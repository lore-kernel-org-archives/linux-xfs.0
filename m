Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794444117;
	b=xIhajcLO9X80OO9OMMHkDFUDzYp8msT6RuSp1qaWLgINHGtwUsXtHiDLLOtKu8WJ1w3B
	 6jDonNdlDHLSiIMyXb1k91uVuu8d2mr46Eq7N4GyspCddDR2uoIkZ6mMCHpt4+1Y3v3mN
	 GMTvrjUYduLeQj69SkcWV2hWqD+QHOMAMHX//RfRtByy2Y5UEDEQCbRwqKCVHrjYzevuG
	 y6vcQd7U/oImZKQfqXKFlX1PRnJLgUGTWFzkBrbvQUWK+8dVM+5jEvajBIUxa+X6EpTHz
	 oDGmTZPD5RmB9Pzzkfiih4O1cNXctGFktM3Pjn7w6OYoGW9cXz5dBK1fPrzdcBl/wqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444117;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RRta4FZ2e8Hmb5o5/lhGVzPWc/3peuR99+e6UdySdC4=;
	b=Z7YshQdVzXSPwz+7oV7emTfGjP47VHVUs8VJVDMk6cXyC0GmYba9F0P8/JhWFhqQcBYZ
	 hhy07jVzl/YLprr3uGaITaVHxGUpEa+LWvpM2XKfcVe59w6H+vq4Ko4GpPIDmXg/lya5J
	 UDjhjuHyqO+aWIjZP9mOIe7AiK73r8ydGJbfPaD1DL3PxyGwNz22ivaMcuJzZW40tYCgC
	 NZ+AKXWOAlSWvnK7vA2uNjQLIoD4xDW/3bFBK2B++Dci7LPF7VPzP1gp+C8k7XgIFWTSY
	 qMO0gWvJlvhEno30cTuPc8k2yW5a2XgbdnStHeprZJflA4gojoFdQXh4hStx0cegWxg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LsHIpcUA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A88606A324;
	Thu, 12 Nov 2026 00:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LsHIpcUA
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794444117;
	b=jt94tAut3/SHYOgt678m9EXoFhSHu3ijljw36LuwC53IkNNsADmYD0kmW5UQQuKmuw0Q
	 nm48gYqmU4QHQZYHSP7XjTxTYfYxr+uipr5MiuN7sy7j/EjsbUA2ZCxQgIpu2nfTJbJCq
	 NKdkLnLsSLI+cY68Nj75JRObDZFGvSfRAX7TGUOKB8LslD9C/ocEtC+DYkC2SpTKA6UY5
	 wfSO7YWYZrG63ZeUH5eWlUiIYx1k8DSFB4KbDFgEWfoVayIIWS0iKT9jIgw/M7Ca1NCh9
	 +N0BXel9zDR7bM3gkors+DPtuqComsh8hofptqCbcmO16ijfSBZHrbgEt3SOMbKMkxg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794444117;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=RRta4FZ2e8Hmb5o5/lhGVzPWc/3peuR99+e6UdySdC4=;
	b=M3bxMuHu2MSer5WhOD7f0unuY5pzD0kUjjZINLH6x4QCDYvE9y066uwUbS3i9xQSFMqW
	 0DzvoZtMB0W26GNsivbaGQRuvMGdMskXlJdV7zRvZc8aVUZzcn2XDVG9Qoc4mN66ddeyv
	 tZd4F6J6vFCcHOot+xS2ZUAmGOGXE1zI39Z1pUmxGNOkLscHuVxOF2Lj5ssMHwlnPvVCV
	 QRncFcR5kBfTNy63cWnjTHIR2gHPOyhANGl3ym3NNvc4Dl6OD1fJYMbHTxbBlPo8yXHOh
	 5gUq0jEZekApOtXT1pJEr9ol6RMKc8jHOWXSkdCDU+hlLnEGKL7lGlZLNCMqPyr7ScA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CB51B1F00A05;
	Thu, 12 Nov 2026 00:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794444117;
	bh=RRta4FZ2e8Hmb5o5/lhGVzPWc/3peuR99+e6UdySdC4=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=LsHIpcUAJiHCUpb4x0OK3n83O3SBRyWSkfTnKKG34OVc8FQfJsJqrKO4h2HmIg7GU
	 DiyKpx3zBsgCQOh/yWRFLYbTr2J+NbsFVZQHk0ZQ6JIjsCgFfQdMUbVSF/eE4gYWwH
	 ozZJs0uo+XRyFL78qS+ll9PYbovMQglM8Hjb6JUXKOcTo5tzairFH9uJ2gE8cqj7Iy
	 6aN5WUd2UrmN6gskwjdHEsxxr6jmwq63jdiXbVEqISe35q9qGJBdZa6O0XlRnfz+3l
	 ZihPI53uQNG+nHY4fOmo8HPGi6zajvxDfxh4clQirGk4kwelPA6gMPUB0OxmcDuk7u
	 Y3tlaGU2GmCZw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2B0A54919E;
	Thu, 12 Nov 2026 00:41:56 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 12 Nov 2026 09:41:56 +0900
