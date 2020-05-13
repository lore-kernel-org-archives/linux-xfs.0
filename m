Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A4ACA90AF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 12:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D233B206D6
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 12:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbgEMMQl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 08:16:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731675AbgEMMQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 08:16:41 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DC4Lds144586;
        Wed, 13 May 2020 08:16:33 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310175a11n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 08:16:32 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04DC4Kpj144347;
        Wed, 13 May 2020 08:16:32 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310175a10w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 08:16:32 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04DCFVvs026276;
        Wed, 13 May 2020 12:16:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3100uc0ky3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 12:16:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04DCGSnl66191780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 12:16:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0587CA405B;
        Wed, 13 May 2020 12:16:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A576BA4054;
        Wed, 13 May 2020 12:16:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.87.1])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 May 2020 12:16:26 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Date:   Wed, 13 May 2020 17:49:29 +0530
Message-ID: <1989896.HOZoU1XjBG@localhost.localdomain>
Organization: IBM
In-Reply-To: <20200512235322.GT6714@magnolia>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <1605922.TduNPZZDZ2@localhost.localdomain> <20200512235322.GT6714@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_04:2020-05-11,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 cotscore=-2147483648 clxscore=1015 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130110
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, May 13, 2020 5:23 AM Darrick J. Wong wrote: 
> On Fri, May 01, 2020 at 12:38:30PM +0530, Chandan Rajendra wrote:
> > On Wednesday, April 29, 2020 9:05 PM Chandan Rajendra wrote: 
> > > On Monday, April 27, 2020 3:38 AM Dave Chinner wrote: 
> > > > On Sat, Apr 25, 2020 at 05:37:39PM +0530, Chandan Rajendra wrote:
> > > > > On Thursday, April 23, 2020 4:00 AM Dave Chinner wrote: 
> > > > > > On Wed, Apr 22, 2020 at 03:08:00PM +0530, Chandan Rajendra wrote:
> > > > > > > Attr bmbt tree height (MINABTPTRS == 2)
> > > > > > > |-------+------------------------+-------------------------|
> > > > > > > | Level | Number of nodes/leaves |           Total Nr recs |
> > > > > > > |       |                        | (nr nodes/leaves * 125) |
> > > > > > > |-------+------------------------+-------------------------|
> > > > > > > |     0 |                      1 |                       2 |
> > > > > > > |     1 |                      2 |                     250 |
> > > > > > > |     2 |                    250 |                   31250 |
> > > > > > > |     3 |                  31250 |                 3906250 |
> > > > > > > |     4 |                3906250 |               488281250 |
> > > > > > > |     5 |              488281250 |             61035156250 |
> > > > > > > |-------+------------------------+-------------------------|
> > > > > > > 
> > > > > > > For xattr extents, (2 ** 32) - 1 = 4294967295 (~ 4 billion extents). So this
> > > > > > > will cause the corresponding bmbt's maximum height to go from 3 to 5.
> > > > > > > This probably won't cause any regression.
> > > > > > 
> > > > > > We already have the XFS_DA_NODE_MAXDEPTH set to 5, so changing the
> > > > > > attr fork extent count makes no difference to the attribute fork
> > > > > > bmbt reservations. i.e. the bmbt reservations are defined by the
> > > > > > dabtree structure limits, not the maximum extent count the fork can
> > > > > > hold.
> > > > > 
> > > > > I think the dabtree structure limits is because of the following ...
> > > > > 
> > > > > How many levels of dabtree would be needed to hold ~100 million xattrs?
> > > > > - name len = 16 bytes
> > > > >          struct xfs_parent_name_rec {
> > > > >                __be64  p_ino;
> > > > >                __be32  p_gen;
> > > > >                __be32  p_diroffset;
> > > > >        };
> > > > >   i.e. 64 + 32 + 32 = 128 bits = 16 bytes;
> > > > > - Value len = file name length = Assume ~40 bytes
> > > > 
> > > > That's quite long for a file name, but lets run with it...
> > > > 
> > > > > - Formula for number of node entries (used in column 3 in the table given
> > > > >   below) at any level of the dabtree,
> > > > >   nr_blocks * ((block size - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct
> > > > >   xfs_da_node_entry))
> > > > >   i.e. nr_blocks * ((block size - 64) / 8)
> > > > > - Formula for number of leaf entries (used in column 4 in the table given
> > > > >   below),
> > > > >   (block size - sizeof(xfs_attr_leaf_hdr_t)) /
> > > > >   (sizeof(xfs_attr_leaf_entry_t) + valuelen + namelen + nameval)
> > > > >   i.e. nr_blocks * ((block size - 32) / (8 + 2 + 1 + 16 + 40))
> > > > > 
> > > > > Here I have assumed block size to be 4k.
> > > > > 
> > > > > |-------+------------------+--------------------------+--------------------------|
> > > > > | Level | Number of blocks | Number of entries (node) | Number of entries (leaf) |
> > > > > |-------+------------------+--------------------------+--------------------------|
> > > > > |     0 |              1.0 |                      5e2 |                    6.1e1 |
> > > > > |     1 |              5e2 |                    2.5e5 |                    3.0e4 |
> > > > > |     2 |            2.5e5 |                    1.3e8 |                    1.5e7 |
> > > > > |     3 |            1.3e8 |                   6.6e10 |                    7.9e9 |
> > > > > |-------+------------------+--------------------------+--------------------------|
> > > > 
> > > > I'm not sure what this table actually represents.
> > > > 
> > > > > 
> > > > > Hence we would need a tree of height 3.
> > > > > Total number of blocks = 1 + 5e2 + 2.5e5 + 1.3e8 = ~1.3e8
> > > > 
> > > > 130 million blocks to hold 100 million xattrs? That doesn't pass the
> > > > smell test.
> > > > 
> > > > I think you are trying to do these calculations from the wrong
> > > > direction.
> > > 
> > > You are right. Btrees grow in height by adding a new root
> > > node. Hence the btree space usage should be calculated in bottom-to-top
> > > direction.
> > > 
> > > > Calculate the number of leaf blocks needed to hold the
> > > > xattr data first, then work out the height of the pointer tree from
> > > > that. e.g:
> > > > 
> > > > If we need 100m xattrs, we need this many 100% full 4k blocks to
> > > > hold them all:
> > > > 
> > > > blocks	= 100m / entries per leaf
> > > > 	= 100m / 61
> > > > 	= 1.64m
> > > > 
> > > > and if we assume 37% for the least populated (because magic
> > > > split/merge number), multiply by 3, so blocks ~= 5m for 100m xattrs
> > > > in 4k blocks.
> > > > 
> > > > That makes a lot more sense. Now the tree itself:
> > > > 
> > > > ptrs per node ^ N = 5m
> > > > ptrs per node ^ (N-1) = 5m / 500 = 10k
> > > > ptrs per node ^ (N-2) = 10k / 500 = 200
> > > > ptrs per node ^ (N-3) = 200 / 500 = 1
> > > > 
> > > > So, N-3 = level 0, so we've got a tree of height 4 for 100m xattrs,
> > > > and the pointer tree requires ~12000 blocks which is noise compared
> > > > to the number of leaf blocks...
> > > > 
> > > > As for the bmbt, we've got ~5m extents worst case, which is
> > > > 
> > > > ptrs per node ^ N = 5m
> > > > ptrs per node ^ (N-1) = 5m / 125 = 40k
> > > > ptrs per node ^ (N-2) = 40k / 125 = 320
> > > > ptrs per node ^ (N-3) = 320 / 125 = 3
> > > > 
> > > > As 3 bmbt records should fit in the inode fork, we'd only need a 4
> > > > level bmbt tree to hold this, too. It's at the lower limit of a 4
> > > > level tree, but 100m xattrs is the extreme case we are talking about
> > > > here...
> > > > 
> > > > FWIW, repeat this with a directory data segment size of 32GB w/ 40
> > > > byte names, and the numbers aren't much different to a worst case
> > > > xattr tree of this shape. You'll see the reason for the dabtree
> > > > height being limited to 5, and that neither the directory structure
> > > > nor the xattr structure is anywhere near the 2^32 bit extent count
> > > > limit...
> > > 
> > > Directory segment size is 32 GB                                                                                                                                  
> > >   - Number of directory entries required for indexing 32GiB.
> > >     - 32GiB is divided into 4k data blocks. 
> > >     - Number of 4k blocks = 32GB / 4k = 8M
> > >     - Each 4k data block has,
> > >       - struct xfs_dir3_data_hdr = 64 bytes
> > >       - struct xfs_dir2_data_entry = 12 bytes (metadata) + 40 bytes (name)
> > >                                    = 52 bytes
> > >       - Number of 'struct xfs_dir2_data_entry' in a 4k block
> > >         (4096 - 64) / 52 = 78
> > >     - Number of 'struct xfs_dir2_data_entry' in 32-GiB space
> > >       8m * 78 = 654m
> > >   - Contents of a single dabtree leaf
> > >     - struct xfs_dir3_leaf_hdr = 64 bytes
> > >     - struct xfs_dir2_leaf_entry = 8 bytes
> > >     - Number of 'struct xfs_dir2_leaf_entry' = (4096 - 64) / 8 = 504
> > >     - 37% of 504 = 186 entries
> > >   - Contents of a single dabtree node
> > >     - struct xfs_da3_node_hdr = 64 bytes
> > >     - struct xfs_da_node_entry = 8 bytes
> > >     - Number of 'struct xfs_da_node_entry' = (4096 - 64) / 8 = 504
> > >   - Nr leaves
> > >     Level (N) = 654m / 186 = 3m leaves
> > >     Level (N-1) = 3m / 504 = 6k
> > >     Level (N-2) = 6k / 504 = 12
> > >     Level (N-3) = 12 / 504 = 1
> > >     Dabtree having 4 levels is sufficient.
> > > 
> > > Hence a dabtree with 5 levels should be more than enough to index a 32GiB
> > > directory segment containing directory entries with even shorter names.
> > > 
> > > Even with 5m extents (used in xattr tree example above) consumed by a da
> > > btree, this is still much less than the limit imposed by 2^32 (i.e. ~4
> > > billion) extents.
> > > 
> > > Hence the actual log space consumed for logging bmbt blocks is limited by the
> > > height of da btree.
> > > 
> > > My experiment with changing the values of MAXEXTNUM and MAXAEXTNUM to 2^47 and
> > > 2^32 respectively, gave me the following results,
> > > - For 1k block size, bmbt tree height increased by 3.
> > > - For 4k block size, bmbt tree height increased by 2.
> > > 
> > > This happens because xfs_bmap_compute_maxlevels() calculates the BMBT tree
> > > height by assuming that there will be MAXEXTNUM/MAXAEXTNUM worth of leaf
> > > entries in the worst case.
> > > 
> > > For Attr fork Bmbt , Do you think the calculation should be changed to
> > > consider the number of extents occupied by a dabtree holding > 100 million
> > > xattrs?
> > > 
> > > The new increase in Bmbt height in turn causes the static reservation values
> > > to increase. In the worst case, the maximum increase observed was 118k bytes
> > > (4k block size, reflink=0, tr_rename).
> > > 
> > > The experiment was executed after applying "xfsprogs: Fix log reservation
> > > calculation for xattr insert operation" patch
> > > (https://lore.kernel.org/linux-xfs/20200404085229.2034-2-chandanrlinux@gmail.com/)
> > > 
> > > I am attaching the output of "xfs_db -c logres <dev>" executed on the
> > > following configurations of the XFS filesystem.
> > > - -b size=1k -m reflink=0
> > > - -b size=1k -m rmapbt=1reflink=1
> > > - -b size=4k -m reflink=0
> > > - -b size=4k -m rmapbt=1reflink=1
> > > - -b size=1k -m crc=0
> > > - -b size=4k -m crc=0
> > > 
> > > I will go through the code which calculates the log reservations of the
> > > entries which have a drastic increase in their values.
> > > 
> > 
> > The highest increase (i.e. an increase of 118k) in log reservation was
> > associated with the rename operation,
> > 
> > STATIC uint
> > xfs_calc_rename_reservation(
> >         struct xfs_mount        *mp)
> > {
> >         return XFS_DQUOT_LOGRES(mp) +
> >                 max((xfs_calc_inode_res(mp, 4) +
> >                      xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
> >                                       XFS_FSB_TO_B(mp, 1))),
> >                     (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> >                      xfs_calc_buf_res(xfs_allocfree_log_count(mp, 3),
> >                                       XFS_FSB_TO_B(mp, 1))));
> > }
> > 
> > The first argument to max() contributes the highest value.
> > 
> > xfs_calc_inode_res(mp, 4) + xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),XFS_FSB_TO_B(mp, 1))
> > 
> > The inode reservation part is a constant.
> > 
> > The number of blocks computed by the second operand of the '+' operator is,
> > 
> > 2 * ((XFS_DA_NODE_MAXDEPTH + 2) + ((XFS_DA_NODE_MAXDEPTH + 2) * (bmbt_height - 1)))
> > 
> > = 2 * ((5 + 2) + ((5 + 2) * (bmbt_height - 1)))
> > 
> > When bmbt height is 5 (i.e. when using the original 2^31 extent count limit) this
> > evaluates to,
> > 
> > 2 * ((5 + 2) + ((5 + 2) * (5 - 1)))
> > = 70 blocks
> > 
> > When bmbt height is 7 (i.e. when using the original 2^47 extent count limit) this
> > evaluates to,
> > 
> > 2 * ((5 + 2) + ((5 + 2) * (7 - 1)))
> > = 98 blocks
> > 
> > However, I don't see any extraneous space reserved by the above calculation
> > that could be removed. Also, IMHO an increase by 118k is most likely not going
> > to introduce any bugs. I will execute xfstests to make sure that no
> > regressions get added.
> 
> (Did fstests pass?)
>

