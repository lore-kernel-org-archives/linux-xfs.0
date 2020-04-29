Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB595C83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D472073E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgD2PdA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:33:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726511AbgD2Pc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:32:59 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TFW7rE175209;
        Wed, 29 Apr 2020 11:32:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mggvuhcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:32:55 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03TFWjVo177228;
        Wed, 29 Apr 2020 11:32:55 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mggvuhby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:32:55 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFUgGF029622;
        Wed, 29 Apr 2020 15:32:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu70r69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:32:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFWp7V55771222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:32:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB6011C04A;
        Wed, 29 Apr 2020 15:32:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ACDF11C054;
        Wed, 29 Apr 2020 15:32:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.39.37])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:32:49 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Date:   Wed, 29 Apr 2020 21:05:53 +0530
Message-ID: <2685908.IIZSzdRcA6@localhost.localdomain>
Organization: IBM
In-Reply-To: <20200426220805.GE2040@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <2457302.TnqmriUJk8@localhost.localdomain> <20200426220805.GE2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart6355879.3B4Dmp7Yhb"
Content-Transfer-Encoding: 7Bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart6355879.3B4Dmp7Yhb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, April 27, 2020 3:38 AM Dave Chinner wrote: 
> On Sat, Apr 25, 2020 at 05:37:39PM +0530, Chandan Rajendra wrote:
> > On Thursday, April 23, 2020 4:00 AM Dave Chinner wrote: 
> > > On Wed, Apr 22, 2020 at 03:08:00PM +0530, Chandan Rajendra wrote:
> > > > Attr bmbt tree height (MINABTPTRS == 2)
> > > > |-------+------------------------+-------------------------|
> > > > | Level | Number of nodes/leaves |           Total Nr recs |
> > > > |       |                        | (nr nodes/leaves * 125) |
> > > > |-------+------------------------+-------------------------|
> > > > |     0 |                      1 |                       2 |
> > > > |     1 |                      2 |                     250 |
> > > > |     2 |                    250 |                   31250 |
> > > > |     3 |                  31250 |                 3906250 |
> > > > |     4 |                3906250 |               488281250 |
> > > > |     5 |              488281250 |             61035156250 |
> > > > |-------+------------------------+-------------------------|
> > > > 
> > > > For xattr extents, (2 ** 32) - 1 = 4294967295 (~ 4 billion extents). So this
> > > > will cause the corresponding bmbt's maximum height to go from 3 to 5.
> > > > This probably won't cause any regression.
> > > 
> > > We already have the XFS_DA_NODE_MAXDEPTH set to 5, so changing the
> > > attr fork extent count makes no difference to the attribute fork
> > > bmbt reservations. i.e. the bmbt reservations are defined by the
> > > dabtree structure limits, not the maximum extent count the fork can
> > > hold.
> > 
> > I think the dabtree structure limits is because of the following ...
> > 
> > How many levels of dabtree would be needed to hold ~100 million xattrs?
> > - name len = 16 bytes
> >          struct xfs_parent_name_rec {
> >                __be64  p_ino;
> >                __be32  p_gen;
> >                __be32  p_diroffset;
> >        };
> >   i.e. 64 + 32 + 32 = 128 bits = 16 bytes;
> > - Value len = file name length = Assume ~40 bytes
> 
> That's quite long for a file name, but lets run with it...
> 
> > - Formula for number of node entries (used in column 3 in the table given
> >   below) at any level of the dabtree,
> >   nr_blocks * ((block size - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct
> >   xfs_da_node_entry))
> >   i.e. nr_blocks * ((block size - 64) / 8)
> > - Formula for number of leaf entries (used in column 4 in the table given
> >   below),
> >   (block size - sizeof(xfs_attr_leaf_hdr_t)) /
> >   (sizeof(xfs_attr_leaf_entry_t) + valuelen + namelen + nameval)
> >   i.e. nr_blocks * ((block size - 32) / (8 + 2 + 1 + 16 + 40))
> > 
> > Here I have assumed block size to be 4k.
> > 
> > |-------+------------------+--------------------------+--------------------------|
> > | Level | Number of blocks | Number of entries (node) | Number of entries (leaf) |
> > |-------+------------------+--------------------------+--------------------------|
> > |     0 |              1.0 |                      5e2 |                    6.1e1 |
> > |     1 |              5e2 |                    2.5e5 |                    3.0e4 |
> > |     2 |            2.5e5 |                    1.3e8 |                    1.5e7 |
> > |     3 |            1.3e8 |                   6.6e10 |                    7.9e9 |
> > |-------+------------------+--------------------------+--------------------------|
> 
> I'm not sure what this table actually represents.
> 
> > 
> > Hence we would need a tree of height 3.
> > Total number of blocks = 1 + 5e2 + 2.5e5 + 1.3e8 = ~1.3e8
> 
> 130 million blocks to hold 100 million xattrs? That doesn't pass the
> smell test.
> 
> I think you are trying to do these calculations from the wrong
> direction.

