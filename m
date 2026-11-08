Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794101078;
	b=XIaiQS2eAzpBebbdtE0pzGafIwu/awhjR5uyL7fSIeryD5fGFvJ97mC9Li8yfNMjOCKW
	 YbIZK4xpqztxzxvTRdb4Em97TXGS5VKBso0UPRCzlfopMkF1hI6Q50+fl/gp7eZu281by
	 J4Svky1AV4LuNYcOIw57jFqyZeVzaFryDRq1P0UcF7NXTyX7voGYmUs0eoD815KEMK5mz
	 ZUuFH4aWHFcjtKZPqDTnKHWC9cyUW2RYrKHvRH1uC515wQCxBzoeG6ZvOOvHDt/1gS6kY
	 FA8xn4jgWwUjp5FDKw0iAJP4jrKOsjS4QoaYv6Pl7j04a15K3qeiG4+K0B0KhTKKdcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794101078;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SYjgRjtW9Qav1EH5oVbNUvJ1CA9oZPCmwexLBTNZ64I=;
	b=yWTbUARQTXSSy07HlwmNxaiQuR0GB6SQoNxGuaJluORfW2Yv25Xo6JVSqIqaMlbfd92W
	 tcWZ3PvP7QC08w1i3J+6jdW2wV2HpiRwjZzbbctTdHelnHBqCbsjH3i24dmr4OPqJAyo0
	 +uG6nA5aunELnaEJcutFtC3Af118F1BGCRPzSXAWb37hCridCFX4V5p2YULJpYMg0nEsq
	 lbqPcpJ2IEqGbOuQc031LAWsMyajQiIWyPv3wWDiwSEX+hKibYI1u69UUpLLh5DaxLa6P
	 m53jlq9/xXoj01my88Hr0tdDyG95xpWNPPmpk0UtjTM951m7Trq9MUOvaUEZuZKnbtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xrpA9UK1;
	arc=none smtp.remote-ip=74.125.224.47
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B514606A326
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 01:24:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B514606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xrpA9UK1
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-67921b515a7so118061d50.2
        for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 17:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794101077; x=1794705877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SYjgRjtW9Qav1EH5oVbNUvJ1CA9oZPCmwexLBTNZ64I=;
        b=xrpA9UK1zoi4+OXnLCbxyeyPi48LYOI1qmrxTs/0bfT3Utq8U37ueTxdjXQWAy2sl+
         Xfp2EF2fJvD8t5n9c4iEEXaTLocDl8UhAKSW6iFaRINv5DGXnC7mM7efyLD/vy7VtMDy
         Y5G0t3o0ErBQL/q/ya2cVPVxjRdmp2SOraDn+fZxW3W0wllY+gRQcpa+aPXcgX222O8K
         weYrIvW5cm5LKLP8L0rKBgBRi3kSqd2AxLyf1Sytisc1WYSgXA7hyevGVUBlH8k9/paU
         rOoDiVvs4dPdAy8BZG+GmImYxNNzBhdkRckZ0GJAh7ZhEq0M5LpaurxnBoYsjK/8s1P7
         4EgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794101077; x=1794705877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SYjgRjtW9Qav1EH5oVbNUvJ1CA9oZPCmwexLBTNZ64I=;
        b=I/v+xND8sqj5eMBJdMX3GH9SXdrEzZmMw2A9jVwjLME9zlVoUQZEH8nc7gKYnnCW1F
         gTWYOwXoHcfyQHpIL1IIj8RWInN3eP3vPUhU+BF18LuuTRm2vaXRokAjHunLQOGSORji
         E5Xdeg7hq2DkBm35chtZRyi0uq23XVOM5fHZG+mnkKbqOLTfCg3R2bjPNsm1iks6x2IG
         j3vvSFszENYjQuuVQ8ZQqjJtdgkjLnSjq2xYuklShIWZ3PL0J5wIkrSiD0OCeXHzbpTK
         n0VvgKE7MbfGV7piqSM6SQx59YbGobrJ9MEIvbgHqW4m28BEdExF0Jef10dELHTrFtF+
         3QQw==
X-Gm-Message-State: APuU4Z91UzJ1VxKsmJOaBIQE8/+THvl2w61+RxMLCVYlVEwE5QHoYenU
	FuBM4bkA+J051C281/dXqO6WKMKJrFkd/ONoLOwgxPsjvCTHMj3ORWrkBO6d5Q==
