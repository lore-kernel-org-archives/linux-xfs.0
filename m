Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AC8EE800A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Sep 2023 14:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241340AbjIHOPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbjIHOO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2023 10:14:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0AD1BEA
        for <linux-xfs@vger.kernel.org>; Fri,  8 Sep 2023 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694182446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/gHYeaHYW7J0BYQ2w5FPEK9IEdhsXOZobbaMgeO5V28=;
        b=FaAFQMzKKJm/dxFA3Qs1X75dAsjuL6aZAgW5rtXwbhnw4DEYZzetbirnipWiCNIS9SW5yT
        XRdRWiugNxMC1igzXWx0lrKlGujWTV7ONcTLOg9IQv/4OJ0xVBfrMLDxQYaa7NhBtTI2uo
        lRE6GsiQPj9EGziK3MpUB+kTwiac/lk=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-AcP57CR3Pze0075czofdHg-1; Fri, 08 Sep 2023 10:14:04 -0400
X-MC-Unique: AcP57CR3Pze0075czofdHg-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6bc4dfb93cbso2303158a34.1
        for <linux-xfs@vger.kernel.org>; Fri, 08 Sep 2023 07:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694182444; x=1694787244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gHYeaHYW7J0BYQ2w5FPEK9IEdhsXOZobbaMgeO5V28=;
        b=iVOMivpFmR90LwzdDcYeykWi0j5jckFLWp0Hg6ZiVPes39/pBSZZ7P5nSRFpo7c6Uk
         z4EcH2BTFPCjVE24Rt1JFXLmWmkcE926A6tyQh0CxUv1oAAfyDZDTCyqCMEVvUeforOe
         3+QuMQlB0CX04PLOPOydzo8VgdIZH9sGZJ51XuAqnj+/4l/ArR+bY25W+MS7EWarJhDl
         GUKQpiH9L8qsNV9V0V3FdSPwLPUH+IFH9WfezX7atIC9I4QfV8QKjLRCzWz3G4TUMaIc
         IOfAbyUxBNX6ZqY+k7ALZ+P8IHpxUC+PnG34BoJ+dejY3315YPQZwO0vx6rx1RDhcuMM
         iSKg==
X-Gm-Message-State: AOJu0YwvEidAIae7+2/1/15BwXAesXUB4udtImDy9FAkL/beVfXzwS7l
        U+qIQD43yB+ujIIZ349jWJrlrWdTxX7DF4NiA7o2uHcak350qv2KDEbuoK3ZkKxtSfQJZ4mcnFj
        Heax85fZgMJTzvWY1mYZIhxoBENoWatU=
X-Received: by 2002:a05:6870:b01f:b0:1b7:4521:14b6 with SMTP id y31-20020a056870b01f00b001b7452114b6mr3176049oae.5.1694182443865;
        Fri, 08 Sep 2023 07:14:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJihF/78YrUKgSIobBXtmksWFNQLKLPurOkSKqU+mhAvyR2a5y4tSUivfWywunndUdkT2PIA==
X-Received: by 2002:a05:6870:b01f:b0:1b7:4521:14b6 with SMTP id y31-20020a056870b01f00b001b7452114b6mr3176009oae.5.1694182443003;
        Fri, 08 Sep 2023 07:14:03 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i69-20020a639d48000000b00563590be25esm1238406pgd.29.2023.09.08.07.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Sep 2023 07:14:02 -0700 (PDT)
Date:   Fri, 8 Sep 2023 22:13:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     cem@kernel.org
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common: fix rt_ops setup in _scratch_mkfs_sized
Message-ID: <20230908141359.4di6fyo52rengnks@zlang-mailbox>
References: <20230908121234.553218-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230908121234.553218-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 08, 2023 at 02:12:34PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Tests using _scratch_mkfs_sized() will fail if SCRATCH_RTDEV is set,
> but, USE_EXTERNAL is not, this happens because the function pass
> "-r size=$fssize" to the _scratch_mkfs_xfs argument line, which in turn
> will not set rtdev because USE_EXTERNAL is not set.
> 
> Tests like xfs/015 will fail as:
> 
> xfs/015 6s ... [failed, exit status 1]- output mismatch
> .
> .
>     +size specified for non-existent rt subvolume
>     +Usage: mkfs.xfs
> .
> .
> 
> with this patch the test runs properly using the rtdev if USE_EXTERNAL
> is set.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Particularly I think SCRATCH_RTDEV should not depend on USE_EXTERNAL, as the
> latter is also linked to external logdevs, but I noticed tests specific for RT
> devices also set USE_EXTERNAL, so  I opted to change it according to the current
> usage

According to the fstests/README:

  Extra SCRATCH device specifications:
   - Set SCRATCH_LOGDEV to "device for scratch-fs external log"
   - Set SCRATCH_RTDEV to "device for scratch-fs realtime data"
   - If SCRATCH_LOGDEV and/or SCRATCH_RTDEV, the USE_EXTERNAL environment

So the USE_EXTERNAL should work with SCRATCH_RTDEV too. So this patch looks
good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
>  common/rc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 1618ded5..20608fbe 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -965,7 +965,7 @@ _scratch_mkfs_sized()
>  		[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
>  	fi
>  
> -	if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
> +	if [ "$FSTYP" = "xfs" ] && [ "$USE_EXTERNAL" = yes -a -b "$SCRATCH_RTDEV" ]; then
>  		local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
>  		[ "$fssize" -gt "$rtdevsize" ] && _notrun "Scratch rt device too small"
>  		rt_ops="-r size=$fssize"
> -- 
> 2.39.2
> 

