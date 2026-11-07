Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794047416;
	b=kkzuqGf13kZypLjGJHRnHnbJvGz+VuOOjzBAcbRdY76+avfrljwOsG4Nzp0RLmlC/zTo
	 WZQsciUswuKn1W7k5kkDqBEGiM2N5B8C9v7wPnKKSuxY4tru9haT9vRj91LzvwRQ0QJSf
	 h5ZEPlWqGvf/Tr1Naa92MyQyKg+aRPuDKmN08ADrAGjuyaszdW6ttaGrQH/DvOZXilB4O
	 xFbIF12FVkNcDXE6UPRcknfrOuAIQhVhW1EflVPiOmWKKFH3lHub1QyTODXIxThNlaWu6
	 +ILoYwV2m0VZ0vAnsiaDgzqyuU0pCPCwqZA4ncL1u8BVs/ZvjwKo02OP3E116zWzLeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794047416;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:In-Reply-To:
	 References:Date:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=TcuxYv+XuCgbw4KiXs1IpnIHCIqcFcgGjUNbAL5BTJo=;
	b=JjmMBTMs40BhTFgz7IDPrgNVtVFA9/+DjnW2z/GZ+n+W3G0Rrm27eXXW44aX7/eeGSXz
	 XWhViUXUOt5GeSfOCQmoSg8j01XWk3fNoiphuzYY8ns2a2czXTqPVNsZzqwGww7LSDc30
	 jKCm/N7DO8SDqqNEb8IvMmS+OmMdUsjFZYdrR77ZsBpYb4QJ4MQQUFyUasgB4zHbPaXKk
	 zI6CFyQcX9Fw0N9g2Yv9gBSIb0VSlEIWA61r6sbwWRZ4CZln3FfJ/sbZI0WRofBiahUL3
	 59//B+sdpA5qKKT4JybmRQTuBx9IY81GPiJD7Bo9E+ySWt36cfFvOVfv5xp587th+Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=jw8BDy9E;
	arc=none smtp.remote-ip=203.205.221.221
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A0E606A326;
	Sat,  7 Nov 2026 10:30:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47A0E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=jw8BDy9E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794047405; bh=TcuxYv+XuCgbw4KiXs1IpnIHCIqcFcgGjUNbAL5BTJo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jw8BDy9EuXav4ibaaFhY7jM0JBPqT5cW5NYS8bq5JLGlvS2EkVlyklc1gROwkwTCD
	 KSrHmSOUcjVYXz5ivZQ87+5omaSKM18W/uptqs1E9e9kobDroa6yKxs5r81kSlN0jU
	 G8M4AdVoZoMysbjXgc55F7bce4Tv1UJlUw1mWEIs=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 78380259; Sat, 07 Nov 2026 18:30:03 +0800
X-QQ-mid: xmsmtpt1794047403t2pocn9j4
Message-ID: <tencent_2485A31E7D66A27A52E9BF4747109D384C09@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+FC2NnpBTyNS2RInVc2qmDhS5yWgd4eXpIZDAJgOmE7RsMLEETC
	 jv9Ma3hitk/uCQSO/LT08tN5JGlrCeqzzZzfEjN4UxIhndbDn3OeqKgWdORXCbizTYLoWCGCP+tW
	 5RUtct0PQvy2czlm77KAxVTB7r6/e3aqgs2QMOvuB7OKa6pto5B4pDeQzKhmqtLQX6zvmBGVtKti
	 3cBRk5UcIKntwJ7lgUnTuGhFw0+GY5KAJvI9wBOYSlk6BmwNsnD+pyqbDdaU0XV0dRpJ9Er4Rp4w
	 w2WW5da+czlU74QfObT0mAXwWiYm5gURLt1LTde+22s+hEhjCnPryXQ6YPdcDiFVtL3OG8iPilN7
	 qhtDbDWqAiZvwS3G5srTLWubnc8AXeZYw0wPtrBUfcfZ5JUsLHlY8QQnpICS21ruEXByzfbuX9Dh
	 IvJ0Lex5ZlOlzw2f5nmebZ/tNc5Uf5CZSZiRe16+dCjf9KIMhIIK6/R5jH6dBXy1j5vpzsEx9vKx
	 ET7EvdlTFvjgDITF8oiFuv71thpX5OjBrbko6MT5gujk6Ty09NIaKJ6B7hV6OUutnfkbPQDRYwF6
	 Sy9OncDW1etsSTtRxUhQR1wkhMAOjIjeYLtCZ8x/Gb91wZ7Pb14g9cePwlvk+LTyVeK1AqxeafEK
	 b6vJaumzgEtWoc0VHnlVbkpkP57J8kesSaVGStbZwlgwcgnil2QspiH9xT9a66hCE9OdaCdB0BXR
	 /jHpDikNP33OLH/gt6g8x3tGZricD2/JqpyJ/qbLPIz8W+2n4VG/nSjF25uGxakofaLimNfvDrg1
	 bBR6dGwxGVkzPeJRqwoXA3I59BKgTHZUENFaCImSpqiNyPLa2SRZ87yFUi5285k9uZisoPMIx5zz
	 7DwfDLuHUDzs8hxXZ9YYQyzTuRTfZE+LZInIjxBMMJUZR7zbXnLhRaw0ghi4baZWrFUyTc8CykU9
	 /8tMjlDD8iAkvh7k2FEmxpOXV8GoXikoPI2ssK+aci+Lr75VyVrmzw0e2gt0BmO4dqoBrsw05JVd
	 9CrdqYG86EjacBoeKFpRZxcm0owz6QOA99DrxpZeAFa1Jk7yLlx/68iSH1to36FHXGmaBcmU2MJK
	 aFViir
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: xfs: XLOG_WAS_CONT_TRANS on a transaction with no buffered
 regions reads ri_buf[-1] - null deref Oops during mount log recovery
