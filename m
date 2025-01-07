Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE2518641
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736230023; cv=none; b=lmgTWC3MJZW/vmWldWXG7zUAhoxWabFesZ6zmQ/1Hw6tDXCKv3Ay+wwyO8R1arwW86dXZuRuCuh37HV/b1dpYrTw6uKEddIYRpMYXUkMuzoY6bL7ypvbIRKZ+G7bjEA0dw/QoIc6S1khQVhd8c6WMb67F9ezd+L5gR9tbv7B/eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736230023; c=relaxed/simple;
	bh=FfUe8CeNMCbT4taIRO5IuVA2THHlLIKnK5ruPKUsUeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGOV/xUxEpzYOBlIr5QiiHFFH0ou36vNSl51mn2RgMvUvWK4hP5IEcef3aLfF+arPb6BmIkLdwWnyPdY+UomKqkKAlCP7a+GcXOPtw9QuwRJedT7Q7YoKev9tMfZ2J7IpM7gleLdnr4uyPrw2dceYpOqM2gARTs/KW7qgw0MFSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 523B067373; Tue,  7 Jan 2025 07:06:57 +0100 (CET)
Date: Tue, 7 Jan 2025 07:06:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: simplify xfs_buf_delwri_pushbuf
Message-ID: <20250107060656.GC13669@lst.de>
References: <20250106095613.847700-1-hch@lst.de> <20250106095613.847700-6-hch@lst.de> <20250107020810.GW6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107020810.GW6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 06:08:10PM -0800, Darrick J. Wong wrote:
> > -	 * after I/O completion, reuse the original list as the wait list.
> > -	 */
> > -	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
> > +	bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC);
> > +	bp->b_flags |= XBF_WRITE;
> > +	xfs_buf_submit(bp);
> 
> Why is it ok to ignore the return value here?  Is it because the only
> error path in xfs_buf_submit is the xlog_is_shutdown case, in which case
> the buffer ioend will have been called already and the EIO will be
> returned by xfs_buf_iowait?

A very good question to be asked to the author of the original
xfs_buf_delwri_submit_buffers code that this go extracted from :)

I think you're provided answer is correct and also implies that we
should either get rid of the xfs_buf_submit return value or check it
more consistently.

