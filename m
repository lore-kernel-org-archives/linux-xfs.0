Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240581;
	b=BOYBCfZaM0LTwRfaMBGWGANi1lNwymTrnkrQGX2YWqQ5WW3ocQgslGILnJe0A3paskHz
	 e1XTpk3G0A0CwDtlek5iavkxtaxa8QUgQh5REYRr8yOxA1E8UCfPX6BYSStOQ/jWZaXpN
	 Ob+31JRl7ArmBg68vDVWxfxFHjP8eMbPNHoraUV7rvNrfJzFyjGpBvtEiAmSewakOQF/X
	 9yT4g7QgqkTFz5acl0648ZqUc55GqTHOpegkD05gIdCc9uApKkUC6uouf3a66QP7mcZth
	 aHSh18a3acr/8N+FDkpzakfewSBBSOYDYJHXEdGj+Xb6p3ZqBpokZLOD5Bw3nCgwb8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240581;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=4XiBHu6J1/Wrk04/tYhxMDSUV7+mtsUoRrkmRrRsd0M=;
	b=one67BU8UOa8ffvYKot7414cNWfNIh2J5WtC+9vcH2skIaM4FynkUHANH4PJwpYjVBK8
	 3DG5pG7nccr9IfNQwR4Y4rbWcPXDP7o2YkI/9G8BTfKIDJmpQQ/2HVbH7H8TfWJeln+VZ
	 wvHNHbo3tTJ4pEg0n8JQsGnGWVx10slhoDZAdk1xdzeRp3izFN96N1XIeBbiqJ0K5V5EK
	 AlFkFkM4DlIlze+xXkXHktKK53zk27OpsfV1gZ117ZZBcgATpAi6NML0Hqu24l81Dk52+
	 hIE36RMGuNYQ5jyjEukLpnpZAJCVVocFErIPTiD/Wt7urfosa4gwXk4wHXm2xQoL4fQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lL25Ki0F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5264606A31D;
	Thu, 29 Oct 2026 02:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lL25Ki0F
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240580;
	b=bX5I1nwQpqXfR9EQ/S5eGx1Ly8xCcB/6muvsbQqCuu4hdmsB7W1HyavQzGHnL+QMFLLK
	 KqbDa7G9UKvhjNtlYmcJJiZ4/VOAJcO1dj2XPC4Fp3EdEpVxWBuyWemh6bhjogLRDP1Cc
	 Jsb4nBS+E/Bf/QRH7NO+pAYTx+G48E9Cc8AA8BG5hkySpEkA9VJNGoW3fqOYpAlRCNGqf
	 foZLv6g811EUqX++DTx77/4o9Z+Sp8I4nAKLO9c/EPmtH9ahJTH3Le1X7BDWQFRrp2bFt
	 sBfo23k/3VDgk5SzTIDqRP4oV21wPmSZsEo8KRZ6fJTQN2VnJtC89rD/4mz/WBXAacw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240580;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=4XiBHu6J1/Wrk04/tYhxMDSUV7+mtsUoRrkmRrRsd0M=;
	b=OQ1mxFaRBiKiqEOhKsSsL0n4YatP/UOavyMXlkCorkSJNkqrVg8jGyMoyDW+/BMiLo8A
	 fItggKoLDK7H0M7i1KW1INnF553Zt2+IoxVEx3BeuVNuDVSMyY6voRziUJA1gt11rTVwP
	 cYYDPcw3o4DfuXDT0JCrgsLjcdLfQJ7CYOXVKJUUHQ4Cxq0Mu3lJu1WYRigEglVRKEIwQ
	 KObtaq33iIVrHSNRg6MJWpe8XxPhZkHlJIUxL9uYGhygoA/uscfIKbLeAhIQtswMKlsb/
	 6efRolrT5ZOEXXCuA4TDFDDxR8yKRPZZfcZ+LnwEohmw8Tqo1FcAFWJL9yTGCJfkc6g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 56B0E1F031E2;
	Thu, 29 Oct 2026 02:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240580;
	bh=4XiBHu6J1/Wrk04/tYhxMDSUV7+mtsUoRrkmRrRsd0M=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=lL25Ki0FcCwkvnUQCASQEDpsS/YI/zKPTPfcyTnxaDipcbmKXTSAaElgr/IOHG4l1
	 +W0QPiQd5zOEQLcb5CWs577B0mytcLfNMgQdZmEeOHZ/LdX8oiFPX7A9mfQYz7uZCr
	 56eL20toH5IobhNd5EnfnybvalVkIlfQtR8cx4/kALenJCRv2ogPjb6eFR8+e/pO0r
	 gYKaup7gKCZ49CNx7yZaAflGdxG8dBITwdDUXuwqxjpc+YZozn2RQNqkKRNmcOEroL
	 7fdeJ85GAuWIUFx9fVHn+DZ2w158iVQdh+qDTyjMdgwL1MW2FFtwtYz/T6j82MN2Hl
	 Eyjx3Wv/chjMA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A6C3F45662;
	Thu, 29 Oct 2026 02:22:58 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH v5 0/9] xfs: pNFS block layout fixes
