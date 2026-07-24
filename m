Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B8519C54E;
	Fri, 24 Jul 2026 06:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874158; cv=none; b=RVmRPEmwA0fJvfb4BwjFZ/0dk4sWF/V2j1tEwwed+QYupznfazLUqHvckPwsOdYnrO1x1TUvefclw2MH+GLqtsbjagUcn2KgKedlQ67qLU07AHvSOe6KNTZ9fArB+5gHrAHAiKVOIiR/zI33tZwSZGSUS3QFLiilv84M9i6HWm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874158; c=relaxed/simple;
	bh=lBFpdcg9Y9vfkcQ793bHvr8UCur96BAYFBIaUoPe4qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtYAuLaopWL55G1U7ZkLpXtpOiQbW6uVSEvHruXolw8eXmmR7yPF70GRjAHfFC5QWhz6B4YKIClOYdbIW8M+lwF0gz5QtoAMkJZRjqoXNvzRVnHEuYOBIhlPv0oR5RwBZ3X00cvgCQXJDqxqxARQ4z0q8lW8GErQ0ZkQDjnSqBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DB2E768C4E; Fri, 24 Jul 2026 08:22:33 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:22:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/22] iomap: add a separate bio_set for
 iomap_split_ioend
Message-ID: <20260724062232.GC4953@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-2-hch@lst.de> <20260723164907.GA2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260723164907.GA2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 09:49:07AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 23, 2026 at 04:49:26PM +0200, Christoph Hellwig wrote:
> > iomap_split_ioend can split bios that already come from
> > iomap_ioend_bioset and thus deadlock when the bioset is exhausted.
> > 
> > Add a separate bio_set to avoid this deadlock.
> > 
> > Fixes: 5fcbd555d483 ("iomap: split bios to zone append limits in the submission handlers")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Cc: <stable@vger.kernel.org> # v6.15
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Note that this already is queued up in the vfs iomap branch for 7.3.
I've been begging to get іt queued up for 7.2, but so far I've not
even managed to a reply to that.
