Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E5CCD6E5A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 11:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjJKLK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 07:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbjJKLKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 07:10:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5814124
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697022562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/7i0TJFI9d4XbjTdESSdpldcYJIKaHsNys5HjyA4API=;
        b=hcKK0i3bjgKvgFH6UImt3NWSGPkB3f6x5sMifMIt9vlr46qKy2vU0+eR9ATjlXdCYMa1Bz
        0RYnMP5HMpGAd92UL0/IF6YyAbLmRRfJj7X775BlwQ6WWXzTSrPrKn43pr0Ucfh2n6n+P3
        Zf9UTnCo8rjydztaysVR2WEozRgJMVE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-gDL_jYjCNou64adm9alArg-1; Wed, 11 Oct 2023 07:09:21 -0400
X-MC-Unique: gDL_jYjCNou64adm9alArg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5068bf0b443so4414392e87.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697022560; x=1697627360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7i0TJFI9d4XbjTdESSdpldcYJIKaHsNys5HjyA4API=;
        b=w7GKCa3JjxoCraM3Mnxz1QECypcdfXbGRicdZXkHnQambduOyKdsHx+uFKDIgCEzpy
         THJy6ymLbcMnm8UHhmMD0ci1yzUjpCGNSIXaZVvrGmeZm0cKlJxSeHQRKnJh2rQnXesO
         j8WxRgFg/cUjyajxu/6MUoy8Bb2TBoWpDzCWeGj9MNEEKN9Bzrbu0xoPecUHXdTvmtly
         7l/t3QWmIZ+Q/p3dayCRHAP49KRJnsdB0SyoDhoKC8OhcgNJi00W+9hQpz4NxeqvhMzi
         /FykpGCIas175nNczyELwK7nc/nIf+uhoXEb5YF5LBhbc6MQKnr/Ut/oKJfXDXeSksNm
         6PgQ==
X-Gm-Message-State: AOJu0YxFwEvTFjJiEiqZCjrOCL90aXUVembDFI3ylQsi9aRqGDfIYpkR
        nz6enJNPWo0+a/SgAUq+uNBs/uC/752/wuotV4SRpUVZilTuSQLXeHggigE3D+mZhv7og6SDyl7
        Q8gvWGMYYsPmNFn1gvhI=
X-Received: by 2002:a05:6512:131b:b0:503:3421:4ebd with SMTP id x27-20020a056512131b00b0050334214ebdmr17941167lfu.63.1697022560036;
        Wed, 11 Oct 2023 04:09:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrllkG05Ach5liC9J7rG6Cgh0JKuFlyZ1Ps6tj2NTHIqGbPHXOS23Vt7t0IiuUT2NNIcszvQ==
X-Received: by 2002:a05:6512:131b:b0:503:3421:4ebd with SMTP id x27-20020a056512131b00b0050334214ebdmr17941144lfu.63.1697022559604;
        Wed, 11 Oct 2023 04:09:19 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id l21-20020aa7d955000000b00537f44827a8sm8753240eds.64.2023.10.11.04.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 04:09:19 -0700 (PDT)
Date:   Wed, 11 Oct 2023 13:09:18 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com,
        Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 04/28] xfs: Add xfs_verify_pptr
Message-ID: <6g3pgk5lne5otglajnnt6badujg2x45uwevv63j5hxngnomqmr@6clv7xn6x2zd>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-5-aalbersh@redhat.com>
 <20231011010143.GH21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011010143.GH21298@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-10 18:01:43, Darrick J. Wong wrote:
> Could you take a look at the latest revision of the parent pointers
> patchset, please?  Your version and mine have drifted very far apart
> over the summer...
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-fsck
> 

Sure thing, sorry, haven't checked if they changed.

-- 
- Andrey

