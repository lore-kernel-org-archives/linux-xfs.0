Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A73A274B5C;
	Sat, 30 May 2026 06:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780123064; cv=none; b=U4Xy3QFjsP/1dnxgvM/65pUN5FtKn+el+RY+072ltOwdZdzu1x8LFeKos75IwHovQRME4wOoCTzCVzOwRxBzlbrZwYFd7rcVTgq0wjPFTHRW3dEWl+zQy3TC6K8jbrLM1BG3MZ3mVmnDMKzkA8PAoYUZwT0bQ6+NNIrJvWZtHkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780123064; c=relaxed/simple;
	bh=gEiLYM2doJphVnKry/4lwBBYT6Td5kWBst9SCeRY4i8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NKEkWftJNyVovuu7ejnMxrriOvQUtWnUpdB2gqKBrPZf4URKKcqk+yf5oUQVjZhrJ7jB2o/xchuiDzYKIMSyTay/aaPG4fQqQqcVzGxqDNYehWRGbpXtW2bL3+jQn1jbwDcbdDpS0qawqGaCyRiJkE7JKNnrsKGJ1qrFt2PRmmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NdxXmZ8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NdxXmZ8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532B11F00893;
	Sat, 30 May 2026 06:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780123063;
	bh=Mzd8gJewC6ZnzoHSZe0g9lGsqiB7x1YwPjmy3uHsLJ8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=NdxXmZ8cpAMtFoutTjErUjVgPVF1lhWu4Xr3G5az1fxws6LfqDq1Tcp9dpaKCciR+
	 uw5j4DDFS+vtxkufjRjRuYkH9XglS+aP1rpg/F3PizHvZXEUlfVDqrkhH428aViO0Z
	 lcQdew2FTS6VRW9ZHBkeJYP2xNtteoWfXjQa0/yFBF2RtK/q8kVhFzkVIfQEjWF7j0
	 +VQPpQbfjfcklLna3J9VwxuQsggqVCyrVHCrqQydtdSoySf5hcc7tG+L/rHpTFf5EJ
	 ZjrcIexopAM9847aV1DjXXJDUxhI3eD3Bhbp5rYy0gLZ+o/yDAq/ZK6HfyVwprmTBw
	 vcu+dxLYCrlfQ==
From: Carlos Maiolino <cem@kernel.org>
To: Dai Ngo <dai.ngo@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <20260520003503.2399326-1-dai.ngo@oracle.com>
References: <20260520003503.2399326-1-dai.ngo@oracle.com>
Subject: Re: [PATCH 0/2] xfs: correct pNFS layout mappings
Message-Id: <178012306198.22275.7605201361489277249.b4-ty@b4>
Date: Sat, 30 May 2026 08:37:41 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Tue, 19 May 2026 17:32:57 -0700, Dai Ngo wrote:
> This patch series fixes pNFS layout mapping issues exposed by running
> xfstests generic/075 against an NFSv4.2 block layout export. The first
> change stops xfs_fs_map_blocks() from propagating an uninitialized
> mapping record after xfs_bmapi_read() fails.
> 
> The second change removes the XFS_BMAPI_ENTIRE flag so each request
> only returns the range the client asked for, eliminating overlapping
> in LAYOUTGET replies.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: fix use of uninitialized imap in xfs_fs_map_blocks error path
      commit: 97bdbf2613eb89428b739ce09d1a6e1c8435a286
[2/2] xfs: fix overlapping extents returned for pNFS LAYOUTGET
      commit: 36ca6f11424a5b6d92b88df37c40bf2fe825d5a0

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

