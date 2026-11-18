Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014001;
	b=OOqQvQhk/xuND208Lip/QGHv/0E3pqn60riyAuJvshlDhnMw4JeOFtA2ZMWsRPlwpfEo
	 MWVazZcoQXMAd1m26eYBczzeuTJpgBMv5ofHWJ9P/Q/q+8xXozgZeuCMSwYbcecBb2f86
	 XnHzreAHqaiGfMNZAaJmmVsA3Y0CwUTZB07IBTCtbiGzNXzSMo7sKqy94EU2mWJZL4fwG
	 j7il/ED7sX5aiSxOdT5p/nhGm7JtbSl4OylkE6IWhD/U/3tuheylLgB3i4f/2YZ4mvD1M
	 p9375b7tCc80sQyrmReeXxDhmjUuvrX3Z7X5MhRGf4J8OVXwb+L0mtMHVR9Bx4CvJdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014001;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=d/RoD5olwuPLZld3zSJU+6g7HJ9qLqXHiKtPlJcCmgQYaAjPPEb2GlUTaj4EDJJuRG1I
	 ouuosFFMg0p5O1SqisWIE88NaMb6AsxMqS6FM6OGK8r3YzxnQJqoS7lTk3tzuC7RrRzjT
	 M86UsetXwQjYshHaUdj74pGuL8UMtAyyW9kamdJInLXuuZEBLadDT4RBjV0ICkmUyZKH9
	 W+zeoO+Eg4L6TF2tPP/hfIYSJwgI2ka21v874meB3KAXSPf8iFsRekmgxr3Dc5wmzyvnV
	 eJLJywuVlcpfMDCeTzZgD4xwdw3mFLyCgpHcvkmKWFBfJssGBgnitYbK8opIQEYf0Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="K8/YCyMJ";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lpf0EoXP;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="K8/YCyMJ";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lpf0EoXP;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4A3606A32C;
	Wed, 18 Nov 2026 15:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A4A3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=K8/YCyMJ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lpf0EoXP;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=K8/YCyMJ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lpf0EoXP
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 216DC1F88E;
	Wed, 18 Nov 2026 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=K8/YCyMJX+yQh819SY4TOwUofCjQcD0hb2V3kzU5TZtxUoK4M9KLRL5EzQzHbpGlLpoK6y
	kDUL4ovynMw6BSXCx4xatCtQZurgbJQfPAJEGu2YCv1bQRCwSXJyBzx/IoIpUt74Nm831P
	C53f8nIHUoI0EKmGrL1Cem48VPrQN4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=lpf0EoXPpUNLJalkJMzUCh3VN8B1Gm2zv4c4XW6Tig2zH2fJsX45OmgR9JMSSvnqj+HL8s
	x1wFSzURvVZi5ICA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=K8/YCyMJX+yQh819SY4TOwUofCjQcD0hb2V3kzU5TZtxUoK4M9KLRL5EzQzHbpGlLpoK6y
	kDUL4ovynMw6BSXCx4xatCtQZurgbJQfPAJEGu2YCv1bQRCwSXJyBzx/IoIpUt74Nm831P
	C53f8nIHUoI0EKmGrL1Cem48VPrQN4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=lpf0EoXPpUNLJalkJMzUCh3VN8B1Gm2zv4c4XW6Tig2zH2fJsX45OmgR9JMSSvnqj+HL8s
	x1wFSzURvVZi5ICA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED1C613507;
	Wed, 18 Nov 2026 14:59:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yr50MW69/WqmXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0AC4F250A1; Wed, 18 Nov 2026 15:59:54 +0100 (CET)
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
Subject: [PATCH 10/13] afs: Use inode_or_folios_dirty() in afs_evict_inode()
Date: Wed, 18 Nov 2026 15:59:44 +0100
Message-ID: <20261118145941.1063127-23-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1012; i=jack@suse.cz; h=from:subject; bh=A3fwFrLxq2sLtsoLLFywsEZVT5HTyxLWIrwzaeggONU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1k37ZIR6z9fsTw8rPMt+C+UFIW26BkL5FQl qYWaDW7412JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29ZAAKCRCcnaoHP2RA 2RvcCACHKWZlGcGDdSiAJp85PlUWyBQrTnIa0GQs4OufDPtonw9LyfMaQqei/t+As60CWoIZkGS BvfoUQJghvAdPdAn8/6T1QrkMGXedEPne8wmons4U0Izs/iHqubLDSXYzzjxVsCS8QWcidma5Eg jxad8PiF8KSKYPHwkI60nWEeZr9y/6WPFae07BL+wboyJ2Ej2VjX8VbBA4EN0+LrJR7ImmZCsAW xCsm7//KlMA8VBs/zNbLny+DRHcXdP7pyC/fFtIq2OipPd3B0ikX7t1rHblWQulY1Ev2aDFNfxi 8c6giQriDc4vSIpKP8XFT+xzn+i8yjyubthZcmA/6aCE35yh
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLyaw51ggmke6bkcxeyajg5whq)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -15.80

Use the helper instead of direct inode I_DIRTY check to abstract details
of inode dirtiness handling. This also properly triggers when only
timestamps are dirty and lazytime is enabled (although I'm not sure if
it really matters for this particular case in AFS).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/afs/inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 0733abff77a5..69982e7d7020 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -667,10 +667,8 @@ void afs_evict_inode(struct inode *inode)
 
 	ASSERTCMP(inode->i_ino, ==, vnode->fid.vnode);
 
-	if ((S_ISDIR(inode->i_mode) ||
-	     S_ISLNK(inode->i_mode)) &&
-	    (inode_state_read_once(inode) & I_DIRTY) &&
-	    !sbi->dyn_root) {
+	if ((S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
+	    inode_or_folios_dirty(inode) && !sbi->dyn_root) {
 		struct writeback_control wbc = {
 			.sync_mode = WB_SYNC_ALL,
 			.for_sync = true,
-- 
2.53.0

