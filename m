Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793270128;
	b=egsrxheXPBlw75mBxtzKX8cCSWWSM2VBdvXrdhDtMPXOgQem+QzMzNs4a/m6bcxptC70
	 JZ4e4EPew0EIOBhigbsbrCnzEHGuWC7KSCCxb99pcggrBmRvAkID867D7sBrEaxvZC170
	 flj5QtOp5gO+wnwOF96mqbmvMzHvQ5G+bVP20NH0yLqz5EaAfcvJlmIO4BXUwUs5xPL/w
	 rQs40iTeS9BFN4I5k3ZPVhgB8oG2BkSLsz/LdK/n2qXYTJCJFcPdMW5+2rNjSg6rQAj7r
	 /IG9Idv4Yhlh6D2gGPcu71D+JuzkAy8lSpPLGx6mqcvzTxsPZCPxY2smshaz7b+kEIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793270128;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=+loMS1DKw9n2SuoPv2bKActD8SVZBe7w68FZHgHyD2A=;
	b=1Xyps84wGUqnQuZ5nXJfqBmwsH+v2ykPpN+XOuw1loytpPR36pA44lDCUNR7b+6VMmMT
	 aO9nzfAo73gnws28HG4IEKkGf7Vi8Ox2IDksv0Wjm5bdcyp+pkjyVZEHuoZpM9QhWmGMl
	 oewA1CjN18LeIbVBlu9ve0VGzShIgGSg2sVwlKONopMJud8x8ZVedbQNXEK5DF+NcOsjy
	 4sf6Igktus48aRatjpjKabvthQrCWgDnLY+Cso1KxNCHfLSCEjnPYhQjZguYUmnK5yXZx
	 PtXDWj37LDOuoTzfZ3QhxtWWlV7zT6IPLf6LsZyK8mkoaI79uEMqbLm2ySfZ9UFBI1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bkOKmNCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F42606A31C;
	Thu, 29 Oct 2026 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bkOKmNCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A4B1F01825;
	Thu, 29 Oct 2026 10:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270127;
	bh=+loMS1DKw9n2SuoPv2bKActD8SVZBe7w68FZHgHyD2A=;
	h=From:Subject:Date:To:Cc;
	b=bkOKmNCh73/pZZBPlO2wOq39inC7Ey8thWBk2L7YZfMHue8YJR9ZLXY8ygbYlqiqN
	 HFsd/rr2qhbs0uqmjJfdY0d+RlZHsY4RifbsNTHoU+hcM5Zf5yI8QE4zMFopwlfL+a
	 +iSsqPHyVJwhK47Weunrq8FApzuH1lUE+E32CI7OSlk6DqzBGNBYXhmalWRV8/JkTg
	 Ggwb4KHz/uSY7J8zNwiMiXde2AmIVIUgpcW0nJ3RDTQwrDb35d/fUVxQ3gJ+o5WEz0
	 NfE0By0Bb+n+GbSxlNerMOGlybhtha0dDXu9e3s4JP5zQliRMU6nD2PEqISih3FYrB
	 0JAV157e3aN/A==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] iomap: fixes for short copies and integrity bio sizes
Date: Thu, 29 Oct 2026 11:34:47 +0100
Message-Id: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWMTQ6CMBBGr0Jm7TRQEYWrGBZtGWU0tqQjakK4u
 y3G5ft+3gJCkUmgKxaI9GLh4BNUuwLcaPyVkIfEoEvdVKVu8R3iHTk8zISG8cIfEjy4ttG0P9X
 DsYb0nCJtRTqe+x/LbG/knlmVF9YIoY3GuzFHWao2qfpLVZ7Aun4Bhn1xLKIAAAA=
X-Change-ID: 20261029-work-iomap-ai-fixes-5c962e384d74
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <clm@meta.com>, 
 Josef Bacik <josef@toxicpanda.com>, Matthew Wilcox <willy@infradead.org>, 
 Zhang Yi <yi.zhang@huaweicloud.com>, Joanne Koong <joannelkoong@gmail.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2586; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YuzXwNxGxIuWR8h8hgV+wPhUPpmDK/4aYgo/tp8dnWA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9Vsx6PPfponrbDc37joo2pDq/i61y/usSVlGnX3Xy7
 qEz8mFKHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPRdmP476Fc/vzRlbMnP2bd
 4hC0z90kJzKdn9d+388nN3VlL177LMjwV3yvt2KZbsb/VRekPKslWqf9O+HyI+/EjYt33zBu3rr
 OhAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Two iomap fixes that came out of Josef's AI bug scans.

The first one is old. For a buffered write into a hole, an unwritten
extent or past EOF __iomap_write_begin() marks the zeroed blocks
uptodate before the copy from userspace. If the copy comes up short the
uncopied part of the write stays behind in an uptodate block:

        ftruncate(fd, 4096);
        pwrite(fd, p, 3000, 100);    /* 16 bytes at p, then PROT_NONE */
        pread(fd, buf, 4096, 0);

That returns 2984 bytes of whatever was in the page before. Willy
reported this in 2024 and Zhang Yi posted a fix but it never got merged.
I went with the same fix. Josef's version zeroed the partially written
blocks completely and only marked those uptodate. That works too but
it's a lot more code for the same result.

Willy suggested back then to drop the uptodate marking from
__iomap_write_begin() completely. I didn't do that. Blocks that were
read from disk are valid and keeping them uptodate means a retried short
copy doesn't have to read them again.

The second one is from v7.1. When the filesystem handles the integrity
metadata the bio size check wraps if a single chunk is larger than
max_integrity_io_size(). That limit is capped by the maximum segment
size, so it's 64 KiB on lpfc and qla2xxx, and XFS writeback of a large
preallocated file happily builds a single 300 MiB bio and overruns the
2 MiB integrity buffer.

Note that a single chunk above the limit still gets a bio of its own.
That's fine with 4k pages. But with 64k pages a folio can be 128 MiB
which needs 4 MiB of PI with 16 bytes of metadata per 512 byte interval.
That's not new though and needs a separate fix.

Both are tested in a VM. Without the first patch the short copy
reproducer leaks on XFS with 4k and 1k blocks and on ext4 with buffered
iomap, and an fsx-like checker with faulting user buffers fails within
a few hundred operations. With it both pass. The second patch was tested
with scsi_debug DIF/DIX patched to a 64 KiB maximum segment size.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (1):
      iomap: don't mark unwritten parts of a folio uptodate

Josef Bacik (1):
      iomap: keep large chunks from defeating the bio cap

 fs/iomap/bio.c         | 2 +-
 fs/iomap/buffered-io.c | 3 ++-
 fs/iomap/internal.h    | 9 +++++++++
 fs/iomap/ioend.c       | 3 +--
 4 files changed, 13 insertions(+), 4 deletions(-)
---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261029-work-iomap-ai-fixes-5c962e384d74

