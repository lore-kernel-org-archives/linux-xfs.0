Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B226C3A16B9
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 07:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776237435; cv=none; b=rdeh94OaRzQ30+kzaSMm9xK45P3B1XEYPgu/PSqzTjL91GcRky3PYRJKkM3EmzvSJrX6X6sWZhG43VmgNkTcc2w2hqOE0yRrULrbGvvn59w9znoy58MaZhlqA8o/FbKpB2It91iwnz+ZRDTecAaCZ3DQCjcI89mcvVuBUV0VlaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776237435; c=relaxed/simple;
	bh=Z0PFj83wUZxDbDI0Tl2heYx+wvJWiKxDfwKkJMwyGXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z6daby8aIgCN3v2zKWRizvwKdiguesQgVRtPORaUEMfO9ElYQFsBQlgaB/jlEIDVQHYwMAqjDh1mOq6l0zO7xhCd/LDMGKNWI+N8DlIZSv2IKk7rSMnlxfeaIWWXF9uezkh/HFqesy804mKCyZx7+RcKArB2uBi5JUKDyX1BbbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RtTZlR4m; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GKe1+gT5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RtTZlR4m";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GKe1+gT5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776237432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Kpxo+PDDK3DTSUbSbSohhwT8i9dWuHGnv9dNRZsuMyc=;
	b=RtTZlR4mwKga7TT+F9LUgwpDRkbidB39+r2Wgavvi/Sr7snIuHbZZafeXTv9ILeS2Pnkwe
	vvuAqEfuGeOSR8LLWA6Rc9WJx3CRUOxcTfqeP09NkeITmVqyJoPsGC78w1YMEV3Luuis6s
	9eYjUo28q/LlT3sBkYZ1Z4JuurzHFiE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-9teSpx_FOO2mOa0Qok4JOA-1; Wed, 15 Apr 2026 03:17:11 -0400
X-MC-Unique: 9teSpx_FOO2mOa0Qok4JOA-1
X-Mimecast-MFC-AGG-ID: 9teSpx_FOO2mOa0Qok4JOA_1776237431
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8d4adfc84fbso1815928385a.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 00:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776237430; x=1776842230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kpxo+PDDK3DTSUbSbSohhwT8i9dWuHGnv9dNRZsuMyc=;
        b=GKe1+gT5h7gW8ba/FTyibv+U7IOaJRf7bFrGCBsgwVkCDIw4sL8ne0pp00dqmZjaDp
         y/dGvaI+L9k3GhVJwK8EH1PrQKLLFYwt3X47tPLGZhIgiPiYVe4NIgH29DwW4q+l+teI
         Dr8si1QtsNWPGwukgD3yKe50SDONkDvt9a1EqR4vduYeALrDQbNmm5Gw2Dy7baUPxvmH
         3kTODpz9sFnksxUUVgp0SDA07i+0ivcRkpKmqx9I71celKmBA9tAlog9llD9bmMihd4c
         TLPpg3MDokt1iHFToxIyyPvd7v5Xp7Bey7YnexKr5cEhrhhivbGkVLjOCHMEkDgIVhQa
         Dg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776237430; x=1776842230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kpxo+PDDK3DTSUbSbSohhwT8i9dWuHGnv9dNRZsuMyc=;
        b=G/V9ys28PTupj4+y2Jfw9bZQ+/Ea9IGUc+8xJhK7DLwKBCv9Bxj83NjWAvKAk/roEO
         7a4TVUhRM9fIWh7ExErJAsa4YdkjiWZs11Kmcjx9E9i21Q4X8iFrBkDuAt318vil0jMi
         F2EB0eQJHXeHqVrOL0IhtiDygDPDVVg9zm80JZLdweGk2vNAUOW2igJKhEXCJl5l081s
         e3J04BpF2BuMrrBH2bM5Q6JDr9SwqsZ/7eMGghLvGJwh4csvc55BvI28dGfow8pNRejQ
         N9CRKr12b+FVmtCCuAAj29J0V8L7wthFeuKxKySAEPBJTA5yGqjhoprWBy4Ad7TNFKDK
         haig==
