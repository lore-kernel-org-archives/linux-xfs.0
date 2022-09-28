Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EE6C04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 10:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiI1KGk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 06:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiI1KGP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 06:06:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAA2CF4BC
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 03:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664359573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3gw4vvdbnXkqVMQRkylbZBkR8vSzat91OmvnbQMTGlg=;
        b=Yv69dMCpAM8jpxkNyMvWmllPe1zQiPceGT49qF9svy9Pf+jubQPtChV+Z2v/UcVktjL1Hh
        wux7hyyY6L+VshzZC/u2ZufC27x9egJT1FE6M7VP1GUPmNQCVHIW2gE3JbRR0Gx4/Dz+vP
        u/AwonZKI8wlFtOaacCSlnQMsuqhE4M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-460-xfBRXGjvPRawnCgBuI6Ytg-1; Wed, 28 Sep 2022 06:06:10 -0400
X-MC-Unique: xfBRXGjvPRawnCgBuI6Ytg-1
Received: by mail-qv1-f72.google.com with SMTP id ll6-20020a056214598600b004af9fc1faf8so180410qvb.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 03:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=3gw4vvdbnXkqVMQRkylbZBkR8vSzat91OmvnbQMTGlg=;
        b=LvpPWCPvJNWO2MfhZN7rMZDO/IGvoi4/tq2E9rVXYc2JQ7xKCH3P420sRSo8RAnVIL
         1kE1uCaTrytBxUxrvkG5jZvu312Bp7qL4AUHoJXcOP/LEuOZdepEsFdL5dO6MEoJiD1c
         m4opGob0cAS/OXVnwobmG0mVIVNzwYlqlO5JLV4bqaGhIBalj/HzSzweVwtZuuvjQ2ND
         hk6v7pJ/BYp8S0+cfclhda503FGVeBQ5Ub/73loZodki4KCvqk5OO6w0orU9T5wGHNhR
         pQzu4ZPtCVqxzNTyX4PNUt9BV+PFhklWkOvgkTqO+MUnT+uNZNWcbsm9kDFP1TLzMlCw
         QHug==
X-Gm-Message-State: ACrzQf0vjt84RSZlP06b6/MQNr4VlvLPjf6JCHqPaNurMHBATSltjAq2
        yxls7QV2HLWthGwFmSCLHXb8x6BSXPWz0Uv4aXphMlS39xsqWebvpzUP3arcbsTwBcpeAXAdh3o
        ttffRYbyL0o7rRXLmng5l
X-Received: by 2002:a05:6214:27cb:b0:4ad:1a90:61c9 with SMTP id ge11-20020a05621427cb00b004ad1a9061c9mr24839692qvb.110.1664359570091;
        Wed, 28 Sep 2022 03:06:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Jj/KGBDss4X8kpp/uS3tFoxeZIrCX/F5lIxS7m7U7qBE+XuvyN35hK8rs8ebojGEeWjLQAw==
X-Received: by 2002:a05:6214:27cb:b0:4ad:1a90:61c9 with SMTP id ge11-20020a05621427cb00b004ad1a9061c9mr24839683qvb.110.1664359569915;
        Wed, 28 Sep 2022 03:06:09 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i5-20020a05622a08c500b00343057845f7sm2650118qte.20.2022.09.28.03.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 03:06:09 -0700 (PDT)
Date:   Wed, 28 Sep 2022 18:06:05 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] xfs/114: fix missing reflink requires
Message-ID: <20220928100605.c57deoxrwtuh42uj@zlang-mailbox>
References: <166433903099.2008389.13181182359220271890.stgit@magnolia>
 <166433904232.2008389.13820157130628464952.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166433904232.2008389.13820157130628464952.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 27, 2022 at 09:24:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test both requires cp --reflink and the scratch filesystem to
> support reflink.  Add the missing _requires calls.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/114 |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/tests/xfs/114 b/tests/xfs/114
> index 3aec814a5d..858dc3998e 100755
> --- a/tests/xfs/114
> +++ b/tests/xfs/114
> @@ -18,6 +18,8 @@ _begin_fstest auto quick clone rmap collapse insert
>  # real QA test starts here
>  _supported_fs xfs
>  _require_test_program "punch-alternating"
> +_require_cp_reflink
> +_require_scratch_reflink

Good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  _require_xfs_scratch_rmapbt
>  _require_xfs_io_command "falloc"
>  _require_xfs_io_command "fcollapse"
> 

