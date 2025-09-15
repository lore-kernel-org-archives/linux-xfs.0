Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F4E2F2906
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757960963; cv=none; b=ROrz5dHCdl5bgwYtKSWOyrlJUrp3FDTBMmVKvyMhMZuBePfr1qNfYlY7Ea6QrKzShrCkfnn5jBs6/GJWtMgaKFdcdyakkO6jKSqRfT1pNPkl66wwBh6fMQAHWjR7H+auaKcg8SvifuKPg4omm7mIVMiFHrkR2QEDl0VxAUV+azA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757960963; c=relaxed/simple;
	bh=RTHfDu7l169XLlkFjXIZrNIUVgeyKPTJNq87dNN7eOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUtGbjl6viH15DDk03mDOGuSAsoV1Fcyn7Lza+VMk6HTqh2KHduRksdLpRKOcyymmKgIRbMUG1nETyzugh98q/p/8wCyAB8qb5FuILFT+aX3Qru1HdFusCbjoLH1bEt+OabbDCK6LujpzK4FSnnV+biC/re7BxsHoIiiCgCKBIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hE5mfXpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hE5mfXpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D462FC4CEF1;
	Mon, 15 Sep 2025 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757960962;
	bh=RTHfDu7l169XLlkFjXIZrNIUVgeyKPTJNq87dNN7eOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hE5mfXpmnfbsE61RDFck+1dezil22n5p6TzFXCkGHIuj6h5eIgZKG7HTi2TAQPxzH
	 8AgfsFGFBIx24EML1qIkXLTReuA84W1gKfCT6Zyva5082pZaSHA//oZNY0KrmEcln2
	 Nl5lgkAe9rAnzgAa7skGyB6Xme9BxgOLJKjr0Pd67a6UQwUppl4F3LbyO6qMORWunJ
	 +mD7Q1etEoFuxcrzFVOp8+VUip7Um23jvh/Q1BMJn18Em6s7VQqsp0x3rGay/co5FR
	 bww/AYaEwgJy25aBe02brmL2vytjB9yxPb7SBmWylwUUcBKBL8whS1vU2PuipNJX2U
	 S4VTfnmgMugKA==
Date: Mon, 15 Sep 2025 11:29:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: remove most typedefs from xfs_log_format.h
Message-ID: <20250915182922.GS8096@frogsfrogsfrogs>
References: <20250915132709.160247-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915132709.160247-1-hch@lst.de>

On Mon, Sep 15, 2025 at 06:26:50AM -0700, Christoph Hellwig wrote:
> Hi all,
> 
> this removes most of the mostly unused typedefs in xfs_log_format.h.
> There's a few left for which I have series pending that will do the
> removal together with changes to the area.

For the whole series,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

(leaning heavily on the build bots to notice if the name changes are
actually correct)

--D

> 
> Diffstat:
>  libxfs/xfs_log_format.h  |   83 +++++++++++++++++++++++------------------------
>  libxfs/xfs_log_recover.h |    2 -
>  xfs_extfree_item.c       |    4 +-
>  xfs_extfree_item.h       |    4 +-
>  xfs_log.c                |   19 +++++-----
>  5 files changed, 56 insertions(+), 56 deletions(-)
> 
