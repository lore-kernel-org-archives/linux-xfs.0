Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C65C6379F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 23:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjASXjV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 18:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjASXjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 18:39:14 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075869F066
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 15:39:13 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id lp10so579152pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 15:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/5nzSngSGtGFE/Ehi8rPgndxQvoHjiIpaLSYYppFhz4=;
        b=0qHUScTrrk8LeQ/ATZHL0hxf0UyGc4L/SAJl6jOAxssHQlNouN6Srtw4Yqhc0HwVy/
         Pn+/xb9XBLwiYu6Hu09EBm4hfbndjqjGGfrmtRN0+F/L1sTdz1Dy38u3GNICMBX0sFmE
         sCjc/Oj+KTGpRwgENRQF9BTNb7k8g5TAsAeCyZKvBojOdOxyLZnYyy2p5o3mzEPhYIB2
         ntwaDPwhtfRJ4mBMe1clRsrpuLvbufTDV7O2ULW0FzlBflTFL7LMHAxslTQTCHidezts
         lCv9L5rtBJso/AwelbvLgGQ7ZjJKz1RjFVnGZlIOYiUgl8GrZqr+BPFIMWsNHdJd12LT
         PNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/5nzSngSGtGFE/Ehi8rPgndxQvoHjiIpaLSYYppFhz4=;
        b=GeG/aiOD6SeZgv5xnPC30v9WJN77UgQx0gpi5GC9H+qT6hrk7kt9er1X4C46NmqZqu
         F9+zPhs9mEylUi3DJZ0waXRter5PiZtlXdNTzVKvR8p7ZVMqvgLxaHGoCRxVwL7Lt5ZT
         8K7DFa4g06c13h5WeeTJQktdEEE7qO7Yo8jEYZip+B8WUYhELiVm4usk0jTRISp8Xmqn
         h+3F+w6pXhl9FcRISbBKAv8d5XyeT9ZB5NltDmb554ExfWBdnhQQjko5L8wodrFLBAEh
         ZJ6abmpdq6460cFQ3MCsuq8fhJFb1YMRXU0M+QLgvthN6tKoh/zc59zZ6ZsSWF72EVcR
         7WHQ==
X-Gm-Message-State: AFqh2kpX7El9Yu/lMXOEW2f3DWVfzUW2mELJerKcVRQaKKATlIrVeiiq
        YOy0yGsV55c1yvV0S/M5fLGFGoSFXczl06go
X-Google-Smtp-Source: AMrXdXuMX3xQFSOo7SsdswM4cidqo339gBQLmrH36Jct8R9TQL2NTaZtqJ9tsjCcSyqReCIXmvFRsg==
X-Received: by 2002:a17:902:eb89:b0:194:997d:7735 with SMTP id q9-20020a170902eb8900b00194997d7735mr11845001plg.48.1674171552549;
        Thu, 19 Jan 2023 15:39:12 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902bd0500b001932a9e4f2csm22494676pls.255.2023.01.19.15.39.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 15:39:11 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIeUv-00581i-64
        for linux-xfs@vger.kernel.org; Fri, 20 Jan 2023 10:39:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIeUu-008cfr-38
        for linux-xfs@vger.kernel.org;
        Fri, 20 Jan 2023 10:39:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] progs: just use libtoolize
Date:   Fri, 20 Jan 2023 10:39:06 +1100
Message-Id: <20230119233906.2055062-3-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119233906.2055062-1-david@fromorbit.com>
References: <20230119233906.2055062-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We no longer support xfsprogs on random platforms other than Linux,
so drop the complexity in detecting the libtoolize binary on MacOS
from the main makefile.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Makefile | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index c8455a9e665f..c12df98dbef3 100644
--- a/Makefile
+++ b/Makefile
@@ -73,14 +73,6 @@ ifneq ("$(XGETTEXT)","")
 TOOL_SUBDIRS += po
 endif
 
-# If we are on OS X, use glibtoolize from MacPorts, as OS X doesn't have
-# libtoolize binary itself.
-LIBTOOLIZE_TEST=$(shell libtoolize --version >/dev/null 2>&1 && echo found)
-LIBTOOLIZE_BIN=libtoolize
-ifneq ("$(LIBTOOLIZE_TEST)","found")
-LIBTOOLIZE_BIN=glibtoolize
-endif
-
 # include is listed last so it is processed last in clean rules.
 SUBDIRS = $(LIBFROG_SUBDIR) $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
 
@@ -116,7 +108,7 @@ clean:	# if configure hasn't run, nothing to clean
 endif
 
 configure: configure.ac
-	$(LIBTOOLIZE_BIN) -c -i -f
+	libtoolize -c -i -f
 	cp include/install-sh .
 	aclocal -I m4
 	autoconf
-- 
2.39.0

