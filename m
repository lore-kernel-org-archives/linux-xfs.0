Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3F01EF39E
	for <linux-xfs@vger.kernel.org>; Mon,  4 Aug 2025 12:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309316; cv=none; b=gQvjiLY15rv/lAoRuY8fBvJdeGuU4GevpIpmWP88LUGLFakwKPvLO2Eij0+/J92OEM9tRpGkjWpshhhdDMyU7DsxMCRRvbGzkr3QMUvoaudVautgFhRPXE7ZTFDYz91TAnbDdATk7fGmC7eyXFna1A0do33IXfQJ269CsGjOB64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309316; c=relaxed/simple;
	bh=rFk8aOItMD3KPTAuqQNbI7OblSncXhXJz6tEBjQVg6E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mUoOu7vzagRrEht1uBTgD20fV+u1fJLKWTPINxJYaSM6feh1TF0gYKsoSoogqpRY3/2l2hvcdjzBjvEQfgAfC4Agz7Tvoen4USxCvXCchuFWvGKuzCI/tVrWMF0C987yQlairv5aHz815MRxArjDOFdkNGcQ0YThx+GLDaeVnco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AAcF9bj+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AAcF9bj+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754309313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R68X+6+HMmLHL7LPhwrARIBKQ4M6SvFlQIPiCZ+fgGo=;
	b=AAcF9bj+1y0JQurRwVk5Qh7hNpqPEtHukmkhovygluMUks8SQhI4Pt2KEo2qPkNEWjC0EW
	YUk/UHIoatF+UfQBhkedypmMDdfVRnfgr2nj/whPUWzwb1ebYFWN1CguqGr6l4KbbJzQdb
	78GIZzgITRU8j40gHj1l1vLkq1pbWgI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-6ZRXc5GfPtumerQT2BVPtA-1; Mon, 04 Aug 2025 08:08:32 -0400
X-MC-Unique: 6ZRXc5GfPtumerQT2BVPtA-1
X-Mimecast-MFC-AGG-ID: 6ZRXc5GfPtumerQT2BVPtA_1754309311
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4595cfed9f4so4819205e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Aug 2025 05:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309311; x=1754914111;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R68X+6+HMmLHL7LPhwrARIBKQ4M6SvFlQIPiCZ+fgGo=;
        b=uCLBsDzcHmk2rQRSYoa/2GJz2jc35z7ensseaA8vzRB/R7K1ijDejR/PY6Wbf2VkE4
         mtKEpKzJ1AlTZMcfKSIuNwCPXskm/dTd5pnNusifK7xittx+XPZ8qnr/9oNabOf2pApI
         8lk8+AsFLh9lhiN1uPt0OB+tKcK6pE7VBpFEKZ5Y+6ekMnUViXS+mFtue+6zBpLy8OZV
         g8wlHREO64RZpsJB0028VrOQMiY/efQ47q0jO+lsoVxnuQ8TJh48IJ14UFtnPOgvEA7A
         aXypaZm1DzFO6U2Q/TcuvM4klv9Wj992z6VKdrdfJXzphVXDfU2u2LNjdztR801iyGw7
         jF/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGQk+WUDa3K1ATG2c6nPE9B23pXRmBgZNlwXuVA4E+3kjJPNpeddb6CAPH8x6mCw0kE6l3zcM21dA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQYUrEhtsy+UK+QKo8TuzS5FaXK3KSDOYZWtrF6Ss/TdyieHNU
	bb/Do1iywaHEiJzRmSsF5bm3BHBO5KyjLGFoX9GoaO8DR3lW61aUW4NoYVEFCqd2DofVHzvqNKv
	QgQF9IXHBNRspDAQ1ggYNusGNHA5ynVrl09SgArCJ2gMSSwuu28SXhr7JSYm5
X-Gm-Gg: ASbGncsZ0TevN3uw1qD1yfM3YfsckrLmQBqO/1K3hx+WfPqoh/YkZ26TSZa642XmY7K
	alde1n++wsLwVhsf0WLcrbGg2QSWTEuw0Gq4/jWwGxnxPHbIig8olqx6kIehxnd869FwrYQVtV0
	SmCvbgNKrkpn8iBnEC0fScap6sqKgSJW8BsNjAkl6rjQtRvEgUvuruz9B9clARq8USFdNbBH+ln
	tUqi9LtPQkMQp9wwAjXCCFH+RiU5Tc3ZmNKAgtjNUYGKKxgoGlw9S41KaZis9vd1Gjfj9zzQztb
	AzJTaJvEZC5CM+3hT14FIhQ6Mkg9I66IaJWjIFl79kS9KQ==
X-Received: by 2002:a05:600c:c8d:b0:456:eb9:5236 with SMTP id 5b1f17b1804b1-458b69eb65bmr80088415e9.15.1754309310968;
        Mon, 04 Aug 2025 05:08:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFftFaCIqHxg+0lA7xIA/hDF3aJMpB5vLQV6flue1pNK53/EOfTO+SaTmU1dyEXBJzYDPGuzQ==
X-Received: by 2002:a05:600c:c8d:b0:456:eb9:5236 with SMTP id 5b1f17b1804b1-458b69eb65bmr80087995e9.15.1754309310481;
        Mon, 04 Aug 2025 05:08:30 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee4f239sm163962675e9.21.2025.08.04.05.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 05:08:30 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 04 Aug 2025 14:08:14 +0200
Subject: [PATCH v2 1/3] xfs: allow renames of project-less inodes
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250804-xfs-xattrat-v2-1-71b4ead9a83e@kernel.org>
References: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
In-Reply-To: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3607; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=OSppPNIpHEEPsCBe6issi+sM62/lDe6LoiVlMauRGdQ=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMiYs2nv5RGWNQWDAz7QiiTiRuzc1TnmfWFaeva3iv
 NMi3tS+6g8dpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJjJnA8P/1Kw2mUUXND1W
 uXeKvVHafat9juq9ehPeoMw4MaZrR7WUGP7K/BCrUOY8laSmZagbGC51e/61Oyk2dzQbMrunlL2
 vkGADALRQRlU=
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
2.50.0

