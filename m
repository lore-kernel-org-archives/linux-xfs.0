Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC5C2D97AF
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 18:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971649; cv=none; b=deJRnsTbJP9uzgnoouKRi8d3w11BKWuuzXlu6AsPt6k0/cbi9kQRdJaOtnxTXEKTu3WVLi4T6MZeOgnwzsSuk1hmr+9/NNx6+6amOyC7z1PQ54Ni8r+ZdoxzP14Oqe4mZ/xolDR/ZVsC0rJHSn8W7yMeh8NsCRM2jcEjq1fmiK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971649; c=relaxed/simple;
	bh=UWTVi+79biUDXYVbP1Zfv1jqXnj1FUi+MQ3m7OOq1IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dslg2GGuSRtVQ9vYFT2uRqOmjIXvJRDnIeuACg4j6xOTHH8koRRrIQlhwHduJRqwO692w36igvdm5In2neUBOzUR/NOYzFwcBnXy8BZjI7m2tDJN7lzvxQWtdRsq85PR5/fvkPNOZQEYUXILIQPvHTvuRS9XYS7MgnKIUVS5NtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvdstYrc; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvdstYrc"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4eddceccb89so10606981cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 10:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762971646; x=1763576446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bm1UHN2KZxJ0B3W03H3cTsYhakxCO69X9Qr+GtDJfPk=;
        b=GvdstYrccqKxeRmF2zQbbG230Gziq5f2liMevtY97kPVichOYfm+4MneI5nSlYiwS4
         bpJqtz7zqx6kge8YfXnr61Te1lNSFP8OxLhEKIY1SGNoC6YsRWrttgTneX0mhK97pDr1
         zqnSqIM8CuAJG2qBhWO0Ph89HHWbGIxIg9oy96Rkx44Q2TGo5bTT35ERge2rha1/mQ/c
         xVpxahBH6S760pl/wbqaH7qXRgMk0cYLW5d3zBFCGBFEeJ+/aTa5paX6fhOhQnQ7rysZ
         xh+uZu+XFYsmdEYkR5sF6YQ1hp1gOqDcHjs1seKhAeO/yxMneKCXszFMdp7PlkmKTvqS
         SqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762971646; x=1763576446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bm1UHN2KZxJ0B3W03H3cTsYhakxCO69X9Qr+GtDJfPk=;
        b=PvQBmnaTjsopRVUfQM9hB3uqcGM0PZYcmN/IkkTrxmVhU04EnHuFY/VfyCH509iQ93
         tZStW8e2SWxyQ3e2/NjtkWYEQM5PsTGEvOF+NEQFTTKwJ+hQRIuJOG6jYzFmr3oo5OM3
         kkmE7yT6+lSDMkoKwd4eVQ/1Zb1HI1HluAfA7vcPMtaUipCZSSBFtNWZaczh1vUaxnZB
         gW6av82j/9nBMwoKgIcPykxLAjbd+7bmvF5/nf+twwzbtfNye1x63gltasSxP35Hi8k1
         bBHg9MhXtvVD5b5E2V88G7R4d/r5vMo2GMKHyTWvJuxNum6rvcoE9m6iLI6yuWepOw/F
         JLyQ==
X-Gm-Message-State: AOJu0Yxo4YN88R1jGZOnsQghG5VgVt9gZgZLj4OgPq7A4sldC9JCY1QO
	lzPd/gz87KcCxHlx6u7Mx6EuUp9yA/7Qkfc/V6oS5rechBqL1Bhibyln
X-Gm-Gg: ASbGncu6P9g4KT34xFeRMCtji1EuckhFIhjWjv85aodELAkI+qcjgRzDnOdRKuRZpYH
	z/k7zauXtO15L06A+QPZ5U/xIW6V/B9+MYulDyMpZXitlaeu2Bfs6P2lMItwWMhe7AlsdZj1Zkr
	pJ2P/QQV5yADvBRb3PeZoBVJTpVQ1vgXsa2cvX5tZLhKvHO1uhInHsFvGkbWs/5RFOzGQ/hC00P
	3e9V2flL+Qcjo+leB44gkxoJ2lMouPbllMfZL16R37o2Rk9rivvvy603dyrVMFvRbO057ihxcAW
	4fpFpodSWfJGW8Pkc/662IBurz4rPmzFLWZljsUa7Wg5A2mDqtJJjDf3ofYI3pqZZzF/nkawVrX
	p2NUM171Ti8z7WGEr+48YewPj9r6KN4umn5yg3fCZI9sMvYGQ5/S5LAQMxIfSk63+jS7dHW9W3X
	XkxfuxpMrnBPTf7zfOl/1J
X-Google-Smtp-Source: AGHT+IEuXqC6cY8OV3bFmpAtTGXgz+fn2i6JPBVrYLRDN+Z4yHegy+UVfSzEKFMHist/CiPMcek+nw==
X-Received: by 2002:a05:622a:1ba3:b0:4ec:f073:4239 with SMTP id d75a77b69052e-4eddbc6a4f9mr52756321cf.6.1762971646334;
        Wed, 12 Nov 2025 10:20:46 -0800 (PST)
Received: from rpthibeault-XPS-13-9305.. ([23.233.177.113])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda5659cd2sm92260921cf.15.2025.11.12.10.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:20:45 -0800 (PST)
From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org,
	chandanbabu@kernel.org,
	bfoster@redhat.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Subject: [PATCH] xfs: reject log records with v2 size but v1 header version to avoid OOB
Date: Wed, 12 Nov 2025 13:18:18 -0500
Message-ID: <20251112181817.2027616-2-rpthibeault@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aRSng1I6l1f7l7EB@infradead.org>
References: <aRSng1I6l1f7l7EB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In xlog_do_recovery_pass(),
commit 45cf976008dd ("xfs: fix log recovery buffer allocation for the
legacy h_size fixup")
added a fix to take the corrected h_size (from the xfsprogs bug
workaround) into consideration for the log recovery buffer calculation.
Without it, we would still allocate the buffer based on the incorrect
on-disk size.

However, in a scenario similar to 45cf976008dd, syzbot creates a fuzzed
record where xfs_has_logv2() but the xlog_rec_header h_version !=
XLOG_VERSION_2. Meaning, we skip the log recover buffer calculation
fix and allocate the buffer based on the incorrect on-disk size. Hence,
a KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
xlog_recover_process() -> xlog_cksum().

Fix by rejecting the record header for
h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
since the larger h_size cannot work for v1 logs, and the log stripe unit
adjustment is only a v2 feature.

Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
---
changelog
v1 -> v2: 
- reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
- update commit subject and message

 fs/xfs/xfs_log_recover.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e6ed9e09c027..99a903e01869 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3064,8 +3064,12 @@ xlog_do_recovery_pass(
 		 * still allocate the buffer based on the incorrect on-disk
 		 * size.
 		 */
-		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
-		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
+		if (h_size > XLOG_HEADER_CYCLE_SIZE) {
+			if (!(rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
+				error = -EFSCORRUPTED;
+				goto bread_err1;
+			}
+
 			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
 			if (hblks > 1) {
 				kvfree(hbp);
-- 
2.43.0

