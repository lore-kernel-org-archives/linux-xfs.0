Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424460;
	b=NGJ0NlliKQUeUJ9hhOLbLYBFjiAUnszH+QcELKG2GCMNBOssR6P/tYKtnFtyJ+TZixlz
	 E+U4aZCxoVWLKvigZLTwNJrbVBm3/5YQyv+vvdJpkkM70q5Y9ChwNLZO+HUreyghFmlGs
	 kP8g32NMZyt4i+WqtHv2d8rOXf9nkfOJk2vB5Q43nhDld9wpDpmLnAIKYAr+oo9IwitBb
	 o2/SaTRUG/VcAUuZ+U12nDRBjW3nIINs0sUtDhuS1r7eAd55ZW4jDAzibMwzux9gEOvHk
	 9SIVr/06MNWdQeGPCGuWfaKdRmyEuG+BJ7+Q2RrYWc4x4oEO6eICEmhP/T9jhiI+nWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424460;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Pre-Result:X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:
	 X-Rspamd-Action:X-Rspamd-Server:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=uPhxwqgRwFr2c0Wk/MJfXbhM5TnmiRTw7EakaKv1UGA=;
	b=HJhCmbBhN75aP0BfK3wQm8Uq65TD/Sox1z/3QSuXE+8uFUALV7uEEHuNfTwcOgYHvkrn
	 slB+yD2BXgPPN1ueEuhknGJpj8/z2FwB2adBrmBGvqx+KfOWYOILb8pqWDTtKb+Lm2dH0
	 RLvL+w4uL9JJh+7z1rM+FILFYXeahclG391Jlih6o/2KJei69b2DwxR933964/5vYSMtE
	 ZLSn3Zi/oHYLaNaajozERBwFGmFORSMlUBEwO8KdbAkAdJb0FQppYJlW1RE4MQ29tp9LC
	 P5x/t9A0gojsh5U3chxmqDsCyCD68sASAANEhCBTMgLoMNdYf+gR3e8E8xt44JO1qjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918DE606A32A;
	Mon, 23 Nov 2026 09:00:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 918DE606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 01B2B1F7F3;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF80413532;
	Mon, 23 Nov 2026 09:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B2ulLMkABGvgBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:00:57 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 54A9B275FA; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	"Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Subject: [PATCH v3 01/13] bdev: Drop pointless loop from blkdev_flush_mapping()
Date: Mon, 23 Nov 2026 10:00:36 +0100
Message-ID: <20261123090040.19006-14-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1749; i=jack@suse.cz; h=from:subject; bh=GZumrknrM8DPyabr5Jne8KkRCS0p4/yNON9cCW4wy70=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBAC4xsOQMPEQ2oKCGhB4uItf13zp0U70aCwz8 BgxDEqYscuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAuAAKCRCcnaoHP2RA 2Yg5B/42IPKKHMy6SSIbhPKxdCra8evAwnyXErezZac3fbRHGUyfm2yWf5konhAEdX/MLMTYQDt /cr4G9mwfK3/V0zMBR2I2u07NDAl2X9fnk7M+qBRQ5nMlv7nGooy48BccVa6qi1XdCekw9BZOuD 4/jDvTQy0fmEcr64knYRC+oSlc/r+nThyOkEAzk1iZCzdjjQhLZl6zAJDPcf1iL01TJwfwZ8GBO APpIdoItWy7+qAmaDZddSfNwxedGcf43/Ju1297VRa8qbXDM21j9E/fbmK+syjfw+MSZyjrtnsp OGwtIwKfv8OL3hw9OvBMuWeFt8mgXY4s8P0TNKFi7kyDubak
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 01B2B1F7F3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00

bdev_write_inode() is really odd loop calling write_inode_now(). The
bdev doesn't have any pages by now and if there are any dirty bits in
the inode state, they are stale. Just call write_inode_now() once to
clear them.

Reviewed-by: Pankaj Raghav (Samsung) <pankaj.raghav@linux.dev>
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

