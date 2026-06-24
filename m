Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB08439A809;
	Wed, 24 Jun 2026 08:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782291585; cv=none; b=GgWv0fI2kO0Agvj7uebtfppETqDtGh2HaPMgaBYFZVJZufCXvVvKVeNOv+tsFVtEdCKglXgnLd9AUL2uDKJAbvo8qUf+Ljl+DGP/A+TX855C8DToGgaZm4LlQPbxyYl8j0i3oYpur9r4Xclo5f8jYBIcGfwUjBT/3mQDnJrXhzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782291585; c=relaxed/simple;
	bh=ItpYSXrK/37J71vAtTVRv7EPn/7nOKqrjREz9qixy/Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ioHI3wtTlIzQ72CgvQivPhpn4t1OV+ZPGtdTZ5xxQ4XRHQeNzmWF3tacDJC3JJYt8ZLCZYA71SddERfDLmGiwq49bDnKTLhGPUJDWtuAvpkKbB1hhx4JseTQjkig/ZYgqvjAVh/a1MRLgnzvYWT2SjbYTu/xNrXFLGWLDZasUOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0v3ckCZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0v3ckCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7FB1F00A3A;
	Wed, 24 Jun 2026 08:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782291582;
	bh=Kfog2XYgdAz2tICEuYPMWdkUUmomPmspfGK5Ice4Jqo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=V0v3ckCZreTLHBWI2DQ0Ao25Y2i7ybcWseLm5EmwZbWIMxXez49bh7wb4hoL0MemX
	 DDnYyi/vw5GJfHrQ/nea3efur8GwSo6hHb3jkbxFbOqy/okRn5cN/85xQjJ6mjDG3E
	 rh6X9Vbxc6QDIGD/QQsi37GlKZIbP897GIkoIzpA71qLlbXaqjlGTnepv2FJL+zW3f
	 cRxLhJk9v9PQ4c9o/3tHGft0Siobxcj7RlwAiGe5Rd4u0L+GdE27NO8nSq7Ejypayi
	 OIT4ZDLC7ChIudE/UAu7X5xDl1AIhiVS7qTcYBgu4jce5ylVUtFOy5H5kQOperMV7o
	 XYe4Gn18KEkZw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A1D39EF964;
	Wed, 24 Jun 2026 08:59:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH v10 00/22] fs-verity support for XFS with post
 EOF merkle tree
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <178229157126.2577930.6775564706271606889.git-patchwork-notify@kernel.org>
Date: Wed, 24 Jun 2026 08:59:31 +0000
References: <20260520123722.405752-1-aalbersh@kernel.org>
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, djwong@kernel.org,
 david@fromorbit.com, linux-unionfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 hch@lst.de, linux-btrfs@vger.kernel.org

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Christian Brauner <brauner@kernel.org>:

On Wed, 20 May 2026 14:36:58 +0200 you wrote:
> Hi all,
> 
> This patch series adds fs-verity support for XFS. This version stores
> merkle tree beyond end of the file, the same way as ext4 does it. The
> difference is that verity descriptor is stored at the next aligned 64k
> block after the merkle tree last block. This is done due to sparse
> merkle tree which doesn't store hashes of zero data blocks.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,v10,01/22] fsverity: report validation errors through fserror to fsnotify
    (no matching commit)
  - [f2fs-dev,v10,02/22] fsverity: expose ensure_fsverity_info()
    (no matching commit)
  - [f2fs-dev,v10,03/22] ovl: use core fsverity ensure info interface
    (no matching commit)
  - [f2fs-dev,v10,04/22] fsverity: generate and store zero-block hash
    https://git.kernel.org/jaegeuk/f2fs/c/07d09774e2bf
  - [f2fs-dev,v10,05/22] fsverity: pass digest size and hash of the all-zeroes block to ->write
    (no matching commit)
  - [f2fs-dev,v10,06/22] fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
    (no matching commit)
  - [f2fs-dev,v10,07/22] iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle fsverity
    https://git.kernel.org/jaegeuk/f2fs/c/63e242afa466
  - [f2fs-dev,v10,08/22] iomap: teach iomap to read files with fsverity
    https://git.kernel.org/jaegeuk/f2fs/c/1d140731753a
  - [f2fs-dev,v10,09/22] iomap: introduce iomap_fsverity_write() for writing fsverity metadata
    https://git.kernel.org/jaegeuk/f2fs/c/36a36c4cac91
  - [f2fs-dev,v10,10/22] xfs: introduce fsverity on-disk changes
    (no matching commit)
  - [f2fs-dev,v10,11/22] xfs: initialize fs-verity on file open
    (no matching commit)
  - [f2fs-dev,v10,12/22] xfs: don't allow to enable DAX on fs-verity sealed inode
    (no matching commit)
  - [f2fs-dev,v10,13/22] xfs: disable direct read path for fs-verity files
    (no matching commit)
  - [f2fs-dev,v10,14/22] xfs: handle fsverity I/O in write/read path
    (no matching commit)
  - [f2fs-dev,v10,15/22] xfs: use read ioend for fsverity data verification
    (no matching commit)
  - [f2fs-dev,v10,16/22] xfs: add fs-verity support
    (no matching commit)
  - [f2fs-dev,v10,17/22] xfs: remove unwritten extents after preallocations in fsverity metadata
    (no matching commit)
  - [f2fs-dev,v10,18/22] xfs: add fs-verity ioctls
    (no matching commit)
  - [f2fs-dev,v10,19/22] xfs: advertise fs-verity being available on filesystem
    (no matching commit)
  - [f2fs-dev,v10,20/22] xfs: check and repair the verity inode flag state
    (no matching commit)
  - [f2fs-dev,v10,21/22] xfs: introduce health state for corrupted fsverity metadata
    (no matching commit)
  - [f2fs-dev,v10,22/22] xfs: enable ro-compat fs-verity flag
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


