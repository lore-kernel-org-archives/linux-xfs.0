Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3A2C6FA86
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Sep 2022 18:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIFSgd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Sep 2022 14:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiIFSgR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Sep 2022 14:36:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A07680480
        for <linux-xfs@vger.kernel.org>; Tue,  6 Sep 2022 11:36:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v202-20020a252fd3000000b006a8f6c5d39bso5312637ybv.21
        for <linux-xfs@vger.kernel.org>; Tue, 06 Sep 2022 11:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date;
        bh=i0R53TAK8Pvv1dqj3X6sLp/mYhXJAf8bewUjnJrtogc=;
        b=oiA1uT/TkBmmqbTWbkabtss704rsOio/xfNZfZkhOW8PVou+H8Sv8ARoqgMaM+bH2c
         lsZWIaE+KwXDl4TaNk8A3Lp4MLSqKCjh7EspIfr2aukRK0hhUp8PA3GJp3LzzCNs6n5Y
         25F5Ee2zOh8ZUuD3dbNEj20UEMQO9BsEqIRTqlIWk7wh6i2HATLmFT9HW8nPRNdUq3Xu
         CkLUW2U9hBCCzIRQyFuO7a/KALCtcGG10BeaMiFp3NucRsG7fJyBBw7vg2kkjJMLuQrs
         M5HYZcOsqT5kk6KlIzWYt8jR8UiEyF8kYKHcxNQxfCHecs7htrEolEeoYl2YKgUx589X
         EQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date;
        bh=i0R53TAK8Pvv1dqj3X6sLp/mYhXJAf8bewUjnJrtogc=;
        b=EOJ21sE4atDqh+0eI1m73+qwyXPWYUKZ1ywOYkaDp8a5k2fsVF35IT+8YYsKskjsYH
         +x97uj4b5Ca9Af7JXbj92w6j62+UWrBCarin/sHR0XkGA1fbWkMboJUdz/MFjgu0WL23
         kWinVB8PLvP3r3Y118TC6KSo0T/i7nXcBEkFdSbjLaClzmIk34WiCAAmm5cHjlHhh1yk
         vh/DwEDWROv2maEV93p8BjpTZVcFqfPvkdvQYvF0o6vb7b2caCguBvIhyAHsgJlrfVGc
         EBNes2d5ESmW5iIsiQHAJXaGJXjKh2r72b+u5H6D62cb2qHJWTZ16Y6Po8ExeFQBUGtW
         j1Vw==
X-Gm-Message-State: ACgBeo0P5G3CWvLc7F2oJQA0BhEpLaGDFfb/KjsqqNSocMNH3k4adf6C
        +0s5tsMRKwcjOvqJKKQz9VH/R1FwYHqVUDK/kQ==
X-Google-Smtp-Source: AA6agR68wmtnyd+6tLLKnKjrQMkTdwVdgbm15czxZnqbkWTAuhNE9Qc+94GhH3giQsB+i4aE5T/pLqg/pkNM/mwcTw==
X-Received: from varshat.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:a35])
 (user=teratipally job=sendgmr) by 2002:a5b:84a:0:b0:67c:1db1:2069 with SMTP
 id v10-20020a5b084a000000b0067c1db12069mr35622834ybq.507.1662489365256; Tue,
 06 Sep 2022 11:36:05 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:35:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906183600.1926315-1-teratipally@google.com>
Subject: Request to cherry-pick 01ea173e103edd5ec41acec65b9261b87e123fc2 to v5.10
From:   Varsha Teratipally <teratipally@google.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Commit 01ea173e103edd5ec41acec65b9261b87e123fc2 (upstream: xfs: fix up
non-directory creation in SGID directories) fixes an issue where in xfs
sometimes, a local user could create files with an unitended group
permissions as an owner and execution where a directory is SGID and belongs=
 to a certain group and is writable by a user who is not a member of this g=
roup and seems like a good candidate for the v5.10 stable tree given that 5=
.10 is used in versions of debian, ubuntu.

This patch applies cleanly. Let me know what you think


