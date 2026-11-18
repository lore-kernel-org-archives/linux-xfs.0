Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014002;
	b=KV+qU+p8ViiQ2MXNLEBmMqYEc3K6lQj1035duxklGmUpkCPYg9BX+Om9n5P0/lwBfYTR
	 t+L5d0G+/tkY0aCZcZXWoNyqgGnm6XcHp2E0jHLLQLaEqLzYakgvUl6IS4JZeM8wkTHjf
	 2f4wAUEM4UBTuNmAim/XkcY+/FsgnKWddmuW9qmXftMtA1qEw0tSJwQpQQmwSeYQVV/OK
	 7mxGx78Si5N2hzWBbNJZD7kXcrPUYtv07WHmZk6Vr0hs65IQ4YztY6w0lp2MPPYaQwyZB
	 OJ0ldMKnVp/2DLNwpK8xKluYenOfKH7j4B73Gw8I383tyPMZNtTTFOIgIK/8ikDQUlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014002;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=4kMyiBnHKkK/yo3t92quHidOpgsHUSIMAfVvVlnZuV49yFTmdbMK+feqj9Exjsf2KFk6
	 NeSvX4bW6a2VDpMe1i3Dap7HUwZ+/lej2UL0otDBmf4aDEZMpVR6uby3DIM5Ha5I3FLAD
	 GukbWQdJi1P3vOpd5RCeQdf1b0LGrOOS6kaF9+950GRV9HXdmCkgZZo1CDzc20Cwd0THa
	 Fwz6tZETsJhD12WU3cbrM9fEJc1fGertwuIB8Y2esYcnE2EM/P7xtBrKRoURp3EP8l/iv
	 S8BB7bv3EWs1UvpvY9dYGTa+G5tiNcWtJi1NqTV2ZtLr3kohc71p5CmuRA3KBEC5AYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Rpf4+yf8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+3KtVxTS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Rpf4+yf8;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+3KtVxTS;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB5760A2606;
	Wed, 18 Nov 2026 15:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCB5760A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Rpf4+yf8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+3KtVxTS;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Rpf4+yf8;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+3KtVxTS
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4851922329;
	Wed, 18 Nov 2026 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=Rpf4+yf8Xzq96VmTPUbjTqOD0TiS9H+nnxbtI2D5/7RvDXF2GKAepIvDgkDFsI79xOF/LM
	K5IK+cDwvHh4TiqhSycoSYzzEwGj07/PY2fyX4+XQ8uQ3ZU9lfu7Mt0J8c3tue/ICbpvAO
	3BiY/pnrfs/Z+Nsh+g0dIEbuZTkxnYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=+3KtVxTSyZ586v5nmT4veBm7DvukttALshALlwmPZg/ZhKh57L2u+N/3LORnJzEhvAhc91
	0pjt8kAHV0O2MMBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=Rpf4+yf8Xzq96VmTPUbjTqOD0TiS9H+nnxbtI2D5/7RvDXF2GKAepIvDgkDFsI79xOF/LM
	K5IK+cDwvHh4TiqhSycoSYzzEwGj07/PY2fyX4+XQ8uQ3ZU9lfu7Mt0J8c3tue/ICbpvAO
	3BiY/pnrfs/Z+Nsh+g0dIEbuZTkxnYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=+3KtVxTSyZ586v5nmT4veBm7DvukttALshALlwmPZg/ZhKh57L2u+N/3LORnJzEhvAhc91
	0pjt8kAHV0O2MMBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23D47134F6;
	Wed, 18 Nov 2026 14:59:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZfZvOW69/WqtXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:59 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 18167250A5; Wed, 18 Nov 2026 15:59:54 +0100 (CET)
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
Subject: [PATCH 12/13] fscrypt: Use inode_or_folios_dirty() instead of explicit state check
Date: Wed, 18 Nov 2026 15:59:46 +0100
Message-ID: <20261118145941.1063127-25-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=719; i=jack@suse.cz; h=from:subject; bh=FMLwmEIo3Jn+kxzPFnZc8LhNnipFkY3Bc7bC/iC2Ncw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1meJphD0clnEX4nMNjKhoUbG1H4Fuqr/Knz VDsqwpscFqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29ZgAKCRCcnaoHP2RA 2R3NCACAyvCj9DoG6inqymtSUfWz/WGEsFbk/4OEr4FdYk6zptycBqyE7qgsYaVrkEvNBdHU9co xxrB4CZG4gsTuVXVacCev7xxTFa18ix7inxtQu1HHw07VO4X89l5vEcYLbiDBwFZLPykufU0905 ChUSrWuVkmctHVWviZHffgD8G12jqQeu2FICXa4WhRrcYWiCf4MesUKs1tOMB6aMEjEPp4rMm4A eP3E6mi1aH6ftoGp1ywn/dvR8ODZrFZ1lEQSzvkC7Q/NLquFF73qj/5aZnFF7zZiwcic1cmD8o3 ZSKB/MNmLGmszr7alV0/kYfu+jkE2L6RrewBi4ZH5jlmKQFb
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLyaw51ggmke6bkcxeyajg5whq)];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -15.80
X-Spam-Level: 
X-Spam-Flag: NO

Use inode_or_folios_dirty() helper instead of explicit inode state
check. No functional change.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/crypto/keysetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index a77b889d7578..1cd40663b251 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -839,7 +839,7 @@ int fscrypt_drop_inode(struct inode *inode)
 	 * userspace is still using the files, inodes can be dirtied between
 	 * then and now.  We mustn't lose any writes, so skip dirty inodes here.
 	 */
-	if (inode_state_read(inode) & I_DIRTY_ALL)
+	if (inode_or_folios_dirty(inode))
 		return 0;
 
 	/*
-- 
2.53.0

