Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E3D1E9B34
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 22:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742594933; cv=none; b=qWpqzOMMWoGgTafZO6gdI1mUrE756gBUQ/xvwTmbeVIaIClKuV1MnkT2/IFhuf2XT+pwZz2YxtayeuDeIrsG/YsPRzGDvqU6KdRWu2cf9i3MJYyn/dYHqdw0qJW8jCFO2OoS0hMcCf0n19NcwPueux4MeD4muaQ/mRlTJDK5dk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742594933; c=relaxed/simple;
	bh=fl6M24CK/pGwDG+XVMQhvbk6ts/QyFUHngWuiptyYHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NU4ruD4vMeHTnL2EBFRhSugt/tIlH4E7LtsG1enI15eOPC/mAIDRhcHrqcM4HNv5YQh+Qtmhve9gu+laKByzMZmke9T4SfpCpV1ixucC1/zYrABK9Q4AOtrQ4L3xxRTDiDWD6T4xWok/94wG5Wpor/OvEJYX9V1VcQyRjCQ6gdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BT9gkNuL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BT9gkNuL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742594931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qTDS1UunVSEW5xa9Jbn92c/5TrRWyjNTwUdP7U2vJyg=;
	b=BT9gkNuLkzSkWy9CbsSbzRJ6QV9u5UXEW9Dr49MLtNjQvYpv4+eLvZ/YsaAeepDwi1TZdy
	hUo/Mz81uQF+mEXfKWiPOfuvkTGRn+X4Nt5E7AJnx+3u8XsoRjYhRK03pEaNLUr8kPUTVu
	avMEk6L4WzUVeZmP6ttRBytfZNjpPEU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-Y9OcCGs9O2qgbrOkOp7rzA-1; Fri, 21 Mar 2025 18:08:49 -0400
X-MC-Unique: Y9OcCGs9O2qgbrOkOp7rzA-1
X-Mimecast-MFC-AGG-ID: Y9OcCGs9O2qgbrOkOp7rzA_1742594929
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d2ef1a37beso22944565ab.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 15:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742594929; x=1743199729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qTDS1UunVSEW5xa9Jbn92c/5TrRWyjNTwUdP7U2vJyg=;
        b=Opw9w+HYJ6UpV7AToVpQbI0h7CrnTtljF0PkVr+ZV/mvgmF7H7U8kFpdg5xh9EAgor
         Pq3iRTXy41notDNdmXoDDc8ZUbmXoXYjAohRrXdcVERms5T0uhxUj6Tug1a7KTMCrx4d
         uP+XhrFO6UMsohRzYamvyl9SWS1xitQc38IcT70zMdBQGuSTBoCmYMqnVewGNqpIaa7A
         dC9E5LESsCU2o0KUxseeLV1J99qss6kAjzrXi4wxfwFvpQIzcLFSKXABTgAiUXKcDLHv
         Jn5XWpqYj77FpUOkdvn60qc0lnHXT8T1GfAK+6jhZfeqURfqBfogmhgGZ6PtLfwbA3Dj
         e2Aw==
X-Gm-Message-State: AOJu0YzrH1uIrCRZgB0VAfyA2xUGHOWtqYWhOGBPXszZzf16LxT8oEgz
	+UOTF0Hvqh4p65ghPVQIqda2VMaFnAScLy/y2jfGaDF1kqeZbX0zPBhRKkiHXliMFvv7vQiRIx7
	jHomlUMrdJzw8xFd3EqiJoOrV1lbplz/K4+T2a8b0i1z7aLUzO5geYH/9+/wdVoBe2liWdyDKIN
	32ifhhDdUqmBEL5r9+FysHkq+v2GE7EpvfUPwd0igRig==
X-Gm-Gg: ASbGncvGU91jsulfSXJ3GFzdhjDRMwq5p8YXUas0PCyPSXrAOFjezDBCx7bEYtC6/z9
	p4tigE21j9gt1CIwQYvVqYcoihtlRwJT0Qtf5vorjw6cin2L/hlPrtStQ/131E+g5NeepDWs6B8
	oka/JJbWZYjz6TzYFiUKFIIE9FLALwQQV5uAAQkezUkyGApr9ssW41QYxZ5bETsx9kOFclzqpgx
	2ANuhe0txjwDVEDomUdo+P4m1FNFf0V59khvtmVeN+qZ+c1Cx7XYZPjKZ8IWNqiXQRWFATiqOBw
	4virurNuXIrGPU3RHFjp9sXqHeVJ5tH1WxK6uzBxygbai9w8xj8bmQB2rw==
X-Received: by 2002:a05:6e02:3f8b:b0:3d2:bac3:b45f with SMTP id e9e14a558f8ab-3d5960cd058mr59373625ab.4.1742594928864;
        Fri, 21 Mar 2025 15:08:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkEBkTjL3Ojja2Lp4yNqp9d52YQsuEmzddIe6N/iL5xvnb8Yt40uI3ulUSkHdhlRQFhTfRyg==
X-Received: by 2002:a05:6e02:3f8b:b0:3d2:bac3:b45f with SMTP id e9e14a558f8ab-3d5960cd058mr59373325ab.4.1742594928303;
        Fri, 21 Mar 2025 15:08:48 -0700 (PDT)
Received: from fedora.redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbeb2e40sm624283173.121.2025.03.21.15.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 15:08:47 -0700 (PDT)
From: bodonnel@redhat.com
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net,
	djwong@kernel.org,
	hch@infradead.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v3] xfs_repair: handling a block with bad crc, bad uuid, and bad magic number needs fixing
Date: Fri, 21 Mar 2025 17:05:35 -0500
Message-ID: <20250321220532.691118-4-bodonnel@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bill O'Donnell <bodonnel@redhat.com>

In certain cases, if a block is so messed up that crc, uuid and magic
number are all bad, we need to not only detect in phase3 but fix it
properly in phase6. In the current code, the mechanism doesn't work
in that it only pays attention to one of the parameters.

Note: in this case, the nlink inode link count drops to 1, but
re-running xfs_repair fixes it back to 2. This is a side effect that
should probably be handled in update_inode_nlinks() with separate patch.
Regardless, running xfs_repair twice, with this patch applied
fixes the issue. Recognize that this patch is a fix for xfs v5.

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

v2: remove superfluous needmagic logic
v3: clarify the description

---
 repair/phase6.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 4064a84b2450..9cffbb1f4510 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2364,7 +2364,6 @@ longform_dir2_entry_check(
 	     da_bno = (xfs_dablk_t)next_da_bno) {
 		const struct xfs_buf_ops *ops;
 		int			 error;
-		struct xfs_dir2_data_hdr *d;
 
 		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
 		if (bmap_next_offset(ip, &next_da_bno)) {
@@ -2404,9 +2403,7 @@ longform_dir2_entry_check(
 		}
 
 		/* check v5 metadata */
-		d = bp->b_addr;
-		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
-		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
+		if (xfs_has_crc(mp)) {
 			error = check_dir3_header(mp, bp, ino);
 			if (error) {
 				fixit++;
-- 
2.48.1

