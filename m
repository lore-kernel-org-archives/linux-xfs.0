Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAC2C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1867238D6
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FgjgWBbh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgIXRH5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728679AbgIXRH5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 13:07:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600967275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2CBo0GsrUjkDOtmc5DsoLMAwlQdWwNF1jtxrDDjt+s4=;
        b=FgjgWBbhKYqDyvkZQGPh8s0q+fa6odKrMhHKqFhSdSqpWMqGOpOPxvUgk6Vpkg+kZZE+1w
        LCHNERA3Sv3p+7RlDX84ZBWsoFd4CTpiWE50Ix4kuL6Nb5d+tLf5745OizzafFj5LOLpxV
        NyVh6QccySEDI7aeLCRGZdkEK+EynK0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-fJRe-8DPMHiAmzgng0bMig-1; Thu, 24 Sep 2020 13:07:51 -0400
X-MC-Unique: fJRe-8DPMHiAmzgng0bMig-1
Received: by mail-wr1-f72.google.com with SMTP id l17so1476472wrw.11
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 10:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CBo0GsrUjkDOtmc5DsoLMAwlQdWwNF1jtxrDDjt+s4=;
        b=eULECwq1v64D0x1ir9KkBNTEzXdvNanfUuMAsticU6PEcrUOjz6fxnI6WyxT8prVO9
         wSLV9vKTeHIBQFy/lkPIYaobNkPsIZnJ+r4HnXF4HPBWdLaHoYEhXiGzX2u0+A4jDi3u
         2xL+z5FxASpWD3GEPMTWZV5DKz8RVNU2OuilU/L1lF9TzkG2dQOAXRKeUdM4pOCMFmQW
         8L0L9g7US9hDYYfivmswnNMS5C8PL8PLu2Mv9S+Yp4xgR/zZR9nGlnSqJ3U+wNV4PUSx
         4wPQR/irT5x361PzIVbsNizyJgDGF57RvHFpjY8H+u6CAmAzs/vGI0iTnqS4uiThfCK/
         e7hA==
X-Gm-Message-State: AOAM531KQJa8uTo2Wb8q0InHOJoMI10fV/NMYxj3b+CX5SQ/lRXQCOb2
        xgQDde6BQJzSVvbPKuSbhyWgf7q9OPHhgw0XOepdt737KLPmirwNBaENWujJcKLDjpLN+uw2K7T
        lVu513qUS9G0Q9i1a+TZV
X-Received: by 2002:a7b:c215:: with SMTP id x21mr171653wmi.138.1600967270475;
        Thu, 24 Sep 2020 10:07:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+f2LvG9Pm6BC8AiYFXZ1KEYAWUERq0aCGyux0kcSHbIdfkKouu6208yycAuAnOLUeUNXlNQ==
X-Received: by 2002:a7b:c215:: with SMTP id x21mr171637wmi.138.1600967270292;
        Thu, 24 Sep 2020 10:07:50 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id k8sm103838wma.16.2020.09.24.10.07.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 10:07:49 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: remove deprecated sysctl options
Date:   Thu, 24 Sep 2020 19:07:47 +0200
Message-Id: <20200924170747.65876-3-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200924170747.65876-1-preichl@redhat.com>
References: <20200924170747.65876-1-preichl@redhat.com>
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
index 413f68efccc0..208e17810459 100644
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

