Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A6B2882B4
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 11:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753786882; cv=none; b=nK1f5I4U+9MLwPx/bgWHIJcX6EWJgs4P0qrYpdKWJQbiv7w4zki84T7pk0dAgsyztCVBMVIj5yNTYOutjAYeRuZyEbGmX+6bYZkyzp5qhyKg2InWw3vIT+mWE52zSV+zp6u+c5JHxg3ea/+cDzGwypO0ci1wYw66+Im8Xx7bccc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753786882; c=relaxed/simple;
	bh=oJDsuqg6ie7RuIQ/lYQCVy3shQnsPT2z0/xhijDSZ6Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pAErBxMGiTibSKwoNy96ELjF2iGYD+Y9QzqlWLc9RZHShRp4n5e2bDbfJIeeBhnKnTxMuOVTTBOLaiHilVfrlhS4g1OU5snB7U6QkP8L6jAs0fbZ8KBVWZ6bb/q15FaPQHtkOgaiceKGmaBt1Agr5QDU6ShoAfzd9voCBGjO2ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M0vBgeUo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0vBgeUo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753786879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gX6QhrksqQsXpGpszGmxOp9w5LwcUCpK/eL76PN0DsA=;
	b=M0vBgeUoyAS6chIru8g/TdIPsP6vaY4A7TCo05u3WP+QbsPqNEG3czu7s1fNiilE9XRXKK
	fyaWHehDjMEgT5o28cmexM+dFoLFZDIBqRkuZLI7ux8m91GHHg6dT8yIV70roaPA+ktuCf
	YWH03BN5oJjia80jXQFIGOPTJj7EpHw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-8Qh5q5f5OTiAFRTWJVfI9w-1; Tue, 29 Jul 2025 07:01:17 -0400
X-MC-Unique: 8Qh5q5f5OTiAFRTWJVfI9w-1
X-Mimecast-MFC-AGG-ID: 8Qh5q5f5OTiAFRTWJVfI9w_1753786877
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ae98864f488so620544466b.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 04:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753786877; x=1754391677;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gX6QhrksqQsXpGpszGmxOp9w5LwcUCpK/eL76PN0DsA=;
        b=KbysniLd5w3ElyxGUktHuwEvTLaXgEcNH5FzAyfNh80cg4fVaPDIsTXlBXrcmC0kCX
         vCsWFq7W1kj0m+JeRUaxneTtwBLk/tBYZO56lU5OdN7OOltJWFuqhvPIjE6KyZt7c0/F
         ik77FxccRfgesFhwPRRQWB38p2SrN2MEUFLYNuzAp+oF/meu7Gr7t/POstClzcE9/N2N
         SyolclMKkC+yFRZXIYSBRoDQlYN0muq+lXQxjQYg+xPh4xMTHCrkRWeP4uUCAfIazPlB
         ITxfNL6a0QUG8c2Zba0eosDDs0R+0USDi8+Q1qKTwd2kZfv9ryMYAAKsY2KYnflYNy0c
         V4mA==
X-Forwarded-Encrypted: i=1; AJvYcCUg+psSmpGg5Sr4Tyhek1OxZRp0iFZ6+nVMZcKxbCPS8koxNMsDb0j9HhFpbKY9SLppQcU9AndEEfk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3nx+wVSrHDFURnWhnVxuwXx4qXSDIXYdRfKyVMBrPgipyqnDH
	02ot6UyUu01BaUvHQ00SxDf6yIXc7pizC4ZAiE422igdq+LybOiljdtoz/i1mU0nCqgWpvaa/vW
	bj4sRj09wEL+KYsdlAAyVhX3Tbta8+T/BJBZlxyYGDbFSAV/YOy6LKF5FzA68
X-Gm-Gg: ASbGncuSXr+qeab1KG1pGQNaMgqAX/wxRTduceIGbnXVCX3cVx9/JKgjrw29FKG4mZr
	lMakIeLndn2AMZ1tzWTRATDCLv3axYv031e/iSsQce9oA7davCZ/5AJ6KyxgyX6pq1IxWU/Ij83
	n3n7EhYSLuMHx8teQjP5ppczSkMl3NYN971XK+qbwC4Dd8qVd8Pk7hBb9k1xa/+Y17Z84vdjh8Z
	2HhhmHxUAY9XJGzpi+ZeBaGA9vVgUzX2REWcWbKUb9+PhkahhMWaTwOnTRxv1JRYSCr/v8PWujE
	4+UZEF7fQyh/yLFA/CeATxC7NPfyNqZl2vDHNdFR/OFOxg==
