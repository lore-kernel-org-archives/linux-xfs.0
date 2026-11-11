Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794367033;
	b=xrrbt+PiRSnFu5fGkbjg8QA8osKfS1SRsrtVX/rnpDnim6EcTSiD0N/ezVa89xQ3RiQj
	 UtnjZP2o6bHGJUqohVmJRnIBMVWm5jl/FDuGEcXVaUBbNWvC/h1do3b0mKhMzZvqqvPHa
	 ZKAk2eNIrjC/WOnBahmwB3NBso7WTeXpqu/7NOzvhMev2FMoVGBvLXBCiVRlcXxHoDPQg
	 Ab7iBi+teFplZuOnvNOn4AawvgHVsuHdSsJlvsDtfWbWLbunIYuFMdnAWB/BVwfy2qYjW
	 muLwEvoix48c9+sCQaiZIcvxDNqwfYbJ8rIMfY1DOc2YxgLWGSo11vpCg6/1GNPkPfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794367033;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=1vjq4WJ2E/VrmteftSGIAuvyGzJ38GK9he7dKG79KRU=;
	b=tjHcXTgtYakXkxM5tNyHZFDSsDD+rYYpzTm/ANAeIwN3YhKksUKoM0m1bRXQ81PzFVCx
	 g0A46WeQE2Fyp90kdpE4ZNydrfefleRzWPEIYgt8MQ49aIFwKQ5TDq3Wit8DLGm7nGg1U
	 lFTZDEm5hZo32Nype2TdkzHPcnK3Du22WZAhYGOIc2sBdf3aZabYXgo2f21aV2gHsO+Cw
	 gwId9dvg3WK3DMzTsXWq5rJMh0sfqeZKFrONDjO60Id4RbkkmfER7uRbmM5Cf7nMoh+qq
	 Wkbuq/QatjxfmDGkK968gQLQjaUiaXaPfzqgitFbeY3C+A9+HJxff2jhLYFXnZI9n8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jazMZnms;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A23A60A2600;
	Wed, 11 Nov 2026 03:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jazMZnms
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794367032;
	b=dPfxmDneZJFOM4sbndUz/FaQzxBR2QlJroIm1vuHBcMMLkz3dejlJZIppRs2acHLxRmz
	 +m3Lk5zIWHmiKp/BI76/E9V/5AXHZJ5R92ac6Iu7I2SJm/BzZAmZTybYFv79h8bjGM551
	 gYen9BI52LwHOdjMMjzjsxOtS9pPgSUISp+bd7D/THmIWueJ293h0WMGgTxDeYznrYsh+
	 pyJQo4IgYYc+3k0Er352AXV1B2Y+9r1ykHLWAIs3hDQquP34IMzbreyqASkNZBGhasHux
	 oapL149AvlLLIN1Z7CdkusUiqjzvAnKbkvIunRJsuL7s/qX5l1krXFuwyYPmqeVjqFQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794367032;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=1vjq4WJ2E/VrmteftSGIAuvyGzJ38GK9he7dKG79KRU=;
	b=M7iJOBRWSrdg+ZgrfoP+yhpe1GF5jSzUjlt/19Fe1XY692u5NMt3KIlLUAHHD8XXpkDm
	 urha66ToT9ZZzKCLUeAOzurHP/Pr45hxuCvK0Gd0YPWG7r8fmYuqlA6PIvA1HBpSoW4L0
	 JGRk46yldAA5Oqm77cKkcO/miB2R9oZlnoReUXyY0lP7PZzZMW3Auqr3ToHPp2orf3ntF
	 kNTMg4txdTzT3s+tBnaCO1SC/S6jDgemtlrSNVJE5QrOBEDbi2HcXkrK58Fldx3F2LwY3
	 92A84vetLNdzv2fbQs+8Brlc2aiKw1OneChqxW/imp2o0RhY4nSnsTQ/fkmwIinC/zw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 43BF71F0093C;
	Wed, 11 Nov 2026 03:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794367032;
	bh=1vjq4WJ2E/VrmteftSGIAuvyGzJ38GK9he7dKG79KRU=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=jazMZnms7uOcWXLO8P8O9t/Xc7f1ueVcF4Qazm+cU9arL674IVdrbMCjkpdIwg1FF
	 FpYAOqCWcKPxkZaITMBfh0CbGR1DBrMkXs8nSoS6IAxSCBs+B+fTSjXM8On3XV99p1
	 lEQU/+MX0EgTSsdXdZo3mS9EgDie4MIqvcECJko7ZHuyKhTa+WEF/XMts4K9M4ztII
	 1uHVaVr6oIl2q/Yqtdrz8jpYsJawlzu6TzENeVlpq4LYNPclZ1/qanQdLI7wczUI3C
	 Jh6mIe30gqTE5KjT/2ZL6kW7pDdFpMBR8I5XCoMl8KvtbM1sm3eV1ZIjvPdyh26QrX
	 FTsjUrxxicaqg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8FBAF48D44;
	Wed, 11 Nov 2026 03:17:11 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH v2 0/2] xfs: skip redundant fsync cache flushes
