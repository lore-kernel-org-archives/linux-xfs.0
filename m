Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF69C004D4
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 23:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjASXjU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 18:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjASXjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 18:39:13 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3BC86A4
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 15:39:12 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o13so4023476pjg.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 15:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=rsd55ti6Y4n5bfc1JXN60y9yB8X5/Af5j9U2qhqynCk=;
        b=PGWgrZYmqAHnWUDEEM3C8wE9m3zUFVUbmPH2hgq0jkR6rKX09oKwe+I+NZVD5VZBYH
         j6mBDGI+QIebCsZLb7umVVb/UO1TLhvvSQn3MIIZ1okX3igyxPra6k6xQjbz2+aRtPti
         wlYYEJut+OhinNzX/0nG0p+e/s5ikjMmnjHD24DuhfG8fBn6wMquHrvXGp87qKe/NoMX
         H7sz42BtS5Vt8bxIsnlzcZWHJ7o6mNJy8Kx2Qwkij+rWA8KxkFEo0UfODjvkjFN28Wdv
         dyOrhkkDY3K2D02P3IXV/c/X0ni7g1UoFtuQV2SoxpwNUCrHfrbpHs2EdW8W2jiGq05R
         cUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rsd55ti6Y4n5bfc1JXN60y9yB8X5/Af5j9U2qhqynCk=;
        b=kgNTsTUX3etMdpxVAyXZQTximETAflg0mNsqPTC7vnvlU7RMo/jC9swxJA17ee/Wzc
         iPSPOFEq1JdeCkJpXVBIGdtGFhP67YOQ74vNKHk8tOY9ew7bKczI/zXLeP4q+QFK0Ww6
         haGqN9/v3r1CjlUJ143Z3UVW74fTUToSotHWoLbRX5rtzfbxQ5kcopaGwQ7jc+C3zFiM
         ZISU7NRFzMoz4Rq/gjfieyn4yZiRxZyOMcXONXYKkt0fM1JnW4D00n9ZQ06eO0G37UCq
         PMQkGnsf7naZzpTVo3VCprNPA67B2HxUU3md1dS6NS9FlAuIIGTaoW9RvJCgHQ9HjC+6
         tIiw==
X-Gm-Message-State: AFqh2kpc21Ovq3/Sp9FS7t8haYLQpv8SPT2CpKDD0p0b+oxELoU2VO1m
        EsAOiaLGwPGd2kSzE/7HcXmeHhVCa7951EPY
X-Google-Smtp-Source: AMrXdXugK3sGnsWLUSjsHxE7deLpOm4GCH1UaMuNSalK1L1cQ20ioYL8QFnBK+Ot0mxhzB8HoMLY1g==
X-Received: by 2002:a05:6a20:bc84:b0:b8:adcb:a92b with SMTP id fx4-20020a056a20bc8400b000b8adcba92bmr11310094pzb.36.1674171552247;
        Thu, 19 Jan 2023 15:39:12 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id d8-20020aa797a8000000b0058837da69edsm21049472pfq.128.2023.01.19.15.39.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 15:39:11 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIeUv-00581e-3H
        for linux-xfs@vger.kernel.org; Fri, 20 Jan 2023 10:39:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIeUu-008cfk-2k
        for linux-xfs@vger.kernel.org;
        Fri, 20 Jan 2023 10:39:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfsprogs: fix libtoolize issues
Date:   Fri, 20 Jan 2023 10:39:04 +1100
Message-Id: <20230119233906.2055062-1-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI folks,

Just hit the problem fixed in the first patch trying to build a
6.1.1 release. I don't know when the problem started, or whether
it's caused by upgrading userspace on the build machine, but I don't
really feel inclined to spend hours trying to track down some whacky
environmental issue that we really shouldn't need to care about
because the code that is breaking is there to support 15+ year old
build tools.

The second patch is just cleaning up the libtoolize mess that MacOS
platform support required that is no longer necessary because I
noticed it at the same time....

-Dave.


