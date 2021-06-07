Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37FAC47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 08:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB6CF6108E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 08:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhFGIfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 04:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhFGIfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 04:35:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A290C061766
        for <linux-xfs@vger.kernel.org>; Mon,  7 Jun 2021 01:33:17 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u7so8234040plq.4
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 01:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=SiYoXLVNn5lr5ZE4pcEuJwTjKFW3AW9bZo9rNDIG3UA=;
        b=d4DZHxN0aoW+EEeIJI+mAGh2mmfsd7UnIVeRmNkIl5/+9ZL+Rgxuj5OYFZgXGYWmai
         +ghyEmdrZFjsPIcs8TCc1uEarPGkOcu5NkRVqG662UckQP7R3bqWCh5yzG7Vuw7rAp+q
         My3LnczzdjQ2XzvCyoD/2HBDjF4aG5pvSuioewc2cwxZo3q/D7TDPbAutoGmMTzXYC2c
         YtCf/V5Zgg3BRnlLExvRRafzEIrHNNaL3vVYejgqIcNXITnaDZISSxZHXY9/5cROE6bu
         4p5jD0JmXpp3EkPTybnw4yFV20P+0fnUVksdbXeRW2dSnO2aN7I2b8YoVHfvVXmFo/od
         MAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=SiYoXLVNn5lr5ZE4pcEuJwTjKFW3AW9bZo9rNDIG3UA=;
        b=drrbRMirJsvS3BIHDOhWeCkYCAP783BuYed+T+ch1yNOxBLt1fg6DDqhZiW235N/vn
         1ByVSQhWjAZSl8Ry1nr2kgMqaTK80imTy8/zG5IBufIPHPlN7uQBodNUNstM+YE76T5e
         ndl7pMfMzoub9TemIhC4827J0e2z0YiqN77G1Hhwk91Sm5VMO3LuKLXFE0ylg5AMNoa9
         /XfMUgolje7rQGtSKIrq9rT4fnJ0Jt+wvJoH1trITGdlmLmiJmuPdOmk3CnLfohN4WPw
         Wqm8mRhdMAqWZCHRQ2zWxaAmy657C1i+KKarGnIvUi26j43q+LyaXqaaEdNlS28gB5BR
         0wVg==
X-Gm-Message-State: AOAM533LrY9A3DBBS25LpL16ZBLJ1QjmtLCsIeHpdhnl4iUz284ehPty
        iML03IwJt0ZR+fzxqgpN5IkE3wQPBEYrRw==
X-Google-Smtp-Source: ABdhPJzF0CyIdJOq3LOCUJMVaCJksSoWOoodmlfvwwVUd1fpz/7DdQPGP7shsNQ3mcKhMhrx70mj6g==
X-Received: by 2002:a17:902:548:b029:10f:30af:7d5f with SMTP id 66-20020a1709020548b029010f30af7d5fmr16039606plf.22.1623054796512;
        Mon, 07 Jun 2021 01:33:16 -0700 (PDT)
Received: from garuda ([122.179.77.39])
        by smtp.gmail.com with ESMTPSA id l5sm7365046pff.20.2021.06.07.01.33.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jun 2021 01:33:16 -0700 (PDT)
References: <20210607052747.31422-1-allison.henderson@oracle.com> <20210607052747.31422-4-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v20 13/14] xfs: Fix default ASSERT in xfs_attr_set_iter
In-reply-to: <20210607052747.31422-4-allison.henderson@oracle.com>
Date:   Mon, 07 Jun 2021 14:03:13 +0530
Message-ID: <87h7iakrau.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Jun 2021 at 10:57, Allison Henderson wrote:
> This ASSERT checks for the state value of RM_SHRINK in the set path
> which should never happen.  Change to ASSERT(0);
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2387a41..a0edebc 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -612,7 +612,7 @@ xfs_attr_set_iter(
>  		error = xfs_attr_node_addname_clear_incomplete(dac);
>  		break;
>  	default:
> -		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
> +		ASSERT(0);
>  		break;
>  	}
>  out:


-- 
chandan
