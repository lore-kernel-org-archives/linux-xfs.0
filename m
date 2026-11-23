Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424464;
	b=xqILxWApRmtTZezhPj6DMi8e05y1mTPeG7BINATykCfSSIX20gHtmA/kTVNvSM46Z6US
	 +DIzYVV8AhRioZDx0O0vSbx73lNqjLULbDMZPg/7ykEqL9peCJsMspIlrw/Zbc7da0I7C
	 OjRUYcLbqtgu4cZz693fGYyD+ztt3QmVLMlCmCECRKhjFAHeo1z8N9C2ovHuvkw7lZ7DK
	 mi8jrGCmpY3s3Rfo02gMhBAF3AzH7nmJ5SCgC/QqxbaHa69ZGRD2kzjelBfeFYwHcQEb9
	 meZwLQXAHosHvTyDM7G3CTBkgzZJEZ6I8W9cfSzXspmAK6s7trbn6Kxn2Sqll2n7Rvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424464;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=DMrHi2IMDf/J6GCKlnmVAoN0n1+oBY+s12QVYLLP5LyXB9N4JadBOZAlwYFAaNTtHpPE
	 XL6VWyIhjfZ62NOIPR9GZtmmM1JCf/iyaWrNikQHw/q0yqWWpDM8X9/ZzOAuKUA/G056r
	 xInCz1s6Rlm6LWiDgxzXTVvGTN/dVxvyDt3KmFqNlSpL7649NMnQ5p8tyLvQzEkAx7zzj
	 FW4CjTrbEiYSeggU98tNXIR8hgNL6fI6ImqYp4PwCbULwEVcbmwyKiT9vNcxOxI3MUDi5
	 8EVkO4L/HCS0cVS9aTysqM6F7n9mrySwWTFFJahEbt2VU6YpMaLIImnza90CTOH7IkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=a1kFkkXS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yREDWJzt;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=a1kFkkXS;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yREDWJzt;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113F2606A6AF;
	Mon, 23 Nov 2026 09:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 113F2606A6AF
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=a1kFkkXS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yREDWJzt;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=a1kFkkXS;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yREDWJzt
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 979711F82E;
	Mon, 23 Nov 2026 09:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=a1kFkkXS6n6Ulh2EhKFCTOalxE58TIbM3pLMhErOhDM1ZJh8Cwkj/Jqy0PnxfhYBMow+Nv
	ltqPyHKiHEF7fIyJaMb20x7f0wSFVgnIPwpQAE20vaZ3eZKbQYxu76+V7gOusxFQPStA/8
	W/FjmMa+aLxDM4jbTeJY47X18jEH7vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=yREDWJzt7ktwTPxbwyLWqfaQ8M8K+pLDnpnGD6keMbZO7GIB4+Cu2PcGL8UmG8IMOWl6rc
	Af9WCDSv35D2P9DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=a1kFkkXS6n6Ulh2EhKFCTOalxE58TIbM3pLMhErOhDM1ZJh8Cwkj/Jqy0PnxfhYBMow+Nv
	ltqPyHKiHEF7fIyJaMb20x7f0wSFVgnIPwpQAE20vaZ3eZKbQYxu76+V7gOusxFQPStA/8
	W/FjmMa+aLxDM4jbTeJY47X18jEH7vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmtgyvlcoco63cjpiS7pBzWifacKy+9MGY1FIRs7ge8=;
	b=yREDWJzt7ktwTPxbwyLWqfaQ8M8K+pLDnpnGD6keMbZO7GIB4+Cu2PcGL8UmG8IMOWl6rc
	Af9WCDSv35D2P9DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 760841352B;
	Mon, 23 Nov 2026 09:01:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SBSRFs4ABGsVBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:01:02 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 9168427610; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
Subject: [PATCH v3 12/13] fscrypt: Use inode_or_folios_dirty() instead of explicit state check
Date: Mon, 23 Nov 2026 10:00:47 +0100
Message-ID: <20261123090040.19006-25-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=719; i=jack@suse.cz; h=from:subject; bh=FMLwmEIo3Jn+kxzPFnZc8LhNnipFkY3Bc7bC/iC2Ncw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBADCeJphD0clnEX4nMNjKhoUbG1H4Fuqr/Knz VDsqwpscFqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAwgAKCRCcnaoHP2RA 2SE7B/9SjePb3Ea8II0EG/clVH2bLbB4umvHRwcDUP1/lR9wuiOIwbr1NVbK49AY3SvMxMxrgRe kV5huAjcKV73Wn/HE+jjhsCodVnEruaOs3nYMPlvWkUejK/uJD1JaBil9miQ8fPdli161E2UqQQ xFARQldAgteVldlDMN3m/scpztGHMg1zTRbaGc/SYQWOBuxCn7Z1zcMeXy/WbHC5mqJR/Th2+ND Nuqtzc8HZOHt1UTKvAOD0DxRUIi/n7HYUU64SsFojSO80rW1f33F6OuV6VImsZ1ZujjFq5GlumJ SQ2AxQyrbV5cjO5TmXek5EvbNpZ/SnU+giDQj1EpTrgxJVFJ
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

Use inode_or_folios_dirty() helper instead of explicit inode state
check. No functional change.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/crypto/keysetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index a77b889d7578..1cd40663b251 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -839,7 +839,7 @@ int fscrypt_drop_inode(struct inode *inode)
 	 * userspace is still using the files, inodes can be dirtied between
 	 * then and now.  We mustn't lose any writes, so skip dirty inodes here.
 	 */
-	if (inode_state_read(inode) & I_DIRTY_ALL)
+	if (inode_or_folios_dirty(inode))
 		return 0;
 
 	/*
-- 
2.53.0

