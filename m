Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550478;
	b=KodTE9nF5Z6qEQ4nyOlyMgQ5CKVedgj7ZWZPwdh/n8CXJyIcN/ZkReKQCTelEoD3sPK6
	 ZZoC7vITzxf82MIP7QQZ+wZCdXpRAuLpzo9cllDRG9DGIsixJ6C6M6ZDQPh76yqjALwHm
	 e/5ftvpo4La60yVB2Mz22PVyVIHLJVc2PRshGZ6VVK6uKm66hwIoUK0LjwVIOv4Rc2c26
	 W0ziPStYj7S3HCIF/vajQq0VdXmToFXXS540+bwmLLn73Yknklh41jP8QQhrRe1ZX17t9
	 NUN/a7CUeJsR7zBJYH9jqs60JWwNHjEr/3SQeh+RVBCWr/UgXC6gKA6ik8T3qExGzQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=REJsOLwnT2P/avPBtR/BK6p8j1ibMqDK3+PxP0rMxnQ=;
	b=K7sL3gW/X/y8HwslFdeDgdzMDKm2ce/f9Sx8qZw552WdXpkBGZ/cdPigbgUADVcMG44n
	 v7RGvI9ePbRIsSiHp00kgfO7+RC7fotlhU8gpYLxfzWcV9YYbKwFJ6W5XaA9PNNquIqN7
	 5ncxH+XfcJ7DU1RVTNWbfHwkD22tDHyjGbjJEr2Eg1fjWDfzs4ZxgvDbuwQC2uijOC+hf
	 3YFJNLzYtfU/gn69giV8TKBQ7YtWMfTx6JMqe6eGVYF7/FUB03DVVzfM50mpJ093SCMMw
	 R8QmScOCW+MBAHzxE/7QOk0S77bCzeAp0TAGvov0JUutJUiD0oJqd4WvSX40PHSEiuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C+evjEM2;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3F1606A32C
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D3F1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C+evjEM2
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so18439575e9.3
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550477; x=1794155277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REJsOLwnT2P/avPBtR/BK6p8j1ibMqDK3+PxP0rMxnQ=;
        b=C+evjEM2OrhLT+6KkcCd0FWwVf+ZcZwDv14IY3cpJn8QDazvadj1x1Fplnm+OGnoj6
         4GSqUId2Uyu8If+Yy/8LWYnvo6IIwcGK/DLacZ79p9Nnw1ryxpo1pzTcJjHZ5L5L+3TB
         exnt83habACZIpZm/Vht2kPICa8Ah1i/mWv7Pc+cxw0CVRBgmWJ1N7u8q/mlsOzIQKRB
         0mMWU7xkDLPPFmMq8bZiMTPWiZ+QA7TWhHkKBsH+0CGZJzSAMBbxZNcwJ6TPbrsMBHLF
         JNOoqhfkclt2IVEbZz166p32LV7Ckf2gzKKgUmhnxLOFXmjczJz62jk5QjbkQ32fDAAd
         2aJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550477; x=1794155277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=REJsOLwnT2P/avPBtR/BK6p8j1ibMqDK3+PxP0rMxnQ=;
        b=QkTIR4F5blTp8NPKjsX1UhZ/5H4WbRIfDKXAVsa1jdKXqB3vgsNpqRgcLOVp8eJ9GH
         dASiXcRbKU3PsKjPOb53HsrN6EGyuSCggSG2Pqpku13LuOspDoqg/WgkE30O/GQrBfvc
         moA6t6UjWdujT1dotcDYk4V1yD4ZsfhAe/Xn8kH5fAgYtS944LXt5AaPAmMpkcbJZq8f
         ZKHcQnAOOC0TJ02Q8kshF1oIL4A7/nwrtBTEVZCS6ZNSKHaA/y+MKFYt7q2ad1xmNxGd
         u6tesBPxEOmCEpa2R32mO3DT5wSW/NWqbqQ5v3qx0mezy0AFjM4QpeCqLlWtu8AcEKob
         OdLg==
