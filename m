Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBDA4D4867
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223599; cv=none; b=N+uQjx2ss/OkYhVJYRxvkGLHQXT21Es6o/2aM25MdNUtHT1O+w8iIT9sNT0tl0wZ6LOrVEgTrqWxH6sDHK30dG/e+Fi5NTDkGh7YLh7xhNiyAc2HfUoz9OwMl5PI8XSr0zxsKvhZPFgCXixnxdQZYYi429IyLVu3pqcggR5JDJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223599; c=relaxed/simple;
	bh=LF4s3diN1j0ZDpIdRNBMYFHHuzKH0tLRpEIi9YD8RvM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qWcGrcNZktSjaSph2aF1smxaUjORrTtCfaaIm5xXzO75QqaXEf6H0TpYTDEI88SCNuGMF8XTphF8yoy38ERhNqiizwsmNP4aXoyiVZpnLRzI1RZVTeJogDfOpzOQrYhw76NUIK5e21OrfqiWUkGh9lOjQL2WAYXB7eqHHJBPQ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LIsbZV++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LIsbZV++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6751F00898;
	Mon,  5 Oct 2026 18:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791223598;
	bh=61Eg7GRTu7eONodW2iSwO9U5p2y4M3dWoFk06y5DRq8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LIsbZV++Mir98BD8SyGtAmtM1yEegRolHF2t9to2qjXyfEoncMjPsdpW3NHKLimjj
	 Bq2azpFqbZMQnpoliiNmtPeH7VVsgVnHW4H39wY0/TRMD/EHMAPqayU12LKWb6r38D
	 cfmFyjOMlTdjuEDBNJWffrK8SNJQ83Gai2n+bZkM/eKtEkvYsI+2x3S4hD6bVpVCfE
	 romkKIEZjGqGtmcwrp9PioocbO4Cp9RVOSiW0WlIuyitbJMchNEmhnFO5awIQguBdI
	 JElhHH2JhWNkHyGx4ePwkrVR7T+YRLgOHrZaVpOU8TNDfOBMfV2unSCVAqHhlvQlZN
	 rnytwhpp1UAgQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260925151543.3382123-1-hch@lst.de>
References: <20260925151543.3382123-1-hch@lst.de>
Subject: Re: speedup cache flushes for the RT device
Message-Id: <179122359733.102066.13789286478683490561.b4-ty@kernel.org>
Date: Mon, 05 Oct 2026 20:06:37 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 25 Sep 2026 17:15:35 +0200, Christoph Hellwig wrote:
> this series speeds up multiple caches from log commits by doing them
> in parallel, and by not doing non-log device flushes where they are
> not needed.
> 
> When doing small O_SYNC writes onto the rt device of a file system using
> two SSDs known for bad flush performance which do not support FUA this
> gives a 70% speedup.  That is a rather academic case where performance
> is bound by the cache flush, the speedups for normal setups and workloads
> will be much lower.
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: clean up xfs_fsync_flush_log a bit
      commit: 5ed6d84e9dfe4ace8a96ab2c7b486f0ffe3e67fc
[2/3] xfs: optimize cache flushing for CIL commits on multi-device file systems
      commit: fe8b1951cd812ec592164cd43ee7a0ce49a79622
[3/3] xfs: flush multiple device caches in parallel in xlog_write_iclog
      commit: ac81739a869c24a42db15282a44de68623376f27

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

