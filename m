Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B1FC388F7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA16B22240
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bsAKk9H2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgKMLce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 06:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgKML3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:29:54 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19D9C061A47;
        Fri, 13 Nov 2020 03:29:22 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so7414042pfu.1;
        Fri, 13 Nov 2020 03:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t9ZTduprDwuKupa2O2bRQn5mVCQGyLWGKFkLP3hQnLs=;
        b=bsAKk9H2h+3/YDr7cTQ7i7c9GgD/PEjb38Hx+PVD0Fo1Dw9egD02AAJTGxEun1T/ll
         8iJJdyCGONZjau42CtzpFBL3ZK31CjFOtwYFaBOvEY9kESIHQuFfRf4z+PdZT7V4yp2Z
         hGWwPN9tKyKTt+Xy6qVFH+Xu6GtRxRgXkCFBB0DR6tXXySXzf2RDknWb246c7dHNLF2m
         PqFoRIaj4X1CMeiSquTmMIMNS1ADg6ws6xR4YydtWcAIKVwaSG7inTazhobIc6MTZHuZ
         eJNmlgM5zZFoMZ8W0qqNffmYx32vjjW8a1SY5hyi+2sMhfT/glZVx4JQI3YoIoIadzgB
         vLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t9ZTduprDwuKupa2O2bRQn5mVCQGyLWGKFkLP3hQnLs=;
        b=XLwidEj+9zwRAMGQg6ypORWf5yZaL9aeQiuWScWD5pDWx1V9Oi6ogfKSjzbnWANna+
         GDvH9cFeyq00Lh+jaZWXDRNoZIyXmdXa7pYUQx96lAZ0q8E36Mx6lFZGLXv9ssDxffSG
         m7fzuieZ/vSb4iij7sV0+T7JQG2PNuUzRhbP+/jb7FY2uEF0kbmG5VcPjnVy3Csnslrs
         SEzLA9grd8fwdcIR8YK/yNlpcjPKyUSdewX8r9Qo6aqEoUYZnkoO3Dzm5XJYUtvroWRY
         amAu77giIrG3qfssmiWBm6yccVywQg252FSylHnU2/zL0Kbq4AV01fiL1k6EuCS3+rsv
         WpEA==
X-Gm-Message-State: AOAM533TNk9z4eB8AN97dPkSYZyBiIFVAly8jFXSCC7fZ1dK9NA9vB3g
        SaDjlKew/RiR0gELrxdjULnY5PMfqT8=
X-Google-Smtp-Source: ABdhPJwxbjEio2w84y9Zf0gQxX3wzzheiw6uIAj47FADQbCkAbh0QSX4JngX+vt2rWSvBkSzcRPAwg==
X-Received: by 2002:a05:6a00:c8:b029:18b:b0e:e51 with SMTP id e8-20020a056a0000c8b029018b0b0e0e51mr1594976pfj.37.1605266961964;
        Fri, 13 Nov 2020 03:29:21 -0800 (PST)
Received: from garuda.localnet ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id j12sm8894058pga.78.2020.11.13.03.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:29:21 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH 00/11] xfs: Tests to check for inode fork extent count overflow detection
Date:   Fri, 13 Nov 2020 16:59:18 +0530
Message-ID: <15437715.NU04MGavY6@garuda>
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 13 November 2020 4:56:52 PM IST Chandan Babu R wrote:
> The patchset at
> https://lore.kernel.org/linux-xfs/20201103150642.2032284-1-chandanrlinux@gmail.com/T/#m90a8754df516bbd0c36830904a2e31c37983792c  
> added support to XFS to detect inode extent count overflow when
> performing various filesystem operations. The patchset also added
> new error injection tags for,
> 1. Reducing maximum extent count to 10.
> 2. Allocating only single block sized extents.
> 
> The corresponding code for xfsprogs can be obtained from
> https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/.
> 
> The patches posted along with this cover letter add tests to verify if
> the in-kernel inode extent count overflow detection mechanism works
> correctly.
> 
> These patches can also be obtained from
> https://github.com/chandanr/xfsprogs-dev.git at branch
> extent-overflow-tests.

Sorry, the correct git repository URL is
https://github.com/chandanr/xfstests.git.

> 
> Chandan Babu R (11):
>   common/xfs: Add a helper to get an inode fork's extent count
>   xfs: Check for extent overflow when trivally adding a new extent
>   xfs: Check for extent overflow when trivally adding a new extent
>   xfs: Check for extent overflow when punching a hole
>   xfs: Check for extent overflow when adding/removing xattrs
>   xfs: Check for extent overflow when adding/removing dir entries
>   xfs: Check for extent overflow when writing to unwritten extent
>   xfs: Check for extent overflow when moving extent from cow to data
>     fork
>   xfs: Check for extent overflow when remapping an extent
>   xfs: Check for extent overflow when swapping extents
>   xfs: Stress test with with bmap_alloc_minlen_extent error tag enabled
> 
>  common/xfs        |  22 +++
>  tests/xfs/522     | 214 +++++++++++++++++++++++++++
>  tests/xfs/522.out |  24 ++++
>  tests/xfs/523     | 176 +++++++++++++++++++++++
>  tests/xfs/523.out |  18 +++
>  tests/xfs/524     | 210 +++++++++++++++++++++++++++
>  tests/xfs/524.out |  25 ++++
>  tests/xfs/525     | 154 ++++++++++++++++++++
>  tests/xfs/525.out |  16 +++
>  tests/xfs/526     | 360 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/526.out |  47 ++++++
>  tests/xfs/527     | 125 ++++++++++++++++
>  tests/xfs/527.out |  13 ++
>  tests/xfs/528     |  87 +++++++++++
>  tests/xfs/528.out |   8 ++
>  tests/xfs/529     |  86 +++++++++++
>  tests/xfs/529.out |   8 ++
>  tests/xfs/530     | 115 +++++++++++++++
>  tests/xfs/530.out |  13 ++
>  tests/xfs/531     |  85 +++++++++++
>  tests/xfs/531.out |   6 +
>  tests/xfs/group   |  10 ++
>  22 files changed, 1822 insertions(+)
>  create mode 100755 tests/xfs/522
>  create mode 100644 tests/xfs/522.out
>  create mode 100755 tests/xfs/523
>  create mode 100644 tests/xfs/523.out
>  create mode 100755 tests/xfs/524
>  create mode 100644 tests/xfs/524.out
>  create mode 100755 tests/xfs/525
>  create mode 100644 tests/xfs/525.out
>  create mode 100755 tests/xfs/526
>  create mode 100644 tests/xfs/526.out
>  create mode 100755 tests/xfs/527
>  create mode 100644 tests/xfs/527.out
>  create mode 100755 tests/xfs/528
>  create mode 100644 tests/xfs/528.out
>  create mode 100755 tests/xfs/529
>  create mode 100644 tests/xfs/529.out
>  create mode 100755 tests/xfs/530
>  create mode 100644 tests/xfs/530.out
>  create mode 100755 tests/xfs/531
>  create mode 100644 tests/xfs/531.out
> 
> 


-- 
chandan



