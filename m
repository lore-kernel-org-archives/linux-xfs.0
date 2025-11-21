Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E55346E43
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763726222; cv=none; b=bbfilvvxRVZ1TTl/TBRDdWkctbyg3WyBVQrReR1c3oCr9FNa1oeZpGDVVcZkQrNTZ9ZixXSkXZ8bblQW3WtR8oEkBfgfrkW2Uz+6jM93qemC4YixSi3AmMi8zsPXJ327HcprhQsidzubFdw70AEEhHsrajyqwZOOFuzAeqhb4bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763726222; c=relaxed/simple;
	bh=R8GRcttGF1T3d6+Cl/AroewdMSebGIHuofVMGMJsXlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ep6yGUDKh+7r9oV2xu7cpRyYKO4S+OU0ImY3jB98L31kYBowXp4K/xj2w6A0C6gPZzXZb3pEHov484P3CC4Z+Lzcw5XXjikMxsuXVGBKnEivMI2VSXYf4kPy35HB8wMLVWuuD9+FNoqlIedzEem1zERTNyOuYM0A/cjLavTvlzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4lE3iSx; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4lE3iSx"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7baf61be569so2250965b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 03:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763726220; x=1764331020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0kaM0a2BYntxbf1z2+KtSo06Ztxj21kqZKO+ZWV34Dc=;
        b=J4lE3iSxsTghWQee2EMfn8RCwVOeN2pAI6tMo1B49lxTwRU9+BVIqIIXgHxqsZfkLj
         qAh6Lm2OCFsjl7rl/aBqkQMxveVRfWQNGjo+mU+Qn+jCOwhhyAIWY653nHGF2Cr2XHj8
         nu1s3H55k6Op+hLXNioMgqSz90nYKXW5ARPzbVqV3mszxWCRS82Ez+YDSmWZovYwKnsT
         d4HpBkZGR2aYeynVQxH1M13pVH0rhHl8k4EqNK97nDipm+zQnVLyhgVoSqAFub7j4dXU
         97Y2O7c1xAqK6DQhHZ/I1Bks6WtmiouuOOoulRi9pRGNEuBByjl4xCr4veSVVDCXuZXG
         MuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763726220; x=1764331020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kaM0a2BYntxbf1z2+KtSo06Ztxj21kqZKO+ZWV34Dc=;
        b=BwoMHXNl+BHZkJJQpslB1gsF8I0SOGBXOQUvVr8F487IIcLk2pvqSsO5D8xFVKodsk
         WTkPFMF9Z4ENFt/tKrJNQDroPLjNQI2NXNrpSSGCejCJRJYcF4uTXL/0+wRmuteeMwSO
         5j3Ki9awJmzMDpUEhj6SaM2YEZfLzRrZ77F//EFOHRYULWQ51dsd2sHF4zpCyroDYqBz
         ofcRddS+yazhF2vF3xaIpXdQJz71OqVLC25oa+1k29Y7FvqI35tZaNoPtHd2ih+JFkJR
         jRISHc45zng9wN5zoF+gZQFb2opEDbaElubsjtOffCjRNON4UjSYkuloqL/sFb/wnkJp
         8PcA==
X-Gm-Message-State: AOJu0YzBFH0L3rt2e7oer1sKfNwQfW8i0rHBOburf+Lvi3sb6e5zbJOg
	EG3OqV6TXdzoGxeiEPnwDE2Oo364+ro5TsrtMz9xKi/d0V5ni6o2I0n4b6wBEw==
X-Gm-Gg: ASbGnctQ1wHdbraNAUkLIcXbOJOUj5ONdprYyKVcYgxiH8KdCIH0wRmgoEkM1kEnOcU
	twWDT+2ldmspAY68DUVIb1tneBIQ1AVp8ULx/uIBYUP1BHOjcnTmR51Z92kfU3+Q6AS9m/qv4yy
	/7XU7DZRzpXGpnQvcM/JdK18H7XQv0wBwXKg5X05bO9A8RRejfnVEB5gxBXKZ0BY0jGpLEgpixB
	PIfHjgNE7Rt833C5p3o9d5MZfgIyNQ2y0ZmQNAmY32o8PaZTtEJq7TxEqTfsVd9j4vXBKAlI3NO
	68nhP+ueEApbYh4TzP+0HgI+mLW/7mvTIwbwGL9v5LjpHjSxzqBguQhTU6I02j8g/a9bX1V7Oeb
	sXL16lAPJTHyi9RIh6zKKM5xDG8xYYXCgTRWrHFWiIRitBQqV5PwwYRHYL4WIPIfPqhV9G2i4CB
	zeLN9JpOeYQJt+V3kDOGVuG3WzF6oVKUnkNw==
X-Google-Smtp-Source: AGHT+IEQ5TKmJNvFOI6V93bWmKlvdZYoBEucDc7MxzGgWIqiOr4R2NffVPtJak5CjKQIcp0gLB9X8w==
X-Received: by 2002:a05:7022:f683:b0:11b:c1fb:896 with SMTP id a92af1059eb24-11c9d70a12bmr945319c88.4.1763726220190;
        Fri, 21 Nov 2025 03:57:00 -0800 (PST)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93db4a23sm24119158c88.2.2025.11.21.03.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 03:56:59 -0800 (PST)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] xfs: fix confused tracepoints in xfs_reflink_end_atomic_cow()
Date: Fri, 21 Nov 2025 19:56:56 +0800
Message-ID: <20251121115656.8796-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

The commit b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
introduced xfs_reflink_end_atomic_cow() for atomic CoW-based writes, but
it used the same tracepoint as xfs_reflink_end_cow(), making trace logs
ambiguous.

This patch adds two new tracepoints trace_xfs_reflink_end_atomic_cow() and
trace_xfs_reflink_end_atomic_cow_error() to distinguish them.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_reflink.c | 4 ++--
 fs/xfs/xfs_trace.h   | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3f177b4ec131..47f532fd46e0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1003,7 +1003,7 @@ xfs_reflink_end_atomic_cow(
 	struct xfs_trans		*tp;
 	unsigned int			resblks;
 
-	trace_xfs_reflink_end_cow(ip, offset, count);
+	trace_xfs_reflink_end_atomic_cow(ip, offset, count);
 
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	end_fsb = XFS_B_TO_FSB(mp, offset + count);
@@ -1028,7 +1028,7 @@ xfs_reflink_end_atomic_cow(
 				end_fsb);
 	}
 	if (error) {
-		trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
+		trace_xfs_reflink_end_atomic_cow_error(ip, error, _RET_IP_);
 		goto out_cancel;
 	}
 	error = xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 79b8641880ab..29eefacb8226 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4186,12 +4186,14 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
+DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_atomic_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_from);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_to);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_skip);
 
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_atomic_cow_error);
 
 
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cancel_cow);
-- 
2.49.0

