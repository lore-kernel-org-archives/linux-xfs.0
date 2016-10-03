Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38372 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752275AbcJCPBO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Oct 2016 11:01:14 -0400
Subject: Re: [PATCH] xfs: add XBF_XBF_NO_IOACCT to buf trace output
References: <4074f575-f4cf-e8ee-7c79-0bbc45333f5d@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <41ae7c95-cdfc-ed01-a213-a9a7c4f49447@sandeen.net>
Date: Mon, 3 Oct 2016 10:01:12 -0500
MIME-Version: 1.0
In-Reply-To: <4074f575-f4cf-e8ee-7c79-0bbc45333f5d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org

Ping?

On 9/8/16 4:53 PM, Eric Sandeen wrote:
> When XBF_NO_IOACCT got added, it missed the translation
> in XFS_BUF_FLAGS, so we see "0x8" in trace output rather
> than the flag name.  Fix it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 1c2e52b..424f6b0 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -71,6 +71,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_READ,		"READ" }, \
>  	{ XBF_WRITE,		"WRITE" }, \
>  	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
> +	{ XBF_NO_IOACCT,	"NO_IOACCT" }, \
>  	{ XBF_ASYNC,		"ASYNC" }, \
>  	{ XBF_DONE,		"DONE" }, \
>  	{ XBF_STALE,		"STALE" }, \
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
