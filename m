Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E961C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbiLMRbv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236351AbiLMRas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8406123398
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+GiG0BGe80J6W6TnK0jiJK/bNKCYrNUMGHoKQBGkRkw=;
        b=fa0+ibUbJCodjilQmYgM4XGPvdANJdFMbXcLv9sCwuMZ/GxepQ18BAcVlPyxSZKlyME6Wt
        s7r5rX1RgR1+S+I+QjZx91KV+vfe0a9eVzyKoN/OjvpFyrseVL/ICMqzCCn91G5UWmB7fR
        c1nkFu8xPNe7sAaeFid1K3ajBKsJfhc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-541-GVk6HzlmNsiC_PsdIdsM7g-1; Tue, 13 Dec 2022 12:29:50 -0500
X-MC-Unique: GVk6HzlmNsiC_PsdIdsM7g-1
Received: by mail-ej1-f69.google.com with SMTP id nb4-20020a1709071c8400b007c18ba778e9so1881137ejc.16
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+GiG0BGe80J6W6TnK0jiJK/bNKCYrNUMGHoKQBGkRkw=;
        b=cy9+3sTLklQLrUmljRmYGs1NAS4E1+IMzcbCMQZnHeVAGQoTAi3G0L+rMzvO/ePvuE
         s54vFyEThZ7sLSZKT3AjqBEPDx3y5xB112xSJLkvooybdoMZxuhprW7L/WUMnGZ3Gijl
         dLMdocCvFVOYtC2Y+rQji8owIX2gh/gYDR8lKbUkPNczw6ymMTFK1Lngey4ZqRabY+AC
         SWasda40UKBn2Zgc98+R+Ov4j82oUgYq/8VDt4ZZyPzTdsl03/o1OmQmsa8s0FdT4y4Z
         pQfOPwoqtWxObGm/KC/9m7p7WDlg37SfOCD6qmfFTYEay5YHYBDYflxap5tn9QxUKHaM
         9HbA==
X-Gm-Message-State: ANoB5pnQTc97uM13rvaRmLP+dG/TKICNoA6rBDC18tE+FlYswYYc302v
        GF/T1FjyfUfqK7yz/Iaybhm8rDv6+w+zCG3shv9BvohssfuosCxK4x8LcLJAmCirLZEFb80pThw
        Z4+dfZLbRzr+QfPaagXjs4DvhjpElYFTrYBGbDDNOl1I6/UH26M3r+zRl/N2EwjKUK31znv8=
X-Received: by 2002:a05:6402:2986:b0:45c:834b:f298 with SMTP id eq6-20020a056402298600b0045c834bf298mr16957708edb.21.1670952589349;
        Tue, 13 Dec 2022 09:29:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4+VYAsy05Ni1/O+l//FoyYcD0DzahMvHdo1dYl84a/uMCpesHVM+J1EHD+ElFaOaTbL4DKPQ==
X-Received: by 2002:a05:6402:2986:b0:45c:834b:f298 with SMTP id eq6-20020a056402298600b0045c834bf298mr16957692edb.21.1670952589140;
        Tue, 13 Dec 2022 09:29:49 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:48 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 11/11] xfs: add fs-verity ioctls
Date:   Tue, 13 Dec 2022 18:29:35 +0100
Message-Id: <20221213172935.680971-12-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3cd46d030ccdc..dff3672c16140 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -43,6 +43,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -2267,6 +2268,16 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case FS_IOC_ENABLE_VERITY:
+		return fsverity_ioctl_enable(filp, (const void __user *)arg);
+
+	case FS_IOC_MEASURE_VERITY:
+		return fsverity_ioctl_measure(filp, (void __user *)arg);
+
+	case FS_IOC_READ_VERITY_METADATA:
+		return fsverity_ioctl_read_metadata(filp,
+						    (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.31.1

