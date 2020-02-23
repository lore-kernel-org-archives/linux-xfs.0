Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA0DC35670
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 23:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D749020880
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 23:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlPdmahe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBWXUO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 18:20:14 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43809 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbgBWXR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 18:17:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id r11so8222582wrq.10;
        Sun, 23 Feb 2020 15:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ic1q2DA4tBzvn95/5QBdtjGvI/C7xVEzkX6mr+GRlig=;
        b=QlPdmahetukXS0taCeLY9OE2knc89tS/FlyFEK9SvEQxZYzYtmPHEWd1fhXXL47Tbe
         R/X47lAUoVlNHJguWmQqMc+B7C0u2CnkqcjNfWtnVO7jAAIHS4lFoM6Rt2ushKyEUvdU
         pHSkJ4GWCcfIFc+XS82/Yj2w8Yd4fl2EXATNU5QYDTEiDKZuGv2yh8n49Sz2GvXfAa21
         hQQ//cHhB0YwyIfF3mnsMm+9Shw3gzwHJKdK0QzBG/CDra5r/94R2XOsqYmyRgHW5gtQ
         6rENDD5eg45JL+tzLhDEbY8UXvdidw9cLfXrMHaHdEs85Jo59NtokXaxeI46BlSespqG
         Mc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ic1q2DA4tBzvn95/5QBdtjGvI/C7xVEzkX6mr+GRlig=;
        b=Nx+6j3zj/8/Iu1Y5eXO3qnnv4fMp6wYT4ozYOxJVghigTVOVK6P3qhgMQDir6fatcj
         jUpVFrHULkkHRXAT7FSu4FPvG+wq9xqwqrkzL8FUQNKRg6YTvFHXa3qKb5lnfFAewKlW
         0HXkGVu1ozCh8oIlgSe1jIKlTmO4ZuE+Oii9pRvQvFX2Oihyt8SwJz6cshpDAhmucsza
         FvBvv46B14VA7FSKG7/GZBFnRFM0BqiVJnN3+HNdIAm5xAFnCfirG3HCXnBFLm4ToWvV
         tbCICZPNdMAIOqD9tJzJNns3u1ELIskLtkw3KkhQ4dbr9AFP+Lqe+JCIWb4MXkltPOGt
         CLuQ==
X-Gm-Message-State: APjAAAVSzVWa+78yJVpiRtQnIoepvNNck71wK0RMTkLjmKKoJmwrYxbv
        NcvoodOe82IWe6iNxpJoBw==
X-Google-Smtp-Source: APXvYqySCBgtZXi0jxMa34a5qlhz7LiN/3Jjg8Zzwljlm9RYp17Xi/SZ9ll4QtQrqZTCEXJo7OlsKw==
X-Received: by 2002:a5d:4088:: with SMTP id o8mr12554441wrp.144.1582499876300;
        Sun, 23 Feb 2020 15:17:56 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:17:55 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org (supporter:XFS FILESYSTEM)
Subject: [PATCH 03/30] xfs: Add missing annotation to xfs_ail_check()
Date:   Sun, 23 Feb 2020 23:16:44 +0000
Message-Id: <20200223231711.157699-4-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sparse reports a warning at xfs_ail_check()

warning: context imbalance in xfs_ail_check() - unexpected unlock

The root cause is the missing annotation at xfs_ail_check()

Add the missing __must_hold(&ailp->ail_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 fs/xfs/xfs_trans_ail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 00cc5b8734be..58d4ef1b4c05 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -32,6 +32,7 @@ STATIC void
 xfs_ail_check(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip)
+	__must_hold(&ailp->ail_lock)
 {
 	struct xfs_log_item	*prev_lip;
 	struct xfs_log_item	*next_lip;
-- 
2.24.1

