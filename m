Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56506 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387503AbfGXPTg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:19:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OF8vRh001023
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:19:35 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tx61bx6ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:19:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OF7iPi114322
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:19:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tx60y52gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:19:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6OFJYpw010194
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:19:34 GMT
Date: Wed, 24 Jul 2019 08:19:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [bug report] xfs: introduce v5 inode group structure
Message-ID: <20190724151933.GB1561054@magnolia>
References: <20190724081143.GA30722@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724081143.GA30722@mwanda>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 24, 2019 at 11:11:43AM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch 5f19c7fc6873: "xfs: introduce v5 inode group structure"
> from Jul 3, 2019, leads to the following static checker warning:
> 
> 	fs/xfs/xfs_ioctl.c:738 xfs_fsinumbers_fmt()
> 	warn: check that 'ig1' doesn't leak information (struct has a hole after 'xi_alloccount')
> 
> fs/xfs/xfs_ioctl.c
>    730  int
>    731  xfs_fsinumbers_fmt(
>    732          struct xfs_ibulk                *breq,
>    733          const struct xfs_inumbers       *igrp)
>    734  {
>    735          struct xfs_inogrp               ig1;

Heh, yeah, that looks like a bug.  Expect a patch soon, thanks for
finding this. :/

--D

>    736  
>    737          xfs_inumbers_to_inogrp(&ig1, igrp);
> 
> The xfs_inumbers_to_inogrp() call doesn't clear the struct hole.
> 
>    738          if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
>    739                  return -EFAULT;
>    740          return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
>    741  }
> 
> regards,
> dan carpenter
