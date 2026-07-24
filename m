Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F5C3B71C4
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 13:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900025; cv=none; b=SvLknRyHbw3QssXCSe2kUa6zfbZ2G7d4CjcfLEU4uRJVUlkGIHRN0SDSwQo+MjPyZafYmC3kGk5Oazc+ycJPEbWwJYIQGl3k9ZVrDkBlptKGaveDtCgkFNGopBKgF98wky7UfzlaDg/A2jpUirbtB1+AnkSPUCiHUN83HCdj2Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900025; c=relaxed/simple;
	bh=Oho22ogpd79FN59/VMKoDYgBS/cSrYQqb3jikjHjFcI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kpj0HBbK7C3Nn3jLPYhiyPamCLMlJvYFGtezo8FN03iCLyyXQQNq++wiVIp3qI9l570rnUeURZiTwQ5TNJxZtoesVfsKPTERDQ+MZtZtK6JfyiHl92HSUVHX/2PXGnsGyUUF75mpEdvpv8Kpam5dA/ZWP2iJrwlhk6bQibLiaPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hMHi3EVW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hMHi3EVW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hMHi3EVW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hMHi3EVW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59EDB7B88B;
	Fri, 24 Jul 2026 13:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=87KJldLVO12YI6/aqcMypvZbGEc4Q23o2OfJPWjlafE=;
	b=hMHi3EVWgudVW3Rtpsa9f6sJYDStIiDsU507vjY2B72mqcuP4Ckx6E3eLT1b9Gf/Ng1Fyw
	Cr7k0Oz79bSZpwo0QMCO3Arc+4IUNQv1SdkQANJl14+v+otVdWWDxNWuWR55+Idz478ODU
	D5WWY893wSPTtMERn8fnFt0W4Lz12SM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hMHi3EVW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=87KJldLVO12YI6/aqcMypvZbGEc4Q23o2OfJPWjlafE=;
	b=hMHi3EVWgudVW3Rtpsa9f6sJYDStIiDsU507vjY2B72mqcuP4Ckx6E3eLT1b9Gf/Ng1Fyw
	Cr7k0Oz79bSZpwo0QMCO3Arc+4IUNQv1SdkQANJl14+v+otVdWWDxNWuWR55+Idz478ODU
	D5WWY893wSPTtMERn8fnFt0W4Lz12SM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12998779C3;
	Fri, 24 Jul 2026 13:33:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id redGM7JpY2pIJgAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 24 Jul 2026 13:33:38 +0000
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
	linux-fscrypt@vger.kernel.org
Subject: [PATCH 00/12] fstests: introduce fscrypt support for btrfs
Date: Fri, 24 Jul 2026 15:33:16 +0200
Message-ID: <20260724133328.1837318-1-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 59EDB7B88B
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

This is a rebase and cleanup of older patches [0] from Sweet Tea and Josef
fixed to work with the recent kernel and btrfs-progs changes.

[0] https://github.com/btrfs/fstests/tree/fscrypt (227ac42)

Daniel Vacek (1):
  fscrypt-crypt-util: add support for per extent KDF

Josef Bacik (4):
  fstests: properly test for v1 encryption policies in encrypt tests
  fstests: split generic/580 into two tests
  fstests: split generic/581 into two tests
  fstests: split generic/613 into two tests

Sweet Tea Dorminy (7):
  common/encrypt: separate data and inode nonces
  common/encrypt: add btrfs to get_encryption_*nonce
  common/encrypt: add btrfs to get_ciphertext_filename
  common/encrypt: enable making a encrypted btrfs filesystem
  common/verity: explicitly don't allow btrfs encryption
  btrfs: add simple test of reflink of encrypted data
  btrfs: test snapshotting encrypted subvol

 common/encrypt           |  94 ++++++++++++++++++++++++----
 common/verity            |   4 ++
 src/fscrypt-crypt-util.c |  12 +++-
 tests/btrfs/613          |  54 ++++++++++++++++
 tests/btrfs/613.out      |  13 ++++
 tests/btrfs/614          |  73 ++++++++++++++++++++++
 tests/btrfs/614.out      | 111 ++++++++++++++++++++++++++++++++
 tests/f2fs/002           |   2 +-
 tests/generic/580        | 118 +++++++++++++++-------------------
 tests/generic/580.out    |  40 ------------
 tests/generic/581        |  89 +-------------------------
 tests/generic/581.out    |  50 ---------------
 tests/generic/593        |   1 +
 tests/generic/613        |  24 +++----
 tests/generic/613.out    |   5 +-
 tests/generic/798        |  77 +++++++++++++++++++++++
 tests/generic/798.out    |  44 +++++++++++++
 tests/generic/799        | 132 +++++++++++++++++++++++++++++++++++++++
 tests/generic/799.out    |  51 +++++++++++++++
 tests/generic/800        | 115 ++++++++++++++++++++++++++++++++++
 tests/generic/800.out    |  14 +++++
 21 files changed, 845 insertions(+), 278 deletions(-)
 create mode 100755 tests/btrfs/613
 create mode 100644 tests/btrfs/613.out
 create mode 100755 tests/btrfs/614
 create mode 100644 tests/btrfs/614.out
 create mode 100755 tests/generic/798
 create mode 100644 tests/generic/798.out
 create mode 100755 tests/generic/799
 create mode 100644 tests/generic/799.out
 create mode 100755 tests/generic/800
 create mode 100644 tests/generic/800.out

-- 
2.53.0

