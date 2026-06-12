Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09D73D6CB0
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 09:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781257922; cv=none; b=njxFd9dc3cDrL72HV5GjPqLjU8ml+8UtGUMcTgoVarXmfiH5yprF4E0EA9juBl7KqEeyZ32lC2GV8gMbSGXt2oCaAXIyxnUBnJkujxxQPqi6TcbEC3Qx3Tw88icSPhuF8Youy531yByTzwdTluaPNIhg3yfglmHFNRTnurW7quc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781257922; c=relaxed/simple;
	bh=hAMhLS4zAxMNjW4G9NlQpZu1tDK+NqT3MRUui8vX1MM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdZ21UJDU4+q+SdehwADAnOd5GQlWF3FC3AhxwUy4YyzMWS5m4KSr2ZKty2l4ANy9L+GB005coshMJi3Sv2zz16r8VabOUFdJ7f/oSC2zzZWoWeYyOOkH/EyMfx2IQ2N1EKBJjJg29RbHCoXUbZEYecGqqWKUbDrMuKynkmpPmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JyViLnJ0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JyViLnJ0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JyViLnJ0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JyViLnJ0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 08F5576494;
	Fri, 12 Jun 2026 09:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFZyyRcTnq/fPpSv7aCpo7Q4cr0cY2LkaRxoKIT1vL4=;
	b=JyViLnJ0rs40DryFnZ/hjVY7nwAvVsTPGUkdWYuB3ljVdkSPAvltCeHRxNSn3eUlHf25of
	Ng/59Tg1Vau/RA/aNf0CT7F9e/otB3WFEb5T5/SGhE+blUfRkmj7ItuXy0vn8KFJrZmexn
	7EEW/6WPn7O+Jj+5N/OWFBscbQbjc5A=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=JyViLnJ0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFZyyRcTnq/fPpSv7aCpo7Q4cr0cY2LkaRxoKIT1vL4=;
	b=JyViLnJ0rs40DryFnZ/hjVY7nwAvVsTPGUkdWYuB3ljVdkSPAvltCeHRxNSn3eUlHf25of
	Ng/59Tg1Vau/RA/aNf0CT7F9e/otB3WFEb5T5/SGhE+blUfRkmj7ItuXy0vn8KFJrZmexn
	7EEW/6WPn7O+Jj+5N/OWFBscbQbjc5A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C7F1779A7;
	Fri, 12 Jun 2026 09:51:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6JwdK67WK2r+FgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 12 Jun 2026 09:51:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/4] block: respect iov_iter::nofault flag in bio_iov_iter_bounce_write()
Date: Fri, 12 Jun 2026 19:21:13 +0930
Message-ID: <35a61301ea76c71d101533bf7d4aeffb7752fb85.1781253428.git.wqu@suse.com>
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 08F5576494
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_NONE(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

For the incoming usage of IOMAP_DIO_BOUNCE in btrfs, btrfs has set
iov_iter::nofault to prevent deadlock when a page fault is needed to
read out the buffer.

However bio_iov_iter_bounce_write() doesn't respect iov_iter::nofault
flag, and just call a plain copy_from_iter() so it can still trigger
page fault and cause deadlock in btrfs.

Fix it by utilizing copy_folio_from_iter_atomic() if nofault flag is
set, otherwise use copy_folio_from_iter().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 block/bio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b33ff69bb722..01bb76d9717c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1335,7 +1335,10 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 			break;
 		bio_add_folio_nofail(bio, folio, this_len, 0);
 
-		copied = copy_from_iter(folio_address(folio), this_len, iter);
+		if (iter->nofault)
+			copied = copy_folio_from_iter_atomic(folio, 0, this_len, iter);
+		else
+			copied = copy_folio_from_iter(folio, 0, this_len, iter);
 		if (copied < this_len) {
 			iov_iter_revert(iter, bio->bi_iter.bi_size - this_len + copied);
 			bio_free_folios(bio);
-- 
2.54.0

