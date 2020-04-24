Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBB0C54FCB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 11:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2F42087E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 11:44:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DikCtli5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXLop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:44:45 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44955 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726668AbgDXLop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 07:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587728683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UTGriZpPGdFlX4HepYpncxvNzDjObf/wLasCSQztmUw=;
        b=DikCtli515kljMOcE8uiB/xPNNMqXH7iWHnn0cX4QNLpXQYq3CtBEBwmjf9WemC3eHPOt+
        qMff1pxZubDFzXUT2XErpuc2Jalv2wG7pBLuLcD2+YWV9Wn+HwSWo3Mx4ed2PursFf+2jH
        wKySQppN72RbaayTl0JxdTqUcgRIkH0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-GS4kE7DUNYCk3giozzDjig-1; Fri, 24 Apr 2020 07:44:39 -0400
X-MC-Unique: GS4kE7DUNYCk3giozzDjig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97F4B1899539
        for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2020 11:44:38 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 226F95D9D7;
        Fri, 24 Apr 2020 11:44:35 +0000 (UTC)
Date:   Fri, 24 Apr 2020 07:44:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: define printk_once variants for xfs messages
Message-ID: <20200424114433.GA53690@bfoster>
References: <c3aee5bb-806a-d51d-0c0f-b0d6a10fa737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3aee5bb-806a-d51d-0c0f-b0d6a10fa737@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
> ---

LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

