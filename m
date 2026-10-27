Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135389;
	b=48C6V71nJMqCZal8nkfGtCbIsLytijmePoXPZ+BDk4Zv+hAfgjUms8WBy4gcpfUeFy12
	 R/lG1NY8wC0Emo594sHpFTwgI6yXvhJKD5T+B7cA2wKGMzCjXskH+MueOKLts48ys737I
	 54s+Wz1mFiU+84xOzN3MzjpQ9FQ16GhbU3MjI8Sf170lYMkC1gcAHykxMuKMsfXIAlsn2
	 5R35db+CKeP8hKtJhNLeMonwYeflbZs2oW/lTyMQhSoAKgpQaQwb9belE/YTb9nNaEmtm
	 k/tpGOOyJ8TrihwIp9ohgZDEXlXmvuXOUJfIDrzqwhGZNqeI20azHcbMRDsBFIPwUGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
	b=CpfK7mMdMBSvHdfzn0EboUM6AK9/nPHv4aPv2238DGP0GIuqf+Lg1qXcRuvhB4GtTJPO
	 PWmRGoD9Te1hzxdtChqBmHZRu9FEmGsJPhXeFCMz1wCnhqUH4ArR/GU7+ribWnCaxq3kD
	 5Y5Skz/u2lnlmzlHnnJH0yMjR3jfmPoABp9oxoX9e3GKZmbCOSM7lQGPlbDuIlkHb1Nh2
	 e+NBI121u5W6rEEEvjDd3mwdeINK/rPLQQhl+e1zUw42l4BGv28jn3OQj5Ts9q3oqJHw1
	 gkKvRCPnqjqGwFOH2sP+6R5JIwQR1FOPrgKyq6VOkcS1sqDki/4qCuwINEKQA6U8EQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n6hOQTUU;
	arc=none smtp.remote-ip=209.85.219.53
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA5C606A327
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FA5C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n6hOQTUU
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91b55859245so4818206d6.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135388; x=1793740188; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
        b=n6hOQTUUqngfoaAVe+wP7OipaQREpIZUTmr+9ABQ9A+RccYPbJ0xQON28EvRuyVBqt
         r9HM2iZE5cGg3PPNbG9WI93phORSXncFRdrjqv+ei/9HVJWZHrloHKm4dVwJcpKUsKIZ
         1pKz0CoBUEo0w1+Bv4ggVwqXdAraxzEKTXRBNPzZwya47RBli+DIhmUMFp4Ur5xfJGEB
         DVacZ4aD4hdYD/qdT08/V59jlYOFpWLjCJ5MJCxwT0+od31pmaugcsv9ZAAyt0DtpK6/
         FP7MKuzv8SSpxsigqar6AIaK6iqcvukWr6ltLO/guLJuuQgKnfFpDgSU6h1AfRjjYQvv
         B6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135388; x=1793740188;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
        b=yg2T2E7KNkLATgpes7CYpDPD2CTyyuonMKgFVVrgwW6z3X4J1mPun8cwnn+Q+Djl3y
         yPoqeeywmebr0TcdyyHe88sGhSbQI7f91sanuLunfuW3sEBmx9jrpEZQySXHKoJeK8nA
         wNGdDd65osWOp+SY+DB0aCukZ+giQKE4niPZ4BRXYqZM+Yh1xld0vKXAu7ztJvGosym1
         9lmOyqQSQgqAlqzH5ICqoLx5cezNTnlUsx5mwdaQ+uY1jvjTYXpZ+HxANzSEFM3x1MsA
         ARSM9WBWIQE1cQfFI9emv9PQpDqR9WSCS73jsmGD6cEEc+rCiqZnkVu4yo2ipValmX6e
         WkRA==
X-Forwarded-Encrypted: i=1; AKwUvBwa7ddGvf/VSoeHs7akyV/8CLrrhEY97k1Aym6eBYh2y3kkT6iII/ysqT0l1TOEZOIPGDaj6gS0uLc=@vger.kernel.org
X-Gm-Message-State: AFq9FYKrIwr2BVuEMIIHafU2xLlPpN6A1MFqf61PooaBwxp00Dy+A/Nv
	JNK5ozWHqKHylqTP4zOuFZ1ihfk0CXlQaRjGx9ri7Iun484bFVyDEJyvDZPxDZApXD4=
X-Gm-Gg: AYBFou3u7noiQ/8DNMrPJwr13QA8Vx2+6MSMcYwV7g4X30yKrLVAKb1mr9W957FYL7O
	B1t8fQeoFfa36jTZCYR9lP/7/m0BibZXtOvpsnamly6oYXR3tjxS9tOn2oMjDx8JVhzZffgD8vv
	29IINV62AaLJEpmc5h/tSNLXFcVG9WbRfjzNxBK/COy/wyfVN99eRUTTasWZax1XABjSQ2T49x2
	tmD1l52ilroR0lYUBqAowp+yEhhK6khNIF/bb9+OXpFfEi+9Sk/CazaBLob1CoLjVdEX8n1IDvw
	uE7WsqSCgxacxK0gEDBzr4U/C/LAlmim4RoF7+q51+ZZlmeq83Xmg1Gfvy57aA0Rr4KeuUadNwG
	vEqZS+/cG+FBH4BRpKFyaDTBKg7Nb53mtNIuxW6wDzPlvGm9LlAAMqbXJ24PgwfCqVW2imzz3pi
	PXH3zw7wJ3Q/tYxUCbYJWy3Ic7ioKtWQugeQQM936ZbK82n6HPd6p/Z3CwZwAANWITy/4T3gmy4
	GdoIO63ZvEw92pfSVHt5fnFZG7NelCoMnloMbKjntSbTuxjBuQw0wnGIENiCZG84sOe0A+P
X-Received: by 2002:a05:6214:8611:b0:91c:772d:fd7d with SMTP id 6a1803df08f44-91c7cf8f9b1mr5253166d6.26.1793135388396;
        Tue, 27 Oct 2026 14:09:48 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c8c2b3sm113364796d6.31.2026.10.27.14.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:47 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:28 +0000
Subject: [PATCH 02/10] ext4: set SB_I_OVL_USE_SYNC_FS if there is a journal
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ovl-containerized-sync-v1-2-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=855;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=aO8AZhSXBs2aP15NSjU103SL3h8/eCNuFcd5jsKb2vQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLYucfR36lRP85t2sKZ2ZLaJ9rWkQsjCap0MbdXMa/mnYx1Aa41Uw40CeY2ykt+WukwlWz8EyZD
 bupKVdGj8SQg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With a journal every change of metadata is part of a transaction, and
ext4_sync_fs() commits the running one.  ext4_write_inode() has nothing to
add to that, it only forces a commit as well.

Without a journal the flag stays clear.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ace06b4f9e3..037e274dca8a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5542,6 +5542,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		err = ext4_load_and_init_journal(sb, es, ctx);
 		if (err)
 			goto failed_mount3a;
+		sb->s_iflags |= SB_I_OVL_USE_SYNC_FS;
 		if (bdev_read_only(sb->s_bdev))
 		    needs_recovery = 0;
 	} else if (test_opt(sb, NOLOAD) && !sb_rdonly(sb) &&

-- 
2.55.0

