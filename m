Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424465;
	b=SFY+RoynyZJhd/Jn74PdajEP0ehDvwHxnwtNuMR7lXhjndpeOk6NDHbnQ/yzu/KAoyq4
	 wBR4FcXOPNjxHVJckwNRcR9o5/IoQKY7kbS/PpRayXXXvqhjs4uzWF3ns6h5SUwjbTmXc
	 kQGP0zoodvRQbVS6MbQa77oucwRdh9id/dVhTh6NFbmdWV2L3mmLb6wrX4QBvPeylEEeA
	 Ro0Mj9mged0i+Vd/Ij8FtVw1zQRFysinbitMmRK9VUdgmeBDCbPAuJrgVXeNC01uvKcvN
	 DDI1jy+SHvtY9qSrZwrGQw0oN+4eirgP5bt9dy2zB4br0AecBY0JyNSLiG93bY7wTMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424465;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=Jp8Bf6/C7qzSRkDIS67w9/8cYQC1IS1l8hdUpK+q58U=;
	b=nRLLxVIL66m4a3So6uvsX3R+GaL5ZVuYreloxbh01ls3j+riPphGxFCuaHm/5EHle5XV
	 RsHHop8fhJ0DMl35m+AdbQ11m7WLzhwA49BAdWgLG9gGqirFfrVim6D9lNQZjOB8FoE42
	 ZCSrxJim+SDjHnaqi9R1jB/uV2sRqJTNuu7JnEeJk4YihgjiMKBxbR16CbEDG4vch7JL2
	 EDEDDnbHptLr0lx6DOtW6OwQ+b+/sveF8amI8dZDvITscny3uH+kBF3SiV783txn+qzXV
	 eqhCkeXJxrfhHwYdhHXkPG4Jqj4Ky3j9AJG5zJDvz0Fr/bfetvLq3qX6EQjxGdRYZCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2iCqFKvd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Wt+fPbUr;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2iCqFKvd;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Wt+fPbUr;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8457C606A6A0;
	Mon, 23 Nov 2026 09:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8457C606A6A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2iCqFKvd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Wt+fPbUr;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2iCqFKvd;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Wt+fPbUr
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE1031F833;
	Mon, 23 Nov 2026 09:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jp8Bf6/C7qzSRkDIS67w9/8cYQC1IS1l8hdUpK+q58U=;
	b=2iCqFKvd1hEcpS6PHDD4s0xoXL+iSrf2leX6zYvDIjXPRy18GBzpZ1VP5/Ou1PN1xdXkTF
	UZHYByga/n9hpSW73+v1NUOkhoOjDtqgrPuckKiCS++emVlFuIcjLceeED1E8qYQpXPGMe
	SdGURoPRNK+sNCw4GDrnHYznTED71No=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jp8Bf6/C7qzSRkDIS67w9/8cYQC1IS1l8hdUpK+q58U=;
	b=Wt+fPbUrzj2LE8o+ueS/DACOiWtj5cYwD4JUnaB3oewXRtVzHb1oXc/sF7vbi/j+4Vws9J
	qKeCxExq45U3JxBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jp8Bf6/C7qzSRkDIS67w9/8cYQC1IS1l8hdUpK+q58U=;
	b=2iCqFKvd1hEcpS6PHDD4s0xoXL+iSrf2leX6zYvDIjXPRy18GBzpZ1VP5/Ou1PN1xdXkTF
	UZHYByga/n9hpSW73+v1NUOkhoOjDtqgrPuckKiCS++emVlFuIcjLceeED1E8qYQpXPGMe
	SdGURoPRNK+sNCw4GDrnHYznTED71No=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jp8Bf6/C7qzSRkDIS67w9/8cYQC1IS1l8hdUpK+q58U=;
	b=Wt+fPbUrzj2LE8o+ueS/DACOiWtj5cYwD4JUnaB3oewXRtVzHb1oXc/sF7vbi/j+4Vws9J
	qKeCxExq45U3JxBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B53513532;
	Mon, 23 Nov 2026 09:01:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r4j3Gc4ABGsXBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:01:02 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 9765827612; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
Subject: [PATCH v3 13/13] fs: Use inode_or_folios_dirty() in __inode_lru_list_add()
Date: Mon, 23 Nov 2026 10:00:48 +0100
Message-ID: <20261123090040.19006-26-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=755; i=jack@suse.cz; h=from:subject; bh=8YjGys7j0AZPC+xTuLBhes4R3hdR8y5UBwcvGhQGyuM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBADDw36xnBrH5xG73VlTHqBQWHyHrFmP8Rknh e7OYuEfA7uJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAwwAKCRCcnaoHP2RA 2QkcB/9PmMzUHOosNS7Ohyn2Xj4zuV+8xX1MTraRFQcKlUXPWO8+hgRk1oatGiOauY6v3stljDj xtSwgD8LqlJ00Uwu2ez5cohsi3Br8DPma4iJP2mCbdavzIeOyj5mbcJDIHP4bXlKyE+YVXcXePh R/VCDz4bK+CUA3ANFI5jHGIXRKtv1+QHtbxU+GQTIh8zcHOqjuB6Z4XqQ9YS7ar252r/Y3/mdtO dLbVOmH6IbvELfYuYMm1YsFvMYAmfHSfErq1cZOdTQlp9WNYjKJ1rtLsFoTvW7QekchpZxtzBBV VkBnuo2YKY+UJfcOOOD+of8AY83TrZ3UaT8un85SUTR758xt
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
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

Use inode_or_folios_dirty() helper instead of explicit i_state check in
__inode_lru_list_add(). No functional change.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index f63535ee3629..73afa57fe385 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -552,7 +552,9 @@ static void __inode_lru_list_add(struct inode *inode, bool rotate)
 {
 	lockdep_assert_held(&inode->i_lock);
 
-	if (inode_state_read(inode) & (I_DIRTY_ALL | I_SYNC | I_FREEING | I_WILL_FREE))
+	if (inode_state_read(inode) & (I_SYNC | I_FREEING | I_WILL_FREE))
+		return;
+	if (inode_or_folios_dirty(inode))
 		return;
 	if (icount_read(inode))
 		return;
-- 
2.53.0