X-Gm-Gg: AYBFou1nhiwzgZetqzvn76f8yTwa+vwASl9zNPLWp6zteP4FMVH4VXGZH4GY78GEpbX
	yQ1QVutrw53ZR4Rlc26kU4ivOtCbWYGs1051Y4KLcyA20UKcWOE5XjLjTBGrm5xkS3ZnxYyNcI+
	5N8j5hUqqLsIOYCOK+srEs6Lgb86UqbrzKdeA03yq5WYAb8ae0RPlkRmbgJpMAUewWB3INZDbVu
	xNFhNd0Vc/86IDUXptRgNZEgokZy/RAWzUhB78mxdmqOIJufaWlnVjpmhgbcBAukQDV9IGybJKt
	AqT5+fC5VCm8Zfgm5IRPr01yQCXyt+Y4skrZwhIKtJtQ0uBNoCWgWPM+X+tweouXHbaoHkxxOJi
	gxjZ8x16qBxkxWzoGevuDju44Ix/qsqjhBw9pGtNustXCDH2krZvvfqayagRQLAothMLilJyDAD
	ePXKSPyF3OcZacP1IFYychSwKsFsdJ0LHZqKldyid4GEFgtD0GwMPF1TSbSoaa045nNxM7dPVt3
	6fFvlEWXzebqkUTc+8hBgn43lDaNPEJu5vmPVxtHmCFR+qkHZBjmH56qQs47torwCEf52gzjmLZ
	H+UXPdP3YFgyE5SUVH3s8+lEF35FICCISkuy
X-Received: by 2002:a05:690c:16:b0:8b0:e238:271b with SMTP id 00721157ae682-8b36c8d7c5fmr2915587b3.2.1794101077533;
        Sat, 07 Nov 2026 17:24:37 -0800 (PST)
Received: from diego.local ([186.151.96.233])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b36bb86036sm4910457b3.18.2026.11.07.17.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 17:24:36 -0800 (PST)
From: Diego Rivera <diego.rivera.cr@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	cem@kernel.org,
	djwong@kernel.org,
	Diego Rivera <diego.rivera.cr@gmail.com>
Subject: [PATCH xfsdump 1/2] xfsrestore: don't assume single-digit dump levels in dump labels
Date: Sat,  7 Nov 2026 19:24:08 -0600
Message-ID: <20261108012410.3156325-2-diego.rivera.cr@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108012410.3156325-1-diego.rivera.cr@gmail.com>
References: <20261108012410.3156325-1-diego.rivera.cr@gmail.com>
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

display_dump_label() renders the dump level by adding it to '0' and
asserts that the level is below 10. The media header carries the
level as an int32_t, so the assert is the only thing tying xfsrestore
to single-digit levels: on a build without NDEBUG it aborts on any
dump whose level is 10 or more, and with NDEBUG it prints a
punctuation character instead of the level.

Format the level as a decimal number instead. The translatable
message is left untouched so existing translations keep working.

Drafted with an AI coding assistant (Claude); details in the cover
letter of the posting.

Signed-off-by: Diego Rivera <diego.rivera.cr@gmail.com>
---
 restore/content.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 7ec3a4d..963aa7f 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -9425,15 +9425,14 @@ display_dump_label(bool_t lockpr,
 		    content_inode_hdr_t *scrhdrp)
 {
 	char dateline[28];
-	char level_string[2];
+	char level_string[12];
 	char dump_string_uuid[UUID_STR_LEN + 1];
 	char media_string_uuid[UUID_STR_LEN + 1];
 	char fs_string_uuid[UUID_STR_LEN + 1];
 
 	assert(scrhdrp->cih_level >= 0);
-	assert(scrhdrp->cih_level < 10);
-	level_string[0] = (char)('0' + (u_char_t)scrhdrp->cih_level);
-	level_string[1] = 0;
+	snprintf(level_string, sizeof(level_string), "%u",
+		 (uint)scrhdrp->cih_level);
 
 	uuid_unparse(grhdrp->gh_dumpid, dump_string_uuid);
 	uuid_unparse(mrhdrp->mh_mediaid, media_string_uuid);
-- 
2.43.0

