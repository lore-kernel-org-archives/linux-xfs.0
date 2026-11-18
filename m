Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013996;
	b=wvti+yox90MjYahyCndIazscRMPt7vFpcux2LBZbSQP3nED5DqISKhGH7BCxqiKA0l4L
	 fwOQHf29rPo1fzdiM4tGgNvuUeILLHbyMuysrrzRqTkTQFP1RxEWDKv+PLiNTl2+/nnVM
	 M/l5Wq8ltdSJie0lpYG3QeLcc/MjdXKNCcX7CCP5QVCIQzvf9HPNsSC104PynWa0Hwj90
	 NQ/7XE2SGyMnVhEaMrBEB3GqUoErOpSAsA1uCA83+LjNG1P8WEABs6/9l3gTNFaQAgbsa
	 isQFE6lBxVr9xsyUxiC0qPSSh4/fV2CEn7OCnFpWLT6oS2mm2R8iiD+FsKnpIm8FCQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013996;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=s6yJ8Ndejm7vpCK6+oclxZpbiR5Baogu7RGKVuI5phc=;
	b=YhHaHpZaUZyMb2k6pLDq2mrgamOxTcj65kqOB7oIIH8sOFPT+LR9/PoF8t0qjp+76odx
	 xEAVPKMsQ5uxODBL6ni3DH5R8gExeXlGmeHhfGl89VjH9fmQqVPDFxP+nXW6HYGdV15pX
	 ka3qyWD/QHa9Vz9ohofBtonpMjUdipaUGr+MWRETX+1tAKirVhrm4fvbFkpjp+wZZ9zmA
	 xW3cZWtt7tEtYmUaK0c8LjQFUS9aXkmEALjuW13mQkzsEH7d+KxPudm9cfJuWO0zJC2/o
	 6q/9O1kiJhWhW1fRZxn+PzVFbDT93hdgLcI5koMm5aRP2pJBn+BMrfdjbBywKf4qZgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=o0LNQBE6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jKjkFddC;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=o0LNQBE6;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jKjkFddC;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2AD606A336;
	Wed, 18 Nov 2026 14:59:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D2AD606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=o0LNQBE6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jKjkFddC;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=o0LNQBE6;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jKjkFddC
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 725CE22346;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s6yJ8Ndejm7vpCK6+oclxZpbiR5Baogu7RGKVuI5phc=;
	b=o0LNQBE6uZJ/EbdIg3Q0VEHGldPK+DG8IUDGu/V+q64w2KHcjoqdHaTEbXAcs2Aiflr9co
	hq5rK0QupE4Nn1iXCW6lhlvk0QlHHI83ytyNQ/I4NNbXNMLswCcybC9LgOp0Kedyf/Y83H
	iXn/mZDVlt/foD1CbKLrkwI0BfHrPzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s6yJ8Ndejm7vpCK6+oclxZpbiR5Baogu7RGKVuI5phc=;
	b=jKjkFddCHLtv9M4ifLXiHU/ZbQaLgx4j4zsvH2WgLQ0J+yUex4ttf2Yd2uIdgePWndD+Mg
	w2oqYzCGmq2RvIBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795013994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s6yJ8Ndejm7vpCK6+oclxZpbiR5Baogu7RGKVuI5phc=;
	b=o0LNQBE6uZJ/EbdIg3Q0VEHGldPK+DG8IUDGu/V+q64w2KHcjoqdHaTEbXAcs2Aiflr9co
	hq5rK0QupE4Nn1iXCW6lhlvk0QlHHI83ytyNQ/I4NNbXNMLswCcybC9LgOp0Kedyf/Y83H
	iXn/mZDVlt/foD1CbKLrkwI0BfHrPzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795013994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s6yJ8Ndejm7vpCK6+oclxZpbiR5Baogu7RGKVuI5phc=;
	b=jKjkFddCHLtv9M4ifLXiHU/ZbQaLgx4j4zsvH2WgLQ0J+yUex4ttf2Yd2uIdgePWndD+Mg
	w2oqYzCGmq2RvIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E687134E9;
	Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r2o8B2q9/WqFXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 14:59:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id BFC332508D; Wed, 18 Nov 2026 15:59:53 +0100 (CET)
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
Subject: [PATCH v2 0/13] fs: Various I_DIRTY_* state handling fixes
Date: Wed, 18 Nov 2026 15:59:34 +0100
Message-ID: <20261116171044.6938-1-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=908; i=jack@suse.cz; h=from:subject:message-id; bh=har4eQx+WA3Yx2wMGDte8Sp2jYmXDYxKBynIXcZzeEg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBq/b1Wi2Lf6TecdD7vGSwQyo/bmTz1Dz7JU1uHl sQGKU3scwCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCav29VgAKCRCcnaoHP2RA 2ShrCACyopx8ODeggLoMfBy6MmKVusKQT2A5fK3na5my6r9AxeuAPP+YydV6FFlKcWJMqcwANuE /qL+nHpkBKzdAPOyw1UyWnfoRpHO2NEwfINy6CvE5liC9j9KFN4jT0R02Oh87K0KsQb6nnilJwN jrQJ8U3VtfZRC7NXrrJDOpgbroCgo3gLzSu47ReHrB8IWRt6CAonpPyk2kTLKpL0SGHEQPxbegc I72WjJWUAPVqgN6E2bXn4UQTqW+NV0vwBywNGV367hCE35XZA0XmsJ6AkktDd957cDTK6oVEJpU GhsRj/1eDT45x86larcMOyDFx+UMr0jicBHY0uS6dPWw+W7i
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Hello,

this series is a result of my audit of I_DIRTY_* state handling fixes. Over the
years some pointless code or code with smaller or larger bugs has accumulated
in filesystems around handling of inode dirty state. In particular testing
for I_DIRTY_PAGES is very subtle (and racy without holding i_lock), some places
forget that I_DIRTY_TIME also means inode has dirty metadata etc. So this
patch set removes direct checks of dirtiness state from filesystems and either
change them to directly testing PAGECACHE_TAG_DIRTY or to a helper function
which performs appropriate dirtiness check reliably.

Changes since v1:
* Fixed orangefs checking of inode dirtiness
* Added Reviewed-by & Acked-by tags
* Added Fixes tags
* Made gfs2_fsync() conversion more bug-to-bug compatible


								Honza
Previous versions:
Link: http://lore.kernel.org/r/20261113083336.15152-1-jack@suse.cz # v1
