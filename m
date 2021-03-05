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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82216C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502A46502E
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhCEIf7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCEIfw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:35:52 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D9AC061574;
        Fri,  5 Mar 2021 00:35:50 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s7so1051248plg.5;
        Fri, 05 Mar 2021 00:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ChSzM0qDvheNp/Vqezi0JRID4WQjEumbHzf5iOxDs58=;
        b=YXvI2hMLiADyZeZeOCHlam9DfSLyHOgNvPrMl3DN3etFl7d1FANAe0CGPbS1fozD9O
         pkgve18Gd1GSiZy0pj3rPqh92KKrl468jyrSEC2yp/QDbNqtM7vKg9ORYVCU4ODM7v62
         iwBCRXbMRewncjBk53BKGYfSwVlT1rZvMaUGYkcH94qg9GPsxQSbs+gg06WBpHqYmiCI
         w82pW4LFldSIBOLN/LPDT0eBoon/9blDHmkqHqMCUBvRHHHcEt4nzFGnYBWKdGPL8iPM
         1X7nje1n1l2UCrjnA7RDIEVaoB312SF8MvIILGJdOuiw4CXK/SQKq1fKEWchdOdZ70Ac
         CKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ChSzM0qDvheNp/Vqezi0JRID4WQjEumbHzf5iOxDs58=;
        b=ktZp1J5jGQw1KDZPCJCCotd1Qd1s3gylRFuKqn0iNjpvALBhr4v0IVp19Yu6XWkW+f
         fLaK1X1uL4M3LbAk5c1uh2PpeqORaMcwhpoo0kRahDMZjJ3EmbXersj3bCoMR/a0Yl4x
         me4RrIwZG8w5imehUfsg/eUnfJK00ecK1+BHXyUdv/Uzkq9/KbphdQ8BrpPWCSDwvq3H
         ZLOSmLYQaLyhFRuAwB1VjZDcp8d+q/zTaR8FqnZsCsb7nkYEy7IK3oWNIDjweonhBZcZ
         eGiiHJlSOLL/2ujsZuVG/grQXo3qCAgn/rjyt02s++pZn1LM4Lb88SC/xQB90BJU1tRm
         TcSA==
X-Gm-Message-State: AOAM532r9HsPXlVwr43Y32C4NiULWW9g4x49o5+SLi7jR6e5KXasTKgv
        RUUXRJXKHLx7MeMwzd4BA1KkvWT+s8A=
X-Google-Smtp-Source: ABdhPJxHe58QCSbz6FSCX9e5PdCkFYvEJ+EEd1sORSNfG2bulGuFG5vPnkz8muN7WCgCy3dMj6UqZQ==
X-Received: by 2002:a17:90b:4b87:: with SMTP id lr7mr8593420pjb.5.1614933350234;
        Fri, 05 Mar 2021 00:35:50 -0800 (PST)
Received: from garuda ([122.171.172.255])
        by smtp.gmail.com with ESMTPSA id h6sm1786885pfb.157.2021.03.05.00.35.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Mar 2021 00:35:49 -0800 (PST)
References: <161472735404.3478298.8179031068431918520.stgit@magnolia> <161472737624.3478298.18322455058303982173.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/4] generic/60[78]: ensure the initial DAX file flag state before test
In-reply-to: <161472737624.3478298.18322455058303982173.stgit@magnolia>
Date:   Fri, 05 Mar 2021 14:05:46 +0530
Message-ID: <87k0qmt2u5.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 04:52, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Since this test checks the behaviors of both the in-core S_DAX flag and
> the ondisk FS_XFLAG_DAX inode flags, it must be careful about the
> initial state of the filesystem w.r.t. the inode flag.
>
> Make sure that the root directory does /not/ have the inode flag set
> before we begin testing, so that the initial state doesn't throw off
> inheritance testing.

If $MKFS_OPTIONS has daxinherit=1 option then this will cause all the inodes
created in the new filesystem to have the corresponding flag set. Hence the
patch is correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/607 |    4 ++++
>  tests/generic/608 |    3 +++
>  2 files changed, 7 insertions(+)
>
>
> diff --git a/tests/generic/607 b/tests/generic/607
> index dd6dbd65..ba7da11b 100755
> --- a/tests/generic/607
> +++ b/tests/generic/607
> @@ -156,6 +156,10 @@ do_xflag_tests()
>  	local option=$1
>
>  	_scratch_mount "$option"
> +
> +	# Make sure the root dir doesn't have FS_XFLAG_DAX set before we start.
> +	chattr -x $SCRATCH_MNT &>> $seqres.full
> +
>  	cd $SCRATCH_MNT
>
>  	for i in $(seq 1 5); do
> diff --git a/tests/generic/608 b/tests/generic/608
> index dd89d91c..13a751d7 100755
> --- a/tests/generic/608
> +++ b/tests/generic/608
> @@ -98,6 +98,9 @@ do_tests()
>
>  	_scratch_mount "$mount_option"
>
> +	# Make sure the root dir doesn't have FS_XFLAG_DAX set before we start.
> +	chattr -x $SCRATCH_MNT &>> $seqres.full
> +
>  	test_drop_caches
>
>  	test_cycle_mount "$cycle_mount_option"


--
chandan
