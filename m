Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA94L0uH133580 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 22:21:00 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9404164F14
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 20:22:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	ILdCU71In5nh7NTt for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 20:22:25 -0800 (PST)
Date: Tue, 9 Nov 2010 15:21:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] XFS: handle hole punching via fallocate properly
Message-ID: <20101109042156.GG2715@dastard>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<1289248327-16308-2-git-send-email-josef@redhat.com>
	<20101109012254.GE2715@dastard>
	<20101109020509.GB27816@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109020509.GB27816@dhcp231-156.rdu.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef Bacik <josef@redhat.com>
Cc: xfs@oss.sgi.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, cmm@us.ibm.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Mon, Nov 08, 2010 at 09:05:09PM -0500, Josef Bacik wrote:
> On Tue, Nov 09, 2010 at 12:22:54PM +1100, Dave Chinner wrote:
> > On Mon, Nov 08, 2010 at 03:32:03PM -0500, Josef Bacik wrote:
> > > This patch simply allows XFS to handle the hole punching flag in fallocate
> > > properly.  I've tested this with a little program that does a bunch of random
> > > hole punching with FL_KEEP_SIZE and without it to make sure it does the right
> > > thing.  Thanks,
> > > 
> > > Signed-off-by: Josef Bacik <josef@redhat.com>
> > > ---
> > >  fs/xfs/linux-2.6/xfs_iops.c |   12 +++++++++---
> > >  1 files changed, 9 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> > > index 96107ef..99df347 100644
> > > --- a/fs/xfs/linux-2.6/xfs_iops.c
> > > +++ b/fs/xfs/linux-2.6/xfs_iops.c
> > > @@ -516,6 +516,7 @@ xfs_vn_fallocate(
> > >  	loff_t		new_size = 0;
> > >  	xfs_flock64_t	bf;
> > >  	xfs_inode_t	*ip = XFS_I(inode);
> > > +	int		cmd = XFS_IOC_RESVSP;
> > >  
> > >  	/* preallocation on directories not yet supported */
> > >  	error = -ENODEV;
> > > @@ -528,17 +529,22 @@ xfs_vn_fallocate(
> > >  
> > >  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > >  
> > > +	if (mode & FALLOC_FL_PUNCH_HOLE)
> > > +		cmd = XFS_IOC_UNRESVSP;
> > > +
> > >  	/* check the new inode size is valid before allocating */
> > >  	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> > >  	    offset + len > i_size_read(inode)) {
> > > -		new_size = offset + len;
> > > +		if (cmd == XFS_IOC_UNRESVSP)
> > > +			new_size = offset;
> > > +		else
> > > +			new_size = offset + len;
> > 
> > What semantic is FALLOC_FL_KEEP_SIZE supposed to convey during a
> > hole punch? Doesn't this just turn the hole punch operation into
> > a truncate? If so, what's the point of punching the hole when you
> > can just call ftruncate() to get the same result?
> >
> 
> Well your UNRESVSP can do the same thing as a ftruncate

Actually, it can't because it leaves the file size unchanged.  Like
XFS_IOC_RESVSP, the use case is to allow punching out pre-allocated
blocks beyond EOF (that were put there by XFS_IOC_RESVSP). e.g:

# xfs_io -f \
> -c "truncate 20k" \
> -c "resvsp 16k 16k" \
> -c "unresvsp 24k 4k" \
> -c "bmap -v" \
> -c "stat" \
> test.out
test.out:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..31]:         hole                                    32
   1: [32..47]:        136..151          0 (136..151)          16 10000
   2: [48..55]:        hole                                     8
   3: [56..63]:        160..167          0 (160..167)           8 10000
fd.path = "test.out"
fd.flags = non-sync,non-direct,read-write
stat.ino = 134
stat.type = regular file
stat.size = 20480
stat.blocks = 24
fsxattr.xflags = 0x2 [prealloc]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.nextents = 2
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
#

Which leaves us witha file size of 20k and two unwritten extents
from 16-24k and 28-32k.


> so I figured it was ok
> to just go ahead and use it rather than add complexity, especially since I don't
> understand this crazy fs of yours ;).

Ask, and ye shall receive enlightenment. :)

> > I'd suggest that FALLOC_FL_PUNCH_HOLE should, by definition, not
> > change the file size, and have no option to be able to change it.
> > This needs to be defined and documented - can you include a man
> > page update in this series that defines the expected behaviour
> > of FALLOC_FL_PUNCH_HOLE?
> 
> Oh I see you mean don't allow hole punch to change the size at all.

Exactly. If you can preallocate beyond EOF, then you need to be able
to punch beyond EOF, too. The only other way to remove persistent
preallocation beyond EOF is to truncate, but that doesn't allow you
to only punch specific ranges beyond EOF...

> I was thinking of doing this originally, but like I said above I
> figured that there was no harm in doing the equivalent of an
> ftruncate.  But you are right, theres no sense in duplicating
> functionality, I'll change it to keep PUNCH_HOLE from changin the
> size.  Now I just need to figure out where that man page is...

>From the man page: http://www.kernel.org/doc/man-pages/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
