Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6332CC3F2C6
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33DC8246A4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:32:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DiJFMh6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgB0Xb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 18:31:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52410 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB0Xb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 18:31:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNRwu5049027;
        Thu, 27 Feb 2020 23:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=p+s3Q7xn+oBQjfw/W33Or6HoAVCnrOndmmH4w4MKm7s=;
 b=DiJFMh6LKLgWly/M2gV5u7XRO7+kD45MrM1IkOYWKd17EVvi8qGuTem/XlvnCLnLWgx+
 qlu+nECNxNhl5PVYH8oQN6JMH8ppbmbf5fuAY6Hgx9SsqV9XqkvtBpfjjji70qYXJBpz
 b6y9EyjFVrnUdHMpccxd36czc0cHpnmuXKcJB8i+Cjs0QqihESzWbWNxFK6CT47Te6m6
 768LKxZpxFEc4cMQ/sErk6ErAStfrq4pkSX34fcpIobM7WRzzAIMhQCPnw//8LCIVbXp
 Jj6PR/haHvgQZD3AtBg/XZHPwwSFjfBGsgbU//tHzcrf7Ask40j8YwRTk52x2fRPFsqp pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ydcsnp8mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:31:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNQqvY105548;
        Thu, 27 Feb 2020 23:31:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ydcsdmvst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:31:55 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RNVsox029191;
        Thu, 27 Feb 2020 23:31:54 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 15:31:53 -0800
Date:   Thu, 27 Feb 2020 15:31:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 2/9] xfs: introduce ->tr_relog transaction
Message-ID: <20200227233153.GQ8045@magnolia>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227134321.7238-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:43:14AM -0500, Brian Foster wrote:
> Create a transaction reservation specifically for relog
> transactions. For now it only supports the quotaoff intent, so use
> the associated reservation.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 15 +++++++++++++++
>  fs/xfs/libxfs/xfs_trans_resv.h |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 7a9c04920505..1f5c9e6e1afc 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -832,6 +832,17 @@ xfs_calc_sb_reservation(
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  }
>  
> +/*
> + * Internal relog transaction.
> + *   quotaoff intent
> + */
> +STATIC uint
> +xfs_calc_relog_reservation(
> +	struct xfs_mount	*mp)
> +{
> +	return xfs_calc_qm_quotaoff_reservation(mp);

So when we add the next reloggable intent item, this will turn this
into an n-way max(sizeof(type0), sizeof(type1), ...sizeof(typeN)); ?

> +}
> +
>  void
>  xfs_trans_resv_calc(
>  	struct xfs_mount	*mp,
> @@ -946,4 +957,8 @@ xfs_trans_resv_calc(
>  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
>  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
>  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> +
> +	resp->tr_relog.tr_logres = xfs_calc_relog_reservation(mp);
> +	resp->tr_relog.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;

Relog operations can roll?  I would have figured that you'd simply log
the old item(s) in a new transaction and commit it, along with some
magic to let the log tail move forward.  I guess I'll see what happens
in the next 7 patches. :)

--D

> +	resp->tr_relog.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  }
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 7241ab28cf84..b723979cad09 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -50,6 +50,7 @@ struct xfs_trans_resv {
>  	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
>  	struct xfs_trans_res	tr_sb;		/* modify superblock */
>  	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
> +	struct xfs_trans_res	tr_relog;	/* internal relog transaction */
>  };
>  
>  /* shorthand way of accessing reservation structure */
> -- 
> 2.21.1
> 
