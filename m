Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B35197556
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 08:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748067; cv=none; b=rk9MIl44N3Ip+HbhEaC6y7EkrbS0Qrp/W30s1XiPyq+9bMZtH6LNupPMM3nJiSSE93mWEttsoc06Yv07iLVdNq4Ky5ZOyAcsPe4hH4BIPn2DY7m818Betu6cst33TiahWotMUWNIPr7rOjWPLEH5VPEaDbDEIvmi/qqtL5K2q3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748067; c=relaxed/simple;
	bh=RQ2gSNjSwE7tUkbnZ+7EHFk6JiTrwzMJko/+Eac8inA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=s+aKvdA8cJEbOgb1wWaFbNjNPi3tA/4YddhbqZ7s6f3vUNHQ52mZWBT3dN1lDFR33ot8hXVIzfr5IvDLyeWE8gg85r2mQ3o5OReOgk1pHhR8ixTpyf+3HCvnyvIKhYc96oHVSVs7C09TPD/Z1PlNq7oUCvgnHf2hYjc/hma4A9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkOptM2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkOptM2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE8BC8B7AA;
	Tue, 27 Aug 2024 08:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724748067;
	bh=RQ2gSNjSwE7tUkbnZ+7EHFk6JiTrwzMJko/+Eac8inA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=DkOptM2pQcMDh8NlDLEM+sJZvUXuGsSYZ87Vi4XZjXRV0WTaQVhuMNbHBqff6mcif
	 qTzxfwIOXiY/ylU8qzRsjmMhB4RnQ/3QkRPjzaHbEgYn4KHzYGNSFlqfx9b+8B4ld8
	 YVUZYaqktr4I/6wivl4LXqnkGkU0HpZGTP7mfgHCGnbpVYMJPUo4TKkfsTiMi6y07c
	 TTUNRINW2Abj+TW+QvX95IEwUo0StSVjvdP5HdDnc/oOY5fKed9g22Be/KAvHxgpyP
	 GpYodHUGGVStzSgmQ0Hc3E213DFCoJaKggaArxPtaRwR4OoFkHv0ZhGMc2TGQkmdUM
	 l7OTfaafrX7ug==
References: <20240824034100.1163020-1-hch@lst.de>
 <20240824034100.1163020-7-hch@lst.de>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: support lowmode allocations in
 xfs_bmap_exact_minlen_extent_alloc
Date: Tue, 27 Aug 2024 14:09:35 +0530
In-reply-to: <20240824034100.1163020-7-hch@lst.de>
Message-ID: <87bk1es6hs.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Aug 24, 2024 at 05:40:12 AM +0200, Christoph Hellwig wrote:
> Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
> variant fails to drop into the lowmode last resort allocator, and
> thus can sometimes fail allocations for which the caller has a
> transaction block reservation.
>
> Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.
>

The changes look good to me,

Acked-by: Chandan Babu R <chandanbabu@kernel.org>

-- 
Chandan
