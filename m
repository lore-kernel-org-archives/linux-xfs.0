Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795237520;
	b=0yXltVWzfI/2DriqW5rW2n/undYeW9pWcl6usq9nfvy2+SCZidWrpXh4wKb2At3Q9BAI
	 lcA3vKACfEsZj61LOHYTaJWC7+clPph4xnrB/xiDW78AABVI6+Sgqt8GBmwcwrOU2sRoo
	 FZrxb8fxzMa+APc/UWaqpGeR6A03WwkQ/HkXlQA1A7jiRYLPIgtWXjrfAocV2o1Jafy2Q
	 luGGkD2wJKzz4h0tRI6ZiWGf0U8et0gSKZhbaOscLWJze2+HcZpSrggryZ2D2xJ3Fw5Nd
	 VWmCN98EryJy2VAvC7iZ38wvinGrNDh4WJm5ZwtaFfXXSxObRfvIcRwm7JYS7Sjr04Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795237520;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQEmuIgwiSjfHM1LUUYtpY7CsiRUokc3oxpqHpj8l5I=;
	b=133iPMWiqm0ihWMuQdKCKL/5pA8vW+5znivHl+A7YKMqJmJJkCq1uXFwcOqGziH57wHq
	 kKfCU1OoadqRRwroHC2PbUIHpVXG4eAXpWNHxVt4hm20fuCwyGozy7NAvdmvNNbSvzOfu
	 3CdlSn9jr3jB32ugXY0bT288QysDJ1qfa8b9ybFfroahCeBrvbIw7goOBeZ7U/oahBtBZ
	 LL3oCM48Hve6ahQqVEQ/GXA3I6chArYco1F8TKU4ZTItztvkqMe3n760wOaPwpD5KCOfW
	 Zez+09ornl4+jAgNuwT6/Y9Q2UBekea52wKfXT8S9yFd5EDVMZyCVuuleVTSxQpml/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ahx4FyJd;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596BA606A693
	for <linux-xfs@vger.kernel.org>; Sat, 21 Nov 2026 05:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 596BA606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ahx4FyJd
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-33fb4680717so4106301eec.1
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 21:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795237515; x=1795842315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZQEmuIgwiSjfHM1LUUYtpY7CsiRUokc3oxpqHpj8l5I=;
        b=ahx4FyJdCzr8CkjV+1FLr+jCU58RDubvTc9idS0Lp7sWS5XHx2zbOt4MH4p86wKh0r
         yrjHJDtX4tiN6j5wpPjfyW3pC5ZLaaxak6jJuBeHNSWqNaTblvbWJjYXE+RngkYm1M01
         inqd3roa97NOdaAp9j0zNe3oJIT2AKdJAl+M1ksIJknBVXAtAb1yVzgFQkFiVSIyxQBn
         BT9U/8xyd97ed61QgDjIKbuDFf3ppjsqn90nRQ/nG26+Z4erGeUN32eao/1B65Pe5Z3Y
         6ALDVV4U73UXfIxagJWYzrSWCCVq613p5rFMRq0bm1fAO7zpCcNMFODQtJmE5gkJOAQY
         vjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795237515; x=1795842315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZQEmuIgwiSjfHM1LUUYtpY7CsiRUokc3oxpqHpj8l5I=;
        b=SmOSP3HLnJwqNf6iQUvICiEsVsCuVpymzM1Mb57I19BKDKA1umIROd9B+h5LM1S/Mr
         xErL+tEBiPnhWX3JbyTfRTshyy0/1eUa/O7PVRDrQa27jvCAsYuw1mjFD6wS1kJ+p+Pt
         RQuEa3sIwJgfzONdAmYIT3a7HJewl918WRQ5S4LIw8IM5DGmoWgFZ+Zi5uWfHKLaHEKd
         qvoH/ucAmeBNJ/EciRT+UNvrHJg0PqTGmzGhDkOkGMRAObaRLPG5b/QjUqaTZrBTw1Xb
         FPJcsfEJZ19dQcwsf0uMgHKBZ6QECdRrdQJfev4tzK7s16AopdhnavOuzR3HtWcIGQpP
         X2Ww==
X-Forwarded-Encrypted: i=1; AL+hErEZ0ZVV1JoxQH1dnftsPxysZUXEdiFK7UD0HWYHwga80lY8UQF5QADZBIZ0DGY5KiXrX2ruqn1U3d8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+NY13kNSINC2BQXkWddR+kFkZogSieRDIcoa43eUfIDN5ajdxH
	LADmDvDGOHWJh+aj0VdqNdNbm6iWZPtKAELTyhXXol2rgEKQdz2mANUH
