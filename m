Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C02CC43463
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 09:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 125712073A
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 09:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pKRVVzOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgISJpq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 05:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgISJpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 05:45:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1287DC0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2020 02:45:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t7so4501800pjd.3
        for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2020 02:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0nYnLjQXT0tZ/Rc6uAjrO0mlf2aEnvRJ3VfSyLmUy2k=;
        b=pKRVVzOyQyt6edmCstoE6cK40BiJNqVSGpsRF08AHgTz9a/9pJYJtaonNFVaJjaugL
         2GhNQ1g6vcJdHhuEUN32nvGmJiluWt1VpMDS2Qoe5rfqD3WfHNmSAz6k2voMO/4bw/AX
         JHE0NiyGnphT5JIeQ9Mw+5TWmZnwDFwhiByN3D6Xnw6JlBvLi0MuTh/jMz1DIxqKZFqa
         5KHs5Kl/87UBObPychEJOKIbGzu1xIOPLVbdwyLghMEdzK22xi53fgP8AddKofqyH9Br
         +9F3XMJchSc84n2hHqMcD/OTPuLOjAJLuVM7fxHm2D0QbIcuubS0bm6tWAHdjXIQaCRh
         9mXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0nYnLjQXT0tZ/Rc6uAjrO0mlf2aEnvRJ3VfSyLmUy2k=;
        b=HVKwG10H2pRft5pRb3Pn0uNnwKeYM/S6TSAu9yKAGq6Z3Ad78vWixmRwpQZ8714ts5
         wr/1uaM23pgrPV8PAPeDxku2d2UzXQ4lrnqc+TJAGAXIGx88osIfpbXNz4P7j+a7c/D8
         4coftPCeAwXXps7sw9vf5rkvkUMZEYC8X7KZt9j9wJoR+qnP58/04Bd8WM+Y3z0lQBgM
         NLBiDsdx82BkXB/AUye3dk5oCn+oGLX7vF9/l1kUsWFAAgo9WaUDLIx7HVU0BJtszWsU
         g9PgXKTTXOevl5PBAGvuQ0twzywAMRcwGWylNGxry+Dy5vbsw/P0i9oVgNsdBnR2Xp0F
         zY3Q==
X-Gm-Message-State: AOAM531dRhvp6COTHdzyxlgdOINHTnz1nO5gCRqU80eMbgFAMNOkeMOK
        sl5lWohrCo/ghWeX78zumTM=
X-Google-Smtp-Source: ABdhPJwDPQQ7+LTdl0SBQx7Ota6BIZ5QA8cBBQJdAhmHWhm2hhq7/h8sScncu/J80fjFWE8RMCOiKQ==
X-Received: by 2002:a17:902:9f84:b029:d1:cc21:9a49 with SMTP id g4-20020a1709029f84b02900d1cc219a49mr25128161plq.9.1600508745650;
        Sat, 19 Sep 2020 02:45:45 -0700 (PDT)
Received: from garuda.localnet ([122.171.63.16])
        by smtp.gmail.com with ESMTPSA id x3sm6148117pfo.95.2020.09.19.02.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 02:45:45 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 10/10] xfs: Introduce error injection to reduce maximum inode fork extent count
Date:   Sat, 19 Sep 2020 15:15:42 +0530
Message-ID: <3295439.FJLT6Hgy6b@garuda>
In-Reply-To: <20200918153930.GX7955@magnolia>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com> <20200918094759.2727564-11-chandanrlinux@gmail.com> <20200918153930.GX7955@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 18 September 2020 9:09:30 PM IST Darrick J. Wong wrote:
> On Fri, Sep 18, 2020 at 03:17:59PM +0530, Chandan Babu R wrote:
> > This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
> > userspace programs to test "Inode fork extent count overflow detection"
> > by reducing maximum possible inode fork extent count to
> > 10 (i.e. MAXERRTAGEXTNUM).
> > 
> > This commit makes the following additional changes to enable writing
> > deterministic userspace tests for checking inode extent count overflow,
> > 1. xfs_bmap_add_extent_hole_real()
> >    File & disk offsets at which extents are allocated by Directory,
> >    Xattr and Realtime code cannot be controlled explicitly from
> >    userspace. When XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag is enabled,
> >    xfs_bmap_add_extent_hole_real() prevents extents from being merged
> >    even though the new extent might be contiguous and have the same
> >    state as its neighbours.
> 
> That sounds like fs corruption to me, since btree records are supposed
> to be maximally sized.
> 
> > 2. xfs_growfs_rt_alloc()
> >    This function allocates as large an extent as possible to fit in the
> >    additional bitmap/summary blocks. We now force allocation of block
> >    sized extents when XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag is
> >    enabled.
> 
> Ah, so your goal is to dramatically cut the MAX?EXTNUM and then force
> the allocator to fragment the fs, so that it will quickly hit that
> maximum.
> 
> /me suspects that "maximally fragment" ought to be a separate error
> injector that teaches the alloctor to satisfy the minimum required
> allocation, and to look only in the short end of the cntbt.

This looks like a perfect fit for my requirements. I will take a shot at
implementing this. Thanks for the suggestion.

-- 
chandan



