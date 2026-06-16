Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3089343D85
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 08:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781597587; cv=none; b=rGwDYP+KzOmoVXRFpkkW/5sszQZjzqLcUiFD4KoDGlXfm4z4sSxmo7QP+4chLVnR+4T0l/RCYy3EL0T205fQN+JkFUcDYJItYEp3eqYutpntOg61v1Dy47UCOClGPCa1GmcY8dzTGGnQV79Alp4vwidF4rGk3lRQHxAJ0bnUS1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781597587; c=relaxed/simple;
	bh=ApJ8hEFbOWDDl/g/FnI6Twa9ZClrgXCuUw2iLESC54g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHT6ZuFQf/EAn2HDHLqKraOQjYT/KqOTZcyG2VX5Nb3D/22P/hxN+aGyebQ7mRYMbdGY71o0jx7P5m63ac19Pta4hQ/E0D1FucW0h1HSSyBTl0a7vkPPYU0adnyVYuft7XX6X9zYfkUSZ2zfBPJbRoDg5laExKcykPgLgE8kbxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IKq2LVAe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dB0KFGGt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IKq2LVAe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dB0KFGGt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DAA8E6CAA4;
	Tue, 16 Jun 2026 08:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781597581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LTMa5qIOFdEgpx+JF/zPTfmlJ/Xr9ywX3u/cykcwkbI=;
	b=IKq2LVAe9ugoF1j4WQK3q9Q4QUKLUajQA0smARRKVZ5tfWUpDj9TA89KuUcFpZ8Bh8x4hU
	I6Htszd9woWeSrC4ENPVm0I1c04FBILvSJGdzd/y8Q2ShjRK+fq3mrmq5rEfd/igCNbmgZ
	eYclfvpVxBoHGfa6bhnHi/2U80zdTkw=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=dB0KFGGt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781597580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LTMa5qIOFdEgpx+JF/zPTfmlJ/Xr9ywX3u/cykcwkbI=;
	b=dB0KFGGtVfisEct7xm+4ETeaKiWil8R2JWnAK6lWBw3wOd5V/Vp/+l3NNV3bAkjwgt6baE
	jJLPsQ7kASeaaaj4hi8EO/o3c47OsxI4uk8+ISGNZiq9WPzs9luto0KzDt0tk0hVo6vxsr
	DEaZ5pLursktVL7o5Kikk3bJQ4tqrSc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE142779A8;
	Tue, 16 Jun 2026 08:12:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qJy2IooFMWrWawAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 16 Jun 2026 08:12:58 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 1/3] block: revert the iov_iter after a short copy in bio_iov_iter_bounce_write()
Date: Tue, 16 Jun 2026 17:42:35 +0930
Message-ID: <c400989f227343b134110773d5acaaacf7024574.1781597506.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1781597506.git.wqu@suse.com>
References: <cover.1781597506.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DAA8E6CAA4
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

For the incoming IOMAP_DIO_BOUNCE flag usage inside btrfs, it's pretty
easy to hit short copy inside bio_iov_iter_bounce_write().

This is because btrfs has disabled page fault to avoid certain deadlock
during direct writes, and instead btrfs manually fault in the pages then
retry.

And inside bio_iov_iter_bounce_write(), if we hit a short write, we
didn't revert the iov_iter, which can cause problems like unexpected
garbage for the next retry.

Revert the iov_iter after a short copy.

One thing to note is that, the folio is allocated then immediately
queued into the bio, so the proper revert size should be
(bi_size - this_len + copied).

Fixes: 8dd5e7c75d7b ("block: add helpers to bounce buffer an iov_iter into bios")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 block/bio.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5f10900b3f42..d2fdfcb016c1 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1321,6 +1321,7 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 
 	do {
 		size_t this_len = min(total_len, SZ_1M);
+		size_t copied;
 		struct folio *folio;
 
 		if (this_len > minsize * 2)
@@ -1334,12 +1335,22 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 			break;
 		bio_add_folio_nofail(bio, folio, this_len, 0);
 
-		if (copy_from_iter(folio_address(folio), this_len, iter) !=
-				this_len) {
+		copied = copy_from_iter(folio_address(folio), this_len, iter);
+		if (copied < this_len) {
+			/*
+			 * Need to revert the iov iter for all bytes we have
+			 * copied.
+			 *
+			 * However the bio size differs from the real copied
+			 * bytes as @this_len is queued but only advanced
+			 * less than that.
+			 * Need to compensate that for the revert.
+			 */
+			iov_iter_revert(iter, bio->bi_iter.bi_size - this_len +
+					copied);
 			bio_free_folios(bio);
 			return -EFAULT;
 		}
-
 		total_len -= this_len;
 	} while (total_len && bio->bi_vcnt < bio->bi_max_vecs);
 
-- 
2.54.0

