Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E75436A033;
	Tue, 16 Jun 2026 14:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618920; cv=none; b=VaH7Chhrvp7MMQwVuSbE4XdLEQDq3p0SVUgsF4ot0xbAyy/rTEjHeAiJbLfaJVoINUBT4sewI+z8LSpkhEivwKTiO84038+xXmWrWNs92vdm8vZWcIfNdLh1JP/nvwtMXUiDNzu09Ot4swQXpl39QwlmTIXGGP9zBvS0Y9SqD+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618920; c=relaxed/simple;
	bh=+c5vJQdoUivvVsn514PbmmH2DGT2hz4x522TzvMxmoE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PvrgJs8BpZZbImSwW6bihqWMdQRy/cz6g5hwM3i3Whaw2Zb4+IvAnA0FY+Ys1bfM4zTW/rteQlcG8G8HDkxYo/3lSKRF0xcVrypEnX3WwJDoU1uZFN47VVHYRtHXA7oWKbvdTxTG/jyq9vM0xeKU5S1tzr/TOdIz0vIedc+/dWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kySEtXA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kySEtXA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C5D1F00A3D;
	Tue, 16 Jun 2026 14:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618919;
	bh=AeeZi/hxbgHmb/F0VfPB/7qCPnOkVDs6Bdia00DiCdc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kySEtXA+i2Sy19y3C7hyItYnoGUU0IRW9m/qLUgWLY0CT/JoqcLQwor8hbb/bur8x
	 QSTZSCimCT+fi9+I/xfLsyabbeYThwQZoNLNVU3qJQMOTG79ogMINMGHm19HYM35KV
	 SEqtHSLSBZGHGcyaluIsbjrpHn53ZAdR+WoOuRglqqFjOpeQkO3RFqgyj4EDFXdKU0
	 sMeX6RJJ9MwG76DnNcWigWoF0cQPg2ASRAa2Fh2ogixt4Sv7GUmdbSHVnHSRMFB3mu
	 QKPu3jbhyIMzqD6sasUJF8vzoAKtIE0DS+69xmHaF4ujtbTzhvtE7vrUisorRvOt8l
	 xeEg8KRn9KVQQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:17 +0200
Subject: [PATCH RFC v2 01/18] xfs: fix the error unwind in
 xfs_open_devices()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-1-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1654; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+c5vJQdoUivvVsn514PbmmH2DGT2hz4x522TzvMxmoE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzrE3XdWnvZxYvtzt2P9e9PnRV1uDvZsPaZWH7J6
 X1rgjRvdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykbxMjw72E5nfrd6W+STto
 cv74grrpL8wvlBxWFmo+8mrZ8/UbKn4xMmw+l6cao/5He1rRkoSJd+TND37Z8eVKRdPe8KCIaaV
 Xo3gA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since the rt and log block devices are closed in xfs_free_buftarg() the
buftarg owns the device file. The error unwind does not respect that:
when the log buftarg allocation fails, out_free_rtdev_targ frees the rt
buftarg - releasing rtdev_file - and then falls through to
out_close_rtdev and releases it a second time.

The unwind also leaves mp->m_rtdev_targp and mp->m_ddev_targp pointing
to the freed buftargs. The failed mount continues into
deactivate_locked_super() -> xfs_kill_sb() -> xfs_mount_free(), which
frees them again.

Clear the buftarg pointers once the unwind freed them and clear
rtdev_file once the rt buftarg owns it, so nothing is released twice.

Reachable when a buftarg allocation fails after the data buftarg was
set up: an I/O error in sync_blockdev() or an allocation failure in
xfs_init_buftarg() while mounting with external rt and log devices.

Fixes: 41233576e9a4 ("xfs: close the RT and log block devices in xfs_free_buftarg")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/xfs/xfs_super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eac7f9503805..8531d526fc44 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -534,8 +534,11 @@ xfs_open_devices(
  out_free_rtdev_targ:
 	if (mp->m_rtdev_targp)
 		xfs_free_buftarg(mp->m_rtdev_targp);
+	mp->m_rtdev_targp = NULL;
+	rtdev_file = NULL;	/* released by xfs_free_buftarg() */
  out_free_ddev_targ:
 	xfs_free_buftarg(mp->m_ddev_targp);
+	mp->m_ddev_targp = NULL;
  out_close_rtdev:
 	 if (rtdev_file)
 		bdev_fput(rtdev_file);

-- 
2.47.3

