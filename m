Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D295C33DEE9
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 11:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761909573; cv=none; b=EXoMDwVx9nRNPzYv6Gg7R3E3zKSku6WmvWIu3BkucCx/5+fi8JGImo/pBP+Qq3Elo0ReU4A/SFvPFb3re1wv/umBwO541+6dRMTGsg9OHydvYTXNwV9TcS4cIswFWWErHzHeVa71uqg46a1VzfOsNdXOQ0lRMkCzDdSfqzIt1RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761909573; c=relaxed/simple;
	bh=u5veALzpJf8mJuKe/poU/FC2mkkmsRRHfZdOnocJbjs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LeqvozI7AXGlmqyM5eC+PtBw5oIBZnkMnMKi+CTWcjMxHv3STEBy7B5ZU4HWqAVskR6itWeU5qXyR+psN5kAOdXcLgC+gSlwv8zoVh2PACtIEHkyp7VlMH6bZ43NK8WUnJ4f/699tCd2+24rye8wZV7wyA0k8vx7y1CEhgtFX6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QdcCJVPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QdcCJVPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA887C4CEE7;
	Fri, 31 Oct 2025 11:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761909573;
	bh=u5veALzpJf8mJuKe/poU/FC2mkkmsRRHfZdOnocJbjs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=QdcCJVPA68VbEwohHjH9lJdzp73qWqPx+P8rHmiuRhCNCsNWC8sacjggutBpqc2yp
	 Ctxo8Eh1avCwBglWFP+u+KS8oq6fZGoz6+dmuX3To585Kwgs1ew+ATxFXwZu9Yd1LA
	 dSEUw6h6yLMcF0sK/cxDf8m/gJ0lv7b6fbqm+OYzXQtn+wowkbe2u0QOIQU+VMw0YG
	 UEDqDv9ITzh0/EMdmUFCv+mkvq0TPaOY3mu6ex7TIKhM+UikO9InGcQAgY5fTOAHv9
	 s6YTagVjhlDt9KWDNnsxjZFHiWYf8xKBBZO7jIywWGAd6mqECvNqNaglLKPxwUZg9T
	 GLCA3vzbXKexA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 Damien Le Moal <dlemoal@kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>
In-Reply-To: <20251023151706.136479-2-hch@lst.de>
References: <20251023151706.136479-1-hch@lst.de>
 <20251023151706.136479-2-hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Message-Id: <176190957147.118652.14188920932751767757.b4-ty@kernel.org>
Date: Fri, 31 Oct 2025 12:19:31 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 23 Oct 2025 17:17:02 +0200, Christoph Hellwig wrote:
> When we are picking a zone for gc it might already be in the pipeline
> which can lead to us moving the same data twice resulting in in write
> amplification and a very unfortunate case where we keep on garbage
> collecting the zone we just filled with migrated data stopping all
> forward progress.
> 
> Fix this by introducing a count of on-going GC operations on a zone, and
> skip any zone with ongoing GC when picking a new victim.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: prevent gc from picking the same zone twice
      commit: 83bac569c762651ac6dff9a86f54ecc13d911f7d
[2/2] xfs: document another racy GC case in xfs_zoned_map_extent
      commit: 0db22d7ee462c42c1284e98d47840932792c1adb

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

