Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C5F507F66
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 17:06:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B76898F8040
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 15:06:46 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	O8yP5oHGE8PXOcJQ for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 15:06:44 -0700 (PDT)
Date: Tue, 15 Jul 2014 08:06:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Message-ID: <20140714220633.GV4453@dastard>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
	<20140708121500.GA518@infradead.org>
	<001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
	<87ha2jsy6p.fsf@openvz.org> <20140714212539.GH8935@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140714212539.GH8935@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Dmitry Monakhov <dmonakhov@openvz.org>, Namjae Jeon <namjae.jeon@samsung.com>, 'Christoph Hellwig' <hch@infradead.org>, 'linux-ext4' <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 'Luk?? Czerner' <lczerner@redhat.com>, 'Brian Foster' <bfoster@redhat.com>, 'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com

On Mon, Jul 14, 2014 at 05:25:39PM -0400, Theodore Ts'o wrote:
> On Mon, Jul 14, 2014 at 08:27:26PM +0400, Dmitry Monakhov wrote:
> > Actually they are differ. EXT4_IOC_MOVE_EXT copy data inside kernel,
> > but XFS_IOC_SWAPEXT live this job to userpsace see:
> > http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=fsr/xfs_fsr.c packfile
> > And I'll vote to make EXT4_IOC_MOVE_EXT deprecated, and implement EXT4_IOC_SWAPEXT
> > as XFS does that.
> > Ted, Lukas what do you think about that?
> 
> The reason why EXT4_IOC_MOVE_EXT moves the data via the cache is to
> avoid being subject to races if the file happens to mmap'ed and being
> actively modified at the time of the defrag operation.  
> 
> I'm not sure how XFS handles that case, but if it's not somehow
> locking the file against mmap's before it starts the userspace copy,
> it would seem to me to be fairly dangerous in terms of prevent
> potential data loss in this scenario.  Unless they are doing some
> especially clever?

Yes, we're being clever:

	a) we can snapshot the inode directly with bulkstat and then
	feed that as a cookie back into the swap extent ioctl, hence
	detect any change made to the inode since the snapshot was
	taken; 

	b) we do invisible IO to copy the data (i.e. doesn't update
	timestamps on the files); and

	c) the swap ext ioctl aborts if the file is mmapped() at the
	time we do the extent swap.

Basically, if there is any inconsistency or trouble, we abort the
swap without doing anything and leave userspace to clean up.

As it is, we'll be looking to replace the swapext call with this new
move ioctl because we can do a lot more with it and avoids
implementation wrinkles like having to check and handle different
sized data and inode forks, and having to change the owner field in
every bmap btree block after the swap has occurred.

FWIW, what we ideally need for these sorts of defrag programs is
per-file freezing. i.e. we freeze the file to be defragged, then do
the copy in userspace, swap/move the copied range and then unfreeze
it once complete.  That guarantees that the file is not modified in
any way while userspace is doing the defrag...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