X-Gm-Gg: AZFdTZcSxqUaiR08cQzX4XM16XRW7XXlffHUzCvmBuTCX0FLkDn0F0B24Sk6mFZMxb7
	ik21CG9bTsRqJOrZp5wcZyMuvYfJmi43ualEhZ0uAITzptygLNZfWRTDZyTMDMBVJ1dPN7/Kwix
	wddxWLJW4usQeVTxIK/Q02p0/0hKErFqyu8GNqyoOsQODjt2VXSMJH8LQJJMpzOrFPqF/rX6XYs
	BViETgwb88pukPwak1gN/SpSWXeoJjycYQLXVOf6eqoCG/Gx3t8Ou0Ql1Rae3Mg+OXwLAmLj3ic
	AlFk/+8hK1i1ecoJsN4uLJAqxUTTaEMAlpUv2iOT7YUipzXUEBPawq+dzBREe/Mg32sn7WRALLo
	2o+9P7HcWL0YOooFhKH/0jVEWkdFyN6jCkTPKAHLSPL1yp/JBFYaQ2CfUqaky3JHCtn64qV04J9
	SyIcca6U5EOMgssoJs1p7qvGvptd64NDlhzalj3gy74HfpJCW1gO06J5gkkip0RoopEyRCNTOod
	M/XkbDzCy/SsGcLrNc98tAqZ7+jcIYzVXUVZX4PiZO9lBijR0sTd4QstpACRM+1xGOTee6/qlUI
	XC1X5j1vVMYMktFHfV1p7ZirED2YkGSWzplzhJR0fKDUgJOaJuxSwyFqyfik/Si3PVs=
X-Received: by 2002:a05:7301:6405:b0:37a:cafa:6d78 with SMTP id 5a478bee46e88-3856ff54addmr5762667eec.33.1795237515192;
        Fri, 20 Nov 2026 21:05:15 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567daaf70sm14545835eec.28.2026.11.20.21.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 21:05:14 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: reject a hole in a remote xattr value
Date: Sat, 21 Nov 2026 14:05:10 +0900
Message-ID: <179523678723.1642977.7101755246592074809@gmail.com>
In-Reply-To: <awB1mmg22PhD_efC@infradead.org>
References: <awB1mmg22PhD_efC@infradead.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_attr_rmtval_get() maps the blocks of a remote xattr value from the
on-disk value length and only asserts that a mapping is not a hole. The
leaf verifier caps the length at XFS_XATTR_SIZE_MAX but does not check
it against the blocks the value owns, so a larger length makes the read
reach a hole. Without CONFIG_XFS_DEBUG the hole becomes a disk address
past the end of the device:

  xfs_buf_map_verify: daddr 0x258000001a7f0 out of range, EOFS 0x96000
  WARNING: fs/xfs/xfs_buf.c:423 at xfs_find_get_buf+0x160f/0x2350
  Call Trace:
   xfs_buf_read_map (fs/xfs/xfs_buf.c:648)
   xfs_attr_rmtval_get (fs/xfs/libxfs/xfs_attr_remote.c:434)
   xfs_attr3_leaf_getvalue (fs/xfs/libxfs/xfs_attr_leaf.c:2718)

Check for a hole or a delalloc extent at run time and return
-EFSCORRUPTED, as xfs_attr_rmtval_stale() does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
---
Christoph, understood: an image with crafted metadata and recomputed
CRCs is outside the XFS threat model, so this is a hardening fix for
such an image, not a security fix. It does the same run-time check as
xfs_attr_rmtval_stale().

The patch was written with LLM assistance; we reviewed and tested it.
It applies to the xfs for-next branch. With it, the reproducer from the
report no longer triggers the warning, and XFS reports the corruption
instead.

 fs/xfs/libxfs/xfs_attr_remote.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index e6c8dd1a997a..722440f005ca 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -427,8 +427,11 @@ xfs_attr_rmtval_get(
 			xfs_daddr_t	dblkno;
 			int		dblkcnt;
 
-			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
-			       (map[i].br_startblock != HOLESTARTBLOCK));
+			if (XFS_IS_CORRUPT(mp, map[i].br_startblock == DELAYSTARTBLOCK) ||
+			    XFS_IS_CORRUPT(mp, map[i].br_startblock == HOLESTARTBLOCK)) {
+				xfs_bmap_mark_sick(args->dp, XFS_ATTR_FORK);
+				return -EFSCORRUPTED;
+			}
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
-- 
2.43.0

