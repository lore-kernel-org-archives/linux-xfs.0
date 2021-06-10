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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC7EC48BCD
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92650613C9
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhFJIql (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:46:41 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:35522 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJIqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 04:46:40 -0400
Received: by mail-pf1-f175.google.com with SMTP id h12so1031276pfe.2;
        Thu, 10 Jun 2021 01:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=hICD7LSY5LV/UYFY902mdNo4INpVIpBGwurGQbCLaBo=;
        b=WhrowTEdnDU5XhkZxeD5036hxYZdqSU1uHo9qSWKhI620pqjlMXIdnfUnkrrKIysqJ
         9Ct6QIq8Ukp84uHYbb9Q2dIzS8xNSTeKUzSAir1LgBpmk2c0IxKFpNxRfuHbiOFRwh5C
         /MgZ+Ufg5TCARM9uaZGVaWUa6Y3TpLaVws9QIlSF4Wc4mGh0FhaeeXI7YlRwOdf7+OXx
         h+SvvVPQ9KNx5ZQ6DEWzWl4lbelE7maDOAub6aPEJ1hMleAU8ZE82zQIXH7S1XqM+XxP
         Sd/fda8OK+O94NIUYhoTXpXKkjOHONdQZ0jr/O+peFqF28JaX/Qk7cLUlQs5WRS4X+CQ
         opnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=hICD7LSY5LV/UYFY902mdNo4INpVIpBGwurGQbCLaBo=;
        b=Vjju5dOzRk9NaUlcLt/e56Xh6InvZ/D3rylfDz9svb2O0V8c3Hw+A8ZAVFXFHq0qen
         81U9fb+ey4lP9KTMplhR9NBZfgWcP/rNn4dVO5YVkduh7DOc7h+DiUk9nLZY9Gtx/cxw
         tZO1pJmpT5iD3BygYBA4PiLpLBR0k0uiAED0ovtZV6XoUBbmhwEU/1mLR975FX/BWxGK
         hY9BaLIMBxbF2JB4KvNC0XJqrwYIFICrzmku7wFN8C0ZQQFY+VAKHGyz/ao3XlX8PVOQ
         G6RR9UpsBMmdyVfONIqLsOz/+4vM11Rltdwo6QXq0f+IlS9Fo6tw2k85inT2g/4GSL9A
         fQCg==
X-Gm-Message-State: AOAM532Nl8YdJoA5R2t1sk89gQn8VYyRX3Ie5gg3/X+XpITEDeL/tQ8c
        a1xfD9TgTv5UtrhKwHaIbEc=
X-Google-Smtp-Source: ABdhPJwO01Z9uZRbk8ZXDimO4i7d6hSwvedGDDYbmT4OcQrP1UsX1WId2kwG+RIrXp3f6LUCzhUW6w==
X-Received: by 2002:a05:6a00:10:b029:2f5:9339:1e8c with SMTP id h16-20020a056a000010b02902f593391e8cmr1000635pfk.42.1623314609490;
        Thu, 10 Jun 2021 01:43:29 -0700 (PDT)
Received: from garuda ([122.171.171.192])
        by smtp.gmail.com with ESMTPSA id e2sm2012313pgh.5.2021.06.10.01.43.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jun 2021 01:43:29 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317276776.653489.15862429375974956030.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 01/13] fstests: fix group check in new script
In-reply-to: <162317276776.653489.15862429375974956030.stgit@locust>
Date:   Thu, 10 Jun 2021 14:13:25 +0530
Message-ID: <87zgvyp0sy.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:49, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> In the tests/*/group files, group names are found in the Nth columns of
> the file, where N > 1.  The grep expression to warn about unknown groups
> is not correct (since it currently checks column 1), so fix this.

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  new |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
>
> diff --git a/new b/new
> index bb427f0d..357983d9 100755
> --- a/new
> +++ b/new
> @@ -243,10 +243,7 @@ else
>      #
>      for g in $*
>      do
> -	if grep "^$g[ 	]" $tdir/group >/dev/null
> -	then
> -	    :
> -	else
> +	if ! grep -q "[[:space:]]$g" "$tdir/group"; then
>  	    echo "Warning: group \"$g\" not defined in $tdir/group"
>  	fi
>      done


-- 
chandan
