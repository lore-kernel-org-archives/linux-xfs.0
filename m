Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51B139903E
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 09:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781257914; cv=none; b=QS1swEZjCDtPKXoRcMSSf6MwqC7M0KfjMRGCunh62Yy/AKBg0OZcYjivCa/+NDdv/GoZFYYCBEDE3Tqdo3h/E7fbg2tltMIpwPOk1+KhQbCcgoPGdThsHQqowO4bkU7zTlBWZw3AfMzIsqZk4ZTdn13e1IpoML+WLmjvgwpYKfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781257914; c=relaxed/simple;
	bh=d5CfACRvH66ZIYLAg+Tt5MI8eK8h/DZeSayKvX4RlSw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhfRT7RAXbV8kp8gpAhHkIc8loYyDIMLbVcLavT/z+TakmW+wn5L4OnPqGHNWXvLk88Sn+LVA6w0t2c0yZwaGPAdcXaNSRwz2HzM5E2wCMQp4ReclGakGjZXuUmZ8uxxaiyp50VArX7f4OtFv3Vx/eTmZ72QLUzyMEpceWumsQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=n0XUqLnP; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=n0XUqLnP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="n0XUqLnP";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="n0XUqLnP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 64F9776009;
	Fri, 12 Jun 2026 09:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZMnjiGpCuva1czSiJ6RhzxZxiIvq8q3zE2wXXn9Ku1M=;
	b=n0XUqLnP1CSsC3MCr2PuAz2ivZEbR+Idx54V0sWtXsYqOxE7OOc8tHn8pO+J5/rfkdkZkB
	ovMspceSpYoHPUbTZ2W6oFMOf9+tDPbyjfFxfUDlGRGgZW5zcdgil1+il5IFEHcRmFDges
	zpWE4g0Ab5TJy8oi9x0SSXqs2qYYEB4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZMnjiGpCuva1czSiJ6RhzxZxiIvq8q3zE2wXXn9Ku1M=;
	b=n0XUqLnP1CSsC3MCr2PuAz2ivZEbR+Idx54V0sWtXsYqOxE7OOc8tHn8pO+J5/rfkdkZkB
	ovMspceSpYoHPUbTZ2W6oFMOf9+tDPbyjfFxfUDlGRGgZW5zcdgil1+il5IFEHcRmFDges
	zpWE4g0Ab5TJy8oi9x0SSXqs2qYYEB4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6764D779A7;
	Fri, 12 Jun 2026 09:51:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kN6zBazWK2r+FgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 12 Jun 2026 09:51:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/4] block: revert the iov_iter after a short copy in bio_iov_iter_bounce_write()
Date: Fri, 12 Jun 2026 19:21:12 +0930
Message-ID: <ed47077f3d4336b64a177486e74b4f6a460b2392.1781253428.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1781253428.git.wqu@suse.com>
References: <cover.1781253428.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

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
 block/bio.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5f10900b3f42..b33ff69bb722 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1321,6 +1321,7 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 
 	do {
 		size_t this_len = min(total_len, SZ_1M);
+		size_t copied;
 		struct folio *folio;
 
 		if (this_len > minsize * 2)
@@ -1334,12 +1335,12 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 			break;
 		bio_add_folio_nofail(bio, folio, this_len, 0);
 
-		if (copy_from_iter(folio_address(folio), this_len, iter) !=
-				this_len) {
+		copied = copy_from_iter(folio_address(folio), this_len, iter);
+		if (copied < this_len) {
+			iov_iter_revert(iter, bio->bi_iter.bi_size - this_len + copied);
 			bio_free_folios(bio);
 			return -EFAULT;
 		}
-
 		total_len -= this_len;
 	} while (total_len && bio->bi_vcnt < bio->bi_max_vecs);
 
-- 
2.54.0