On Wednesday, May 13, 2020 5:23:22 AM IST you wrote:
> On Fri, May 01, 2020 at 12:38:30PM +0530, Chandan Rajendra wrote:
> > On Wednesday, April 29, 2020 9:05 PM Chandan Rajendra wrote: 
> > > On Monday, April 27, 2020 3:38 AM Dave Chinner wrote: 
> > > > On Sat, Apr 25, 2020 at 05:37:39PM +0530, Chandan Rajendra wrote:
> > > > > On Thursday, April 23, 2020 4:00 AM Dave Chinner wrote: 
> > > > > > On Wed, Apr 22, 2020 at 03:08:00PM +0530, Chandan Rajendra wrote:
> > > > > > > Attr bmbt tree height (MINABTPTRS == 2)
> > > > > > > |-------+------------------------+-------------------------|
> > > > > > > | Level | Number of nodes/leaves |           Total Nr recs |
> > > > > > > |       |                        | (nr nodes/leaves * 125) |
> > > > > > > |-------+------------------------+-------------------------|
> > > > > > > |     0 |                      1 |                       2 |
> > > > > > > |     1 |                      2 |                     250 |
> > > > > > > |     2 |                    250 |                   31250 |
> > > > > > > |     3 |                  31250 |                 3906250 |
> > > > > > > |     4 |                3906250 |               488281250 |
> > > > > > > |     5 |              488281250 |             61035156250 |
> > > > > > > |-------+------------------------+-------------------------|
> > > > > > > 
> > > > > > > For xattr extents, (2 ** 32) - 1 = 4294967295 (~ 4 billion extents). So this
> > > > > > > will cause the corresponding bmbt's maximum height to go from 3 to 5.
> > > > > > > This probably won't cause any regression.
> > > > > > 
> > > > > > We already have the XFS_DA_NODE_MAXDEPTH set to 5, so changing the
> > > > > > attr fork extent count makes no difference to the attribute fork
> > > > > > bmbt reservations. i.e. the bmbt reservations are defined by the
> > > > > > dabtree structure limits, not the maximum extent count the fork can
> > > > > > hold.
> > > > > 
> > > > > I think the dabtree structure limits is because of the following ...
> > > > > 
> > > > > How many levels of dabtree would be needed to hold ~100 million xattrs?
> > > > > - name len = 16 bytes
> > > > >          struct xfs_parent_name_rec {
> > > > >                __be64  p_ino;
> > > > >                __be32  p_gen;
> > > > >                __be32  p_diroffset;
> > > > >        };
> > > > >   i.e. 64 + 32 + 32 = 128 bits = 16 bytes;
> > > > > - Value len = file name length = Assume ~40 bytes
> > > > 
> > > > That's quite long for a file name, but lets run with it...
> > > > 
> > > > > - Formula for number of node entries (used in column 3 in the table given
> > > > >   below) at any level of the dabtree,
> > > > >   nr_blocks * ((block size - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct
> > > > >   xfs_da_node_entry))
> > > > >   i.e. nr_blocks * ((block size - 64) / 8)
> > > > > - Formula for number of leaf entries (used in column 4 in the table given
> > > > >   below),
> > > > >   (block size - sizeof(xfs_attr_leaf_hdr_t)) /
> > > > >   (sizeof(xfs_attr_leaf_entry_t) + valuelen + namelen + nameval)
> > > > >   i.e. nr_blocks * ((block size - 32) / (8 + 2 + 1 + 16 + 40))
> > > > > 
> > > > > Here I have assumed block size to be 4k.
> > > > > 
> > > > > |-------+------------------+--------------------------+--------------------------|
> > > > > | Level | Number of blocks | Number of entries (node) | Number of entries (leaf) |
> > > > > |-------+------------------+--------------------------+--------------------------|
> > > > > |     0 |              1.0 |                      5e2 |                    6.1e1 |
> > > > > |     1 |              5e2 |                    2.5e5 |                    3.0e4 |
> > > > > |     2 |            2.5e5 |                    1.3e8 |                    1.5e7 |
> > > > > |     3 |            1.3e8 |                   6.6e10 |                    7.9e9 |
> > > > > |-------+------------------+--------------------------+--------------------------|
> > > > 
> > > > I'm not sure what this table actually represents.
> > > > 
> > > > > 
> > > > > Hence we would need a tree of height 3.
> > > > > Total number of blocks = 1 + 5e2 + 2.5e5 + 1.3e8 = ~1.3e8
> > > > 
> > > > 130 million blocks to hold 100 million xattrs? That doesn't pass the
> > > > smell test.
> > > > 
> > > > I think you are trying to do these calculations from the wrong
> > > > direction.
> > > 
> > > You are right. Btrees grow in height by adding a new root
> > > node. Hence the btree space usage should be calculated in bottom-to-top
> > > direction.
> > > 
> > > > Calculate the number of leaf blocks needed to hold the
> > > > xattr data first, then work out the height of the pointer tree from
> > > > that. e.g:
> > > > 
> > > > If we need 100m xattrs, we need this many 100% full 4k blocks to
> > > > hold them all:
> > > > 
> > > > blocks	= 100m / entries per leaf
> > > > 	= 100m / 61
> > > > 	= 1.64m
> > > > 
> > > > and if we assume 37% for the least populated (because magic
> > > > split/merge number), multiply by 3, so blocks ~= 5m for 100m xattrs
> > > > in 4k blocks.
> > > > 
> > > > That makes a lot more sense. Now the tree itself:
> > > > 
> > > > ptrs per node ^ N = 5m
> > > > ptrs per node ^ (N-1) = 5m / 500 = 10k
> > > > ptrs per node ^ (N-2) = 10k / 500 = 200
> > > > ptrs per node ^ (N-3) = 200 / 500 = 1
> > > > 
> > > > So, N-3 = level 0, so we've got a tree of height 4 for 100m xattrs,
> > > > and the pointer tree requires ~12000 blocks which is noise compared
> > > > to the number of leaf blocks...
> > > > 
> > > > As for the bmbt, we've got ~5m extents worst case, which is
> > > > 
> > > > ptrs per node ^ N = 5m
> > > > ptrs per node ^ (N-1) = 5m / 125 = 40k
> > > > ptrs per node ^ (N-2) = 40k / 125 = 320
> > > > ptrs per node ^ (N-3) = 320 / 125 = 3
> > > > 
> > > > As 3 bmbt records should fit in the inode fork, we'd only need a 4
> > > > level bmbt tree to hold this, too. It's at the lower limit of a 4
> > > > level tree, but 100m xattrs is the extreme case we are talking about
> > > > here...
> > > > 
> > > > FWIW, repeat this with a directory data segment size of 32GB w/ 40
> > > > byte names, and the numbers aren't much different to a worst case
> > > > xattr tree of this shape. You'll see the reason for the dabtree
> > > > height being limited to 5, and that neither the directory structure
> > > > nor the xattr structure is anywhere near the 2^32 bit extent count
> > > > limit...
> > > 
> > > Directory segment size is 32 GB                                                                                                                                  
> > >   - Number of directory entries required for indexing 32GiB.
> > >     - 32GiB is divided into 4k data blocks. 
> > >     - Number of 4k blocks = 32GB / 4k = 8M
> > >     - Each 4k data block has,
> > >       - struct xfs_dir3_data_hdr = 64 bytes
> > >       - struct xfs_dir2_data_entry = 12 bytes (metadata) + 40 bytes (name)
> > >                                    = 52 bytes
> > >       - Number of 'struct xfs_dir2_data_entry' in a 4k block
> > >         (4096 - 64) / 52 = 78
> > >     - Number of 'struct xfs_dir2_data_entry' in 32-GiB space
> > >       8m * 78 = 654m
> > >   - Contents of a single dabtree leaf
> > >     - struct xfs_dir3_leaf_hdr = 64 bytes
> > >     - struct xfs_dir2_leaf_entry = 8 bytes
> > >     - Number of 'struct xfs_dir2_leaf_entry' = (4096 - 64) / 8 = 504
> > >     - 37% of 504 = 186 entries
> > >   - Contents of a single dabtree node
> > >     - struct xfs_da3_node_hdr = 64 bytes
> > >     - struct xfs_da_node_entry = 8 bytes
> > >     - Number of 'struct xfs_da_node_entry' = (4096 - 64) / 8 = 504
> > >   - Nr leaves
> > >     Level (N) = 654m / 186 = 3m leaves
> > >     Level (N-1) = 3m / 504 = 6k
> > >     Level (N-2) = 6k / 504 = 12
> > >     Level (N-3) = 12 / 504 = 1
> > >     Dabtree having 4 levels is sufficient.
> > > 
> > > Hence a dabtree with 5 levels should be more than enough to index a 32GiB
> > > directory segment containing directory entries with even shorter names.
> > > 
> > > Even with 5m extents (used in xattr tree example above) consumed by a da
> > > btree, this is still much less than the limit imposed by 2^32 (i.e. ~4
> > > billion) extents.
> > > 
> > > Hence the actual log space consumed for logging bmbt blocks is limited by the
> > > height of da btree.
> > > 
> > > My experiment with changing the values of MAXEXTNUM and MAXAEXTNUM to 2^47 and
> > > 2^32 respectively, gave me the following results,
> > > - For 1k block size, bmbt tree height increased by 3.
> > > - For 4k block size, bmbt tree height increased by 2.
> > > 
> > > This happens because xfs_bmap_compute_maxlevels() calculates the BMBT tree
> > > height by assuming that there will be MAXEXTNUM/MAXAEXTNUM worth of leaf
> > > entries in the worst case.
> > > 
> > > For Attr fork Bmbt , Do you think the calculation should be changed to
> > > consider the number of extents occupied by a dabtree holding > 100 million
> > > xattrs?
> > > 
> > > The new increase in Bmbt height in turn causes the static reservation values
> > > to increase. In the worst case, the maximum increase observed was 118k bytes
> > > (4k block size, reflink=0, tr_rename).
> > > 
> > > The experiment was executed after applying "xfsprogs: Fix log reservation
> > > calculation for xattr insert operation" patch
> > > (https://lore.kernel.org/linux-xfs/20200404085229.2034-2-chandanrlinux@gmail.com/)
> > > 
> > > I am attaching the output of "xfs_db -c logres <dev>" executed on the
> > > following configurations of the XFS filesystem.
> > > - -b size=1k -m reflink=0
> > > - -b size=1k -m rmapbt=1reflink=1
> > > - -b size=4k -m reflink=0
> > > - -b size=4k -m rmapbt=1reflink=1
> > > - -b size=1k -m crc=0
> > > - -b size=4k -m crc=0
> > > 
> > > I will go through the code which calculates the log reservations of the
> > > entries which have a drastic increase in their values.
> > > 
> > 
> > The highest increase (i.e. an increase of 118k) in log reservation was
> > associated with the rename operation,
> > 
> > STATIC uint
> > xfs_calc_rename_reservation(
> >         struct xfs_mount        *mp)
> > {
> >         return XFS_DQUOT_LOGRES(mp) +
> >                 max((xfs_calc_inode_res(mp, 4) +
> >                      xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
> >                                       XFS_FSB_TO_B(mp, 1))),
> >                     (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> >                      xfs_calc_buf_res(xfs_allocfree_log_count(mp, 3),
> >                                       XFS_FSB_TO_B(mp, 1))));
> > }
> > 
> > The first argument to max() contributes the highest value.
> > 
> > xfs_calc_inode_res(mp, 4) + xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),XFS_FSB_TO_B(mp, 1))
> > 
> > The inode reservation part is a constant.
> > 
> > The number of blocks computed by the second operand of the '+' operator is,
> > 
> > 2 * ((XFS_DA_NODE_MAXDEPTH + 2) + ((XFS_DA_NODE_MAXDEPTH + 2) * (bmbt_height - 1)))
> > 
> > = 2 * ((5 + 2) + ((5 + 2) * (bmbt_height - 1)))
> > 
> > When bmbt height is 5 (i.e. when using the original 2^31 extent count limit) this
> > evaluates to,
> > 
> > 2 * ((5 + 2) + ((5 + 2) * (5 - 1)))
> > = 70 blocks
> > 
> > When bmbt height is 7 (i.e. when using the original 2^47 extent count limit) this
> > evaluates to,
> > 
> > 2 * ((5 + 2) + ((5 + 2) * (7 - 1)))
> > = 98 blocks
> > 
> > However, I don't see any extraneous space reserved by the above calculation
> > that could be removed. Also, IMHO an increase by 118k is most likely not going
> > to introduce any bugs. I will execute xfstests to make sure that no
> > regressions get added.
> 
> (Did fstests pass?)