X-Received: by 2002:a17:906:9fd2:b0:af1:1dfd:30f4 with SMTP id a640c23a62f3a-af619b0f686mr1503997966b.47.1753786876543;
        Tue, 29 Jul 2025 04:01:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQyZp+qcLvceozYAuP7KpLA999KSg3jb/ccHW5QJCcgl1IodZGFDlMFJt7nHyCpsXSjf8amQ==
X-Received: by 2002:a17:906:9fd2:b0:af1:1dfd:30f4 with SMTP id a640c23a62f3a-af619b0f686mr1503993466b.47.1753786875929;
        Tue, 29 Jul 2025 04:01:15 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61563b3edd8sm1083884a12.47.2025.07.29.04.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 04:01:15 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 29 Jul 2025 13:00:35 +0200
Subject: [PATCH 1/3] xfs: allow renames of project-less inodes
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250729-xfs-xattrat-v1-1-7b392eee3587@kernel.org>
References: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
In-Reply-To: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3607; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=4pCtpKdtlgTlS6eM5TzvA1M9h4y8I+AeQkZFuKlKOWs=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMjpW/vzF/T7Y8cXXO48L3714/3Xt6u/Zv/bzla043
 fb3I0vcsvXqHaUsDGJcDLJiiizrpLWmJhVJ5R8xqJGHmcPKBDKEgYtTACZy6y7DX5nouZciw3MK
 O60qgjtKP69RPzWhJrHqGceiK62//M7khzD8D44/G5q0g+3UzJ+lWx+WfGfeemu/rf7z9of9+nJ
 We6M5mABdtlFy
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

Special file inodes cannot have project ID set from userspace and
are skipped during initial project setup. Those inodes are left
project-less in the project directory. New inodes created after
project initialization do have an ID. Creating hard links or
renaming those project-less inodes then fails on different ID check.

In commit e23d7e82b707 ("xfs: allow cross-linking special files
without project quota"), we relaxed the project id checks to
allow hardlinking special files with differing project ids since the
projid cannot be changed. Apply the same workaround for renaming
operations.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9c39251961a3..0ddb9ce0f5e3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -877,6 +877,35 @@ xfs_create_tmpfile(
 	return error;
 }
 
+static inline int
+xfs_projid_differ(
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip)
+{
+	/*
+	 * If we are using project inheritance, we only allow hard link/renames
+	 * creation in our tree when the project IDs are the same; else
+	 * the tree quota mechanism could be circumvented.
+	 */
+	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
+		     tdp->i_projid != sip->i_projid)) {
+		/*
+		 * Project quota setup skips special files which can
+		 * leave inodes in a PROJINHERIT directory without a
+		 * project ID set. We need to allow links to be made
+		 * to these "project-less" inodes because userspace
+		 * expects them to succeed after project ID setup,
+		 * but everything else should be rejected.
+		 */
+		if (!special_file(VFS_I(sip)->i_mode) ||
+		    sip->i_projid != 0) {
+			return -EXDEV;
+		}
+	}
+
+	return 0;
+}
+
 int
 xfs_link(
 	struct xfs_inode	*tdp,
@@ -930,27 +959,9 @@ xfs_link(
 		goto error_return;
 	}
 
-	/*
-	 * If we are using project inheritance, we only allow hard link
-	 * creation in our tree when the project IDs are the same; else
-	 * the tree quota mechanism could be circumvented.
-	 */
-	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
-		     tdp->i_projid != sip->i_projid)) {
-		/*
-		 * Project quota setup skips special files which can
-		 * leave inodes in a PROJINHERIT directory without a
-		 * project ID set. We need to allow links to be made
-		 * to these "project-less" inodes because userspace
-		 * expects them to succeed after project ID setup,
-		 * but everything else should be rejected.
-		 */
-		if (!special_file(VFS_I(sip)->i_mode) ||
-		    sip->i_projid != 0) {
-			error = -EXDEV;
-			goto error_return;
-		}
-	}
+	error = xfs_projid_differ(tdp, sip);
+	if (error)
+		goto error_return;
 
 	error = xfs_dir_add_child(tp, resblks, &du);
 	if (error)
@@ -2227,16 +2238,9 @@ xfs_rename(
 	if (du_wip.ip)
 		xfs_trans_ijoin(tp, du_wip.ip, 0);
 
-	/*
-	 * If we are using project inheritance, we only allow renames
-	 * into our tree when the project IDs are the same; else the
-	 * tree quota mechanism would be circumvented.
-	 */
-	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
-		     target_dp->i_projid != src_ip->i_projid)) {
-		error = -EXDEV;
+	error = xfs_projid_differ(target_dp, src_ip);
+	if (error)
 		goto out_trans_cancel;
-	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {

-- 
2.49.0

