Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183D1E94103
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbjJFSzW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbjJFSyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DF1116
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h+hERDddpeeIHe4DM9B5TqIjpvoGQYj+Dd7I5rMKZNk=;
        b=SN+h39RIfV4kiWiorIF1kGPws7MDGlDjn0Fi21H9NNL1tGkZeTkH5z1sqOngTSyBCqb+iq
        LyfjetycJNg1sFjCUMZXQ2xJgdYKlCWGXdV1JMRAyj9ME7gDV1mfwrnJvcwd9wi0WN8qAW
        lplB45NmXGlF9zCLSgzhUz0wyf3kvx0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-dkUHvfUfMO-kYNaTlBOfEQ-1; Fri, 06 Oct 2023 14:52:45 -0400
X-MC-Unique: dkUHvfUfMO-kYNaTlBOfEQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9b65c46bca8so208419066b.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618364; x=1697223164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h+hERDddpeeIHe4DM9B5TqIjpvoGQYj+Dd7I5rMKZNk=;
        b=aNsngfx5i2MWP2vIEvcXd7Ugv+hzBf6ibampOwOMwAxBtziiDvIcXqkP0kfuJMvEH0
         6GVidD4iHaWRH8I99/xIjBn9VoP3jn05XhYagq9pSSyEONyVjQxNG14xMB4kawhKzUtK
         kB+1USXkAaIrP/8ybDnAAMuUyCaI7X8dPIi+I9raWZZsjeY0362+MR/KLe3C0vi5oztg
         etWfmo6ta8HhVQXGtuGer8Vn6PcwLj8zKbG4+IX27XiAzzDhe51+ZrT2pH5ufahOd5lr
         94SxRosASNneF+Msxy0hfIm7m8FTn8q9rTixMW0eUqw4w3RszZdqe+mevLpPNpxZYsH6
         oSbQ==
X-Gm-Message-State: AOJu0Yxa6e/aBpVSZHEtnPgueY/IwPd4kB8FuDDhCbz1uLjopJjuEchy
        YlrtROswJ9HeWkybql55Sm1h0d+5Cc9by4Hy5wqa/b3vO/WrWENvW+yuXBtuLlX3zLVNFdS69zi
        lzRgXpQQOdbE2WEN3zxzHC/mVL5MZJvs7Fe1TDlHI1WmhspTpK+oqbgF6KMef/3svJCP3yaN9BW
        /gVdE=
X-Received: by 2002:a17:906:31c7:b0:9ae:673a:88c8 with SMTP id f7-20020a17090631c700b009ae673a88c8mr8463915ejf.21.1696618363826;
        Fri, 06 Oct 2023 11:52:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGj4mxEdfFg60CQgUH6Kl9WUvjEgQ0RS1ocFOzUW2NWuCD/0V4jWL98MJ2Rk4lHCKYOiP5xjQ==
X-Received: by 2002:a17:906:31c7:b0:9ae:673a:88c8 with SMTP id f7-20020a17090631c700b009ae673a88c8mr8463904ejf.21.1696618363632;
        Fri, 06 Oct 2023 11:52:43 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:43 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 27/28] xfs: add fs-verity ioctls
Date:   Fri,  6 Oct 2023 20:49:21 +0200
Message-Id: <20231006184922.252188-28-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
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
2.40.1

