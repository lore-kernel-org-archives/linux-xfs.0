Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF45C2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C88920784
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nCCr3f1h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbgELX4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 19:56:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50920 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELX4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 19:56:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNrDeF040345;
        Tue, 12 May 2020 23:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Jijn7JpvMQRc6JyN6/NzB5vbFWimLi00HrJyQfm67yQ=;
 b=nCCr3f1h9TZOrjGU+9bCiVVs2d9ntD334q2xKyrsfey6yIClBbiyeHBZ/NzOOxt4HVas
 gJhBJSMLeicTzIJlKh/fHrObJQQRoPPGeZl3toXrUW19EiGyYf12ajF+DnHzm5svuni8
 l5W2MnCvT/RRJ/hIaizNrrGZFtpnPBRdTxZrrew+jn/0JJc3LhczWRfDLM9Y+7DFK9TN
 DZQ0Kx5rnKNgbXEnOfc8vog/vPI7IKxiGUIc3p4n14qsNiQHPnNQHyZo4NXMi1R6iLD3
 g5RolEmoSyRRY4NVmfPtk3VuovhzkITqlOb215mo7m9qHUkYyLA7Jgp/yV0+4yCmAHix HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3100xwh9sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 23:56:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNsZTS095439;
        Tue, 12 May 2020 23:56:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3100ypdaf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 23:56:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CNtx29007414;
        Tue, 12 May 2020 23:56:00 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 16:55:59 -0700
