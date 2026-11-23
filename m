Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424461;
	b=THIEIgWmudIwmBKyMAUMLL6A/oPBoE1qNPSeXXM4rLMVA2NWg/1579n2OUCEJOzvTENn
	 bU+331lxCZTuMehHolp2e+ThUf1+N83oim9g5yoHFzLyJCqdjLCJBN1PJjI/UqCR/p12X
	 UUofSsln5+tyUoB7muqArPS1La/tv5Mzmf/HZtRKSE6y4nnCWvdAxaBD/smrRGXfMh+GC
	 pJ64sBYV4IXin/tWPMayM5M+XujMKHZJZuIajm3/WuqEJ/GtzXU6OSE5gvhmTRuakjWG4
	 ma91fBsf28mzeuhJJjrfIhJ7iOA9P3YYPqXqr0/2HNdbqjzzZNE75dGfJzDfXHM/TRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424461;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=O39JXi5k3K9AYzQlilyWAQFtMH7+2Ip6YVrc8OdVAfg=;
	b=0PWJN1QiVh4ffGGwSXqLvjVXkBnBMV1itFaWjK+uPAqe1g60D36ZOXZAgqlJnmjhICH8
	 sy3Z/PHc1PuJXZ0lYFXGcjZMG1mfhIb7zLPeV/3W3UVC7sVykKuKw2MbfsQyFkQmZR+Ry
	 qnfTfkkhTw71h1iEGU1IH2CHBuszuI2zGkAro+yGN7RoVbdGZ2giG18VvdHtT8bLkyt+I
	 c//I9rjHjNOejg29XJoFoYaBAlbEBm6bKJfiCvH/Koqh1DsFaWIUXmGrxdduRL1AJmhsl
	 zmxea36LwmTt/HPen5/LbXMqUkqrKU/vgrG0C3ITN7CJobSnr8b7YFM3JTUbQYgyN/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XEMiW9FS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=slK3PK2c;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IWUpd4tx;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YsY3q8bN;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6995606A6A9;
	Mon, 23 Nov 2026 09:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6995606A6A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XEMiW9FS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=slK3PK2c;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IWUpd4tx;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YsY3q8bN
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23F2A220AD;
	Mon, 23 Nov 2026 09:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O39JXi5k3K9AYzQlilyWAQFtMH7+2Ip6YVrc8OdVAfg=;
	b=XEMiW9FSKeNVZfxK1TmadmRcl1KCimjz8Rcdb6ZTC4hUROyOf63hBhgF/jyO/FwNgwsV5G
	//SrpXcUz8u1+zUWOOLjEZUpRoZFEPOMlp3WiQusIbA4UfotUfJ2IFJyAZPZ9DnGnuKKuF
	0KlRSlyN3vxNEB9EU/cGi6DD+5Hf8bM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O39JXi5k3K9AYzQlilyWAQFtMH7+2Ip6YVrc8OdVAfg=;
	b=slK3PK2cIGWK/xqnT7jckTIAJC7+KNrE0xIo++VP0rQ21J/h3ZPHliFLIN+PtNGhyQgvoY
	OBxtzMhZ1P+K0GDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795424458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O39JXi5k3K9AYzQlilyWAQFtMH7+2Ip6YVrc8OdVAfg=;
	b=IWUpd4txpYWd49MwNZa/MQtoXhvFXvoruKKCz64+P7Ty9OY7ibTCspTjV9scHFPzZjO4YA
	tOWUEBJfcyNpaR40sV9AoeUyhgvu/2SoGMyQGguogo8hZVWP8nejT8Nk5EjFkhXjIi747f
	qVQMvKnm3UUsi5HcUm0r9aBvKXvfi74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795424458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O39JXi5k3K9AYzQlilyWAQFtMH7+2Ip6YVrc8OdVAfg=;
	b=YsY3q8bNru1BdNgw1uFBt5zeI7uSIlQttOOa5VA0qtGsFHdtk2qYGgpU/nls0ZKL5peaZJ
	5MBaqgfccSKDfNAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7619136CB;
	Mon, 23 Nov 2026 09:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pnI+MskABGviBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:00:57 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 5AAD8275FC; Mon, 23 Nov 2026 10:00:57 +0100 (CET)
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
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Subject: [PATCH v3 02/13] xfs: Drop pointless I_DIRTY_PAGES check in xfs_can_free_cowblocks()
Date: Mon, 23 Nov 2026 10:00:37 +0100
Message-ID: <20261123090040.19006-15-jack@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1092; i=jack@suse.cz; h=from:subject; bh=KdSnsq8+pRAtowYvxbQqVA1eXIauc0HVVLDRR762jnM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBAC5b8UfOwIZulW/Ge4yyUOL4JaBbZEbc1vlE Iz5aemnp0GJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawQAuQAKCRCcnaoHP2RA 2fRPB/9QaYJNragl2Am9tYlLX9nPa/y2kyTMS3VZNIIAHZ98YN3VZykmYDXt5XsS72dAsWovwxU yJjKF2een8Mtg8djtKfH0Qs7Z7cuAb213Rqetd2qrucybQd39OxF1fsKLttfW9tOd8hrM1uxaj8 ZuDnwmb9wUQ1ICHlDFIBM162jwOi0HTB0dpWEv/IH29GvUhKc8JmJiFCRNZJibNYKZB5VF8CPi4 xJ1ofbFRxOrMU8T4e8ixALhoasP2lk/oay4MuQCRv+uBRKo1QOMFFpJOESQJdCDtnkqQy0new9G iLtyJzgfp8q9/cTgvH2Xh42bBCmPseKmitZCbCwL9gGimfTn
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.985];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -15.80
X-Spam-Level: 
X-Spam-Flag: NO

PAGECACHE_TAG_DIRTY is the authoritative source of information about any
folio being dirty in the mapping. I_DIRTY_PAGES is just an approximation
used by writeback code that can get stale under certain situations. So
just rely on the authoritative check.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Pankaj Raghav (Samsung) <pankaj.raghav@linux.dev>
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

