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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A89BC48BE0
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 06:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FBE9610A0
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 06:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhFKGdn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 02:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFKGdm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 02:33:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357B3C061574;
        Thu, 10 Jun 2021 23:31:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so86106pjn.1;
        Thu, 10 Jun 2021 23:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=rDJbmulKROCjCE+FcnlfJQX3awvMgGF3tA9qRM1MDNk=;
        b=lkTyXzodFUyb0QSRW6hCkfBTH38SnNXdHMMvvrQ0i1cbMkpDRaQm1+utKyYQIlJVfB
         JOdiPk5GnNVD6PZ1Z0GUm0MlzpcKkAb2YSKP/D4Nz7DiEK3bO6VQSdjIawHwQstUgZlI
         fZJVzrhhzi5N7LEtA9F1KMw0S1z8CSMi1bMLRgNyez6hSD+lCplmzxF/JNF1s7ZYRpwC
         Zc/sCDyiNZ94zm7HfnA+3aRgAD8lyRtEBjBENaBLUODAZd//QQnLbMIYgr050VsxpbDr
         t6tJ2zUtjd2oqWcFGZwL8Y9KvCg0go9tZEZfOw4I/pk8dcXVC8RwFrAGtguSQaRzGmxO
         3Zmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=rDJbmulKROCjCE+FcnlfJQX3awvMgGF3tA9qRM1MDNk=;
        b=jUrPpYcsiuOwUSAiKEzmV+bRQjwmjmv0P0A5ugIXBA5Ljlua9wKMVMnN7CGTbM6IpE
         NKawSO805rlShC+gBw0mm2Nm7CEcyNFIPqR8Tx6wlvmzvMEKhvYwlc7yDMjKGwAU3Zwv
         TcVl2PFPlaWrhhdE30/nSa2lOueV4M6vyFCRQALPz9GG9J97CjVE3ZwRg1pMRMoixwWC
         IO1elBtZxWnlFKRqIM/DtebNJKV1mT2uA3MjssJCIn3VdUmzcnJpvMf1o2vPtUebdwMH
         dVEP+S5bGfMTBjsSMr5+pGJx+ajlN8FBq81VLjfcbZTyUMW7B09ywVcsncF6WdFAgIo4
         3SZg==
X-Gm-Message-State: AOAM53138lSrG1L8xP7zRFinbL8S96jvwCcuGNWQfD9xn6kn4Z6p5o3h
        25Y5RUe0H7JQ7yNQiSI42BI=
X-Google-Smtp-Source: ABdhPJxKubz3piajKb4C2kquQVGqz4ZrG5iLpz2GT0O2M7nV+DYsiOwMlzA9wyzM26DOzZZ7lblGjA==
X-Received: by 2002:a17:90a:7841:: with SMTP id y1mr7583423pjl.119.1623393088725;
        Thu, 10 Jun 2021 23:31:28 -0700 (PDT)
Received: from garuda ([171.61.74.194])
        by smtp.gmail.com with ESMTPSA id q12sm4398384pgc.25.2021.06.10.23.31.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jun 2021 23:31:28 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317280590.653489.10114638028601363399.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 08/13] fstests: convert nextid to use automatic group generation
In-reply-to: <162317280590.653489.10114638028601363399.stgit@locust>
Date:   Fri, 11 Jun 2021 12:01:24 +0530
Message-ID: <87v96k3oar.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Convert the nextid script to use the automatic group file generation to
> figure out the next available test id.

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tools/nextid |    1 -
>  tools/nextid |   39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 1 deletion(-)
>  delete mode 120000 tools/nextid
>  create mode 100755 tools/nextid
>
>
> diff --git a/tools/nextid b/tools/nextid
> deleted file mode 120000
> index 5c31d602..00000000
> --- a/tools/nextid
> +++ /dev/null
> @@ -1 +0,0 @@
> -sort-group
> \ No newline at end of file
> diff --git a/tools/nextid b/tools/nextid
> new file mode 100755
> index 00000000..a65348e8
> --- /dev/null
> +++ b/tools/nextid
> @@ -0,0 +1,39 @@
> +#!/bin/bash
> +
> +# Compute the next available test id in a given test directory.
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ] || [ -n "$2" ] || [ ! -d "tests/$1/" ]; then
> +	echo "Usage: $0 test_dir"
> +	exit 1
> +fi
> +
> +. ./common/test_names
> +
> +line=0
> +i=0
> +eof=1
> +
> +while read found other_junk;
> +do
> +	line=$((line+1))
> +	if [ -z "$found" ] || [ "$found" == "#" ]; then
> +		continue
> +	elif ! echo "$found" | grep -q "^$VALID_TEST_NAME$"; then
> +		# this one is for tests not named by a number
> +		continue
> +	fi
> +	i=$((i+1))
> +	id=`printf "%03d" $i`
> +	if [ "$id" != "$found" ]; then
> +		eof=0
> +		break
> +	fi
> +done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | tr - ' ')
> +
> +if [ $eof -eq 1 ]; then
> +   line=$((line+1))
> +   i=$((i+1))
> +   id=`printf "%03d" $i`
> +fi
> +
> +echo "$1/$id"


-- 
chandan
