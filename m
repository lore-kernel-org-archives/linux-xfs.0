Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A689C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3657723A5E
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbhAPJYj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 04:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbhAPJYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Jan 2021 04:24:38 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F76AC061794
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:57 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id a10so97750ejg.10
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h1HVqmNNlzZp+H1to+o4XGHCBePfAjH6ARhTFaITEZ8=;
        b=qV18tdRkLriN+hwFMDPxwxWX4agGlv/bp5R2GmvtQIptQqX3vJ89T2fPs3jO7/xoAX
         35kdlLveCF3Dk2I/VmIfIWzzZqKotO3MrIJMBYXn9Yez5KygDmjK4FL7Wz5tc5fcVKHr
         hBzbT0CMzIS3D/1ngwnrz9waXMVxMuQv9dJJpxuZrEhLu79JBqjK18Ft3CWjPx8jFTES
         LXX+58sefgbAZJUIkuuoyyl5MlkiCzQO0Z1udfZrvpMWuzt9b8dGCZXMlxqy+vBF/BFs
         xeMdPpoIoDDEzlGSKGdUdCX30rkA/Y+GA80oJS6LNBAlNVO9cucj1TsxNOMSllIbD6or
         RXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h1HVqmNNlzZp+H1to+o4XGHCBePfAjH6ARhTFaITEZ8=;
        b=a57uj0N2ZeBDIuFGR0G3Z5w1qB9dXd/h74GuPjoKFPrN6p93/XfqkSFdJlzQOL055J
         m9+R+xM4is63P00GUwZm4uJEO7+UV5+5244GtJH0ysXTm6Ka3eZrpFdplBfv7/FFXjnM
         w7HvwFvD0nKsyEJNpmFLfiykwGsDvUygzucqM0LicybxK/gRl6rm4WP3aLOD98DGGuOH
         G5A18sRGJFKX9rCY5mzkZjhZ+2hSXib03fVDN6bf+Sn1ETt5LBN+UJ32XfhYJUCjWvkn
         q/o/ndcp6UxyGi5+6iJsUHd2MjlXqgKEZ3ApsbOLwq3CPqnRNetDRhQEIK92rHcxy2iK
         KnXA==
X-Gm-Message-State: AOAM532Hs2RB6a6LjazrroJqf4uNLtcIkm2QNlq+TpSr38yqh4DfMGYV
        vXr+fbgjkrPMmMtRX2lRQFCH/DwFoQDWiIMgf2o=
X-Google-Smtp-Source: ABdhPJxfXCY6mb7sbPz/3d/TbPXzQMzojHsC+Ee8GDKWIC42HYP/a3RQMGvd3lpThQdJ0jfCU1dlTw==
X-Received: by 2002:a17:906:9381:: with SMTP id l1mr4213977ejx.433.1610789035662;
        Sat, 16 Jan 2021 01:23:55 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id j25sm6166851edy.13.2021.01.16.01.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 01:23:55 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Nathan Scott <nathans@debian.org>
Subject: [PATCH v2 3/6] debian: remove "Priority: extra"
Date:   Sat, 16 Jan 2021 10:23:25 +0100
Message-Id: <20210116092328.2667-4-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210116092328.2667-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Priority "extra" was replaced by "optional" which is already used by the
package in general. There is one Priority extra left, so remove it.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Nathan Scott <nathans@debian.org>
---
 debian/control | 1 -
 1 file changed, 1 deletion(-)

diff --git a/debian/control b/debian/control
index 34dce4d5..64e01f93 100644
--- a/debian/control
+++ b/debian/control
@@ -29,7 +29,6 @@ Description: Utilities for managing the XFS filesystem
 
 Package: xfslibs-dev
 Section: libdevel
-Priority: extra
 Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0), ${misc:Depends}
 Breaks: xfsprogs (<< 3.0.0)
 Architecture: any
-- 
2.30.0

