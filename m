Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2986D3D0D5
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 06:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308246; cv=none; b=tE79ZqAdzo4SbummIB08uEXj7OafbIXrBNgCOiJE5iYWVLFdH2Ru9pcCxwml5CssT61TGc2NgCRrXy1yryvAFzZBbZUWE4Cd5f0WCK7uQCq4qlDzx11DJli2lNkkxnDjtUQNPs/7NjoZU0YwsM0PoJUg0fBtg4EnZdkW1F135fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308246; c=relaxed/simple;
	bh=tK8RcAe8M/vjIRKMOuH2fTUpV8Ld92qkWw34hxWoWNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mwb3NhjUeqfTM/R4jTzXml+Gk00N51pxU/zghrlD2Wm8OmHRSm1Vy7a8e8pAVVQxhvLhRXHviRCy9T0TjVTN0peSP+dlFF1SbNpNxzj4xra/lrl+glS23Z0dO0QsCGq9cGm3mH7aWyMPj5qhwaCv9Sh00j9jOuKRZn5P0QxUUuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oUKzQaGQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oUKzQaGQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lT1peAfbRUIfyIBKz+reQ702i51Sq5Qf4AFH6k7zfAE=; b=oUKzQaGQJNybTMD0NjjNney4E2
	IIn4/1Fb0Ts4QGuegmdvt7WTYSnWoO5tH3l3V9ptNRrn14Bz7gXOz8s27SGRzaTf3C+Nc/E7sIn1m
	5PYuFh+kT+vzPkTx5vBXwydvN3dgGR1IcnR3xFZOh/jjLcKw1xi1Bipfm+wXxiz8Ye+0RSuZlmXbq
	tw8xYENVaCnr/BB2j6JF9a2CX04zI4V02OTpmMg+ljmVN08OfO3yWL7csZ7kmuNuwzj1iMWo+6j+g
	RJEcKsNHI6EpgBTMkRruTkCHQouXhLlX6+5O2oUgZTkUsVj3y0eaHtzxkDlW9m/Igdv2TElP5AWvV
	SHKKeFRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh1LI-0000000Bbqn-36SO;
	Thu, 22 Aug 2024 06:30:44 +0000
Date: Wed, 21 Aug 2024 23:30:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: Re: [PATCH] xfs: don't bother reporting blocks trimmed via FITRIM
Message-ID: <ZsbbFJpCY9BhroY8@infradead.org>
References: <20240822050328.GS6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822050328.GS6082@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 21, 2024 at 10:03:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't bother reporting the number of bytes that we "trimmed" because the
> underlying storage isn't required to do anything(!) and failed discard
> IOs aren't reported to the caller anyway.  It's not like userspace can
> use the reported value for anything useful like adjusting the offset
> parameter of the next call, and it's not like anyone ever wrote a
> manpage about FITRIM's out parameters.

Look good and fixes the reporting issues I've seen:

Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>

