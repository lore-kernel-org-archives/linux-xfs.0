Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992909;
	b=KmGS1dTxiLGvxXCL3+nY34mcfdm2okfoyKH8+3kjmpX4nsn/IsjMPg17AHPwR5/aqrOR
	 gZy/wSc4hCvtlb4zoDhHsb4y4lRCsG/LMlOqQaql4nJfPMirXOoyiyvhuk9Yw/46GQJNn
	 WiuK8AZh+e+GYegeBmrbDPcbgo6d3iOxbdGXAaqrXKGJRgVyHdala6559Jn4tGJJDgj6h
	 Wa5xO1JnzoG/9lGnUGmsIpYwNBGBcJKD1iZUdh/zQS6kyD+IcgXyCecmmjDlxHHkYXsBo
	 jU6pI4tK6Tf/9DF6EyupkSW/dWGvre6s6PSLVzron1DxR9nN8JVAu2J+dlPNR3BOGAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Z+u31LeAmcZ5W5bBi317MlxpfwHqN363dhzo0vXbRUM=;
	b=iPGuB0MRzr3hwzv4rQnOp2My3115J+eNYD/yo2ZTnnKGqbVYgqGGBkNOe+Izh3s14cAr
	 Wx0imlPODxF4cUTCMy5QNNE9qW6qzP42J204fJ8gQc5gbi8uaPX8GCWNMZ3rEbelqkvr5
	 /5CsYIBIrz7JSfi4gxH52BP1jxml22cIg0lngnSPZEaBe0EsjcNa8x+Pbbl+mnnxkYBgi
	 OFwEbvRk8sWAa2zhVn4N70swWno9PHLyHh9TpqqXR3Hiiw+RJDb8xOncreeo3xgEUbf2h
	 MBhlQn8bgM9c9rLIDcBJnb+ScRqB4tqk3ecfo1PpRawR6FteZFSd1dehrfYSDY4sPzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AUHW7wq9;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AF6606A31A
	for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 05:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73AF6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AUHW7wq9
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cd5d2dafeccso811766a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 25 Oct 2026 22:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792992909; x=1793597709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z+u31LeAmcZ5W5bBi317MlxpfwHqN363dhzo0vXbRUM=;
        b=AUHW7wq9iMCiWOoaHXsP2JE+3GaHH4Kg39si/n8BlOG1XLsyTAFJI5i4UdZRR5wjiV
         T47waIdDXHONNSAuAcQQZRTNvIhbMwF7r4eF1h/kV00Lhpj0pf+Lnk7rknGUVG8GiBuI
         FFMuNckhxvZfc1cqIrdanMCLF8/QshKxfEycbonZjSQaG1GVi1rqzfb+KaI4O3X+e8PY
         WX2oJt0JwjRVNJsgfeRpHge2h+98ulWIdL66UotVx1mVPerq0G1WClHFmDLOfQepwGZq
         +hWiH8OneIeu7he4Iwk/n5Joiz8upQqFaT8gWPiXg2J5WmKI9u8vyZPt3EqAfRl7cIeN
         +q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992909; x=1793597709;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z+u31LeAmcZ5W5bBi317MlxpfwHqN363dhzo0vXbRUM=;
        b=xvcQhZkeY2P4Lo9pSsKTCxbLvyiMQksH+4v/rK3OcMs7jhJr5T3uPIF2tzvJEQ+YHc
         0nvT2BuBHMVzLgC5vfyt/JNNY/A4ozpdjaUwEEeDykEKYuccj5kbo0SRujWyM9Y2fXbz
         16Awo7zbkzvwKo9A2l9QfBGzzjSGk+yZ0gb4YMuEOSjd3xkFVy4X4OD/3kR1B9jXrIpR
         C7R/52eWCtIVNvAEbJNRwvzmkYMw0p+06ITpPzzIEL1zUjbpv8ZBAlK4uu3Zod0g6e3Q
         djYd6AViUZDL6+u8vPLVZQOYL8WYDmaGUrbBIL2c8P/XlnDlvd4WEsECVonXXElO7+2M
         uY+Q==
X-Gm-Message-State: AFq9FYJWAca/O3MMfLsJV/Atmsfx/zzuUt5+Y1lyBXyriAJSfTulZ+gP
	v8KIGtHE0/9gdJkLMggZte5oARY217bShowS6ebIbtNbxewTJbDgZavqHaeMRbaY
X-Gm-Gg: AYBFou2MpTAC+Ht7mGbSzB2pK0MtKLwpBxIRHVWWboPFWgv3vARK7EvZwmDw1kq9znZ
	xSAcQ012jtQ6q/oXyxZGrVFV9LkpYFxDdDTw44Js/wwGpjFyXN8tAzl5Zh7XatxmXkD9Wi6Je7r
	4WdO8dU2cTSPjNoNZPMJotZmrUTO2l700LBhaXbk0LIxN6O3lsfZG05CKfjeWCnS/f8wZUnOZMK
	i1tftWiX7SEj2cglzKOVCs5VUy2dS4xjPd47EjQKIWnjPS0WWF43TBBjvEQ/jffOI4xYKFYwlZV
	c7V0pjLflh7YydwQhOOVTktjh2CpREtPPu1NslO7Y9phZ+IIkMLYdHutXGhXIdqAW/Rz+UqOKNi
	Gk/Y9E9B5l0oCLNYhTJ5dQ27t3wYfuV8kSws5VBHQfnTlA8g3u9d1Hy4/7OCdBoyMnk0dpWiuEO
	9CDs2s2pm8s7+P59ZwnJ1DChOEf7tyEahi6Gm6Otghs2UFXaVEYnyKqoBte+LqI/SciCpB5LvHo
	ysr0IF+cWUex7XoeBaJYRWpvQXXUCwkqYxThOWvE9YS7cyopkdpJSeTiu4=
X-Received: by 2002:a17:90a:ec8e:b0:3ab:7031:d962 with SMTP id 98e67ed59e1d1-3adeb0fb5fbmr4521956a91.41.1792992908735;
        Sun, 25 Oct 2026 22:35:08 -0700 (PDT)
Received: from fedora ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebfa4102sm6947614a91.12.2026.10.25.22.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:35:08 -0700 (PDT)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH] xfs: fix unwind handling during xfs_mount_sysfs_init()
Date: Mon, 26 Oct 2026 15:34:55 +1000
Message-ID: <20261026053454.987673-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.56.0
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

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

The goto for failing to setup /error/metadata jumps to the wrong place
in xfs_mount_sysfs_init(). Fix it.

Fixes: a9a7b9e8686d ("xfs: add support for lazy direct read bounce buffering")
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 fs/xfs/xfs_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index e77917ac179d..4a6a8c92c3a1 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -906,7 +906,7 @@ xfs_mount_sysfs_init(
 				"metadata", &mp->m_error_meta_kobj,
 				xfs_error_meta_init);
 	if (error)
-		goto out_remove_csum_dir;
+		goto out_remove_error_dir;
 
 	return 0;
 
-- 
2.56.0

