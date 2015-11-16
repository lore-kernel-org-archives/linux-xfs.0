Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BEF87CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 07:37:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8CCF1AC002
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 05:37:22 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id qAMjScVHg7XSaNpf (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 05:37:20 -0800 (PST)
Date: Mon, 16 Nov 2015 14:37:14 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 03/11] pmem: enable REQ_FUA/REQ_FLUSH handling
Message-ID: <20151116133714.GB3443@quack.suse.cz>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-4-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4j4arHE+iAALn1WPDzSb_QSCDy8udtXU1FV=kYSZDfv8A@mail.gmail.com>
	<22E0F870-C1FB-431E-BF6C-B395A09A2B0D@dilger.ca>
	<CAPcyv4jwx3VzyRugcpH7KCOKM64kJ4Bq4wgY=iNJMvLTHrBv-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jwx3VzyRugcpH7KCOKM64kJ4Bq4wgY=iNJMvLTHrBv-Q@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri 13-11-15 18:32:40, Dan Williams wrote:
> On Fri, Nov 13, 2015 at 4:43 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> > On Nov 13, 2015, at 5:20 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> >>
> >> On Fri, Nov 13, 2015 at 4:06 PM, Ross Zwisler
> >> <ross.zwisler@linux.intel.com> wrote:
> >>> Currently the PMEM driver doesn't accept REQ_FLUSH or REQ_FUA bios.  These
> >>> are sent down via blkdev_issue_flush() in response to a fsync() or msync()
> >>> and are used by filesystems to order their metadata, among other things.
> >>>
> >>> When we get an msync() or fsync() it is the responsibility of the DAX code
> >>> to flush all dirty pages to media.  The PMEM driver then just has issue a
> >>> wmb_pmem() in response to the REQ_FLUSH to ensure that before we return all
> >>> the flushed data has been durably stored on the media.
> >>>
> >>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> >>
> >> Hmm, I'm not seeing why we need this patch.  If the actual flushing of
> >> the cache is done by the core why does the driver need support
> >> REQ_FLUSH?  Especially since it's just a couple instructions.  REQ_FUA
> >> only makes sense if individual writes can bypass the "drive" cache,
> >> but no I/O submitted to the driver proper is ever cached we always
> >> flush it through to media.
> >
> > If the upper level filesystem gets an error when submitting a flush
> > request, then it assumes the underlying hardware is broken and cannot
> > be as aggressive in IO submission, but instead has to wait for in-flight
> > IO to complete.
> 
> Upper level filesystems won't get errors when the driver does not
> support flush.  Those requests are ended cleanly in
> generic_make_request_checks().  Yes, the fs still needs to wait for
> outstanding I/O to complete but in the case of pmem all I/O is
> synchronous.  There's never anything to await when flushing at the
> pmem driver level.
> 
> > Since FUA/FLUSH is basically a no-op for pmem devices,
> > it doesn't make sense _not_ to support this functionality.
> 
> Seems to be a nop either way.  Given that DAX may lead to dirty data
> pending to the device in the cpu cache that a REQ_FLUSH request will
> not touch, its better to leave it all to the mm core to handle.  I.e.
> it doesn't make sense to call the driver just for two instructions
> (sfence + pcommit) when the mm core is taking on the cache flushing.
> Either handle it all in the mm or the driver, not a mixture.

So I think REQ_FLUSH requests *must* end up doing sfence + pcommit because
e.g. journal writes going through block layer or writes done through
dax_do_io() must be on permanent storage once REQ_FLUSH request finishes
and the way driver does IO doesn't guarantee this, does it?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
