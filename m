Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795660481;
	b=L18AUzzPWfc6NfhJ/dYv+I4yi1MT4tsHLxRZMt6jPBkQicaQTOkbqmwb10nGuxdNOqma
	 ThUCWhot62ViNFZ8AJ91oCWmlNFylxyOqN0mWU4gMY441f8NdbYaMuUcXLZzyJkwkfVMc
	 eki3CrrD6IY2K70iLDhOhsB9btzBnqJg7CJJkM6yvSLh23CoctePnrnhGUM6gmR10Zp+W
	 qwpHvtTV/iA9mq25K68TeYkCOKlo/ImKrfVINVezzE6t0jf2raFM5zF9Y2BLrrqQegOz6
	 2uhoqrzGyWGA+5ySaiLhuU9xbG1tD0hGKY12so5yOAyD+DRRooTYMmvGTZEgoF32A7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795660481;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=x/ILrJ+/NMYTFTFp5J74uQeEtDJj7OVnJ5vnxO7aL9Q=;
	b=wDUsCNA9GoMZ6EWhFDVIwK3erRvFGpmlIqdQzOD3zvzDPPOXmyZWqvJ+thB+/PysJfGH
	 dqLzkRxC3Bxbq153TMLpE9EEmZ3hqee9Lw4McEDw/cOqbRXlyFZghfVdz7VyP/VGvmHtS
	 YBEGI3q9eh14k07/z3Qv9qeeZ3DEqRaH1YlN6iRIuN77b7MZsiLqN8CDW25Yk1vy2NlDe
	 60Aa5WLUp0GS2LVRuan3/gmyTyP4AdnIqc8wxye3pwpvEKlt4taHs+kKqV4MAFBojgcrm
	 tWi36T0p3D+aYXE2gPRzI2R4UwDdyNBXcOi4xl7/krSiTWxsRFlF1UM5kMms98anNjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ctxJ8ZzC;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275E3606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 02:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 275E3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ctxJ8ZzC
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-386e226acaaso10164eec.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 18:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795660479; x=1796265279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=x/ILrJ+/NMYTFTFp5J74uQeEtDJj7OVnJ5vnxO7aL9Q=;
        b=ctxJ8ZzCb5J+nwhRb4lb2Eeuu+v3J86bGNTKlzTAQCD5zCdQpV498cQ3u7a/ujYruM
         M2MQxJyBpyE8l9Xl+OcLQ/I6bBP9rRGmVjKBXXipNlXGmXNdK/Yky/hK/3CWJKybyvub
         WpTSmK/GT8ZCMYsgiEF3voNroNE4W64F/ReheYKtIvfLLa0F6+/RAExTXhkrssOknuCY
         L7hZLCtNAHnCBUwGBOvpk9JNr18DTGfUyiCEBLFMAndorG8mn7egM/K1l7c4vLh3g8aa
         KIzYtddpF1mOxglxBVB+2bwPSHSNs0s3LMUfoc+mpfW9rdBCy/5q1pce0j1xMecC3T1H
         z1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795660479; x=1796265279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x/ILrJ+/NMYTFTFp5J74uQeEtDJj7OVnJ5vnxO7aL9Q=;
        b=oEsUDQX54J5VM6amXgqB3e8dABeKTwEXp2UfffA+WNkdROUL+Q/C66Br16bJsu+9Dl
         OYhdLQhtG2c9gLfIZdD2BKgA38HruTohp1ECjWlB4JWzwDVz171MSPa4Z/17/jvpfCyR
         0ke4Cdi96eiUN3jufxEbId6CNiJM8dxMsVCkwwUjsZbCnnTXItC8Llg9/2KmK+L2+tKv
         lZZKT89bGoSUWgvW0XTjKGpHhM2K1WE1TaS30rIs5wD3tF/qfRBBrXDjj+jtw4v5F6C3
         NC8yU9ODPoLwS4eB4nJ5IwDvcMCQfN3EBe+kKcveMjyUSQ1LU8FdFk4et46HPHMYO4Z7
         9x3Q==
