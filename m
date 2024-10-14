Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BE014A092;
	Mon, 14 Oct 2024 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728892216; cv=none; b=oAI7v5YLrH1QLn10OZHkWt2/wlLQQWNhNg8xfMk0m5lLK/AVfJ/e3bqaI/bPztCsh55pld0ZysVUrjtHbY2FDshBJr27opk8dIAzPXWFLexJLsUwzklsbrxFP9ZUlyC33d8q7/SEmQcmIVNq1dconRcY1lBSnqCUmVoxQu3vdPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728892216; c=relaxed/simple;
	bh=8ft23zLBPyfjIIXt7heqSn40/bAraUUJJSrSWnFtRQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niZMoWp31S1Mc2rDr3wfnE3R3IFTZMVWiMWSHE8xdgiyy2WZrhHWXmgGotXGODeDIDav2kjfo7Okr0Fhx0nOV8v001nB0LO7sqxFBWJat+sKIdxenhdA+omd0D28gHL3DKgw0/GPcDVKqrFwn2C45OxybGEVKFe90umXVD9o6JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qu5BE14M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qu5BE14M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8ft23zLBPyfjIIXt7heqSn40/bAraUUJJSrSWnFtRQc=; b=qu5BE14MgM8bbW9/QmHwT5J0D6
	fdzZUofwlobtSae51xmUKD0Y+dLBiO7s1qbFRAUji2/yD0MlqbXQh2dmmzoqvqA71IZViJ8Ra/Mry
	+byVP82kXpX1fVEVWh1PoOSZH6I86AOWciL0aZGm0nPHIRmHl3qmxqiAsN+JwD0fqdpu5UEAI7z4y
	fFJpA4prGpiJkWnjjc/Oc+2+8EoupdsmsTcLeHXHi38MwrE5cqANfKvd6JZ0o8xnW0NXKOR5CYOK1
	YXaW1mCGu0b5TffcNDirT4PRNswwhD6lJ45b14YoIyK1IcKavAt+llKSUM6akNBQ5zr7/zfij0Go9
	HeuUTBdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0FqI-000000048fU-2Tim;
	Mon, 14 Oct 2024 07:50:14 +0000
Date: Mon, 14 Oct 2024 00:50:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCHBOMB 6.13] xfs: metadata directories and realtime groups
Message-ID: <ZwzNNnbHhlCi8REx@infradead.org>
References: <20241011002402.GB21877@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 05:24:02PM -0700, Darrick J. Wong wrote:
> I'm only sending the kernel patches to the list for now, but please have
> a look at the git tree links for xfsprogs and fstests changes.

As far as I can you've also sent out xfsprogs and xfstests patches :)

