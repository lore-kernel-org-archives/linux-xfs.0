Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014001;
	b=kbSdgxWbTCbqagHh/Rp+H3HP6CTFbkEMBl11Q/VMmCR9j0g344q1lg7+oX0f2dyzWRGr
	 60JDyMMbrZHk561o2+QnYTI8uqwk4OUXJhBkuXd03Zwf3SjWsoTZNzuZhsHn6xSohuJbm
	 6RodMCb/zX42/XrL54cwtlFpz5Z7PlCuRne3Jnwqyh3PHm9jnEVmAL3oWdZNa1yE1KJKD
	 XWDaSXCTBTu9QW8aKeQwpgDJU649cqrv5bm1qZd0L1F62N1dNsygOEYo9VSLSVS6p/tKs
	 JKsiZrO3QZtjkEub45eB+jGU64uC8DZOcBIe5bZPOCRxr9+kTssQBo5h2swLTpx8CZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014001;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=liX9DvuWM1bnvV9hQsSoBI0H+CbWc3KB+ndlNO6K5fLDrj1tWrZcmWhCSLKL3RW34IhP
	 HJhZRGOIhhg4+D7dT8sOAQszu9FTZXz16exVpBctgbyg9MPxMMwWhH0yLxRdsxk++ee5w
	 r5k4y+SCl/6bIjFB1H1C2fGGcvtx1IpDD1N+rN3ubiw1SXLIDMTPULi4aZrXg52ofBfb5
	 BYVia03X+EzE0ntyYr0C1sC04wot9REvZj44NQqMcfEfDr+orkZjvA53RxmEVVcUd3cEX
	 Kr1GH5TLictVAOKHn3Be8yQLtmJLTJ4glFXY43xs/EDrOL0CZXym6U+rAoKqTIhzozg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RHrpy4UY;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fD7DZZZf;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RHrpy4UY;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fD7DZZZf;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAA660A260B;
	Wed, 18 Nov 2026 15:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDAA660A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RHrpy4UY;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fD7DZZZf;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RHrpy4UY;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fD7DZZZf
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 310992233E;
	Wed, 18 Nov 2026 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=RHrpy4UYmhCSCcxgCAziLaHa1dFcb2+GQ2RKi5ZceI1pgh5K2KnH3L7QeR+qP17+3cdaHa
	rhkHfpVQ9IxeG1KlgTaPnqK19lZ0CyiKOCf2ZJeBJefDbpRzjXAFY6BRAqAcpvSfNjsXXi
	lWMgblsmqGEtvopV3eQTvT98/5At6q0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=fD7DZZZfLWx5PdDJZzUxXM2RPjnGGvUSg7+35xvI6bEQmbec8VekCwKK9lPkWlrQ7Tl8EL
	w5krZvJC7M8NaPCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=RHrpy4UYmhCSCcxgCAziLaHa1dFcb2+GQ2RKi5ZceI1pgh5K2KnH3L7QeR+qP17+3cdaHa
	rhkHfpVQ9IxeG1KlgTaPnqK19lZ0CyiKOCf2ZJeBJefDbpRzjXAFY6BRAqAcpvSfNjsXXi
	lWMgblsmqGEtvopV3eQTvT98/5At6q0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=fD7DZZZfLWx5PdDJZzUxXM2RPjnGGvUSg7+35xvI6bEQmbec8VekCwKK9lPkWlrQ7Tl8EL
	w5krZvJC7M8NaPCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02A0213510;
	Wed, 18 Nov 2026 14:59:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CfzsM269/WqoXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:59 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 11912250A3; Wed, 18 Nov 2026 15:59:54 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	gfs2@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	devel@lists.orangefs.org,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev,
	<linux-block@vger.kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-fscrypt@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 11/13] nfsd: Use inode_or_folios_dirty() for dirtiness check in wait_for_concurrent_writes()
Date: Wed, 18 Nov 2026 15:59:45 +0100
Message-ID: <20261118145941.1063127-24-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116171044.6938-1-jack@suse.cz>
References: <20261116171044.6938-1-jack@suse.cz>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=967; i=jack@suse.cz; h=from:subject; bh=cYIvrjsiNKxiZPqGAovv6JqrD7CM1UBMeWeAmEJiYA8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1lvYiDz5CLiR+xnAcc3/FsOEmPn/Lc1PIWm Wad05vv352JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29ZQAKCRCcnaoHP2RA 2VFmCADN6lAZL2vQ/NB6yoJFFTLIVtGFyXpWDyuOnrQ4irHeYl106VCymLs7eX5AlP5xwdJ7wmF KBurewdfdkMtbUz+pM/6sU1xkImYsVHxmkjBLGEJruSo5+yxFaDFZcGKrlIfx3HS4SwNF8mHZl1 5mcPzrw5Ixdjov2157XF1bSKFITG/EHanMt3D1YzByyEP+yPgdlPiNH116RNXyg9KzWqWvm1kwM og9KaH2TtgaCmELgSkIX8dAmjVnn3snMZ6F1wcnBkssbLTUlHGNZrRBp9QCJXLb6mToV+QcZlf0 Hxw9jRGHSBlcuhpaKkFllcBrAnv7z3pBZ1Wh8LrTP1FnuYHy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLyaw51ggmke6bkcxeyajg5whq)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -15.80

The check for dirtiness in wait_for_concurrent_writes() is racy because
I_DIRTY_PAGES flag can be temporarily cleared by
__writeback_single_inode(). Use inode_or_folios_dirty() helper to avoid
that. This also makes sure inode timestamps properly persisted when
lazytime is enabled.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/nfsd/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 56c49b5bc5bb..a314ca39272f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1249,7 +1249,7 @@ static int wait_for_concurrent_writes(struct file *file)
 		dprintk("nfsd: write resume %d\n", task_pid_nr(current));
 	}
 
-	if (inode_state_read_once(inode) & I_DIRTY) {
+	if (inode_or_folios_dirty(inode)) {
 		dprintk("nfsd: write sync %d\n", task_pid_nr(current));
 		err = vfs_fsync(file, 0);
 	}
-- 
2.53.0

