Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424462;
	b=d8EQMNlL7urvKGhuU3fnl7UfOleG8pM0td8jC/pGOdYj+04J+eg+RO6B3z+Q/2p3HAtk
	 R/M0uPwWj0VbSJBLjMb2KD+6nw4izunTpR36kq2rPmQzlgUD2TjhO2sgnGc5uC8f3SfFS
	 ss4bqcxr+aYiUG2y6Nh2TuSvLHaCQlXaFiv4bbcjU084AGaJyaRM3+s2LQGFndIfwaujp
	 JUjULF56WO6knq5Kc/Q2YWLyPTUfsFg/RuTE4ZTpYooA0GfUotSVClMyedMqr7AWfPoG+
	 zs3EjUuGkH9V76A9cDX3Wc4QBH03mwHWlhyHsVTWNUIyvexnVLyk9sC+A9M+tllG0DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424462;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Pre-Result:X-Rspamd-Server:X-Spamd-Result:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:
	 X-Rspamd-Action;
	bh=HfV14SKuasylwM7X5VpLaQgs/+seM3hJPVM0BUQseaM=;
	b=S5JrLDa9a/tpbj44DNQDGGKzU4YvZnNcFAkE19spwnKpjH8ago7Mz08ZybpdPo1o1Kwg
	 2e8cM5sDxRRpKG8IiyH2LKUhVhk0294glHqqX9LetqcNASSt0SHDNW4cw8Saa49vI042j
	 WvOvZv6GkGqL9+W4t6EpEyQ6Pto68gFqfw8tjq9fTEmoKCoUHq1AabFhgPxqd9Vk73yh+
	 bOPIwzMvyigqwe+bodoGeXR7ZXhhWhBEhymDl8XjpQciO4CMAuxjXXVnnorG+LTHILis4
	 eI7YVRm390LvkWkOPIT4iDTw3+gCQh3OwSLkIf1NcHKTjdoTQjF/PPkvMFcpKd64OAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAE560A3810;
	Mon, 23 Nov 2026 09:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABAE560A3810
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A20271F818;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DA62139B6;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CKkKC8oABGv1BgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:00:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7AA8327608; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
Subject: [PATCH v3 08/13] fs: Provide inode_or_folios_dirty() helper
Date: Mon, 23 Nov 2026 10:00:43 +0100
Message-ID: <20261123090040.19006-21-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1005; i=jack@suse.cz; h=from:subject; bh=p+APc2RQCkvpzVtkfrRDeLOBTmFgYKXPQdLJfqCExg0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBAC+QJl0ElfexN4Roh8VT9lVm6d0o+i/O3aAE Ax4KTqavBOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAvgAKCRCcnaoHP2RA 2ZIBB/9u157MCZYIkGQsepdnoio91foT0WKxtpNbvLdwcCM6CXhGSE3SvXp3WgdQ+p2z4BZwSMl g1UgGRj73qo1A6ZZFRxC+jCa+pH1QQtoFUr/FyNGUjrDMeaoZNAjnhf2KhTxX7L8KZ6joIQegof Q2FG2t5RDl7lQ0dB8qWKgunVzjIebY553LCFtGpk4JE7zeEkVRV/GdcTdr7pXoFlcYsdVRNxUN0 BMt6vHeHG0d+n0U3D2oWn+hQmN1ltJehuJzZEBxpot+OOTL7Q9xst4qf4gFU5hzJlId4ISXhgpA 6sWF7Dz1ZSwbWyitIh/KhXo0xJzag6+mhmRBrU/0IOGVP/VM
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
X-Rspamd-Queue-Id: A20271F818
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

Provide a helper function checking whether inode itself or some of its
folios are dirty. Also returns true when only the timestamps are dirty.
We'll use it in filesystems instead of direct i_state checks.

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

