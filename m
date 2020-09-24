Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3CDC4727D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 091B62395C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:07:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/OvEd0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgIXRHy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728533AbgIXRHy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 13:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600967273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Wtm/cLHvqYGKGlziELXDIpICdVz+nah6vXT6Osr7zg=;
        b=H/OvEd0AVsa5H7wj6HWij3MiKh17/+MT+cgSTK4Vxrph28n8OOKzyqqJuYP/X8BFsjpZxC
        VdQ59s5eNwRboqKxj/56q5uQDcMByQsfbQHCGLaGUn+A3NgOre8v5vvXe4wyqRBjRW3uDB
        8DPZ8t2ENj7hPnt1O5JbpHEwI5TaOps=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-3DdnHPNmN_-ZUTw0IlGXWQ-1; Thu, 24 Sep 2020 13:07:51 -0400
X-MC-Unique: 3DdnHPNmN_-ZUTw0IlGXWQ-1
Received: by mail-wr1-f70.google.com with SMTP id s8so1482654wrb.15
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 10:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Wtm/cLHvqYGKGlziELXDIpICdVz+nah6vXT6Osr7zg=;
        b=IvRAWLkx8xbGNJL1zSqh95dm3aVCBR3c6/vpbcpJVufdbEhALOgbEVVNyHJ5jdNTi6
         bbkBhCrkCU7UPRWzAnDZDlxYo76IUonSMtLkinbOgkBNgQ6vY8nFUGlCQSZBTILxixBh
         YzFXja1YSgq2PHeSRoD+XNIhcrNur1N3jT6Z8fp2oxDgrk99SCdh3zA3Q+Wpgjz4PCrz
         Myc891pWiHvU53/uN4qz8NnUmmnQZWguGCeZwsDdUC8VeQAXXRM4ibMXUiAm2gzD1tqY
         +eacoOf4L0ap7zaMdCOD8yqcMYFaViLLS8GcGB7V3co/KPnM9jXeG3GWL+XNIl8apufs
         W96g==
X-Gm-Message-State: AOAM5325zibgADv4cQpp9WxvxUBEVldQeQa0R0SfjbFvF7vUeMkrCfL3
        f28hEDdNzek2HXgfiY5lGweeWsNm3OTfSHnwHE7VgaYKruU2lU0TH5OIofLZnj2NzG756uvxXqj
        I/uEYGxtlvfUFIrbtibyF
X-Received: by 2002:a1c:63c1:: with SMTP id x184mr174779wmb.138.1600967269754;
        Thu, 24 Sep 2020 10:07:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwg8JzHhiDNF5ZLdUUkYcxzsmxwNgwwB89FvzFQ1GdgnsU//14AX9GE3KlltCLK8hXnkhTjw==
X-Received: by 2002:a1c:63c1:: with SMTP id x184mr174763wmb.138.1600967269497;
        Thu, 24 Sep 2020 10:07:49 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id k8sm103838wma.16.2020.09.24.10.07.48
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 10:07:48 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: remove deprecated mount options
Date:   Thu, 24 Sep 2020 19:07:46 +0200
Message-Id: <20200924170747.65876-2-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200924170747.65876-1-preichl@redhat.com>
References: <20200924170747.65876-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

ikeep/noikeep was a workaround for old DMAPI code which is no longer
relevant.

attr2/noattr2 - is for controlling upgrade behaviour from fixed attribute
fork sizes in the inode (attr1) and dynamic attribute fork sizes (attr2).
mkfs has defaulted to setting attr2 since 2007, hence just about every
XFS filesystem out there in production right now uses attr2.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 Documentation/admin-guide/xfs.rst |  2 ++
 fs/xfs/xfs_super.c                | 30 +++++++++++++++++-------------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index f461d6c33534..413f68efccc0 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -217,6 +217,8 @@ Deprecated Mount Options
 ===========================     ================
   Name				Removal Schedule
 ===========================     ================
+  ikeep/noikeep			TBD
+  attr2/noattr2			TBD
 ===========================     ================
 
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 71ac6c1cdc36..4c26b283b7d8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1234,25 +1234,12 @@ xfs_fc_parse_param(
 	case Opt_nouuid:
 		mp->m_flags |= XFS_MOUNT_NOUUID;
 		return 0;
-	case Opt_ikeep:
-		mp->m_flags |= XFS_MOUNT_IKEEP;
-		return 0;
-	case Opt_noikeep:
-		mp->m_flags &= ~XFS_MOUNT_IKEEP;
-		return 0;
 	case Opt_largeio:
 		mp->m_flags |= XFS_MOUNT_LARGEIO;
 		return 0;
 	case Opt_nolargeio:
 		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
 		return 0;
-	case Opt_attr2:
-		mp->m_flags |= XFS_MOUNT_ATTR2;
-		return 0;
-	case Opt_noattr2:
-		mp->m_flags &= ~XFS_MOUNT_ATTR2;
-		mp->m_flags |= XFS_MOUNT_NOATTR2;
-		return 0;
 	case Opt_filestreams:
 		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 		return 0;
@@ -1304,6 +1291,23 @@ xfs_fc_parse_param(
 		xfs_mount_set_dax_mode(mp, result.uint_32);
 		return 0;
 #endif
+	case Opt_ikeep:
+		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		mp->m_flags |= XFS_MOUNT_IKEEP;
+		return 0;
+	case Opt_noikeep:
+		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		return 0;
+	case Opt_attr2:
+		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		mp->m_flags |= XFS_MOUNT_ATTR2;
+		return 0;
+	case Opt_noattr2:
+		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		mp->m_flags &= ~XFS_MOUNT_ATTR2;
+		mp->m_flags |= XFS_MOUNT_NOATTR2;
+		return 0;
 	default:
 		xfs_warn(mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
-- 
2.26.2

