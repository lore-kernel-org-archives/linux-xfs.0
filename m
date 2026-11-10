Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234516;
	b=0PiyunGOcU0u9RyP2DgZI6EXWBayX6QMCp1EL52ehXOjJK2dip1cAbqy4VfRpkbBnoKG
	 tus+W25G2k6Qs+eSKeWT/ytnivav2yU14BBxZm0nWFkJu8LNBzICJrUeAOydOtN0XiqrS
	 Uvnoja31GcAZ2EUzXyOKg0GOP+rzFrFqIQ1c9vQgamwbounurKEBjDMboo6zlhyT175cq
	 dOHusZhoL47K9IQGBCYmaIhcWLJ0/a68YqZ2sLCgpoXH+iKQP6faRUUQSbi8b0z3v3AFu
	 K2dJ1NfpOqOyy1l9bGfwWiJEIutdkS9In+RjcdAqCtVWXA1piVMjMgdD+DHl4Xrop2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234516;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:Date:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=nejG8CTg/b7KBR9Zc2Eod3tSixBdqEzA8yLaK1qcvpM=;
	b=5kCH3JIWYD+V9Nf7uE5/x1zodNtWsdNsIkQ4cqUx6kHTWQflQ7M9z+8hHQwtB7Ytz9BB
	 pOhofQiu6bD3oO5jM6axXhSucDfTIOrSrG2sENk6EaJcnQ5wI9BmO0rF2RV3l2t97htI4
	 tcLpTFdHueyEqb33prlsygZXfvjov9/AQSgbqrMra1XZkDLps9Dp26X4ko58teEhdjuUV
	 UM3NgwMMiWWgxeB3MT70Dz/qmVsVPphOip1bPg0ZUdkVROLZSsWUKXkebBVIRWBHEJ5LQ
	 hAqV637xc0E5+HCWYtK0oTLas3MHamAoNR/6jpGbIZ5NHLPdn3fGCbubbs5PwxexpaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=OnrH+nIS;
	arc=none smtp.remote-ip=162.62.57.137
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFF7606A325;
	Mon,  9 Nov 2026 14:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FFF7606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=OnrH+nIS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794234510; bh=nejG8CTg/b7KBR9Zc2Eod3tSixBdqEzA8yLaK1qcvpM=;
	h=From:To:Cc:Subject:Date;
	b=OnrH+nISw0aXyC1IktZpkyCojcAQt687Lg22+JBh4nHliTgCBeSuQMlRZaGGHxF0f
	 aX377fxuOU2iP2iSUYQwQnqTJ+GwI46rQDEBRAVh9dmYyhgU1VBjAXu9/68ZliSV7J
	 X3BZhgx2lVrHOlkCz/ZHHxDrl8zpfMvjNq/r9+rM=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 71C3506F; Mon, 09 Nov 2026 22:28:28 +0800
