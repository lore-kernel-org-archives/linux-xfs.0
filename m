Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38232E743;
	Mon, 26 Jan 2026 11:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769428117; cv=none; b=lQmvDTcWEVhRm21kiXuAXYKF6UqpFYknDc8CZd7qgIAny/P0BNCDTWfzag8TMRQK+g98wbOWWaRFLU1UkOGKUfeHzGaoFJAalTQ4v6S1DcsmRTuTVsHVlasqeK1fQuN8BM41eyCk/8yyojKHP9jMfQk8eV4H1bKEPF+BdMZBC74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769428117; c=relaxed/simple;
	bh=Hv8PLo/XZN7+ToF8xlqSWcXxwVmhYxoiNZFUek0J+v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guVeF4e42vdJfXjfMvqvecc87mQKIc7yv0ZNK4q15jJjrOJNPEe1CvpCB5/ZXgm/RTtm/0M1xSVJUP82PhqOdE+9xAUeRnrV4BnL1KdorChkrJezVGnlq3E8o+i2vdc32ZH9bxI+jP/Rv6srbZzf527J6F3M9sr084fEQld6NPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 837A76732A; Mon, 26 Jan 2026 12:48:31 +0100 (CET)
Date: Mon, 26 Jan 2026 12:48:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/15] iov_iter: extract a iov_iter_extract_bvecs
 helper from bio code
Message-ID: <20260126114830.GA23617@lst.de>
References: <20260126055406.1421026-1-hch@lst.de> <20260126055406.1421026-5-hch@lst.de> <c8ec9ff0-a445-49d1-8b84-6b0ed39c9b92@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8ec9ff0-a445-49d1-8b84-6b0ed39c9b92@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 26, 2026 at 03:27:16PM +0900, Damien Le Moal wrote:
> On 1/26/26 2:53 PM, Christoph Hellwig wrote:
> > Massage __bio_iov_iter_get_pages so that it doesn't need the bio, and
> > move it to lib/iov_iter.c so that it can be used by block code for
> > other things than filling a bio and by other subsystems like netfs.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> 
> > +ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv,
> > +		size_t max_size, unsigned short *nr_vecs,
> > +		unsigned short max_vecs, iov_iter_extraction_t extraction_flags)
> > +{
> > +	unsigned short entries_left = max_vecs - *nr_vecs;
> 
> Do we need to check that *nrvecs > 0 && *nrvecs < max_vecs ?
> Also, if *nr_vecs == max_vecs, we should warn and return 0, no ?

*nr_vecs = 0 is fine, and in fact the most common case.

We could add a protection for *nrvecs < max_vecs, but this is a very
low-level API, so we should be able to expect some sanity from the
users.  Especially as it will blow up instantly, including with KASAN
splats.

