Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559668;
	b=wLyBI9GHJN0+NpluG6fdTpxLBu9J6QN8dtdjVVhkVVlvpaRkySIs/D76MwFv5QgnhXY3
	 v66j4IPHvQDca+gX42gTxUdshOMVuvsLgQjm1dLqCJizdIzerUm18VDkurtnqtxPtP5yT
	 eTcpIOUI4I9wwCet+Nj010jNCy+iGowogwRKo/LA5LtZ5YeEMO6j4hhC8Xjvvch8lS2fO
	 V2Zcr1ia1d6heFUA7SIQgI/bqYIs6mrXZ2ppJRkGS4OoKq71vtW+aeLu7OZyfMAE1HLtj
	 bb5v9ZbrvMbkHHizOgIXCpCG5/Vg3WUH/Q4foYspaM+/hII6mYrTC9fidjZ5yPyXV5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559668;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=vjoVU8HmWEIlN7Ms7bUAFVaqkulzQzBGl4EFHgqPzLnk+81YvsIok4+YuFOPQqzdhKzv
	 /6mQcTRFYQNewPkzgWyyojrph+GD2EqbwnUXJdF3sMeU+GOwXsNu53GwLAq/0gr+p6dTp
	 CQ1302Okim27mQtVRHuWeBOO0srolMiOON7FLvH+GYwnPJ649gDzVa2v5pK3zciE7UBlm
	 NTXAa+U02GtUamfIVqytxPWYXodc7qi8YJ0WpBNLQzkwW4O5mtBJ9f6gzdC5soD1E4ChH
	 +NYMftN0b9XG+oBBHspsmObEn/JmlWcG1d8UT58Mdo0UBG/kzdKbTsPjk2koQcSNGWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=q7SQd6qY;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/ia6cCWv";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=q7SQd6qY;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/ia6cCWv";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2118060A5BE7;
	Fri, 13 Nov 2026 08:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2118060A5BE7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=q7SQd6qY;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/ia6cCWv;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=q7SQd6qY;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/ia6cCWv
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95CCA2222F;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=q7SQd6qYPppgGx1RvNN1Prl8+SsTO+als1KWI6pOHDI7+X+Z/D7oK7FEBaAro4V4H0OZy8
	IdB3FWyrk1h+250JnL0eXFEH1hVX2F6DV07rMQYJFAZQmvY+3u3k45Wkj25T2N2hFgZC5p
	x19ZJki+PWoxpFf5/yAG24prbHOrwqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=/ia6cCWvBQp47vCTYHP9e1EqTiOEGKSlJx4eEoC6Xj0+yYMav3p+e9unR2Fd8Qd+Z64ugq
	fVSIVD1JvQgfKzAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q7SQd6qY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/ia6cCWv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=q7SQd6qYPppgGx1RvNN1Prl8+SsTO+als1KWI6pOHDI7+X+Z/D7oK7FEBaAro4V4H0OZy8
	IdB3FWyrk1h+250JnL0eXFEH1hVX2F6DV07rMQYJFAZQmvY+3u3k45Wkj25T2N2hFgZC5p
	x19ZJki+PWoxpFf5/yAG24prbHOrwqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gC+WTNqo3zddo1hQ6r2uM40CkmOnnZwNP+h9kAciQTI=;
	b=/ia6cCWvBQp47vCTYHP9e1EqTiOEGKSlJx4eEoC6Xj0+yYMav3p+e9unR2Fd8Qd+Z64ugq
	fVSIVD1JvQgfKzAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 476F6134F4;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3UzgB6/O9mqfFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 08:47:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 5493E22C3C; Fri, 13 Nov 2026 09:47:42 +0100 (CET)
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
Date: Fri, 13 Nov 2026 09:47:10 +0100
Message-ID: <20261113084700.739002-23-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1012; i=jack@suse.cz; h=from:subject; bh=A3fwFrLxq2sLtsoLLFywsEZVT5HTyxLWIrwzaeggONU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq9s6M37ZIR6z9fsTw8rPMt+C+UFIW26BkL5FQl qYWaDW7412JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCavbOjAAKCRCcnaoHP2RA 2fOnB/9N0DhMFFgBL3K16hxLT7UKoCMqPWk1QFkZRZd6CtvUw+QeAUhA636lPh7IGwEqK3ztO42 YRS8nKRUzDs/WowxxMJ00UlwAokjxFeBgRtlH2B4xkl7qsrcUkM850G1Agh+fJfoJ1gVAV5S5Ve y+tGq7gZk0UjBbqQsIVArBBkqPw+qgzHtJsRNyTBc4QN4F+0cKs4Hs4Du+PJhvbMSJkYm1jvQY/ sBBqbHRmd5J+SlmUEQRPntBybPCyTutNsnNd01xNMOZrP5yGyLUPEWLjOykG/piacYDpnYWRRa0 KFVhPqwTwSpiDmnHsbnSuVadyFxktjJIyWGZ99LgnH1Vrd0l
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95CCA2222F
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RL51pwup9t9rrf6fhpcri3z6a5)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -12.01

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

