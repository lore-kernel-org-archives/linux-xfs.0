Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A395EC2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 17:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C33424125
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 17:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="erfAZNAh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgAUR57 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 12:57:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUR57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 12:57:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LHm7Gk174008;
        Tue, 21 Jan 2020 17:57:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=V6PObDK/qgfkvjmFLAHQZ1AjmDLEYNWBN2Wj9R5SEjM=;
 b=erfAZNAhNNsQpnp7tJFJPZVlv0/hc5U4K+VM3ewn+Tv+5m9ZO5wvjj/1/VfT8tBfyNtU
 s/zTzHPsyE9NVMZJwPLveuAeEscQf6H/gJuIHaqptgZFMUhLnPDCwPdEZBBbotrVdBg2
 2gy5xwUAZNpA+Izzx7J0nDA2lMeXgbgSiwJujDezNXa8xHlimac+0jUF85CFlga80mF7
 9Jba6ntMKOP0ZSI83Hcoe9rAsG+4GbcWBFT/vE/sQrANuzIeWeplMEh6JLOOJf2S+5MG
 BqHeRyH2qd22Q44WPuoFyNU3v/v/r2CRAY5FbNqxtVPrsFqWdETjRp5MmV8zkJQ/BFFo fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseuevfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 17:57:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LHmhsj061209;
        Tue, 21 Jan 2020 17:57:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xnpfpfdpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 17:57:54 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LHvr0k024712;
        Tue, 21 Jan 2020 17:57:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 09:57:53 -0800
Date:   Tue, 21 Jan 2020 09:57:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 06/29] xfs: remove the name == NULL check from
 xfs_attr_args_init
Message-ID: <20200121175752.GG8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-7-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:28AM +0100, Christoph Hellwig wrote:
> All callers provide a valid name pointer, remove the redundant check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hm.  I wondered if this should become at least an ASSERT(name != NULL)
to catch future users screwing that up, but I think the answer is that
we'll crash soon enough in xfs_da_hashname?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 04431ab9f5f5..d5064213577c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -65,10 +65,6 @@ xfs_attr_args_init(
>  	size_t			namelen,
>  	int			flags)
>  {
> -
> -	if (!name)
> -		return -EINVAL;
> -
>  	memset(args, 0, sizeof(*args));
>  	args->geo = dp->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
> -- 
> 2.24.1
> 
