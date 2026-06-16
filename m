Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD8E3DB31C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 08:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781597593; cv=none; b=qwtjbchKfOe8BJA/MsgrbLCZXH2ovUxXY/2/3RK46yxr16ysAQxe2eQlBmsPmyOaWfN3aXGnGsi73vOI/fYCG9KvfhX+FdDVImpDoO/EoGeVU5RmFLESqB28rto9/d9Yb+2Fr8ZrpujEGCLBx+dWpTfNQtKdwcP3lvpJyCujmvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781597593; c=relaxed/simple;
	bh=zcYlI6BOH27Zqh+GlLfj050W5csemhmRX2lQcvXKXco=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpx/FIp6kLXUE499oII/5Ppnm8QxRxrX7Xwc1usGt3YrjdPLYPIYMeErDDhpnSYhC2im0nzYEn5Mgjudy00BOKNvhmc0lVCK8r1OH/P5OhQALXbdjIlymQ9FgOv3/5rP6DtB1RJovHc5sfh3KpU/f9M72b6EMoDcuEG3PIdlUaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=f/WkpLdr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=f/WkpLdr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="f/WkpLdr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="f/WkpLdr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 843736CAA1;
	Tue, 16 Jun 2026 08:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781597583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHkl7eB5Q33d+KIXaR6NtZXizd+J+fXxtJicsuSOa/U=;
	b=f/WkpLdrAv2Ya5OHyMHsAcxsn5BhLG6dErAXEBzXz6nS+ynPHryxEvoykZSWkUMP1Z6v0w
	n5LIP3MgQiAtF111/enowu9UwQohDMnXKOHvcQMqhpPIGQnQF8qNxCez6JmDMcAGtdaATN
	rUlgVfiGwQt8NSl+xSYE7KbfVLB63O0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="f/WkpLdr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781597583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHkl7eB5Q33d+KIXaR6NtZXizd+J+fXxtJicsuSOa/U=;
	b=f/WkpLdrAv2Ya5OHyMHsAcxsn5BhLG6dErAXEBzXz6nS+ynPHryxEvoykZSWkUMP1Z6v0w
	n5LIP3MgQiAtF111/enowu9UwQohDMnXKOHvcQMqhpPIGQnQF8qNxCez6JmDMcAGtdaATN
	rUlgVfiGwQt8NSl+xSYE7KbfVLB63O0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 817A8779A8;
	Tue, 16 Jun 2026 08:13:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IMwgDI0FMWrWawAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 16 Jun 2026 08:13:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 2/3] block: respect iov_iter::nofault flag in bio_iov_iter_bounce_write()
Date: Tue, 16 Jun 2026 17:42:36 +0930
Message-ID: <9c165a314022b61566eb247852eb773ca6c70889.1781597506.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 843736CAA1
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
 block/bio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index d2fdfcb016c1..7fd7c35f9a28 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1335,7 +1335,11 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 			break;
 		bio_add_folio_nofail(bio, folio, this_len, 0);
 
-		copied = copy_from_iter(folio_address(folio), this_len, iter);
+		if (iter->nofault)
+			copied = copy_folio_from_iter_atomic(folio, 0, this_len,
+							     iter);
+		else
+			copied = copy_folio_from_iter(folio, 0, this_len, iter);
 		if (copied < this_len) {
 			/*
 			 * Need to revert the iov iter for all bytes we have
-- 
2.54.0