I had executed fstests with 5 different configurations i.e.
1. -m crc=0 -bsize=1k
2. -m crc=0 -bsize=4k
3. -m crc=0 -bsize=512
4. -m rmapbt=1,reflink=1 -bsize=1k
5. -m rmapbt=1,reflink=1 -bsize=4k

The only test that regressed was xfs/306.  It failed when using "-m
rmapbt=1,reflink=1 -b size=1k" mkfs configuration.

The changes were made only to the kernel and I had used upstream xfsprogs since
the newer kernel is supposed to mount older filesystems as well.

The dmesg log had the following,

[  702.273340] XFS (loop0): Mounting V5 Filesystem
[  702.275511] XFS (loop0): Log size 8906 blocks too small, minimum size is 9075 blocks
[  702.277764] XFS (loop0): AAIEEE! Log failed size checks. Abort!
[  702.279615] XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 711
[  702.283679] ------------[ cut here ]------------
[  702.285170] WARNING: CPU: 0 PID: 12821 at fs/xfs/xfs_message.c:112 assfail+0x25/0x28
[  702.287651] Modules linked in:
[  702.288654] CPU: 0 PID: 12821 Comm: mount Tainted: G        W         5.6.0-rc6-next-20200320-chandan-00003-g071c2af3f4de #1
[  702.291995] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[  702.294159] RIP: 0010:assfail+0x25/0x28
[  702.295176] Code: ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 40 b7 4b b3 e8 82 f9 ff ff 80 3d 83 d6 64 01 00 74 02 0f $
[  702.300079] RSP: 0018:ffffb05b414cbd78 EFLAGS: 00010246
[  702.301463] RAX: 0000000000000000 RBX: ffff9d9d501d5000 RCX: 0000000000000000
[  702.303293] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffb346dc65
[  702.304976] RBP: ffff9da444b49a80 R08: 0000000000000000 R09: 0000000000000000
[  702.306747] R10: 000000000000000a R11: f000000000000000 R12: 00000000ffffffea
[  702.308417] R13: 000000000000000e R14: 0000000000004594 R15: ffff9d9d501d5628
[  702.310138] FS:  00007fd6c5d17c80(0000) GS:ffff9da44d800000(0000) knlGS:0000000000000000
[  702.312078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  702.313421] CR2: 0000000000000002 CR3: 00000008a48c0000 CR4: 00000000000006f0
[  702.315210] Call Trace:
[  702.315807]  xfs_log_mount+0xf8/0x300
[  702.316741]  xfs_mountfs+0x46e/0x950
[  702.317640]  xfs_fc_fill_super+0x318/0x510
[  702.318739]  ? xfs_mount_free+0x30/0x30
[  702.319669]  get_tree_bdev+0x15c/0x250
[  702.320579]  vfs_get_tree+0x25/0xb0
[  702.321417]  do_mount+0x740/0x9b0
[  702.322220]  ? memdup_user+0x41/0x80
[  702.323135]  __x64_sys_mount+0x8e/0xd0
[  702.324033]  do_syscall_64+0x48/0x110
[  702.324918]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  702.326133] RIP: 0033:0x7fd6c5f2ccda
[  702.327105] Code: 48 8b 0d b9 e1 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f $
[  702.331596] RSP: 002b:00007ffe00dfb9f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[  702.333430] RAX: ffffffffffffffda RBX: 0000560c1aaa92c0 RCX: 00007fd6c5f2ccda
[  702.335146] RDX: 0000560c1aaae110 RSI: 0000560c1aaad040 RDI: 0000560c1aaa94d0
[  702.336843] RBP: 00007fd6c607d204 R08: 0000000000000000 R09: 0000560c1aaadde0
[  702.338618] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  702.340314] R13: 0000000000000000 R14: 0000560c1aaa94d0 R15: 0000560c1aaae110
[  702.342039] ---[ end trace 6436391b468bc652 ]---
[  702.343308] XFS (loop0): log mount failed

