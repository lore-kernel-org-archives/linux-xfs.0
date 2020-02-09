Return-Path: <SRS0=+eDc=35=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B12C352A4
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 15:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221BE20838
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 15:30:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q2uBXYbv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBIPaB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 10:30:01 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43059 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgBIPaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Feb 2020 10:30:01 -0500
Received: by mail-pf1-f193.google.com with SMTP id s1so2374295pfh.10;
        Sun, 09 Feb 2020 07:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ywTru7ToFVQTTIaSwQhMsQMl50bqA8Wbg0F099lyplU=;
        b=q2uBXYbvMvREs/0vNPTnmCfI9TgYo0dNWs8IEQEs1WGCQH+jP42VsexysbnkI6jaFx
         J5V+e9di6UA6efWTrH+LPfBbYkYPcw1KikGmNcN6+9wrDds38qT9wui1JHvzW2bF5UAp
         okWtVOrB9Bzfhzg9BEvG8hB4Uu1Bj/KYK1o+dWSP5f+hxK2r2sNQzmqbuZAzv3PfFKwA
         haOV9LaJvXNxs011HKYUkMXqr6c9f40ODE7rx5ZYdkhtYkvfhehQa96t7QQeMEiRbAZj
         +cmvWXKRadgtalTAwqCZ4/8Vzsv89vxvdS33OOt9XmSJ73lnjlh1IDJDTK6nqXl56PuN
         Ioog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ywTru7ToFVQTTIaSwQhMsQMl50bqA8Wbg0F099lyplU=;
        b=QR6NctL3e/T+BBEFp9n/M9bRlokfGI9Wq6IzClcr032YZ+09Xi6cs0l3xyrqO1lYql
         NsJgPsGXR1wAySchlzzdzGwY1XtZakjgff8Dtpc9QajoHWqsI+YTrdXdUyEz+EnnXiHB
         jW2HztyWkOyu7bEhNosGQKoAMrskjZrSQUzzfkzp5k0+tQ0KyDeiFmGexsh3FbMTmfIJ
         /fUXNcSc/9wsoE5vzpomQgvLhiLGG9b39RbQtpHgAoRveirwi35OAL7HygMOPgHYs4lH
         Iz6cCIu8wnDMllS4HVWrgwlkdOZKSqXcCkalbu1dxdiaVukMwVdN1UYEGaGfwoCgxwB9
         6wEQ==
X-Gm-Message-State: APjAAAVdJN2KikjsKTFDCB2v1hRdNZx1oXumcPd+q5Nqv7brWLMFNqB7
        3vGyc2ropC+JrBxN1N4xRy8=
X-Google-Smtp-Source: APXvYqzC41BmboJei7tlXL3kqPiV912VJn/o57t6vQsH8sOn2ec2iX+DzX6i0aY6CL5ngLhPeTAG5g==
X-Received: by 2002:a63:3487:: with SMTP id b129mr9736459pga.320.1581262200205;
        Sun, 09 Feb 2020 07:30:00 -0800 (PST)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id 5sm9619885pfx.163.2020.02.09.07.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 07:29:59 -0800 (PST)
Date:   Sun, 9 Feb 2020 23:29:54 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] generic/402: skip test if xfs_io can't parse the
 date value
Message-ID: <20200209152954.GE2697@desktop>
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
 <158086092087.1989378.18220785148122680849.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086092087.1989378.18220785148122680849.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:02:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If xfs_io's utimes command cannot interpret the arguments that are given
> to it, it will print out "Bad value for [am]time".  Detect when this
> happens and drop the file out of the test entirely.
> 
> This is particularly noticeable on 32-bit platforms and the largest
> timestamp seconds supported by the filesystem is INT_MAX.  In this case,
> the maximum value we can cram into tv_sec is INT_MAX, and there is no
> way to actually test setting a timestamp of INT_MAX + 1 to test the
> clamping.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/402 |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/generic/402 b/tests/generic/402
> index 2a34d127..32988866 100755
> --- a/tests/generic/402
> +++ b/tests/generic/402
> @@ -63,10 +63,19 @@ run_test_individual()
>  	# check if the time needs update
>  	if [ $update_time -eq 1 ]; then
>  		echo "Updating file: $file to timestamp $timestamp"  >> $seqres.full
> -		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file
> +		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file >> $tmp.utimes 2>&1

Agree with Amir here, ">" whould be better, instead of appending.

> +		cat $tmp.utimes >> $seqres.full
> +		if grep -q "Bad value" "$tmp.utimes"; then

Echo a message to $seqres.full about this test being skipped?

> +			rm -f $file $tmp.utimes
> +			return
> +		fi
> +		cat $tmp.utimes
> +		rm $tmp.utimes
>  		if [ $? -ne 0 ]; then

So here we test the result of "rm $tmp.utimes"? I guess that's always a
pass.

>  			echo "Failed to update times on $file" | tee -a $seqres.full
>  		fi
> +	else
> +		test -f $file || return

Same here, better to be verbose about skipping test.

Thanks,
Eryu

>  	fi
>  
>  	tsclamp=$((timestamp<tsmin?tsmin:timestamp>tsmax?tsmax:timestamp))
> 
