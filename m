Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CDD2E7F3A
	for <linux-xfs@vger.kernel.org>; Sun, 28 Jun 2026 09:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782640122; cv=none; b=iWOLyOHcjgi0Qkj1MZhgtLQDp1A/axU6uyhKStpPPGcikDDyPAtHwZD881FAujtgU2Avc8FjH0byxRUpany3VCx3iI8BN9uX7pAXsUlww8QjmuqhyJ29sgkbO8+eBsehaFvVdfVfTtuK+cA3LyeMb5g1VAfnPu46wTizCDWyad8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782640122; c=relaxed/simple;
	bh=WQcQ7QnDNpj6b+N54Y8A71HMVtVxhAxt2cuaVLwotzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V3dWSBlY7DKBkUwgC3ebjTvmw1gOsCUtLJmzHuVsXy20nrppZ6HB4RXrYFwgn3Ed77hxSfD0FvcJ9W2t5xIuFWP6BJrYWnikirvwCLMYp/gxb6IP+snsNNh/NeTOwbKyhMz4XenvJS4P+UJa74SLNkACWS8QYY+oxNClW6xX3Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjRe0WOa; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjRe0WOa"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8000e21f014so26557377b3.2
        for <linux-xfs@vger.kernel.org>; Sun, 28 Jun 2026 02:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782640120; x=1783244920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BSJ5wyzaVD0AAbYArY5bvFALJrFls1U2rKAskILea1s=;
        b=jjRe0WOaiPoAW5lpM9LhyziJECRmQCk/Q/n15gN4aweH2esiZweNP2FGwv4bQa0O5d
         cMQm4CrAlLKN2idt68P5skze6G1RtSaD/uvVllMq67+is7ipFketd0iJZcSeivrzvl6C
         uG5VAni+1ij27pqmK8FYb+mj3OKDL2vEV8XZXc+SnzsSguCwT9sOKoYfns3Oa9ijhiuu
         WzucI/DEXUK60X7MBEO6iNvj83m+8m61SYu9wUANNj5ftEspXH0wYs/PkcVD5nbbcNAr
         uJM6RBpTkMEmvuAx6Wb4l/hQaBJxlCvr9FNnO6BPIXtc/gyimV6RAve6H6d+F9Y5rAG7
         zDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782640120; x=1783244920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BSJ5wyzaVD0AAbYArY5bvFALJrFls1U2rKAskILea1s=;
        b=KVdJb2p1/i95qhAAtTH/b9aVYtC+LCsqzqwtM3TSUFhnuMO5/9eC11TnxytUl1aqpH
         tILL5VivoSV8J4/Mj9nKxY1BhJbFL1YBHvw8/rcmvD47v/AeUeb19RESH7pKaExfdQzA
         gg+g3svFa/df6qbYZcttVY89KnRGhs+hdREA49C4ot8RgK9ozywae5RhwJB6/P+Mqb2s
         GjSL3uE6znljJLUmmMWDJeGV4mOnmdZ4Dj6W3cCKOjkfgoTqHD364RNmRbWEpVkNt9tg
         xmd80/fMkKcfLLZf9M1QuCbsvr20/v/BvLV3BMv22cNhNkAFr465GxbHALDD7K4CgHo1
         rXww==
X-Gm-Message-State: AOJu0Yy+lsYdZNSBp0UY3PtRw7Vaa/IGIbLzTuaW8YteWgB0LFvmy/4+
	y3w6XREeubRaeIF9wy+087DKwgxPGDlIJtu+BnxfWHFOSI5ieoFJXGyH
X-Gm-Gg: AfdE7cmyzXKo0ifzle/3xh/BlpECRTCuZj4vRJxgXu2Cd8XzLWNZLl++uB6gByrUNOZ
	ae4RHnhSBZbuFDnAd6YjwiBLQQENmIe5+6fb2GXj0bjye6JNCXUvWaEMRsPKc8gh0gJlZzj8xam
	IR8vnJb6GWmXhYQrZews98M4URjim76XvDDhTJf1eQVjBQTptnykfVEM5nV3immoKVoG96sU4LS
	HEzInbKHocdAjj8XT4WEa8f1ciqCfB2zbMzgrbtMZ+vXPYIvyD95ldrYMX9e12bxwz2sdhhMSWi
	fzFA8dhjs2Nne6jZSZmptjUqWTQ6S5bVLs4rqN7SFu8F/m/po7s0qW0JnWJuThcc/IsGJa8TiUU
	dfi+p17uqGtz1stFwTx3no3GI5B/v7cqwplzijVmjYht43te2s0DJF65YrNIcfNYthGFfhJoysD
	5tG5zMtlvv9hKqqKL0J7qmz62Icg==
X-Received: by 2002:a05:690c:c6c7:b0:80a:a034:17c5 with SMTP id 00721157ae682-80aa0343466mr102014457b3.53.1782640120184;
        Sun, 28 Jun 2026 02:48:40 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-80c211137bdsm24277057b3.12.2026.06.28.02.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 02:48:39 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] xfs: zero newly allocated btree root space
Date: Sun, 28 Jun 2026 11:47:48 +0200
Message-ID: <20260628094748.46578-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_broot_realloc() preserves the existing in-inode btree root while
growing its allocation, but leaves the added bytes uninitialized. The
inode log formatter copies if_broot_bytes bytes into the journal, so those
bytes reach the log record and its CRC calculation before every location
has necessarily been overwritten by btree updates.

Clear the newly allocated tail immediately after a successful growth to
keep stale heap contents out of the filesystem log.

Fixes: 6c1c55ac3c05 ("xfs: refactor the inode fork memory allocation functions")
Reported-by: syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=97f2c05378c5d68dcb8c
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 606a36526ce2..0d81c78f5afe 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -398,6 +398,8 @@ xfs_broot_realloc(
 	struct xfs_ifork	*ifp,
 	size_t			new_size)
 {
+	size_t			old_size = ifp->if_broot_bytes;
+
 	/* No size change?  No action needed. */
 	if (new_size == ifp->if_broot_bytes)
 		return ifp->if_broot;
@@ -430,6 +432,7 @@ xfs_broot_realloc(
 	 */
 	ifp->if_broot = krealloc(ifp->if_broot, new_size,
 			GFP_KERNEL | __GFP_NOFAIL);
+	memset((char *)ifp->if_broot + old_size, 0, new_size - old_size);
 	ifp->if_broot_bytes = new_size;
 	return ifp->if_broot;
 }
-- 
2.54.0

