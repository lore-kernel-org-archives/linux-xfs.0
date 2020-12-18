Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8D8C4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D4723A23
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgLRH0R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgLRH0R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:26:17 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0569AC0617A7;
        Thu, 17 Dec 2020 23:25:37 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id f14so829311pju.4;
        Thu, 17 Dec 2020 23:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ejK+psMjgjWzzhovwASKUe2Krr91CvmuAB0bsrQ/1vw=;
        b=SCO413SzDFN5S/1I8WiRVIHYoUSHN9+Zj0Nrxg6qq/PR1STSunrAl14VrJRnbyPR8p
         Ljy4Kg9sJv8PAqy7z+QVgT04ZxJJXGmoeMTjU8dN/a00zW2k8x+Ay+R/ODaQiOvSIMUv
         +6R+5SO0YIBwey3Yj5ac+7sctFX4jq16e3FRzDAHFT9Ecycx5fWmjDnRp7ECaJB8LzRp
         zevxgc8i6GNKHPZxRfA7xDZIrQ/b26EiGto624rZrf9mIQvYBhDgItJ2j4pRd4q33yvG
         /djLlcgRHu0sidRvVVup20igmnHxPxOmw0QCRm6wpWhoLrDO3A/UVGODFxglyw+wMGGy
         1a3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ejK+psMjgjWzzhovwASKUe2Krr91CvmuAB0bsrQ/1vw=;
        b=LXw3SpjDni6wAFrVDc83s8j0lQLPW2SDYib1ZNdv/iTVK5/TNB71fSKL6u7kTSuysv
         82ZyFiJIZWbquQ81clVMDjmFhcEPyNS8Euca3+iCkf0hvSStlFBHy7P+r1aVEJGDh351
         J1yLUDG3VDj9Tz+G+ZSzjd/5vNtEsv79hY9zb0giOBail98XHP3No9Gk56UPd0Kj3rsE
         1R88HYlfHFO23rIApIO37v6o77BxZjYhiWuRB/s8AYP1AO6Tfrn4TVbacjyCJ0aLg6FT
         smKy5ThRj+zWrv64CgioJDGjTdOSTX66XJB7AuwsJWhJNfitMBY5km0mOaiZQvYgybxS
         cMUw==
X-Gm-Message-State: AOAM531y201ofzmqhAnWlmHlG14Ou2ahh73wFg2yLJhPPKUrnVg8k9Z2
        2sg60UWjbpUnlzGewaUoaQ==
X-Google-Smtp-Source: ABdhPJziFk04N1cmakBhKh7h5Yc+KiG+dQxrkQvIA8X5f1ROA98zew+2414v03Tt8n0J9qvY2Xj8Uw==
X-Received: by 2002:a17:90a:d90e:: with SMTP id c14mr3043464pjv.85.1608276336574;
        Thu, 17 Dec 2020 23:25:36 -0800 (PST)
Received: from [10.76.131.47] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id y1sm8355350pff.17.2020.12.17.23.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 23:25:35 -0800 (PST)
Subject: Re: [xfs] 237d7887ae: xfstests.xfs.513.fail
To:     kernel test robot <oliver.sang@intel.com>,
        Kaixu Xia <kaixuxia@tencent.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com
References: <20201218055819.GA12524@xsang-OptiPlex-9020>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <5cc27796-00b7-aa4c-95a4-5c8c6f8c7c00@gmail.com>
Date:   Fri, 18 Dec 2020 15:25:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201218055819.GA12524@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi，

The patch https://www.spinics.net/lists/linux-xfs/msg47389.html for xfstests
will fix this regression.

Thanks,
Kaixu