X-Forwarded-Encrypted: i=1; AL+hErFINjsgNNqb3lw9mSJ/FLVALzr4Frdc18jBywJBvXkURsWNxxUDO+58y5fHe8a0tRbvYbMqHXUcJgw=@vger.kernel.org
X-Gm-Message-State: APuU4Z/4WousCBc0hF579p0wfrYLobE3grGhXH1V2F/eFwm2X82lJxlO
	C6Co71AsY4frJf0hX+8SVIkBc2ZQRiTJjPiFWMjjThw+reqgAwETxWsl
X-Gm-Gg: AZFdTZceSdfJmxOlsmwtL8oMwqlVLdXzxyreb/RgR0qHztBW6rP1WD6j039BKqQSfSx
	+Cl18x3pC3C2ZYb+PwHXZHWwD79t80h9XgsMa5HudBBgwE5QDAfF8KdIgMUrerXtCCRR7AGNR5l
	9UtEwsYZlVv70Msog4R2Ju8MrIUaI0aIEhcCkbPbr5hsF6U7NNfAXIM8qjhvkkk3VLLzpyprIue
	ESO/Yhqlz9nKWfeFlbQxvC9EoUdnLdKIynqzjmGDOf9poYxkWnn/k+2mRazPlV/YMVE4ORbK8VA
	UGgPzTW9SWPpnu+Pv35zq5p+pBBqCRRe/iN5oncCr96rjzURgM5PHCcwDT9flNy6ciDMuKR5rkO
	JiCUNmWzMDt7l43oz3QHK2OvPT59jLnUCdlM/XQ27Mvbs1oSe0u62aX5UsiTYqhnW15Ne+gH+Ej
	I90SgAe9T0BK2FqS6aj10/V16Vifoo8Ysb+W4esGx3+pkZ/HfAoci/8Y5UJ2OrYx8c855uS31YQ
	BvMyLmqaDq7USAsB8hcFDP8Sh/eFn6g5OPqrimYDJ/Di/YKUg8l3moGMh8asrTznXEDN2BOpKIl
	Nlde8vnXbnlJND2AcrSwP07FDVLUKfOg+KDl6PEkpFzeDIdV51OKt2NgR0dbFyFyvssELW4IkmA
	jv0jWy61AtB1naiMauh7KvToRBU9kGUVOgradcph2EG/VR7hq18u65NC0g2IfeU36AzYmuyM=
X-Received: by 2002:a05:701b:4281:20b0:14d:c7ae:85dd with SMTP id a92af1059eb24-1b55686523bmr20656315c88.7.1795660479079;
        Wed, 25 Nov 2026 18:34:39 -0800 (PST)
Received: from localhost (ec2-43-203-195-82.ap-northeast-2.compute.amazonaws.com. [43.203.195.82])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5566c1142sm44070633c88.2.2026.11.25.18.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 18:34:38 -0800 (PST)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH] xfs: fix wrong lookup direction in xfs_refcount_lookup_eq tracepoint
Date: Thu, 26 Nov 2026 10:34:01 +0800
Message-Id: <20261126023419.5727-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Jianyun Gao <jianyungao89@gmail.com>

The trace_xfs_refcount_lookup() call in xfs_refcount_lookup_eq() passes
XFS_LOOKUP_LE. But the actual btree lookup below uses XFS_LOOKUP_EQ,
so the trace record reports a mismatched lookup direction and misleads
debugging.

Fixes: 08daa3ccf541b8 ("xfs: add repair helpers for the reference count btree")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 75e469576a8b..6a15a1afed1a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -96,7 +96,7 @@ xfs_refcount_lookup_eq(
 {
 	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
-			XFS_LOOKUP_LE);
+			XFS_LOOKUP_EQ);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
 	cur->bc_rec.rc.rc_domain = domain;
-- 
2.34.1

