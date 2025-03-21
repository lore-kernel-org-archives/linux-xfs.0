Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083601DFF7
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567419; cv=none; b=Y1WQk/lEP+UIpa9fsSCbpxwRU/nvbKYsSYBPpYyng5Uccqhe3Z94injh0vAQPfUgkPo1Ha68xgCub0b28W3XKGeSLZiP0madVtFZGvQgbmCtc3wrXRq4Udr4jhj1gewO+9Eemi1AaFQITNJsvBHgW8NjxSSuahG4Iod4O14oYfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567419; c=relaxed/simple;
	bh=qJcYeEHq1jA8iUwUhMEZ4Fsd3pWfZMWIu2Lqnr4r1sI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i+HzNqLiBMluimshBUfklTVsEkrj6CO/wnUhDMdRr5EK9xvqc6lxcugsHZtVKPDcC0tsrUdIbF2vdjGvZrJqb00Ilatfu1NQHhjieDCi8dyKLxHDg77sgNLuqkAoRsdDQ230vX8SllP+kTcP9EgkPuz8yrJIV3D9Xsl50OXdRPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0B0Ug4q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0B0Ug4q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742567416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZoxfVK5PH92PwUl1fdSQSLQ+rq1zwwU9tSLj1QRngng=;
	b=K0B0Ug4qeaxDVKOgx17m4HBqBTGBTyDsXBqQ5U0408jXxQo73VGqzBGmQcMqRJYU2sFFWj
	mt/Losp2OlWGnLPQzxjmK0fjYXX/mwahnbtJ9jITYuecIahcV4bk0Joj6MiPVa0regKvmF
	7T5tw28qwDFYXGc+vFj5SffXHw1s+Qc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-3g0QRewxO7aODHpF71TeVQ-1; Fri, 21 Mar 2025 10:30:15 -0400
X-MC-Unique: 3g0QRewxO7aODHpF71TeVQ-1
X-Mimecast-MFC-AGG-ID: 3g0QRewxO7aODHpF71TeVQ_1742567415
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c543ab40d3so332529285a.2
        for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 07:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742567414; x=1743172214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZoxfVK5PH92PwUl1fdSQSLQ+rq1zwwU9tSLj1QRngng=;
        b=RchPSbVn/hFT0Bds5UOS/8/BwRoqc41udJ5Kfsy/D5U8xJO/trPJjtWTS2ch+tPi0j
         0ocaNj53XLI+WfYLOHdQwacGJU+MlawgRYTxp+TvqcwVGSlevJvhhC6xD5Q912eXSPSW
         NC+AYN954GUmKF4CJ/blJq7VN1fwresbOSx6pgiLRtW6DCsx4cTRyPAPcML8CKKvKuR8
         7spB9KUzOdvgZbSGLRPJMRR+1aPl7Z7ln8uKzyc2/r9oX54IynsMzWa5nOFT7/rt+h27
         SpgfV5vu3BjLjCOI6kFd+e31pR5ax99wQqUkwA56/a7R30B+V/Nr3G6FB6dnS1R0E4TN
         8jRA==
X-Gm-Message-State: AOJu0Yz6GydStRJgVJRnaRGG7eqdKGOMJ9hRmUJTEeXm366kGKpNVSda
	V1szjya2OmUb7rhPRPxP23hkKzNN2Pgl4UsoujS3C67bG6tFGRqnuYAFJ7wNEAFui/dBlAzB0Cs
	1sdNbdqM/qFInWWH6qCnR2+t3G4/TPrgs3VkP5QrE6+rJV2tu1eP0brrG4tYX9NCPLeRSKCUJ/H
	b+mxIVEE2xSZg0dzGkDHqdqcJPPIHkXaty+R7qeKqJSA==
X-Gm-Gg: ASbGncsBIU1ooEf24kDWAOUg3tUUUpr9i+U1IYZ1qKdYupZhzyD8YjA8msivR9BBASi
	2dVLEEmNmz88pP16r2uHsMsosmxyK/E2JCVEVkrkghMcZngD9Ynsd7iINJU4WaEKJF5BY9D/CId
	21eTbqZ+pgpudMPnEcTKDktIlZO6Ta9XuGHA9qahnqN/FfqVRZ5c3dTnaqw+HFyaPXOPTHgydXA
	+GUIYVEFHhv7WdqID8vupbCJ3ojCIoOyf4PqsTO1R4TpOH4l67wyI2lojLDUbMGrrPOBBbyP+4c
	eKInjDs1V/EeksCO+qPAcB2hcuwMVWi3+mRx34owP2jw3t2BbyCDXvX4Tg==
X-Received: by 2002:a05:620a:4894:b0:7c5:5909:18dc with SMTP id af79cd13be357-7c5ba162857mr431950485a.14.1742567414450;
        Fri, 21 Mar 2025 07:30:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3mCXlXE0cGHVwYJ4lOoO9GIXcRmMM1z3kTR0oHS+/odUg0A2/zWX7csaa7BmKHbCsHV2Pwg==
X-Received: by 2002:a05:620a:4894:b0:7c5:5909:18dc with SMTP id af79cd13be357-7c5ba162857mr431944085a.14.1742567413833;
        Fri, 21 Mar 2025 07:30:13 -0700 (PDT)
Received: from fedora.redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5b9355870sm135774985a.108.2025.03.21.07.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 07:30:13 -0700 (PDT)
From: bodonnel@redhat.com
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net,
	hch@infradead.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v2] xfs_repair: handling a block with bad crc, bad uuid, and bad magic number needs fixing
Date: Fri, 21 Mar 2025 09:28:49 -0500
Message-ID: <20250321142848.676719-2-bodonnel@redhat.com>
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
Regardless, running xfs_repair twice fixes the issue. Also, this patch
fixes the issue with v5, but not v4 xfs.

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

v2: remove superfluous wantmagic logic

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

