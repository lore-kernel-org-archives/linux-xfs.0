Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387424AbeITS0Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Sep 2018 14:26:16 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4CF086668
        for <linux-xfs@vger.kernel.org>; Thu, 20 Sep 2018 12:42:57 +0000 (UTC)
Date: Thu, 20 Sep 2018 07:42:52 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfsprogs: define xfs_stack_trace() for debug builds
Message-ID: <20180920124252.GA745@redhat.com>
References: <d260b935-c518-1fdb-c728-84db5a1224a8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d260b935-c518-1fdb-c728-84db5a1224a8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Sep 19, 2018 at 03:19:14PM -0500, Eric Sandeen wrote:
> Building with -DDEBUG fails due to lack of an xfs_stack_trace def'n.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 2f2ca06..b6746ca 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -118,6 +118,8 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
>  #define xfs_alert_tag(mp,tag,fmt,args...)	cmn_err(CE_ALERT,fmt, ## args)
>  
>  #define xfs_hex_dump(d,n)		((void) 0)
> +#define xfs_stack_trace()		((void) 0)
> +
>  
>  #define xfs_force_shutdown(d,n)		((void) 0)
>  
> 
