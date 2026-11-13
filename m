Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559666;
	b=nGLzS31HSEIUDQO2lr424BPNUeDDJAnhKRxZGe/mTFAYqhfk9yCOCikmM2PgfNbLW/vz
	 MNSTKfVSX8znY4d6RrpKBkKKwyTuICIOb0ZN4UJ4IUvuL60cdDN8qSW2nt/kua7FEbI0o
	 bBBGJg+aZz99T072w8Lx/AvBU2jVVt41WmWvytRBxWyF9ZqqtYVpLHo9VFuF0oxIfSuSf
	 fMbcnxDSlQs65+OWTxi8RAzuBkKZNklfuz99oO3axM1CMx3wEp+TeMPm5fI/S86JJwKnJ
	 ElKbg0FntUhrA41BhCd/UZYoxPPULbr8miaqVP57S4AQhkqVjXI1lik/YELQhZZdbcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559666;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=lGaWPq2hxbSwQgkla+vq9FckM4ckPsjRDg6WmI/NWoY=;
	b=fkSKT8Jt7hFW1Tn/9H1rnZfhfZOTda7ycqSWrJLqGi/ORnzMcQ/JqPx9H7Xve49H5clR
	 pmRRivU/WCOn3b7U03w2XvmRtIpyLy1IpUPUh2oZfVLTUrXOHXXIrLHVSQOA98Xs4128p
	 KI/0PAvEM37NSYJoId+UMTfVrLcV6LtDPY0430rDrVh19OCjDQ48Bs3QMriUJhilHB4bo
	 dIaibnYyAk2qTeTZYFQfwh4SjqLJk/6oqkoCf/I77wrdc7c9AwM1Ii/8EhuOyweDuTl0r
	 B4ncb2G0HhXX2NghOlqQNp+fHmb/SCotI/q74OmZhoBMTJvm7qt33C1IaY4bpccNZ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="s/4LI/sJ";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=A8GvagWz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="s/4LI/sJ";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=A8GvagWz;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A307606C1AB;
	Fri, 13 Nov 2026 08:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A307606C1AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=s/4LI/sJ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=A8GvagWz;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=s/4LI/sJ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=A8GvagWz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 726BE2222B;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lGaWPq2hxbSwQgkla+vq9FckM4ckPsjRDg6WmI/NWoY=;
	b=s/4LI/sJykeqF5/JoXARBbe2jF6vHAQEtgyVRxewvJS45nYTeI2Ibdh+HDUKsV3Qj7jLej
	gbJMjOD8ryskNUP0XEOgj9E2RvsrSiYvmSHEzaMF7kGaVOdZpZUwxr20BPXLtgxhdVwZv/
	AnWSRbqbsqzYYOqRIM3qLewdi9hPw0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lGaWPq2hxbSwQgkla+vq9FckM4ckPsjRDg6WmI/NWoY=;
	b=A8GvagWzRK04n5F7Y024T9e7+YKhS0ETNXjEVPMbV2Zjwya9CCm5i5uMQFMiwcpng3nY6o
	WM5OFyBA6qJSigAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="s/4LI/sJ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A8GvagWz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lGaWPq2hxbSwQgkla+vq9FckM4ckPsjRDg6WmI/NWoY=;
	b=s/4LI/sJykeqF5/JoXARBbe2jF6vHAQEtgyVRxewvJS45nYTeI2Ibdh+HDUKsV3Qj7jLej
	gbJMjOD8ryskNUP0XEOgj9E2RvsrSiYvmSHEzaMF7kGaVOdZpZUwxr20BPXLtgxhdVwZv/
	AnWSRbqbsqzYYOqRIM3qLewdi9hPw0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lGaWPq2hxbSwQgkla+vq9FckM4ckPsjRDg6WmI/NWoY=;
	b=A8GvagWzRK04n5F7Y024T9e7+YKhS0ETNXjEVPMbV2Zjwya9CCm5i5uMQFMiwcpng3nY6o
	WM5OFyBA6qJSigAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F9CB134C3;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4qyzNa7O9mqTFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 08:47:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 3A84D22C34; Fri, 13 Nov 2026 09:47:42 +0100 (CET)
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
Subject: [PATCH 06/13] gfs2: Avoid racy dirtiness check in gfs2_fsync()
Date: Fri, 13 Nov 2026 09:47:06 +0100
Message-ID: <20261113084700.739002-19-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1535; i=jack@suse.cz; h=from:subject; bh=eElpIvXtB5Lou2OjNvVwNJCDbio2gBGD0nCtT4C3z2s=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq9s6IdzpCT3XQhNwBUjN5K0X5H5NFjJJ+rixt4 2v5tpzDNCOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCavbOiAAKCRCcnaoHP2RA 2c3OCADIAmHn5g4cJy3sYbTwRqObDv1XFZR7WPS2zaCpEdjgJCZINoe4ssxB9m0snsw4dlBrW9k vjBSf+Ow8oh97tYfU/BNjrqUrjtgWfZzWikjIfsaTCtCNfNP5Zc9dXbp4DbVJLHQ9THGaEMk6WN qFgBYgl4ZieoNMdHcwtRC+6KYie+9sTMzIEWZHev+/XeJWDPqlaf919seTHXdJMJFEzFYhYW9Xs hdoFK0I0Ek4B/lNNBoSGQRMWQKx2idjDgcU5ON7rWo7v76BmQZkKHQEie+l8zpKuej1kXDRjpCr e29rPqh1xA39P1hKXbO81xalEklcAbQDIQv+1tgWB3eivp/f
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RL51pwup9t9rrf6fhpcri3z6a5)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 726BE2222B

Check for I_DIRTY_PAGES state in gfs2_fsync() is racy because
__writeback_single_inode() unconditionally clears the flag and
reinstates it only later based on PAGECACHE_TAG_DIRTY tag. If
gfs2_fsync() unlocked read of i_state hits in between, it will not see
I_DIRTY_PAGES although there may be dirty folios in the mapping. Check
for PAGECACHE_TAG_DIRTY instead and use inode_is_dirty() helper for
inode metadata dirtiness check.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/file.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 1efd0679badd..9e52f1832673 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -749,7 +749,6 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 {
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
-	int sync_state = inode_state_read_once(inode) & I_DIRTY;
 	struct gfs2_glock *gl = gfs2_inode_glock(inode);
 	struct gfs2_inode *ip = GFS2_I(inode);
 	int ret = 0, ret1 = 0;
@@ -760,12 +759,9 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 			return ret1;
 	}
 
-	if (!gfs2_is_jdata(ip))
-		sync_state &= ~I_DIRTY_PAGES;
-	if (datasync)
-		sync_state &= ~I_DIRTY_SYNC;
-
-	if (sync_state) {
+	if (inode_is_dirty(inode, datasync) ||
+	    (gfs2_is_jdata(ip) && mapping_tagged(inode->i_mapping,
+						 PAGECACHE_TAG_DIRTY))) {
 		ret = sync_inode_metadata(inode, 1);
 		if (ret)
 			return ret;
-- 
2.53.0

