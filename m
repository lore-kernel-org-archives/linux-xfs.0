Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107893;
	b=nZDSsyGbhjBYOlEq+u1FeVHTPdsyv/7k2XEuRz2ZKVa/1oQIQ8kN727gjFmkimqxCxXU
	 rF4yE7vAcyL88A3ht6tSbKJW6gAH1b71SIggeWB+VuD7UWY5X/484WDzxGF2vYJOLuWK4
	 4RAWKJ1Y9wUUMiQmmb2AnDdE0kn6+aBn11KkRWl4+8KZNoJFM1DjnOtpI2dsa7NWA0mvk
	 64bZr5VTvxDZugWDzWEnJpXkOUs66cZIDdS+8V2kWeffz5/dJ0GraeinsTIbHWo8PIaer
	 oU1jaER/wxI7QhZGGY3P2VC+Pq8qbSLx+5ejQOaI/m4xORPmOHLqc0kvDdOFX7oFLnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=9YrcN3VTHuAzKVwTFah/n0lO5UTQ+5t8mWxnZHt8ueo=;
	b=u6J4n5+8Oocjxj6ow4ytPPiV0ijGx7W/tnhgzFFtmUca05aX0ClgvSlXGnS6/t0scDfc
	 +vMitd4DZrLJG1XM3iVob/E8RhGbZ7VUyv3pYGu7K3NSx0xxJabAotXdO2pyib4qn8o7A
	 8ywYEwmSBnuNLTIa8recLzVrYPwJYpV4fkunXsLH9YD4cUNUkE4FrOWImikC3zTa8xYNL
	 /ERdOYdP9D1W499xFta1wdSx5oofWm1GVaz776c1/lctQoCG2MbNvHjjFt9Vlj97R9qRK
	 yoWPrjdDtFSYElb5bdpYnOQMJs4bhkUdrc9JKzpo8ZS3C6TIpdVqO1lU3yHEhofjm5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="HO9/WGTz";
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE1560A3826
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 17:04:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DE1560A3826
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HO9/WGTz
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-383435e46f9so1390136eec.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 09:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795107893; x=1795712693; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9YrcN3VTHuAzKVwTFah/n0lO5UTQ+5t8mWxnZHt8ueo=;
        b=HO9/WGTzKBzVAS4R2l3j9A1ZAr/EEt32hh83fjRUiplNAChVV+gzvU4e3EgLBrphnt
         /lVlHa8QP9HalvvWzuyZF1EEYWWXtTFqISiCu/3zplAPrft3CVHGjcMJt59dVrdvnxn6
         gldp6z87WwOOsRyJbwgQ7ugon34ZtV+cA1rEoeMvkI1zMeyaoeOub3E5HsBTqyk0LcyI
         cCWBRDI/JG/FWS+yFxwTh2/f/Hd+axOlqbh+XRbhNmeK3du0yiOTGVuuTl5GZyhlIuqu
         ypf0ORff+TwGa9Hh9mBEoGbbVUMLa31YeJbC4pOxarKIZWeBjJUnJnTb6HZPYDZ6bRqV
         FHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107893; x=1795712693;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9YrcN3VTHuAzKVwTFah/n0lO5UTQ+5t8mWxnZHt8ueo=;
        b=r2r33a94MPnFe1rqZ+XAC6kpiq5Bb367fiZjU2TjHDKyZsbzHPSEvgBKtP/gDtyFgr
         lEH7tCSVWsvD3A9QpUfLvMcY1EKQVob1OpIs3wHxsWdZnXp3tIj3gQibgxfrykU7tMBj
         /GutfihD/E9mE0ViKw24Vd/uXLmfOFqYPQIOmwNKUuXhYhnN9vm4YRrWwkVLGQX9ShXc
         I3FcMPfZ9jzHu5EeWjtqDfuoUrgy7NJ29sROpU0TkpKpY7nlXpZrXWpp1C2Iez8Pwr/i
         l3WCaHQUosqTGswYecUnjoJiSBvTBqlPD6Lw7UEzocKhHBzJy/NubtmcLP6JRED8ihvG
         qk1A==
X-Gm-Message-State: APuU4Z8q1Lkvdkl607Ahao1+WDRYg66LYGlUBfcRS4g4EFjonRURT9p1
	PLkdZxw7V3o9zIP9R1QmVVSk1IEmpdHn3NVyPZQY37w6a9zga+AD42pQjVb75UXlClsYHRIX+rC
	g+1bg9QrWqg==
X-Received: from dycns21.prod.google.com ([2002:a05:7300:f795:b0:382:8cee:3808])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:881b:10b0:384:24d9:526b
 with SMTP id 5a478bee46e88-38424d953afmr2634367eec.26.1795107892359; Thu, 19
 Nov 2026 09:04:52 -0800 (PST)
Date: Thu, 19 Nov 2026 09:04:49 -0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170449.1513687-1-irogers@google.com>
Subject: [PATCH] xfs: initialize error in xfs_getfsmap_rtdev_rtbitmap()
From: Ian Rogers <irogers@google.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

When xfs_getfsmap_rtdev_rtbitmap() was converted to iterate over realtime
groups with xfs_rtgroup_next_range(), 'error' was left uninitialized. If a
continuation or range-bounded FS_IOC_GETFSMAP query has start_rgno >
end_rgno (for example when keys[0].fmr_physical + keys[0].fmr_length lies
in a higher realtime group than keys[1].fmr_physical while both remain
below eofs), the while loop executes zero iterations and returns the
uninitialized stack variable 'error' directly to userspace as the ioctl()
return value.

Initialize 'error' to 0, matching xfs_getfsmap_rtdev_rmapbt().

Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
-Wconditional-uninitialized enabled; fix and changelog drafted with an AI
coding assistant. Build-tested with LLVM=1 W=1 and
-Wconditional-uninitialized; not runtime-tested on a live XFS realtime
filesystem.

Fixes: e3088ae2dcae ("xfs: move RT bitmap and summary information to the rtgroup")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 fs/xfs/xfs_fsmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 041bb2105ec6..3ccf3ce23332 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -760,7 +760,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 	xfs_rgnumber_t			start_rgno, end_rgno;
 	struct xfs_rtgroup		*rtg = NULL;
 	uint64_t			eofs;
-	int				error;
+	int				error = 0;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 	if (keys[0].fmr_physical >= eofs)
-- 
2.56.1.708.g77570a6a1d-goog

