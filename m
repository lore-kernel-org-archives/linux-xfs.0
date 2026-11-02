Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631713;
	b=HqITsgzgiztjLiMDwEWKOpwT/2qG0uUMDYUEu/AypDuXs9mGi4L34DzWBMIu0mpR20Ql
	 s46urpPZN0jR4us1MK4iufX5vRf7zAJmQeIMFwWXe68rlPhzhODyTb+SmgDH7UEgSf/7a
	 uZHgHn+/KEj/uI8RSZsV48WsG5T2GqF2OhD3hBfLCXkSggxxVWTE8dIfXL2bDL37OnAz7
	 f2MQ6zrWEFYxqxqd6eNEwmePHjkHN6XqAzA+7QK5UAvTeKluRgIlsjon09CU24k2Ki2hs
	 VZQbqjb++N8KBV+sVi90JZsVle+/QqH/eff8WPSinbvM+eZak4cRlFIesAQg9MEZw1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631713;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8l44OpvREKctVeUFVW4vf198xHBq2jFaQ6cO5qom3KM=;
	b=TzZ6I5Eudh5oLTJaQzpDz4b46MrTWbGtzSzN1DNh7lLcTn8oNEKSfvfUqAU+BfGr0fJb
	 mTZlFbfiQfLO5zFgjNqEaz1ZwUoLVUSq3udglP1bq3qZ0UpmszYZ6qrhEb9MNfyNW6e+o
	 US5diWZ7sHTZ1cYOWlgp7/Cv7xdfJ1Z41X5j9KXEgETF9VirGnJDkg+3orLa7p1/8X/XJ
	 GmnVacndddHLlamaOAYgHq4GMd93x9w2gmBOmmTzdYnHYkS/zf50rMMJV1NfTrWDI5Uzr
	 pRY2qFDPfd1WB7zLHaj7PTUnkP58PMlrJoaLz+6XnD5O6h8elUtEYs38HG2ZrPh5TGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="nrOjI/IQ";
	arc=none smtp.remote-ip=74.125.227.136
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0F460A2631
	for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2026 15:01:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E0F460A2631
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nrOjI/IQ
Received: by mail-pj2-f8.google.com with SMTP id d9443c01a7336-2e538951d07so30769915ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2026 07:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793631712; x=1794236512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8l44OpvREKctVeUFVW4vf198xHBq2jFaQ6cO5qom3KM=;
        b=nrOjI/IQ8vLRDHe1WeG4/2R824pmXUtn3ORubIMGUAv81K4aIF1ybSqn14Yc88zYEO
         kzdxo9I33lORrsimuUAV8Js5ZTDmPmNBpgdeiAzbjjfvgv6Umfx87NRldYWwfIYgPOnW
         eBR/eJzTfFC1Pyuevj10xoTjKy+DLDs7MYk5Zj8B34Vn2MZtWyFLOsnk2P3VnpdxTW7F
         ChAKJxH3MxP3TA897ZAKLOBwCdYMscH85vQyOG6LUwmhKHRwrb2s93oyCge7zqiBwQFc
         /Dw0N5WOr31coa832+VDR0xDGpUv9aCbhXNQoe10iWxMOLG8FPtXYcZPQ5G/P2XHITGy
         w0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793631712; x=1794236512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8l44OpvREKctVeUFVW4vf198xHBq2jFaQ6cO5qom3KM=;
        b=c/J2G7gs1c7NxSPfDuJGlNQ9ofvo+SggXYc0myjTIokkiFSxY4SlO3SIyrSgJlGtaR
         LSQi6hAFotg7+lEoiroQcG6yF2bwCJf5pov0U6gmKDe8NzzMXDYfXHkiZ0u7E2mlhv6p
         CNFeAyqqNaxLU4ml4a/q8wdVewNvrQmuYzw3rdwq/VKYAPe2I/773uLGP1cD0Ffn+Ulm
         X4cPNta7iIYVbuZ1H0c/es56bISKQeGMP6hxr3/q1Spob3KhfUMJHzFWTrrYrhYkwa+T
         N8QMFFrRyNH+O+Kxr9Prr2MMpObmqcI7VGT7w/t35NXM8vpg1kw/kijWYu2Ou1hGp6S3
         CH/A==
