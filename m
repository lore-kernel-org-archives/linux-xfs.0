Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105343016E0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782797506; cv=none; b=AJLX/XQe5PQ7jTd+vpPastuuA3dVqr/JueLd1QbTmqOJpSuZ4Hf1vMf1mdfY9mEk0eo4tfcSVsclUiirSZhVhoGRPk4a1XjwOuFyt+fsSM31FH4+P5vE+8t1Q1WsdhAjnaok0jFhrVe19iKZHwMwQScyKPX1hJo+K4uQL7GpJA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782797506; c=relaxed/simple;
	bh=q4hwwS1FynIdY+LErE5UayWvd143+kPiwhVQkMsX1N8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEOAVPgHf8c5id3tZ/HR758jJlmXUz6c0dFrEjPYFBANO/ZIEYIUwWenf8074E/+Q7XvdmAmYLwzxtaYT7itDtoHRw2mQ60EYIQectbrd3rcVF5uw8T98GHO3lHelECCql0MwmTWi5BlMzToMfSPdXGtMwz3mTubmkHKR9vcrBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A615268C7B; Tue, 30 Jun 2026 07:31:42 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:31:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/6] mkfs: fix PATH_MAX check
Message-ID: <20260630053141.GB21007@lst.de>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs> <178278129843.858323.3368571818285079629.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278129843.858323.3368571818285079629.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 06:03:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Per the snprintf manpage, the correct means to check snprintf for an
> insufficiently large buffer is to check if its return value is >= @size,
> not > @size.  Codex found this.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

