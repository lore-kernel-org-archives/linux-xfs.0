Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 72C0A7CA3
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 13:34:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6513AC004
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 11:34:25 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id FBCZstwGZjYDYB7N (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 11:34:20 -0700 (PDT)
Date: Mon, 21 Mar 2016 14:34:14 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] xfs: updates for 4.6-rc1
Message-ID: <20160321183414.GB3490@thunk.org>
References: <20160321020505.GJ11812@dastard>
	<20160321091628.GE30819@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160321091628.GE30819@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Thanks Jan, for checking the merge.

I didn't realize the ext4 fixups were going in via the xfs tree.  I
didn't see any merge conflicts from the linux-next tree (or maybe I
missed it) so I had assumed it wasn't in Dave's xfs.git tree.  My plan
had been to deal with it after the prereq patch went in via the xfs
tree --- in fact I was thinking about checking to see if the xfs.git
tree had been merged so I could get the ext4 commit merged and sent to
Linus.

Sorry I lost track of things.  If I had known I would have indeed
manually merged in the branch, resolved the merge, and done a
regression test cycle before pushing to Linus.

						- Ted
						
On Mon, Mar 21, 2016 at 10:16:28AM +0100, Jan Kara wrote:
> On Mon 21-03-16 13:05:05, Dave Chinner wrote:
> The resolution of conflict in fs/ext4/inode.c is fine except for one minor
> issue:
> 
> > diff --cc fs/ext4/inode.c
> > index b2e9576,2b98171..e5ba3b0
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@@ -3289,10 -3161,10 +3289,10 @@@ out
> >   }
> >   #endif
> >   
> > - static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> > + static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> >   			    ssize_t size, void *private)
> >   {
> >  -        ext4_io_end_t *io_end = iocb->private;
> >  +        ext4_io_end_t *io_end = private;
> >   
> >   	/* if not async direct IO just return */
> >   	if (!io_end)
> > @@@ -3300,8 -3172,18 +3300,17 @@@
> >   
> >   	ext_debug("ext4_end_io_dio(): io_end 0x%p "
> >   		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
> >  - 		  iocb->private, io_end->inode->i_ino, iocb, offset,
> >  -		  size);
> >  +		  io_end, io_end->inode->i_ino, iocb, offset, size);
> >   
> > + 	iocb->private = NULL;
> 
> The line above should not exist in the result. It does no harm but is
> unnecessary.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
