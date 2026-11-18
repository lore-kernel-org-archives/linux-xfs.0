Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013997;
	b=fFiSxYtuq958SFYU3FZN08jo45xEhIY0q7g5aekLHQTDS0TaHRlWCWeijOIusBJRcdvV
	 zXJa0eW0fLYRGmFQE48qwL5Oo93dPCkIaDay6XWlezMeYr8zx3OfByP3FsbizkP8kGq0A
	 YWf99EIBV3X888TbpIj6J66A96qIwbnTULGqpQWie89TOOQd3tojDJ9FeK0lByB6BIiPc
	 No9C49ZsOMwBalvTz4Vr7Hwj3ST3MqlQU8l+Oq76Gyo77I7CHzXpF0jkFudC7VpFfII/0
	 HOgnLeObSvu0wY4PKK2j/E9GF6sTez2F33QbeTAK5RVs3HwD+Puu0jt7JbvtHurq1jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013997;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Pre-Result:X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:
	 X-Rspamd-Action:X-Rspamd-Server:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=9PufyaWrVxeOz4NAkti43XXJxPZUVkn8LHkFwQ+8mbE=;
	b=uvsxezfADsNpKgVtkMU3SVW5vyiEPfRcz+H0kN18J4IH8zT1Nt1H7wguNS5FPh6JWqDx
	 Kt8U52tqUAE0ntn5FMyjGnp57FdnEgIC6FnQ1NTNLByBRfl6Q+XGCEiRjaoDgOG5YIt2A
	 hgxAQJdQRb9e6/WkP1mSQGh3lFM/Tw8FdHofCp4AMwQtGttzq0ZYafUPa+QB/VvME5PxE
	 UR9w0qx3SYo8xt0JUBNKChgeX44kddoUniSMqf+q4yhi1r+/cuA8RC61p1j0Ww3wVbAKD
	 KgaSHzJg1VkVMcNzBsWop1U2c9EZi/4XtScO/vfq3zPx3TKi/4HhTkl4V8GrZqJTqPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F0E606A338;
	Wed, 18 Nov 2026 14:59:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75F0E606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C348B1F76B;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D53B134E9;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u4u0G2q9/WqNXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D208925093; Wed, 18 Nov 2026 15:59:53 +0100 (CET)
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
Subject: [PATCH 03/13] orangefs: Check PAGECACHE_TAG_DIRTY instead of I_DIRTY_PAGES inode state
Date: Wed, 18 Nov 2026 15:59:37 +0100
Message-ID: <20261118145941.1063127-16-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3189; i=jack@suse.cz; h=from:subject; bh=qOt0w8EOsDa7j7GP1xhYD0AcvF7QiI85DGoAYBCrs7k=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1e1aRsAVN8lnD44xY0otIjcS7frf9DOm+qj 5JeeuPtQJmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29XgAKCRCcnaoHP2RA 2SMvB/4/glj8K0/TmQiIlw8DWVmw6RjXXopRbZrc+3/md3Dc9a/p0x6TdW6JLWXeQMkBSQhTFDi ccZCHhCKscOgWs0NKh1iZp5wzlxiFMC8UBHQzf/G4ZDrwssVFEya8DvhqY8J0OTAX+23FRvY3qT B+Vl4CXtCUuj3M42tCZEcXaFqB2Ji9jT4rYTk4XOVYxyf8TL/+NK8WAuhI0jKi+c9IywbJOCafF aJJgEccLveO/U6Ah9RxV1Sy3PM1ZeYqc/MD78xgRdT+OX40fSKBl7HUrX+SK03QseVDddfZgoxi 1faD763SUf3lLHw0S3FVpAPjHWaQodev8XBICoLpGbsZQeA9
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: C348B1F76B
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

PAGECACHE_TAG_DIRTY is the authoritative source of dirty folios present
in the mapping. Use that instead of looking at I_DIRTY_PAGES inode state
which can get stale for example when folios are written directly with
filemap_fdatawrite(), which is how orangefs_flush() and orangefs_fsync()
write the mapping. So a getattr keeps serving the cached inode after the folios are clean.

The dirty tag alone is not enough. folio_start_writeback() clears it
and sets PAGECACHE_TAG_WRITEBACK before wait_for_direct_io() sends the
write. OrangeFS writepages does not return until that call finishes, so
I_DIRTY_PAGES still covers the round trip today. A getattr that looks
only at the dirty tag stores the server's old size while the write is
in flight. orangefs_writepage_locked() then reads that size and shortens
the write.

Hold the cached attributes while either tag is set.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/orangefs/orangefs-utils.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/orangefs/orangefs-utils.c b/fs/orangefs/orangefs-utils.c
index 9ab1119ebd28..241b10858b31 100644
--- a/fs/orangefs/orangefs-utils.c
+++ b/fs/orangefs/orangefs-utils.c
@@ -233,6 +233,20 @@ static int orangefs_inode_is_stale(struct inode *inode,
 	return 0;
 }
 
+/*
+ * Dirty and writeback tags, not I_DIRTY_PAGES. filemap_fdatawrite()
+ * leaves that flag set after the folios are clean. folio_start_writeback()
+ * clears the dirty tag before wait_for_direct_io() returns, so the
+ * writeback tag is what covers the server write.
+ */
+static bool orangefs_writeback_pending(struct inode *inode)
+{
+	struct address_space *mapping = inode->i_mapping;
+
+	return mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
+		mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
+}
+
 int orangefs_inode_getattr(struct inode *inode, int flags)
 {
 	struct orangefs_inode_s *orangefs_inode = ORANGEFS_I(inode);
@@ -247,7 +261,7 @@ int orangefs_inode_getattr(struct inode *inode, int flags)
 	spin_lock(&inode->i_lock);
 	/* Must have all the attributes in the mask and be within cache time. */
 	if ((!flags && time_before(jiffies, orangefs_inode->getattr_time)) ||
-	    orangefs_inode->attr_valid || inode_state_read(inode) & I_DIRTY_PAGES) {
+	    orangefs_inode->attr_valid || orangefs_writeback_pending(inode)) {
 		if (orangefs_inode->attr_valid) {
 			spin_unlock(&inode->i_lock);
 			write_inode_now(inode, 1);
@@ -281,13 +295,13 @@ int orangefs_inode_getattr(struct inode *inode, int flags)
 	spin_lock(&inode->i_lock);
 	/* Must have all the attributes in the mask and be within cache time. */
 	if ((!flags && time_before(jiffies, orangefs_inode->getattr_time)) ||
-	    orangefs_inode->attr_valid || inode_state_read(inode) & I_DIRTY_PAGES) {
+	    orangefs_inode->attr_valid || orangefs_writeback_pending(inode)) {
 		if (orangefs_inode->attr_valid) {
 			spin_unlock(&inode->i_lock);
 			write_inode_now(inode, 1);
 			goto again2;
 		}
-		if (inode_state_read(inode) & I_DIRTY_PAGES) {
+		if (orangefs_writeback_pending(inode)) {
 			ret = 0;
 			goto out_unlock;
 		}
-- 
2.53.0

