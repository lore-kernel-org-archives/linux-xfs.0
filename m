Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550489;
	b=2JGZMdwy4sK5mv56w9YIsNe00Cmn4921RcP5NWN5WYF5x4KGLYfFKZWH4cyt1sMvJOZX
	 jDyQHCfNX5vbZet5BmQTcntfAO/ThLS/hKwPhMfi6acPvszaxHx7WAqP2kUDoBYR/Pgy+
	 3MnzZth371/Qgmp8qbbHCFEonCxXI1umna4tJW4VhcU+7MPT7AdbH96WGnXrWWtcJMSAK
	 2imeQUc9vBu3ckSr/LorRsH3SZFPE6ncZaR9NwmvIsRGbXSUZvAxATw9ebgviGcTzpA3V
	 tnjQZIA4fL36Nw8yxamMFVsyGyXPhEWciSglQzDfu+sCjoxssvBvFTmoFPeI+tMqdEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550489;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wIpnfgpc4gGxLz5ffG2Ck3h942TA0ba9U7z4T9K70SQ=;
	b=Q9D4k1MY7pQt2YU5/FK5f+W4ex3sR+wA9Faa1Fub1vORFqRE6vxaEMTG1+bI/hvDpck5
	 9EN+QAxdoPxE7hxzfcKq/L4pKNXCO+M+eE8OlyIjXI0j43mos0vKucNZJy1T4WgOuU1h7
	 sjwX1ZQe2nYZ0n+iBo28fUdYp4hgF1tBBqK96rZt8GKhXhePRd4fnYdMaCqM6nV1Wy1RZ
	 kJX6dNKnvCC7q+OeYQL6NpZi33VwkFe6gEQreQeXNrhpC7GsPzFW4H8WpuPrsALYcIwla
	 9xteviysIgND98M9C7/MlfIpJi+NGAuPnTfrmAOkorUkNBxjscrYZSgPF+6dU0GGrog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qH+tNuWr;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D246606A32D
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D246606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qH+tNuWr
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so19087325e9.0
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550488; x=1794155288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wIpnfgpc4gGxLz5ffG2Ck3h942TA0ba9U7z4T9K70SQ=;
        b=qH+tNuWra6mXJrpTdiphco1DHSRkDz6/+gbV4TOEjyvcZiq4w1zfKCT/KRaZWjQ4r2
         RLJlBSE/tR1MfzupOOz185OyIf2Mb+fpg9scHbGYWVK6CmxIxUwGszuyPVs6MLaaGcEM
         tFLlvSYaJN/48SRIvyZeWoMO9OtJkJOqreBfjn1qxRMpR7f5tvz+BMGl9pGHXi5RWJTx
         N7Lzyw1uLBiTDXAwRmfe8iwCPCw33ni4rnLIuo/C9isFzFqsG0A1WEFaEeuS6NbBPWiA
         Jm+Z/bwzXJAElRMA8mD3eX0IQ4I1RiavBxFb0u9SjzGWIfuydfMJqbfhUN9wFEm6wQ7d
         vIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550488; x=1794155288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wIpnfgpc4gGxLz5ffG2Ck3h942TA0ba9U7z4T9K70SQ=;
        b=pAD2XYcQDZHft58ilinGkMms/YBAYUYL3qmk+803qY8RvYWhSGqVyl/4+LEg5EP0pf
         J9RYCj/zMkk5qNLIhUDqr0e+C63TkpUlEToRuL1izPha7BnUcQqmPwE0hiyD1nNWnOXb
         0WydXMf5yaIxWNai8muGB4bMgBhqLw6II3goAetsII8icgbyp5CiPkFbj5mxIfvjAZOp
         9X8Hz/rJ3G7L/uLp/CX5zz3wkD18xtDyOgChunZV5d2NZdcUupn0eIrWV721cERN5cYW
         nCuYJ1Qy8XDrKz7CNlEtNxQhHNxiapW0/WWXyd7n27K9bTI0VtGJ20rArA02OzYfXqRn
         bj1w==
