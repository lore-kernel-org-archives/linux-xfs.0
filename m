Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013997;
	b=xcpv71uWMpWhuJjp/zAVsqEr82iZzs9IAxKLqBfkphTNIkwHGIWX2wCHzIEtk6EMmasp
	 GazS2ANvMrGT28tu3RZN3O6yfEZWflsGqftxfwMVfJ1yAdZoDm+K0TcOW97aeRyz4w1Q/
	 yxjcKbaPxD58tFK8suPnleldhAXvEsovn5AzyY5yZo5ru+ODcdV5g7VppLIvjQFwyv7pu
	 z4y3GLQrvc2q1nhzE73kinGXURd8rnRokqucSV4rPC+6TFIzj+Uc/mlNq8aLpVCRL0Qe9
	 0yezBHpL55CbfqfAdeo9kjDp7dpmpq7hexE15smLF6aHRX04sCes83pThPlvc/neKpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013997;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=Pomk2X7btrd5iqAUKt1F/dLDEOzM35/O0Smbkacuy00=;
	b=jDlwI6Xn/S/+Zi02GQn+QqWBf1MpF5JtWTv4wGrtgvLt2TLghgYPuwqqpHldTsJoT08C
	 kyBLCexYhDHLvoYMemtkvToRn2RUbdg7bzPheEwRER5XSbl3dS0AtW6IpofhXU8YsM9Lz
	 ImdPTHZJFpqjqexd/xuiSXNv68lzw9JeWC23aatLozp90X7G3dadSafM7nCThHxJwQd+u
	 6LXK77oKWq/h8bsk/s3xgqgxQBsKJ0j/sXitRoahKYWAxeNuRp+0YvCtYFulugIl2bTJT
	 vpS7gu8x+94d+amOkSYoZrARwCR8qhwDCbtOR+z9FqtAGGxy4Nu0mBGkWY9SbSglhMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IRsQS12S;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=J4vi4DgG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IRsQS12S;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=J4vi4DgG;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B3C60A2608;
	Wed, 18 Nov 2026 14:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10B3C60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IRsQS12S;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=J4vi4DgG;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IRsQS12S;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=J4vi4DgG
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 258AE1F7C2;
	Wed, 18 Nov 2026 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pomk2X7btrd5iqAUKt1F/dLDEOzM35/O0Smbkacuy00=;
	b=IRsQS12SE4uLVHeXZ0WA5bzAxmMcxUfmhN3eqt56i5UM44l+hb9v+csDgTGJ4YjDzlm8ym
	ivuOJP9hF1x3jiCC2z+ogrDuRs97RKsT+WSJybJtKQhvSCDuHURYTRAUC2H2wdu1xQu45E
	NsxGBRSzLDYysgkC/Xzfd5BhopjRH+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013995;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pomk2X7btrd5iqAUKt1F/dLDEOzM35/O0Smbkacuy00=;
	b=J4vi4DgGdGRUcY0a7OFfVdlpxKKhEOnG516JBxoIumTWsmYpI1mhZ+5BYBQOhzdbaZEnjg
	dF80js34bdLY8yDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pomk2X7btrd5iqAUKt1F/dLDEOzM35/O0Smbkacuy00=;
	b=IRsQS12SE4uLVHeXZ0WA5bzAxmMcxUfmhN3eqt56i5UM44l+hb9v+csDgTGJ4YjDzlm8ym
	ivuOJP9hF1x3jiCC2z+ogrDuRs97RKsT+WSJybJtKQhvSCDuHURYTRAUC2H2wdu1xQu45E
	NsxGBRSzLDYysgkC/Xzfd5BhopjRH+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013995;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pomk2X7btrd5iqAUKt1F/dLDEOzM35/O0Smbkacuy00=;
	b=J4vi4DgGdGRUcY0a7OFfVdlpxKKhEOnG516JBxoIumTWsmYpI1mhZ+5BYBQOhzdbaZEnjg
	dF80js34bdLY8yDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC876134E9;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UFm3KGq9/WqZXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E5AB725099; Wed, 18 Nov 2026 15:59:53 +0100 (CET)
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
Date: Wed, 18 Nov 2026 15:59:40 +0100
Message-ID: <20261118145941.1063127-19-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1559; i=jack@suse.cz; h=from:subject; bh=wa+vohgO4tItenycZEb3QkJxJ3Iq12jSdcFcxnO6TOc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1h8UZHnt7CO/gwJbFO0OnsUh+1HyMYJU1PY yzlYeNGlA2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29YQAKCRCcnaoHP2RA 2UjqB/922XDopuQ80MSVCLKEDgbtXQ6blx57ooraPe8YbLlbDhgovGL3gl+jYhzVc9BsXZ1Q6fu Z4KbYJfrCwrw/rXacsC/fAxoksF5/xnv+QlCC0RrSXbu8H59L7WeZB13K2HusGkxUMfo+Xam9fc VV1vFSdmrJRBcwZ4zaUiQ/laG1lsNa55ACH9C93VDGy3W8Ew3q3bh2Zd1MaY9whtW5TJXkwiHcg bmkMGaazE1RHs8q1z2XAXUopNSbOtfssVxwkCBo5M922Ix76fwBKr2w1l7miWUsmClSG0ydX9Rd g/Ngu8O0PJB+7YmC4l8Wg6Qvn9cfsrDpp2SOe3UGgn86mspk
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -15.80
X-Spam-Level: 
X-Spam-Flag: NO

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
index 1efd0679badd..f5532f72ab99 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -749,7 +749,7 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 {
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
-	int sync_state = inode_state_read_once(inode) & I_DIRTY;
+	bool dirty_data = mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY);
 	struct gfs2_glock *gl = gfs2_inode_glock(inode);
 	struct gfs2_inode *ip = GFS2_I(inode);
 	int ret = 0, ret1 = 0;
@@ -760,12 +760,8 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 			return ret1;
 	}
 
-	if (!gfs2_is_jdata(ip))
-		sync_state &= ~I_DIRTY_PAGES;
-	if (datasync)
-		sync_state &= ~I_DIRTY_SYNC;
-
-	if (sync_state) {
+	if (inode_is_dirty(inode, datasync) ||
+	    (gfs2_is_jdata(ip) && dirty_data)) {
 		ret = sync_inode_metadata(inode, 1);
 		if (ret)
 			return ret;
-- 
2.53.0

