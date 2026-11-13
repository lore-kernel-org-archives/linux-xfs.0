Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559665;
	b=3HxDrNxDKeY2b0CeGYDCEtg9fVoXGGWnl4fGvrUdmWlTcU5d9siZfdhOWPjh74euFrUS
	 kbt8OLDtk0xcsj23SBeHNnJ8nk3EzbSNCqQ9hoK9sHQABuZpRsZjti678btnWHQ0reCEG
	 vnKeISdMUVSpH1lEplxOyufvv2OFikqrMYv4vCRpFJgmycyPCjP86O7r6M1FgupFt7nM6
	 /z5iUkHbKLba86CSOkRZwe4yrqiP+9CBGWilQmw2PO3IwtrFgMyBwXN1urCIaTnvwG3Ud
	 vVwebrGyVOf+UcMy25DJUpKzeoMcK+PkMhQ/PQjq2uy2ZmSayYjdx48pM2aowqmSY7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559665;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=VQb+bKWhxu6T8I0319SZX3JCOfe5xe2J2p1rpusenNw=;
	b=oSvhIZwlZh4K56BTl7DCO2dEvHfvoFXwOJm5mkVVQqoRhpltUarGC0sOxW37DoRD9xt4
	 KRciZQpvxmWNNxYwmu3ERCvtKLSFSsRAOXx1BUGXAK1KkCR0u5xDUXnlQ0v0bfO+X6jaV
	 /Tj6dEfHiAUcC+9HDQiJlEe2QTE6nhmLxPnmWsPHUUB2OyB5rkJWGgHuyUoHqxZ+L8P2Z
	 YdGiEx1beYXuR5dtBubdDATgIqZrt6EeQO89Q/klHyocLoT22/joAR1SiBnLaEY/g0ili
	 Ivop8m+f2ZaRnFuWBP2g1EVnzcPO0MqdVYq7VdOmEqi1iYL/1UsJzAmQFpXBVxmQifA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="SFWF/cZk";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YzIwrAfm;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z1LvWcF0;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xJHYWwHE;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D531B606C1A6;
	Fri, 13 Nov 2026 08:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D531B606C1A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SFWF/cZk;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YzIwrAfm;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z1LvWcF0;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xJHYWwHE
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA9211F7E4;
	Fri, 13 Nov 2026 08:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQb+bKWhxu6T8I0319SZX3JCOfe5xe2J2p1rpusenNw=;
	b=SFWF/cZk3I/gN2+5m1tOqvAZq6G8FRG620CwrBya2rGpAE4AsiGrsCTt30B9mKYSdX5yaF
	ze4LVi7uJ6tACaXwyYIXqCsVF8XoTcFUWwCctb22tRz38w0CAaZ2sMbhQ5binRqffXR/d3
	ATAIMD8BzHpHPrWUQbRs/015Qgip8Nw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQb+bKWhxu6T8I0319SZX3JCOfe5xe2J2p1rpusenNw=;
	b=YzIwrAfmE0ZFFXctq9K4jlZa2G9nAxmukL7wHJr7WxMyzQ6Gz1IINpmBFc0AVnG/7tvM+7
	nttY1Xx/bUw747Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z1LvWcF0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xJHYWwHE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQb+bKWhxu6T8I0319SZX3JCOfe5xe2J2p1rpusenNw=;
	b=Z1LvWcF0ChFlNdB2FafW7GgBIxBzBThZnXKd/ykG+jbp6jaPDy1ynBF/vJa1uckVwYoFYU
	VUTiDDAtTTLi53+rz89puvROP1D1zk1Y+duu9nznYORr/oN3qMGJmRH5L+4M9eWx/8TXZo
	3DfPWB6I/b/LY8rTG1mNjE6r0dtZ2e0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQb+bKWhxu6T8I0319SZX3JCOfe5xe2J2p1rpusenNw=;
	b=xJHYWwHEPehAGB+myLducoI1S4pWXtYjgAaTcX3fktQ7gZLsNaLQYxH9FRkx46jZvpDGrk
	jB14jAHn3IqXrhBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B371134F4;
	Fri, 13 Nov 2026 08:47:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DYn7Ha7O9mqIFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 08:47:42 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 1AA2A22C2A; Fri, 13 Nov 2026 09:47:42 +0100 (CET)
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
Subject: [PATCH 01/13] bdev: Drop pointless loop from blkdev_flush_mapping()
Date: Fri, 13 Nov 2026 09:47:01 +0100
Message-ID: <20261113084700.739002-14-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1685; i=jack@suse.cz; h=from:subject; bh=z1JyqCsZ1lnse9oZn1LwdYUSEld1ft2x2CnQBKoqPus=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq9s6EYcoAlm2vX4tK6XDG212WFtG10TkQz/+FW 9G3zmi8FbKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCavbOhAAKCRCcnaoHP2RA 2e/FCADwPe/h1X0kZUbCcBmzLY6l0HIzhD5T9gl4BSgguQxbV9VIxOlGmWN97upPqjNPkfh4lWW +nMYG1+V0hI4BC9qfrn9tMFb4MaFNwH9PwuhmTS4ZIoiPo/N4Ia4LM4bFxuzJFQlEear+Qsygai uGBQ4DvMCiX+BpT0YzevZkQbPXrI+vbBje/QY5T83W68PoOIXx+uJaMTVxS0wvpWOtVcvog6yED HrERf/fBCWym9YB4FVSTjEK/ZEp1vvkrJT6Xl+pmb+7Mh+pGF0HB7GiS9kvVX1sTiPJxJblVtsl IAvIJycHGvIGZIj+ESdREJClGklkbc9GDJSrasCoST+T53D5
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: CA9211F7E4

bdev_write_inode() is really odd loop calling write_inode_now(). The
bdev doesn't have any pages by now and if there are any dirty bits in
the inode state, they are stale. Just call write_inode_now() once to
clear them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bdev.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index f20f91b3176e..9fa72df4f47a 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -60,24 +60,6 @@ struct block_device *file_bdev(struct file *bdev_file)
 }
 EXPORT_SYMBOL(file_bdev);
 
-static void bdev_write_inode(struct block_device *bdev)
-{
-	struct inode *inode = BD_INODE(bdev);
-	int ret;
-
-	spin_lock(&inode->i_lock);
-	while (inode_state_read(inode) & I_DIRTY) {
-		spin_unlock(&inode->i_lock);
-		ret = write_inode_now(inode, true);
-		if (ret)
-			pr_warn_ratelimited(
-	"VFS: Dirty inode writeback failed for block device %pg (err=%d).\n",
-				bdev, ret);
-		spin_lock(&inode->i_lock);
-	}
-	spin_unlock(&inode->i_lock);
-}
-
 /* Kill _all_ buffers and pagecache , dirty or not.. */
 static void kill_bdev(struct block_device *bdev)
 {
@@ -755,7 +737,12 @@ static void blkdev_flush_mapping(struct block_device *bdev)
 	WARN_ON_ONCE(bdev->bd_holders);
 	sync_blockdev(bdev);
 	kill_bdev(bdev);
-	bdev_write_inode(bdev);
+	/*
+	 * All data is written out and evicted but inode can have some stale
+	 * I_DIRTY bits set. Call write_inode_now() to get rid of them so that
+	 * the inode can be evicted.
+	 */
+	write_inode_now(BD_INODE(bdev), 1);
 }
 
 static void blkdev_put_whole(struct block_device *bdev)
-- 
2.53.0

