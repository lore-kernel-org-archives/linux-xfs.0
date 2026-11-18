Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014001;
	b=1BrveO+sdZwV5VR9LOyf9bKg2WAgdBmAXvVgD1hLpN6C01cSbRcpx7DQguG44omzznwv
	 H0kFOEs9svS4Q2SS7FAC2F3qP+ZkEe5PzZIFzIThxsQskL3LRcx7GossWM95QwF9qZZAw
	 U4dV0ZKoq+T0bVcTMWIzjAS5No5OoQRGK4aYhH7d+oT9FCYdqM1WyXkK4HJLr2/IXotoj
	 Q3rILcrJd/0YfYYiSai1bE4FTmk0VkPXfNPB50AXWjpb8khuJn/CrlVziwmllBAC/PnND
	 PG6sQx22/lB0FFJNfS5kJPW3T5QgQ175gnxsBq5ivV0AymJDJZWvdXAmGt+jG1yoK7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014001;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Pre-Result:X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:
	 X-Rspamd-Action:X-Rspamd-Server:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=6iRKFoGPoNxIxzoHziVi3ti4Tp9wo3z3sJ/WWTfiGCA=;
	b=OPczThCkzg+nQZqGfd6ZBWyCBRzAtRLCBmJI7hWrGBLibtdPb2jWkjUGKeI9dbxnAtog
	 ubr1VWtvWuLONu2Nu0WA6nHjqEXYMewB2vpB7itgSwM9JmYRANM+wOcxStOhTrEwVtxga
	 69mNy6BvJbyBQXzl5RBZvvpBPUBt+BhkYJzD6H90x5yXvL6tpl1P+Yaf4pgcwuk8ytfzr
	 V+4eTbkCmW+QT/3O8jrAryWdqoKQk6bwOPYNcK8/vzk90VYlrWyTXWt68/3NmZryKCzf/
	 mIIgau5TRvOhRhMQ6IwGBstHzx8dfadr0Ue8xZfw6VafNAPl5CvQMtXFatUW8Kf7GvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4CC606A333;
	Wed, 18 Nov 2026 15:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A4CC606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1316E1FA8D;
	Wed, 18 Nov 2026 14:59:59 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8CFB134F6;
	Wed, 18 Nov 2026 14:59:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TNv7K269/WqjXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id F21D82509D; Wed, 18 Nov 2026 15:59:53 +0100 (CET)
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
Subject: [PATCH 08/13] fs: Provide inode_or_folios_dirty() helper
Date: Wed, 18 Nov 2026 15:59:42 +0100
Message-ID: <20261118145941.1063127-21-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1078; i=jack@suse.cz; h=from:subject; bh=air2t+jjpODu/KcuQssVmunzU4STOOKtGPrRiC3+PDg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1jgCLcrr68IISe8krmX8iMaQxGIJYwSTtJn aSN3yFLpHqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29YwAKCRCcnaoHP2RA 2VUSCACoFoo1wiI2E7N/KctoN+nmKLKNBp5N1vgfrkGn0p4AZb1vgSKGMKP+czK12upjZ0BrTFu SrKocGxZAOsN/7Rr32Z+51Mct4NEPWOzekuIdLQzzFv4v4s6QjDq80N+Tq7DSgjwVURLnJp75Bi vkQwb6m2jJul7aSYi6Uu5w3F/GM7kriCdfCg9aAagoJms4ZWI05Ve29cxXfyQLQ5OPv1Lxmawh+ j57I7cJb3o25jK6CMBhaN6NFbooSmpppjd9yX6hI2go5Y+seImXHme+g3zUdy7+qBnpBngYboor B9kTAWW7rqpQdhmTEyzD2LDLvOktNXf8HOhxitDaxxn8T4HG
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 1316E1FA8D
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

Provide a helper function checking whether inode itself or some of its
folios are dirty. We'll use it in filesystems instead of direct i_state
checks. Note that this check returns true also if only timestamps are
dirty when lazytime is enabled. This is what users really want.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 025f5d890689..f602deacf953 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2228,6 +2228,13 @@ static inline bool inode_is_dirty(struct inode *inode, bool datasync)
 	return inode_state_read_once(inode) & mask;
 }
 
+/* Check whether anything in the inode itself or its folios need writing */
+static inline bool inode_or_folios_dirty(struct inode *inode)
+{
+	return inode_state_read_once(inode) & I_DIRTY_ALL ||
+		mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY);
+}
+
 static inline void set_inode_metadata_writeback(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
-- 
2.53.0