Date: Thu, 29 Oct 2026 11:22:57 +0900
Message-Id: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
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
X-B4-Tracking: v=1; b=H4sIAAGu4moC/3XMQQ6CMBCF4auQrq0pQwviynsYF6VMoQsK6WCDI
 dzdwkpj3EzyT/K+lREGh8Su2coCRkdu9CnUKWOm175D7trUDASUucgVXyzxyafT6Nn0/KKkqiE
 XGrFhaTQFtG45wPsjde9oHsPr8GOxf/9SseCCK2lN1QDKsmpvpAd6+u5sxoHtWJQfAIgfQCagh
 kJYDUZLLb+BbdvenCpY+e8AAAA=
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=3097;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=c/1TEndM7InozfzPWoIRGtybrwNWX1Xg1TAnNYOp1+w=;
 b=+Hhyw83TxI8HBGZoFKKAYZ5ZKpcWypWiqrKh4t6W7wio3bJbyDws59vEZFOTU1tWLU0qPm//I
 qF6I4tSSzeeBalOMkb+d7qFEdRypvTghDUpMls7MXTVTL0HZ8NHuXOt
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

The XFS side of the pNFS block and SCSI layout fixes. A pNFS client
alone can trigger the bugs fixed by patches 1 and 3 to 6. Patch 7
closes a race with a local process writing to a shared mapping.
Patches 8 and 9 make a LAYOUTCOMMIT stable the way fdatasync does.

Patch 3 needs patch 2. Patch 4 should not go without patches 2 and 3,
and patch 6 not without patch 5. Patches 1 to 6 are marked for stable.
XFS_BMAPI_CONVERT_ONLY takes bit 12 of the bmapi flags, which the
fs-verity series [1] also uses.

Tested on nfsd-testing plus this series in QEMU guests. nfsd exported
XFS on an nvmet-tcp namespace to pynfs ([2] and local tests for patches
5 and 6) and the Linux client, with KASAN and lockdep and also with
XFS_DEBUG. fstests -g quick ran on a local XFS. Each patch builds with
W=1 on for-next.

[1] https://lore.kernel.org/r/20261002223705.2175542-14-aalbersh@kernel.org
[2] https://lore.kernel.org/r/20261014-pynfs-block-commit-v1-0-1723979f495f@samsung.com

---
Changes in v5:
- Cap the block count in xfs_iomap_write_direct() instead of
  xfs_fs_map_blocks().
- Clamp the layout length with min_t(), as min() rejects u64 against
  loff_t.
- Assert that XFS_BMAPI_CONVERT_ONLY allocated nothing.
- Shorter commit messages, with test results below the --- line.

Changes in v4:
- Limit a pNFS allocation to XFS_MAX_BMBT_EXTLEN blocks instead of
  refusing a count whose reservation would wrap.

Changes in v3:
- Post the XFS pNFS patches as one series.
- Split XFS_BMAPI_CONVERT_ONLY from its pNFS user.
- Return -ENOSR when nothing is mapped, and commit the transaction
  instead of cancelling it.
- Add the datasync arguments to xfs_log_force_inode() itself.

---
Daejun Park (9):
      xfs: mark the inode preallocated for pNFS write layouts past EOF
      xfs: add a flag to convert unwritten extents without allocating blocks
      xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
      xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
      xfs: cap the block count of xfs_iomap_write_direct() at one extent
      xfs: clamp the pNFS layout range to the maximum file size
      xfs: take the invalidate lock while mapping a pNFS layout
      xfs: add datasync and log_flushed arguments to xfs_log_force_inode()
      xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync does

 fs/xfs/libxfs/xfs_bmap.c | 14 +++++++--
 fs/xfs/libxfs/xfs_bmap.h | 10 +++++-
 fs/xfs/xfs_export.c      |  2 +-
 fs/xfs/xfs_file.c        | 52 +++---------------------------
 fs/xfs/xfs_inode.c       | 36 ++++++++++++++++++---
 fs/xfs/xfs_inode.h       |  3 +-
 fs/xfs/xfs_ioend.c       |  2 +-
 fs/xfs/xfs_iomap.c       | 28 +++++++++++++++--
 fs/xfs/xfs_iomap.h       |  3 +-
 fs/xfs/xfs_pnfs.c        | 82 +++++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_zone_gc.c     |  2 +-
 11 files changed, 147 insertions(+), 87 deletions(-)
---
base-commit: ec8f62cc109a3f596b3c65dc0f1011c209239051
change-id: 20261015-xfs-pnfs-batch-85459210aeeb

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


