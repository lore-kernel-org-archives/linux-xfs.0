Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17413 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbdBORQN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2017 12:16:13 -0500
Date: Wed, 15 Feb 2017 09:16:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: do not unconditionally enable hasalign feature on
 V5 filesystems
Message-ID: <20170215171602.GF6813@birch.djwong.org>
References: <1487174254-9002-1-git-send-email-chandan@linux.vnet.ibm.com>
 <7dd96d6b-ccb5-105f-18aa-207e1c28c625@sandeen.net>
 <20b8b2b4-9586-1300-2591-f90c67a401e3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20b8b2b4-9586-1300-2591-f90c67a401e3@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org

On Wed, Feb 15, 2017 at 11:03:11AM -0600, Eric Sandeen wrote:
> On 2/15/17 10:13 AM, Eric Sandeen wrote:
> >> The root cause of the problem is due to the fact that
> >> xfs_sb_version_hasalign() returns true when we are working on a V5
> >> filesystem. Due to this args.minalignslop (in xfs_ialloc_ag_alloc())
> >> gets the unsigned equivalent of -1 assigned to it. This later causes
> >> alloc_len in xfs_alloc_space_available() to have a value of 0. In such a
> >> scenario when args.total is also 0, the assert statement
> >> "ASSERT(args->maxlen > 0);" fails.
> > Hm, the intent of the _haslign() function is to say that V5 must always
> > imply the "alignbit" - i.e. we don't want to grow an infinite feature
> > matrix, and by the time you get to V5 supers, there are many things which
> > cannot be turned on or off, such as this feature.
> > 
> > So what happens here... xfs_ialloc_ag_alloc does:
> > 
> > args.minalignslop = xfs_ialloc_cluster_alignment(args.mp) - 1;
> > 
> > so you're saying that cluster_alignment comes out as 0?
> > 
> > That function is checking _hasalign:
> > 
> > static inline int
> > xfs_ialloc_cluster_alignment(
> >         struct xfs_mount        *mp)
> > {
> >         if (xfs_sb_version_hasalign(&mp->m_sb) &&
> >             mp->m_sb.sb_inoalignmt >=
> >                         XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
> >                 return mp->m_sb.sb_inoalignmt;
> >         return 1;
> > }
> > 
> > So are you saying that this function returns 0?  That would imply that
> > sb_inoalignmt and m_inode_cluster_size are both zero, yes?  Is this
> > what you see?
> 
> Sorry, I guess that means XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) is
> zero; inode cluster size is 8192 in this case I think, and that is in fact
> 0 filesystem blocks when computed with this macro.
> 
> I need to think about this a little bit to convince myself that the inode
> alignment bit really /should/ be off for a filesystem of this geometry, vs
> changing the macro to recognize the case.

Why isn't that XFS_B_TO_FSBT instead a call to xfs_icluster_size_fsb()?
That function is used elsewhere to compute the number of fsblocks
backing an inode cluster, which seems like what we need here to figure
out whether inoalignmt makes sense w.r.t. the size of an inode cluster.

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