Date: Wed, 11 Nov 2026 12:17:10 +0900
Message-Id: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADbe82oC/32NQQ6CQAxFr0K6toYpgYAr72FY4NDCJDLIVAiEc
 HdHDuDyveS/v4NycKxwS3YIvDh1o49AlwRs3/iO0bWRgVIqjElzXEVRdPMW5TVrj8oTllnDZEU
 Kohzi8h1Y3HpWH3Xk3ulnDNt5spif/d9bDKZIVfVsJWcqbXbXZtDZd1c7DlAfx/EFdgYRZrgAA
 AA=
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
 Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794367030; l=1829;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=c4BWBwBKwkn74Ov6XMf6CjVsk1F8tqFkdQIPCAjSv4w=;
 b=ZLCHVLmcQn7q5tXwuxyvwaz6vsXPLFdxDMUFZLVPgOA7X+r9TAs/5MTtqOZ4/XN+AL1GolO2b
 V40e8hp1lqTDZ/cX3Bc/KdIZbERy3JFUYZtJZ7Htirh+5kKz8PyDJ0Y
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

Concurrent fsyncs often wait for an iclog that another task wrote out,
and then send their own cache flush. Patch 1 numbers the cache flushes
on each buftarg. Patch 2 uses the numbers to skip that flush when a
later flush has completed.

16 fio jobs of 4k append + fsync in a QEMU guest: 1111 -> 4498
fsyncs/s. fstests -g quick shows no change, and a dm-log-writes crash
test on an internal log lost no data (patch 2).

---
Changes in v2:
- Zero ic_flush_seq after the bio setup and take the flush number
  where REQ_PREFLUSH is set
- Move the fio result into the commit log of patch 2, measured again
  for both kernels on the new base, and add the single job result
- Rename the argument of xfs_buftarg_flushed_since() and the fsync
  local to submit_seq, and describe the submit and completion ordering
  in the comments
- Keep the fsync comment on why the flush is needed
- In patch 2, shorten the DAX text in the comment and the commit log,
  and drop the commit log sentence on numbering the fsync's own flush
- Say below --- of patch 2 what changes for a failed flush on
  bio-based dm
- Rebase onto the current for-next (v7.4-rc2)

---
Daejun Park (2):
      xfs: number the cache flushes submitted to each buftarg
      xfs: skip the fsync flush when a later flush has completed

 fs/xfs/xfs_buf.c      | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h      | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.c     | 18 +++++++++++++++---
 fs/xfs/xfs_log.c      | 28 +++++++++++++++++++++-------
 fs/xfs/xfs_log_priv.h |  1 +
 5 files changed, 120 insertions(+), 10 deletions(-)
---
base-commit: 48326a2382d80715475d10ce98734ac65d2d2150
change-id: 20261105-xfs-fsync-flush-seq-83ae2cff6225

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