X-Gm-Message-State: AOJu0YwKduXBpmfUiodd66nU9vJKmyk5qW8Tb/iRnyFjYqk9Mnajtoos
	3lMu8e3h0X9HVolkhNYI3JdkZT/JppGrcOqYI30QwHA90TY0EjWjmeKQKTWptr1OT2yKL+4PISp
	F482Wj3zdE/28yhczrdST6t/6tdXWZbjPTaDxhGRUGREi/PiMbbuhBocbDPnFxWD18kxzotP0no
	WXyBy4aaOVOwppD1kCCOlsW3KIRfv+7O/2Q+jmbJUzyVwLQXCG
X-Gm-Gg: AeBDiesKbLXXLTTF0xamzPpiDFJSNJ563RO5Wk5Vp8cAo85ycVIquADZia9s0CbipZo
	rCAAol6/Ud98NQmpa5DdFhFEXzZt0o2xZiFmFhjCX0WpGwgeqVhwsuVLcUUjtjHmOxHnPklX7Vg
	DXCmwbHTkAQVK6n1oMYWcWusZdaiu1TJ9mwjP69CIVoGYAHn6rZINDPYp/G4I9HStgUUPqVBSx7
	28HJMrAy5gG36mRhDz+sC4c0vzXl4a8qkl5R75GdZM23J1pwGMGZEWdABUpBhSw7pOUiwr6zMcX
	dsD7I3sUECFOzhUEYB8+o6Q5WfBxOfXPIK0g8Q2VgkD1zIZspHl5HBhqnyo6UP+3zqWj0EnJ12q
	PZIJ5NR6CNJ39ILqGFAdDAK13NJ2Fm+XDvFVUtG4ZzBovjQ==
X-Received: by 2002:a05:620a:254b:b0:8d6:874c:a763 with SMTP id af79cd13be357-8ddcffa63fcmr2846137585a.49.1776237430036;
        Wed, 15 Apr 2026 00:17:10 -0700 (PDT)
X-Received: by 2002:a05:620a:254b:b0:8d6:874c:a763 with SMTP id af79cd13be357-8ddcffa63fcmr2846134885a.49.1776237429589;
        Wed, 15 Apr 2026 00:17:09 -0700 (PDT)
Received: from fedora43-upstream-dev ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e4ef33bc4csm58464985a.12.2026.04.15.00.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 00:17:09 -0700 (PDT)
From: Ravi Singh <ravising@redhat.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org,
	dchinner@redhat.com,
	esandeen@redhat.com,
	cem@kernel.org
Subject: [PATCH] xfs: flush delalloc blocks on ENOSPC when creating symlinks
Date: Wed, 15 Apr 2026 07:16:57 +0000
Message-ID: <20260415071657.23412-1-ravising@redhat.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When creating symlinks on a nearly-full XFS filesystem,
xfs_symlink() fails with ENOSPC even though space could be
reclaimed from speculative preallocations. xfs_create() already
handles this by flushing outstanding delalloc blocks via
xfs_flush_inodes() and retrying the transaction allocation, but
xfs_symlink() returns the error immediately.

Add the same ENOSPC flush+retry logic to xfs_symlink() so that
symlink creation behaves consistently with file creation.

Signed-off-by: Ravi Singh <ravising@redhat.com>
---
 fs/xfs/xfs_symlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index c4da624fb296..bf3cf23892eb 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -148,6 +148,12 @@ xfs_symlink(
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
+	if (error == -ENOSPC) {
+		/* flush outstanding delalloc blocks and retry */
+		xfs_flush_inodes(mp);
+		error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink,
+				udqp, gdqp, pdqp, resblks, &tp);
+	}
 	if (error)
 		goto out_parent;
 
-- 
2.53.0

