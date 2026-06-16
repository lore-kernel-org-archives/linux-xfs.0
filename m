Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1044B3612CF
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 08:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781597581; cv=none; b=vEzVt5fPheca5NbNN7QImJqSnBFIgk2lpkzEjNtzgaTK+4d/T+VW63dTttUdjqb/e15cWZkwT29gOqLldy1fw2sCIOUS+QWiiaFjVO4Sa0efC1KdAkxWr2BV6+gmAazAKT20+PXkCbVicpkm5OMhL2qClbBrRc0KZ9sE6JTQQlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781597581; c=relaxed/simple;
	bh=al9hpuFpqsIjZwH+x7Gha+NtcvGhCsfQ/bjSIc5HaTk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Wj10UdMgIEK5UzsSIQHu4y9aZOWAajMcxSB+LuIvJYZgM+AmYNjRKqwu1wNS/G15m7NSjgTt0bpnW3fc2qzrQmS/uqW00TAI1soUWYau9rpSu7fU9D2RW9VmFhIXyOJTZ4NG8mLUF/bJtI6sMQqDFxCJT2nUxhigGGRRJnZaYJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AbEOd4MZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AbEOd4MZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AbEOd4MZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AbEOd4MZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 472E36CAA1;
	Tue, 16 Jun 2026 08:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781597578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YisAiIYXF3a6H38XzU5Fz4HeVYLAdB+0rrEl9RKukZQ=;
	b=AbEOd4MZiKoHDPEmcTPewGqnhLBK/RQcu0PON3AtV4pBnv9wd1uBEa7JHmHcCYrrSudRI6
	icOzKxQgFTNiC2gWTR5DDa6Q9rDvIIme9kBxeCa9HtrjOuWbKXJ3xP0cquZ5Uc6G3OpZcT
	d+JOQLLvrepS7ojZzvxtI+Tf+rxO818=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781597578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YisAiIYXF3a6H38XzU5Fz4HeVYLAdB+0rrEl9RKukZQ=;
	b=AbEOd4MZiKoHDPEmcTPewGqnhLBK/RQcu0PON3AtV4pBnv9wd1uBEa7JHmHcCYrrSudRI6
	icOzKxQgFTNiC2gWTR5DDa6Q9rDvIIme9kBxeCa9HtrjOuWbKXJ3xP0cquZ5Uc6G3OpZcT
	d+JOQLLvrepS7ojZzvxtI+Tf+rxO818=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45E88779A8;
	Tue, 16 Jun 2026 08:12:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id X5G+OIcFMWrWawAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 16 Jun 2026 08:12:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 0/3] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered IO
Date: Tue, 16 Jun 2026 17:42:34 +0930
Message-ID: <cover.1781597506.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[CHANGELOG]
v4:
- Follow iomap/block layer code style to avoid lines over 80 chars

- Reject NOWAIT BOUNCE direct writes inside btrfs
  The iomap code still allocates memory with GFP_KERNEL in other
  locations.
  For now just disable NOWAIT BOUNCE direct writes and let the caller
  fall back to blocking mode.

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

  Reject such combination in btrfs when enabling IOMAP_DIO_BOUNCE
  support.

And the final one will enable btrfs to use IOMAP_DIO_BOUNCE flag, so
that even with data checksum we do not need to fallback to buffered IO
and reclaim most of the dropped direct IO performance.

Qu Wenruo (3):
  block: revert the iov_iter after a short copy in
    bio_iov_iter_bounce_write()
  block: respect iov_iter::nofault flag in bio_iov_iter_bounce_write()
  btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered
    IO

 block/bio.c          | 21 +++++++++++++---
 fs/btrfs/direct-io.c | 58 ++++++++++++++++++++++----------------------
 2 files changed, 47 insertions(+), 32 deletions(-)

-- 
2.54.0

