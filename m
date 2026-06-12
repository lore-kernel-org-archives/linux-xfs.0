Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E313AB5AC
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781257906; cv=none; b=drOhIGYWCiQeQGdYmw+ZIZkx0Ub0eS7AAJO1aFgvPHYTefLANT2lJdHdj+jRQgLhUf9YdcEYA22N3kCNSTTUVlRv75K54Z6z4ahVk0nMX3G5XhSvTQZ0bF1sWqIAyd/CK1n1g1gPrqymX1IV+nOAY5gBPY1d8R8lYqINk8aOqnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781257906; c=relaxed/simple;
	bh=2cLqly4j3WhxDZr4OJpbMXTyg3xkhFy8CoBLk1YDuiY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Zu3ZZ7G3sYVc6deAjx0XnLy8noiWQ80ZsCSN9V/qxvUaOD4K+P/LH5t2vnaDMcnyGmEh5n7j/4junBy1jstJEyV4IQm6YXXzGScSAF4mTpbrA46POzrDwwImE4cdA4pAJHqiWr9Pclg3UNNOw7xsec8tO2HKzqRRa9pF2K7JN9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aUCBdWG0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aUCBdWG0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aUCBdWG0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aUCBdWG0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF67875EC1;
	Fri, 12 Jun 2026 09:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zx1SP72U6TXb2Yduv9Z749/hZGUblXFK21ICZpUDatk=;
	b=aUCBdWG0zJxfuN6XMQLBTxTzaBJ0yd37bl68eS5vPWW62/O/ZLVYmU/r17Ju81UInGEihp
	qMLLnQKMDvZmcpNQZdn0X+J9AMWmgG0AJLIe6RaiNzM6/O9G3UFrFVBKZ+L3TlF1bBjYVt
	yxZbciSC+CyEjb87HFJmJF+DixZOEhY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zx1SP72U6TXb2Yduv9Z749/hZGUblXFK21ICZpUDatk=;
	b=aUCBdWG0zJxfuN6XMQLBTxTzaBJ0yd37bl68eS5vPWW62/O/ZLVYmU/r17Ju81UInGEihp
	qMLLnQKMDvZmcpNQZdn0X+J9AMWmgG0AJLIe6RaiNzM6/O9G3UFrFVBKZ+L3TlF1bBjYVt
	yxZbciSC+CyEjb87HFJmJF+DixZOEhY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C24DE779A7;
	Fri, 12 Jun 2026 09:51:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uh/jG6nWK2r+FgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 12 Jun 2026 09:51:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/4] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered IO
Date: Fri, 12 Jun 2026 19:21:11 +0930
Message-ID: <cover.1781253428.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

[CHANGELOG]
v3:
- Fix a bug in error handling of bio_iov_iter_bounce_write()
  Which can lead to generic/708 failure on btrfs.

- Respect nofault flag in bio_iov_iter_bounce_write()
  To avoid btrfs specific deadlocks.

- Reject NOWAIT and BOUNCE direct IOs
  Since BOUNCE always allocate pages using GFP_KERNEL, which can sleep
  and break NOWAIT requirement, has to reject such combination.

v2:
- Rework the comment in btrfs_dio_write()

Commit 968f19c5b1b7 ("btrfs: always fallback to buffered write if the
inode requires checksum") solved the csum mismatch caused by unstable
direct IO buffers, it has a pretty hefty performance penalty.

Meanwhile upstream iomap has introduce IOMAP_DIO_BOUNCE flag to get
stable buffers meanwhile without falling back to buffered IOs.

Using that flag btrfs can reach 95% of the original zero-copy direct IO
performance, almost 2x the current buffered fallback performance.

However during my tests, there are several bugs related to iomap that
can lead to direct IO test case failures:

- generic/708
  Results garbage in the end of the writes, is a bug in the error
  handling of a short copy.

  Fixed in the first patch.

- Deadlock if using the page cache as direct IO buffer
  This is because bio_iov_iter_bounce_write() doesn't respect
  iov_iter::nofault flag.

  Fixed in the second patch.

- Possible NOWAIT and BOUNCE conflicts
  BOUNCE flag for both reads and writes will allocate new folios using
  GFP_KERNEL, which can sleep and break NOWAIT requirement.

  Reject such combination in iomap_dio_bio_iter() directly in the 3rd
  patch.

And the final one will enable btrfs to use IOMAP_DIO_BOUNCE flag, so
that even with data checksum we do not need to fallback to buffered IO
and reclaim most of the dropped direct IO performance.

Qu Wenruo (4):
  block: revert the iov_iter after a short copy in
    bio_iov_iter_bounce_write()
  block: respect iov_iter::nofault flag in bio_iov_iter_bounce_write()
  iomap: reject NOWAIT and BOUNCE direct IOs
  btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered
    IO

 block/bio.c          | 10 ++++++---
 fs/btrfs/direct-io.c | 53 ++++++++++++++++++++------------------------
 fs/iomap/direct-io.c |  4 ++++
 3 files changed, 35 insertions(+), 32 deletions(-)

-- 
2.54.0

