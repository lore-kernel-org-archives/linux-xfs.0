Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014001;
	b=KnnH9R2b5GOp4PdGZslCdsSBJ+pvpAvgMIghdF3Rtlapqz8W1RKJr95uOfAtRJD+LHo7
	 7WEtg/xAY3XwSvnm4O9uAy18cjscr5RgiSLHLIp1AXNo6V9CIGEUfzYJyIU5f+VFU/YSr
	 r38NVK8sr4YC9Jkq6jqtgleu5B1+CjD+PV4XUcKyXMyrSWhrhPryeRZlw4C29v3PsKEs9
	 1tTv0ak1AWD3fZ2HACHsr1BoQWGmcwpAt17IZw/L+vXvkqF+lF5yA/sUx0WBZRo85BYHI
	 BpIJ6aJB7mFIABP1eqJMw5Di4zECWXnJXRTAInSFhnZfnBYhZ82cfqTQ0DiuPY3goDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014001;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=5BgqYWkr5dDEaPyxorYR6MRSFIGspFJ29qovXVtBSKU=;
	b=3Suz8lgMCGhrw09Bsh1fwmjfGuMX5Kqa0woaWooJkKZDpLSgZFWne+xnkMcqjLHJsuHc
	 xtt4WmSNOvq2hwevEs0wvtTznJkY6hBspnZhIrtZomXmarcRRm07Fu2OWdo/jVlQlxRaI
	 A/h5KSrIcu6vGYGEiaD9T7He9r+9X9SmIxIBFuah8SwTu9l5eWa1Pra2+ZIW3ueH9MJ8L
	 NVwL0NE+zuMPBmr2iZMuoz8pqX87hP3zB3Mgsca0/GoLrXt7zndTxxt5Fe3I1R1mK2ybP
	 s+G+Hv9AyAUHAE5qjBw4Ofcov+HNkXJUzwIMdUH+d+fgeN1Dhz6DyBtwT0DgO3TQVcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ytq21vAR;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8+UEmULx;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ytq21vAR;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8+UEmULx;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1003606A334;
	Wed, 18 Nov 2026 15:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1003606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ytq21vAR;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8+UEmULx;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ytq21vAR;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8+UEmULx
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19D6222330;
	Wed, 18 Nov 2026 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5BgqYWkr5dDEaPyxorYR6MRSFIGspFJ29qovXVtBSKU=;
	b=Ytq21vARCYN35FPU9/qs4OuobfZ63l/McaKJve4ur0wSJGj4vqVZsrJhe66upt2ljViwtj
	Gokaqc9OjBDIxyq8wqXhl7pzrwlMvZqopvH7T24y25uYvqz4ovuL55IjHpiKjef6giKLHv
	M7SHbdeybZO8M4qMRH24HcIWHYdGUh8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5BgqYWkr5dDEaPyxorYR6MRSFIGspFJ29qovXVtBSKU=;
	b=8+UEmULxPDalCxGkJ8TkrUvasiirIldjt79VCq25gPRbKHXYr19ASDa0e6Mvy/M9eZCbfh
	EEu1g3Edc1VtZPCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5BgqYWkr5dDEaPyxorYR6MRSFIGspFJ29qovXVtBSKU=;
	b=Ytq21vARCYN35FPU9/qs4OuobfZ63l/McaKJve4ur0wSJGj4vqVZsrJhe66upt2ljViwtj
	Gokaqc9OjBDIxyq8wqXhl7pzrwlMvZqopvH7T24y25uYvqz4ovuL55IjHpiKjef6giKLHv
	M7SHbdeybZO8M4qMRH24HcIWHYdGUh8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5BgqYWkr5dDEaPyxorYR6MRSFIGspFJ29qovXVtBSKU=;
	b=8+UEmULxPDalCxGkJ8TkrUvasiirIldjt79VCq25gPRbKHXYr19ASDa0e6Mvy/M9eZCbfh
	EEu1g3Edc1VtZPCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D555B134E9;
	Wed, 18 Nov 2026 14:59:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gK5WLW69/WqkXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0462E2509F; Wed, 18 Nov 2026 15:59:54 +0100 (CET)
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
Subject: [PATCH 09/13] gfs2: Fix dirtiness checks in gfs2_write_inode() and evict_linked_inode()
Date: Wed, 18 Nov 2026 15:59:43 +0100
Message-ID: <20261118145941.1063127-22-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1351; i=jack@suse.cz; h=from:subject; bh=JUAS52XSvpeUyCESIR6NEVkfaPXelV0p15UKZLgcatI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1kciwdNfITyjGdyuqRw51GfobJyfmDjFytH 02y9FPPDFKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29ZAAKCRCcnaoHP2RA 2YL3CADSy1X5HRqWpQL5OXpARB2z1ddQspe5MRdnZYA6qdIkFNuTYh69dtLkRK+HpVDgzYIeUVn yIw6gsjDBICnajNxKUsJi62anZ49k2Cx/asgX6Ks5xgbpD/jW1g217m42EXXSUleWHP03eO/Txe 0Z06kBr8Aois2PxbyX0/yZKEhXkszDARMKMPNe3nuxv7JhZFHaQjB91j7zliQU7EugP5aY5Ts0F Kqk1P26VcoE9I+jRh0HFWD9meT4BQn8/UI+QH+uVCS9C3QUqANR0pxftRbE9P9V2eGXnwZq5maO w0SgGWsebOd5/YHBtA08Ayp0F1PstN3IJ/Tg50CpTMjtvBrs
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLyaw51ggmke6bkcxeyajg5whq)];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -15.80
X-Spam-Level: 
X-Spam-Flag: NO

The checks are bogus because they check against inode->i_flags instead
of inode->i_state. Use the inode_or_folios_dirty() helper which actually
checks what was intended.

Fixes: 957a7acd46e6 ("gfs2: Remove inode from ordered write list in gfs2_write_inode()")
Fixes: bd67f17718cc ("gfs2: Fix data loss during inode evict")
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

