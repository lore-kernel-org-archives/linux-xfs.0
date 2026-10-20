Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792526696;
	b=Xw4C5EWq5rx/PEhJqD9pTeuPelFsecrw6obT/Urzqhu7z+bYKE08itNpF3liCgbHTkaG
	 xrqChBN1zS6ewAXsVanuXZQ/Op2/fkOCcpOh8quYAna6JbyzrVUPcLMLPrzURsoHMJQJe
	 m1NUJPfO9ERw4y8JkkviNFGsvAmKqBqgfLjuJPTH7UkWahpHlSu9mpnBaDmqWzo7Qladw
	 DfyXAvvFuswhdB+JesgAcWJvt4XLddWLzPhua18QqL4s96dPrXkhl6DUJpe/0MYv3qvFB
	 oKuyeqpg74VuOUANXEIHMT22CZ9VJWt17mA7JxflxkERwM+TTEKgPCb6Yf51Wf6ysdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792526696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xMZTvVnvR9FWtNNDaBKX050k2N0y/5tjvvOdwrkPXQ4=;
	b=2Ej15EIcgPCldQfH9Kv/79Ic1Nt2pjkaCwfQhxacJmQq/uNPuQvkZppX4DQxAcOtNG61
	 6MC9nAXwrODocyjdeG9/2d0HVdBBTckbv2ZRN9tfAEBU0LiWBlEifmDd+X4d0gof7fsh2
	 zckkF0NQ8FUFT2wsd6ZDvw+Q+TIZrh5ILWityzhLyNtjTf7sTAS8SqEglqLQOS6X/abSQ
	 yE/K3VN9LpAC7GMNm2TVBYVG/deP//eOzNkFuKmXEqqA9RjWZRm9PHA5LOwUuTC8PA17E
	 EUcSF6r0h6hwSceEJm8R4V4vKN5ndPO0gJrLKphpqhPu/Qqb+MsHXkwDq8UqjwXoAOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="B8NJI9S/";
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4615606A319
	for <linux-xfs@vger.kernel.org>; Tue, 20 Oct 2026 20:04:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4615606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=B8NJI9S/
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so27418895e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Oct 2026 13:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792526694; x=1793131494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xMZTvVnvR9FWtNNDaBKX050k2N0y/5tjvvOdwrkPXQ4=;
        b=B8NJI9S/eyruMrE5iJnI28LVu3YcRWv5BuNg9PYiDjMh60lTmTouCskW5ErpvkyeCu
         +HD0/e+/sIidcUIpKv+rBnUJsCKYSMYjoPvlCtjLS4/lDrbL6eeCkd9squSRciqznx6N
         06rmR4ADVnDzBfkubL621eFSYn2cvgyG14RTG+KR10AG1RPR8UfW6gXITMdPthPMjkCs
         0QIwM1Fy9grtqRUm43WwOhS5ObcVZBCUYGgr/IHXYAeD+NAAQ7k+HEO9d7fuEgHkBG5y
         Oo2hdQ+4dNYZRfuS9hbKpzentIbfqoTdk797DdcpFMhK/6WDh/l+6Bhg/6LbeZsMvz0H
         V3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792526694; x=1793131494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xMZTvVnvR9FWtNNDaBKX050k2N0y/5tjvvOdwrkPXQ4=;
        b=v7c0dQ9X3E6R3DT3Z5E8zcfdTYWaho4fVP/3lUOS9gOf8GSZ1E4aZov/nxlGsuP/t4
         M81gEI8Q1PKnUQkqZjFqwzZwTSmlgC7il0v5NK+jsGbV1quNpMmfJVa96MU48uY3s+nI
         VcE0L+7Y7a7KhakSdGZOs0hJ9q1hvvV+kOhvDfMrMstXFWFwnLgb03y1VzsgcCReDiRB
         POzvhnZH/lj4NyTm4WzL+IdTdUsNAJy5+db1mmmrXIjvoXMLkANl/B2gczxyrkhkmXQp
         GB9hnMURUD9+RJhjbwMN3wmPnxnTxjYxQ55MOpaMxco5ZQzzCWbeFwY2GA5fQFTUquQG
         +bXA==