Subject: [PATCH v2] xfs: check the disk address for hardware atomic writes
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
Message-Id: <20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
X-B4-Tracking: v=1; b=H4sIAFML9WoC/32NQQ6CMBBFr0Jm7RimEFBX3sOwKHWASaQ1HUQM4
 e5WDuDyveS/v4JyFFa4ZCtEnkUl+ATmkIEbrO8Z5Z4YTG4qIspx6RSHN9opjOLQPqT3mLNtq1N
 RlGVtIS2fkTtZ9uqtSTyITiF+9pOZfvZ/byYkNKYuW6rOrjB8VTvqy/dHF0Zotm37AlqwMIy4A
 AAA
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Pankaj Raghav <p.raghav@samsung.com>, 
 Pankaj Raghav <pankaj.raghav@linux.dev>, John Garry <john.garry@linux.dev>, 
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794444115; l=2519;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=/KQlHm9zqOvC9vqKeC5B3c3hAccfr9ecgZJuujouvUg=;
 b=+lSElbUv0ZC1/gr/jZ2ThAFPuMnQ1/1sWHgTm4Nzwg96uKMPQ4ue2HxEOB/GH1spDUmkZxtpU
 L3mz5mjt69BB+UtzwNCmLcdPj8VQv1FL3xfUyfwI1AGVPNhIxHWOnC4
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_bmap_hw_atomic_write_possible() checks the alignment of the encoded
br_startblock, not of the disk address. This was harmless while atomic
writes were capped at the greatest power-of-two factor of the group
size.

Commit ec8f62cc109a ("xfs: don't limit software atomic writes by the
group alignment") lifted that cap. The block layer can now fail a
misaligned write with -EINVAL, and XFS does not fall back to COW.
Unaligned AGs, such as those made by mkfs.xfs before 6.16, and rtgroups
made by any version can hit this.

Check the disk address instead.

Fixes: ec8f62cc109a ("xfs: don't limit software atomic writes by the group alignment")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
The bug needs a group size that is not a multiple of the device's
atomic write unit max. mkfs.xfs 6.16+ rounds agsize to a multiple
of it if the device reports one at mkfs time, but never rounds
rgsize. Before 6.16, a single device of 4 TB or more got an odd
agsize.

Tested on emulated NVMe with a 64 KiB atomic unit and boundary.
64 KiB atomic overwrites in AG 1-3 (mkfs.xfs 6.6.0 -d agsize=262142b)
and rtgroups 1-7 (xfsprogs 7ebfc20eb88e -r rgsize=65534b) failed with
EINVAL before and used COW after. fstests -g atomicwrites and xfs/838
(rt) give the same results before and after (generic/773 fails with
ENOSPC on both).

Changes in v2:
- Explain why the check was harmless before ec8f62cc109a and which
  filesystems are affected (Pankaj).
- Reword the comment: an fsbno is not always a linear disk address
  (Pankaj).
---
 fs/xfs/xfs_iomap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3465204b8d..119ff8e4c95 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -848,8 +848,10 @@ xfs_bmap_hw_atomic_write_possible(
 	 * atomic writes are required to be naturally aligned for disk blocks,
 	 * which ensures that we adhere to block layer rules that we won't
 	 * straddle any boundary or violate write alignment requirement.
+	 * Check the disk address: an fsbno is not always a linear disk address.
 	 */
-	if (!IS_ALIGNED(imap->br_startblock, imap->br_blockcount))
+	if (!IS_ALIGNED(xfs_fsb_to_db(ip, imap->br_startblock),
+			XFS_FSB_TO_BB(mp, imap->br_blockcount)))
 		return false;
 
 	/*

---
base-commit: 48326a2382d80715475d10ce98734ac65d2d2150
change-id: 20261110-xfs-hw-atomic-align-0eab6833447a

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


