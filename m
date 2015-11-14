Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32E377F5A
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 18:20:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 112298F80A1
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 16:20:42 -0800 (PST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id 5WeMclriDTWcAPpX
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Nov 2015 16:20:40 -0800 (PST)
Received: by wmec201 with SMTP id c201so51920558wme.1
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 16:20:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1447459610-14259-4-git-send-email-ross.zwisler@linux.intel.com>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-4-git-send-email-ross.zwisler@linux.intel.com>
Date: Fri, 13 Nov 2015 16:20:39 -0800
Message-ID: <CAPcyv4j4arHE+iAALn1WPDzSb_QSCDy8udtXU1FV=kYSZDfv8A@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] pmem: enable REQ_FUA/REQ_FLUSH handling
From: Dan Williams <dan.j.williams@intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: X86 ML <x86@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Nov 13, 2015 at 4:06 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Currently the PMEM driver doesn't accept REQ_FLUSH or REQ_FUA bios.  These
> are sent down via blkdev_issue_flush() in response to a fsync() or msync()
> and are used by filesystems to order their metadata, among other things.
>
> When we get an msync() or fsync() it is the responsibility of the DAX code
> to flush all dirty pages to media.  The PMEM driver then just has issue a
> wmb_pmem() in response to the REQ_FLUSH to ensure that before we return all
> the flushed data has been durably stored on the media.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Hmm, I'm not seeing why we need this patch.  If the actual flushing of
the cache is done by the core why does the driver need support
REQ_FLUSH?  Especially since it's just a couple instructions.  REQ_FUA
only makes sense if individual writes can bypass the "drive" cache,
but no I/O submitted to the driver proper is ever cached we always
flush it through to media.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
