Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2998ECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 18:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJXSlO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 14:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiJXSkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 14:40:55 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5636823169
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 10:22:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m6so9575043pfb.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 10:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2Br7gTGg+bTYjhFikYlTyWIS7XZ/zfRJ4l4mR4BaWnw=;
        b=kzio6O9foLsTdduw4qPWtUunGy7dBPJQWatiZpSYElPVhm7XOnXTntO5nGwbz5Jvks
         3hz7ne7iZC6ZidsmPuTeRpLDSFBpb51Fdso6dMUpyV/yXEX4PV2EXtbQsWKYjS30MUMy
         VEVBye+YalzCl05HweQ5bEdpYqGAFXcc7YWwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Br7gTGg+bTYjhFikYlTyWIS7XZ/zfRJ4l4mR4BaWnw=;
        b=IG3e0iTqEJrJqsK0qHDJYjCTg6yzcD7LCUZl+XvUyn/WePy+e2cr7Oe11zo56TgIDH
         5NNblX7IK8dGyrD692vemykx0s828RAhRwKpXEozPhwZZ81hF5JNnu7vZZNSt8nfc1vB
         K9zT+JLzicDtRjHBjHJcWBpaxmV2dy0/tcRMsMgA8mJQooys5in0bjxHLTZObcwQiiEv
         Om62zrL7ywA1S1+O0YdMsPHwdd5gR7foV344gUaRf+o6jM0JHvTEWSmhvfo8QtBP+/aU
         mJbGWv2e3U+mtLRJLFxKyX7gEvQdIwQyoiferixaqhhcpf0oSCYUTR5Zwzt2ooIOCD9F
         umxQ==
X-Gm-Message-State: ACrzQf1l3JrgeBs5N+wDZkrtOEDqG1og76Vu7iNDM8nDEqTu0/5xaJcA
        PPF6ZxJ8GmoVgMBXUUPLaKPcSA==
X-Google-Smtp-Source: AMsMyM6Xf/Ay80cc04aGFXkV1EKdELuQWBz0ZTP9I2z2QQPt8yJjKHPxmWAgCU+8kCnc0Yjjbik3Xw==
X-Received: by 2002:a63:f903:0:b0:46f:1b5:b4fd with SMTP id h3-20020a63f903000000b0046f01b5b4fdmr5864583pgi.544.1666632060784;
        Mon, 24 Oct 2022 10:21:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902714200b00172a670607asm19265269plm.300.2022.10.24.10.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 10:20:59 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithp@keithp.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Zorro Lang <zlang@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2 0/2] Introduce flexible array struct helpers
Date:   Mon, 24 Oct 2022 10:20:56 -0700
Message-Id: <20221024171848.never.522-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=700; h=from:subject:message-id; bh=x8uV4aZZztVTmbVMfTDapI60PBgowK00+Q+TiPkLUcA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjVsl56wyNYJzpsbCQL6ohWRdrL8nrZWH1C9b0EBI3 /3hg+QaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY1bJeQAKCRCJcvTf3G3AJp3hD/ 9v0h2HOPT0KyV9Wj+/DDXGTNfp/v78T2NN4VTDIWF9kfNT6gT9udpBvDlL8pQHJOICxaNrYg5cgU9R cvDFc5ySXOydg+z588o2heFtR6qOFdJEINyeRVRD4ue22IHHNYcwhQo3P74c3p2C6ho69L8GWCv46P dEXF5lBV+0KCgbBa/YedDUOU1G0cM5G8axwJciEI0GW7Pum/EDLLp2WX0aUUKiYhuvI2EBIRrrLkjq fJ04uDNEh9LdMRsu/N0Tr0OLRuelhmfga6IIQ0isHJ01FNViYhutX7nOGUjSYnIVZA1Ctk37Fu+aB2 hz3i9i3jypYhLpk9PYhRA6JUq52rC98D3Gn+LKF9quKWkLOXrbCUIDAmlGU0P+dwokq77BYJN4QMjs kaNGQ/yqYXU43FnajQMtF8Pp8spcEn6WyVGLnAwz9WoQNa3f0VDD2SbJDEFpt3ZUFm9RTYAU1LlNzC m2kWPSwWkCsn28Swuw/r/zgh5T41RFP/xVn/fbq44PIbV3+VPnE52BO2z99U5CWHJlhKKBRY4+L1S4 KVjZhjG0SpfQP6pRURij0/JIM6vhDr2yF9KgJxZmPGVBUoXdLxGbD4uA9b+XR4ekc6EnbC4HFR8NX8 2G0TrY2OsBOkvoq7z9WNDVWW8pcUtwVLjfmYu0oD/h6rCTmiuteuImcFwYCw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Here's a trimmed-down version of my original proposal, which just includes
flex_cpy(), as this is needed by XFS.

-Kees

v2: only include flex_cpy(), leaving remaining helpers for the future
v1: https://lore.kernel.org/all/20220504014440.3697851-1-keescook@chromium.org/

Kees Cook (2):
  Introduce flexible array struct helpers
  xfs: Use flex_cpy() to check extent copying

 fs/xfs/xfs_bmap_item.c      |   7 +-
 include/linux/flex_array.h  | 325 ++++++++++++++++++++++++++++++++++++
 include/linux/string.h      |   1 +
 include/uapi/linux/stddef.h |  14 ++
 4 files changed, 344 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/flex_array.h

-- 
2.34.1

