Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE3767F3F
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 16:16:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 603C8AC003
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 14:16:10 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id ugaJiVoZOm6qDhj2 for
	<xfs@oss.sgi.com>; Thu, 07 Jan 2016 14:16:08 -0800 (PST)
Date: Thu, 7 Jan 2016 15:16:06 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v7 1/9] dax: fix NULL pointer dereference in __dax_dbg()
Message-ID: <20160107221606.GB20802@linux.intel.com>
References: <1452103263-1592-1-git-send-email-ross.zwisler@linux.intel.com>
	<1452103263-1592-2-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4h3NcXHHQAWL=HwgGxTbFTeOa98S9fxWu7dA3nTEcFxxA@mail.gmail.com>
	<20160107093402.GA8380@quack.suse.cz>
	<CAPcyv4i_xfihzc_LKYiz_XuTVVCMSf5dsJQE8g7-NURe170p7g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i_xfihzc_LKYiz_XuTVVCMSf5dsJQE8g7-NURe170p7g@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Thu, Jan 07, 2016 at 07:17:22AM -0800, Dan Williams wrote:
> On Thu, Jan 7, 2016 at 1:34 AM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 06-01-16 11:14:09, Dan Williams wrote:
> >> On Wed, Jan 6, 2016 at 10:00 AM, Ross Zwisler
> >> <ross.zwisler@linux.intel.com> wrote:
> >> > __dax_dbg() currently assumes that bh->b_bdev is non-NULL, passing it into
> >> > bdevname() where is is dereferenced.  This assumption isn't always true -
> >> > when called for reads of holes, ext4_dax_mmap_get_block() returns a buffer
> >> > head where bh->b_bdev is never set.  I hit this BUG while testing the DAX
> >> > PMD fault path.
> >> >
> >> > Instead, verify that we have a valid bh->b_bdev, else just say "unknown"
> >> > for the block device.
> >> >
> >> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> >> > Cc: Dan Williams <dan.j.williams@intel.com>
> >> > ---
> >> >  fs/dax.c | 7 ++++++-
> >> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/fs/dax.c b/fs/dax.c
> >> > index 7af8797..03cc4a3 100644
> >> > --- a/fs/dax.c
> >> > +++ b/fs/dax.c
> >> > @@ -563,7 +563,12 @@ static void __dax_dbg(struct buffer_head *bh, unsigned long address,
> >> >  {
> >> >         if (bh) {
> >> >                 char bname[BDEVNAME_SIZE];
> >> > -               bdevname(bh->b_bdev, bname);
> >> > +
> >> > +               if (bh->b_bdev)
> >> > +                       bdevname(bh->b_bdev, bname);
> >> > +               else
> >> > +                       snprintf(bname, BDEVNAME_SIZE, "unknown");
> >> > +
> >> >                 pr_debug("%s: %s addr: %lx dev %s state %lx start %lld "
> >> >                         "length %zd fallback: %s\n", fn, current->comm,
> >> >                         address, bname, bh->b_state, (u64)bh->b_blocknr,
> >>
> >> I'm assuming there's no danger of a such a buffer_head ever being used
> >> for the bdev parameter to dax_map_atomic()?  Shouldn't we also/instead
> >> go fix ext4 to not send partially filled buffer_heads?
> >
> > No. The real problem is a long-standing abuse of struct buffer_head to be
> > used for passing block mapping information (it's on my todo list to remove
> > that at least from DAX code and use cleaner block mapping interface but
> > first I want basic DAX functionality to settle down to avoid unnecessary
> > conflicts). Filesystem is not supposed to touch bh->b_bdev. If you need
> > that filled in, set it yourself in before passing bh to the block mapping
> > function.
> >
> 
> Ok, makes sense.
> 
> Ross, can you fix this instead by unconditionally looking up the bdev
> rather that saying "unknown".  The bdev should always be retrievable.

Sure, will do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
