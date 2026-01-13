Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A40B38FEF9;
	Tue, 13 Jan 2026 13:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768309845; cv=none; b=DeKBI7u0oOBCvyrc+qL1rxV9rIiWS8BbKvNhLcV2PzF0fXzr97lryjAE8lLxKbqwpvNCrC+7323MSgfAHY6wRJXlfCq99EVSplTS4V5l+j1NUNPTh6iYzs+XkOp2aDmfT+MDhfh4ma++Lm/Xz3D2toDg3Ngn2OyFSyNIsGhjzKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768309845; c=relaxed/simple;
	bh=zgQotarsYa5tOkHAEXUEfGGDqnjkLPWC74gcOV3qQn0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IwcxnnIVuE2JhY+wdjnR5rfuLUPWcda97wysS1O9iI31N7DiwE4iB5ug45woZetD7Q4wEkIXthNxKyYLnZZh/UaUU5iPoMA+Dbl4WRklLHdfokUzKXaMPQiUJJnerYoWEoEc+Mja0XN+cFqxGySyVk4pFQF2Xc4VuHOTg1XuQY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXTAuVO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXTAuVO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D4FC19422;
	Tue, 13 Jan 2026 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768309845;
	bh=zgQotarsYa5tOkHAEXUEfGGDqnjkLPWC74gcOV3qQn0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=kXTAuVO59JOJz5uO4WSCQp0fp8T7d59MvpAsABLhUDlwR4WNC+eUvU+O85ZyBx5LR
	 sK2PzOXQ0eNd6Hooj4WrnY0s7RXpnTHBiAvi3gYY2IC8HO11E5OOh8mS1xRybx3yZm
	 YwDjosZfZMdsBvdB6xq+C6Oc82IsVB/8MT3jAuEw7KlJH43G7OUzWMhxsbjnn5bcRt
	 52N/VpFe1NMoqNHX9kt7JbVQCSTHuSkbns68YSC3rrx3gO+Ep8DFZKr6fyeWmGmFKQ
	 V1kSEMNEjhDwfFrmARl/klKhrCLHFht9dg9Nu2yKKKBfRCWmcvMKsLiOHkRsATMY1S
	 ProJwRnQNliwg==
From: Carlos Maiolino <cem@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260113071912.3158268-1-hch@lst.de>
References: <20260113071912.3158268-1-hch@lst.de>
Subject: Re: improve zoned XFS GC buffer management v3
Message-Id: <176830984350.127908.17552778347104756275.b4-ty@kernel.org>
Date: Tue, 13 Jan 2026 14:10:43 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 13 Jan 2026 08:19:00 +0100, Christoph Hellwig wrote:
> the zoned XFS GC code currently uses a weird bank switching strategy to
> manage the scratch buffer.  The reason for that was that I/O could be
> proceed out of order in the early days, but that actually changed before
> the code was upstreamed to avoid fragmentation.  This replaced the logic
> with a simple ring buffer, which makes the buffer space utilization much
> more efficient.
> 
> [...]

Applied to for-next, thanks!

[1/3] block: add a bio_reuse helper
      commit: ba9891cb95ebe8bef380aa267eab593bb9e4bd51
[2/3] xfs: use bio_reuse in the zone GC code
      commit: fc7ef2519a8cba4b017cf4063db2a96f12d41a2c
[3/3] xfs: rework zone GC buffer management
      commit: 716ad858cbeea165e1faa102211dd14b6571e8a1

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

