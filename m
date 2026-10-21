Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792616444;
	b=Z7EEMJ2d6i17Vaqe30VT1UzbW6TMrG8AwODJ46QCrSAMSkcncXpWmJwlo1+8Z4udM2LN
	 NnCZFqIXMueGNeWAVNDBHQ1yuTd0aeY1xAXqClI979bOw8osUotsbmN2/4RZBuw25cAyt
	 f4VErI8HBBW947Gy5YANaZyiMfa3QVRSCdcdrhy188NNYAirn51zYHP0uAaXLChxQHTgr
	 m7S65nwNOuQtjW80DwHcQ4euvvYhSM9vD9iRpDhMetzP0p6OSTCt6iChkN9PkPoX4dVeK
	 YlZb7xvMh2cM/oTJezdp86I3ZxGNkcLwmPc3QsvgqC4NEpRwYbYf8SzI8Xk+O9jb0Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792616444;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:From:To:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=EIUQVmsNe9MtoPSjnH+7hUxaJzQdq03zlcuLDy+dbjE=;
	b=zJXezOfLeVpB3tlyv8MFbwGCalY/tDEOVxws8gzZsCWlBp1VZdNeZYvvtRkTKu6H0EO5
	 HYG3wMwOVF7alTXJVoK4aKLK9El9Wn28xD04TSVjPeZFOzJLdiX6uw77YWAaf4OyArIUR
	 axhzJUNz8tkkzO4ZyAKdi1aLUv1ccMxLIUIWw12G7KQSar0L+RKUZQ/ShWuRWKfN8Hpr7
	 r3woJYCgG7jTlbuZJR5t6QQ/ay0C4UVIxOB72dvqe6qBHtX2Lc/aDpbyGnQL8Pz/Kf0Pn
	 oLTVxqpOJLxeCISX3XvnOuFzoBf3nZRIzu1bEdUIou+yvL1vAr4MUYYWl0Zwgl9RP+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ks+8Zu64;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ks+8Zu64;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE7A606A319
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 21:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DE7A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ks+8Zu64;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ks+8Zu64
Received: from kunlun.suse.cz (unknown [IPv6:2a07:de40:b306:2000::2])
	by smtp-out2.suse.de (Postfix) with ESMTP id 0B00D1F812
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 21:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792616442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EIUQVmsNe9MtoPSjnH+7hUxaJzQdq03zlcuLDy+dbjE=;
	b=Ks+8Zu64P3jRHEs9goVSQNN8Wy2EBTc/8d0oQuPr+EY6/tR7uRtl08GXgAwawIMVee/LsB
	rMGpn1Yb5SIoYNXB0p+TOeiGiXrML8NDzCtQ6CG+68lvXpJVg579hI41WZdt7KRjotGxWe
	1/WVs3V63pSmQFI8D56QJBYE8m3RGXk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Ks+8Zu64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792616442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EIUQVmsNe9MtoPSjnH+7hUxaJzQdq03zlcuLDy+dbjE=;
	b=Ks+8Zu64P3jRHEs9goVSQNN8Wy2EBTc/8d0oQuPr+EY6/tR7uRtl08GXgAwawIMVee/LsB
	rMGpn1Yb5SIoYNXB0p+TOeiGiXrML8NDzCtQ6CG+68lvXpJVg579hI41WZdt7KRjotGxWe
	1/WVs3V63pSmQFI8D56QJBYE8m3RGXk=
From: Anthony Iliopoulos <ailiop@suse.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: skip iunlock with empty iolock flags in xfs_file_dio_write_aligned
Date: Wed, 21 Oct 2026 23:00:32 +0200
Message-ID: <20261021210032.14001-1-ailiop@suse.com>
X-Mailer: git-send-email 2.56.0
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
X-Rspamd-Queue-Id: 0B00D1F812
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.84 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_SPAM_SHORT(2.94)[0.979];
	HFILTER_HOSTNAME_UNKNOWN(2.50)[];
	ONCE_RECEIVED(1.20)[];
	RDNS_NONE(1.00)[];
	HFILTER_HELO_IP_A(1.00)[kunlun.suse.cz];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-0.96)[-0.962];
	R_MISSING_CHARSET(0.50)[];
	HFILTER_HELO_NORES_A_OR_MX(0.30)[kunlun.suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DIRECT_TO_MX(0.00)[git-send-email 2.56.0];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b306:2000::2:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,kunlun.suse.cz:helo];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_ZERO(0.00)[0]
X-Spam-Score: -2.84

When using RWF_NOWAIT, xfs_file_write_checks may fail to acquire an
exclusive lock upgrade and return -EAGAIN for aligned DIO, setting
iolock to 0.

In XFS_DEBUG kernels, passing no lock flags to xfs_iunlock triggers an
assertion failure. Fix this by unlocking the iolock only when there are
any flags set.

Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 fs/xfs/xfs_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7d0c8a197575..1eab6dbb4c5f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -766,7 +766,8 @@ xfs_file_dio_write_aligned(
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, ops, dops, dio_flags, ac, 0);
 out_unlock:
-	xfs_iunlock(ip, iolock);
+	if (iolock)
+		xfs_iunlock(ip, iolock);
 	return ret;
 }
 
-- 
2.56.0

