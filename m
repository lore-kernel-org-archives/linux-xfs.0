Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424461;
	b=t9wHEDEEvc2x6Yb/nNDQHh1sjQlc74ATQe35WonpWCzvYemVcFmY56zy42SbXeI42XCW
	 ADwE8tHX5rw7cIec/UEVYWiJQIomxCaSpSrCk9mVxJefGUqDkWL+Ce4jM78YhTFUxJUpz
	 76xcVc4yLzjfYTzoO8U+LPVnenicFAPu4hWzwIzsRUojjPpYFl6UCmy1red6+fD2wDBGB
	 ydVwDQ1O0rVS09hNT2VYPbIpQA2LNMlIeJod7YJ2/LQeS+JYdVk2O3CvwgwmBbeJtxSBw
	 kcD9/VgOomHU/VrkSfa6rTY2y7LCWY5OcBBG+nthQlJTYmlNZijyEOeC59IFesvQATg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424461;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Pre-Result:X-Rspamd-Server:X-Spamd-Result:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:
	 X-Rspamd-Action;
	bh=XqMYKlFrQjVU4+K5c5B4knwoUhVZrKgHat1wB1uHc8g=;
	b=mnG6Of3RqIl1QNt28GFL39Kleb24HsG4W829CNoJrHPJsPXShsmukPCxz/Y5Ep4lTcSz
	 7QZZ2Xw48fn7wrkgN/xvCELEflTLGhJqhOP7H5ldHVcSxVcCROIqirzKk6jtEiMKMOOeR
	 Xa2/yLmsw8rahbRXRB5EBq8i79JgcFieXhn+rBnCllPO7LCQFwlPaB7+oqYA+Q/5nYUEf
	 p8PL09/4gxrxPtX/AAzz2lIoUGRmqrNr4shO+V6FWzBfJU4a2+lZUEKCF11NKYR3WmVoa
	 qfuukzwmD4iY/oVVsRxmFg0/T7tzAcaeKpVie8SN+MsPk/CCAYWON818EZRgfTDaWbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3272F606A33D;
	Mon, 23 Nov 2026 09:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3272F606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8365D2209F;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C234137C3;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aYaNBcoABGvxBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:00:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 705A427604; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
Subject: [PATCH v3 06/13] gfs2: Avoid racy dirtiness check in gfs2_fsync()
Date: Mon, 23 Nov 2026 10:00:41 +0100
Message-ID: <20261123090040.19006-19-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1953; i=jack@suse.cz; h=from:subject; bh=j2mMAX2HET80cyoNDKtciTe2MhUn/m5yF2y6/WHEovQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBAC9mML04tH+Wpr6JUEW1nzb/5JH3JFbnOcrV CAc1v0fje2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAvQAKCRCcnaoHP2RA 2aXGB/91aGj2m4dX1o7v/5VYZ1jayzyjBgOB2VSspGEKUZGwP1B7xafyNU7CidR4CpKzlpcV9bG 2qSREzZMNUe2RXTqEUHngUNWrWnG8EHR5AGBwn3etytEv/vA9LrJER2HOyLpC40uOo8vZVrUN83 Sa9RBEjzCJpAooIiD5ScOsYgzkoaBlDI6Xx/LFlSZf6jSko57QuASV4p+BpkqiqFkUnn8QQ4oJK PJybSg+mOFf3i1bxIEsHUoNGaY64wS/67cPbFIW3khmCkCR2ovtmw6Nza2SaGEXpGYTkL5nwli8 0aM3b1yhspKizAmW8rAZBqEIPUKo868v+WSuXSIR15TBmlA1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Queue-Id: 8365D2209F
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

Check for I_DIRTY_PAGES state in gfs2_fsync() is racy because
__writeback_single_inode() unconditionally clears the flag and
reinstates it only later based on PAGECACHE_TAG_DIRTY tag. If
gfs2_fsync() unlocked read of i_state hits in between, it will not see
I_DIRTY_PAGES although there may be dirty folios in the mapping. Check
for PAGECACHE_TAG_DIRTY instead and use inode_is_dirty() helper for
inode metadata dirtiness check.

Using the helper effectively reinstates checking of I_DIRTY_TIME bit
that was removed in 3aac630b5ce1 ("gfs2: don't worry about I_DIRTY_TIME
in gfs2_fsync()"). Since vfs_fsync_range() calls sync_lazytime(),
checking I_DIRTY_TIME is indeed unnecessary but it is harmless as well
and using the helper is more robust in the long run.

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
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

