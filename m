Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47011 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752161AbdBORhi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2017 12:37:38 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1FHXmVr058756
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2017 12:37:38 -0500
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28mq9gcsk5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2017 12:37:37 -0500
Received: from localhost
        by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 16 Feb 2017 03:37:35 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id B95913578057
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 04:37:32 +1100 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v1FHbON027656276
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 04:37:32 +1100
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
        by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v1FHb01J016503
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 04:37:00 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfs: do not unconditionally enable hasalign feature on V5 filesystems
Date: Wed, 15 Feb 2017 23:06:41 +0530
In-Reply-To: <20b8b2b4-9586-1300-2591-f90c67a401e3@sandeen.net>
References: <1487174254-9002-1-git-send-email-chandan@linux.vnet.ibm.com> <7dd96d6b-ccb5-105f-18aa-207e1c28c625@sandeen.net> <20b8b2b4-9586-1300-2591-f90c67a401e3@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3208255.yebvhpfuCU@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wednesday, February 15, 2017 11:03:11 AM Eric Sandeen wrote:
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

Yes, sb_inoalignmt is indeed 0 because of the following code from
main() in xfsprogs/mkfs/xfs_mkfs.c,

	if (sb_feat.inode_align) {
		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
		if (sb_feat.crcs_enabled)
			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
		sbp->sb_inoalignmt = cluster_size >> blocklog;
		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
	}

And XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) returns 0 as well. Hence the
condition (xfs_sb_version_hasalign(&mp->m_sb) && mp->m_sb.sb_inoalignmt >=
XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) evaluates to true.

> 
> I need to think about this a little bit to convince myself that the inode
> alignment bit really /should/ be off for a filesystem of this geometry, vs
> changing the macro to recognize the case.
> 
> -Eric
> 

-- 
chandan

