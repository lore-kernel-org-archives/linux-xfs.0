Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013997;
	b=c6pnvWl1P9MqQagKcHPQ0JV9Sl+vXSXHEyLPMSXij7OAjxB/FKf+jCMIIUc6YSoMM7d6
	 x0Hq2VTwnJN4QEHGAEMnLa8Bb0XLrjfo9deUdTYG6qg3spw76yHkAIcIU8VpFybQbZ/Fa
	 koSaenbNuAw4vbKrXS7WtFMB5cVnpTX8noJ0NOqDDCNWeMZHTpiiFmatLRp22xwRcEnjb
	 OuKAqcOJ/SmW4/8uwabvR371qV2iJ3auIUo97ImOJaQARax1vkROL7QwT8lVmPvWHWTeY
	 ozd0l/Ykqx47GTizwNIrHO8NAVQu7ZFZq4Dg9sD5KHO4OVXlt06SXG//xT0zpe6F5og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013997;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Pre-Result:X-Rspamd-Server:X-Spamd-Result:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:
	 X-Rspamd-Action;
	bh=sJOcjt+fA3f0gmiULrSdno2cFCxjWnvJ5BbzkQtHN60=;
	b=sWp4sjaTU9ObJzQ61klOrXXcYsgWsZ4OibpScu42CMB5zrlAjZQb/hrS3fH76AWKc5Jp
	 kCzPqUGMTR9DlT+MqqNJYjnRWWmSpj9pYJhGiBNRz4sKjkLrRwKeGDhk0z9bGrE2odg6r
	 xl+Dl/GZmorxGYD8oXoiZ4fGNoQwEXP4FeXHQiLUOhfJ9TSobbfPLdTP+70hJWj6S9tZR
	 7YwVAqhMuHLcTexeS75kpJUDxWGr5Lxm5DfPd+l3QoCnonE9AX9xP/zZNJDy471dgKsJ8
	 yLX6HbMGYwHfH76G8Gn6OITz1d5bXQ6JXv4od+rOH1AQv+NkNR7MVECEgnSZl6guQTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3908760A2619;
	Wed, 18 Nov 2026 14:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3908760A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3E6661F88B;
	Wed, 18 Nov 2026 14:59:55 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9C0E13678;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nhs4KWq9/WqaXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id EBE012509B; Wed, 18 Nov 2026 15:59:53 +0100 (CET)
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
Subject: [PATCH 07/13] fuse: Use inode_is_dirty() check in fuse_evict_inode()
Date: Wed, 18 Nov 2026 15:59:41 +0100
Message-ID: <20261118145941.1063127-20-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=825; i=jack@suse.cz; h=from:subject; bh=/+R2RM/eaN1B9yo0gEWxhhBzGp/HXlo+uc2oxzvZkfA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1iwUXPrwJb6wqOYNJVZc3QJF0vToQ0BOAqp KD6ESMyUjSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29YgAKCRCcnaoHP2RA 2QwrB/9Mm3+2DQpy9V/8srvbDv5mYqpXIE6EkduRpO9Y+1nU2t5X6wLPkmp+HOVmnnTJkYo53BM SXQSH3GQsED+XZvEhne2eps7ahNZSCn1M/Ag4E+Y1QV4A7Aa//W2qZnJlZrdZaza/QqJpN5yh+0 UPLn3c8E910+faWrJsUs/ORJgF5ANhkHPPxx4k81q2D2vk2X7d6Da4NvMECZAi1mh++82HrGVgF C/Y9b7lK3kfY/mIsMAuZiyvp1IU9/ZmmS6QxgxBJAxJi2Bejnl+hHlcNcyiyUnQWYvFuF84ovyT EXNlWIqLIzVq9d5xVh6B4Yj+GHSS/yKPrXwG/+xuJspV2ZZm
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
X-Rspamd-Queue-Id: 3E6661F88B
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

Use inode_is_dirty() helper instead of explicit i_state check. This will
result in additionally warning if we have unwritten timestamp updates
when lazytime is enabled but that is actually desirable.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fuse/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1341b681d0ed..ef88ba7bf682 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -143,7 +143,7 @@ static void fuse_evict_inode(struct inode *inode)
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	/* Will write inode on close/munmap and in all other dirtiers */
-	WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);
+	WARN_ON(inode_is_dirty(inode, false));
 
 	if (IS_DAX(inode))
 		dax_break_layout_final(inode);
-- 
2.53.0

