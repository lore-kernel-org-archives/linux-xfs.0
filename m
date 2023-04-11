Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC6FC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDKX7I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDKX7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:59:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB28D8
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:59:07 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pc4-20020a17090b3b8400b0024676052044so9808586pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681257546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6/9y70NPtbVwQ93L71+hmmmV1Tt7sDX8vYuZUXq/78g=;
        b=ddobEaHX3Zih1EN8/eea1NXkJWIkylv/9YwpmRfjQy9YLfRBhSD13nhLDiK6UXJKIz
         YlpbN+PDIf679vYQb7khTRq4OA7s1WpHXOnTx6W6AIvuNiQOGQZXkSxXY2k5L0Cdmt/W
         cNHJYsT2GSgzIbwV541Eg0TLgyUBTaw1ZWLiSusJrjtJHbY3cBNvIhBe5Qh8H/gDpFmF
         2yO6oODX5p8mGxHALn66Uc5mVlfuwE0rjzA9X89pQsKnfWqSc9VTpxCtrHdw3IuURVkJ
         dEvrOXozUJCSx5kqbvl7qrwsbLcWUOZC52r6qmmqsetDH4vxTiQIaX9DzAHuOKZiozZN
         qjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681257546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/9y70NPtbVwQ93L71+hmmmV1Tt7sDX8vYuZUXq/78g=;
        b=KXy6wiLTZbl1dUwUDs8/xksBEYExPV2TWFZ0jLU7xnFjODg6ADUMfR+oRPf2I/nJMN
         5ma9g4dim1epv305NXTBkeweIzUehEyZEhJ53pqhkXon/hDDxYxlNrYWt802/BxiEjWA
         IS1Yo2iAi7bS+iQ2gxG6Nwg8Ny5EOd3OAxrteMAz/jLML+zvQdFbC0sGC/5XtaroKdhT
         aItetS65B6YsDCMfADRpq1Qrrspssy5Ahm4+gB7wX3GYiQ3mbul3QuPMKD+Or00z2AFA
         bOyKfClFVwysJJEfhlRAO/YhQPzu+Ajr//VVZMOajZkSN4iNWY6TT9UoqBbE3cEvGOeM
         Uc8Q==
X-Gm-Message-State: AAQBX9dYEYBimzdtsjLolTvLJO5ibbvVOJMFzZ/E3ovWpwouTbZWHwcF
        zQw63fJHR6ittpWDbChw0JnHmA==
X-Google-Smtp-Source: AKy350aeksThdRxTI12cPaWX+GsIktG2/xCWHy2PJitL45ymk3jF78iYzRE5CrIMxUKXvDk9efqOEA==
X-Received: by 2002:a17:903:2286:b0:1a5:7958:a75 with SMTP id b6-20020a170903228600b001a579580a75mr14623222plh.54.1681257546603;
        Tue, 11 Apr 2023 16:59:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id o2-20020a170902bcc200b001a1ca6dc38csm10209101pls.118.2023.04.11.16.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 16:59:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmNt9-002HuN-3q; Wed, 12 Apr 2023 09:59:03 +1000
Date:   Wed, 12 Apr 2023 09:59:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: fix inverted logic in error path
Message-ID: <20230411235903.GF3223426@dread.disaster.area>
References: <20230411174644.GI360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411174644.GI360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 10:46:44AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> smatch complains proceeding into the if body if leaf is a null pointer.
> This is backwards, so correct that.
> 
> check.c:3455 process_leaf_node_dir_v2_int() warn: variable dereferenced before check 'leaf'
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/check.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/check.c b/db/check.c
> index 964756d0..d5f3d225 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -3452,7 +3452,7 @@ process_leaf_node_dir_v2_int(
>  				 id->ino, dabno, stale,
>  				 be16_to_cpu(leaf3->hdr.stale));
>  		error++;
> -	} else if (!leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
> +	} else if (leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
>  		if (!sflag || v)
>  			dbprintf(_("dir %lld block %d stale mismatch "
>  				 "%d/%d\n"),

Looks good. I'm surprised the compiler didn't warn about this
obviously broken code...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
