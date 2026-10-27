Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135391;
	b=N3m/kVSCA5PMc0RzIYhUaRGDD0z5/wWEhUZnrXIHI9IgELlkUMcxfGCX7crJz54f9GAN
	 XbznZXekirOIa1XImGc/uDNOdLfDYGw+50HtObKxMJN7oy6aH2p2ajBkhMxXjy8dvLIUs
	 b0UoDWgouboh1j4C+iLMKam3DRqmE09XIgZ6KBTRhhqxGuGCyJRi8kjI8PxDUuaeDTgSC
	 nPAFmBJTQIK5+eoX7TbglPpYwhIhJ8sPXIB/WVF91Asiju5sHwFlN/iY0iKkEtchhPSMK
	 7o9ut6V9m+IixZH2jwpMNxG8l60X5u3aCbS9tlTERv4Kp5H01W/z7VGgmJcnagVp/eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
	b=P6vmLALaqJ1aDLOmMFDGqYLl7lng+NItkFYolNP/Au6rSfp5YKn3zytD6rmu48kGT72J
	 sZpoMt3nACCyliIjQ1Tfn2hsKM2Yqy2w9jXEFcciLqus7bgaArctNMrFme39HAJhCIcQn
	 wyh4nnquRvkh18BQ55kldkMpCoBknRdFLZdF1isZiILJLB4bJXD3JEzrGoo58ZvHDOjwS
	 6M2m1bVtuNCCEVJMgFwAq2M06ujcr8SDtuDX48HpxTK8h4T9zR4TuBRorfskfCnhvNnei
	 e6k0Oqjjs5ZcQ+tjCLajPg6nFueCN36SOQySMZM2nFJYNuCYnLmmAbNQ0oW7V10GQng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=WnvvvdTc;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC32360A260E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC32360A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=WnvvvdTc
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53644b28706so5962471cf.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135390; x=1793740190; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
        b=WnvvvdTc7G1nfaWX/xZKKnrICsgfAqeL0R9qFWLgI1Lu6RxgO3Y0j6JpA78kzWjYYF
         KyHoApYnqdtPpwWqfZAw1ZHZJU+FOrbBiHwQmZ71f/p1rv0nSKVSrveRfhtfsUqhDK77
         whvi1LUz+/OAAEmIQmJJBuXgJAoalPNrMrCHO8ICLrteLjaaazmRhnuZZB8693EsvC0P
         aFtcYWZhs+cUyb6MfKJ7TpwPzncqeXWQlaRPzHPMlLHVg9VuV/+ATMzV6LYkGnffpwU0
         nteEG1kjc7zbUoS7e89EOLrDTDoYhaVC660ZHf2WhRhQ+FzhUdOwf98TItMqyoculpUQ
         Q7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135390; x=1793740190;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
        b=pTVc8Qb7097uBVlMIlsjanh7Ci3F59RtIlLV+qJYuP/qxDbCmXviBIo2dEL13v0C9p
         MeVfuCsO/XS8F6xwuKifTNn+8jckGdlkCmlVAvvA9W3d0V/wEwHliavhCem5+GgU7y2G
         iQJK+4SaNJ1IdfxxQRuQQudTm69C2/MHf4ticLtbLVoN2Xuiq2bY14Bop1yPIQ0XtU2U
         717oPKhMn0vToE42AYhowMwwpWcorpPE2iuLkuxaRzUDFItYknuXbEiO30CVzK116QWp
         oUCyq1qECvIwlJkjXcsz5Qi/yloeZuWnm4J//vTEZt+cBIlcYAtpU+zILn0u1pZL/lzD
         sG5g==
X-Forwarded-Encrypted: i=1; AKwUvBxKp/rQiRycvRgjn6EhZRNgtVa5j63mfeZQUrbAJf4DPGYmsJhaLMmYzoqaGai21V6Czk+J0ht/ucg=@vger.kernel.org
X-Gm-Message-State: AFq9FYK4S4MhPWg8ILcEOEkODK4padxKRHULL+OfyI79yBjBW38DUvuQ
	oxdTqy/5MHv4CJmjFRXhuggB/M6bw2zsb0V3zHdb68oBhqFgFpoxBmg6TELsB2b7YYE=
X-Gm-Gg: AYBFou2BvabPwFnK7lJPdNYUNzK3XceJHp0mGLgJdGGxnCpnao5OgNxlDoxOnwG87lx
	AsqRVNu9tGVkkC3Cl1qWGe1JewGFsje4mtJiD4V9dkWbEj5EmqL7YPpsFvNRk+h19wSLdzz7uh4
	swdbeNlOdxkVS9khbRod9z02cRfnGO/QCNC33F00aFX32JcxzN2SbQ9IWELJ2EjaoMMDb2WDdKg
	t/efNt9xZueSIA/xTKi3pMAbqsCGXpyx3Xphys6Zm3r0neVVkvpI2lmnheBWwYRg76ZKhDPhlmF
	V7P9gRbAGWfa7VV3gGgU+D791STpGwPhMTguIl6P5L9m6uyLxa5PGBiqu2VGecHdLwrR0pS50wX
	JStzdvCQFVscuxz+SMwKftXS0qNpZXc5cVp+0ZxWBc231FPVLMTZ7TPv/Jn7h6f8LDpTUoIS2bN
	fCm+p179A/0ox2Om6LBZTNu2RNXMAvuLCiF9CcxYXDMkPPpOeAgKYR15tDRXqbAKAma/CCyEvRK
	3vUkfqj2hFSYCKOkTYGmlR2rtJ7hHIaH6CR7kyNxz5QqD3F0GmBGGCeauGb4xDwh2JMwAQao5UA
	WnELr/B0MpXEKtRqww==
X-Received: by 2002:a05:622a:8b08:b0:535:d7e:dbe with SMTP id d75a77b69052e-53fcbee4226mr9184971cf.12.1793135390022;
        Tue, 27 Oct 2026 14:09:50 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53838cf2dbfsm88162341cf.2.2026.10.27.14.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:49 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:29 +0000
Subject: [PATCH 03/10] xfs: set SB_I_OVL_USE_SYNC_FS
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-3-802e512379a6@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=709;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=1Z5502S4N9+PxpDJ24MamzJyZyNagTbtfNLwpblShXA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDJutvjNlSBU/eOcQ9wQNaWwYhbQ0y1uFYtQSeQkyDonWymvy92FRNAyiqlerkJRJJxNhvaXRz7
 8R+gU7AP+DQw=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

All metadata is logged, xfs_fs_sync_fs() forces the log, and there is no
->write_inode().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..2f09d48b7e6f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1924,7 +1924,7 @@ xfs_fs_fill_super(
 		sb->s_time_max = XFS_LEGACY_TIME_MAX;
 	}
 	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
-	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;
 
 	set_posix_acl_flag(sb);
 

-- 
2.55.0

