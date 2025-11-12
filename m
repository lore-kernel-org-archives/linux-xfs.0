Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BA7186294
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 10:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762943597; cv=none; b=Y/buL+Jv5DU505Wqtro8XtYa4re348oCY8zFJ1Nc4JxQOEapzqrdWkUA4TeVyWO4gKpYCuo+KMHNorbDjxD1N379xKwqaRt5F021adQYvofmfneWOCRgV958eLayKlo3GCmlPwCmWknpzb+Ig6LMMoWqg+hz8BuNqScH7J+Q+Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762943597; c=relaxed/simple;
	bh=qGO9J5NtZNpJa5LH/0tBIAuXxFafISkHb1LCKFkj2k4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qwDdJWh7k7GGmzJT8pNqGT+J7kSGbigXWhNjUajDR6p6m/Z77VPPEA67mHRp05PIaHIoIrAnAuYu3cDihRGMv/cdm/mKJ046DK9yg0REyz/jI7FLW1zsjeLj+6n0mZ/kgazNHd4RVkyDK82CxqCovyOWT6/JO+dfDdWGzJc3NhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqaHHiNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqaHHiNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDB8C116B1;
	Wed, 12 Nov 2025 10:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762943597;
	bh=qGO9J5NtZNpJa5LH/0tBIAuXxFafISkHb1LCKFkj2k4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=IqaHHiNaRJ5vPv851EpqYbHxPMQDc5lzMtOqEnCUkX117kIdAR+z63N4FUvP0zxw4
	 /Br+VYWZzR7NSTyU1/Nk0CukmgkLRexW4C8t7wr6gnJn34yb6ARkx3xYixCG7kM9/o
	 IfFNqndR+4JbmgyZGRRrb1ysEbiyEKdX6vJ4RmkEpUy4CrY567Y5N37JHIy/t8PuC6
	 2QZYelHStnawsQjcqb/oocIPpF46WQSP//bgMrF/800f0lFD5Kga8sX1+lbu2gxD1R
	 ZmTJyAubKzhU7R++S1M96iryEyHEGtnxai6X16Vsz3pJR1NtFwpehTXkeaY5kgte21
	 wBzmXqL+pr3Ew==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20251027070610.729960-1-hch@lst.de>
References: <20251027070610.729960-1-hch@lst.de>
Subject: Re: kill xlog_in_core_2_t v3
Message-Id: <176294359646.682626.5824293511107187767.b4-ty@kernel.org>
Date: Wed, 12 Nov 2025 11:33:16 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 27 Oct 2025 08:05:47 +0100, Christoph Hellwig wrote:
> xlog_in_core_2_t is probably one of the most confusing types in the
> kernel. Not only does it describe an on-disk format despite claiming
> to be in-core in the name, but it is also has an extremely confusing
> layout.  This series revamps our C representation of the underlying
> data structures so that they hopefully make a lot more sense while
> killing off xlog_in_core_2_t for good.
> 
> [...]

Applied to for-next, thanks!

[1/9] xfs: add a XLOG_CYCLE_DATA_SIZE constant
      commit: 74d975ed6c9f8ba44179502a8ad5a839b38e8630
[2/9] xfs: add a on-disk log header cycle array accessor
      commit: 899b7ee44baebcfb2b2366b2aff6e9aca4486c4d
[3/9] xfs: don't use xlog_in_core_2_t in struct xlog_in_core
      commit: be665a4e27417227cf40cfe27e616838bb46548c
[4/9] xfs: cleanup xlog_alloc_log a bit
      commit: 16c18021e1f518e6ddd4ddf2b57aaca7a47a7124
[5/9] xfs: remove a very outdated comment from xlog_alloc_log
      commit: 9ed9df98fcd7203c0eeac21e6784bb7cc7a291d3
[6/9] xfs: remove xlog_in_core_2_t
      commit: fe985b910e03fd91193f399a1aca9d1ea22c2557
[7/9] xfs: remove the xlog_rec_header_t typedef
      commit: ef1e275638fe6f6d54c18a770c138e4d5972b280
[8/9] xfs: remove l_iclog_heads
      commit: bc2dd9f2ba004cb4cce671dbe62f5193f58e4abc
[9/9] xfs: remove the xlog_in_core_t typedef
      commit: 6731f85d38aa476275183ccdd73527cd6d7f3297

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

