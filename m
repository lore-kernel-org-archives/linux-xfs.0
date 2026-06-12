Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076DF3D8103
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 09:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781257930; cv=none; b=hprA7gKngMEqhcMP46hcTbFdEki9dXEBPqf4Lpk3Gc5J2Q8Txf719zqo957b0v13QU09U1ygHYYiUojfU91emcXXnIon+tu4qWnU3l64l/8h6Nz794XNCwqAPatKeP7pIenFBlP0fE16GzLRMiJXAFXxUrPz+xVBLIipFwCG0Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781257930; c=relaxed/simple;
	bh=y+kS0aNdzD5ZpzcjqEPKSOo2duiccnf2Ix68VL4rx0k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aw0JFx6qH5KVZNrhf6lVj1W6SZ2nZOMZJjzOnxwI6flG0fyigHrgqaYtO9D9vtmKiahwFIm9FtDL41ubnrgHY1jY7angJg1sjqSTJjFgR5WfYgUIAxNpcyq4v7pCRq0F05/zHjlxgva0edYCuA8MjDdjo4/ol9beTwB2fnS5bd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VT/F4UsW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VT/F4UsW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VT/F4UsW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VT/F4UsW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A2CF575EC1;
	Fri, 12 Jun 2026 09:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gcKH3Yj/IJOBAb8+VdEPWWnNTruafb27vPLl2XbF1G0=;
	b=VT/F4UsW03qSjLCH7oFDT+tgmHbNC2tCyHJdv1VV4YNYyR9jWBDmJ9rskXhrsvGWaM/690
	vGMPGOJLmKtGBbAgAHts2zYli3vR2/DxWAJHxnZY9cR8mcBj3Pvw5+Ir0TpDxcx2UBtAKW
	dB7DdJd7Xxtfae543UTG1lID7dKmR2o=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gcKH3Yj/IJOBAb8+VdEPWWnNTruafb27vPLl2XbF1G0=;
	b=VT/F4UsW03qSjLCH7oFDT+tgmHbNC2tCyHJdv1VV4YNYyR9jWBDmJ9rskXhrsvGWaM/690
	vGMPGOJLmKtGBbAgAHts2zYli3vR2/DxWAJHxnZY9cR8mcBj3Pvw5+Ir0TpDxcx2UBtAKW
	dB7DdJd7Xxtfae543UTG1lID7dKmR2o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4EC4779A7;
	Fri, 12 Jun 2026 09:51:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GOKvFLHWK2r+FgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 12 Jun 2026 09:51:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/4] iomap: reject NOWAIT and BOUNCE direct IOs
Date: Fri, 12 Jun 2026 19:21:14 +0930
Message-ID: <3d739b6dc37e34ca2a2a3780d12d0288a4060d57.1781253428.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

If a direct IO requires bounced pages for stable buffer, it will always
allocate memory, and both bio_iov_iter_bounce_write() and
bio_iov_iter_bounce_read() are allocating pages using GFP_KERNEL, which
can sleep and break NOWAIT requirement.

So we need to reject such NOWAIT and BOUNCE direct IO in
iomap_dio_bio_iter().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/iomap/direct-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b36ee619cdcd..d1601122f0b5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -412,6 +412,10 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	unsigned int alignment;
 	ssize_t ret = 0;
 
+	/* Bounced direct IO will need to allocate memory, breaking NOWAIT flag. */
+	if (unlikely(iter->flags & IOMAP_NOWAIT && dio->flags & IOMAP_DIO_BOUNCE))
+		return -EAGAIN;
+
 	/*
 	 * File systems that write out of place and always allocate new blocks
 	 * need each bio to be block aligned as that's the unit of allocation.
-- 
2.54.0

