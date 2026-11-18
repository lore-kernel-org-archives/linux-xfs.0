Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013997;
	b=OFe6EMZyEfnyaTTO43H5DKAI9z0hjHs7nIKh8lNpe0cEf57zM3s++fFQzRBhVSrH9S4q
	 jMQhIvRdAqLRGXFsCYsMhA2EO4ujgc81GEJBfydluMQAlyfBdJsUZVyOmHUhRw2gKtaZK
	 54riQc2xRsL9g6qQQFR6imPKM/wqw2TjYyYZ6uWThGUpR+CIqO+kC/WerPWDFXdGk5wnh
	 GEB+YoxPgcYjwOD1sS/I6XSC7kWZd86C1gNTaYTylJhziSgZJX3wzKVL0V3tIB/H/j08F
	 WX3ZsmopsJdjJBdgMIsEVaPVzlA5D7hsdNrWxp/C4ew8bqdpPYxOAd5B2tEvznJ8P6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013997;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=XFDOLbeibPZWrEjO0KvT8p2cenRiQma2CJuLktIIqUw=;
	b=Mww1DZ1b+QH8Ft+otvIx6i0YZOixM7LKkS2TjoQ2wp7HPXlK0TTERYhTcgyZ2CdjkCTZ
	 0t+SfWTTjBdaYiZxj61kxgHHgMHqT5rmXWUxpBIqUhwlRAkNgzHxmGV1CUlOsFUcZwRa4
	 7DLyp2BPyHeGIOgobC8L2F6ukpXApp7sSlAeliNJ9r0PrktyDWGoA63ixPzLNTotuYxgA
	 +TiHn+3fWHsqaVwUbNXToHPOWbGEwO/bfB2ZVirex4UnTZ6DMjVmnCID2PXCPwumalU4o
	 pNWKLR0TkgxYo8L0BzxuVEcEt1vZZ497knsFteEgW8pQa/V6pGvEXq02xZ5o5L34hJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nAMWne3k;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kxva213d;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="zV/tnQd/";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6o3oCFoz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0B1606A33D;
	Wed, 18 Nov 2026 14:59:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF0B1606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nAMWne3k;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kxva213d;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zV/tnQd/;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6o3oCFoz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA03A1F7E3;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDOLbeibPZWrEjO0KvT8p2cenRiQma2CJuLktIIqUw=;
	b=nAMWne3ktBlHt7PpruJPZUHQERGJxYaunnLT7tgsCvpYFuHykLRVm96ivsggg5NZzywe4T
	RcfvumQw2j9B59goQw/p/ciC8dSmVe/721RfZ0D2cWkGknN0UQatMWqnqMow3EoKhuTkhT
	12M2KyvaD7rCTqEKihd/HeSXQPGd3Aw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013995;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDOLbeibPZWrEjO0KvT8p2cenRiQma2CJuLktIIqUw=;
	b=kxva213dWMSKaWAWnehXrtPL0R0BC37qPBVOnkvHLwOOY927YIizIWOgWFhHDVDpZlrutn
	tlIDBNIGrEBxT+Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDOLbeibPZWrEjO0KvT8p2cenRiQma2CJuLktIIqUw=;
	b=zV/tnQd/yC4IxLVlLWPyizbfNJxCZlj3pw+18Qa9s0DRI9MEF0fExM7fItsAzXtvusahYd
	pVqGbUn2Es82jvE+e2kHyz1EFvFonzhfMCQznNRkuPXzllfqwpaAcpkm8KWslRfU3N37yx
	pM//5VN8hsSb954fP5FQRQiWhRkxqCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDOLbeibPZWrEjO0KvT8p2cenRiQma2CJuLktIIqUw=;
	b=6o3oCFozXfFCdOQ2tE6G7Qh+gbVPslhfaQlBGuVCJjzyhUiipY2MymZBcIDlY6e48NS9BV
	4rtFqflKc5xdn9Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76F9213507;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wUvbFGq9/WqKXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CAEB425091; Wed, 18 Nov 2026 15:59:53 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 02/13] xfs: Drop pointless I_DIRTY_PAGES check in xfs_can_free_cowblocks()
Date: Wed, 18 Nov 2026 15:59:36 +0100
Message-ID: <20261118145941.1063127-15-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1028; i=jack@suse.cz; h=from:subject; bh=Y0SDc1WFQmniLZEatIiIPOkHzzDXirzGTDP0nvvh6BU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1eCZMEkmwVjOdW+1uuGzIuT9jEa725b3F1L E/kBjpMzDiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29XgAKCRCcnaoHP2RA 2bq+B/9ofbwLafT3nTN0pOgQzTd/wbO/ngOKwiuM6xcAOO/60oaTB9ycf97Wp5SElc60nqf9Ze6 bwab2dvXtNdD8bVpYZyvlP39s4gHI2YqzGWlEAApyEg3k7hLQNBe2JgdOxE7iKExHN8tsn/oERh R77mTucEusts+kWwlVNeJ6BzA7zCVvF+CJec0mGIkqXdKUmZf1jgm5Gtg55cuh1BpVePJVY/nzL 5/WT++3+iLd3GO+/pfbzlxDcVLUsv0LX0fzygfKFIUp+QwVVl5EEVN+vudePAzQiybBH9+0sHeX ohPGmEhSxgbPx6CkUTz2/K6fnY/0NrnWSRi3nm1T3XaBstil
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
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

PAGECACHE_TAG_DIRTY is the authoritative source of information about any
folio being dirty in the mapping. I_DIRTY_PAGES is just an approximation
used by writeback code that can get stale under certain situations. So
just rely on the authoritative check.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_reflink.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 683c1841e640..1310cc9fe829 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -17,8 +17,7 @@ xfs_can_free_cowblocks(struct xfs_inode *ip)
 {
 	struct inode *inode = VFS_I(ip);
 
-	if ((inode_state_read_once(inode) & I_DIRTY_PAGES) ||
-	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
 	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
 	    atomic_read(&inode->i_dio_count))
 		return false;
-- 
2.53.0

