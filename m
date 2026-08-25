Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A46435C181;
	Tue, 25 Aug 2026 06:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787640940; cv=none; b=DMU/GLyyqTFVD5SavIem6ivAbzOqnU2ABSSLRt0DzhfQx4ZV7Aw7h1tVuWZgv+UHkde4q96YtN/m6Ynv3bMrO2FdBYAPmniJv6Nong5FeYIwL23eITzuhEvWYw1bTSVN3Du9gLAXyak4ZN2PKzpi7t/8a6AH7+4pfq0F2d/lkEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787640940; c=relaxed/simple;
	bh=Wp+fW0WLfe2reGoS9k9krqcDiOExdVxZfuJv2Z8/RVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXNZRvCJlKf8Wg3FdDfGgnwJMTL1IJYnlLC8sIfye48y5KUGORUo+unhjdFUi5FazB0e3DMHjxm7xdswvMCps29JnPEy9y+vvfABxd5Fs5aa5PhLMrMDVUUsdsrXNUZHDqO2Zksa2MQbWSTZOOgFtlqMbvlXKqdEwDrqS7cANqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0F10868BFE; Tue, 25 Aug 2026 08:55:34 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:55:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	brauner@kernel.org, dgc@kernel.org, jack@suse.cz, cem@kernel.org,
	axboe@kernel.dk, kbusch@kernel.org, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
Message-ID: <20260825065533.GA24808@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com> <20260717125538.508925-2-joshi.k@samsung.com> <20260721030338.GU7380@frogsfrogsfrogs> <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com> <20260819070814.GB1541@lst.de> <076db8e7-6c6e-4d91-b442-1471ad7a5c27@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <076db8e7-6c6e-4d91-b442-1471ad7a5c27@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 12:00:46PM +0530, Kanchan Joshi wrote:
> >> - That stream/fd will be unavailable if some other application has
> >> already opened it.
> >> - If applications gets the stream fd, it can use that to set stream id
> >> for multiple files.
> >> - It can close the stream-fd and that does not change anything for the
> >> file resource (i.e, its inode continue to carry the stream-id value that
> >> was set).
> >>
> >> Christoph - does this match?
> > 
> > Almost.  I didn't really think of your last point there.  If the
> > inodes keeps using it when it is dropped that breaks the model a
> > bit, but revoking it might make things a bit ugly and slow.  Urgg.
> 
> I think it is consistent to the model that says stream fd is a distinct 
> resource and it is a necessary lease/license to set the particular 
> stream(-id) across files.
> If the stream-fd is held, that stream-id remains exclusive to the 
> application.
> Closing means, applications is fine to release the license and 
> underlying stream-id becomes available to other users.

But that also means it can be reallocated to other users, which
now mix data.  I guess the answer might be "don't do this", but
I'd love to have interfaces that aren't easy to abuse.  OTOH
implementing this might be quite an overhead.

> >> 4. FS_IOC_QUERY_FILE_WRITE_STREAM_ID		_IOR('f', 138, __u32)
> >>
> >> Queries the write-stream value (__u32) currently assigned to the file
> >> (its inode).
> > 
> > I'm not sure exposing the actual ID to the user space application is a
> > that good idea, 
> 
> But don't we need a way to know if stream id/value is set on a file or 
> not? This ioctl is more about observability; GET equivalent of SET.
> Also write stream value is not going to be there if/when in-core inode 
> gets evicted.

Yes, but the application needs to basically set it after open
anyway.  Keeping any kind of state over a file descriptor that
has been closed doesn't make much sense.

> > same for passing in the wanted ID when allocating.
> 
> Can drop OPEN_EXACT flag if you prefer that.
> But this was for the case if application restarted and wanted its new 
> data to go into the bucket where it was previously writing.

But that assumes that the bucket hasn't otherwise been reused, which
might not be the case.

> > That leaks a lot of internal details.
> 
> I viewed stream-id similar to how we view file-name. Application can 
> list file names, but need the fd to do operations on that file.
> So, I could not understand internal details part. Could you explain? We 
> have FIEMAP and unprivileged XFS_IOC_FSGEOMETRY already expose the 
> placement of the file.

There are a lot of operations on filenames.. XFS_IOC_FSGEOMETRY and
are in a different register than normal file operations.  If we
want to expose the mapped stream IDs I'd also rather have them in
a different register than the usual APIs.
