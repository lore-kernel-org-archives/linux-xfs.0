Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F43D3C5523
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 06:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415565; cv=none; b=Zz5DHFa8TeFhiPqMo9NAxPSc+zzPFq1v0ZyQgLsPRCpiCcc87oUDuXFI5LGlmGbG4y87jSk/Pl/31YkCOu4HRoB0GVF0dbU8OPth/gYDXf0KybV+oy1D08VaV1cLxdggOTJaEM9jh5VLk0o8GIL+qpzpoTRdeFGw00ppaDjSPhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415565; c=relaxed/simple;
	bh=PeTf1MINMIa25F/GDAT+Mzj/e43azYsNERUTPg/AdEM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rK6eSpFlL0jooE1jF/n9i8LIhLszwF0lMR/Y/qrMM+jZh3foLAC+mRRFV/1SHZ6VNf4pEZK+l6AgWtjrO9d7Sm3Ymq/JznaJHHXSFooSYaf6lKZB8DHZqFAHjwvYvPcdKQxpWfByko3lRNCWNYBNNoqB3R7bJJc+jZbWrlIMDhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MS0BFZK7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MS0BFZK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0364D1F000E9;
	Thu,  3 Sep 2026 06:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415563;
	bh=Ev5UW/mPNBCh1MxKsMy/N9iu7cz9MqG/LY7jXoQOtb8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MS0BFZK7JynzjN2UTnIIY5aMUgbckOski5OHNM7SqK4UzSYSSl5rhuh+CnxLsWpQk
	 bvB1fbb5L9dlle2xSPM542u7Ndms5ZtR7TNEiCNAyuZ09AGFte3u6qOn4/NSwg+awx
	 ot97klabJK/DjxCQvaFeUV4R/DGSHdS9V9khKxA8SAhMa6C0xDcqXc8F9jQG6tfhZ4
	 lmlnESm6MXtiSo+Yh0u6zrwc7SCth+VROW1YG7fo2feVdF/YVQLSmxw7t1f5P7DKEK
	 BRh1hSjTUst3zBK3sV/5rf9hNKVht6YJBYQyUTN7933sNxUe0XhAiN72TeNQUondnP
	 5qeWn+vAbEtxw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Subject: Re: improve log context annotations
Message-Id: <178841556271.1198521.135060069742854592.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:06:02 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 20 Jul 2026 11:45:37 +0200, Christoph Hellwig wrote:
> this series improves the lock annotations in the XFS code.
> 
> Note that right now this is all mostly unused - the less stringent sparse
> lock context checks got disabled when the clang version was merged, and
> we're not quite ready to enable the latter yet due to our conditional
> locking in the ilock helper and the locking contexts transferred to the
> transaction for the inode and dquot locks, but I'm working on that.
> 
> [...]

Applied to for-next, thanks!

[1/8] xfs: fix the lock annotation on xfs_iget_cache_hit
      commit: b47988c1881c3a2a8ce49eaa4e76ba5617bac6cc
[2/8] xfs: fix the lock annotation in xfs_extent_busy_update_extent
      commit: 95e4f208b0674b0e8fd98a1d81fcde3326a77e1c
[3/8] xfs: fix the lock annotation in xfs_mru_cache_lookup
      commit: 479fbaa8751bccaad852d267647ed161193ee3e6
[4/8] xfs: improve lock annotations in the log code
      commit: 52f5bed99875cb4ba2553052e66327aa554b46f2
[5/8] xfs: add lock annotations to xfs_try_open_zone
      commit: d5cb9fc9094339993fe284b09b77869b7f22c1af
[6/8] xfs: add lock annotations to xlog_state_shutdown_callbacks
      commit: a34356467f2c126b9a9c2fecd9f03312b98b505d
[7/8] xfs: add a lock annotation to xlog_cil_push_background
      commit: 24835368f11da87629c2a53cb1ed729dd8d81084
[8/8] xfs: add lock annotations to xfs_ail_delete*
      commit: dc1c4245c2c5eb281eba85676d975ef687fe327a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