X-OQ-MSGID: <c31-xfs-logged-sb-geometry-20261107@qq.com>
In-Reply-To: <c30-xfs-wascont-rideref-20261107@qq.com>
References: <c30-xfs-wascont-rideref-20261107@qq.com>
Date: Sat, 07 Nov 2026 20:00:00 +0800
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

While continuing on the same recovery path I found a second issue in
the log-replay handling of the primary superblock buffer - this one is
an unvalidated install of logged geometry, and it is a different
mechanism from the flag-sequence gap reported above.

## 5. Recovery installs the logged superblock without validating its
   geometry fields

xlog_recover_do_primary_sb_buffer() (fs/xfs/xfs_buf_item_recover.c)
recovers the buffer, then installs the on-disk superblock into the
in-core one with no validation:

  error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
  ...
  xfs_sb_from_disk(&mp->m_sb, dsb);

The only checks afterwards are that the AG count and rtgroup count did
not shrink. Everything else in the freshly installed superblock is
used as-is. The immediately following consumers trust the geometry:

  error = xfs_update_last_ag_size(mp, orig_agcount);

which reaches __xfs_agino_range() (fs/xfs/libxfs/xfs_ag.c:172) and
shifts by the freshly installed sb_inopblog:

  UBSAN: shift-out-of-bounds in fs/xfs/libxfs/xfs_ag.c:172:11
  shift exponent 40 is too large for 32-bit type 'unsigned int'
   __xfs_agino_range.cold
   xfs_update_last_ag_size
   xlog_recover_buf_commit_pass2
  Kernel panic - not syncing: UBSAN: panic_on_warn set ...

The same mount-time read path validates these fields through
xfs_sb_read_verify()/xfs_validate_sb(); the recovery path bypasses
that entirely - the same on-disk structure gets two different levels
of trust depending on which path reads it.

## Reproducer

The base image carries a real dirty log from a normal crash. The
logged primary-superblock buffer item (XFS_LI_BUF, blf_blkno == 0,
XFS_BLFT_SB_BUF) is located, one byte in its data region is changed -
sb_inopblog, data offset 123, from 3 to 40 - and the v2 log record CRC
is recomputed. The unmodified image recovers and mounts cleanly.

Reproduced 3/3 with panic_on_warn=1. The code in mainline as of
2026-11-07 is identical.

Other geometry fields are installed through the same unvalidated
xfs_sb_from_disk() call and feed the same consumers: sb_agblocks,
sb_dblocks and sb_agcount go into __xfs_ag_block_count(),
sb_inopblock into the inode geometry, sb_blocklog into every shift and
mask derived from it. I did not chase each variant; the mechanism is
the single unvalidated install.

## Suggested fix

Validate the recovered superblock before installing it - the existing
xfs_validate_sb() (or at least its geometry subset) covers exactly the
fields these consumers use:

  xfs_sb_from_disk(&mp->m_sb, dsb);
+ error = xfs_validate_sb(mp, &mp->m_sb, true);
+ if (error) { ... return -EFSCORRUPTED; }

The reproducer (log scanner that finds the SB buffer item, flips
sb_inopblog and recomputes the CRC, ready-made image, serial log) is
available on request.

Thanks,
Guikun Yang

