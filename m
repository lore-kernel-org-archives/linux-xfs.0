Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793846953;
	b=QPXhOxJn19uufLK5PYswYVi/NTE8V9WrZ+W4n2q+XdW/tOlOEkyKZLj6RpM0eaNPkQq0
	 3OZlEi7gpGKhGfMvigoHHCNGQPwpWK+YT+5006jUfdvP7HFmB6EQStHQQgXe96IKS05t8
	 ARMLthTdJq+hoFPgA9zPiv1OSvKwYVAPbw9NLyo46WStah/9l3VyTGvGNtR8SpMWv1eVh
	 ztY/Z4+HQgFNXJiqvnnAuijCNdOIO6EdI61n0vn20zu9ycTaUSx04yx9qRRe/rK2iwQ8a
	 0pk7lxWvIJkuDnLdzvu5xIXniZJPUKqzVmuwy9b4jJ4fxpSCeFtg5ih+ppry9nlzvxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793846953;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=YHdQqGtXg8YOE5O9LodtRsGGzhkW1AIOdgt8reo9jCI=;
	b=21qbE0ovWpUGKyJyLVBUV+iT0ZtIq4fq2SucWl95ds9b7fO+TAmvpb4MuApZJeiAsOnJ
	 N0uwBlIoxuxi3veJBe6J3pH+LyP+Y6Aju1BQIXOv1oo/bPiUbKrryX/u6k2LJ1ci3X0Vd
	 RFncwJnot65bBcNcsx/xzr8EXHShxkeI6BXKaSYiwZDCN+qorH/SUkz/rAvn/frdYp086
	 LXS5RGwGiiPNwPb7QVjg4q/VIXLrjsVYmvYqLe70BUB2qtoMCkoTi8kX7b3lJ/mJbvvC9
	 h3PnDdKeuwF/g2w07d3yyFOofg6D2IZT2Rc5pNuTBeNJL+ps0OXL/ycTWkatJGPhRBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6JmoMjH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48063606A31B;
	Thu,  5 Nov 2026 02:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6JmoMjH
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793846952;
	b=Wua1mk6mIKWZVPpNAFcQTdUEQrPolqlr1U9mzyfKXpkIbqelK/ha2mzACuQh+LGSVz9w
	 niwcGtffK4dvOnwd6Fm/+nUUXa7kzDMsMM3vEMUZ4r7Wd0Pl9GzRD7dnoDcJDnZntxqqd
	 RmFvWeXb32CW3Fz9KYmE2ZEEm0mxutnHnKpTRWLxRs9uvXoSqqcFRChlaieA/0Lv4lHdK
	 22v+tVuTNk3B7EbPWBypWl/mXn48lNn7GnHQvZ7R31VvpJtOjNefTu+zO3ie4f7JNC56C
	 eqmysOEQCyQX1jN1S3zHcKqZt6EwoKiBbb0O/avW2g2+6zCIVzisUzh1dYOqc2FNgVg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793846952;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=YHdQqGtXg8YOE5O9LodtRsGGzhkW1AIOdgt8reo9jCI=;
	b=DhM9amyfYgKGDNvrc5cRfCy/xuhBUw8sLGEyWJyfJYgOHVjOc65DU7TulVqZ8ryi4/8J
	 RubwXo2o9hnId8Q6KEp0sv9eg8piVgyWI9H2fBeg6SdR9orek2YVR4kF2ezWVTKoR9LZv
	 gX+PSWao3JTEngqUcofwM19lhXgEgrRVUhFY82xw0hfi8dRowOUuPMOR5WjMhKBY+yBY7
	 DxHQWkaYQL3Hj087PUDPqMWEmNESVU4bKXJsi5lbjnUSkm5FenYBUvQIM1oshGtPEousK
	 E+5FhIU7dgvGAcuO5jGPh3AJs+T+0saZhhoXj5eJY3Br0Np6IBkX3fW8IJ/mWubWlAA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6DA971F000C1;
	Thu,  5 Nov 2026 02:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793846952;
	bh=YHdQqGtXg8YOE5O9LodtRsGGzhkW1AIOdgt8reo9jCI=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=F6JmoMjH8hpyZ0P7kr5syGECJiaM1Wm1I6dtkObtT7JCKXrdn7+cWSqIHcHf/kSE8
	 9DJIpH6nl+lriVn09HIdj9CUmiv5j1IliSCelPV2hR/AUz/2K6C2GwdRkYNkO1ycT5
	 grY50yuJiCCv3VEqm41xtI0lTdb5CCtNBlhAEnoKjYmmspwP5KLGDqEGEHPKJROKOg
	 nGPwaTzuSfU5P9FPheUsHNmv3O5Qfp91SCUuOLz3F5XjKsWxMRdZ45nNmfjUHLhVew
	 chDfq6Eav2mh0dtnVQqOAwHfvmCf1MjC4AGUgewrUEHu+M+EKu3gQz5Zaa5F2HbFt+
	 z3G8pI2QnIZRg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 01AAD4704A;
	Thu,  5 Nov 2026 02:49:12 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH 0/2] xfs: skip redundant fsync cache flushes
Date: Thu, 05 Nov 2026 11:49:11 +0900
Message-Id: <20261105-xfs-fsync-flush-seq-v1-0-299bdf5e28c3@samsung.com>
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
X-B4-Tracking: v=1; b=H4sIAKfu62oC/x3MwQpAQBCA4VfRnE3ZEcmryEFrhiktdiKSd7c5f
 of/f8A4Khu02QORTzVdQ4LLM/DzECZGHZOBCqqdKyq8xFDsDh5lOWxG4x2bcmDyIjVRBancIot
 e/7Xr3/cDdFj4zWUAAAA=
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793846951; l=1069;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=NQTFHpwt987/Z9fZrwgqPjU/uEomGjhiNQuVS35MfSg=;
 b=gClUR6DwC9OlLGCYV3zCtSGOkNahTDwXNMleYmFnweN3OYmHQWaGf9QEv/NkVlg2rlCbwbcLO
 fDjF7tGe8BsDvFiJXGtL6b9+EX9ugIS+xA1V4i85LXlSml7rSrRK0ri
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

16 fio jobs of 4k append + fsync in a QEMU guest: 809 -> 4185
fsyncs/s. fstests -g quick shows no change, and a dm-log-writes crash
test lost no data (patch 2).

---
Daejun Park (2):
      xfs: number the cache flushes submitted to each buftarg
      xfs: skip the fsync flush when a later flush has completed

 fs/xfs/xfs_buf.c      | 39 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h      | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.c     | 21 +++++++++++++++------
 fs/xfs/xfs_log.c      | 25 +++++++++++++++++++------
 fs/xfs/xfs_log_priv.h |  1 +
 5 files changed, 114 insertions(+), 12 deletions(-)
---
base-commit: 1e17fc56469d62d1c1ac45c137a2456d14456f1d
change-id: 20261105-xfs-fsync-flush-seq-83ae2cff6225

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