On 2020/12/18 13:58, kernel test robot wrote:
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 237d7887ae723af7d978e8b9a385fdff416f357b ("xfs: show the proper user quota options")
> https://git.kernel.org/cgit/fs/xfs/xfs-linux.git xfs-5.11-merge
> 
> 
> in testcase: xfstests
> version: xfstests-x86_64-d41dcbd-1_20201215
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: xfs
> 	test: xfs-group-51
> 	ucode: 0x21
> 
> test-description: xfstests is a regression test suite for xfs and other files ystems.
> test-url: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> 
> on test machine: 4 threads Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz with 8G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 2020-12-18 01:24:14 export TEST_DIR=/fs/sdb1
> 2020-12-18 01:24:14 export TEST_DEV=/dev/sdb1
> 2020-12-18 01:24:14 export FSTYP=xfs
> 2020-12-18 01:24:14 export SCRATCH_MNT=/fs/scratch
> 2020-12-18 01:24:14 mkdir /fs/scratch -p
> 2020-12-18 01:24:14 export SCRATCH_DEV=/dev/sdb4
> 2020-12-18 01:24:14 export SCRATCH_LOGDEV=/dev/sdb2
> 2020-12-18 01:24:14 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
> 2020-12-18 01:24:14 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
> 2020-12-18 01:24:14 sed "s:^:xfs/:" //lkp/benchmarks/xfstests/tests/xfs-group-51
> 2020-12-18 01:24:14 ./check xfs/510 xfs/511 xfs/512 xfs/513 xfs/514 xfs/515 xfs/516 xfs/517 xfs/518 xfs/519
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 lkp-ivb-d05 5.10.0-rc5-00026-g237d7887ae72 #1 SMP Fri Dec 18 08:12:46 CST 2020
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb4
> MOUNT_OPTIONS -- /dev/sdb4 /fs/scratch
> 
> xfs/510	 1s
> xfs/511	 2s
> xfs/512	 2s
> xfs/513	- output mismatch (see /lkp/benchmarks/xfstests/results//xfs/513.out.bad)
>     --- tests/xfs/513.out	2020-12-15 12:31:26.000000000 +0000
>     +++ /lkp/benchmarks/xfstests/results//xfs/513.out.bad	2020-12-18 01:24:44.695412845 +0000
>     @@ -77,7 +77,11 @@
>      TEST: "-o usrquota" "pass" "usrquota" "true"
>      TEST: "-o quota" "pass" "usrquota" "true"
>      TEST: "-o uqnoenforce" "pass" "usrquota" "true"
>     +[FAILED]: mount /dev/loop0 /fs/sdb1/513.mnt -o uqnoenforce
>     +ERROR: did not expect to find "usrquota" in "rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,uqnoenforce"
>      TEST: "-o qnoenforce" "pass" "usrquota" "true"
>     +[FAILED]: mount /dev/loop0 /fs/sdb1/513.mnt -o qnoenforce
>     ...
>     (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/513.out /lkp/benchmarks/xfstests/results//xfs/513.out.bad'  to see the entire diff)
> xfs/514	- output mismatch (see /lkp/benchmarks/xfstests/results//xfs/514.out.bad)
>     --- tests/xfs/514.out	2020-12-15 12:31:26.000000000 +0000
>     +++ /lkp/benchmarks/xfstests/results//xfs/514.out.bad	2020-12-18 01:24:46.007412903 +0000
>     @@ -1,2 +1,5 @@
>      QA output created by 514
>      Silence is golden
>     +attr_remove not documented in the xfs_db manpage
>     +attr_set not documented in the xfs_db manpage
>     +logformat not documented in the xfs_db manpage
>     ...
>     (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/514.out /lkp/benchmarks/xfstests/results//xfs/514.out.bad'  to see the entire diff)
> xfs/515	- output mismatch (see /lkp/benchmarks/xfstests/results//xfs/515.out.bad)
>     --- tests/xfs/515.out	2020-12-15 12:31:26.000000000 +0000
>     +++ /lkp/benchmarks/xfstests/results//xfs/515.out.bad	2020-12-18 01:24:47.082412951 +0000
>     @@ -1,2 +1,3 @@
>      QA output created by 515
>      Silence is golden
>     +limit not documented in the xfs_quota manpage
>     ...
>     (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/515.out /lkp/benchmarks/xfstests/results//xfs/515.out.bad'  to see the entire diff)
> xfs/516	 32s
> xfs/517	[not run] rmapbt not supported by scratch filesystem type: xfs
> xfs/518	 3s
> xfs/519	[not run] Reflink not supported by scratch filesystem type: xfs
> Ran: xfs/510 xfs/511 xfs/512 xfs/513 xfs/514 xfs/515 xfs/516 xfs/517 xfs/518 xfs/519
> Not run: xfs/517 xfs/519
> Failures: xfs/513 xfs/514 xfs/515
> Failed 3 of 10 tests
> 
> 
> 
> 
> To reproduce:
> 
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp install job.yaml  # job file is attached in this email
>         bin/lkp run     job.yaml
> 
> 
> 
> Thanks,
> Oliver Sang
> 

-- 
kaixuxia
