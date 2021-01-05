Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5D1C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 05:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D886722597
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 05:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbhAEFiw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 00:38:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbhAEFiw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 00:38:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1055ZipO110759
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NPZsAflwKKi2v2ir+gxDW8RlYhpLMHXrTCjmOS4RwVk=;
 b=0C/PGi287H34lsxzq+c5jZZ+dvcOttxbj/fgZ59mAqm9cg91ib9q6I6kokdgtDW5LfS8
 L6pVY0h0s21xz/G85aPyHi5tNhwZmTO9ZvzY0x9l/keCKjCCblf7fEvayLcaFsOYFB4d
 bLqbt9fGtVFrbXE5D9TGfHo5UAJ/IH5lFV2wKv8xCWua+xL4R8++W2sWsp6YtIKkzFmm
 4JgfV1TSepSi96chmvuumLg7hRcC4c0i3sOjK3eZgNmKoGIjxjY0BToNCXpYc82F07wg
 Va8N5P3W5hGOT9l+EP6SZZW2qJEr5XH1bBQtIU956wHQaecqDatLxovpeIq6SYK2rupb iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35tg8qy9jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 05:38:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1055aLJH039398
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:38:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35v1f86dkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 05:38:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1055c8qG012187
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:38:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 21:38:08 -0800
Date:   Mon, 4 Jan 2021 21:38:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 08/15] xfs: Handle krealloc errors in
 xlog_recover_add_to_cont_trans
Message-ID: <20210105053807.GU6918@magnolia>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218072917.16805-9-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050034
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 18, 2020 at 12:29:10AM -0700, Allison Henderson wrote:
> Because xattrs can be over a page in size, we need to handle possible
> krealloc errors to avoid warnings

Which warnings?

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_log_recover.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 97f3130..295a5c6 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2061,7 +2061,10 @@ xlog_recover_add_to_cont_trans(
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>  
> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);

Does the removal of NOFAIL increase the likelihood that log recovery
will fail instead of looping around looking for more memory?

Hm, what /are/ we doing here, anyway?  I guess someone logged a gigantic
xattri item, which gets split across multiple log records, and now we're
trying to staple all that back together?  And perhaps the xattri item is
larger than a ... page(?) which causes dmesg warnings when combined with
NOFAIL?

--D

> +	if (ptr == NULL)
> +		return -ENOMEM;
> +
>  	memcpy(&ptr[old_len], dp, len);
>  	item->ri_buf[item->ri_cnt-1].i_len += len;
>  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> -- 
> 2.7.4
> 
