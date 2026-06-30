Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32E73E1D07
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796799; cv=none; b=MJ0l5ZXejDXfbQ4Xu8YA40dytawc+tlzxUa7eFYk6q1AEapl+RHsoGzLhHYwLWBLjY7tcVd/M4Bq1Zlc+JNKBfVQzD5YbrTTgJ6oEl/Reyf1UpNJLMaWFkTpEeQK7Mjtk72+4f+2uZSf1XC3T+ZMXXtuVsvPk20GO/z9u4TmKoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796799; c=relaxed/simple;
	bh=Y3IyZVq7BJS2pqDXLijBrlVqXAuRHYz79TNnN5a8kAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIWvXdgS/w3oCETcHv6WYRBm9zltkv4eYtgaC7aqm3gC43MHLBcCXhK1Fi3jWgsEuSZ8VRfwgKSc8IN6FD9uyD9my0Xn0NZ1GZhLPV040DuNUj47asfCSrxKKYuWcToy3yxjjHaZuTHr13sXGalNqLBbW+zA8LvSsMijO6VEsuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1750F68C4E; Tue, 30 Jun 2026 07:19:56 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:19:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/1] xfs_healer: fix getmntent race in weakhandle
Message-ID: <20260630051955.GC20888@lst.de>
References: <178278130347.858743.17561352882773270723.stgit@frogsfrogsfrogs> <178278130366.858743.10151303158169061377.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178278130366.858743.10151303158169061377.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 06:04:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out that getmntent() can't be used in threaded programs
> because it might employ hidden global static buffers.

Can't be used is a bit strong.  It just can't be used by multiple
t─reads at the same time.


> GNU and musl libc
> provide a getmntent_r variant that requires the caller to establish the
> buffers, so let's use that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