Date:   Tue, 12 May 2020 16:55:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Chiristoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: Use the correct style for SPDX License Identifier
Message-ID: <20200512235557.GU6714@magnolia>
References: <20200502092709.GA20328@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502092709.GA20328@nishad>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 02, 2020 at 02:57:14PM +0530, Nishad Kamdar wrote:
> This patch corrects the SPDX License Identifier style in header files
> related to XFS File System support. For C header files
> Documentation/process/license-rules.rst mandates C-like comments.
> (opposed to C source files where C++ style should be used).
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Looks fine to me I guess,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> Changes in v2:
>  - use up all 73 chars in commit description
> ---
>  fs/xfs/kmem.h                      | 2 +-
>  fs/xfs/libxfs/xfs_ag_resv.h        | 2 +-
>  fs/xfs/libxfs/xfs_alloc.h          | 2 +-
>  fs/xfs/libxfs/xfs_alloc_btree.h    | 2 +-
>  fs/xfs/libxfs/xfs_attr.h           | 2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.h      | 2 +-
>  fs/xfs/libxfs/xfs_attr_remote.h    | 2 +-
>  fs/xfs/libxfs/xfs_attr_sf.h        | 2 +-
>  fs/xfs/libxfs/xfs_bit.h            | 2 +-
>  fs/xfs/libxfs/xfs_bmap.h           | 2 +-
>  fs/xfs/libxfs/xfs_bmap_btree.h     | 2 +-
>  fs/xfs/libxfs/xfs_btree.h          | 2 +-
>  fs/xfs/libxfs/xfs_da_btree.h       | 2 +-
>  fs/xfs/libxfs/xfs_da_format.h      | 2 +-
>  fs/xfs/libxfs/xfs_defer.h          | 2 +-
>  fs/xfs/libxfs/xfs_dir2.h           | 2 +-
>  fs/xfs/libxfs/xfs_dir2_priv.h      | 2 +-
>  fs/xfs/libxfs/xfs_errortag.h       | 2 +-
>  fs/xfs/libxfs/xfs_format.h         | 2 +-
>  fs/xfs/libxfs/xfs_fs.h             | 2 +-
>  fs/xfs/libxfs/xfs_health.h         | 2 +-
>  fs/xfs/libxfs/xfs_ialloc.h         | 2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.h   | 2 +-
>  fs/xfs/libxfs/xfs_inode_buf.h      | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h     | 2 +-
>  fs/xfs/libxfs/xfs_log_format.h     | 2 +-
>  fs/xfs/libxfs/xfs_log_recover.h    | 2 +-
>  fs/xfs/libxfs/xfs_quota_defs.h     | 2 +-
>  fs/xfs/libxfs/xfs_refcount.h       | 2 +-
>  fs/xfs/libxfs/xfs_refcount_btree.h | 2 +-
>  fs/xfs/libxfs/xfs_rmap.h           | 2 +-
>  fs/xfs/libxfs/xfs_rmap_btree.h     | 2 +-
>  fs/xfs/libxfs/xfs_sb.h             | 2 +-
>  fs/xfs/libxfs/xfs_shared.h         | 2 +-
>  fs/xfs/libxfs/xfs_trans_resv.h     | 2 +-
>  fs/xfs/libxfs/xfs_trans_space.h    | 2 +-
>  fs/xfs/libxfs/xfs_types.h          | 2 +-
>  fs/xfs/mrlock.h                    | 2 +-
>  fs/xfs/scrub/bitmap.h              | 2 +-
>  fs/xfs/scrub/btree.h               | 2 +-
>  fs/xfs/scrub/common.h              | 2 +-
>  fs/xfs/scrub/dabtree.h             | 2 +-
>  fs/xfs/scrub/health.h              | 2 +-
>  fs/xfs/scrub/repair.h              | 2 +-
>  fs/xfs/scrub/scrub.h               | 2 +-
>  fs/xfs/scrub/trace.h               | 2 +-
>  fs/xfs/scrub/xfs_scrub.h           | 2 +-
>  fs/xfs/xfs.h                       | 2 +-
>  fs/xfs/xfs_acl.h                   | 2 +-
>  fs/xfs/xfs_aops.h                  | 2 +-
>  fs/xfs/xfs_bmap_item.h             | 2 +-
>  fs/xfs/xfs_bmap_util.h             | 2 +-
>  fs/xfs/xfs_buf.h                   | 2 +-
>  fs/xfs/xfs_buf_item.h              | 2 +-
>  fs/xfs/xfs_dquot.h                 | 2 +-
>  fs/xfs/xfs_dquot_item.h            | 2 +-
>  fs/xfs/xfs_error.h                 | 2 +-
>  fs/xfs/xfs_export.h                | 2 +-
>  fs/xfs/xfs_extent_busy.h           | 2 +-
>  fs/xfs/xfs_extfree_item.h          | 2 +-
>  fs/xfs/xfs_filestream.h            | 2 +-
>  fs/xfs/xfs_fsmap.h                 | 2 +-
>  fs/xfs/xfs_fsops.h                 | 2 +-
>  fs/xfs/xfs_icache.h                | 2 +-
>  fs/xfs/xfs_icreate_item.h          | 2 +-
>  fs/xfs/xfs_inode.h                 | 2 +-
>  fs/xfs/xfs_inode_item.h            | 2 +-
>  fs/xfs/xfs_ioctl.h                 | 2 +-
>  fs/xfs/xfs_ioctl32.h               | 2 +-
>  fs/xfs/xfs_iomap.h                 | 2 +-
>  fs/xfs/xfs_iops.h                  | 2 +-
>  fs/xfs/xfs_itable.h                | 2 +-
>  fs/xfs/xfs_linux.h                 | 2 +-
>  fs/xfs/xfs_log.h                   | 2 +-
>  fs/xfs/xfs_log_priv.h              | 2 +-
>  fs/xfs/xfs_mount.h                 | 2 +-
>  fs/xfs/xfs_mru_cache.h             | 2 +-
>  fs/xfs/xfs_ondisk.h                | 2 +-
>  fs/xfs/xfs_qm.h                    | 2 +-
>  fs/xfs/xfs_quota.h                 | 2 +-
>  fs/xfs/xfs_refcount_item.h         | 2 +-
>  fs/xfs/xfs_reflink.h               | 2 +-
>  fs/xfs/xfs_rmap_item.h             | 2 +-
>  fs/xfs/xfs_rtalloc.h               | 2 +-
>  fs/xfs/xfs_stats.h                 | 2 +-
>  fs/xfs/xfs_super.h                 | 2 +-
>  fs/xfs/xfs_symlink.h               | 2 +-
>  fs/xfs/xfs_sysctl.h                | 2 +-
>  fs/xfs/xfs_sysfs.h                 | 2 +-
>  fs/xfs/xfs_trace.h                 | 2 +-
>  fs/xfs/xfs_trans.h                 | 2 +-
>  fs/xfs/xfs_trans_priv.h            | 2 +-
>  92 files changed, 92 insertions(+), 92 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 6143117770e9..fc87ea9f6843 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index c0352edc8e41..f3fd0ee9a7f7 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0+
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index a851bf77f17b..6c22b12176b8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> index 047f09f0be3c..a5b998e950fe 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0d2d05908537..db4717657ca1 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000,2002-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 6dd2d937a42a..5be6be309302 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000,2002-2003,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 6fb4572845ce..e1144f22b005 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index aafa4fe70624..bb004fb7944a 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_bit.h b/fs/xfs/libxfs/xfs_bit.h
> index 99017b8df292..a04f266ae644 100644
> --- a/fs/xfs/libxfs/xfs_bit.h
> +++ b/fs/xfs/libxfs/xfs_bit.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index f3259ad5c22c..6028a3c825ba 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index 29b407d053b4..72bf74c79fb9 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000,2002-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 8626c5a81aad..10e50cbacacf 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 53e503b6f186..6e25de6621e4 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 08c0a4d98b89..059ac108b1b3 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 7c28d7608ac6..d119f0fda166 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0+
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 033777e282f2..e55378640b05 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 01ee0b926572..44c6a77cba05 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 79e6c4fb1d8a..9c58ab8648f5 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0+
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * Copyright (C) 2017 Oracle.
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 592f1c12ad36..f2228d9e317a 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 245188e4f6d3..84bcffa87753 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: LGPL-2.1
> +/* SPDX-License-Identifier: LGPL-2.1 */
>  /*
>   * Copyright (c) 1995-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index 272005ac8c88..99e796256c5d 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0+
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * Copyright (C) 2019 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> diff --git a/fs/xfs/l