X-Gm-Message-State: AFq9FYJ1TNz3Qb9mgnU43rh78t7YqIoMUWWo8dwVYj//Z8bfxnjYfPQC
	jvLmDb4rKJPuMfzLfq9Ipnl2fz6TE7SwALzQky7v9izCmxOF8bDPZkfNIvH5
X-Gm-Gg: AYBFou18YmpRzkpxuixgYKjdqYu+a96uXXdy2+CeiM9BSq/zoVsAVSkEQX/a1L7GWn+
	OS4RQlx5CFwKypL8er8foqokxvnhJDZmK55ATQtKTXLHnLNv8WVuJae0MiNE+T9PS4bqw8cJNIe
	sM5oh3c/B3XxaUGJcXsqVtYg7TcCfKyku/uVT9yuP/kZoJgjqvYoTh9nGuU8WqKsQiOIj5ehrWb
	NKaLqXH6UkbhG5H2SHNSNjuoBEp1YUbqIM1gdSQlGeRzN92jY+pTheWdreAdyqwVc0hOZ96J4QT
	B5KidHvfFaKKvZQptbdQR10meC+ggZCLt9UeULNKTtX6De/FdtR1NNNUJR4jqnMirGZVl4A6PuA
	6or+d0pxmX2Mt6rKmko69soiMRyXyS+dCanrAaV+8JsGE8ySrpsMruwZI8Kqf6E3nUYTfR2zm6a
	isvHL3Sewsy1S3CULeoVVRsnqPlZ92NJrEc8EHuXeTdkh14rkOAodcNI2Db/Ovt1v26HnhlERtg
	kD7ST4ptlOiXLLhXvy+5ObhEOt6IVlXb9fg3KbZEz0OvgpQPPD9Bcs4iZNy6VxiKtgyP0rBmZC7
	A5tsPsM/9FE=
X-Received: by 2002:a05:600c:a4c:b0:4a1:fba8:b13d with SMTP id 5b1f17b1804b1-4ac17d16ba4mr178304325e9.9.1793550476570;
        Sun, 01 Nov 2026 08:27:56 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac0a66caefsm167095245e9.5.2026.11.01.08.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:27:55 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsdump 1/2] xfsrestore: validate dh_sz in read_dirent() before reading name data
Date: Sun,  1 Nov 2026 16:27:52 +0000
Message-ID: <20261101162753.1443201-2-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101162753.1443201-1-tristan@talencesecurity.com>
References: <20261101162753.1443201-1-tristan@talencesecurity.com>
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

read_dirent() reads directory entries from dump archives into a stack
buffer. The dh_sz field (uint16_t, up to 65535) is read from the
archive and used as the read length, but validation was assert()-only
and compiled out in release builds (-DNDEBUG).

Replace the three assert() calls with a runtime check that rejects
entries where dh_sz exceeds the buffer size, is smaller than the
header, or is misaligned.

Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 restore/content.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 7ec3a4d..9074c34 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8234,9 +8234,16 @@ read_dirent(drive_t *drivep,

 	/* read the remainder of the dirent.
 	 */
-	assert((size_t)dhdrp->dh_sz <= direntbufsz);
-	assert((size_t)dhdrp->dh_sz >= sizeof(direnthdr_t));
-	assert(!((size_t)dhdrp->dh_sz & (DIRENTHDR_ALIGN - 1)));
+	if ((size_t)dhdrp->dh_sz > direntbufsz
+	    || (size_t)dhdrp->dh_sz < sizeof(direnthdr_t)
+	    || ((size_t)dhdrp->dh_sz & (DIRENTHDR_ALIGN - 1))) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
+			"corrupt directory entry header "
+			"(dh_sz %u, max %zu)\n"),
+			(unsigned int)dhdrp->dh_sz,
+			direntbufsz);
+		return RV_CORRUPT;
+	}
 	if ((size_t)dhdrp->dh_sz > sizeof(direnthdr_t)) {
 		size_t remsz = (size_t)dhdrp->dh_sz - sizeof(direnthdr_t);
 		nread = read_buf(namep,
--
2.53.0

