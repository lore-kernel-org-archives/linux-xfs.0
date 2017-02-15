Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34316 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbdBOWxZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 17:53:25 -0500
Subject: Re: [PATCH] xfs: do not unconditionally enable hasalign feature on V5
 filesystems
References: <1487174254-9002-1-git-send-email-chandan@linux.vnet.ibm.com>
 <7dd96d6b-ccb5-105f-18aa-207e1c28c625@sandeen.net>
 <20b8b2b4-9586-1300-2591-f90c67a401e3@sandeen.net>
 <20170215171602.GF6813@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <614e457a-fdf5-5741-a8cd-f161660acc9f@sandeen.net>
Date: Wed, 15 Feb 2017 16:53:22 -0600
MIME-Version: 1.0
In-Reply-To: <20170215171602.GF6813@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org

On 2/15/17 11:16 AM, Darrick J. Wong wrote:
> On Wed, Feb 15, 2017 at 11:03:11AM -0600, Eric Sandeen wrote:
>> On 2/15/17 10:13 AM, Eric Sandeen wrote:

...

>> Sorry, I guess that means XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) is
>> zero; inode cluster size is 8192 in this case I think, and that is in fact
>> 0 filesystem blocks when computed with this macro.
>>
>> I need to think about this a little bit to convince myself that the inode
>> alignment bit really /should/ be off for a filesystem of this geometry, vs
>> changing the macro to recognize the case.
> 
> Why isn't that XFS_B_TO_FSBT instead a call to xfs_icluster_size_fsb()?
> That function is used elsewhere to compute the number of fsblocks
> backing an inode cluster, which seems like what we need here to figure
> out whether inoalignmt makes sense w.r.t. the size of an inode cluster.

Hm, I think this needs some care.  There are several places that use
XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size), see xfs_ialloc_cluster_alignment()
for example, and the sparse inode check in mount code:

        if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
            mp->m_sb.sb_spino_align !=
                        XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) {
                xfs_warn(mp,
        "Sparse inode block alignment (%u) must match cluster size (%llu).",
                         mp->m_sb.sb_spino_align,
                         XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size));
                error = -EINVAL;
                goto out_remove_uuid;
        }

This probably fails in your usecase as well, no?

-Eric


> --D
> 
>>
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
