Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789A3C4727E
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4207121D42
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:50:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GoUkbuTn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgIYQuN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728466AbgIYQuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 12:50:13 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601052612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=42jpAXLhmq5znqGqevt4cZDkvsw+rfPlcAPYm269wKM=;
        b=GoUkbuTn2D3duzSPMP9NYTkpLHWAN0/ZAxeA2sPtjzEOyQgzw3d+f1IjFGH+jttA3F9OOA
        XrscMtBHfspmhd+q/ciAeZ3FQm/66RS1ys9GZOfa6X2xIO5yB+ihQCe9TLuwTYYOGthFvv
        YiJ+ujoQle/VNf7UaYBlN816sY+OY+g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-l1zfnh2nOUuMsBU7HVLWvQ-1; Fri, 25 Sep 2020 12:50:10 -0400
X-MC-Unique: l1zfnh2nOUuMsBU7HVLWvQ-1
Received: by mail-wm1-f72.google.com with SMTP id w3so1311107wmg.4
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2020 09:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=42jpAXLhmq5znqGqevt4cZDkvsw+rfPlcAPYm269wKM=;
        b=mTHKm4DJHI1k6EmqPwokUO0T8rS2B8rLJ6GLIq++pFWAR1UBpJ5TWBBFiXB5EVTFKe
         wnhKxudSeEiCQ/VzsgZGaaflloNqCpxAHj/XDnbZ3LARX0MNfHp+20xsrKYsgm5CkaUD
         oOieoqzFjNhzFqaLtI13YXpDMiqvg+O1WIt7Ju4dJa0F75zFdO/IiQRLXlQqzbd2mk00
         JGUTWKDLUnawuQpikBrd17QpFQcDOSRb0xtxY1Le9wi+SmI1bhcN4S8cGJVBAwfiafzL
         vfEfJutLpoRzg9EJqjxyPaxw+IO8Q7Ip7EZONlRDjNK4euKaetnwZ+JIpJkcIHmL0bSs
         Fm7g==
X-Gm-Message-State: AOAM533MHIDuDLi7j8bwqMWCSo5phEEOQQGUEVBZywYcjetApzAKgmXW
        f/DHsJAsn3CPEnprhFbGPytzb/HfylItkMxW0Iv8cTZBya/rBFU/GEsHcWQB9jwr489wHahj+N2
        zYr3Tvyw0aWmotTYEe+AT
X-Received: by 2002:a1c:8109:: with SMTP id c9mr4067862wmd.130.1601052608828;
        Fri, 25 Sep 2020 09:50:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLIgCbv8gPnIv5Vxpvg541WBd+ncymvSle9R5OWv0Xuq/XnocsFpNHDKWSHV+DBFWUJHXRRw==
X-Received: by 2002:a1c:8109:: with SMTP id c9mr4067850wmd.130.1601052608636;
        Fri, 25 Sep 2020 09:50:08 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id b64sm3181578wmh.13.2020.09.25.09.50.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 09:50:08 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: remove deprecated sysctl options
Date:   Fri, 25 Sep 2020 18:50:05 +0200
Message-Id: <20200925165005.48903-3-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925165005.48903-1-preichl@redhat.com>
References: <20200925165005.48903-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These optionr were for Irix compatibility, probably for clustered XFS
clients in a heterogenous cluster which contained both Irix & Linux
machines, so that behavior would be consistent. That doesn't exist anymore
and it's no longer needed.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 Documentation/admin-guide/xfs.rst |  3 ++-
 fs/xfs/xfs_sysctl.c               | 36 +++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 717f63a3607a..ce32d9d8529d 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -333,7 +333,8 @@ The following sysctls are available for the XFS filesystem:
 Deprecated Sysctls
 ==================
 
-None at present.
+fs.xfs.irix_sgid_inherit
+fs.xfs.irix_symlink_mode
 
 
 Removed Sysctls
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 021ef96d0542..fac9de7ee6d0 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -50,13 +50,45 @@ xfs_panic_mask_proc_handler(
 }
 #endif /* CONFIG_PROC_FS */
 
+STATIC int
+xfs_deprecate_irix_sgid_inherit_proc_handler(
+	struct ctl_table	*ctl,
+	int			write,
+	void			*buffer,
+	size_t			*lenp,
+	loff_t			*ppos)
+{
+	if (write) {
+		printk_once(KERN_WARNING
+				"XFS: " "%s sysctl option is deprecated.\n",
+				ctl->procname);
+	}
+	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
+}
+
+STATIC int
+xfs_deprecate_irix_symlink_mode_proc_handler(
+	struct ctl_table	*ctl,
+	int			write,
+	void			*buffer,
+	size_t			*lenp,
+	loff_t			*ppos)
+{
+	if (write) {
+		printk_once(KERN_WARNING
+				"XFS: " "%s sysctl option is deprecated.\n",
+				ctl->procname);
+	}
+	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
+}
+
 static struct ctl_table xfs_table[] = {
 	{
 		.procname	= "irix_sgid_inherit",
 		.data		= &xfs_params.sgid_inherit.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= xfs_deprecate_irix_sgid_inherit_proc_handler,
 		.extra1		= &xfs_params.sgid_inherit.min,
 		.extra2		= &xfs_params.sgid_inherit.max
 	},
@@ -65,7 +97,7 @@ static struct ctl_table xfs_table[] = {
 		.data		= &xfs_params.symlink_mode.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= xfs_deprecate_irix_symlink_mode_proc_handler,
 		.extra1		= &xfs_params.symlink_mode.min,
 		.extra2		= &xfs_params.symlink_mode.max
 	},
-- 
2.26.2

