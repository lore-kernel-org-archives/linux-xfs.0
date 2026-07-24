Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE5E353A6E
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900043; cv=none; b=gdJad1+ZLrr44fVt26fJnuyLL5uCkos5UqSMDxdZ8L69FfVhz4FfYaREFYywaeC0Z/UEB+qmfHkQeTsnBrI3mhy9IePIHLnny6IlT/R8gdZ/5DNSuz4YsslusVMxtNXGE25heDQI0JFPpgAyWt3VYPVEliWHBfsbmPIvgWlD97s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900043; c=relaxed/simple;
	bh=Lu0Q3R4srSdyMb8eqYTMvEMvhTf1fWVw31AbfPUPhi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSJQP2BQvSBVmEM39lA5Oz4FI4GtgP1AaVDVuy3qdP3aloPFhO/pS9B98c+vn3x7RetnIePw1pa15/OM2O7yaaeUtw4DGQeantPFUPOyj3pdT6tAoKL4VmQPpb9XuISW8XP+r/e7wc4PGGYlP9Vwq460gxJ+OZKaiIn1j3/CkRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=X2mqGnkx; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=X2mqGnkx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="X2mqGnkx";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="X2mqGnkx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5CB917B84A;
	Fri, 24 Jul 2026 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFahWESja0mcpWXiOKBmdg7IRuLRaxK3qV1RSCqu2dY=;
	b=X2mqGnkx7k2FxyrOeNhb77LGUOYApliIQa7Pf6TBjHGHSLaorCH7tQBzEr+m6e6HfANeez
	5xOW7C3oa9N1al3dMDJ6oplJxW2d2OM532Ity6Ocs019kpS3zz1vdCcR7GqBQsh1LofOsQ
	sq9C9mFpN+vI5tmiO5OpM5XqZHun+Sw=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=X2mqGnkx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFahWESja0mcpWXiOKBmdg7IRuLRaxK3qV1RSCqu2dY=;
	b=X2mqGnkx7k2FxyrOeNhb77LGUOYApliIQa7Pf6TBjHGHSLaorCH7tQBzEr+m6e6HfANeez
	5xOW7C3oa9N1al3dMDJ6oplJxW2d2OM532Ity6Ocs019kpS3zz1vdCcR7GqBQsh1LofOsQ
	sq9C9mFpN+vI5tmiO5OpM5XqZHun+Sw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D34D5779BA;
	Fri, 24 Jul 2026 13:33:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MGjrMLlpY2pIJgAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 24 Jul 2026 13:33:45 +0000
From: Daniel Vacek <neelx@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org,
	David Sterba <dsterba@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 05/12] common/verity: explicitly don't allow btrfs encryption
Date: Fri, 24 Jul 2026 15:33:21 +0200
Message-ID: <20260724133328.1837318-6-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724133328.1837318-1-neelx@suse.com>
References: <20260724133328.1837318-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5CB917B84A
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	R_RATELIMIT(0.00)[to_ip_from(RL8xi6x1pj1uf48mqopq9zr7qb)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Currently btrfs encryption doesn't support verity, but it is planned to
one day. To be explicit about the lack of support, add a custom error
message to the combination.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 common/verity | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/verity b/common/verity
index 11e839d2..a857619f 100644
--- a/common/verity
+++ b/common/verity
@@ -224,6 +224,10 @@ _scratch_mkfs_encrypted_verity()
 		# features with -O.  Instead -O must be supplied multiple times.
 		_scratch_mkfs -O encrypt -O verity
 		;;
+	btrfs)
+		# currently verity + encryption is not supported
+		_notrun "btrfs doesn't currently support verity + encryption"
+		;;
 	*)
 		_notrun "$FSTYP not supported in _scratch_mkfs_encrypted_verity"
 		;;
-- 
2.53.0

