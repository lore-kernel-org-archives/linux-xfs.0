Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7983BC77B62
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbjDDO5b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjDDO4o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4900B30C5
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2wyXRFn15U7YuTtccu17S72kQxdrsvbnQJV5citpTBw=;
        b=QQP0Hc2vrkLjTl7JnnIP5UenEuG9JCdZGW/wvBv4IC0Kz8J60VSLRLVX9doGpsTxv/sw1H
        GbanPfcBGS1Y6VVjD4Rv7KSvhhu6ZRd3iwn2G8LHgP6x2GsMq60iugpmOLi5RqODY6thTG
        9k/1gDoo5INqxStpUmZoX5qU/8ffBZY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-RRdIL1-8M4uoGqkWPe5y1w-1; Tue, 04 Apr 2023 10:55:58 -0400
X-MC-Unique: RRdIL1-8M4uoGqkWPe5y1w-1
Received: by mail-qt1-f197.google.com with SMTP id a11-20020ac85b8b000000b003e3979be6abso22124416qta.12
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wyXRFn15U7YuTtccu17S72kQxdrsvbnQJV5citpTBw=;
        b=1jM8N7EyK07zaO+miSHr+PaeJEXVdZAEb6tWa4C7UOim/8ewmCwsx5bKtpz+Ofwfpu
         rFB44tVpyU5EcbenMcuWRQ0r6xUwWg6EUuVpnR4VnZKomTp+JV9kQ/XEPx7663gGt6xA
         dqx3A0eQ8nwUg1gY8OY+1oJ4vGm9zTZ9XI5kqgELicoCk03JoVaDnxITb9QCGBVvinmL
         nsITKLel3INLix2PSlilRSoV+vIwHLIxdaeRYNlRhquf1fV/fOBy3hmxlgNO2cFfxVah
         0noPVL80a7Huhq6pjMk7cTYeKi+hHe1Kxzwc4SosxckpIZ2qjtySkkbpVHE5JAGeI5Pu
         MBOA==
X-Gm-Message-State: AAQBX9dX4iICtvpvBL8fJ5l5AbXPapOrHBeadwnDVTIMgvUQ7uaXQe4H
        +0ky2zwDOErwgOs04UL4AlPMAww9zMW/0Sml2ERA11vXbFXXF87UZiC/ZMn92T7aDl/XHyCm1vI
        hyrLwtDhAedYpKpOBMPI=
X-Received: by 2002:a05:6214:202b:b0:57e:67c2:b9cd with SMTP id 11-20020a056214202b00b0057e67c2b9cdmr4447865qvf.27.1680620156123;
        Tue, 04 Apr 2023 07:55:56 -0700 (PDT)
X-Google-Smtp-Source: AKy350bJb0tNOFsr5rCdSnciXn4UvwnouNwwbFSTjZxZAVItCMscXXWD/V0CsYzmlqPKXH2vmnAZgg==
X-Received: by 2002:a05:6214:202b:b0:57e:67c2:b9cd with SMTP id 11-20020a056214202b00b0057e67c2b9cdmr4447836qvf.27.1680620155884;
        Tue, 04 Apr 2023 07:55:55 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:55 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 22/23] xfs: add fs-verity ioctls
Date:   Tue,  4 Apr 2023 16:53:18 +0200
Message-Id: <20230404145319.2057051-23-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3d6d680b6cf3..ffa04f0aed4a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -42,6 +42,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -2154,6 +2155,22 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, (const void __user *)arg);
+
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, (void __user *)arg);
+
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp,
+						    (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.38.4