X-QQ-mid: xmsmtpt1794234508t94lyr68f
Message-ID: <tencent_F39A283F1F83A8B954C5EFE09123A72F5307@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNzn0jjLyk5wjRneX4y+Koo4A+TE8pvCz3PQEc6mRtc+jTZ6gu8P9n
	 5CbbLV2/4F9JNVE+wWVDqw8TFuLkxyl8iBZMW+l6mGinoxtZtXJoBP3IH5YaGt0r6y9T6YNMGerp
	 m1ZDmmmdmACTRS0KFzXMpp3dR5urMAKaOolyXxJ4zs8HYwbEQhYuu3FAqnkaOJOomP4f4/0RwFDw
	 aNzzXtom7cf7CNx9x5PqfLS9EjW+npkdH/iHXO67iVtzJ3D+K9I9SjyaoI3IyawDXpTvSGKWQ5+E
	 +0Qz9Pn36wmf/WViC/8sE9nTZGOMrfztlPdyVReTVWaq5Z8H32Bc/tAQiBdaVb1EVeYjdjiSKEHg
	 JDC4L6pYiEut39sYiRMJlRMviOg1xpSOeX6m6sobtowa2l3U5rdUvgNxSx6iTKujnTGDqrmqH4tm
	 Fm/emvsGRUbIslK3NcF9sDlbrh5RSwovfgPz9y1qBQbFt7yCMQ1yK8yA5Np4q+CYEtzKg1jb+wQ7
	 caWLbvDkR5b+Mh2sUkP7OA/RiCkzkmEyX75ypvdxyuV3NdR3Csb4sXwX8GUU+CvpyJI5S2nNzwK9
	 C1wKprqSnfBPhKv8D54ked5bZq1pcwFUbsA4LgRja+Z2ghGEDZ1c1p9W3rjvK4xzBK3qFzavFYGr
	 iGfM4bL1+jxdO9O+rIi5/vUdhNmQPiFopTV+AdarOeqFG+ygltD1JW1GGOBHhI0gIaIimW2vBcgY
	 s5hr0O03UTkfUq7DS/q/4cwlySVZ63olNMOgWq0mopVTuzfXJvY3VTLG8CBnDOsD/w7wiWDzHF+j
	 JW6wAZFkNrLyqYBWvw1Vlpj2j8EY5WLS+6z5K5+EvxLmWIBHaIOTQDlp+2JvH1IJ2WfIZKFDsoOp
	 EMDRhDPnG4TSPItu+R/5wowBRnQHemhypc1d9J/OaNv/7QcT+FzW2N3Yy3NN0gz5hpy5lJ3uQWlp
	 oGbb8/70bJj16ENLH4Ix8NNnX0w+tDnwpCYW4ocNty5nsfJ325JmeM/EiCMxj4zzAtV5nGD8gHjX
	 LoHJ4PsyNtf5ak9EMLc1FrExEB/b3TKJF5mrtjgtFR2vv2Pywh3sfKDRuwOrRamQ/Nj/UYHw==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: xfs log recovery: six distinct issues, one per report (index)
X-OQ-MSGID: <c42-xfs-logrecovery-index-20261110@qq.com>
Date: Tue, 10 Nov 2026 10:00:00 +0800
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

Between 2026-11-07 and 2026-11-09 I sent six separate reports about
log recovery in fs/xfs. They were posted as replies under one subject
line, which was a mistake on my part - they are independent defects,
each with its own root cause, its own reproducer and its own fix. This
mail is an index so they can be handled one by one; no action beyond
that is implied.

1. XLOG_WAS_CONT_TRANS with no buffered region reads ri_buf[-1]
   native NULL deref at mount, no sanitizer needed
   Message-ID: <c30-xfs-wascont-rideref-20261107@qq.com>
   fs/xfs/xfs_log_recover.c, xlog_recover_add_to_cont_trans()

2. Logged superblock geometry installed without validation
   UBSAN shift-out-of-bounds via sb_inopblog
   Message-ID: <c31-xfs-logged-sb-geometry-20261107@qq.com>
   fs/xfs/xfs_buf_item_recover.c, xfs_sb_from_disk() +
   xfs_update_last_ag_size()

3. ilf_len used as buffer read length without requiring whole blocks
   KASAN slab-out-of-bounds in xfs_inode_buf_verify()
   Message-ID: <c34-xfs-ilf-len-oob-20261108@qq.com>
   fs/xfs/xfs_inode_item_recover.c:351

4. ilf_size read from a region shorter than the format header
   KASAN slab-out-of-bounds in xlog_recover_add_to_trans()
   Message-ID: <c37-xfs-ilf-size-short-region-20261109@qq.com>
   fs/xfs/xfs_log_recover.c, region collection stage

5. Buffer data map runs index ri_buf[] unchecked in
   do_inode_buffer()
   KASAN slab-out-of-bounds in xlog_recover_do_inode_buffer()
   Message-ID: <c40-xfs-inodebuf-item-index-20261109@qq.com>
   fs/xfs/xfs_buf_item_recover.c:625

6. The same unchecked source index in do_reg_buffer(), with the
   destination side already fixed by CVE-2026-80536
   KASAN slab-out-of-bounds in xlog_recover_do_reg_buffer()
   Message-ID: <c41-xfs-regbuf-run-index-20261109@qq.com>
   fs/xfs/xfs_buf_item_recover.c:464

Separately, ilf_boffset (report of 2026-10-31, bumped on 2026-11-08)
still has no bound and is a distinct issue from the six above:
   Message-ID: <x1-xfs-ilf-boffset-20261031@qq.com>

All seven reproduce at mount(2) from a crafted image, are deterministic,
and are unchanged in mainline as of 2026-11-09. Reproducers are
available on request. Happy to send any of them as a patch series
instead if that is preferred.

Thanks,
Guikun Yang

