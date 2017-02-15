Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751505AbdBOSBL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2017 13:01:11 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1FI0QpM024037
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2017 13:01:10 -0500
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28mswswk7g-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2017 13:01:10 -0500
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 16 Feb 2017 04:01:07 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
        by d23dlp02.au.ibm.com (Postfix) with ESMTP id 22B2E2BB0059
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 05:01:06 +1100 (EST)
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v1FI0wRq37814504
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 05:01:06 +1100
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
        by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v1FI0XMm000887
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 05:00:33 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfs: do not unconditionally enable hasalign feature on V5 filesystems
Date: Wed, 15 Feb 2017 23:30:15 +0530
In-Reply-To: <20170215171602.GF6813@birch.djwong.org>
References: <1487174254-9002-1-git-send-email-chandan@linux.vnet.ibm.com> <20b8b2b4-9586-1300-2591-f90c67a401e3@sandeen.net> <20170215171602.GF6813@birch.djwong.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2186946.HDXjeWPhd5@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Wednesday, February 15, 2017 09:16:02 AM Darrick J. Wong wrote:
> On Wed, Feb 15, 2017 at 11:03:11AM -0600, Eric Sandeen wrote:
> > On 2/15/17 10:13 AM, Eric Sandeen wrote:
> > >> The root cause of the problem is due to the fact that
> > >> xfs_sb_version_hasalign() returns true when we are working on a V5
> > >> filesystem. Due to this args.minalignslop (in xfs_ialloc_ag_alloc())
> > >> gets the unsigned equivalent of -1 assigned to it. This later causes
> > >> alloc_len in xfs_alloc_space_available() to have a value of 0. In such a
> > >> scenario when args.total is also 0, the assert statement
> > >> "ASSERT(args->maxlen > 0);" fails.
> > > Hm, the intent of the _haslign() function is to say that V5 must always
> > > imply the "alignbit" - i.e. we don't want to grow an infinite feature
> > > matrix, and by the time you get to V5 supers, there are many things which
> > > cannot be turned on or off, such as this feature.
> > > 
> > > So what happens here... xfs_ialloc_ag_alloc does:
> > > 
> > > args.minalignslop = xfs_ialloc_cluster_alignment(args.mp) - 1;
> > > 
> > > so you're saying that cluster_alignment comes out as 0?
> > > 
> > > That function is checking _hasalign:
> > > 
> > > static inline int
> > > xfs_ialloc_cluster_alignment(
> > >         struct xfs_mount        *mp)
> > > {
> > >         if (xfs_sb_version_hasalign(&mp->m_sb) &&
> > >             mp->m_sb.sb_inoalignmt >=
> > >                         XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
> > >                 return mp->m_sb.sb_inoalignmt;
> > >         return 1;
> > > }
> > > 
> > > So are you saying that this function returns 0?  That would imply that
> > > sb_inoalignmt and m_inode_cluster_size are both zero, yes?  Is this
> > > what you see?
> > 
> > Sorry, I guess that means XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) is
> > zero; inode cluster size is 8192 in this case I think, and that is in fact
> > 0 filesystem blocks when computed with this macro.
> > 
> > I need to think about this a little bit to convince myself that the inode
> > alignment bit really /should/ be off for a filesystem of this geometry, vs
> > changing the macro to recognize the case.
> 
> Why isn't that XFS_B_TO_FSBT instead a call to xfs_icluster_size_fsb()?
> That function is used elsewhere to compute the number of fsblocks
> backing an inode cluster, which seems like what we need here to figure
> out whether inoalignmt makes sense w.r.t. the size of an inode cluster.
>

Thanks for the suggestion. Looks like xfs_icluster_size_fsb() is the right
function to use. I will test the fix and let you know the results.

-- 
chandan

