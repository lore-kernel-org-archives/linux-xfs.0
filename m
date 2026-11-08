Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794157962;
	b=mLBW5aHkHeuMVPcKEnA16sam/20C5tTm6XugxhOsD1JEfn159JdoyTtdrlhe2G2dLGZ2
	 mqGxVnif8XvJ2TDgU+Ow4IVdz8i3z+N+ii9dtwqh78a9rUr14fYFYk8U+JsMvpHQh/DRQ
	 anH2m83bw0+M2ifazrbb4GvNNckx6CWKFxkEa03vLO27n79hXIuIzCtoJ3CiDLYcFZR6u
	 yPKOpf3a27ge1zgO7lzSic3A0PlJbSAOd5/x0LzeD1yW0QdldaxiRNIw0GOmEIZjdRVC5
	 XNsWUatDK2LPfGU+Z+u08V4wsoWcDENNMSiFf76dLdmSnS3rrcwVMlA77iP0dBlnXVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794157962;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:In-Reply-To:
	 References:Date:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=NAoWQ8bqngmCAJMYimjkXJJCbpoBzq8KQBssKRJjvhs=;
	b=pukWhZVMIseJRJRX2+HEizS04+vO5r9Mmof0bEoSVTVhqmjAfPFp1gdq2o4QTTH93kgE
	 g7g6GC52xYYKwg0bxF1nDanpWjDQ5cKvFMIl/S2Fsv71M0rtqR5ggPIichPv62Ap2xtDB
	 GUzoxY4zuEeCtMuol0fTxZT/NphVfbEAbZdxkCwAIVlFGYGqGmYz9Sd6K1Zc59+yr1uln
	 +rJI9QXh7LmpCwRmivsy2/NsaI7PFSqN5bu54Bfw20XLL1vSAuNQdnWd/Vf7FwIl4gLxU
	 nEYbnCgcpTHZj9XGtp/dp0p6aNYgTpDloZERbWkjydpwnr/AZuBePeYygbc/s1ERtGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="q9/m7L9q";
	arc=none smtp.remote-ip=203.205.221.210
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CB0606A31C;
	Sun,  8 Nov 2026 17:12:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58CB0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=q9/m7L9q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794157956; bh=NAoWQ8bqngmCAJMYimjkXJJCbpoBzq8KQBssKRJjvhs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=q9/m7L9qAYcjcOkiSzT6bJqs7NQZlJxj94x+sCa2eKznTJCvdmV1kDoa4gXuEvNfr
	 yFa/B98BKwIe5SBFXUhF9K9KdYDiBxcnAxWne72d+hbGvjcG74yRiZsud/v9nw//g+
	 S1LnOnEpYC+YkqCCWYe213eqIJwxGtR7N253Wi/w=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 322190AD; Mon, 09 Nov 2026 01:12:34 +0800