You are right. Btrees grow in height by adding a new root
node. Hence the btree space usage should be calculated in bottom-to-top
direction.

> Calculate the number of leaf blocks needed to hold the
> xattr data first, then work out the height of the pointer tree from
> that. e.g:
> 
> If we need 100m xattrs, we need this many 100% full 4k blocks to
> hold them all:
> 
> blocks	= 100m / entries per leaf
> 	= 100m / 61
> 	= 1.64m
> 
> and if we assume 37% for the least populated (because magic
> split/merge number), multiply by 3, so blocks ~= 5m for 100m xattrs
> in 4k blocks.
> 
> That makes a lot more sense. Now the tree itself:
> 
> ptrs per node ^ N = 5m
> ptrs per node ^ (N-1) = 5m / 500 = 10k
> ptrs per node ^ (N-2) = 10k / 500 = 200
> ptrs per node ^ (N-3) = 200 / 500 = 1
> 
> So, N-3 = level 0, so we've got a tree of height 4 for 100m xattrs,
> and the pointer tree requires ~12000 blocks which is noise compared
> to the number of leaf blocks...
> 
> As for the bmbt, we've got ~5m extents worst case, which is
> 
> ptrs per node ^ N = 5m
> ptrs per node ^ (N-1) = 5m / 125 = 40k
> ptrs per node ^ (N-2) = 40k / 125 = 320
> ptrs per node ^ (N-3) = 320 / 125 = 3
> 
> As 3 bmbt records should fit in the inode fork, we'd only need a 4
> level bmbt tree to hold this, too. It's at the lower limit of a 4
> level tree, but 100m xattrs is the extreme case we are talking about
> here...
> 
> FWIW, repeat this with a directory data segment size of 32GB w/ 40
> byte names, and the numbers aren't much different to a worst case
> xattr tree of this shape. You'll see the reason for the dabtree
> height being limited to 5, and that neither the directory structure
> nor the xattr structure is anywhere near the 2^32 bit extent count
> limit...

Directory segment size is 32 GB                                                                                                                                  
  - Number of directory entries required for indexing 32GiB.
    - 32GiB is divided into 4k data blocks. 
    - Number of 4k blocks = 32GB / 4k = 8M
    - Each 4k data block has,
      - struct xfs_dir3_data_hdr = 64 bytes
      - struct xfs_dir2_data_entry = 12 bytes (metadata) + 40 bytes (name)
                                   = 52 bytes
      - Number of 'struct xfs_dir2_data_entry' in a 4k block
        (4096 - 64) / 52 = 78
    - Number of 'struct xfs_dir2_data_entry' in 32-GiB space
      8m * 78 = 654m
  - Contents of a single dabtree leaf
    - struct xfs_dir3_leaf_hdr = 64 bytes
    - struct xfs_dir2_leaf_entry = 8 bytes
    - Number of 'struct xfs_dir2_leaf_entry' = (4096 - 64) / 8 = 504
    - 37% of 504 = 186 entries
  - Contents of a single dabtree node
    - struct xfs_da3_node_hdr = 64 bytes
    - struct xfs_da_node_entry = 8 bytes
    - Number of 'struct xfs_da_node_entry' = (4096 - 64) / 8 = 504
  - Nr leaves
    Level (N) = 654m / 186 = 3m leaves
    Level (N-1) = 3m / 504 = 6k
    Level (N-2) = 6k / 504 = 12
    Level (N-3) = 12 / 504 = 1
    Dabtree having 4 levels is sufficient.

