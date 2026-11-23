Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424460;
	b=q6V0p12ixLCh9034Ei1eU1Zk1zJetCbpK5YG/xdEB+MOUgw9xFDPIFTiGd53ahUsFF43
	 bQ/zJs4pcsIYxZteZIDyAN7zRnVa0qZB5n+ltzq5ZUE8nYxqhw9kpz38Rl/djZ4Lq47X0
	 k3+CZlK70cjTFnlxhDJRnQK0vxNwuVg2bhpXoDXkfethN3dYyES/7Xk8Txf8m1yWnvuSE
	 L+85cK2KhpC4IBbya+vzHw43fQUBWubuVbWZqyuX5ddzxMXa5Ve+/0W4seHA36LONCtyG
	 he+14WNdesAgohVSR8spIlb6GC+VG+96JC/jBdopr4tx/KFaSbvHpEaGHLxFNAmPluQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424460;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Pre-Result:X-Rspamd-Server:X-Spamd-Result:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:
	 X-Rspamd-Action;
	bh=lpvhanw9TJqEMsFgXkrvlifU06FN6p6MwkWBWozOy8Q=;
	b=tkXJCYxDu2Bu1ULfe/Va1l9Jpv+X/c5nkLuL/szN3JvZfBPktxs0/PIY09pu8EEabyFj
	 xA5DOIp6IKyVJPFHTHfm73UhbMcrdQutjvOMLyR1hDbS43fVZ5jm7wG6CwJAMseGm3gRt
	 OO/wtHuK/ScHI0UZXH+8caJEvxMEIqnv52U3ThxIBINw3YRMv/t9emHGxcc2sGZSPvE97
	 7eKaAUg/VQT1bIlIoVpXMWEF5ivZajbC+VvmMNcwNzapUq+gwwfIWiFRrFb0vei8oysAV
	 0ceLuRwFZA6i5jwd6FCKxSPRKrl4t7MzLbFkfLO/qII9DlzkcYj1uLQjebA2MKTDxjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44483606A682;
	Mon, 23 Nov 2026 09:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44483606A682
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AA1BA220A3;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 68FFD13532;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tJ5XD8oABGv7BgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:00:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 808472760A; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
Subject: [PATCH v3 09/13] gfs2: Fix dirtiness checks in gfs2_write_inode() and evict_linked_inode()
Date: Mon, 23 Nov 2026 10:00:44 +0100
Message-ID: <20261123090040.19006-22-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1407; i=jack@suse.cz; h=from:subject; bh=VNCyIkn/glslaPM032BDlF6PyzMHDTmuaiaadhiEfv8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBAC/crBm0TUVlw+aAlbOWDKQSd2UB+UtZWP1t gKye0F6v1qJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAvwAKCRCcnaoHP2RA 2fWKCACym/yM62OerHOpBJLwO+l0T8PQZHq8IDlrrFM5qyCtuGCk/yVfMfSDihPUm8aoHfHualH mi7RzqSZ3TMO1NOjqeHjPX+cE/OdkdB2QNWBAhlNLhRqY/eLEexCLLiEUCqx8OjsFya4W+zdB0Z PL8TlBmbw82XeGlM9cOd8kX7NJQ5V472z47nofimZFGtofcRUZh9gS/xNR7WNZaqtVdY8Y1tFKi cN4SxYlglM3RdKam0wfxeTnLFR14gC3GgQ0LAiC0u6Rv1F/Xq0eBGKexgsWoI20DXlGepnK0cHb 3g8L0rf59SSYKgIoBDusG/IFexuop7kK4Upjb/P+zLfMx07Z
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
X-Rspamd-Queue-Id: AA1BA220A3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

The checks are bogus because they check against inode->i_flags instead
of inode->i_state. Use the inode_or_folios_dirty() helper which actually
checks what was intended.

Fixes: 957a7acd46e6 ("gfs2: Remove inode from ordered write list in gfs2_write_inode()")
Fixes: bd67f17718cc ("gfs2: Fix data loss during inode evict")
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 04bb4cf787d4..9b723dd591a5 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -460,7 +460,7 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 		mark_inode_dirty_sync(inode);
 	else {
 		spin_lock(&inode->i_lock);
-		if (!(inode->i_flags & I_DIRTY))
+		if (!inode_or_folios_dirty(inode))
 			gfs2_ordered_del_inode(ip);
 		spin_unlock(&inode->i_lock);
 	}
@@ -1418,7 +1418,8 @@ static int evict_linked_inode(struct inode *inode, struct gfs2_holder *gh)
 	struct address_space *metamapping = gfs2_glock2aspace(gl);
 	int ret;
 
-	if (!(test_bit(GLF_DIRTY, &gl->gl_flags) || inode->i_flags & I_DIRTY))
+	if (!(test_bit(GLF_DIRTY, &gl->gl_flags) ||
+	      inode_or_folios_dirty(inode)))
 		goto clean;
 
 	/* The inode glock must be held exclusively and be instantiated. */
-- 
2.53.0

