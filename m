Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A835AC27
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782798087; cv=none; b=Mj/W6tKYQ3BsXXpK/mFKmOJMygmdFwymENAzoeGppuvKBFOS2EF4IU5DLSHGS1cgCEIH9NV6tdrLVL/WZYw3oqTdIs2qtEUMavtJH9n7l3GuMfixPiA11fi5YZkOnucgVhN4V388BGBKs1x+Tu92Ov3dSJJOfHn12fEttd6Lnpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782798087; c=relaxed/simple;
	bh=b94VLBz36vmCbNR9EwYGjNKDuMR9FDQc91ciZ6SIadI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBUftTVtXwjZ16pUOKZQ2EnpJpirEzHexEsBu4ZasmJt4riBLaKWvaY/xMow4li1Z6f9xQ4TYEja6KverVbNe+C9fDywifz4EOq1UE1HFbPdwgazkBK7Y8XSIOVL3nTcUPT6BJvXbevqmnVv431eitteNXHOrjIpd76MysKj6zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3A14568C4E; Tue, 30 Jun 2026 07:41:23 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:41:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/6] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
Message-ID: <20260630054122.GE21007@lst.de>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs> <178278129898.858323.347624126934023375.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278129898.858323.347624126934023375.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 06:03:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out that project quota isn't incompatible with
> non-enforcing group quota in the kernel, so those shouldn't be
> incompatible in mkfs either.

For file systems with XFS_SB_VERSION_QUOTABIT there is no incompatibility
at all, enforcing or not.

> 
> Cc: <linux-xfs@vger.kernel.org> # v6.13.0
> Fixes: 525f826429a868 ("mkfs: add quota flags when setting up filesystem")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3da11c664255b1..a4864c37a8821b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -976,7 +976,7 @@ static struct opt_params mopts = {
>  		  .defaultval = 1,
>  		},
>  		{ .index = M_PQUOTA,
> -		  .conflicts = { { &mopts, M_GQNOENFORCE },
> +		  .conflicts = { { &mopts, M_PQNOENFORCE },
>  				 { NULL, LAST_CONFLICT } },

But I think this is just fat-fingering anyway, as it wants to
conflict the pquota vs pquota no enforce options.  So I think
the commit log could use some rewording for clarify, but the
change looks good.

