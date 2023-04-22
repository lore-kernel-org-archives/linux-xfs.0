Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7358C77B78
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Apr 2023 08:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDVIZx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Apr 2023 04:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDVIZw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Apr 2023 04:25:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C841CE
        for <linux-xfs@vger.kernel.org>; Sat, 22 Apr 2023 01:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682151904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fo98sPRado6i9ZjZ5+U7hRnm9axVVu76O4ZpTTgL5mU=;
        b=gMi5sUWtKvdou+2PNLJZdr+70NbKFf6a7KopDK5uw0pgG9RVunLU7TVxyyDl8VYjQKH03C
        OOzDHfW9HNw2ras0M+td4/cMyRxmuGZrtGS9SkNCD6GFrOICOy26E+R/HZ7PLexSvwK3jA
        HQaNBzhDakrpvawUfzwoWhN8nA8g5oo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-Eyl8ti3mOPC9ogiZJ4eaVg-1; Sat, 22 Apr 2023 04:25:02 -0400
X-MC-Unique: Eyl8ti3mOPC9ogiZJ4eaVg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-24763adb145so2740759a91.2
        for <linux-xfs@vger.kernel.org>; Sat, 22 Apr 2023 01:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682151901; x=1684743901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fo98sPRado6i9ZjZ5+U7hRnm9axVVu76O4ZpTTgL5mU=;
        b=URoD5OSylaGW/u1XCo2tdN2K7yaoIhiuLogvlLhQ+7ueMgyb1ajANJtz/SRn+UIaSC
         z1rELZMSCkCVnp0RY4xWvF8h3oCfCNoM6L+f1nudSv8cGis7iQYJm47qmtKFB868qygG
         UXGHBHzyMAZLj0FCAlzGGH0oP+gkjTQoI0e/JZdib+/vFQPvLT8uTfKWrqwsJvTpxFGz
         dhpfv0XfvRU/jxqNjQEBJm85Keb8bbRfUd5smDPeVwgezSYifzl4c9wDpfgMi4Lgl8jU
         dLUFPTMuEOSd2Xk3ipJHP3Mi+3N2d+cwskXQltKAXd/6c5PrRPwQGgDxLkxFfJkBXJUb
         LQ3g==
X-Gm-Message-State: AAQBX9c5elcmRpq0cgVe1btYUXF7pNg4pEkEAIT+d3Y69YEDj7PoNeva
        /QU8RIcG6suziW3wib0q6ZKAtuVQ57elIC5wdYlyBp3klpASSTm7uTDM0nJn5+Uu0ZHeIMoEzBt
        womrcXN+cEpIlkCq26V2G
X-Received: by 2002:a17:90a:4f0b:b0:247:1e13:90ef with SMTP id p11-20020a17090a4f0b00b002471e1390efmr7685759pjh.20.1682151901632;
        Sat, 22 Apr 2023 01:25:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y/1WYyWDvY7Vd5JNgv35XimIX39iYRM4fzaXqMnxD1AhlmfF7bJ8hnu2D3wO1yivhdczhOvA==
X-Received: by 2002:a17:90a:4f0b:b0:247:1e13:90ef with SMTP id p11-20020a17090a4f0b00b002471e1390efmr7685746pjh.20.1682151901275;
        Sat, 22 Apr 2023 01:25:01 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jl16-20020a170903135000b001a216d44440sm3656173plb.200.2023.04.22.01.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 01:25:00 -0700 (PDT)
Date:   Sat, 22 Apr 2023 16:24:56 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] generic/476: reclassify this test as a long running
 soak stress test
Message-ID: <20230422082456.6nsk5ve756j37jas@zlang-mailbox>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
 <168123683265.4086541.1415706130542808348.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168123683265.4086541.1415706130542808348.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 11:13:52AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test is a long(ish) running stress test, so add it to those groups.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/476 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/generic/476 b/tests/generic/476
> index 212373d17c..edb0be7b50 100755
> --- a/tests/generic/476
> +++ b/tests/generic/476
> @@ -8,7 +8,7 @@
>  # bugs in the write path.
>  #
>  . ./common/preamble
> -_begin_fstest auto rw
> +_begin_fstest auto rw soak long_rw stress

Sorry for late reviewing. I thought a bit more about this change. I think
the "soak", "long_rw" and "stress" tags are a bit overlap. If the "stress"
group means "fsstress", then I think the fsstress test can be in soak
group too, and currently the test cases in "soak" group are same with the
"long_rw" group [1].

So I think we can give the "soak" tag to more test cases with random I/Os
(fsstress or fsx or others). And rename "long_rw" to "long_soak" for those
soak group cases which need long soaking time. Then we have two group tags
for random loading/stress test cases, the testers can (decide to) run these
random load test cases seperately with more time or loop count.

Anyway, above things can be done in another patchset, I just speak out to
get more talking:) For this patch:

Reviewed-by: Zorro Lang <zlang@redhat.com>



Thanks,
Zorro

[1]
# ./check -n -g soak
SECTION       -- simpledev
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64
MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/sda3
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch

generic/521
generic/522
generic/642

# ./check -n -g long_rw
SECTION       -- simpledev
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64
MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/sda3
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch

generic/521
generic/522
generic/642


>  
>  # Override the default cleanup function.
>  _cleanup()
> 

