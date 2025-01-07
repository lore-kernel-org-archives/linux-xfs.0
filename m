Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D311DED4C
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736232404; cv=none; b=ZWPBr8Q6gNw9pAo6udmwojDoANz0XTJUD31fv8aJXi7zVJMcYa+GobnGgmpL+W2uSpozH1T2kGfA/9ei/iVTWesrZXZqUzxNAjJWaBFRcow2ZPespW4zXFJR8p+2hNR6Exbt/wEbWwkFvTwb2ZAtXA8PJBoNMQAMwNybGLsAANk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736232404; c=relaxed/simple;
	bh=uqZNJkwHcblnXB324N1avTDN19A20xzQQKDQ2bUoAeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+PiEhx3vFxAVhhmQ6vDyMNkg3bbsr6awNQWvOTGr5oa9oh+7MXJG0a8n5TZXKnQQyswiViCHquVQ3UNqb4sG9Pkn2Xn0t3FkVE+w7NlP7obRLLiZKdBP/SwiZl7JFGKJdAfk46ZIgBFyZ3s/Yg25fvVynfyaGCd4H1j8pKKmYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2255A67373; Tue,  7 Jan 2025 07:46:38 +0100 (CET)
Date: Tue, 7 Jan 2025 07:46:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/15] xfs: simplify buffer I/O submission
Message-ID: <20250107064637.GA14460@lst.de>
References: <20250106095613.847700-1-hch@lst.de> <20250106095613.847700-10-hch@lst.de> <20250107064224.GA6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107064224.GA6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 10:42:24PM -0800, Darrick J. Wong wrote:
> So I guess b_io_remaining was the count of in-flight bios?

Yes.  Plus a bias of 1 for the submitting context so that the
completion isn't run until all bios are submitted.

> And making a
> chain of bios basically just moves all that to the bio layer, so all
> xfs_buf needs to know is whether or not a bio is in progress, right?

Yes.

> Eerrugh, I spent quite a while trying to wrap my head around the old
> code when I was writing the in-memory xfs_buf support.  This is much
> less weird to look at...
> 
> > +	for (map = 0; map < bp->b_map_count - 1; map++) {
> 
> ...but why isn't this "map < bp->b_map_count"?

Because the final ("main") bio is submitted outside the loop as the
loop body chains the ones before to it.  I guess this should go into
a comment to confuse the readers a little less.

