Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DEF1FBEB0
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 08:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752739920; cv=none; b=h92S3Dvw7kcQyA2VcFg1lsY3zO8zEYk6GnJsf4QJjcaDzuHUFzVcm6O9RQoLkQSdbNM12Fttkr9fOQClLpQaOC4bAOPCIMRnzFh0dw9+OnWkvXg6PScWiBKgPPLg+VNStYiT/OnOTGsCfJ8h/MD8sH+omJpmTCEQDr3jifks7EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752739920; c=relaxed/simple;
	bh=PyUnszIXIIXN8n/fAAH8VhJYEwQRaeQpn6unTvLqUfA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cXSC9rjD5NRfVenluSdtcrdkg8pD2cQcKzcP3a3hBwDrJzTRUrtFQNieA5tPnW7P5T6FZjDDkEy730sScDsDfEzg7YL/ZZgq7TlyC+1orlf9Y+vWDgqn72OQnvqowg4i6CpR2UCZQ1MJHuzbgUitw/4NNW/Mp3kUgIQ94fZjih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvcZjf2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvcZjf2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4A8C4CEF5;
	Thu, 17 Jul 2025 08:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752739919;
	bh=PyUnszIXIIXN8n/fAAH8VhJYEwQRaeQpn6unTvLqUfA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=mvcZjf2KeXZu/x+bihv91xUh58cnLnplwgKWmejMCxwBMJa+5LrP8sYKtIfvzGK3s
	 j8dVHueZZwiVrtJWFxnFLbG9rLnBxeGNPdJKOrJEMyazrsL05bkdHU/WFPZR1/8hfT
	 KNhSZBnBtgZ6qmkHkKszdI+6ll08MUEmStY7mzkeX0yOHJsjPh0PEpNI3pujP2PABm
	 iMUPe8M6ADAKdLqT3uueXD/AzjnzhnCEfq85Z7hoZ8gug9EP/FxPHmnYJM6cchGXOR
	 qae+QD8nhlAxvvE+G1SOtbD96s6AM9bCyPlieUeEn/PQmCx0cxjhuplOK7qghAzx83
	 D3aufSjaokeQw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20250716125413.2148420-2-hch@lst.de>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-2-hch@lst.de>
Subject: Re: [PATCH 1/7] xfs: don't allocate the xfs_extent_busy structure
 for zoned RTGs
Message-Id: <175273991858.1798976.13418892695089034429.b4-ty@kernel.org>
Date: Thu, 17 Jul 2025 10:11:58 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 16 Jul 2025 14:54:01 +0200, Christoph Hellwig wrote:
> Busy extent tracking is primarily used to ensure that freed blocks are
> not reused for data allocations before the transaction that deleted them
> has been committed to stable storage, and secondarily to drive online
> discard.  None of the use cases applies to zoned RTGs, as the zoned
> allocator can't overwrite blocks before resetting the zone, which already
> flushes out all transactions touching the RTGs.
> 
> [...]

Applied to for-next, thanks!

[1/7] xfs: don't allocate the xfs_extent_busy structure for zoned RTGs
      commit: 48510b0d85220f61337ad497dfc26ac2beb50413
[2/7] xfs: use a uint32_t to cache i_used_blocks in xfs_init_zone
      commit: c11330b4ac1141ac6c3bfce93333405dc3bb5628
[3/7] xfs: rename oz_write_pointer to oz_allocated
      commit: 8a034f984dfe32b4bf23d6729b04d37b14a76cbd
[4/7] xfs: stop passing an inode to the zone space reservation helpers
      commit: 7a779c6867faf3e2e06e60d2774af648da468c7d
[5/7] xfs: replace min & max with clamp() in xfs_max_open_zones()
      (no commit info)
[6/7] xfs: improve the comments in xfs_max_open_zones
      commit: 8196283484ec758b067adb9405299da675e2411d
[7/7] xfs: improve the comments in xfs_select_zone_nowait
      commit: e381d3e2c80d4b163302e53d0a0879c59ccff148

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

