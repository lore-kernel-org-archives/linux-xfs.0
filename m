Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4K15g2d063306 for <xfs@oss.sgi.com>; Thu, 19 May 2011 20:05:42 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13C6ACEBD03
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 18:05:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	afJOHBM1v3tKBKRR for <xfs@oss.sgi.com>;
	Thu, 19 May 2011 18:05:40 -0700 (PDT)
Date: Fri, 20 May 2011 11:05:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel bug when running xfs_fsr
Message-ID: <20110520010538.GN32466@dastard>
References: <BANLkTi=YSBY5Zq5ePCLZ2mLY70YEw=Yv7w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTi=YSBY5Zq5ePCLZ2mLY70YEw=Yv7w@mail.gmail.com>
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
To: karn@ka9q.net
Cc: xfs@oss.sgi.com

On Thu, May 19, 2011 at 03:35:04PM -0700, Phil Karn wrote:
> I just got the following on my console each time I invoked xfs_fsr on a XFS
> file system. The file system resides on a OCZ SSD that I've been having
> problems with. This morning my system deadlocked while running a program
> that created and deleted many small files on the SSD (a Perl script feeding
> a large number of email messages one at a time to procmail). I suspect bad
> garbage collection algorithms in the SSD; I recovered by booting into single
> user and running wiper.sh on the file system to replenish the drive's pool
> of erased pages. Since then I've been running wiper.sh regularly to ensure a
> sufficient erased page pool in the SSD. I had just run it when I ran
> xfs_fsr.
> 
> So it's possible that my file system data structures are messed up. However,
> the system otherwise seems normal, and I've been routinely tagging my files
> with extended attributes containing their SHA-1 hashes so I can check their
> integrity. So far my checks haven't found any corrupted files.
> 
> Here is the relevant output from my kernel log. Is this a XFS bug, or does
> it simply indicate a corrupted file system due to my earlier crash?
> 
> [29847.045684] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000018

Dereferencing an offset of 24 bytes from the start of a structure.

> [29847.045690] IP: [<ffffffffa033c11b>] xfs_trans_log_inode+0xb/0x30 [xfs]

Three structures possible: xfs_inode, xfs_trans, xfs_inode_log_item:

138 xfs_trans_log_inode(
139         xfs_trans_t     *tp,
140         xfs_inode_t     *ip,
141         uint            flags)
142 {
143         ASSERT(ip->i_transp == tp);
144         ASSERT(ip->i_itemp != NULL);
145         ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
146
147         tp->t_flags |= XFS_TRANS_DIRTY;
148         ip->i_itemp->ili_item.li_desc->lid_flags |= XFS_LID_DIRTY;

And the situation is that ip->i_itemp->ili_item.li_desc == NULL:

typedef struct xfs_log_item {
        struct list_head                li_ail;         /* AIL pointers */
        xfs_lsn_t                       li_lsn;         /* last on-disk lsn */
        struct xfs_log_item_desc        *li_desc;       /* ptr to current desc*/
.....

That should not happen - the inode should be linked into the
transaction (tp), and li_desc should never be NULL here.

Are you running with CONFIG_XFS_DEBUG=y? If not, it is probably
worthwhile as it should catch the problems more precisely before
a NULL pointer dereference occurs.

> and so on...it repeats a few times because I issued the xfs_fsr command a
> few times.

So it is reproducable? Can you turn on the xfs_swapext tracepoints
and gather the output over a failure, as well as using xfs_fsr -v -d
and capturing that output? That might indicate that there is a
specific inode extent swap configuration that triggers this problem
that I haven't realised exists.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
