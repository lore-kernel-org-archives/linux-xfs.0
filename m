Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734291F2C34
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 10:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742551409; cv=none; b=gIIj8UlWZSgufUlhAONL8JJIp0K5v8WO2zydod3PqfcP5UGTmKpJoklkyEtksDN69hDcgay+Njay26jTzJr2k9phpa6TADKYKUMTBsCLzDD6VHR1g724DMF7EC4LLQsxUONo8bcT/eQSo6l8h2ul50qCzQkJedLnnjkZWdpvR7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742551409; c=relaxed/simple;
	bh=FV44VZcR1js+hnb1aI5BSHm1UT4pV3TorvAixL7ea2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TVRwZ2iQm5p7LvYgL4g1/8J5eAoiFyDfExI/SXPu9KktSfXc61aFEyfVJ1/UKqkiSDHZKeBWs0+zf+Ot+1jNys5sAGfvd6UC77ebdH6nIhfWf0XPwzAtXd4rfqnZ2t9L7S0Fj0EK9Vy61TCThHjrpICWqnI+84W7FyVQJTbtd34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=utcnofUM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7K4tJWzk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mzPOvm1X; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XPXvjCjy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="utcnofUM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7K4tJWzk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mzPOvm1X";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XPXvjCjy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 787D121C29;
	Fri, 21 Mar 2025 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742551405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R14WN9kq4S6B1MuMjXKGLmRt+ArJv1VCUUhguggjFGY=;
	b=utcnofUM/dXiNC4zYtzKtm/NY3YX4f+/vCQwSchidq2kdaM0Eji798dGT96O+88IbbF5cr
	FzkK483Y0Az1+fKqVZBQNFT1cN06VCH/eKdphscLHBgZpVtIAWRV+ON9YYc4PFo3aS5Wyl
	50ka8M7ADwnEdq/dLtN/S1nqIH1EWcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742551405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R14WN9kq4S6B1MuMjXKGLmRt+ArJv1VCUUhguggjFGY=;
	b=7K4tJWzkssqhGbqhSTtBAaBnmLm8xFTwQNXh8YXEOhwC531enwmpdc6v/rOpzfRspw8E3v
	1XC618uPmnW1A7BQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mzPOvm1X;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XPXvjCjy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742551403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R14WN9kq4S6B1MuMjXKGLmRt+ArJv1VCUUhguggjFGY=;
	b=mzPOvm1XYKzWSXhZssTvfiwVK9umJXZG5FjmKMubT0E3p7nrj0VhGWpFIIgV0d356/Vrbi
	uGXQbjPZFnanwT6j9E9RcFk2+oPKre+Y2D7vUM+4BCUYMeBigXZ4LGsRHJ4ecDBT7mNwvy
	e9Lq8qYAQ8j1pO3pnsi7uzhQWX0/kig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742551403;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R14WN9kq4S6B1MuMjXKGLmRt+ArJv1VCUUhguggjFGY=;
	b=XPXvjCjySsWM/nGSA3V5VI7nP7kwjo+rRBj7Ie206vaVEF1zCEQ90re50cUZdw/HwRaov1
	wNos3spEHFhztrDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23ADD13A2C;
	Fri, 21 Mar 2025 10:03:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fzxZB2s53Wd7JgAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Fri, 21 Mar 2025 10:03:23 +0000
From: Petr Vorel <pvorel@suse.cz>
To: ltp@lists.linux.it
Cc: Petr Vorel <pvorel@suse.cz>,
	Li Wang <liwang@redhat.com>,
	Cyril Hrubis <chrubis@suse.cz>,
	Andrea Cervesato <andrea.cervesato@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Allison Collins <allison.henderson@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Gao Xiang <hsiangkao@redhat.com>,
	Dave Chinner <dchinner@redhat.com>,
	Jan Kara <jack@suse.cz>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [RFC PATCH 1/1] ioctl_ficlone03: Require 5.10 for XFS
Date: Fri, 21 Mar 2025 11:03:20 +0100
Message-ID: <20250321100320.162107-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 787D121C29
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_CC(0.00)[suse.cz,redhat.com,suse.com,oracle.com,gmail.com,lst.de,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Test fails on XFS on kernel older than 5.10:

    # ./ioctl_ficlone03
	...
    tst_test.c:1183: TINFO: Mounting /dev/loop0 to /tmp/LTP_ioc6ARHZ7/mnt fstyp=xfs flags=0
    [   10.122070] XFS (loop0): Superblock has unknown incompatible features (0x8) enabled.
    [   10.123035] XFS (loop0): Filesystem cannot be safely mounted by this kernel.
    [   10.123916] XFS (loop0): SB validate failed with error -22.
    tst_test.c:1183: TBROK: mount(/dev/loop0, mnt, xfs, 0, (nil)) failed: EINVAL (22)

This also causes Btrfs testing to be skipped due TBROK on XFS. With increased version we get on 5.4 LTS:

    # ./ioctl_ficlone03
    tst_test.c:1904: TINFO: Tested kernel: 5.4.291 #194 SMP Fri Mar 21 10:18:02 CET 2025 x86_64
    ...
    tst_supported_fs_types.c:49: TINFO: mkfs is not needed for tmpfs
    tst_test.c:1833: TINFO: === Testing on xfs ===
    tst_cmd.c:281: TINFO: Parsing mkfs.xfs version
    tst_test.c:969: TCONF: The test requires kernel 5.10 or newer
    tst_test.c:1833: TINFO: === Testing on btrfs ===
    tst_test.c:1170: TINFO: Formatting /dev/loop0 with btrfs opts='' extra opts=''
    [   30.143670] BTRFS: device fsid 1a6d250c-0636-11f0-850f-c598bdcd84c4 devid 1 transid 6 /dev/loop0
    tst_test.c:1183: TINFO: Mounting /dev/loop0 to /tmp/LTP_iocjwzyal/mnt fstyp=btrfs flags=0
    [   30.156563] BTRFS info (device loop0): using crc32c (crc32c-generic) checksum algorithm
    [   30.157363] BTRFS info (device loop0): flagging fs with big metadata feature
    [   30.158061] BTRFS info (device loop0): using free space tree
    [   30.158620] BTRFS info (device loop0): has skinny extents
    [   30.159911] BTRFS info (device loop0): enabling ssd optimizations
    [   30.160652] BTRFS info (device loop0): checking UUID tree
    ioctl_ficlone03_fix.c:49: TPASS: invalid source : EBADF (9)
    ioctl_ficlone03_fix.c:55: TPASS: invalid source : EBADF (9)

Fixing commit is 29887a2271319 ("xfs: enable big timestamps").

Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
Hi all,

I suppose we aren't covering a test bug with this and test is really
wrong expecting 4.16 would work on XFS. FYI this affects 5.4.291
(latest 5.4 LTS which is still supported) and would not be fixed due a
lot of missing functionality from 5.10.

Kind regards,
Petr

 testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c b/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
index 6a9d270d9f..e2ab10cba1 100644
--- a/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
+++ b/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
@@ -113,7 +113,7 @@ static struct tst_test test = {
 		{.type = "bcachefs"},
 		{
 			.type = "xfs",
-			.min_kver = "4.16",
+			.min_kver = "5.10",
 			.mkfs_ver = "mkfs.xfs >= 1.5.0",
 			.mkfs_opts = (const char *const []) {"-m", "reflink=1", NULL},
 		},
-- 
2.47.2

