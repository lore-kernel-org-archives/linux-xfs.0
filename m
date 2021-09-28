Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B165C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 808AC611F2
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbhI1A1m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhI1A1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 20:27:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727AFC061575
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 17:26:03 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id b192so1949360wmb.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 17:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=srGU3VFBqBxm6uu3+3RXumeG0vzzIrMeoyu/iUfxMF0=;
        b=VQg4QNgFUD3IRKgqniJLS99QfiXhVGdo96A69DJvEnBjICDfTZFnR6qDOoqT3DOp/8
         3nDq/1uw1TQEvywQO5R2bAPpq229iwpDIXqtXjwSTH4aSF4gsDV713NZvvu/7AeO2vyg
         eYpS0J1C4Eu8c+xfutsb8TG4wWR+Wruhzu3NqGriHRjRjWnuQ+cCyFyPYqzymVfxNIFR
         g6ReeiYvVG4klfEk8S5AXt4nTEPaiCs5pZ5/Sj17PaAsSrDpbTKBwL49rIENfTYkpEgY
         1aYLbO6RQRI55PUuIIAJgueYcdQgpHqeZXsGpg9lWrjt+mUWWPUdDiqXtVnIN0eCs6ri
         J0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=srGU3VFBqBxm6uu3+3RXumeG0vzzIrMeoyu/iUfxMF0=;
        b=N3PbxufuP6OrqGhAUMZF+fiTeOP/RE1X1IGbeFMVHqUC63YNMWO1SA6edV3HPuY7uX
         ZqbfyXFFG9/JtecA0wWAzRxlKU/CiJJHR38FAOspRqtQMcXpVSsynALEpI7/WAaj5poZ
         UEvvikI60e8/DFsRUXql7KqAnlS0+RNrQxIyFPpjrutNf1ALqs5Y17NEN2WcTGQc8zpb
         g+WkkuZunL6gff57IsEq6U1XKqLB9lcJaluHRkW0Y/Lr0taOZNLMWA2P3SEbo6o+Eb79
         y8rZhcfEX3AzKYg2Fdd9f9P6mc7wsENmPjEFjcZa0eGikAsrrLV8yI2M9P5qhNTeIxBd
         1ljg==
X-Gm-Message-State: AOAM530cUNqSNfx6OpiYdN8R7fJJ+mvPcYkGxXHq1O3ZWLZNd0j2qZmf
        f5dl13jNTxbDWyCKpd7T9LTHpIgZ76un3zlaP8Q=
X-Google-Smtp-Source: ABdhPJxaIsgwKCb+D16Y/7jc+iWFs9PCE3yLKX3iQrjPVqMgjsM2VtXNnal1GBu7EW/MOCO/EUX9IQ==
X-Received: by 2002:a05:600c:1552:: with SMTP id f18mr1797544wmg.184.1632788762152;
        Mon, 27 Sep 2021 17:26:02 -0700 (PDT)
Received: from thinkbage.fritz.box (p200300d06f1f7300176a2a162e6525fe.dip0.t-ipconnect.de. [2003:d0:6f1f:7300:176a:2a16:2e65:25fe])
        by smtp.gmail.com with ESMTPSA id p3sm4755814wrn.47.2021.09.27.17.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:26:01 -0700 (PDT)
From:   Bastian Germann <bastiangermann@fishpost.de>
X-Google-Original-From: Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>
Subject: [PATCH 1/3] debian: Update Uploaders list
Date:   Tue, 28 Sep 2021 02:25:50 +0200
Message-Id: <20210928002552.10517-2-bage@debian.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928002552.10517-1-bage@debian.org>
References: <20210928002552.10517-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Set Bastian's debian.org email address.

Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index e4ec897c..57131bb4 100644
--- a/debian/control
+++ b/debian/control
@@ -2,7 +2,7 @@ Source: xfsprogs
 Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
-Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
+Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
 Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
-- 
2.33.0

