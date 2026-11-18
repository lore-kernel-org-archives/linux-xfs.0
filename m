Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013997;
	b=5s4VbuEGkVLFQW/5WMcmmV8ZVGavOVCNjrtNEoj9j4muSxcNBc95W71FVvxwt7ApLXPv
	 ZvrhHJIIj92oxpT51rI8HRyfTiO01Ah8XpgPF3eggU3+Bla6zLbcggfhupNDWR6boYFbL
	 P2miU4IbleNN031jPGusyAoGbv9lst4L4OAu8ipF6+4/lqae22niSQpicD5fdBWOKIFDg
	 UaQ6J06rM00rimAyZl6idcxEbqqyboijMuEcymAwe1AjHC0S8uzQ6GOnA+PGzMCAZP8GH
	 oDKZgatxvBVZBNw0GTNOk5+0Pa9vH08lY2Ua7SaN2apTKIzKV4Ic/u9VqdgwZg4KCMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013997;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=mYJA3GQ8n1ruKT8gf4nwKvyMAl17qgrGJsQrFim7ex1anmMP5Mz5rWA4Uhtomi8QTg6Z
	 2ZgbhMXcmVZeI3jKDllitQ1Yk0Lc4geDfvzePMgdavUpsvtDBA4meAHBhBNnPBdkx1ySf
	 NlF/VeegDKBtSSr6x0PEDmL5WBfencPEDqtoFSXcgGw1hZwtre7zqcxNfLjVHBzZM3x5B
	 9w8wecJffxwZpnhebZSWtu0n0OJWqIngfwwdXTZDp2o0RtKe5Z5on8sNlW7hmGTehJwuy
	 Dcfi+LQD+m1G+Bg2SWLeFxm6WkksdzCPgqc4RruJe4aSNhnOjphI7uUbLHrZdRBRU5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tSK36OE9;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yg2Ni58S;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tSK36OE9;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yg2Ni58S;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F41606A330;
	Wed, 18 Nov 2026 14:59:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6F41606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tSK36OE9;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yg2Ni58S;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tSK36OE9;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yg2Ni58S
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1FE42233D;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=tSK36OE9v7SyI2HI5hUXQxNCJ5O2xf+YfrZO22BNwpmeaRTxWeJHN0UKjSiZtmcaxRDFeu
	M7cMVve+dldAytEavPMj3GCmhZUFJ7tWnxed2u5kyfDQY2KjMKd0AOfTYigwD0Ca7lhJbG
	IYC81yrCqHK4eQCGUAfMt27yg9qTPco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013995;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=yg2Ni58Sip3AkJDVvE/mUm2c+DZ5cVgirzssCJtcO7elDL568xTUhZB3WCfHOUbYMa9Azo
	PApu2f04XwvHCnBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=tSK36OE9v7SyI2HI5hUXQxNCJ5O2xf+YfrZO22BNwpmeaRTxWeJHN0UKjSiZtmcaxRDFeu
	M7cMVve+dldAytEavPMj3GCmhZUFJ7tWnxed2u5kyfDQY2KjMKd0AOfTYigwD0Ca7lhJbG
	IYC81yrCqHK4eQCGUAfMt27yg9qTPco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013995;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z98a10fHzT++6ngZEHshG/H2z2HCNkc0ofB6cf23iao=;
	b=yg2Ni58Sip3AkJDVvE/mUm2c+DZ5cVgirzssCJtcO7elDL568xTUhZB3WCfHOUbYMa9Azo
	PApu2f04XwvHCnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF69B13510;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3dApIWq9/WqRXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D818825095; Wed, 18 Nov 2026 15:59:53 +0100 (CET)
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
Date: Wed, 18 Nov 2026 15:59:38 +0100
Message-ID: <20261118145941.1063127-17-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=953; i=jack@suse.cz; h=from:subject; bh=xOmo84WJOisQVAhQnOPGQkdou8zuAdb6TcwawJJufqw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1ff2G0M3LorDLP5OvjOgq4WAHvSsH554SUA qj6hLx64miJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29XwAKCRCcnaoHP2RA 2T5UB/9KJvhtw82D4mMQM54eKUuWbi9R83u4lELKEiH2F36FZd1r/AgFBX/9uQH4TTOJWHvKR7+ KfH/WOJ5T6kHoxPWqjLH3t7X2aUSKI2ncqkAFvbuxfs9mSBXmY/i9BZF9iuvv2mYsmkXoPqEHGe poSy22BuVH7SzXrFekCl7fzP6XuPcdzqHCtSslMd7blK+ngogp4qTRNKJ9wDVrdRWCMdMJ+QCsu mmZU6tvK8LNi3rT3015YXEU5rrpFlDu5A5CmW1aiJcUspRfTNoiMTHjzUFtVMDpqBDrwmNJOinh KSNxq4iJHwqJlaEwPAwWdJO2bgJfd+umAUs4bkZj0shiAL3/
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -15.80

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

