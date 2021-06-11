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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A412BC48BE5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 08:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AEDC613C6
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 08:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhFKI0E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 04:26:04 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:40837 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbhFKI0D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 04:26:03 -0400
Received: by mail-pg1-f179.google.com with SMTP id j12so1852050pgh.7;
        Fri, 11 Jun 2021 01:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=bvFa7bksGY3g2VLNVghVo/7jkW/QvNZiYzB25sFV/AU=;
        b=kxYvQHaLa/2FfsDKS9v4A3/wJRaYpa969nXuGUHY7phSaKilp9OEM7Uyuqq1b1Si7J
         d7t1I+SesP2S5QiimGRuFBm1jHSUF1JaMxuKfUkXLubHHAEmZ4aYHDP2+2Pi97OHH2B+
         dQdfYL7B5dTqnY6GWyDbiV+Y81et/yVnwJik49ISU7POdcfzIm9Ivewx9OqKEXM/0L20
         YhjiDT4vSt88FUCXVaG2dARfJ8/25cs85t6mWtrtv6UWxK4MoBTEThs4K3YZq8j7bpVW
         jHePTVq7YC3kMMLLRsZKiccqtAkydl5YoyWEDX6M/fbaiGmP3fuR3IGurKE4e+zFnPAr
         Xuig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=bvFa7bksGY3g2VLNVghVo/7jkW/QvNZiYzB25sFV/AU=;
        b=AioI/8ENA6BUHOvBfodfd4y+E4GXAo71clFCMwdEbAd8F3Q5ZtA0Q1UuZbUhhECm2/
         RmQkFPMjzmCycy11d6sjrnbpmSww9lCNXOEcwZh5u5jFaA6puxrtKrNh1jNLO03oF1TT
         bGbEfBuqDM1aZl2bPS5yHbXEuGA7epXBvkA/B+a6zlxV4b2TRqBdIpfMoeVPZNc4BcF+
         MyDe6lQe2hxL71IlqhMrQMCNYaat5PusS8JmXFcz0m6TwWqOfygbVXsMJKbtBu27yFMD
         qQ2+Q5wYCAwBv5HaJbgIh4m4uq1BA06mozPRYISH5Ccsgtlmg9/iPjZAID7Efp4DAAjF
         e+Ig==
X-Gm-Message-State: AOAM530yZsd+rLEeIplVwDpeWj92+sBGuENW4urgGQU5LVSzIyMRsn6r
        2wpOaNAaRVaW4Mw3qObDfms=
X-Google-Smtp-Source: ABdhPJy9T8hkbrdjQOokuFEJkKcHPjfzyCTc0FOw6UEt+/gCvQ7pwXhpHBvnvlyqv1Rz9X0z5j9gHw==
X-Received: by 2002:a62:1942:0:b029:2e9:debd:d8b1 with SMTP id 63-20020a6219420000b02902e9debdd8b1mr7220294pfz.9.1623399786017;
        Fri, 11 Jun 2021 01:23:06 -0700 (PDT)
Received: from garuda ([171.61.74.194])
        by smtp.gmail.com with ESMTPSA id d127sm4441839pfc.50.2021.06.11.01.23.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jun 2021 01:23:05 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317283324.653489.9381968524443830077.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 13/13] misc: update documentation to reflect auto-generated group files
In-reply-to: <162317283324.653489.9381968524443830077.stgit@locust>
Date:   Fri, 11 Jun 2021 13:53:02 +0530
Message-ID: <87o8cc3j4p.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Update the documentation to outline the new requirements for test files
> so that we can generate group files during build.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  README |   19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
>
> diff --git a/README b/README
> index 048491a6..ab298ca9 100644
> --- a/README
> +++ b/README
> @@ -140,7 +140,8 @@ Running tests:
>      - ./check '*/001' '*/002' '*/003'
>      - ./check '*/06?'
>      - Groups of tests maybe ran by: ./check -g [group(s)]
> -      See the 'group' file for details on groups
> +      See the tests/*/group.list files after building xfstests to learn about
> +      each test's group memberships.
>      - If you want to run all tests regardless of what group they are in
>        (including dangerous tests), use the "all" group: ./check -g all
>      - To randomize test order: ./check -r [test(s)]
> @@ -174,8 +175,8 @@ Test script environment:
>  
>      When developing a new test script keep the following things in
>      mind.  All of the environment variables and shell procedures are
> -    available to the script once the "common/rc" file has been
> -    sourced.
> +    available to the script once the "common/preamble" file has been
> +    sourced and the "_begin_fstest" function has been called.
>  
>       1. The tests are run from an arbitrary directory.  If you want to
>  	do operations on an XFS filesystem (good idea, eh?), then do
> @@ -249,6 +250,18 @@ Test script environment:
>  	  in the ./new script. It can contain only alphanumeric characters
>  	  and dash. Note the "NNN-" part is added automatically.
>  
> +     6. Test group membership: Each test can be associated with any number
> +	of groups for convenient selection of subsets of tests.  Test names
> +	can be any sequence of non-whitespace characters.  Test authors
> +	associate a test with groups by passing the names of those groups as
> +	arguments to the _begin_fstest function:
> +
> +	_begin_fstest auto quick subvol snapshot
> +
> +	The build process scans test files for _begin_fstest invocations and
> +	compiles the group list from that information.  In other words, test
> +	files must call _begin_fstest or they will not be run.
> +
>  Verified output:
>  
>      Each test script has a name, e.g. 007, and an associated


-- 
chandan
