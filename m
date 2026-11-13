Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559667;
	b=MGOJGwMPmM0TkdVIIuH/aN8GSLVbjypPsVP/AxnbpE5QfEzLp8OUqjKX1zoZ35O2xBP6
	 lDu/YL/AI2INdXsfHYPJYDslAGrcU29q6K3SWVJQ+bwNYjC1nwqPvuYKvRD5n3MV/IBw/
	 vf9YLhgJkqNtmjdN/7G5B0AEycTmwRRuWDR6n7LUm3gCOvRE4TJ+JazRh5/HW+pIw7u9O
	 7Dw1J5Hg8QxJAc9QcldFSCMI+p0DjU7SIybp+ZQMuyD3qhdSp5mw546jst9NGKwh1v0uB
	 hyjDjUPbRwERalF+0zwvo7Ix6n8SS/NMIg2Xsu5kju0jshU09JqVE6yPOgiqkAiM+TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559667;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=R5pClmcvNdfyu0yDUjBBxSnZhWmhQniuii9cSdjpx5Q=;
	b=k681dKfON1LSrRkPct5ypkR4Uwlt9vxl+InvQurcUgak7btbUbgGZUufIaVHO33qcg0L
	 OEue5TYYH8q025vJxnVrXMnHpcCGXlgES3T5RGkBTw9M7MSu2f7cc2zwwaSybAit8atwE
	 xjyVj+/5IKd/mqHharWf7cP7899AJcrolIkfHbQUyMz95rw/iqHFce7Bq1XTtzSaNqcCG
	 EP+YzxX4RdI92deEfz/fZ0L86X74h+OvzQoIczZ/l9nyWWNFMA2LF1mHSrUTBmdGva+f3
	 JepDHMocI3GAOWE285Rq44TbOXgjLqclyrY9QeTixTzKY2qmtRqEJf2vOuKmCqq/GQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jqSQbH0f;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PhtA2KXB;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jqSQbH0f;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PhtA2KXB;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3355560A5BFE;
	Fri, 13 Nov 2026 08:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3355560A5BFE
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jqSQbH0f;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PhtA2KXB;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jqSQbH0f;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PhtA2KXB
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BFDEA22230;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5pClmcvNdfyu0yDUjBBxSnZhWmhQniuii9cSdjpx5Q=;
	b=jqSQbH0fpCXYDAteJUgbVaJpFSu0PAUGhqgduAERCh2zNPp2ifSpqAh0H+yOQbkQxSpTZ9
	h1rMNSf74d6nzirOe25iFF4Qte8G93pMvLU11efDN6N9tbCcxwkcLplD6P7V+X3D+xdAo9
	NAV81DZTiz/UHH00iqsGCi6+vDxhbhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5pClmcvNdfyu0yDUjBBxSnZhWmhQniuii9cSdjpx5Q=;
	b=PhtA2KXB8DyJBexVlUA+7xn+dLW2M1uubaDeuwF3awIT/GZUShNI1CwscTHJpteZvjMrrW
	Jf8o3LTT8Q6Zm/Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5pClmcvNdfyu0yDUjBBxSnZhWmhQniuii9cSdjpx5Q=;
	b=jqSQbH0fpCXYDAteJUgbVaJpFSu0PAUGhqgduAERCh2zNPp2ifSpqAh0H+yOQbkQxSpTZ9
	h1rMNSf74d6nzirOe25iFF4Qte8G93pMvLU11efDN6N9tbCcxwkcLplD6P7V+X3D+xdAo9
	NAV81DZTiz/UHH00iqsGCi6+vDxhbhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5pClmcvNdfyu0yDUjBBxSnZhWmhQniuii9cSdjpx5Q=;
	b=PhtA2KXB8DyJBexVlUA+7xn+dLW2M1uubaDeuwF3awIT/GZUShNI1CwscTHJpteZvjMrrW
	Jf8o3LTT8Q6Zm/Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58AEC13757;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x4teC6/O9mqjFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 08:47:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 5A6A722C3E; Fri, 13 Nov 2026 09:47:42 +0100 (CET)
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
Date: Fri, 13 Nov 2026 09:47:11 +0100
Message-ID: <20261113084700.739002-24-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261113083336.15152-1-jack@suse.cz>
References: <20261113083336.15152-1-jack@suse.cz>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=880; i=jack@suse.cz; h=from:subject; bh=DBSQd7khKM/TlZ0WUlpF06P53Fk7cmyzlW/ebF8k3uI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq9s6MnGCO+YkECJ9xRUc7lgoyWIT8yIhoQnJaq hIbcWwPEd2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCavbOjAAKCRCcnaoHP2RA 2VBRB/9M4bGMndIaWHAl8DKTt+n1hViPNb+Z7ST+qQYfTNtU6P5cAu2VYvasFaDqQgx2dFHBhDq ltzKGtNCAit2UJhikNX3Vn41DYvZZQZZu2rasNqncr9CL7LrBA0K3pFLPN1wzby2TfBF7/GFjQ4 iOarvT8MT52lWNp77EM5s7yyRBoh5zZzoG6kx/LR4+VDw0c8GUaPxqmvj/9qU4q4ddxywFnO8WQ xN8PSmfWswKQwXbU5rrLccuOye05H6sJOsckC094RRH5n7WQ9qc7OOLNdVB8s0XXPeXPoa4YDWk o1skWYTlAAewSPSsL2HYHeBxAk3r2sK+IBNZgZiQToE/ffFz
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLyaw51ggmke6bkcxeyajg5whq)];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.80

The check for dirtiness in wait_for_concurrent_writes() is racy because
I_DIRTY_PAGES flag can be temporarily cleared by
__writeback_single_inode(). Use inode_or_folios_dirty() helper to avoid
that. This also makes sure inode timestamps properly persisted when
lazytime is enabled.

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

