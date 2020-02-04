Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531E1C3524A
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26BCA20674
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgBDGP4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgBDGP4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Feb 2020 01:15:56 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206399] [xfstests xfs/433] BUG: KASAN: use-after-free in
 xfs_attr3_node_inactive+0x6c8/0x7b0 [xfs]
Date:   Tue, 04 Feb 2020 06:15:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206399-201763-Ylp4isxuG8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206399-201763@https.bugzilla.kernel.org/>
References: <bug-206399-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206399

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
# ./scripts/faddr2line fs/xfs/xfs.ko xfs_attr3_node_inactive+0x61e
xfs_attr3_node_inactive+0x61e/0x8a0:
xfs_attr3_node_inactive at
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/xfs/xfs_attr_inactive.c:214

# cat fs/xfs/xfs_attr_inactive.c
...
    129 STATIC int
    130 xfs_attr3_node_inactive(
    131         struct xfs_trans        **trans,
    132         struct xfs_inode        *dp,
    133         struct xfs_buf          *bp,
    134         int                     level)
    135 {
    136         struct xfs_mount        *mp = dp->i_mount;
    137         struct xfs_da_blkinfo   *info;
    138         xfs_dablk_t             child_fsb;
    139         xfs_daddr_t             parent_blkno, child_blkno;
    140         struct xfs_buf          *child_bp;
    141         struct xfs_da3_icnode_hdr ichdr;
    142         int                     error, i;
    143 
    144         /*
    145          * Since this code is recursive (gasp!) we must protect
ourselves.
    146          */
    147         if (level > XFS_DA_NODE_MAXDEPTH) {
    148                 xfs_trans_brelse(*trans, bp);   /* no locks for later
trans */
    149                 xfs_buf_corruption_error(bp);
    150                 return -EFSCORRUPTED;
    151         }
    152 
    153         xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, bp->b_addr);
    154         parent_blkno = bp->b_bn;
    155         if (!ichdr.count) {
    156                 xfs_trans_brelse(*trans, bp);
    157                 return 0;
    158         }
    159         child_fsb = be32_to_cpu(ichdr.btree[0].before);
    160         xfs_trans_brelse(*trans, bp);   /* no locks for later trans */
    161 
    162         /*
    163          * If this is the node level just above the leaves, simply loop
    164          * over the leaves removing all of them.  If this is higher up
    165          * in the tree, recurse downward.
    166          */
    167         for (i = 0; i < ichdr.count; i++) {
    168                 /*
    169                  * Read the subsidiary block to see what we have to
work with.
    170                  * Don't do this in a transaction.  This is a
depth-first
    171                  * traversal of the tree so we may deal with many
blocks
    172                  * before we come back to this one.
    173                  */
    174                 error = xfs_da3_node_read(*trans, dp, child_fsb,
&child_bp,
    175                                           XFS_ATTR_FORK);
    176                 if (error)
    177                         return error;
    178 
    179                 /* save for re-read later */
    180                 child_blkno = XFS_BUF_ADDR(child_bp);
    181 
    182                 /*
    183                  * Invalidate the subtree, however we have to.
    184                  */
    185                 info = child_bp->b_addr;
    186                 switch (info->magic) {
    187                 case cpu_to_be16(XFS_DA_NODE_MAGIC):
    188                 case cpu_to_be16(XFS_DA3_NODE_MAGIC):
    189                         error = xfs_attr3_node_inactive(trans, dp,
child_bp,
    190                                                         level + 1);
    191                         break;
    192                 case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
    193                 case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
    194                         error = xfs_attr3_leaf_inactive(trans, dp,
child_bp);
    195                         break;
    196                 default:
    197                         xfs_buf_corruption_error(child_bp);
    198                         xfs_trans_brelse(*trans, child_bp);
    199                         error = -EFSCORRUPTED;
    200                         break;
    201                 }
    202                 if (error)
    203                         return error;
    204 
    205                 /*
    206                  * Remove the subsidiary block from the cache and from
the log.
    207                  */
    208                 error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
    209                                 child_blkno,
    210                                 XFS_FSB_TO_BB(mp,
mp->m_attr_geo->fsbcount), 0,
    211                                 &child_bp);
    212                 if (error)
    213                         return error;
--> 214                 error = bp->b_error;
    215                 if (error) {
    216                         xfs_trans_brelse(*trans, child_bp);
    217                         return error;
    218                 }
    219                 xfs_trans_binval(*trans, child_bp);
    220 
    221                 /*
    222                  * If we're not done, re-read the parent to get the
next
    223                  * child block number.
    224                  */
    225                 if (i + 1 < ichdr.count) {
    226                         struct xfs_da3_icnode_hdr phdr;
    227 
    228                         error = xfs_da3_node_read_mapped(*trans, dp,
    229                                         parent_blkno, &bp,
XFS_ATTR_FORK);
    230                         if (error)
    231                                 return error;
    232                         xfs_da3_node_hdr_from_disk(dp->i_mount, &phdr,
    233                                                   bp->b_addr);
    234                         child_fsb = be32_to_cpu(phdr.btree[i +
1].before);
    235                         xfs_trans_brelse(*trans, bp);
    236                 }
    237                 /*
    238                  * Atomically commit the whole invalidate stuff.
    239                  */
    240                 error = xfs_trans_roll_inode(trans, dp);
    241                 if (error)
    242                         return  error;
    243         }
    244 
    245         return 0;
    246 }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
