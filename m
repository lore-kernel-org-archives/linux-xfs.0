Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794447330;
	b=p4xbKn3oOA9Nc6oX7e/il/85Pi1fgbh6MIZDRXxXS9aNqFPixO42OOyKM726BSRyHMo4
	 9YApk++R3ylXS08i7R7kq01wSv+lEXtzOcm93LBMx7/6YrRboDrCdUsEeaPQEb8ZKQO7k
	 AWOiLWo3mljpWPYOfpDagdTccdUXZtKxj05FnKTa4XoJccJEHdSd4DAIZ2Rp+xlG8FFMs
	 dMGDdEM86+kVbto1OWou/csowixdLBy/X1d219AktwJdYc4ERiZpW65T2ahTFFQankB2G
	 xBjX8PJmRnI7WNsf8qEfI1/fuJmv33WAPH47ykEhwUcl5bbnNvYdrmoZvF/9+hHlCWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447330;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rxA4jyfNMVPQFbbS1u7H9tzqfv38oRGt+zsg1z662Sc=;
	b=HML+4RZ1VpkIYnRzR/uBqCBPyEhD0iDrngA2lGnXbSm5eY3kNluv3Xa4h3vWAcBCvchB
	 /J3vxYqjDg/xawOMop5JT1yM3gdWDSq+Vy7GoTk5gms+T9/6jYeNjCARx1d/T4IEXKNAI
	 EKb0PvOSPYJYynMj4hkZkgSnuGrG7CGhuDKWSqyocehRo1OgASDIEVq+8pshE5l2okJCN
	 pkUcWAf21+FVtkVN5X9p9ZiGtKvSpz82l5Bf6jGkWFEexfJVDaAgdovUu7lCDDdUAT8EN
	 4Y0esQ+a3GU8UOf8cnH39w2qw9NICZ6VZgfytw0HO7MV6QLTvkEwjdFNFSS0rxUcJ2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHmLpPGw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680BC606A332;
	Thu, 12 Nov 2026 01:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHmLpPGw
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794447330;
	b=hzMzHQx5mcDhh+Lpr5TmVRTsnSdDxtaidIpVAYyw0+jwBvCk8WmBf+VI2ro/fyLxP12h
	 DgRkHejXxU+c2QVoUuNuPJhUjZTLMqgMGS+p/1kZ1hHP7Abxneh07pTohdbXepXFDHop4
	 o6N1M5y+xkkiqX0yAuB082Iiamjiz8/VrEQWFPGWQLIj24NJx2bmpajbWiYHtNt/rsJfX
	 q6l/uhldtGU4uMSdo+R6FQRF4qdq0p5/O/le0iQxUwaJ9OmbjaBk+DNYhv50MJAWIBnVO
	 lIOFIe4LMSamM3b9nX5Ft+P6hkDIcxTS36aCclLC2CX8SDah18gVtPjgXHZpO4cyHDg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794447330;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=rxA4jyfNMVPQFbbS1u7H9tzqfv38oRGt+zsg1z662Sc=;
	b=TPk7J6WgNOCTmDPGsVa2Ydmf+2e2rIf9UoCd3RPQV1qOuGewjLwEHf+yeXd5u+IYgzG7
	 AdwU0uuQCyG0K+Imh5ElpehZnVTwA4Rb1ZyL01yBoBVAuArEmsVhYWvUE0+gj0yjek86v
	 9wuSf+lgCukvL9AJM5bBfP6+TIgopOPrLxrQglMY80GLB/aqUFL02IG8ZRj+pWqlG/5K5
	 PBcVVZBdlpkKGeZSRH1nB5lu17F7iXL3ivkegTVhN+PUw2+UU8xAWNTtByWO2wc9bW7bg
	 dMo0LDNpPTKxmrawCA6Bs1aD9VVFgwWzgTGVJNVtKB/zUyFwnI4SPYzRaWRiznbnkLA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 53B701F00AD2;
	Thu, 12 Nov 2026 01:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794447329;
	bh=rxA4jyfNMVPQFbbS1u7H9tzqfv38oRGt+zsg1z662Sc=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=NHmLpPGwDTwPhKDcqGOsva+6joF6ezBl479S9UfF1xWyJY+55TIV4k1Nri/d1WNFA
	 D9phpTog3jt//MBJD3dPIfkoMS6EFMvMSjKVUpCv4XwzDqvYSlFo+CUEm8Vgjpi+NF
	 1JDgNlODqJRyLMG1iC+oHMlH6v81qnJNAnwwj2KLPJetUWweOhw8XIRnwlUtTeCMkA
	 fP31Fq7AP42PX9zitEhgex1p356fO+fgR/9V3/i6d/SE8/RrKAc/5X7+n/nYBJHuEz
	 qAcZxZaDsg7JpH3709HDM6XaXdP02H9m+x6pAugnMYmc6rS27iYYMGBdhyVBX69dzh
	 65RXpUH4W7ZGA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A5138491B6;
	Thu, 12 Nov 2026 01:35:28 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 12 Nov 2026 10:35:29 +0900
