Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135393;
	b=ITMxWZ+FMC1s4MTFk+Th8kl0dSGNdW2WHYDlqbZXdX3X/JUtyymXHUilF4GIB1hvD/qX
	 2PqBqDDg5l743meDwqPluxvR8UGp5Wz14NpIupVimCi0qxi6jTaWZFDj481lClsJg/0+P
	 IUaAOD2BgShvWEt9RCioxciMjLiejDJb1ywF6Fq4PGN5a3+cQn7KJxiZ1C9Q8c5rgmW72
	 DCnlGLtFRheBUIznl2U8Nv9WpNGl9SHATLJ0lcUU3kVXnGddCN6c8gVI2rH6rfXehHhbX
	 VaOrDmvgtpYhT9vuephJ6SECIraU/rZbDgzP0floHBSCKfly5eg/wg3XM3HfH21hG2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
	b=5n8E+d7L9y55gEb8wk3o82D+IiwRVC9+Fm6uwlu5QjG/0Oa6L5Nh6s7KeAPhujF73Z9u
	 HWGlLlI9gVi29636J61cyF7DyRrcv6x/5whRbOMMgFmDHnWEUwLDaQCp47Rp7XSrxCdUD
	 4Y1beRJzp8XLu4EodvatyTxkxjeanLG9HujAKVQkWsLpPTCRHbfjDpu5da/h6oD0U5C0j
	 YjKq+TwJ98vnAaNc+zmQ4+8vlDvYu1A2sWoYazhCl7sh7E+m4BZG6OgsTn2vI2xzaZ2oJ
	 rNkquP6o96BXo/39emD1nrDEkbHLdGDiQV7lkrjTqgOf0KxsAH6lbf4HK2J4Rrgvlkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hOU79HFU;
	arc=none smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF89A606A338
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF89A606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hOU79HFU
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5361e313e63so4391561cf.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135392; x=1793740192; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
        b=hOU79HFUF5XVQIP1i0LutIU/umJRpfeIAGlIU85PQ+VvN8AhJ2xV/+Ckj7hUn0FiXT
         Vo7Bqt5A2O7gVi2FXZ7LR1GJBkC3682be/KrfbJUx3Oze79iZ02cF+nWdL8HAMH+TkA/
         RqJRdc529Hs/8A6MizbL1tlCPDHiaNo4rAfVeS4PCd+pYvNB8GiE3hhXUKHhQVK+xtN8
         JXcziCJ3xyZB8L1d8uSyg8o8tM/93MhtFnhO+nATDdlG/gpAAJwbl8XdWTjLI3geZAFt
         Fqe9NEA86+d0c+71frtm+HrDiotx5CzEsaAF6tQp+yTnBApEwLxl6fqpDPD3/OU7RekT
         j33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135392; x=1793740192;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
        b=jqxgklBvZZFCZs/FEaMCnRuNyyFtBSRlCz5r6Q53JVAeOVRoc0VJbRuHtdA6hFdM0z
         UZivojKCCE+UBuc4MXLZ38G9kR3udU/ovc18PEeStoAE3cBrrOUQcW8+cx45pcSk/G/m
         lBMYkHMi9uGFVdOJPIAkQ2UDF7wCj+mFKRecokxJn3hX30rPqkmcmeHkUtd5Rdu7byFu
         pwP2nbDextC+ZPE/DhYzhRAr8PvacmYGKb/zOYvvzPUfBxLGJA1HxgcJO1ab9awogrHk
         XZF9QC3Qvl3PzqxESE4i84gYsl+UmY9BCz7ohh3aTygokJGF97HBn7Y/wYB04tEffWG2
         MHmA==
X-Forwarded-Encrypted: i=1; AKwUvByhgK1QWESNbEAT/6AjoESYxa1Zg75CHAIZQ9Wyup7Asn5D25snWWkONLCtppmrOxcuJ5XNQJPslIQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYK552G3x3+ZYBcrOt3iBxWnZtS0ZcR3gXBa7NCE/ok3fcCEZzcX
	PPUIrGfRLjOt9T3/7WFMHskXkpXSt5yyMQyBNAh0SXeoGL4z5TnZ0pMnhKPlSj6xcv4=
X-Gm-Gg: AYBFou0iatwta/Q6kwXqdbm4xyyW0fFKxcCXlX1xwKbi7JbSjqsG6XpbzjnCsVcprU6
	d7b4VQqYgmR3Qoi4wq+6HFmSXJPSG6OD2GL4yuO6Lp9cLKib+vPEFIr0XtQN1iHQhPGKj5g+/aY
	ts4IlH2hiHZ2gqXbhuMcUiZgfzZ/WLoTwm0u7UACQqNm7BM9rV2pIuDAeDj8sD8FnXJEf34PKni
	ZE+l47/d9feB+Odvnx0L5j9IS7pqq64qs3cKWfCJ++cCfDMjERK8gzAoP551t8z9l/HlyPWj6PL
	0QnuX9yiK0CEVqmZg5fdb5Viz+AxER25dmAmmZHoxf26o9Q4Q/w4gOaI5VRO9LAfwirs3c+odrv
	m3K/smp0R40r3Y9JVL3J6QcVUEREtaNghVOyWDIBRue/+4Mnpx8h7Vrtbp1V/8OUWbdwH3pQow5
	HM81GF+NJqgqvKHntE4foQeo63FdYgNaQ7HnvI3dbQ8oBgMSWCo+kYFbX3S2BYBDPPu3qNLesY1
	KptVTACx3VrJDCoLgM7R7Be/y5ra4LUyYL7QX7W3IToprZ8amZRSy1SPSAbn2xpcZ4nBhkVvS/w
	qdGsbCmjx0oVWk2PDA==
X-Received: by 2002:a05:622a:8887:b0:535:92a6:22f2 with SMTP id d75a77b69052e-53fcb20dfd5mr9618051cf.15.1793135391683;
        Tue, 27 Oct 2026 14:09:51 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c565esm88811961cf.6.2026.10.27.14.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:51 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:30 +0000
Subject: [PATCH 04/10] btrfs: set SB_I_OVL_USE_SYNC_FS
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-4-802e512379a6@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=741;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=KS+Jdp4IcUSZ6tCav8kl7acTQpMUNvtXOKDv7b4wQHs=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJlIHMWE4mD9Fg4D+/nCw/fqbncWcTX25kEPMy8XebnWW9mJFVsO6uNMHNrIavR2Gh6YLS/9QxQ
 cP8BX8zQgBQ0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

Metadata is changed in a transaction, and btrfs_sync_fs() waits for the
ordered extents and commits it.  There is no ->write_inode().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7fabb775d4e3..cdecf90bdae0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -981,7 +981,7 @@ static int btrfs_fill_super(struct super_block *sb,
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
-	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;
 
 	ret = super_setup_bdi(sb);
 	if (ret) {

-- 
2.55.0