X-QQ-mid: xmsmtpt1794157954tzibjr0oh
Message-ID: <tencent_4E67A4DE89D134238ADA273B4A2095ECDB05@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+FC2NnpBTyNTEPtbf1tZWZs/MhAmlhicwXnWeVWssMQKcSMCf5k
	 kzTi00LYk4MEFxc84ZGMOCu3okSdgBzZ06njPJOJv3ijBlkEloT2Lxqr+GAfdW4tmLI47OSmn232
	 NlKg8DASWBRvsuM32zH5mJJ4QZi5XCL33W4KFuUEboYh625xa/3lqm9pw3x+9ed6bNoPRJWHTcTz
	 G4guqFzYrk99G8U+vDDgjNcCnKwni9COd1Wg8wa5sb8WU6V/kWemL0emQYxTAgGxBCGttNFUJpNz
	 jxQxCzlUWMB5NYmGw9PFIKXn3k3qoSYz9wB79o41exEYFGes+7GHebwmF0AWsz12LDxSW5zENhZF
	 wy/SUj/ixH3PKQ8g5GsNaUGw8eIrQS1gpaIZZgyLd4cFkmFgk875+bwpNQigMFoBAMO/u8f4cRIz
	 ad5aegztlXGes0mDTlp0e5NkVAR85B7u71Ai6cISVlEXiMukPI3f+6bGi7ZoYbb2J7cMnIjAgfnw
	 kaNVbmSyxUNPtEV47FvuYwWjyZrizaoJrr/2FkJl4/XEhQnL8D+2rEsM0jYAO7Q8Zi6JK/ZHaDq5
	 1DVDG7n/W5zf2kivkdW6S2+dDWUf84u9e0Wz35bzP9YQulvp29a1Ilv0DVz1RfYOArY946B2Ex9G
	 HQ60Am+2JdzFvk7FIR/YbPB/66GdbZJuZZmlC1He3BF4MpGCwhq2Z6xR8DONK680TmDzy9N5JSgL
	 QFmDnSh/YAq0u6Bp98MHxegX/65nM3i7TVE65Gb25MtzSyL7lMtCfAA9oAdFw3BxkCxE7LWcorQ4
	 cmiVunQ9cF8XADrEIFz4qs7Boe4CABeGOw/p8dCdleSD30SxTwia8TxjquzFYIRr7bS/QBbRpYGv
	 kIuPhSQNqaHUnpXLBjtIPPbytg9+ByIdXvJEhS0ViQtiaudkPmSXnkUyRAn2jWhya+OOZ+pBgkVx
	 F44EnN590n8OBofkO2u1mMPSDONkzaRoZLVVASD61aTMcYEkNCRFWXekmoQ4VdpjB7jN5yrulIPb
	 N7VQMPH75WS5chATUjbKopQvyZ4fJEVsWl1DgMqA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [Bug report] xfs: unvalidated ilf_boffset in an inode log item
 reaches an out-of-bounds read during log recovery
X-OQ-MSGID: <c35-xfs-ilf-boffset-bump-20261108@qq.com>
In-Reply-To: <x1-xfs-ilf-boffset-20261031@qq.com>
References:
 <x1-xfs-ilf-boffset-20261031@qq.com> <c34-xfs-ilf-len-oob-20261108@qq.com>
Date: Sun, 08 Nov 2026 14:00:00 +0800
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

Following up on this report from October 31 with a re-check against
current mainline (2026-11-08) and a smaller reproducer.

## Current state

xfs_buf_offset() is still a raw pointer add:

  return bp->b_addr + offset;

and ilf_boffset is still used through it exactly once in the tree -
the bare call in xlog_recover_inode_commit_pass2()
(fs/xfs/xfs_inode_item_recover.c):

  dip = xfs_buf_offset(bp, in_f->ilf_boffset);
  if (XFS_IS_CORRUPT(mp, !xfs_verify_magic16(bp, dip->di_magic)))

Nothing bounds ilf_boffset against the buffer that ilf_len bought.
The xfs_verify_magic16() comparison cannot help - it inspects a value
that has already been read out of bounds.

For what it is worth, the inode-item fork regions in this same
function gained bounds in 9232301894 ("xfs: bound inode fork length
against the fork size during log recovery", 2026-09-23), but the
record carries more fields than that fix covered: the buffer length
(ilf_len) and the buffer offset (ilf_boffset) are both still trusted
as-is.

## Smaller reproducer

The original report used a three-step image construction. The same
crash now reproduces with five bytes changed on a real dirty-log
image: ilf_boffset from 0 to 16384 (= BBTOB(ilf_len)) plus the four
CRC bytes of the log record. The unmodified image recovers and mounts
cleanly; the modified one hits

  BUG: KASAN: use-after-free in xlog_recover_inode_commit_pass2+...
  ...
   xlog_recover_inode_commit_pass2 -> ... -> xfs_log_recover -> mount

3/3 at mount(2), with panic_on_warn=1.

The reproducer (log scanner, image builder, ready-made image, serial
log) is available on request. Happy to test a patch - including one
revived from the October RFC series if that is the preferred route.

Thanks,
Guikun Yang