Subject: [PATCH] dm: fail a REQ_PREFLUSH bio with data when its preflush
 fails
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
Message-Id: <20261112-dm-flush-data-error-v1-1-c83d3f8f3ac4@samsung.com>
X-B4-Tracking: v=1; b=H4sIAOAX9WoC/x2MQQqAIBAAvxJ7bkGLSvpKdBDdaqE01oog+nvS3
 OYw80AiYUrQFw8IXZw4hiy6LMAtNsyE7LNDpapWZ9BvOK1nWtDbwyKJRMGmNV1tGm+ccpDLXWj
 i+78O4/t+fAtuAWUAAAA=
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>, Brian Foster <bfoster@redhat.com>, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794447328; l=2208;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=q6PUE0uUyF22bIWKZKcR0Enr0oPYObD9+qpBd6oRddE=;
 b=FH2KTDpAwuT5PIkA91LGgmDPbmmYYbqmsr8/Bs/at2zGx7QGekF57ryKj9WRohgYRm8rWTnRK
 y2C6XvoDU6fCbR5KP/Nlzpx/BOQa4ykhAf0f7/V7tnq4tA9iiVwKoNQ
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

For a bio with REQ_PREFLUSH and data, dm core may send an empty flush
first. If the flush fails, __dm_io_complete() still reissues the bio
without REQ_PREFLUSH and drops the error. When that write succeeds,
the XFS log keeps running and fsync() can return 0.

End the bio with the flush error instead of writing the data, as
blk-mq does.

Fixes: 6a8736d10cb4 ("dm: relax ordering of bio-based flush implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested on v7.4-rc2: XFS on a two-device linear table whose second
device (dm-flakey, no data) fails every flush. Before, 200 of 200
fsyncs of one writer return 0. After, the log write fails with -EIO
and XFS shuts down.

Kernels before v6.18 have a different condition here and need a
separate backport.

fstests xfs/438 uses dm-flakey targets around a linear target for the
log to fail writes. dm-flakey fails the flush clones too. With this
patch, XFS shuts down on the first log write with REQ_PREFLUSH after
the errors start, before a metadata write fails. The test still
passes. A series for fstests moves xfs/438 to the buf_ioerror error
tag.
---
 drivers/md/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1881d86111f..0f6934e0008 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -983,7 +983,7 @@ static void __dm_io_complete(struct dm_io *io, bool first_stage)
 	if (requeued)
 		return;
 
-	if (unlikely(requeue_flush_with_data)) {
+	if (unlikely(requeue_flush_with_data) && !io_error) {
 		/*
 		 * Preflush done for flush with data, reissue
 		 * without REQ_PREFLUSH.
@@ -991,7 +991,7 @@ static void __dm_io_complete(struct dm_io *io, bool first_stage)
 		bio->bi_opf &= ~REQ_PREFLUSH;
 		queue_io(md, bio);
 	} else {
-		/* done with normal IO or empty flush */
+		/* done with normal IO, empty flush or failed preflush */
 		if (io_error)
 			bio->bi_status = io_error;
 		bio_endio(bio);

---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20261111-dm-flush-data-error-5687385d8c0c

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