xfs/306 has,

_scratch_mkfs_xfs -d size=20m -n size=64k >> $seqres.full 2>&1

i.e. it creates a filesystem of size 20MiB, data block size of 1KiB and
directory block size of 64KiB. Filesystems of size < 1GiB can have less than
10MiB log (Please refer to calculate_log_size() in xfsprogs).

The highest reservation space was used by tr_rename. The calculation is done
by xfs_calc_rename_reservation(). In this case, the value returned by this
function was accounted by

xfs_calc_inode_res(mp, 4)
+ xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1))

xfs_calc_inode_res(mp, 4) returns a constant value (i.e. 3040).

The largest contribution to the value returned by the above
calculation was by 2 * XFS_DIROP_LOG_COUNT(mp).

XFS_DIROP_LOG_COUNT() is a sum of
1. The maximum number of dabtree blocks that needs to be logged
   i.e. XFS_DAENTER_BLOCKS() = XFS_DAENTER_1B(mp,w) * XFS_DAENTER_DBS(mp,w).
   For directories, this evaluates to (64 * (XFS_DA_NODE_MAXDEPTH + 2)) = (64
   * (5 + 2)) = 448.
   NOTE: I still don't know why we add the "2" to XFS_DA_NODE_MAXDEPTH in the
   above calculation.
