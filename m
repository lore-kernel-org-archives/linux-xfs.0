Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAF3C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465E22467E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TbwvqiNV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgA1Ozp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 09:55:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46921 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgA1Ozp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 09:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580223344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6TPZkYbdcs79ru2/Pz/ymX7AvMllDC7V2tgRYaow6QI=;
        b=TbwvqiNVRID/CMseXt3hDGDLccoCjuYwYgwmFHPpNnnimznRz4mZq/Q2c+qNdJlZCMoB/V
        LIpgvWVR9QW4w5zh69r5D8HZIQD96lNEXP6VpW+VXBpZWSXOOHDcwgO5C2GRyA7HTnaTL9
        0wNeNqB/a6DlZPfQr/w4jFzI78AEgg4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-vnMEyP17ON2RnUoEy5FJGA-1; Tue, 28 Jan 2020 09:55:43 -0500
X-MC-Unique: vnMEyP17ON2RnUoEy5FJGA-1
Received: by mail-wm1-f71.google.com with SMTP id t17so1023026wmi.7
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 06:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6TPZkYbdcs79ru2/Pz/ymX7AvMllDC7V2tgRYaow6QI=;
        b=LrMObtEpAKYgExmUh/y4VgNnexBGx1YJsjzBob+VUJ16hDD6bLFXNj9Jocb8G4MGJD
         b75+oHU1oX+nTTNXGeihhkU12MTMl7ktwF5Dwq5rvi3dK6WW1o7/6TR80AP1opSxVfjm
         qHLLZfFl4mayTp7f6NHLw49VT6nFySnRyu50t4x0YPdmdCIA5UXkPiom/nIt1LSUiVen
         NnXW+L7bsuEoXVmq7Pf1NevHLMtjBpLat9eA6nLlNR+++PfW/0cCKQAyk8H0+HIkkwb+
         Z/uXdz59dIrtqYPe2U7tUH1sNEl0SgnylBiYA034J/4K1i3BgAxgSxWdem/dRtVya+cB
         2ZKw==
X-Gm-Message-State: APjAAAXtcYfAz+8OZJT/xqE68y9QjwyRXsyy0mvphZ09N8OoK+5aRdpj
        oz0MFlIz17yHjGpFGYonJb/sngumN/UZGlBGiXYGS6wOZMlCQY4Wjej83hchZCsAX8ACdOSLsQo
        vBtoCP68wJX0/YVHscdLu
X-Received: by 2002:a5d:670a:: with SMTP id o10mr28816938wru.227.1580223339957;
        Tue, 28 Jan 2020 06:55:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqxB7BosOLXarCfCPnwTjVhY1cn2EsrJP+XdzPUHT8KmU8sbapx7Krip/PSSbRx1zS62ts3sYg==
X-Received: by 2002:a5d:670a:: with SMTP id o10mr28816924wru.227.1580223339815;
        Tue, 28 Jan 2020 06:55:39 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id q130sm3325939wme.19.2020.01.28.06.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 06:55:37 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
Date:   Tue, 28 Jan 2020 15:55:25 +0100
Message-Id: <20200128145528.2093039-2-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200128145528.2093039-1-preichl@redhat.com>
References: <20200128145528.2093039-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

mr_writer is obsolete and the information it contains is accesible
from mr_lock.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/xfs_inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..32fac6152dc3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -352,13 +352,17 @@ xfs_isilocked(
 {
 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
 		if (!(lock_flags & XFS_ILOCK_SHARED))
-			return !!ip->i_lock.mr_writer;
+			return !debug_locks ||
+				lockdep_is_held_type(&ip->i_lock.mr_lock, 0);
 		return rwsem_is_locked(&ip->i_lock.mr_lock);
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
 		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
-			return !!ip->i_mmaplock.mr_writer;
+			return !debug_locks ||
+				lockdep_is_held_type(
+					&ip->i_mmaplock.mr_lock,
+					0);
 		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
 	}
 
-- 
2.24.1

