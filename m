Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F78C32D0FC
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552451; cv=none; b=Ebs+HYbu0MZ53ciy4YIM6pQMa3KL3vK+Wyrl/n+N8PDOnUgraEsENfakwjLvEBLXdmE6wka1aMx2YnfhngttaCv6KWjvezdbRgtOf/PhScWrgFCn6+rV247gc7+XudxHRaFfSIeX3t69geOWcVs7HRrMgsW+KG1BfQUA2wszaO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552451; c=relaxed/simple;
	bh=+07JA7FUJHgiD77Aj8DmivAMKmwPUO/eE0jRJGw1oaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R41CIEJ9FpaPhP3ZGKVmjhc6OnTolPA3sut2DPQCydXEUgr1WcWS+fmVY2rLegEBFW0QYu7pnDL8mEkGLbQtm1FpA2bszX1La89ojkcDGOnmW1sOuNQ/JaIPU/PoATQQMYpXMo/qyrm2BzibV/C3+rbyF4AzCyzxcTQ2fljMLko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdbskO4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdbskO4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C00C116C6;
	Tue,  3 Mar 2026 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772552450;
	bh=+07JA7FUJHgiD77Aj8DmivAMKmwPUO/eE0jRJGw1oaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kdbskO4ClkX9vG6cTDPwou/Z7OyF5P6dwN60CdWXZ9oM3qKb+VGzrKLMljNiNaevp
	 tqs+oxYZ2LG/atzGNPfTFKpxnrYveg0Wb0/Gu8utL8ZaiPYJGkrOVIHlawrec6pHCf
	 nwJ4oPcccbe4DgY1zgfjncuB0xGQDwSmvikhxtnu6A2lyXNWiJnTxuYJ6wYCt679Rz
	 gXdUE8jKtcg+3NUK/tWKvwY33Dzc4cEEr+1Fh/R+VsEdcmko0l5Dyttxj782ly9+Dj
	 xie+FiSECIOTrrkpgfiKK4lE7nPrY3PctZu0rrly1l38EzMoMiQX65oaIHClaW1AR4
	 On8kEp9AKYKDw==
Date: Tue, 3 Mar 2026 07:40:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, dlemoal@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/36] xfs: split and refactor zone validation
Message-ID: <20260303154050.GH13868@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638091.457970.11956003361714341028.stgit@frogsfrogsfrogs>
 <aab0ENuLXPSADWVS@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab0ENuLXPSADWVS@infradead.org>

On Tue, Mar 03, 2026 at 06:45:36AM -0800, Christoph Hellwig wrote:
> FYI, I have a whole series to make better use of this new API in
> xfs_repair.  But I guess just doing the bulk conversion as part of the
> sync might be ok.  Looks quick from a first glance, but I've not 100%
> verified it.

<nod> This was my quick and dirty make-it-build hackjob.  I'd review an
improved variant on this. :)

--D
