Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A0DC54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC71B20738
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:21:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ljNCJv1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgD0RV3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:21:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34570 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgD0RV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:21:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHJOgl028219;
        Mon, 27 Apr 2020 17:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=j/03FdkUCdFLwyDTKR8GFWYFUIxkHgKyLSQX7W5BimU=;
 b=ljNCJv1dLyC4+y0/Dvh8bsd4cd3UI2xrWCFs+CyKGbLpcysy2yZJaV8iVam3m4ysO/Xj
 OWq60REavmpWK7oqY2Ph//MRYo9NRpCG1u7AUDrBRgHa03aF+oilsx6J9A5ikpo0qYrT
 Lly6Nk9ZtVX7pHYHu3TBnDC5nON9CE0l5JuuRj2FR+GTJnmMW4uOS7vWeSIigYklXXBm
 weQobbs0Htp54zE1kKybmq5pAch90/6vhygkVVhkOKzJite5XR8/yDB0Ags3G2AthCq9
 idSO2NAgEG8ScqVdDZJKCgbpDHdB6vO5c4yepeyL/Uir+p6VDjIeSSpkaLAPuyvMJVE8 xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30p2p00cpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:21:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHGuUK105752;
        Mon, 27 Apr 2020 17:21:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30my0a201g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:21:24 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RHLNq2014724;
        Mon, 27 Apr 2020 17:21:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 10:21:23 -0700
Date:   Mon, 27 Apr 2020 10:21:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: define printk_once variants for xfs messages
Message-ID: <20200427172122.GR6742@magnolia>
References: <c3aee5bb-806a-d51d-0c0f-b0d6a10fa737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3aee5bb-806a-d51d-0c0f-b0d6a10fa737@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 09:36:34PM -0500, Eric Sandeen wrote:
> There are a couple places where we directly call printk_once() and one
> of them doesn't follow the standard xfs subsystem printk format as a
> result.
> 
> #define printk_once variants to go with our existing printk_ratelimited
> #defines so we can do one-shot printks in a consistent manner.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 0b05e10995a0..802a96190d22 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -31,15 +31,27 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
>  }
>  #endif
>  
> -#define xfs_printk_ratelimited(func, dev, fmt, ...)		\
> +#define xfs_printk_ratelimited(func, dev, fmt, ...)			\
>  do {									\
>  	static DEFINE_RATELIMIT_STATE(_rs,				\
>  				      DEFAULT_RATELIMIT_INTERVAL,	\
>  				      DEFAULT_RATELIMIT_BURST);		\
>  	if (__ratelimit(&_rs))						\
> -		func(dev, fmt, ##__VA_ARGS__);			\
> +		func(dev, fmt, ##__VA_ARGS__);				\
>  } while (0)
>  
> +#define xfs_printk_once(func, dev, fmt, ...)			\
> +({								\
> +	static bool __section(.data.once) __print_once;		\
> +	bool __ret_print_once = !__print_once; 			\
> +								\
> +	if (!__print_once) {					\
> +		__print_once = true;				\
> +		func(dev, fmt, ##__VA_ARGS__);			\
> +	}							\
> +	unlikely(__ret_print_once);				\
> +})
> +
>  #define xfs_emerg_ratelimited(dev, fmt, ...)				\
>  	xfs_printk_ratelimited(xfs_emerg, dev, fmt, ##__VA_ARGS__)
>  #define xfs_alert_ratelimited(dev, fmt, ...)				\
> @@ -57,6 +69,11 @@ do {									\
>  #define xfs_debug_ratelimited(dev, fmt, ...)				\
>  	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
>  
> +#define xfs_warn_once(dev, fmt, ...)				\
> +	xfs_printk_once(xfs_warn, dev, fmt, ##__VA_ARGS__)
> +#define xfs_notice_once(dev, fmt, ...)				\
> +	xfs_printk_once(xfs_notice, dev, fmt, ##__VA_ARGS__)
> +
>  void assfail(struct xfs_mount *mp, char *expr, char *f, int l);
>  void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c5513e5a226a..bb91f04266b9 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1300,10 +1300,9 @@ xfs_mod_fdblocks(
>  		spin_unlock(&mp->m_sb_lock);
>  		return 0;
>  	}
> -	printk_once(KERN_WARNING
> -		"Filesystem \"%s\": reserve blocks depleted! "
> -		"Consider increasing reserve pool size.",
> -		mp->m_super->s_id);
> +	xfs_warn_once(mp,
> +"Reserve blocks depleted! Consider increasing reserve pool size.");
> +
>  fdblocks_enospc:
>  	spin_unlock(&mp->m_sb_lock);
>  	return -ENOSPC;
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index bb3008d390aa..b101feb2aab4 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -58,9 +58,8 @@ xfs_fs_get_uuid(
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
>  
> -	printk_once(KERN_NOTICE
> -"XFS (%s): using experimental pNFS feature, use at your own risk!\n",
> -		mp->m_super->s_id);
> +	xfs_notice_once(mp,
> +"Using experimental pNFS feature, use at your own risk!");
>  
>  	if (*len < sizeof(uuid_t))
>  		return -EINVAL;
> 
