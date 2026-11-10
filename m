Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794297658;
	b=eNAodc8BTRrS3pm7TsSvSqqLIV7po+iAxSptBPSSd/6dNtEIKzPhL5LDhyGZcCsBA6YT
	 sk6xlWJCCyle6U+AQjfIJFfgPQOQD4zau4VFBaik3Kry0lAsqbzdZPU0CqwW3kQCCNz+k
	 l9qFnKwsZdnQI/C1jcPUHG3W04wtapMQSeQu8/n4MG+qrASkQkGT1BzZ0b2nNLnUApwUD
	 2dFKB+tDMYb/4IbmN/q09xGQA0gSOlpclsSQ/ZBkfJWdO3qQU0ZVtRSdZOJkYGbV6fxEc
	 w/VryvwpkNrXiRiLYPdHAa5KlfG4e4XznEwNE0dbrqTdEUovH/tfSFQ6AiVbM1KvRqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794297658;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5kzvaJFH6D0JkFePj4/JdbhL4yB346ZGpt0bPSGFrK8=;
	b=lEQDZ0dMsIHsDkgrvLbpkaOeenEt58EiDbbtLtQrbmBeMO0UQVuaQ3u2+8Z3lVpSnSJt
	 L1/yXw32cwmUTmnYEHkY+iyRaSr2ZVJXBtA+AJy7lnP1gNuVFX1NqBCJLHwil5db2lP3j
	 tauhejSMQyalkFe1sGW/u8l/KbOzrA9s58Cgkpw+KGPjvTTe/dHy2BTadvjn30+BzkSMH
	 dT0LOyXeP3WSewd0QEH1LV/dnvgQd/gRkvIgYwt6p7GN2VKa3vu2bM7VWyJfphEZZmhiC
	 IeciLOzY6LioFO5Dgksbzyz+tSVRQRz8AlqHWAuFGcs+BgxiRzNWfn8SOmEpQeY4uyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="VL2tV7//";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A627606A720;
	Tue, 10 Nov 2026 08:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VL2tV7//
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794297657;
	b=QEZVuy12grBsGGkAaVKWR1y4nQAuiJh/xLmQf+s8Z4j7atkWjbnA60vr480rjetLROS4
	 dPbY+Vh4SgZGTfORU1WSAImpTyTKe9dYYkZnMOYXgInj2Y6sl5KdXLUrynTLg2ZwRRw47
	 0BbB8+S+t9aXbGf5wW+YdwYDHokLLXiagMKjYs2LvaVOCMZib9w8frRS2sxODsHvQSraQ
	 yTX+7gp8pq85oamxpkBMSdQg1Gv3HmP9tBpxIOi3VF6VoujIL3Q7F9QPMgrB52OYj4rJE
	 92gy0rlzhmVMMpb3NSX1mFCXtzWHdsIKG86zMYr+8XE5kLbjgTxmMP9qBrvkJIjDqdw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794297657;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=5kzvaJFH6D0JkFePj4/JdbhL4yB346ZGpt0bPSGFrK8=;
	b=Br8+rm9RfoIduyQwd8vtjKRd7DsFsE4IbiATXlh/IlD0MzdH9g7ba8RZKrwjGUaznZZy
	 Vlh388oJuUHruTjAPo5bvmt4m1eppGnvzd5CmSIlM1ZUH6pQ0RnUkEbin7lSfACOKqGn1
	 DerRAPqSg04ZtUItQodN6/jOVk1YRTjEAcgVmgj9JDt8oNTwpWw37ESSlpA/Ns8YytWDM
	 9dXBzAIUxvDURuz/eX09zm7+QlHpCmVLT3hef042fyvpHuIqKIWoZBPBPQjtehkBaMhnP
	 Alx1MuEmQKPEDuMgc3mSr5teom1KpebxFuNx9x2EN72m2QhzGVQrpiZDEm0jaalv6pA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 633271F0089F;
	Tue, 10 Nov 2026 08:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794297657;
	bh=5kzvaJFH6D0JkFePj4/JdbhL4yB346ZGpt0bPSGFrK8=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=VL2tV7//jBw0NfpUJ5/RPJGSESGTE6Srd25mA+fQ1bgy9ab74cGSk79Bi5PXZ3RwQ
	 ghxZJob+Mwf8i1E+n1OYe7LWOxAPyhYmv6V2kUDqwRsV5j2W3LzJsbhea5C45mXUHY
	 QE7PpUyaDYJ3XMnF4UiV3lJ4ax5NPSArEJ8h+rfWWgASceDIKGxeWweMBhIbBzwbWr
	 b0QjGGO05YeKaS87ubCNf4mZ/ofeGyVOBzqGedVuOwsP3sXzIkt22ftTR+byExLrLs
	 wYqb7WTq2qoBRKpNZNFnIaHTiGglieQ4n8/5YYhw7EJFSSuu0yRUAcB6mOf6YylPAh
	 M7XBkeRJxosFA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B652848A16;
	Tue, 10 Nov 2026 08:00:56 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 10 Nov 2026 17:00:57 +0900
