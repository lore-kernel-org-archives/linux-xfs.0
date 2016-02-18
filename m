Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 36B117F54
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 06:08:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 276E98F8035
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 04:08:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Mujkn9Zk0S4M3Bn4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2016 04:08:15 -0800 (PST)
Date: Thu, 18 Feb 2016 07:08:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix up inode32/64 (re)mount handling
Message-ID: <20160218120811.GA16962@bfoster.bfoster>
References: <56C3FB75.6030104@redhat.com>
	<20160217183025.GB4065@bfoster.bfoster>
	<56C55ABE.4050100@sandeen.net> <56C55BF3.3080709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C55BF3.3080709@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Feb 17, 2016 at 11:51:47PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/17/16 11:46 PM, Eric Sandeen wrote:
> > On 2/17/16 12:30 PM, Brian Foster wrote:
> >> On Tue, Feb 16, 2016 at 10:47:49PM -0600, Eric Sandeen wrote:
> >>> inode32/inode64 allocator behavior with respect to mount,
> >>> remount and growfs is a little tricky.
> >>>
> >>> The inode32 mount option should only enable the inode32
> >>> allocator heuristics if the filesystem is large enough
> >>> for 64-bit inodes to exist.  Today, it has this behavior
> >>> on the initial mount, but a remount with inode32
> >>> unconditionally changes the allocation heuristics, even
> >>> for a small fs.
> >>>
> >>> Also, an inode32 mounted small filesystem should transition
> >>> to the inode32 allocator if the filesystem is subsequently
> >>> grown to a sufficient size.  Today that does not happen.
> >>>
> >>> This patch consolidates xfs_set_inode32 and xfs_set_inode64
> >>> into a single new function, and moves the "is the maximum inode
> >>> number big enough to matter" test into that function, so
> >>> it doesn't rely on the caller to get it right - which
> >>> remount did not do, previously.
> >>>
> >>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>> ---
> >>>
> >>> Note, this goes after my token-parsing patch for mount.
> > 
> > ...
> > 
> >>> @@ -607,54 +619,48 @@ xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
> >>>  		max_metadata = agcount;
> >>>  	}
> >>>  
> >>> +	/* Get the last possible inode in the filesystem */
> >>>  	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
> >>> +	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
> >>> +
> >>> +	/*
> >>> +	 * If user asked for no more than 32-bit inodes, and the fs is
> >>> +	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
> >>> +	 * the allocator to accommodate the request.
> >>> +	 */
> >>> +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
> >>> +		mp->m_flags |= XFS_MOUNT_32BITINODES;
> >>> +	else
> >>> +		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> >>
> >> In the current code, we call into xfs_set_inode64() if
> >> XFS_MOUNT_SMALL_INUMS is not set or it is, but the largest inode is
> >> within XFS_MAXINUMBER_32. In that latter case, xfs_set_inode64() does:
> >>
> >>         mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
> >>                          XFS_MOUNT_SMALL_INUMS);
> >>
> >> ... which I think means we want to clear XFS_MOUNT_SMALL_INUMS along
> >> with XFS_MOUNT_32BITINODES here, yes? The rest looks fine to me:
> > 
> > I don't think so; that was a bug, AFAICT.
> > 
> > XFS_MOUNT_32BITINODES means that inode32 was specified at mount
> 
> Ugh; I had that backwards.  
> 
> *XFS_MOUNT_SMALL_INUMS* means that inode32 was specified at mount time.
> For the reasons I stated, *that* flag should never be cleared.  It
> signifies a specified mount option, which does not go away just because
> the filesystem is currently small.
> 
> Maybe we need clearer flag names :/
> 

Ah, I missed that part. Sounds good, thanks for the explanation! (And
yes, the flag names are not clear.. ;P)

Brian

> -Eric
> 
> > time, i.e. the user wants no more than 32-bit inodes for the
> > duration of this mount.
> >  
> > So this is actually a bugfix for the 2nd item mentioned above:
> > 
> >>> Also, an inode32 mounted small filesystem should transition
> >>> to the inode32 allocator if the filesystem is subsequently
> >>> grown to a sufficient size.  Today that does not happen.
> > 
> >> Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > Thanks,
> > -Eric
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