X-Gm-Message-State: AFq9FYJAHm/guA1urzReuP8xGLMoO+IgXfqwd2dZHvQHLk5tjiNQXc9q
	q74w2huAdDFxpzERKV/j0GyfE5tc39d0EM3mHJ0cci9VeEF9mCl2ZGeVdYIu
X-Gm-Gg: AYBFou0g/Kj50i81Wakj6vFUZ8n0YIMwqDPcUP0uhOoFuHMMIhcJ1EAHU3N4rs76L8o
	gndDfHeq3nwUuH6dFw8jTqC3Ih9E/hCQEgdwNMR+w0XRW1BF2RFbjSL8ONrQt42Bf6CEUS0qQLu
	A/AHrsN4bwBSND98CR+pBqRm3D9sg4Y9dC8NwjJz5BzGEVuJV+Fl8xm/akEApaEi/Uyw6VeM3QV
	W18Ueiv6XeyWXuJKxJCiAHGW3O7OLz2e2chsZSMKQeI2l2e1InGRnufsc3hUxbqhdtImKVXT57N
	Uobp7F0NPd9g6drFnpFYStteiAoY1nwiH89WzXtWocqZgE6+oMWuDrG4ubnEsfvB7v+FJK+XYtk
	5aJyE9DGrfqDZ9hHztTEh4HXgpFVHshcoWcgKYZsOX5vmTeJXeRAhQScSd1jrtuG6vAHNzFOzOs
	LXbTa14LNJCSBdmklxOqguV7xQn8K47KU6mOPaeYlgRBiuUeG+87OyZRsWovLgpKSCBxDyL/b/a
	h4CNnBcIv6Om/2bfPytgZFslawApTZR4piKBDJOHC2v2xRaqKd4pAj7Z0vsei0DdA1Fz46D1M9H
	Uvaf7WM2zppc
X-Received: by 2002:a05:600c:4e02:b0:4a1:e6a9:4086 with SMTP id 5b1f17b1804b1-4ac1228b10amr191274755e9.0.1793550487885;
        Sun, 01 Nov 2026 08:28:07 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf0b36853sm192023245e9.0.2026.11.01.08.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:28:07 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsprogs 3/5] repair: cap extent record count at physical fork capacity
Date: Sun,  1 Nov 2026 16:28:01 +0000
Message-ID: <20261101162804.1444159-4-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101162804.1444159-1-tristan@talencesecurity.com>
References: <20261101162804.1444159-1-tristan@talencesecurity.com>
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

process_exinode() uses the on-disk di_nextents count as the loop
bound for iterating extent records, capped only at the format
maximum (2^31 or 2^48 for large extent counts) rather than the
physical inode fork size.  A corrupt inode with an inflated
di_nextents causes reads past the inode fork buffer.

Add a check against XFS_DFORK_MAXEXT(), which computes the actual
number of extent records that fit in the fork, consistent with the
fork size validation already done in the btree-format path in
process_btinode().

Apply the same cap in the prefetch path (pf_read_exinode), which
passes xfs_dfork_data_extents() directly to pf_read_bmbt_reclist()
without any fork size validation.

Found by code audit.

Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 repair/dinode.c   | 5 +++++
 repair/prefetch.c | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 243fcf7a..2240720a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1529,6 +1529,11 @@ process_exinode(
 	if (numrecs > max_numrecs)
 		numrecs = *nex;

+	/* Also cap at the physical fork capacity to avoid reading past
+	 * the inode fork buffer when on-disk nextents is corrupt. */
+	if (numrecs > XFS_DFORK_MAXEXT(dip, mp, whichfork))
+		numrecs = XFS_DFORK_MAXEXT(dip, mp, whichfork);
+
 	/*
 	 * XXX - if we were going to fix up the btree record,
 	 * we'd do it right here.  For now, if there's a problem,
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 3e03ae7f..df0e8be5 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -393,7 +393,8 @@ pf_read_exinode(
 	struct xfs_dinode	*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			xfs_dfork_data_extents(dino));
+			min(xfs_dfork_data_extents(dino),
+			    XFS_DFORK_MAXEXT(dino, mp, XFS_DATA_FORK)));
 }

 static void
--
2.53.0

