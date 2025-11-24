Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF65B2957B6
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763996755; cv=none; b=cRpGMxP3P7scxC6nnJ3jKqUUkZrWTBK40fFjbkH5AY2im7VnFdicCigs8oiTYkW/HySidgxWqyhCAMggo7ALvuvbdUepde5OJbBNhxiq3AjIJSUVPBv8NqHKdGoDpa9Hh1hFmaG/fU5VamFVlJsJ4ahRtnhwpEv7Zyllt+FLLr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763996755; c=relaxed/simple;
	bh=fwmkjsiIDdSCzhSobFaqKSrRekyMt8ImCqedLsVH09U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MSb0XKXZK1MPd/AHohajCPqMra0Lt1ZjaOKj4HQ0zQAJmrw5mQ8SJ9ARWFLzRQOfZ31t21IY0CXri+43qnDoSDb6mS42C8g+S5ZNyhqn0h6J5jg+M+qta36f1SxumnaHzglVrH4vPlj5jIq7cxm2x9p9ghicc36bIp9+rKlmxUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBmhMBY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBmhMBY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94A6C4CEF1;
	Mon, 24 Nov 2025 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763996755;
	bh=fwmkjsiIDdSCzhSobFaqKSrRekyMt8ImCqedLsVH09U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=SBmhMBY5oaT53NoTTIk4umIlLWEdR6hcFuiHUkMYrsMFkUH7vg7TIw8m0W+zPbASe
	 V/1N4o2MAZRE+dqgnG7X5W7FRN2cZKkD9jusBCaOn5c/i94v7C5OiC3Ord6wKJ6WFm
	 7xq1lHQb4PAXwHerW5cdVS4gPrrGmuIMldcsuvR6aLMQo7M5PlwvY3adHjZTtTAyVK
	 lzVhiEpJcZdvZx+3KBNtTvu3g/4XZtjgccjhFRzNZoSlP5uGr+K2XXHNBsm752hVhZ
	 w+ebYNLCwlI+sW33ZbSjO11hFETScJbMM+9ba5rQ9j88BLxJkkinr5BDCFtlKtpCWq
	 7ab393LIFme1w==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20251112121458.915383-1-hch@lst.de>
References: <20251112121458.915383-1-hch@lst.de>
Subject: Re: cleanup log item formatting v3
Message-Id: <176399675437.124952.10369985473910554845.b4-ty@kernel.org>
Date: Mon, 24 Nov 2025 16:05:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 12 Nov 2025 13:14:16 +0100, Christoph Hellwig wrote:
> I dug into a rabit hole about the log item formatting recently,
> and noticed that the handling of the opheaders is still pretty
> ugly because it leaks pre-delayed logging implementation
> details into the log item implementations.
> 
> The core of this series is to remove the to reserve space in the
> CIL buffers/shadow buffers for the opheaders that already were
> generated more or less on the fly by the lowlevel log write
> code anyway, but there's lots of other cleanups around it.
> 
> [...]

Applied to for-next, thanks!

[01/10] xfs: add a xlog_write_one_vec helper
        commit: 5a231381e5e83d266e2d9ba66d1d7f0a9aff3e88
[02/10] xfs: set lv_bytes in xlog_write_one_vec
        commit: 74f645212e0dbfe8c7614b4ba0946f1198148fec
[03/10] xfs: improve the ->iop_format interface
        commit: 406fa5a5a9c303c55924601c8a8ab9aa0228e084
[04/10] xfs: move struct xfs_log_iovec to xfs_log_priv.h
        commit: d09aeba6ce6e8d98eb14207a24ae2c6e01c6065e
[05/10] xfs: move struct xfs_log_vec to xfs_log_priv.h
        commit: 9ff5678846f2a818c744728c3ab58d77b35e07e7
[06/10] xfs: regularize iclog space accounting in xlog_write_partial
        commit: 4d139d3aebef74de9eeb1a24ae35f20f1665c919
[07/10] xfs: improve the calling convention for the xlog_write helpers
        commit: c11b2834d0b2fe3da7c024fe0a840fd953b56b62
[08/10] xfs: add a xlog_write_space_left helper
        commit: 4eb6609e629b2e7af1d22f0d66c6ccf9c3faceeb
[09/10] xfs: improve the iclog space assert in xlog_write_iovec
        commit: 9c3fead7ccd4bc5e6c30f9d8218a1440ec31687c
[10/10] xfs: factor out a xlog_write_space_advance helper
        commit: f66ea030a78345fabeb8604cbf2a7132b25d30fa

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

