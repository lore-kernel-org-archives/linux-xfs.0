Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424460;
	b=c2AFiJaFk1C8W3Zf3HsApr2Z/dFk3S0xKncaEEppsV8bKIVABGVrIZdLpLCb88aR4vKU
	 1/pqfIjUqEpKPF23hrpavEEbDr6VYL76Znyj3+70B74g72Qrsiwo8Y1iJoEwd0OxdyLbm
	 ePBLXGfiQjHR4o5apQBp10HO69/bExnKLh8kkF+O7sclPooICD46qLEC9NoZNMQHgWr1c
	 jvdBP70JTecgTRS7th+pj73DJQHtoAsnVxMSFGdkA/Jsaeta16OshN3XS8KeHJ+mC/NZP
	 PsIGzCTXcyKaPBTCVUo54h1+hdeG8mWJE4ntYnV6hN4LFCwSCMpLrOs6blGphSt3h2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424460;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Pre-Result:X-Rspamd-Server:X-Spamd-Result:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:
	 X-Rspamd-Action;
	bh=+lM7rrM1R/XvKFJcc9D+ndKl/G6mdrWcbu/Y3hUJBMs=;
	b=GMlvRaB4nlt528yoMKNzg138QXPR4feWtg5sZ+XxnjB0VP27a6ZhoP8h7mZLIimmel/C
	 LBF+/8Ky9KbmJZc17twJIpRcy4TZWVFK7MSV0cFrriLIZWjDvpPplluyt/RHwkpqgwtpA
	 e65c+geeDTngFkq9gXWndlFRj+ilc10mnBhCtzfERAudzWoEMWPX7DTnGTm2bGs+fmFnF
	 yei8EECs5yDMQbZ4aWQ6sH8IUcR1jVQaYC52QlzfSTb9iJUQgPAjKOXunYCLxYptDld+N
	 1F4mH7gLoBlw1GpoM5gA62BvnnP+GiKuwcANFEBVYRKBeLGyOfKYctq+bVhrPhLFpMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609DD606A68F;
	Mon, 23 Nov 2026 09:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 609DD606A68F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7F3051F80D;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33706136D5;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DbG/AsoABGvsBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:00:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6AE3927602; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
Subject: [PATCH v3 05/13] jfs: Use inode_is_dirty() in jfs_fsync()
Date: Mon, 23 Nov 2026 10:00:40 +0100
Message-ID: <20261123090040.19006-18-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1029; i=jack@suse.cz; h=from:subject; bh=G2KZ3si9+GMJBvBvY3QFhsaBCqg7CNyaNYSowoLqcTk=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLJZGPbY3e3aaHPOY01SwYaDqltn7v94c+Wx81YPPjavT F8mFiE1o5PRmIWBkYNBVkyRZXXkRe1r84y6toZqyMAMYmUCmcLAxSkAEwkDqm5smxK2947Nm03L NTwfFHG8i1Vn43GdkKssYda/vfxvx5xOxt9SWSeC7PrnzFZTC7Nf9eK8yfUMy5vRJ6MvWMtueZo rljX70MZEMWMpva2r09QO9vzKO2TSIZr+YINv6JMSgS03mKtP3i/vmS4VezRC+7mCRkwyc6baiY ua754rL+usOhVWaK0h55BkXDhhCffsnxfswq8Fe7Qbx4m6n+H+ypPIzC2ffvMjxxGfPSfC4wJCj f836kRFO6R+aNd6pt84nZfLYcsz9kvBggd9GJX99v2eJdF0Lv9mgNhJ/vbeZ+XTGQVbuqYuV1x+ Lryi5N3B6x9nBs+Q47kkZdj8/tv3izqx60xkTVa7PU0HAA==
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
X-Rspamd-Queue-Id: 7F3051F80D
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

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