X-Forwarded-Encrypted: i=1; AKwUvByjxPsCZgyX9J3nPm2a4WLbgG7VlpSdt5punZfQkC+7xowf7JRfcw2sQBlG7H4tvGpfE249qs1UOK8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/+RR/jN1oT4ggi6BeSzhFG4FIKyMZUirMa0LrF98m09nwMuaFT
	T5xP62kya5U+NefQWFVxnHvEmkmqF1GK+XagtpPZvENqgLkrIK8d6ars
X-Gm-Gg: AYBFou2NFAfG42exyBoa8yDVNUzturBM1/U5b2rUD6JaLB6C7RxaKQATXys72o+KTux
	XeG0S0yO+raeLOPhc/7LZJwb8hC3MEfxKlVNQOeMXjQeWvW2MjCPcx5btOzk3OvgYOS55fUaFqk
	eSsSg3oaIzSPejG/SLqPkHKGz5WLOSjLjrNt/Pa43AbXxQafGKP4LdZztmkjrrEj5hPfeRQrrgi
	/0G1Th02JIUhAX6Rf8JO9lXu2Yaj6g6e6YUGEMBvxqy4XoYpKI4RYTSC2jdz9pZGG8SzEFzwTk8
	C8t0mKqy5B3lakokSr57oHxZlPsg6w+h3b1/t/CKra9DXhEz06QhhZSKy8Pd8yVUpzBHlwkf1Ar
	caRML1oSqWQgFJTrMw93t8qVMmjCBKBHECyNO6WGw1+HpQp24rlnXbY91gjpEHP1vheh90Ad6aN
	weT0slCw1zqVlLS35jaYsGxPGCqHVDvOZd+h/VMgw6fw/ALHuP3G+9nqB/LsYivGRQcX1ArUUNp
	PSrGlgUIOCXigaEAciAwd7dYDJfxoRRGBi+B/8zfVraGHANWL0QpNGAcBWvm+9+vvqgnFdbzpCR
	WXhwOPEGSmAa6LuWp4DHT/3iPuHYTfbW3GU795VgW3LVdmUQNqFogzPKnsx0SAY6IzlPEWkDDPn
	M4x1xLkQ+1SgYSimxbG2fhBM54ByiqbhxqfC0WajupVX4emh0cp4GzCifl6Fj9w==
X-Received: by 2002:a17:903:1a0f:b0:2e9:6788:9369 with SMTP id d9443c01a7336-2eb364cbac0mr99822395ad.34.1793631712330;
        Mon, 02 Nov 2026 07:01:52 -0800 (PST)
Received: from localhost (ec2-95-40-37-200.ap-east-1.compute.amazonaws.com. [95.40.37.200])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39052bb1sm31540395ad.1.2026.11.02.07.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:01:51 -0800 (PST)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Viktor Malik <vmalik@redhat.com>,
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>,
	"Bill O'Donnell" <billodo@sgi.com>,
	David Chinner <david@fromorbit.com>,
	Lachlan McIlroy <lachlan@sgi.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH] xfs: fix temporary cursor leak in btree shift corruption paths
Date: Mon,  2 Nov 2026 23:01:41 +0800
Message-Id: <20261102150146.19777-1-jianyungao89@gmail.com>
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

In xfs_btree_lshift and xfs_btree_rshift, when XFS_IS_CORRUPT detects
an invalid firstrec/lastrec result after xfs_btree_dup_cursor has
successfully allocated a temporary cursor, the error path jumps to
error0 which returns without freeing tcur.  This leaks the cursor
memory, the xfs_group reference, and the per-level buffer references
held by the duplicated cursor.  Jump to error1 instead, which calls
xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
resources.

Cc: stable@vger.kernel.org
Fixes: 9eaead51bed95 ("[XFS] implement generic xfs_btree_rshift")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7effebe297ea..d706f59b0301 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2567,7 +2567,7 @@ xfs_btree_lshift(
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2737,7 +2737,7 @@ xfs_btree_rshift(
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
-- 
2.34.1