X-Gm-Message-State: AFq9FYIG8BVFtS9Bf6mWGiE9CWyjkkgnOHKI+Z1uBM8h36mrJcyFyDPO
	pvgsVfOo13mhE9uFLK4s0FUWif+XBkEssIcgcwu33pVJ6L4X3az8KzST
X-Gm-Gg: AYBFou26jbPVJdkB0bvFJG9Jm/zBs3YHe6308SgE1UTJox8pwNPG/bIFZud+iC5IwZC
	DwT2XDSSkNM3MC6K+BRcj8Y7CIFzd45dmb6F87G52VujcDaEs5vLo/ZqqHrwPJJPTMKRY6tt9qd
	H/xyT+pJa3yD5wXQ+Hl8WZOO0T9SCrUH+3RjCNz0Ryj2ySQIAW8YPNrOZ7aADMOVrHfIHqgIvDw
	rdIwePzMHAoUBcRIFid9OPsYWLffVLaZYlTaOAyJzifS7tdcFqJ2GcqZhDBGzOWyuQJpyds6YN5
	Othhsd4F3WivZaRRFXf36/RNz+QSsOM2QJRIrGveqUQvmPdL7txinn1cea7OuhCeT3Gdf3AZqC9
	4zOm+j2O2EL6K2JBj7bT6tHqBsuuevX8UI2owDoWn79uV0YfUX8MitYWBt+fNjYjxrEXY6g2NCk
	BYkoiBr6vbp4rdtf1ZE50JrXFq7H8jxV+nWsfktN1+wh6eVVNR6SPYYuy6Pk8MdlGErFSlrsOx7
	gkQqedMdvlgJgY=
X-Received: by 2002:a05:600c:4e8a:b0:4a1:8961:78dd with SMTP id 5b1f17b1804b1-4a1d7616464mr263477385e9.27.1792526694104;
        Tue, 20 Oct 2026 13:04:54 -0700 (PDT)
Received: from linux.tail9b532d.ts.net ([194.9.6.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fb96bc7dsm22714845e9.15.2026.10.20.13.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:04:53 -0700 (PDT)
From: Eduard Zateev <hackerowskiy@gmail.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eduard Zateev <hackerowskiy@gmail.com>,
	syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com
Subject: [PATCH] xfs: preserve buffer item with outstanding references
Date: Tue, 20 Oct 2026 22:04:31 +0200
Message-ID: <20261020200433.3298861-1-hackerowskiy@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The buffer log item can still be referenced by the CIL after the buffer's=0D
synchronous write completes.  In this case xfs_buf_item_relse() is called=0D
from xfs_buf_ioend() with bli_refcount non-zero.  Freeing the item leaves=0D
a stale pointer in the CIL, which xlog_cil_committed() later dereferences.=
=0D
=0D
Restore the reference-count check removed by commit d2fe5c4c8d25=0D
("xfs: rearrange code in xfs_buf_item.c").  If references remain, keep=0D
the log item attached to the buffer so that its final reference release=0D
can perform cleanup.=0D
=0D
Build-tested: fs/xfs/xfs_buf_item.o (ARCH=3Darm64, W=3D1).=0D
The syzbot report does not include a reproducer, so runtime testing was=0D
not possible.=0D
=0D
Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")=0D
Reported-by: syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com=0D
Closes: https://syzbot.org/bug?extid=3D9d8e687768d0f38c1f09=0D
Assisted-by: LLM OpenAI Codex=0D
=0D
---=0D
 fs/xfs/xfs_buf_item.c | 3 ++-=0D
 1 file changed, 2 insertions(+), 1 deletion(-)=0D
=0D
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c=0D
index 1a4ef34af8d..80f0cf12825 100644=0D
--- a/fs/xfs/xfs_buf_item.c=0D
+++ b/fs/xfs/xfs_buf_item.c=0D
@@ -80,7 +80,8 @@ xfs_buf_item_relse(=0D
 	trace_xfs_buf_item_relse(bp, _RET_IP_);=0D
 =0D
 	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));=0D
-	ASSERT(atomic_read(&bip->bli_refcount) =3D=3D 0);=0D
+	if (atomic_read(&bip->bli_refcount))=0D
+		return;=0D
 =0D
 	bp->b_log_item =3D NULL;=0D
 	xfs_buf_rele(bp);=0D
=0D
Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>=0D
