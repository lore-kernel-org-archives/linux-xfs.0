Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8I6kDXw020362 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 01:46:13 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rn3PE2LKAz6BkwGB for <xfs@oss.sgi.com>;
	Mon, 17 Sep 2012 23:47:23 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TDraY-0006fK-84
	for xfs@oss.sgi.com; Tue, 18 Sep 2012 16:47:18 +1000
Date: Tue, 18 Sep 2012 16:47:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: add xfs_set_inode32()
Message-ID: <20120918064718.GM13691@dastard>
References: <1347900702-23421-1-git-send-email-cmaiolino@redhat.com>
	<1347900702-23421-3-git-send-email-cmaiolino@redhat.com>
	<5057D8AB.6000208@redhat.com>
	<20120918024045.GA14326@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120918024045.GA14326@andromeda.usersys.redhat.com>
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
To: xfs@oss.sgi.com

On Mon, Sep 17, 2012 at 11:40:45PM -0300, Carlos Maiolino wrote:
> On Mon, Sep 17, 2012 at 10:12:59PM -0400, Brian Foster wrote:
> > On 09/17/2012 12:51 PM, Carlos Maiolino wrote:
> > > xfs_set_inode32() can be used to enable inode32 allocation mode. this will
> > > reduce the amount of duplicated code needed to mount/remount a filesystem with
> > > inode32 option.
> > > This patch also enable xfs_set_inode64() to return a xfs_agnumber_t value to
> > > also be used during mount/remount, instead of duplicate code

"This patch also changes xfs_set_inode64() to return the maximum AG
number that inodes can be allocated in so that the behaviour is the
same as xfs_set_inode32(). This simplifies code that calls these
functions and neds to know the maximum AG that inodes can be
allocated in."

....

> > > +	for (index = 0; index < sbp->sb_agcount; index++) {
> > > +		ino = XFS_AGINO_TO_INO(mp, index, agino);
> > > +
> > > +		if (ino > XFS_MAXINUMBER_32) {
> > > +			i++;
> > > +			pag = xfs_perag_get(mp, index);
> > > +			pag->pagi_inodeok = 0;
> > > +			pag->pagf_metadata = 1;
> > 
> > Is it correct to set pagf_metadata here? I'm learning some of this code
> > as I review this so I could be wrong, but it looks like pagf_metadata
> > basically sets a preference on an ag for metadata (e.g., presumably
> > because we are limiting metadata space on a potentially large fs). The
> > existing code looks like it sets pagf_metadata only on AG's below the
> > max_metadata mark...
> > 
> > Brian
> > 
> This AG will be preferred to inode allocation, so, pagf_metadata = 1. And since
> using 32bit inodes we are limited where we can make inode allocations,
> set the first AGs as metadata preferred makes sense to me.
> (but I can be wrong too :)

This discussion is being had because this code addition is in a
different patch that removes the code that it is replacing.  Indeed,
if you look at the code that is being replaced by this function,
it's clear that pag->pagf_metadata is only set on AGs that also have
pag->pagi_inodeok set.

Part of this confusion also comes about because you are intrducing
new functionality inthe same patch you are trying to factor code.
i.e. making more than one change in a single patch.

Hence I think that some restructuring of the patch set needs to be
done so each patch makes one clear change. The first patch is fine,
the second should factor xfs_initialize_perag() to use
xfs_set_inode64()/xfs_set_inode32() without changing any logic,
the third should introduce the inode64->inode32 transition support
into xfs_set_inode32() and the last can stay the same introducing
the remount support for inode32.


> > > +			xfs_perag_put(pag);
> > > +			continue;
> > > +		}
> > > +
> > > +		pag = xfs_perag_get(mp, index);
> > > +		pag->pagi_inodeok = 1;
> > > +		if (index < max_metadata)
> > > +			pag->pagf_metadata = 1;
> > > +
> > > +		xfs_perag_put(pag);
> > > +	}
> > > +
> > > +	index -= i;

And this is pretty clunky. Much better is to introduce a "maxagi"
variable and set it each time through the loop when you set
pag->pagi_inodeok = 1, and return that value. It becomes
immediataely clear what the return parameter of the function is
without needing to document it....

> > > +	mp->m_flags |= (XFS_MOUNT_32BITINODES |
> > > +			XFS_MOUNT_SMALL_INUMS);
> > > +	return index;
> > > +}
> > > +
> > >  STATIC int
> > >  xfs_blkdev_get(
> > >  	xfs_mount_t		*mp,
> > > @@ -1037,30 +1115,6 @@ xfs_restore_resvblks(struct xfs_mount *mp)
> > >  	xfs_reserve_blocks(mp, &resblks, NULL);
> > >  }
> > >  
> > > -STATIC void
> > > -xfs_set_inode64(struct xfs_mount *mp)
> > > -{
> > > -	int i = 0;
> > > -
> > > -	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
> > > -		struct xfs_perag	*pag;
> > > -
> > > -		pag = xfs_perag_get(mp, i);
> > > -		pag->pagi_inodeok = 1;
> > > -		pag->pagf_metadata = 0;
> > > -		xfs_perag_put(pag);
> > > -	}
> > > -
> > > -	/* There is no need for lock protection on m_flags,
> > > -	 * the rw_semaphore of the VFS superblock is locked
> > > -	 * during mount/umount/remount operations, so this is
> > > -	 * enough to avoid concurency on the m_flags field
> > > -	 */
> > > -	mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
> > > -			 XFS_MOUNT_SMALL_INUMS);
> > > -	mp->m_maxagi = i;
> > > -}

There's also a problem of symmetry here - xfs_set_inode64() sets
mp->m_maxagi, which will break growfs logic when it is called by
xfs_initialize_perag() in the next patch. For growfs, mp->m_maxagi
cannot be updated until after all the AG headers are initialised and
written to disk, but to do that we need to have the xfs_perag
headers already initialised. Hence we have to avoid using them by
not updating mp->m_maxagi until after the initialisation is
complete (i.e. after the growfs transaction commits).

This is another reason that factoring should be done in a single
patch without changing logic ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
