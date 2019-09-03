Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738DAC3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 14:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4659C20828
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 14:41:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dS+eyeIg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfICOlA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:41:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34226 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfICOlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 10:41:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83EcoGx124134;
        Tue, 3 Sep 2019 14:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VS4nMVpWftR2GnwcUMmDGUT73xAzA5lDi1AzhVVBhNo=;
 b=dS+eyeIgbejTB8gs2bLdXaBEETtT7WtV/fdRBf+2hvdsD5gmYQQRcMLpwl2WfSCv3A1s
 Ce3zAAEGNBjcv3SVV2QJ9ZYGLwHA7twG+Mne2HO590Z6ukzUvF5fw0gPzjnH01DKE+dV
 TcOzhC8oJTgLF9yD8xw8WZfrWkMC/AC33pkqf57TrgXGXmYUAZ//EpGrEC4SQBubZh+g
 tWJMP3SSKfuKiMZQFDMmnrbKHZdRi04XAQk/m1vbl+ECqPkttNNPOR3W865pwDjyMLb7
 uQTJF/aXCjSrGj30W7Q7rwnIFMl3gGRqiZM+4nhlJg+hOsMMQGQLHS6x3FkvAcPcWqKG bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ussxpr332-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 14:40:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83Ecb8W142326;
        Tue, 3 Sep 2019 14:40:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2us5pgx93p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 14:40:52 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x83Eep0I006927;
        Tue, 3 Sep 2019 14:40:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 07:40:51 -0700
Date:   Tue, 3 Sep 2019 07:40:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH v3] xfsprogs: provide a few compatibility typedefs
Message-ID: <20190903144054.GW5354@magnolia>
References: <20190903125845.3117-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903125845.3117-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 02:58:45PM +0200, Christoph Hellwig wrote:
> Add back four typedefs that allow xfsdump to compile against the
> headers from the latests xfsprogs.
> 
> Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok (though really I looked at the previous broken version and
look how far that got us :P)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  include/xfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/xfs.h b/include/xfs.h
> index f2f675df..9c03d6bd 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -37,4 +37,13 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
>  #include <xfs/xfs_types.h>
>  #include <xfs/xfs_fs.h>
>  
> +/*
> + * Backards compatibility for users of this header, now that the kernel
> + * removed these typedefs from xfs_fs.h.
> + */
> +typedef struct xfs_bstat xfs_bstat_t;
> +typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
> +typedef struct xfs_fsop_geom_v1 xfs_fsop_geom_v1_t;
> +typedef struct xfs_inogrp xfs_inogrp_t;
> +
>  #endif	/* __XFS_H__ */
> -- 
> 2.20.1
> 