2. The corresponding maximum number of bmap btree blocks that needs to be
   logged i.e. XFS_DAENTER_BMAPS() = XFS_DAENTER_DBS(mp,w) *
   XFS_DAENTER_BMAP1B(mp,w)

   XFS_DAENTER_DBS(mp,w) = XFS_DA_NODE_MAXDEPTH + 2 = 7
   XFS_DAENTER_BMAP1B(mp,w)
   = XFS_NEXTENTADD_SPACE_RES(mp, XFS_DAENTER_1B(mp, w), w)
   = XFS_NEXTENTADD_SPACE_RES(mp, 64, w)
   = ((64 + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) /
   XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * XFS_EXTENTADD_SPACE_RES(mp, w)

   XFS_MAX_CONTIG_EXTENTS_PER_BLOCK() = (mp)->m_alloc_mxr[0]) -
   ((mp)->m_alloc_mnr[0] = 121 - 60 = 61 

   XFS_DAENTER_BMAP1B(mp,w) = ((64 + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) /
   XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * XFS_EXTENTADD_SPACE_RES(mp, w)
   = ((64 + 61 - 1) / 61) * XFS_EXTENTADD_SPACE_RES(mp, w)
   = 2 * XFS_EXTENTADD_SPACE_RES(mp, w)
   = 2 * (XFS_BM_MAXLEVELS(mp,w) - 1)
   = 2 * (8 - 1) ;; Notice that the height of the bmap btree has increased to 8.
   = 14

   With 2^32 as the maximum extent count the maximum height of the bmap btree
   was 7. Now with 2^47 maximum extent count the height is 8.

   Therefore, XFS_DAENTER_BMAPS() = 7 * 14 = 98.

Also, XFS_DIROP_LOG_COUNT() = 448 + 98 = 546.
2 * XFS_DIROP_LOG_COUNT() = 2 * 546 = 1092.

With 2^32 max extent count, XFS_DIROP_LOG_COUNT() evaluates to 533. Hence 2 *
XFS_DIROP_LOG_COUNT() = 2 * 533 = 1066.

This small difference of 1092 - 1066 = 26 fs blocks is sufficient to trip us
over the minimum log size check.

I could not find a way to reduce the number of blocks that gets logged.

Hence I thought of the following alternate approach.

The maximum number of extents that can be occupied by a directory is ~
2^27. The following steps prove this, (I assumed fs block size to be
512 bytes since it is the one which can create a bmap btree of maximum
possible height).

Maximum number of extents in data space = 32GiB (i.e. XFS_DIR2_SPACE_SIZE) / 2^9 = 2^26.
Maximum number (theoretically) of extents in leaf space = 32GiB / 2^9 = 2^26.

Maximum number of entries in a free space index block
= (512 - (sizeof struct xfs_dir3_free_hdr)) / (sizeof struct xfs_dir2_data_off_t)
= (512 - 64) / 2 = 224
Maximum number of extents in free space index = (Maximum number of extents in
data segment) / 224 = (2^26) / 224 = ~2^18

Maximum number of extents in a directory = 2^26 + 2^26 + 2^18 = ~2^27

Hence my idea was to have a new entry in xfs_mount->m_bm_maxlevels[]
array to hold the maximum height of a bmap btree belonging to a
directory and use that for calculating reservations associated with
directories.

Please let me know your opinion on this.

PS: I had started making the changes in the kernel and was planning to
test the changes before posting this idea on the mailing list.
   
-- 
chandan



