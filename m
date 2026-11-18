Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013997;
	b=uTajaehni0miHxt4wVI5OuuW6Z43amHuA5ouwu/QRMgXgP+c1ZET7JnCV3y9nLP3xfKw
	 GZ+3iHxxjYINgW4v+n96cEIT6E1tVrz6+/O0fVXMQKzQrcmGTwIa11gOlcftvUHxOkaB4
	 Qotv7ENPr/I7CSIvyA/4uV7kqFmzOf05jn2HYj38CaloxmDX88w2n13Cpx3HUnNKdExih
	 rUBTSHy7wOdZxEYfhtKMHvBlDiJNFvQ1QPxSLajj8K+W+76pXdkmm58S60uGxOhXvkOUZ
	 U4xkxCjPJAFsXHLHCpHhIGxv7ayQNV9MQCCnqZ5Gv/EVmeFefX3Hr4HPcQsPOfpMZbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013997;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=+lM7rrM1R/XvKFJcc9D+ndKl/G6mdrWcbu/Y3hUJBMs=;
	b=Y7Fx6jfUMZnNyV6LzKjQr9kcxz2PE5IghaQGQQuArB/KUK9RufXgvR3F9laeQqG3APLj
	 vIoEnWDJMJqe4nhq4dwmR/XnmwypXeaPVu6pHu8hZsBu6V0Rek3+tlmpfknOoPoRrVjsK
	 mZZ5X8mjEEKc63Ay7RByCqYKPvoqQ0m8FrNVf+EIZsF3KKR4cWpj/PQmnL8qjWv41+K7R
	 Eu/+LycbIb4jhunJINrcLJIxcdVq+vLWJwLbMPzYEe5h/JtLBi8yJeqCIFmj00Yyzx/vm
	 k0Uw/051VIHsZEr8bMu5j9nVkeRrp9OZVgV7znPnThwm+6aEHIxv/TQcNLtVwr2/EOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zXpyvLvO;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NgLIzUVs;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ajkekK8X;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=56oJzU0i;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DBE606A32F;
	Wed, 18 Nov 2026 14:59:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4DBE606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zXpyvLvO;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NgLIzUVs;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ajkekK8X;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=56oJzU0i
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA4941F80A;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lM7rrM1R/XvKFJcc9D+ndKl/G6mdrWcbu/Y3hUJBMs=;
	b=zXpyvLvOhjmRponFEokQVzhGPCCjTFkb+Rbx/HeWa59uidfonEtv1NaTc7ZKd5kE+ql9mN
	CytjYhDMBk+91Xrj7zbr+9Yx2mM6BmGp01mqEG9Z4knuGAB9h8MYDEvC1FkzxR1qZm+/D/
	egVwq0p/Jnudkiox1zRAF43qT0wp4iI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013995;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lM7rrM1R/XvKFJcc9D+ndKl/G6mdrWcbu/Y3hUJBMs=;
	b=NgLIzUVssrU+itZrKh+QxCULgG6vaUwxOsHfOPhZGz6qja7afUDLsCdWa3bXoRMUkjhkGZ
	CVGK18AAKXc3VMBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lM7rrM1R/XvKFJcc9D+ndKl/G6mdrWcbu/Y3hUJBMs=;
	b=ajkekK8XVjfNW/NIMNcCrid+wJHsCTIOLtEOJVe6fCdiaW6j4bCPm9CbDz0Mf26eI4KiTq
	AW6uSPEfTehSlQvL6dK38TbnvLdzBTFrvwHbmEgRwpTU9KNoPRNtvoMdFodVn3MpP5jW63
	mJcpU9g7236dcIalK8gx0h5rj0B9nnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lM7rrM1R/XvKFJcc9D+ndKl/G6mdrWcbu/Y3hUJBMs=;
	b=56oJzU0iQTlw4AQMV8wyodx3lnOO8YiwBCJ8QL+gIl9Var8x0SKZeS//5iGAD1hqE95Zjd
	ObGt0mQw11YZ1uBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE40D134F6;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +FWxImq9/WqTXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id DF04225097; Wed, 18 Nov 2026 15:59:53 +0100 (CET)
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
Subject: [PATCH 05/13] jfs: Use inode_is_dirty() in jfs_fsync()
Date: Wed, 18 Nov 2026 15:59:39 +0100
Message-ID: <20261118145941.1063127-18-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1029; i=jack@suse.cz; h=from:subject; bh=G2KZ3si9+GMJBvBvY3QFhsaBCqg7CNyaNYSowoLqcTk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1gPt2KsTzOSKxicLDBJbWZv/HZqcbPOuDxg 6lnphZYGpiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29YAAKCRCcnaoHP2RA 2c1PB/90TLu2i4yZqkT9opsDwGO8hsvm6X+ho5IPQa5XmvVHuNKJ988hX7TIQtNHGzgyMexOHl7 gSkXuGDdbOhjQsRNRMILb49Hv3OhB69Zd50LRQ2SdCvyzBq7J9Ey8YlJ3wNYnhjGP4pTWWYGilr yRWHmxj+OKWJ/F/GeGUOSZhMAfMSm5/3UAk094yXESQgZxUfsOvZmGl2sevHf7jXhydW9LokbL+ a3G0Bl8s2dHX2qhWFFTUSkzC7fP6w1x0DTK/UTh+CLXzWUuLx8TZeOv2rbSh3uvTBdyn0ZCUUhN bB6Pooljy/ieoRnd3AlDIxx4/OuonRzcVQCzy91KHJNCxG+j
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -15.80

Use inode_is_dirty() helper in jfs_fsync() instead of explicit i_state
check. This slightly changes behavior in that we no longer trigger inode
commit if the inode is clean except it still has I_DIRTY_PAGES set after
data writeout but that is actually a desirable behavior because commit
is pointless if only folios are dirty.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jfs/file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 2f5bb79c0591..90001d3d90fc 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -27,8 +27,7 @@ int jfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		return rc;
 
 	inode_lock(inode);
-	if (!(inode_state_read_once(inode) & I_DIRTY_ALL) ||
-	    (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))) {
+	if (!inode_is_dirty(inode, datasync)) {
 		/* Make sure committed changes hit the disk */
 		jfs_flush_journal(JFS_SBI(inode->i_sb)->log, 1);
 		inode_unlock(inode);
-- 
2.53.0

