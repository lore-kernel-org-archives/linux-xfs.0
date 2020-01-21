Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DD4C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA0C324655
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d4BVX5zs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAUXPf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:15:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAUXPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 18:15:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LND4lw051090
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:15:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0OrA2VfY1130k5aFiFB3BeCDv9S9axKvW7SIHDOmD1o=;
 b=d4BVX5zssj4jbr5hBhEiGPqLmJ7PQ+6yFNjPObgeU0g+5bb12ZTrqXPD/zF5XTMhgYcP
 +jGdRNcAzuuZtigAAOHecr2+fWbkn9WuDcDYi0Tk+/5CwX9xRfG2k2TJ56JEAi9dgZ9y
 C9kQ/km4ylswvW0wVlMl7jAAQdKr0hNdiQMfmghsnajYYLscD2Yh9V3Hvqiq30SCkjfR
 Vi1/BUnCOUU/u41XPtxSAjmVt4kwT2NW3x+uyy+BfnD74f8YERaWmD5NFl5wj5rWLg9x
 kzXYcaq23NF1HUtOoESx0v3vNrjX0/fZvw7ayXH2FLvZbFMsEaTHM4u9RcmMcyT81oRk FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseugg85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:15:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LNEK0W086439
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:15:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xnpfpy2ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:15:32 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LNFVOI002430
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:15:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 15:15:31 -0800
Date:   Tue, 21 Jan 2020 15:15:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 11/16] xfs: Check for -ENOATTR or -EEXIST
Message-ID: <20200121231530.GK8247@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118225035.19503-12-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 03:50:30PM -0700, Allison Collins wrote:
> Delayed operations cannot return error codes.  So we must check for
> these conditions first before starting set or remove operations

Answering my own question from earlier -- I see here you actually /are/
checking the attr existence w.r.t. ATTR_{CREATE,REPLACE} right after we
allocate a transaction and ILOCK the inode, so

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Though I am wondering if you could discard the predicates from the
second patch in favor of doing a normal lookup of the attr with a zero
valuelen to determine if there's already an attribute?

--D

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a2673fe..e9d22c1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -457,6 +457,14 @@ xfs_attr_set(
>  		goto out_trans_cancel;
>  
>  	xfs_trans_ijoin(args.trans, dp, 0);
> +
> +	error = xfs_has_attr(&args);
> +	if (error == -EEXIST && (name->type & ATTR_CREATE))
> +		goto out_trans_cancel;
> +
> +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
> +		goto out_trans_cancel;
> +
>  	error = xfs_attr_set_args(&args);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -545,6 +553,10 @@ xfs_attr_remove(
>  	 */
>  	xfs_trans_ijoin(args.trans, dp, 0);
>  
> +	error = xfs_has_attr(&args);
> +	if (error != -EEXIST)
> +		goto out;
> +
>  	error = xfs_attr_remove_args(&args);
>  	if (error)
>  		goto out;
> -- 
> 2.7.4
> 
