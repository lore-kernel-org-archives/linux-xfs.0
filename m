Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E4D32E6A3
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 08:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768206294; cv=none; b=MOU8GAPmWnfi6ksfUPc6/oNwcO2zI/+np0FC9bQMEl2dNSuMMSj/gbWzf7zXYq14jByltWbwrBwmeFy9GtUFbJ/J8aKTq0PW0qDNNpPvV3hTrmsFxAnOCYQ3gfpjuIzRq4KSPizBBiyiUQHysrtfy+amG6aekI8JvwdSSAQwr2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768206294; c=relaxed/simple;
	bh=DWvSwez5Guy3UW2DP04NYR/BmbKeUBtrBvEZ4gTJKKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uvGboeeuw/mYpOFG710KujgvKwGku4uS8Vuvxemyek1fsX5LlnIBBlExvJBb4oRBseuVc6wXvqXrwENdj7M6T75Fuwhn9wzxYZLLWvPUD1CX+01n4LEEG2T70/vYRYHZypy1cRLHUjEJQBCFo1/X1sY77X0Xex0X34whPZbUWAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9vhhS1d; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9vhhS1d"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c2a9a9b43b1so4158913a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 00:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768206291; x=1768811091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QOrgUksN0pfvPzppmINv87x++txu5LIWgoc0H0evUc4=;
        b=f9vhhS1dL0eKY8BNYw1oV42gAaav32SfXNEnfqZFT8voWJQxFYsGJzpIrBQP32tXxR
         X6LXUNXgFow+1FJtki9oNqwn6Xez3673Ef1uGMNiDQJxud8R9e7c/jwWbvs57x6tQpuD
         eT6gWNuoaCz5jCPKjPkQNU+xNqy5ySz6/fWN99eT1MUgyZeBwotcEKQxDJDdT4FgND/8
         /GIrvV1RjS8Xh+A2hEgFIWCzS6f1S24AscFsf2yTVFgJCaQqXVCpw4yOdrZqzjdfUQG/
         bDyysro9XM7TsZWN8c0RkmdyhmGxiviAiIbLbO5+TOu1ywh7APV+8TX4IYen9Zt2xlN7
         lTOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768206291; x=1768811091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QOrgUksN0pfvPzppmINv87x++txu5LIWgoc0H0evUc4=;
        b=A5kjL79bek25F/xOUA4E1RPF4zBCang4qzpE/HDMncxXNYaudHzjjK4fFmTLZr4he7
         3NiuY7DWVK/GsbRx0fQGYb7TpCdrUKhvgWvERIeUlx+fLDjJCWZFqI7rShvS1qUeeqRw
         KezlN8hzZJjBdTR48DE/WWC1TzNwHsJhRqiXrvsKyKWQZJZi7fQ6rDTbmbEklo3lvrr0
         fxlbfzM5//EENeSTbB/rZnV3CcZpwXSIHlgsl7NTxIIK+beL0OEVLhh1DjdVhH1CyBVu
         dyI9nJx0+JitsiouRhrhuPGzONAuORVReHD1bFh6gplgWNPQq6rgdXXm1T/omE7YGBTk
         2hTw==
X-Gm-Message-State: AOJu0YxAyH3YFX2g8+63OV5HDqq4BNw/nxG2VG4gtwCxjGYeFQhDIIGK
	yIC3m2Lu38ElwjOZSod5fVa72LzBpGgDbp43yE6P+JDJMxrmrp/VP6kjMFSyuQ==
X-Gm-Gg: AY/fxX4pNShZG+9af1KalDh3+Fe1eDXcrRA6g1RpJy46sFuYU6vI/xQxB3DAQ3UvJOj
	jTu2xbC0mYUIoPdcVis/HA8TJqx/jhuSlow/xKeCh+najfGlM+11OO4GK7RhEqTq1XfcbVFEqPB
	X4ViTakvd6BZ9eXZotY37uYdC/ghMUargNavdpzP75/YTe5vcDgqh8Je82oxq2gcJnX0j0QHLTP
	kWFddvXEHDI5f3QEPvnK2nrnWYRbAHeSev8Qw2hj3e+h4KM6/TJFPf99VnnLKAy+8PAiu4i8Gd5
	yOELA3x/il7AISIAJCFMgsuW5G5zufUZBqm9uVBAWyd24Mf6opV+DQx57fghO6zhFbf94CGgxXp
	f6G+vFqbWXMfTXDvN5uhAcnhlaCvzbuhxa+57RU0Umc2EMYJLQL+NqKdjq9RWH06AetZj9Qd5pm
	QNXNqcWUJw5uv7WufCfTncvOje17gPxO21oY9wbzMPX3AlgpTyg9NnVMdR+C770DOKOUqUPw==
X-Google-Smtp-Source: AGHT+IER0OxAVQrw1KNItJbNHPtEJmENybNIFZHdRfrKZZpqx83CKLmxpzprUnX5aco9kWuUAlbytw==
X-Received: by 2002:a05:6a20:94c7:b0:35d:6b4e:91e6 with SMTP id adf61e73a8af0-3898f991517mr17196775637.46.1768206291423;
        Mon, 12 Jan 2026 00:24:51 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.232.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a560sm165854875ad.21.2026.01.12.00.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:24:50 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v2] xfs: Fix xfs_grow_last_rtg()
Date: Mon, 12 Jan 2026 13:54:02 +0530
Message-ID: <9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The last rtg should be able to grow when the size of the last is less
than (and not equal to) sb_rgextents. xfs_growfs with realtime groups
fails without this patch. The reason is that, xfs_growfs_rtg() tries
to grow the last rt group even when the last rt group is at its
maximal size i.e, sb_rgextents. It fails with the following messages:

XFS (loop0): Internal error block >= mp->m_rsumblocks at line 253 of file fs/xfs/libxfs/xfs_rtbitmap.c.  Caller xfs_rtsummary_read_buf+0x20/0x80
XFS (loop0): Corruption detected. Unmount and run xfs_repair
XFS (loop0): Internal error xfs_trans_cancel at line 976 of file fs/xfs/xfs_trans.c.  Caller xfs_growfs_rt_bmblock+0x402/0x450
XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x10a/0x1f0 (fs/xfs/xfs_trans.c:977).  Shutting down filesystem.
XFS (loop0): Please unmount the filesystem and rectify the problem(s)

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6907e871fa15..2666923a9b40 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1324,7 +1324,7 @@ xfs_grow_last_rtg(
 		return true;
 	if (mp->m_sb.sb_rgcount == 0)
 		return false;
-	return xfs_rtgroup_extents(mp, mp->m_sb.sb_rgcount - 1) <=
+	return xfs_rtgroup_extents(mp, mp->m_sb.sb_rgcount - 1) <
 			mp->m_sb.sb_rgextents;
 }
 
-- 
2.43.5

