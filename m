Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559665;
	b=j1gwfWsgnC6lP7uYd3Cs+qLf4oOaWXOKeQqeoH94kSqoK9xMob46WNe8gYDO1iWWFylT
	 +gHeYqMby4vCzlFCO9YLOpsOif2Z7nw1l4hz+O2qpbKCxeqN2BLZbqb21UTIlE1x3mYlK
	 TP2Y538Z2V2SyPDJt11PWZjSDqRusC1RY41tUBjawACCS1Sc6/MG8HsQ3wcCtRYPI14ui
	 8VZpm/IHUvJtlcT7eg9PsXMpk8F6etJec9jOGmBLGH3A3WVliQ75LQFUi/KxY5xh1eTZp
	 Lb4hNmH9ZjfxEdRHxHMYTldtEXlKuw0dwWzNjWVzclC/XQDMtUFt8D60u+Bm102vU2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559665;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=6iRKFoGPoNxIxzoHziVi3ti4Tp9wo3z3sJ/WWTfiGCA=;
	b=sNaGxU1wdmRRfa8KuYihPlNVL8S3JwUUGf6eZx1N2lXbz1ADmxeHO/dL4WyokGGEMYBO
	 XIWjMM2Tm80WuKM5dCW2yc0rv5YiECOZcUHqrDLl45VS1ftrVxMEB0FhHbJs41Mu2+cDy
	 ye13YrE3w3jK+yvlJvAJ44mVpPL+LCcIbXBE/zEGrWW5dbC8aGdaNnCBrrEgjzw/eTcGF
	 PBB/pENbsg4KGCtQEDhgLVL4macQ1KSX6Wb4CeEgww1DJ4XIoV68C9GCLlQ81bdphpL4h
	 1qvDeMWTTmQgPMC6h9biP3EFdrJo3tnemAix0vDLWdS401KSZg/akX/oLu/KfFWXbqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NBTuXoOG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JIvxzRQa;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NBTuXoOG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JIvxzRQa;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B095606C1AC;
	Fri, 13 Nov 2026 08:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B095606C1AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NBTuXoOG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JIvxzRQa;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NBTuXoOG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JIvxzRQa
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 912051FA54;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6iRKFoGPoNxIxzoHziVi3ti4Tp9wo3z3sJ/WWTfiGCA=;
	b=NBTuXoOGjjzZ6A3qO5rJXmNU/Z93mbCmPsecD0kY1JYAmAuc4TYWGrZMAFmtzmPU6sjprm
	9xwYwEMok1CvQFR2l7kArLbMFNO7hs3VnMEVjGcjt099jxcP71ivYA2NvpcoLAxQQBc3im
	dw/CrtYaQq1PkbGo8f7RU5RiP7k+YDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6iRKFoGPoNxIxzoHziVi3ti4Tp9wo3z3sJ/WWTfiGCA=;
	b=JIvxzRQa2B1gVvTr4p3WA6SqNMxSA/rMn4GFZU3HJYIwZIv+lsfEIJJtuGmgRj+uHJYNFY
	Ggfeuncrle1AwtDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6iRKFoGPoNxIxzoHziVi3ti4Tp9wo3z3sJ/WWTfiGCA=;
	b=NBTuXoOGjjzZ6A3qO5rJXmNU/Z93mbCmPsecD0kY1JYAmAuc4TYWGrZMAFmtzmPU6sjprm
	9xwYwEMok1CvQFR2l7kArLbMFNO7hs3VnMEVjGcjt099jxcP71ivYA2NvpcoLAxQQBc3im
	dw/CrtYaQq1PkbGo8f7RU5RiP7k+YDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6iRKFoGPoNxIxzoHziVi3ti4Tp9wo3z3sJ/WWTfiGCA=;
	b=JIvxzRQa2B1gVvTr4p3WA6SqNMxSA/rMn4GFZU3HJYIwZIv+lsfEIJJtuGmgRj+uHJYNFY
	Ggfeuncrle1AwtDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3103413750;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Mz7UAK/O9mqaFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 08:47:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 4712022C38; Fri, 13 Nov 2026 09:47:42 +0100 (CET)
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
Date: Fri, 13 Nov 2026 09:47:08 +0100
Message-ID: <20261113084700.739002-21-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1078; i=jack@suse.cz; h=from:subject; bh=air2t+jjpODu/KcuQssVmunzU4STOOKtGPrRiC3+PDg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq9s6KgCLcrr68IISe8krmX8iMaQxGIJYwSTtJn aSN3yFLpHqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCavbOigAKCRCcnaoHP2RA 2TWKB/4rl9qoWaAPLsndIFCvAf+JaC/7OY8xvwAflW3e0tiYjiktW9Q8NQcrH1ZwIK2I+pDqaNQ hZ4IA0InqAZo8FW5jTbb6zdVlazu74suBN4hSl3e0aFMqowDJNiV4AcM1+FIOWAHQJgKI56hgwy 5kO1YQ98OHYWsc5YBwwrudD8IwD5uuwLzR3lp5LoiB6AGDAGEixphUEC0QNDPh5CgyIqWe3oXXi AmgEBhMFgmvGXuXBIh/WMmrAdokM+qM8JWqmbrPL5rR5OrD6FuoPxZ0UxkDEJI+DMzMZOmviHm3 PTS4dRKYwwzK3Pd2hfZgp9ds9oEsgqQ6fQSgTuT+mH+22m1S
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -11.80

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

