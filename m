Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58954 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbdBORDM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 12:03:12 -0500
Subject: Re: [PATCH] xfs: do not unconditionally enable hasalign feature on V5
 filesystems
References: <1487174254-9002-1-git-send-email-chandan@linux.vnet.ibm.com>
 <7dd96d6b-ccb5-105f-18aa-207e1c28c625@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <20b8b2b4-9586-1300-2591-f90c67a401e3@sandeen.net>
Date: Wed, 15 Feb 2017 11:03:11 -0600
MIME-Version: 1.0
In-Reply-To: <7dd96d6b-ccb5-105f-18aa-207e1c28c625@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

On 2/15/17 10:13 AM, Eric Sandeen wrote:
>> The root cause of the problem is due to the fact that
>> xfs_sb_version_hasalign() returns true when we are working on a V5
>> filesystem. Due to this args.minalignslop (in xfs_ialloc_ag_alloc())
>> gets the unsigned equivalent of -1 assigned to it. This later causes
>> alloc_len in xfs_alloc_space_available() to have a value of 0. In such a
>> scenario when args.total is also 0, the assert statement
>> "ASSERT(args->maxlen > 0);" fails.
> Hm, the intent of the _haslign() function is to say that V5 must always
> imply the "alignbit" - i.e. we don't want to grow an infinite feature
> matrix, and by the time you get to V5 supers, there are many things which
> cannot be turned on or off, such as this feature.
> 
> So what happens here... xfs_ialloc_ag_alloc does:
> 
> args.minalignslop = xfs_ialloc_cluster_alignment(args.mp) - 1;
> 
> so you're saying that cluster_alignment comes out as 0?
> 
> That function is checking _hasalign:
> 
> static inline int
> xfs_ialloc_cluster_alignment(
>         struct xfs_mount        *mp)
> {
>         if (xfs_sb_version_hasalign(&mp->m_sb) &&
>             mp->m_sb.sb_inoalignmt >=
>                         XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
>                 return mp->m_sb.sb_inoalignmt;
>         return 1;
> }
> 
> So are you saying that this function returns 0?  That would imply that
> sb_inoalignmt and m_inode_cluster_size are both zero, yes?  Is this
> what you see?

Sorry, I guess that means XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) is
zero; inode cluster size is 8192 in this case I think, and that is in fact
0 filesystem blocks when computed with this macro.

I need to think about this a little bit to convince myself that the inode
alignment bit really /should/ be off for a filesystem of this geometry, vs
changing the macro to recognize the case.

-Eric
