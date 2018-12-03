Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:45521 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbeLCXzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 18:55:22 -0500
Date: Tue, 4 Dec 2018 10:55:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] vfs: use inode_permission in copy_file_range()
Message-ID: <20181203235517.GN6311@dastard>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-6-david@fromorbit.com>
 <20181203181803.GX8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203181803.GX8125@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 03, 2018 at 10:18:03AM -0800, Darrick J. Wong wrote:
> On Mon, Dec 03, 2018 at 07:34:10PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Similar to FI_DEDUPERANGE, make copy_file_range() check that we have
> 
> TLDR: No, it's not similar to FIDEDUPERANGE -- the use of
> inode_permission() in allow_file_dedupe() is to enable callers to dedupe
> into a file for which the caller has write permissions but opened the
> file O_RDONLY.

What a grotty, nasty hack.

> [Please keep reading...]
> 
> > write permissions to the destination inode.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  mm/filemap.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 0a170425935b..876df5275514 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3013,6 +3013,11 @@ int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
> >  	    (file_out->f_flags & O_APPEND))
> >  		return -EBADF;
> >  
> > +	/* may sure we really are allowed to write to the destination inode */
> > +	ret = inode_permission(inode_out, MAY_WRITE);
> 
> What's the difference between security_file_permission and
> inode_permission, and when do we call them for a regular
> open-write-close sequence?  Hmmm, let me take a look:
.....
> We also cannot dedupe into a file that becomes immutable after we open
> it for write, but we can dedupe into a file that loses its write
> permissions after we open it.

It's more nuanced than that - dedupe will proceed after write
permissions have been removed only if you are root or own the file,
otherwise it will fail.

Updated summary:

> op:		after +immutable?	after chmod a-w?
> write		yes			yes
> clonerange	no			yes
> dedupe	no			maybe
> newcopyrange	no			no
>
> My reaction: I don't think that writes should be allowed after an
> administrator marks a file immutable (but that's a separate issue) but I
> do think we should be consistent in allowing copying into a file that
> has lost its write permissions after we opened the file for write, like
> we do for write() and the remap ioct....

If we want to allow copying to files we don't actually have
permission to write to anymore, then I'll remove this from the test,
the man page and the code. But, quite frankly, I don't trust remote
server side copies to follow the same permission models as the
client side OS, so I think we have to treat copy_file_range
differently to a normal write syscall....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
