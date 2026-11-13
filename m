Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559665;
	b=XbrIlj6sPOffWLpQhMqaZHo2xIC8DqVUBxiE4TukYLMw3LSwWGgbR9/y4A0peRTV1Q0V
	 88M7TqrPsEMnJWE6JzLS9fUl8bL4FOOBuvY099r873kFgpmSz3QsS6vFw22pw9vRb9OLu
	 /Tw8efIW7bbFSNeG/Ro+HRnK8jUiCn1+zWQP9hmxa7U5Fh0yUnnIsl7waGTCCHireAh9E
	 meA1+cvQ+woAvWKqf4xYzO6yaYmJmjPH3Dc3mqd4xWGRfmbHs6HF4jRP85Ex2CGdwn7X5
	 +AeKnIZy7i+lDM6f3VXBt5gTwHNrAMFqP7a7pa0zXll2K1AJ4DIuyfwWVfqmaGbTZ2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559665;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=j/B0HIvVj5NnSaKJGL5wQJgnE71sFwfBrbO+7dI8JKKIvDWwfzbvAqhhMNQUrlA1tLUJ
	 3N7TTcrCoea+M89ypyIeEscGw9ralUx8mWTzfBjrSvBzsgxOySe5G2SdhWWzWy9uVwJLm
	 xHgTaEEkixG3TNsDb2nKyi9ccheOl/KloJEkkOVx0B6cnu67cTavmeJ0O9VUJQ8+05jni
	 DedrhIZceAEbhIjmDHw4ro7tgi2XEUoAyVDSXACz0VKeUKVI3X4FBtpzrq+8HYn0Ym8TK
	 DkSg9TFTLyUB5ufJhCvXAKVcjDvhuNtTPUdk+UKb8EPMzboaZ7AgLyHXeBXSM/hhlLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p1PjY5Ov;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=59b71h5U;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p1PjY5Ov;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=59b71h5U;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50C8606B363;
	Fri, 13 Nov 2026 08:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D50C8606B363
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p1PjY5Ov;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=59b71h5U;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p1PjY5Ov;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=59b71h5U
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 579C61F82F;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=p1PjY5OvtCLshRodLIl+qksUzxWjYgUbxkQZYFV8Fi21RjfBL4MWoqMkzNdzoSkpP1oU0Q
	7PYpKecMrALj0u00wTTXafOy4mx2jhIxH1m6KD8RnjT8VzuwJw5xpUDb4mDC2msBku2DuD
	ASOWKb3Gc0MPzYAY82vEOjPpDmlLH2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=59b71h5UpNNXXrIHVb3Mbia9BjwFaXND0ms8AH+dtl2fOpYULX3Amygl/rPASpvrjFtajI
	W/J1ScVxYvMNUOCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=p1PjY5OvtCLshRodLIl+qksUzxWjYgUbxkQZYFV8Fi21RjfBL4MWoqMkzNdzoSkpP1oU0Q
	7PYpKecMrALj0u00wTTXafOy4mx2jhIxH1m6KD8RnjT8VzuwJw5xpUDb4mDC2msBku2DuD
	ASOWKb3Gc0MPzYAY82vEOjPpDmlLH2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=59b71h5UpNNXXrIHVb3Mbia9BjwFaXND0ms8AH+dtl2fOpYULX3Amygl/rPASpvrjFtajI
	W/J1ScVxYvMNUOCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E17361368B;
	Fri, 13 Nov 2026 08:47:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7BOYMK7O9mqPFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 08:47:42 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2E9F422C30; Fri, 13 Nov 2026 09:47:42 +0100 (CET)
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
Subject: [PATCH 04/13] fs: Provide inode_is_dirty() helper
Date: Fri, 13 Nov 2026 09:47:04 +0100
Message-ID: <20261113084700.739002-17-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=953; i=jack@suse.cz; h=from:subject; bh=xOmo84WJOisQVAhQnOPGQkdou8zuAdb6TcwawJJufqw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq9s6Gf2G0M3LorDLP5OvjOgq4WAHvSsH554SUA qj6hLx64miJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCavbOhgAKCRCcnaoHP2RA 2VGQB/9ekMeVHsyMTY52QC9Ajnl7GwwQOMx4b5NxdHjsWCmVMFrkMT3opTfSbHtdFDSepchQMt2 g+NskCoAOO1J1kD8DXBuIByMnLhzEs14RPJYZzVKSiM/yzbL4MQOqIW5QGk+BNojsbQtCApCen3 3gjdj9pUxfCA69MPNHb6GkRt2j045meRcgI7kQeKRPHTbce8RADmIdfIbkks14hfna0skwaiTXs uv/vAgUgb9KpFQ276vNtde87gqaBHyf/jpqe0z5Pd40UcwpZVyII7jBZ/6oSWkKGtnnsXWwjHZs Li4c1jot+3hZKifTXS475/z/6mf/pRJbRPgtfsK1iewhS7jr
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.984];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLyaw51ggmke6bkcxeyajg5whq)];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Provide inode_is_dirty() helper for use by filesystems (mostly fsync
methods).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c..025f5d890689 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2217,6 +2217,17 @@ static inline void mark_inode_dirty_sync(struct inode *inode)
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
+/*
+ * Check whether inode itself needs to be written out either at all or for
+ * the purposes of datasync if @datasync is set.
+ */
+static inline bool inode_is_dirty(struct inode *inode, bool datasync)
+{
+	int mask = datasync ? I_DIRTY_DATASYNC : (I_DIRTY_INODE | I_DIRTY_TIME);
+
+	return inode_state_read_once(inode) & mask;
+}
+
 static inline void set_inode_metadata_writeback(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
-- 
2.53.0