Subject: [PATCH] xfs: check the disk address for hardware atomic writes
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
Message-Id: <20261110-xfs-hw-atomic-align-v1-1-2274b169c32e@samsung.com>
X-B4-Tracking: v=1; b=H4sIADjP8moC/x3MQQ5AMBBA0avIrE3S0iCuIhaDwSSUtEKTxt01l
 m/xfwTPTthDm0VwfIuXwyboPINxJbswypQMhSoqrbXCMHtcH6Tr2GVE2mSxqJiGqilLY2qCVJ6
 OZwn/tevf9wPrfuLTZQAAAA==
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Pankaj Raghav <p.raghav@samsung.com>, 
 Pankaj Raghav <pankaj.raghav@linux.dev>, John Garry <john.garry@linux.dev>, 
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794297656; l=2023;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=F8iIbd6Eszp+I6y7W1YZ0heXUAQ4Tct/8s2wppk82FQ=;
 b=kS+BsKaUWKZesCUse7dkx23u/LG0MNFq7np4APEH+yrpLvythgqWsOXGgFYwtntkZPK591kGu
 v94W6w3YdiwDUe3qCVwGnLxZoPZwqBgp9MZY+WsfZJEXYYp08dsI/Op
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_bmap_hw_atomic_write_possible() checks the alignment of the encoded
br_startblock, not of the disk address. The two can differ outside the
first group.

Since commit ec8f62cc109a ("xfs: don't limit software atomic writes by
the group alignment"), a misaligned write can reach the hardware path.
The block layer can fail it with -EINVAL, and XFS does not retry it
through the COW path.

Check the disk address instead.

Fixes: ec8f62cc109a ("xfs: don't limit software atomic writes by the group alignment")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Affects a group size that is not a multiple of the device's atomic
write unit max. mkfs.xfs 6.16+ rounds agsize to it, not rgsize.

Tested on emulated NVMe, 64 KiB atomic unit and boundary: 64 KiB
atomic overwrites in AG 1-3 (mkfs.xfs 6.6.0, agsize=262142b) and
rtgroups 1-7 (xfsprogs 7ebfc20eb88e, rgsize=65534b) failed with EINVAL
before and use COW after. fstests -g atomicwrites, xfs/838 (rt): no
change.
---
 fs/xfs/xfs_iomap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3465204b8d..cfa2f7ac03a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -848,8 +848,11 @@ xfs_bmap_hw_atomic_write_possible(
 	 * atomic writes are required to be naturally aligned for disk blocks,
 	 * which ensures that we adhere to block layer rules that we won't
 	 * straddle any boundary or violate write alignment requirement.
+	 * Check the disk address: br_startblock carries the group number in
+	 * its high bits, so it can be aligned when the disk address is not.
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


