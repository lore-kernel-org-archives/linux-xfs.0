Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424461;
	b=FAfKOx6TFzOFjNIoCs5JsVlWDlQFblQ7CVSXKaJJNe6UtqpI73017Sf+Jlf/UyjdhjzW
	 gihfczJbAILCwbgaL0MJZ9sFasC2zFeiAGXwVIE4a4oap1gNut/POGPeQNGfUNPv3lPY1
	 NfNcpRYytX2TJvX+SkpTI+uP5t+eSdljdyD6uSA5MMAaQPXfIxwNNhN711J7cVfycbE+A
	 79prJo6R0MF8TEHADT4eww5AtYFK/F7mGV3qYcOjna+4pZ1mYVG+kaHF1OEJRHXAdL2MF
	 nlQLC96hDqPuba9qlhAPlkQ5U5PpZIaNKm2lnxymLSqrucIPDZcz+M9DM1JjJ8Qjm3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424461;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=sJOcjt+fA3f0gmiULrSdno2cFCxjWnvJ5BbzkQtHN60=;
	b=EHQ6H1RhKRTRcdd7aIujWt0JqtrFdCSHjf5BoqFbUWwVYa+Xt15uQi2Wn4Ur41aT/d9N
	 DQSkLOvvAjGmGKTb+l0TJ0hcfytLfX+SKqbOLTP6PK0EHufep5ulSN/3CF8PTCz1t5coK
	 kc64fndmSqq59tmqDf9MZs5HHH6XkH1YfSzC/JboDRxy50axunnKkCigCru+BWiUGxMI5
	 hKpJI+8NWsckjq49VC+GZy0XzQB81nIZ+bhGWG2EfZoc3h6fnuMQDVvSuDY8m7hPHZk8b
	 FPZ2dorwg0fYoBM31a2MWCB7vDF0CPPv72CYMyD6eEN70eZrO5I30wI10RmxxttFwYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eY+kUw5i;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LdZkrRDS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eY+kUw5i;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LdZkrRDS;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71351606A695;
	Mon, 23 Nov 2026 09:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71351606A695
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eY+kUw5i;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LdZkrRDS;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eY+kUw5i;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LdZkrRDS
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 887BD1F811;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJOcjt+fA3f0gmiULrSdno2cFCxjWnvJ5BbzkQtHN60=;
	b=eY+kUw5iMBdF0nW9muaBfrHB63FwLB7zUAzGE+yGXch64WiuaDTcxXq/psxAkYrWJEfyyM
	EQjfH1nl7lwUif+djfbYWKpeRn0K5Qk+3nduVPfcU7S/QKJPRpQQOI4c+Nh1zOmSFqqWfr
	0RH4KNazfyP1XSxa+wEeNrpEw/6GZGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJOcjt+fA3f0gmiULrSdno2cFCxjWnvJ5BbzkQtHN60=;
	b=LdZkrRDSnyGDngqY8ma+JqwhdH6h6dJKb5b3/kr9k9Dd+a6lkft4tRDPC4nnEbnlg6pRo1
	y4YDSSG9XhXl+1Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJOcjt+fA3f0gmiULrSdno2cFCxjWnvJ5BbzkQtHN60=;
	b=eY+kUw5iMBdF0nW9muaBfrHB63FwLB7zUAzGE+yGXch64WiuaDTcxXq/psxAkYrWJEfyyM
	EQjfH1nl7lwUif+djfbYWKpeRn0K5Qk+3nduVPfcU7S/QKJPRpQQOI4c+Nh1zOmSFqqWfr
	0RH4KNazfyP1XSxa+wEeNrpEw/6GZGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJOcjt+fA3f0gmiULrSdno2cFCxjWnvJ5BbzkQtHN60=;
	b=LdZkrRDSnyGDngqY8ma+JqwhdH6h6dJKb5b3/kr9k9Dd+a6lkft4tRDPC4nnEbnlg6pRo1
	y4YDSSG9XhXl+1Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 549011352B;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9290CcoABGvzBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:00:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7528327606; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
Subject: [PATCH v3 07/13] fuse: Use inode_is_dirty() check in fuse_evict_inode()
Date: Mon, 23 Nov 2026 10:00:42 +0100
Message-ID: <20261123090040.19006-20-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123085601.21199-1-jack@suse.cz>
References: <20261123085601.21199-1-jack@suse.cz>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=825; i=jack@suse.cz; h=from:subject; bh=/+R2RM/eaN1B9yo0gEWxhhBzGp/HXlo+uc2oxzvZkfA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBAC9wUXPrwJb6wqOYNJVZc3QJF0vToQ0BOAqp KD6ESMyUjSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAvQAKCRCcnaoHP2RA 2U5+CACIlHwgN7b53B8jv+fNkqfw8tphr1FP9l9AgZbctmviP5mU+BUYZ1prdT1QLEViojXIP/g kslgdYZ/d4pCsp6Csj/pzC7XQ97FCYdW97HJVfxfcxipiRPrU+5ENpnXmkPps+RG7PvJbcFOW71 /jbThENMKOv6t2YmU+AQabilO3OaTnRwNwOmJJnLH4hDU7qXMxQTKc0zji5227dO5/EkP1hClve BrfhRBPTfBphj/LgkFu7ai+37SAfu1nTu8166kNqW94K3Yax8O10L3VyzUdgtoOrax1ThtpJBq4 0LugjB2ELWnGy2qHJbaXHwkzKy6a7cI/UxT5Q0r6RAWdueOJ
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -15.80

Use inode_is_dirty() helper instead of explicit i_state check. This will
result in additionally warning if we have unwritten timestamp updates
when lazytime is enabled but that is actually desirable.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fuse/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1341b681d0ed..ef88ba7bf682 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -143,7 +143,7 @@ static void fuse_evict_inode(struct inode *inode)
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	/* Will write inode on close/munmap and in all other dirtiers */
-	WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);
+	WARN_ON(inode_is_dirty(inode, false));
 
 	if (IS_DAX(inode))
 		dax_break_layout_final(inode);
-- 
2.53.0

