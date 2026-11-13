Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559666;
	b=DoKc0yrXqtBUo4mKdSBSu+t2qyWIpPSsU9VdeyrIIwmtDhQHUA9Ub4GerTEQwC9iJbts
	 Te5Jjnj/Hvx9Vpv7u++cjL7ValFEjbfATAYRgL0gIwMQhMpRckoOsAYwzh+Lp/rRE1hkp
	 1dSua5oBFgelWnr+htEAQUAIwe/lD2S6PQ8pb19s4CVM1sfspJcl5axMSHWVH6QF4NQ0g
	 UjxUMtPxArVjjJ3SuvcSwOoY3YoGNQ6m34LB1DoVOkcqhLjrx3URq4zK02XdCj4znKwSq
	 rWoLcu7eXGGC3WJcP40WeCV+drx+MEPBq8uqLPEtaeZYj5jU6p59855BQCcrthcK53w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559666;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=pEkGPiPddTdTpcEv+zWsdTkbUZdlWZHlzLW+rI34CIU=;
	b=j3xU1EMlV4a7Wj6oGSgH/5sfjmNxVYDov335TnhS3el1F3C4ww+HSOaNLWLEinUcyDhg
	 uYcTfv82aGaDHT0dYkQBwkEUEsQsRxSJqFoP6ythj0TapG9KEa6GhfD3XwyYWvsgBRI13
	 RPwPvV2SHxel6EQh+9e2U1zJShtq41EfGqahnh0GgfPaIldInRJkxe8/bUGX6iacFMTaV
	 SBcwD6GnvsVM2d9hKWHP+JlFJr3FJIc4AH52zK++R0xLCC7oBl4ZUg1OMDXUoSC5yylx6
	 YcGcUznh+wu7SP0JebLeWHoJie+QeXZMjP6KtifQlLwDWxVTiR85FBuPkOh88YFyEbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="z/ZuHTgm";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oZd2riHN;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="z/ZuHTgm";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oZd2riHN;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE43606C1AD;
	Fri, 13 Nov 2026 08:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BE43606C1AD
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=z/ZuHTgm;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oZd2riHN;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=z/ZuHTgm;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oZd2riHN
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 96E501FA7A;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pEkGPiPddTdTpcEv+zWsdTkbUZdlWZHlzLW+rI34CIU=;
	b=z/ZuHTgmBw9KVQm6ZzzPIX+nMwRCB1OnHm5nV15Jn3HsAc2kZckns3HqO/8xOlml6ypCrj
	8z1sGPlw1OhYeEUU4eB3Keave7ol/sOmNIHv1O+FjoVGvlz9pVJPHCVKCRyyZJH1dT1h0P
	c5239OCywCIagDI18Gwr71ZUczjsKes=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pEkGPiPddTdTpcEv+zWsdTkbUZdlWZHlzLW+rI34CIU=;
	b=oZd2riHNwn5jJKxfx/fS7oqw2DHkwIw8meqoju3WZxQrbDK5JnpN/Aycik0eg2z/vvNnaW
	gTHZnyHqdCQaU5Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="z/ZuHTgm";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oZd2riHN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794559663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pEkGPiPddTdTpcEv+zWsdTkbUZdlWZHlzLW+rI34CIU=;
	b=z/ZuHTgmBw9KVQm6ZzzPIX+nMwRCB1OnHm5nV15Jn3HsAc2kZckns3HqO/8xOlml6ypCrj
	8z1sGPlw1OhYeEUU4eB3Keave7ol/sOmNIHv1O+FjoVGvlz9pVJPHCVKCRyyZJH1dT1h0P
	c5239OCywCIagDI18Gwr71ZUczjsKes=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794559663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pEkGPiPddTdTpcEv+zWsdTkbUZdlWZHlzLW+rI34CIU=;
	b=oZd2riHNwn5jJKxfx/fS7oqw2DHkwIw8meqoju3WZxQrbDK5JnpN/Aycik0eg2z/vvNnaW
	gTHZnyHqdCQaU5Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D70913511;
	Fri, 13 Nov 2026 08:47:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6DmfBq/O9mqeFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 08:47:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 4DF3222C3A; Fri, 13 Nov 2026 09:47:42 +0100 (CET)
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
Date: Fri, 13 Nov 2026 09:47:09 +0100
Message-ID: <20261113084700.739002-22-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1197; i=jack@suse.cz; h=from:subject; bh=qpUV4TvSSCzY7nU96YV3Bi36QDC33ZQD9mO2u2rfs3Q=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq9s6LuTD19UoGoZRg9oc53RbPyhd/W3AJDmisv D/N3qsc+AWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCavbOiwAKCRCcnaoHP2RA 2SOIB/kBw/udCCvizTLfEXKNATmzNez2/7kpNYutfnunkI40wbxUAdAvYY/ULc/Hp0b1N9185a9 Gz5LNTn0ZzV9/n0zYbTXSqGXSa90i5cgeyaZF415ZYIiB1k5wEYxAptenvaooBJEtrHXx+dVjNo Amfz4eTIBPV/irE1cGT8anW2WRKWF9gfxPgiRdN5Qye4b8ZpTZT6+czwITDKuhqkRSkZWt0KWfH rTr6oEo2xGejeNQTRiihzSyZ/uUPtlE29VXHQTY+3ALgiz580cOSdIU8gOpszSDbXt+lEAswQpr frWr+OvME5Y3LVfs/0ORBEXu4KDA9ignZs1Ej3Wm6uTHmo4J
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 96E501FA7A

The checks are bogus because they check against inode->i_flags instead
of inode->i_state. Use the inode_or_folios_dirty() helper which actually
checks what was intended.

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

