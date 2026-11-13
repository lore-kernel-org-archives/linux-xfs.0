Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559665;
	b=Km7uL/daa67ksaxLlP1QD+4eAW26B8+yxlF1pXIJuzI+0hSl7weJzg/MDWcul5jQbeek
	 4WNdUSfY3zzazcL7DNxbz6J595U2c1RubUG7O5fEffTNonNhf3I4TmZQRK/jpRrIcBRiB
	 nYQZn0/UxUzCO+oh/IWxkk4CV7+gXIv6e2pPOC8B8a8xlSI84foRXNFmHiHcFnYPKuPtn
	 Jz2HrE6U9cPW7NmeP94ay5NFNVQ1xtuIzOKkRxfSCoylMbxaYNsljt+B01Po2xwBQcOIr
	 dG3+wbRDbE1aJB8cOSD91QjL9XTZpL3lIR+HOmIT/dSQLlKWrj6LGivHDCBoqkgy0+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559665;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=6RcxWg+VNIX8+XsK7mGJgNjvUHrjRXmWMJ6Gaak6N9g=;
	b=cpP8YfhISr0q7i/cUM3w4T1Hyz5e0L5buz+0T4GHVpmlb2xOqpCoicpeVsomp0INGIUG
	 w/rbIfGEx7qLuBTw3H0FFxedlyRNN6R6SgwgiACcc7iMqxERhxsdZbXTGQaqmLbe3dwb0
	 EC2NyByzCW+Xfawghw0zhAvIDX0/hbWhk9jFsnXtgz9YxxwGAhvpsX+bLVvBxi2kUjPOp
	 0cYDbN17rjlE5kOsZkQOs57PPIDEvMyTZvU3i7jPdpBadpHJ9EoodOeolD7dXjdZDszzg
	 RdJwWZQwJK6xx/Wv8v0qd+nQUR9LjU+PlR2JjC7Kfygaf+hEKZiX3UgjwqDPAbJP2kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p2T6cmZM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iMKXRHIQ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p2T6cmZM;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iMKXRHIQ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD5D606B35F;
	Fri, 13 Nov 2026 08:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBD5D606B35F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p2T6cmZM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iMKXRHIQ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p2T6cmZM;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iMKXRHIQ
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3740C22229;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RcxWg+VNIX8+XsK7mGJgNjvUHrjRXmWMJ6Gaak6N9g=;
	b=p2T6cmZM+oLaydtNdDp9veN3DeTJg6wiR2SIg3cAUJjbxWv4nJIfKY0QJJUZuQFdmhR+P/
	ebfZOoAE/Ev4mqumgZ8h6a3jmt4UJnoQ2q7wcK4SVPOgfKP/XC6scLvxLUFXysvQ5CBekv
	rXbxa0z/W4LPufhmObrQXtT8ERH/ng4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RcxWg+VNIX8+XsK7mGJgNjvUHrjRXmWMJ6Gaak6N9g=;
	b=iMKXRHIQ9XkLvFFO3bkO60s2BJDhcV5uCoOjptggwko4twuPoX64ko4Pk9saxMruYBqXWG
	gahPSgJIoU08D6CQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p2T6cmZM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iMKXRHIQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RcxWg+VNIX8+XsK7mGJgNjvUHrjRXmWMJ6Gaak6N9g=;
	b=p2T6cmZM+oLaydtNdDp9veN3DeTJg6wiR2SIg3cAUJjbxWv4nJIfKY0QJJUZuQFdmhR+P/
	ebfZOoAE/Ev4mqumgZ8h6a3jmt4UJnoQ2q7wcK4SVPOgfKP/XC6scLvxLUFXysvQ5CBekv
	rXbxa0z/W4LPufhmObrQXtT8ERH/ng4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RcxWg+VNIX8+XsK7mGJgNjvUHrjRXmWMJ6Gaak6N9g=;
	b=iMKXRHIQ9XkLvFFO3bkO60s2BJDhcV5uCoOjptggwko4twuPoX64ko4Pk9saxMruYBqXWG
	gahPSgJIoU08D6CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0CDE13516;
	Fri, 13 Nov 2026 08:47:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PRxDLK7O9mqMFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 08:47:42 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 27C5E22C2E; Fri, 13 Nov 2026 09:47:42 +0100 (CET)
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
Subject: [PATCH 03/13] orangefs: Check PAGECACHE_TAG_DIRTY instead of I_DIRTY_PAGES inode state
Date: Fri, 13 Nov 2026 09:47:03 +0100
Message-ID: <20261113084700.739002-16-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1851; i=jack@suse.cz; h=from:subject; bh=Qg6paIpRmdoc51ruf7pUBhSwnRMQQ/P9xxdUTZcJVcw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq9s6GSt8f88LyKpBCH8mV2gd5d4KlCJYJL+E12 59BdENIj4yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCavbOhgAKCRCcnaoHP2RA 2SedCACmIj5ss6ykbgKk8qGdtOXF2yuDM53FGdPSxUragzPmPvNBLVyZeMjr4G/LAsfHygmVj61 d8RcBvygq6eDI/OXUvBcQpFfAHvXBnV8twu79qUYvZRHkhwDroh1wl7PCajCQOHa5XRByln3Zqo mKIMt3P7p0bN/i7Tf++K4BcouVaGMMjR2E2hK+6t+MPTUOusC57SpPx9szPy1EuIbQeoaeB8hxc tNPYTaE00/ew2X20cUID+bzYdNUroJvjH7SwVi1J5HL0m53GDsctRvmSQrNts79EuXzKHrkVryP jnUTFPqnHfj0jltjISffQUOJPFycAQAh7n1Cge4xL0DAgQ3b
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3740C22229
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_RATELIMIT(0.00)[to_ip_from(RL51pwup9t9rrf6fhpcri3z6a5)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -12.01

PAGECACHE_TAG_DIRTY is the authoritative source of dirty folios present
in the mapping. Use that instead of looking at I_DIRTY_PAGES inode state
which can get stale (e.g. when folios are written directly with
filemap_fdatawrite()).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/orangefs/orangefs-utils.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/orangefs/orangefs-utils.c b/fs/orangefs/orangefs-utils.c
index 9ab1119ebd28..4c4036f470cd 100644
--- a/fs/orangefs/orangefs-utils.c
+++ b/fs/orangefs/orangefs-utils.c
@@ -247,7 +247,8 @@ int orangefs_inode_getattr(struct inode *inode, int flags)
 	spin_lock(&inode->i_lock);
 	/* Must have all the attributes in the mask and be within cache time. */
 	if ((!flags && time_before(jiffies, orangefs_inode->getattr_time)) ||
-	    orangefs_inode->attr_valid || inode_state_read(inode) & I_DIRTY_PAGES) {
+	    orangefs_inode->attr_valid ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 		if (orangefs_inode->attr_valid) {
 			spin_unlock(&inode->i_lock);
 			write_inode_now(inode, 1);
@@ -281,13 +282,14 @@ int orangefs_inode_getattr(struct inode *inode, int flags)
 	spin_lock(&inode->i_lock);
 	/* Must have all the attributes in the mask and be within cache time. */
 	if ((!flags && time_before(jiffies, orangefs_inode->getattr_time)) ||
-	    orangefs_inode->attr_valid || inode_state_read(inode) & I_DIRTY_PAGES) {
+	    orangefs_inode->attr_valid ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 		if (orangefs_inode->attr_valid) {
 			spin_unlock(&inode->i_lock);
 			write_inode_now(inode, 1);
 			goto again2;
 		}
-		if (inode_state_read(inode) & I_DIRTY_PAGES) {
+		if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 			ret = 0;
 			goto out_unlock;
 		}
-- 
2.53.0

