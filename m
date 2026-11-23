Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424461;
	b=yJVEmtmqr9gIt6BPb6QB68aHk9GRKg4+zGTxZkIf9+CmFFUKGaOJYCM09ZsFzxMRH6OV
	 t0fXx6zmo7cqLB30crNyAMd+iEL0YU2C+XtfmbJJmu3Xq+JNfzgx8OR0gFFvVNyJLMHiA
	 DqIaaBtjY+y2xAN0RAZCRKpt3ZXAIZTQEDgtmPNqpH/DxiIl6P669WIrzwKmX+pxxMy1J
	 EFzXydwFuLBoE46JbtzIv0JRuP0sYVX5VvlrwEr3V+FHolp8kFGuWKjn1Cah4WgeL9dlB
	 9lHwG33nR2w58saPBxYaTm6l/QhQAWDS6lXrPJysFkS2C+ofNMLfvj9Hzws5apT08SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424461;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=a8zsrengfhgHgmOyjOP8qNxo+tyeEA0o95yrwHD9uX2U/ad1jYuOUPpJXOHC1pSVXhgE
	 xd6dmvDIcnMY8AsHeFYIjJyG3JIA1QjTOAZJItX8r2ZmeRjpQLfQZFO8TihPpM+G8NRyE
	 LDHQXl+HWGyUZPsO4AAsazWwzDNEdg0T8b4Vz6IMwfxT4vX2Sfula93EAl/9ssVmsOpjG
	 ukeSIt/acIUfS98ZnGu4VfJ7DXtAcvLGt7GDnYzKz6t2jH0fDKSQJFqjlwxVcB/fqAQzC
	 OSiVTbArmRyI4Oq+ltlG/MVvgZp2mCHctPNa7NKdqIwIsyEV21L+6TjN9b1YrN4TRRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uVEa7Dm6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1iQhSmiK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uVEa7Dm6;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1iQhSmiK;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4C0606A692;
	Mon, 23 Nov 2026 09:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A4C0606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uVEa7Dm6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1iQhSmiK;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uVEa7Dm6;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1iQhSmiK
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD8C5220AE;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=uVEa7Dm6WOWIWsz8LsQaMUx09RK9P8MXFaj8zpgtdXQZ9ygwfXX0SS+PB/BcTWXZf5mSkx
	fzVIvPpp3YRSlUNskgmYe8TR2crub54hv31vwY0knQTZkA4ZyS03m0U+bXJ3Oki0xAUA+0
	rls6ZSxS5QJ32fWpqSFiCzDgjqB7rCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=1iQhSmiKMvXvBG1AWOH7sRKrDEwJ1PGzDL6+2bkqsF8fEEnnP41r3vFVTmJMxcrDq+53Js
	x0DDag6Y2OP7GzCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=uVEa7Dm6WOWIWsz8LsQaMUx09RK9P8MXFaj8zpgtdXQZ9ygwfXX0SS+PB/BcTWXZf5mSkx
	fzVIvPpp3YRSlUNskgmYe8TR2crub54hv31vwY0knQTZkA4ZyS03m0U+bXJ3Oki0xAUA+0
	rls6ZSxS5QJ32fWpqSFiCzDgjqB7rCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Thsl6lkuOVFQSpa8YxgCbTQQEMiai8fOM04i9JLgUgc=;
	b=1iQhSmiKMvXvBG1AWOH7sRKrDEwJ1PGzDL6+2bkqsF8fEEnnP41r3vFVTmJMxcrDq+53Js
	x0DDag6Y2OP7GzCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84F9C139D0;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tYkzGMoABGsABwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:00:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 8BF692760E; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
Subject: [PATCH v3 11/13] nfsd: Use inode_or_folios_dirty() for dirtiness check in wait_for_concurrent_writes()
Date: Mon, 23 Nov 2026 10:00:46 +0100
Message-ID: <20261123090040.19006-24-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=967; i=jack@suse.cz; h=from:subject; bh=cYIvrjsiNKxiZPqGAovv6JqrD7CM1UBMeWeAmEJiYA8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBADBvYiDz5CLiR+xnAcc3/FsOEmPn/Lc1PIWm Wad05vv352JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAwQAKCRCcnaoHP2RA 2TwRB/wNYFdS3db44kQZ+0BWuK3ZE4g51r7BcfPOUY/rk3cOPVrvrcxQpLRQNmDaKQrMgWfWy23 xm/ORk7Dn7eK1sEKdHpZFH6oSJc6laDPhovlA8q0t1hdG39o5/867aS/bWvn1e9MJNr9dJD1rie 7vR34dCATvcTL99l7pGqIVWUyXIRsWYJ0vHhLgis48YfF6M8Xb06pMyY5iTlBB87X63mLE+VFHW K0BThRb1YNr3fhhbk+IKz9LEeTg4deiEpnM7CEi2ZpYRCE58/FzmswF+zMG5uAavjcjvvuWwo27 IMp9do4PlMkj/iQtyR8vkyUSO2lQ3RuXx7QygsDGsEJA5ZfA
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -15.80
X-Spam-Level: 
X-Spam-Flag: NO

The check for dirtiness in wait_for_concurrent_writes() is racy because
I_DIRTY_PAGES flag can be temporarily cleared by
__writeback_single_inode(). Use inode_or_folios_dirty() helper to avoid
that. This also makes sure inode timestamps properly persisted when
lazytime is enabled.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/nfsd/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 56c49b5bc5bb..a314ca39272f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1249,7 +1249,7 @@ static int wait_for_concurrent_writes(struct file *file)
 		dprintk("nfsd: write resume %d\n", task_pid_nr(current));
 	}
 
-	if (inode_state_read_once(inode) & I_DIRTY) {
+	if (inode_or_folios_dirty(inode)) {
 		dprintk("nfsd: write sync %d\n", task_pid_nr(current));
 		err = vfs_fsync(file, 0);
 	}
-- 
2.53.0

