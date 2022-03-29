Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB739C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 13:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiC2NFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 09:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbiC2NFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 09:05:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA5B2B1A4
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 06:04:01 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C65E2210FC;
        Tue, 29 Mar 2022 13:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648559039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YK9lMo/OgMJ93/gMXmyigUxJEYT4U8w/I0AKiGNIeCg=;
        b=BunS35rg7hv29UVKJiRPiukLzsmjqHIYQh5386AYpD3jCWvpMSrDlAnig7jRtKHBAEwZrF
        6Sh4iiKhPoH7k12CDhEj8EvRKoT8R4aymPjLEixQiPfFhLkZO/fSyRNPfAbtusLhiIJgxX
        PiqDXyVKXmIy+9VcHj8jclnPU3ijPyA=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 84917A3B83;
        Tue, 29 Mar 2022 13:03:59 +0000 (UTC)
Date:   Tue, 29 Mar 2022 15:03:56 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 1/2] Simplify XFS logging methods.
Message-ID: <YkMDvMy0QOg2mo99@alley>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri 2022-03-25 10:19:45, Jonathan Lassoff wrote:
> Rather than have a constructor to define many nearly-identical
> functions, use preprocessor macros to pass down a kernel logging level
> to a common function.
> 
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index bb9860ec9a93..2f609800e806 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -6,33 +6,36 @@
> -void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
> -{
> -}
> +#define xfs_debug(mp, fmt, ...) do {} while (0)
>  #endif
>  
> +extern __printf(3, 4)
> +void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);

The trend is to avoid "extern" because it just creates noise. Well, I
am not sure what are the preferences in the XFS code.

Otherwise the changes look fine to me. Feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
