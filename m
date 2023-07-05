Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8C5C001B3
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jul 2023 06:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjGEGiF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 02:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbjGEGiD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 02:38:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F8E1701
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jul 2023 23:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688539039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NUWX5UvhowWYsdPQKhRlSWjHJ9IgFtq6PuCnNgnxE/c=;
        b=UyDzwP8MddJXYwNrZhdLUxRJE9p5RgQHG3ZUmx4MfIaTElvbAZk5otWeVFsaWZDNawWMoU
        4rdyU8GeZmVtJZPv6WbgvFdk7VARAYMYb4W2bCZLDrgXYDB45Gbcvf0Z0r8ENLkglca2vk
        RFcjL+pAZ+Mf266MM5GrBoy2PcbR83U=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-uzbpj0pYM0-GrbdZ6Shncg-1; Wed, 05 Jul 2023 02:37:15 -0400
X-MC-Unique: uzbpj0pYM0-GrbdZ6Shncg-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-528ab71c95cso5696775a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jul 2023 23:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688539034; x=1691131034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NUWX5UvhowWYsdPQKhRlSWjHJ9IgFtq6PuCnNgnxE/c=;
        b=PfMmiG+XhhfdLPECSIp3xCbdXtG00xffRSrNl7rfpZrZ1ymqvmcHhNPsdnWZj3G8gg
         BdQZJFFoolQMKWUvw0EMaLM938QvoeOukZKRL9F/J7B4qvR1tTBUZDHfOjfqIB3hXEbh
         hBXVPKd+v7A7BoKOqC6g/4SWJnCmdFhcLWkGhDf/DnZ+NeVxWNHOCWTZu8T7Ar9SJ5sX
         Pfz0AOIRN54ZCko1u8LMjFDZkldsx+DCMK3Fud4GpR1z+JyEEu34TJevXsV1jPlzFLD9
         EvAmNmcvQkAMmZ+mETW7ErYwsusQ6cr8fiij2lbfLDokaY9Rj6K/muFH1Rtqy9GSYHqb
         iaAA==
X-Gm-Message-State: ABy/qLaxsVea+sfmMHxcg295zj4zjrh9GWfOILNSc0FDvWF71S+Js81y
        4GRgfrY0fa5AOMPf86lAEurjHAqdh/S7RXBzv2liEFZdLlDo2u16AhFDiE3aUAVrVkHTZYhGZFS
        Eip97wK1ATLvrzEDb6Q9c
X-Received: by 2002:a05:6a20:3955:b0:11f:b885:e83a with SMTP id r21-20020a056a20395500b0011fb885e83amr14819065pzg.57.1688539033982;
        Tue, 04 Jul 2023 23:37:13 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHtcHVO2xFemkdavNw1sqIuI05mR6jkvj+chy+9Ote8/pYCCNbPd+dkvSc7hMq1p/UWQ7RhJw==
X-Received: by 2002:a05:6a20:3955:b0:11f:b885:e83a with SMTP id r21-20020a056a20395500b0011fb885e83amr14819055pzg.57.1688539033672;
        Tue, 04 Jul 2023 23:37:13 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b001b694140d96sm9233434pli.170.2023.07.04.23.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 23:37:13 -0700 (PDT)
Date:   Wed, 5 Jul 2023 14:37:09 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs/439: amend test to work with new log geometry
 validation
Message-ID: <20230705063709.4grbfaznsddnxf4c@zlang-mailbox>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
 <168840383001.1317961.12926483978316384291.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168840383001.1317961.12926483978316384291.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 03, 2023 at 10:03:50AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> An upcoming patch moves more log validation checks to the superblock
> verifier, so update this test as needed.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/439 |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/xfs/439 b/tests/xfs/439
> index b7929493d1..8c69ece655 100755
> --- a/tests/xfs/439
> +++ b/tests/xfs/439
> @@ -21,7 +21,9 @@ _begin_fstest auto quick fuzzers log
>  _supported_fs xfs
>  _require_scratch_nocheck
>  # We corrupt XFS on purpose, and check if assert failures would crash system.
> -_require_no_xfs_bug_on_assert
> +# This used to be _require_no_xfs_bug_on_assert, but now we've fixed the sb
> +# verifier to reject this before xfs_log_mount gets to it:
> +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: journal geometry is not properly bounds checked"

This case is a regression test case for:
  9c92ee2 ("xfs: validate sb_logsunit is a multiple of the fs blocksize")

So I think it's better to write this major commit at first, before recording the
secondary one.

>  
>  rm -f "$seqres.full"
>  
> @@ -33,7 +35,7 @@ blksz=$(_scratch_xfs_get_sb_field blocksize)
>  _scratch_xfs_set_sb_field logsunit $((blksz - 1)) >> $seqres.full 2>&1
>  
>  # Check if logsunit is set correctly
> -lsunit=$(_scratch_xfs_get_sb_field logsunit)
> +lsunit=$(_scratch_xfs_get_sb_field logsunit 2>/dev/null)

What kind of error should be ignored at here?

>  [ $lsunit -ne $((blksz - 1)) ] && _notrun "failed to set sb_logsunit"
>  
>  # Mount and writing log may trigger a crash on buggy kernel
> 

