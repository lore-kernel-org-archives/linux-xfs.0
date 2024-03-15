Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D8645
	for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2024 00:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710461009; cv=none; b=XK376FFTCjSrNFYiQQ2XJz5LSlgm2y+/ev5GJpZntXbwq1pD1eFxw7PW4y/AhiYrYEY5mJ1DbSYwEhy5gFLdiY7GmEA6yrLUt1xc5aKmQpJRpv9GnVMhD9JUoAPzC/qeyzQbGs6m3DJeeVpv2HCSZTiu1tXgdLwjEq2ubeDvr3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710461009; c=relaxed/simple;
	bh=8Ftr7KjJkQtJ+T/9+RmLAOtIpd1M4TT62U7JjV+G/K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fhvl1pp9+ZmQwYn3Kv4HeJOvrVbby85jDBa6s5G7edpjz9N1iTShC+NEPAFhjMLfPEfvwLdqHlB/QAhcFMcnJEAnZT94kBs7D2nVrOg+eJ+beHtcGLnZSJU+pMLOYTBd1Wy1TbvJIFOYFM9SHddkgBT0QJTGTmpNwnuVP+SNvrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJJL/+FR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJJL/+FR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01ADC433F1;
	Fri, 15 Mar 2024 00:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710461008;
	bh=8Ftr7KjJkQtJ+T/9+RmLAOtIpd1M4TT62U7JjV+G/K8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tJJL/+FRl8J8Mje8VETJULlpmvHAEn0QzoD+h/tshGHcsDXsdqD9bV2ykrBki26MF
	 01XMfwdyirAuAQr8w3TdSZEk0qedBVc+mUmKxjYGwrmFabYmEYvVvzYBDqj4Oejqws
	 hwO0K2aW9TDOLO9LuHbk+jmZ+OsnrzsfYf2cRKwOUQO2dSdSVu5d3MV+9DaTf79vsB
	 C4vYjT+ollZYVoSf8t/SJryuEsS20T8lf2+jfg1K3LN+ExWrXRcMydoCBH+iaS+ipN
	 VJEhp200JGPE65lZ0IuMkn4AdeylhQwtQU6C+ktelXD00m/gQdPWQ2rHwbIKIHqViu
	 IfLvpCIEm+8kg==
Date: Thu, 14 Mar 2024 17:03:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs_repair: support more than INT_MAX block maps
Message-ID: <20240315000328.GX1927156@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434843.2065824.16649539998389777667.stgit@frogsfrogsfrogs>
 <ZfJbwx0CQbsZfUxD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfJbwx0CQbsZfUxD@infradead.org>

On Wed, Mar 13, 2024 at 07:06:59PM -0700, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (the new BLKMAP_NEXTS_MAX is much nicer than my previous cleanup as
> well)

Yep.  They integrate well too.

--D
