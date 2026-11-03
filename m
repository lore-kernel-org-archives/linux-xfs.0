Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700162;
	b=pKCjlfQGB8Z+rIakMnOw6yvnSWJValiZRwREAFiOwRI6pqiHpiGYU020kwKnrMeK7Y5p
	 laOyLYBsGmKLhIiegSwRrqkYVG07L0iEjI2oBtJfF9jH/76jVvt3VTItlRrnQwUGPUO9N
	 R0yepJfki58QnSYjxIAKUsG3b+fOu7ftmSFSIpbpgTD6qNe6/ipyZkq8kaBREH9CgYKgm
	 V2YrlZE1PV9JLV9mqB8r/DPhcNgW30mY+fgI4bGiDAD+xQa1S5jOHr2fw37daHb7Tlic5
	 Sx33kpQ6ndi+3X3rlshkDHZS0RUMr2Uhdbd6naPUbSLiYadIZnoWW2Y0nshMP64VogQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700162;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=x+uOsE01FYLCNNNOL1PikYz4xGMxpppHc1xkTCV4W8c=;
	b=34R6RyT5JJIzsSUVEyP9hlAhnAeGiQksMZhzjqsmdb8r22ouKO7QcxscewVI2R5h6wBQ
	 ECaMqLeEKMcBnhvniyKbO3NB0Zgh3Yr9p4V9IA8YXeszdNh/THccBDiqkrfz3VzCyEMZh
	 QDm/Xt/e/PzYCJkqqhczUkpXGGaGzi+e/a5vETEKiVhMYEaxZZrnTwxwVZ8vao+h496AO
	 nQfTsJYrIus9CutKf3ibjJv9eIZ7gO+5JgUmwrD7xVKtQA5+LH55kK1KAuCIOie0dpoi0
	 Q4juUPjb/3cfeUdzFoZRf+e2CkODfHt9j1V9/WOGMpkP4cyd2OILQavKf3PNVJfICqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zq7ykDf3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB97E606EE90;
	Tue,  3 Nov 2026 10:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zq7ykDf3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACAC1F0093A;
	Tue,  3 Nov 2026 10:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700161;
	bh=x+uOsE01FYLCNNNOL1PikYz4xGMxpppHc1xkTCV4W8c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Zq7ykDf3LwUYRMrTGDMpxEENTVeJBwJwvSoLywvvUN4xRLl7KIsJvv8FEzUTV02Bj
	 hspsXosw/LjGIhNaCC/EJ0QEWveZRiTgld41XcHQVeg6LxTi/2+fY+WvRB3kuPQPNt
	 WGJqyS2kndDbczu8Mys4Abg7Y/6Nhw25wAIDJkrY1Wzgm6OTnMCULkeMkOhR1FIHTw
	 vTfHDRvpIsQd8xi+DLVGWAsK7/utVJaTCixkalEBGP7arupKNNJV3xJWAUnHqK1MGf
	 Aiq/Au66CkhJB1bXPGSOux/eMcl6p9d0jw3qrKDTcGAmYRKxZ5o8aF5bgj2FVCSNhS
	 PhpHYPtkwigLw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
Subject: Re: [PATCH v5 0/9] xfs: pNFS block layout fixes
Message-Id: <179370015876.413123.10956026336394412777.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:38 +0100
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
X-Mailer: b4 0.14.3

On Thu, 29 Oct 2026 11:22:57 +0900, Daejun Park wrote:
> The XFS side of the pNFS block and SCSI layout fixes. A pNFS client
> alone can trigger the bugs fixed by patches 1 and 3 to 6. Patch 7
> closes a race with a local process writing to a shared mapping.
> Patches 8 and 9 make a LAYOUTCOMMIT stable the way fdatasync does.
> 
> Patch 3 needs patch 2. Patch 4 should not go without patches 2 and 3,
> and patch 6 not without patch 5. Patches 1 to 6 are marked for stable.
> XFS_BMAPI_CONVERT_ONLY takes bit 12 of the bmapi flags, which the
> fs-verity series [1] also uses.
> 
> [...]

Applied to for-next, thanks!

[1/9] xfs: mark the inode preallocated for pNFS write layouts past EOF
      commit: 77d5d75d727ab3d4c540632ead457d47d3456cd3
[2/9] xfs: add a flag to convert unwritten extents without allocating blocks
      commit: e0fbfbec7d5ba059fcb1529054b5447cbe9c6e0e
[3/9] xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
      commit: faf5f20d6c005af531de079a5a0ea658b305954a
[4/9] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
      commit: 351fccff2881e40f4f449bf100aceb47a54688e9
[5/9] xfs: cap the block count of xfs_iomap_write_direct() at one extent
      commit: cefa7c7b065d129fe95a64b24ee68ca8c47629c6
[6/9] xfs: clamp the pNFS layout range to the maximum file size
      commit: e4211f8034ce04a6bb1e12fc6a054e08b933e5cd
[7/9] xfs: take the invalidate lock while mapping a pNFS layout
      commit: d58a23e183d578aca38d7186c353702facbf722b
[8/9] xfs: add datasync and log_flushed arguments to xfs_log_force_inode()
      commit: c92cc6514b9c11dd29b90b0a814e8ea87b4a4687
[9/9] xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync does
      commit: c3b00a553cbb68b0bebed0ca16d2aa0300d07e56

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