Hence a dabtree with 5 levels should be more than enough to index a 32GiB
directory segment containing directory entries with even shorter names.

Even with 5m extents (used in xattr tree example above) consumed by a da
btree, this is still much less than the limit imposed by 2^32 (i.e. ~4
billion) extents.

Hence the actual log space consumed for logging bmbt blocks is limited by the
height of da btree.

My experiment with changing the values of MAXEXTNUM and MAXAEXTNUM to 2^47 and
2^32 respectively, gave me the following results,
- For 1k block size, bmbt tree height increased by 3.
- For 4k block size, bmbt tree height increased by 2.

This happens because xfs_bmap_compute_maxlevels() calculates the BMBT tree
height by assuming that there will be MAXEXTNUM/MAXAEXTNUM worth of leaf
entries in the worst case.

For Attr fork Bmbt , Do you think the calculation should be changed to
consider the number of extents occupied by a dabtree holding > 100 million
xattrs?

The new increase in Bmbt height in turn causes the static reservation values
to increase. In the worst case, the maximum increase observed was 118k bytes
(4k block size, reflink=0, tr_rename).

The experiment was executed after applying "xfsprogs: Fix log reservation
calculation for xattr insert operation" patch
(https://lore.kernel.org/linux-xfs/20200404085229.2034-2-chandanrlinux@gmail.com/)

I am attaching the output of "xfs_db -c logres <dev>" executed on the
following configurations of the XFS filesystem.
- -b size=1k -m reflink=0
- -b size=1k -m rmapbt=1reflink=1
- -b size=4k -m reflink=0
- -b size=4k -m rmapbt=1reflink=1
- -b size=1k -m crc=0
- -b size=4k -m crc=0

I will go through the code which calculates the log reservations of the
entries which have a drastic increase in their values.

-- 
chandan

--nextPart6355879.3B4Dmp7Yhb
Content-Disposition: attachment; filename="xfs-db-logres.tar.gz"
Content-Transfer-Encoding: base64
Content-Type: application/x-compressed-tar; name="xfs-db-logres.tar.gz"

H4sIAAAAAAACA+1bXVMqORD12V8xb75cNZ100h2rfNit3V+xtWUhDl5KAQvGW+7++g1+zAzgNAEy
OrqTB/CjyUBOcubk5PA0WpzeXJ8ftdlUaGTt83No68/PP4NxVmuyZlkHoRyPMnv0Ae1xUQzmWXY0
n80KqW7b/79oe3rB/+XpdDYf357dz27T4+8QG/DXCohe8deotAv4G0sBf9Xj33r78ykfPhbj6W02
nE0mg+nNRZb9dTK5Gy3Owpw4+ZGdnI6eH6+Xj4vxv/kl3D3/YTLPR/fj6d2lWv56fpP/Or+fzR7U
yd/H4ZVX15PBw1Xo8+GxyK8mg6f7/Fd+v7hgf5H9MSgG2Wg2v7vIfp9cF9nPfHz7s8guMzrb9tLf
imI+vg5/f/f1eHZc/POQZyoLc3ieLzI05Hj5y3D2OC0ynY3uB7eLTD3hSyG8FRIoVEKhfisER8Zr
odKUlUDI0sWxrFTKIAqVtqokZ2pXN+uVrqp0yNInovKjE7B0cW7qcuPi/q3Ss7XSGEEJkIY6Pqos
VK+FJUDACkUkS4QMBBqRKkuEyCnp2iU+pDTVPg5s9FjhYzAQ2btDlBXzq0GYvYu8eH1ViZVxK+94
Y1yhxMqh+I5LqLTTRgTAV7O0jtRGl7pEKsxQ6dq6RGrlyrBRV+KE6F/eRtOSK3FipaQeq3XkxDr7
7ihu1rm4+XEKEagfHx9AsMvHeeDC6+ISfryxLXSXbb0PDFENAzeyLTCs0BivLpNxMX+cDgdF/iHc
S17FcS+iti6Ke9GA2CfVZixojiLftT6byTcMLnqXln3ROrnLEiPLTDop+wbm5/q0EujXLOWkyKQl
Rj7wnkrKudaweMPtAucGpaFfhqthiX4h0m3mkL1IF+ukm1zZ2gO51qxzLSi/RRCVlWEvLXJhpZwC
FxoXxa9MKzgJ/ErKgYvh1zAxV9ZFM79qQKWitC0QOIzi1/U+JX71XlTr+/ArgjicFb+Skm+Be/Ar
IWkVx6+oqH67ipO3zIiclGqdRRVHtbiirAWqdRZ0WqoFowm+hb4VYD+catvTt8k5V3tc0YrNAtcu
l5TaWeDi0vjUaQlYB1Eu0r+tzJIg81QMAaMJU4JjCBitQnEnyk19NhMwOiZRNO9jLxhSHOcvBNlh
tEpKwRYdmjiHgT1r76IkriY0Kq2vAJaNPPQdYF7tPWj6FiJX4JGDnYXhfNht6xZF3biPdWu96HSa
2jZJFhhYbSNZLKzWrQMfJW7Zyh+nWrNO5nVu6LGZWK1XJs62XW6+Utu2KtY4WLlNJLJtDTF2wLa1
yS0ETcYltm2to07LWnl+1G3bRtQPlrVpybUF94C3GHr7uAfOitrA1D0Bca3XpoZWYmW1hK23Js6d
DRqG49xZbVHkYm7qU3APgIgxLcnu4h7IN5fdSXY398CQ64J7sOWetLuGtSwO1z7uge766VgszQqw
Hx8f9a1L+Z/xdDjPB4v85jR/KvJpcfoM2aGJoG35n8Dxr/kfXB5zHSkgDbbP//zv8j+gDhQ6tLGL
pC1hkJ13kWFmEsUdkoTbMscdkmi0JuqQBAywuOmoZI7ZIrL2CACtddnVABDKw95qAMhBN3aSXjYH
OhEAYkP2ewSAmlHvcgAoPd2C0iuxiuQRoE9mX+uRdOwmU6vEEaC1PrsaAVpmD/nTIkCa5HtUqxEg
MuJE6kYEyLj6uXQfAfqgCNChJyR2g2yBMLWJh9ppFWXi6aCyxKtXJ9Day6fatnZiqZmjIkBkQFxq
+0SA1vrsbASIGdWnRYC8X6HizzLxyDB2/SAadJh83yPiLsDe5QhQcs41yhir24wAtUHAfQQocQSI
YMv3ytqMAHlLaPSnRYCck3dgXWBeo8iS7SNAHxoBasG9dVsyIXu4t2hc3CG1RuvjDqnBeh93SB02
Xxzn3iovf4Nv9xjQepddzQFhrHvQQg7IQROzfrB7m9xHSJ8DYvVCol8/B9SMesdyQG1YCICY2kJA
ORNpasYAK46zEEBWxbVvEbGjyG8RkY20aKNzQOt9djYHxDKY7eaAvF/Re59nIWyxz7qQA9Jgvknc
UoC9zwH1rW9961vf+vah7T9u1YHmAFAAAA==


--nextPart6355879.3B4Dmp7Yhb--



