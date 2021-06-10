Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F436C47094
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F15096140F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhFJIqn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:46:43 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:45778 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJIqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 04:46:43 -0400
Received: by mail-pf1-f181.google.com with SMTP id d16so1007279pfn.12;
        Thu, 10 Jun 2021 01:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=NU+ot8fe4/98YQjLQUl3IBQe8ppk7Bdyq1oKZdJEGA4=;
        b=jrPW4viopVYuD4/CmESKcZKLcDmU9mh5jfIBy09JA3dHOB4SWZ1V6Fq/6CwUnn9I5g
         a5umnYi4R+IUe2zE6bS0aKWtHbzHJbZMg9zm3DbpKRnvkselvN6lXa8t2U44C2ozyzA+
         9sUtKM1cuUiwpl7W0DQIlbb77ta1hBUOt/OO3uB9TidTXtRrsBW5vt5oIpifVm2y7qB1
         444Bny/tGx7qT7P2E2dH70sQNa5NCD2CMo6pQn2bjglXpfsOr2q3rTKM1bMrSBvbfUtG
         2gdjVMw9f05OV8GUpDDmRHHEgLg27u6ZHNIvhKRY1GjDWnr3D1I0xdKD3GJv56eiOiuO
         AQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=NU+ot8fe4/98YQjLQUl3IBQe8ppk7Bdyq1oKZdJEGA4=;
        b=tuyteDyE9hieuJek4LMiQKSI7ATK2uHROdg4L4lAfSIwH5LX8UMnTSUtl6vLNM0O+P
         h2CTJ7afK5ZsBIpMj2UUOe5DjhdcOnrEZpecGTR7DmGu8Ie1ukCEs0elU5+YQW3lMRHN
         HM79l49mRHvLh/fkI+CUAlN4qFWwKeiGshFN7PtFMkDUeQT1cUhk4mlmL8Mp7pqKYIAH
         +sWhDSaTVvKlnLEf9OHrVS0qI4S1LjsmKQDJ7XfTvDKC2MxqJDzpJDdARCu9lYCv9/a6
         R24mcb8b9XG7EXK2DWY6VT/70Jo8LxI4wajTGXBOtsa5+Cq8nQQugNfaa9a+CwxPsphB
         s5BQ==
X-Gm-Message-State: AOAM533lDZtSJIR2buS/xGezxd6PNoFcyH6hGhiwLkfk9VbbBA+F1XDu
        vhtzpytzJHWb+vfSZLD+B+s=
X-Google-Smtp-Source: ABdhPJxpxxA/Uw7t3WLyzJrra1iko9IU4bNtAMK963iP2XwW+DITyPb/23/Rx3KNt58PBg5w8TRSpg==
X-Received: by 2002:a63:5d52:: with SMTP id o18mr3932915pgm.440.1623314627606;
        Thu, 10 Jun 2021 01:43:47 -0700 (PDT)
Received: from garuda ([122.171.171.192])
        by smtp.gmail.com with ESMTPSA id n6sm2117432pgm.79.2021.06.10.01.43.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jun 2021 01:43:47 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317277320.653489.6399691950820962617.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 02/13] misc: move exit status into trap handler
In-reply-to: <162317277320.653489.6399691950820962617.stgit@locust>
Date:   Thu, 10 Jun 2021 14:13:43 +0530
Message-ID: <87y2bip0sg.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:49, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Move the "exit $status" clause of the _cleanup function into the
> argument to the "trap" command so that we can standardize the
> registration of the atexit cleanup code in the next few patches.
>

Grep on all the test files revealed that only generic/068 and xfs/004 invoked
"exit $status" inside the _cleanup() function. Hence the changes look good to
me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/068 |    3 +--
>  tests/xfs/004     |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
>
> diff --git a/tests/generic/068 b/tests/generic/068
> index 932a8560..573fbd45 100755
> --- a/tests/generic/068
> +++ b/tests/generic/068
> @@ -22,10 +22,9 @@ _cleanup()
>      cd /
>  
>      trap 0 1 2 3 15
> -    exit $status
>  }
>  
> -trap "_cleanup" 0 1 2 3 15
> +trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
>  . ./common/rc
> diff --git a/tests/xfs/004 b/tests/xfs/004
> index d3fb9c95..4d92a08e 100755
> --- a/tests/xfs/004
> +++ b/tests/xfs/004
> @@ -18,9 +18,8 @@ _cleanup()
>  {
>  	_scratch_unmount
>  	rm -f $tmp.*
> -	exit $status
>  }
> -trap "_cleanup" 0 1 2 3 15
> +trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  _populate_scratch()
>  {


-- 
chandan
