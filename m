Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25979C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 02:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A09960FE6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 02:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhHRCuA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:50:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231449AbhHRCt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Aug 2021 22:49:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629254965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAx2EXb5PV6WL0fY57KJ3BzYBKoFOjh28NeBiEwPKWA=;
        b=A7blZBhoD3gtsrjCbPXXzJe3XsFdmIC7B4qjwCiRg7dMFyOahCgfN7Ad75QAwHrAQfB3Sz
        W+dVPnYrUvI1aIrYRDPc9SlFCx5PuE1MCJ0+1SUmHvgFY/moh7Q+e/7FoKTkEpmYHrjMIT
        X1MbOWfFEW/1XHJ0Wi9Hk/y6IAdidm8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-AYD5uwXFORCiKeH78ewZgw-1; Tue, 17 Aug 2021 22:49:22 -0400
X-MC-Unique: AYD5uwXFORCiKeH78ewZgw-1
Received: by mail-pf1-f199.google.com with SMTP id p40-20020a056a0026e8b02903e08239ba3cso444944pfw.18
        for <linux-xfs@vger.kernel.org>; Tue, 17 Aug 2021 19:49:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=QAx2EXb5PV6WL0fY57KJ3BzYBKoFOjh28NeBiEwPKWA=;
        b=SsGjQvbcKlLHZh2unxMG5yKSGuGcYMGgouvzzNClSjuTnjYKss6nL0htGUGZQ1lt4C
         2Jg7dWIfzDWfKG6BgW+3qwaJa2m78LGOmS1w/vhe31cTf4Deit270LklC9WUNsoFe/qJ
         K27TuY3/Uo2RGrIXuPCtli6O9oQX7WSxKDkBegDri58YBi/QLI06l1RDn3dUXwU36MwR
         zOaA61bsgd7NNMOLeG1Ld2Aw2LJE+2XvZn+Hwp7sUPt4/mm9PEwN5teYsngVI8Wd4C9F
         DlU5Usc0mFVYlyE96QE4gXi9fotCm1kvKfl05nTB5toj0s1HpPaoF1i0gtsYiVvedZoq
         PcRw==
X-Gm-Message-State: AOAM533IJz/rvh0nt4XGQQ4uAPy7owYvcxEGxiOahQuHUIUsXKUaC4O/
        w809MvKiNDS8mD2mdF727IQnfEoi04EZFU1MKN2J7TMc1Rw50f/FrkqjnhzwC2jvncNDn/prrU/
        QH91N3xecTpt4QzpOua1A
X-Received: by 2002:a63:a4c:: with SMTP id z12mr6606908pgk.185.1629254961205;
        Tue, 17 Aug 2021 19:49:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfhC833MCr1o/5inc1CWHJu5CMgV55gcYQyMgYEOzsbRW/U8iH5piBPrzc4Anoz++qf4y52A==
X-Received: by 2002:a63:a4c:: with SMTP id z12mr6606880pgk.185.1629254960873;
        Tue, 17 Aug 2021 19:49:20 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t38sm4049627pfg.207.2021.08.17.19.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 19:49:20 -0700 (PDT)
Date:   Wed, 18 Aug 2021 11:02:02 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs/176: fix the group name
Message-ID: <20210818030202.h5ulaippfk33gas7@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162924437987.779373.1973564511078951065.stgit@magnolia>
 <162924438548.779373.13859752576829414097.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924438548.779373.13859752576829414097.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:53:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Filesystem shrink tests for xfs are supposed to be in the 'shrinkfs'
> group, not 'shrink'.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Yes, you're right:

[zorro@zlang-laptop xfstests-dev]$ grep -rsn _begin_fstest tests/|grep shrink
tests/xfs/176:11:_begin_fstest auto quick shrink
tests/xfs/163:13:_begin_fstest auto quick growfs shrinkfs
tests/xfs/168:14:_begin_fstest auto growfs shrinkfs ioctl prealloc stress

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/176 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/176 b/tests/xfs/176
> index ce9965c2..ba4aae59 100755
> --- a/tests/xfs/176
> +++ b/tests/xfs/176
> @@ -8,7 +8,7 @@
>  # of the filesystem is now in the middle of a sparse inode cluster.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick shrink
> +_begin_fstest auto quick shrinkfs
>  
>  # Import common functions.
>  . ./common/filter
> 

