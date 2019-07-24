Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfGXILx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 04:11:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O896Xd122348
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:51 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tx61bunmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O88Br5145826
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tx60x389n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6O8BnN3011508
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:49 GMT
Date: Wed, 24 Jul 2019 11:11:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] xfs: introduce v5 inode group structure
Message-ID: <20190724081143.GA30722@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hello Darrick J. Wong,

The patch 5f19c7fc6873: "xfs: introduce v5 inode group structure"
from Jul 3, 2019, leads to the following static checker warning:

	fs/xfs/xfs_ioctl.c:738 xfs_fsinumbers_fmt()
	warn: check that 'ig1' doesn't leak information (struct has a hole after 'xi_alloccount')

fs/xfs/xfs_ioctl.c
   730  int
   731  xfs_fsinumbers_fmt(
   732          struct xfs_ibulk                *breq,
   733          const struct xfs_inumbers       *igrp)
   734  {
   735          struct xfs_inogrp               ig1;
   736  
   737          xfs_inumbers_to_inogrp(&ig1, igrp);

The xfs_inumbers_to_inogrp() call doesn't clear the struct hole.

   738          if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
   739                  return -EFAULT;
   740          return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
   741  }

regards,
dan carpenter
