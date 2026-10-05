Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D892D481FCF;
	Mon,  5 Oct 2026 13:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206526; cv=none; b=L1e61OBLcXfYGnfLMx/JRSuQwEJKCV9NESywHKhFZwkN8Y6JR1KFTDvKV+cyGfqApCfotstfKph0hI1nMFJzyFzXiaJPCjAaUlQF7UZycHAzgNO4tc31SyI8x3i8ZjhGeTnzFlM/dU3N9zALwJoM2hvGtGsbz34/xU48bvH6xHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206526; c=relaxed/simple;
	bh=M81/exCzjWwqYvisxTcQIwoj5gzp2QutQQIkMxzL84U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unsKS1Z+H8xkerztbjspVZhKsWXdHu6Nx58pYQ1JAjLQ++zZPl5nd4HhsTlcDFD0wS3SuMMYbs5yQLJDGIzeHlGeZyYy6Mujm1mv4V4K1m0nuvnD/GSPhr42pXKPnfc7eDsWVflEgf0GSGtl8TBfbZykzFTWCmdP1yXvgv0ugWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 633BA68AFE; Mon,  5 Oct 2026 15:21:42 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:21:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs/2301: test lazy bounce buffering mode
Message-ID: <20261005132142.GK26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-7-hch@lst.de> <20260929014204.GI2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929014204.GI2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:42:04PM -0700, Darrick J. Wong wrote:
> > +# Run fsx with error injection for re-retries with bounce buffers, simulating
> 
> Aren't these just retries?

Yeah.

> > +
> > +_test_inject_error bounce_reread 100
> 
> Were it not for this I'd say this should be a generic test.  But I guess
> generic/091 tests the no-bounce code paths just fine, right?

Yes.  If other file systems implement lazy boune we could move it
to common with a helper to check for the support, but without that
there is no point in running this test.

