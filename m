Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92764C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74BCF208B6
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GSE3YdBQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgFHRbO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 13:31:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbgFHRbN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 13:31:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058HSRSC196256;
        Mon, 8 Jun 2020 17:31:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZzhH++0XCk4gDWLAz6paompbAJX2yCyIw+oZjSsB3S4=;
 b=GSE3YdBQx3N++BQSHsY0tZoS9AbzKSWoRIwmYgwqQXKXZWRJhhjG0uZEvxu4LTmXB4WN
 8d4diwCefCdICJTL0sk08WE/NuvH4cjHWhuIPsbirJd3I+7+/Q6aZ58zi27HC54P8Eez
 iPzFg3qe0E2XrtjPnmBhl4qgOXiiAWRdiSvB8GKHDX9KEUJdM3Av7Pe4E3Zt0J4TlGA5
 TLRQFQsL3PVBwQMuoMALIJnW3E4cHHdUGERKMIdFbZTtbIxyxLP2uvnfql7LV7EimyVy
 26xJe9sR+4DmeJST3TfJjo5wJdW1cIRFxQ13AbbRT4jSzPyBNxGdYRb9E1XbzwAh8/gG jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31g2jr04wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 17:31:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058HSNiw150832;
        Mon, 8 Jun 2020 17:31:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31gmwq834s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 17:31:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 058HV4HD021802;
        Mon, 8 Jun 2020 17:31:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 10:31:04 -0700
Date:   Mon, 8 Jun 2020 10:31:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 0/7] xfs: Extend per-inode extent counters.
Message-ID: <20200608173103.GH1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606082745.15174-1-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 01:57:38PM +0530, Chandan Babu R wrote:
> The commit xfs: fix inode fork extent count overflow
> (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
> per-inode data fork extents should be possible to create. However the
> corresponding on-disk field has an signed 32-bit type. Hence this
> patchset extends the on-disk field to 64-bit length out of which only
> the first 47-bits are valid.
> 
> Also, XFS has a per-inode xattr extent counter which is 16 bits
> wide. A workload which
> 1. Creates 1 million 255-byte sized xattrs,
> 2. Deletes 50% of these xattrs in an alternating manner,
> 3. Tries to insert 400,000 new 255-byte sized xattrs
> causes the following message to be printed on the console,
> 
> XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173
> 
> This indicates that we overflowed the 16-bits wide xattr extent
> counter.
> 
> I have been informed that there are instances where a single file
> has > 100 million hardlinks. With parent pointers being stored in xattr,
> we will overflow the 16-bits wide xattr extent counter when large
> number of hardlinks are created. Hence this patchset extends the
> on-disk field to 32-bit length.
> 
> This patchset also includes the previously posted "Fix log reservation
> calculation for xattr insert operation" patch as a bug fix. It
> replaces the xattr set "mount" and "runtime" reservations with just
> one static reservation. Hence we don't need the functionality to
> calculate maximum sized 'xattr set' reservation separately anymore.
> 
> The patches can also be obtained from
> https://github.com/chandanr/linux.git at branch xfs-extend-extent-counters.
> 
> Chandan Babu R (7):
>   xfs: Fix log reservation calculation for xattr insert operation

What happened to that whole patchset with struct xfs_attr_set_resv
and whatnot?  Did all that get condensed down to this single patch?

--D

>   xfs: Check for per-inode extent count overflow
>   xfs: Compute maximum height of directory BMBT separately
>   xfs: Add "Use Dir BMBT height" argument to XFS_BM_MAXLEVELS()
>   xfs: Use 2^27 as the maximum number of directory extents
>   xfs: Extend data extent counter to 47 bits
>   xfs: Extend attr extent counter to 32 bits
> 
>  fs/xfs/libxfs/xfs_attr.c        |  11 +--
>  fs/xfs/libxfs/xfs_bmap.c        | 118 +++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_bmap.h        |   3 +-
>  fs/xfs/libxfs/xfs_bmap_btree.h  |   4 +-
>  fs/xfs/libxfs/xfs_format.h      |  49 ++++++++++---
>  fs/xfs/libxfs/xfs_inode_buf.c   |  65 ++++++++++++++---
>  fs/xfs/libxfs/xfs_inode_buf.h   |   2 +
>  fs/xfs/libxfs/xfs_inode_fork.c  | 125 ++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_inode_fork.h  |   2 +
>  fs/xfs/libxfs/xfs_log_format.h  |   8 +-
>  fs/xfs/libxfs/xfs_log_rlimit.c  |  29 --------
>  fs/xfs/libxfs/xfs_trans_resv.c  |  75 +++++++++----------
>  fs/xfs/libxfs/xfs_trans_resv.h  |   9 +--
>  fs/xfs/libxfs/xfs_trans_space.h |  48 ++++++------
>  fs/xfs/libxfs/xfs_types.h       |  11 ++-
>  fs/xfs/scrub/inode.c            |  14 ++--
>  fs/xfs/xfs_bmap_item.c          |   3 +-
>  fs/xfs/xfs_inode.c              |  10 ++-
>  fs/xfs/xfs_inode_item.c         |  10 ++-
>  fs/xfs/xfs_inode_item_recover.c |  22 +++++-
>  fs/xfs/xfs_mount.c              |   5 +-
>  fs/xfs/xfs_mount.h              |   1 +
>  fs/xfs/xfs_reflink.c            |   4 +-
>  23 files changed, 451 insertions(+), 177 deletions(-)
> 
> -- 
> 2.20.1
> 
