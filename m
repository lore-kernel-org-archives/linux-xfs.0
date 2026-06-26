Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B7B3AE6F3;
	Fri, 26 Jun 2026 06:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782454833; cv=none; b=uKMT7tyyzsK7AmgIdI+rUqw8CkNlYplLP8ujbXSYyuwKQTgRfZRZ18BJhLoZLU66F3ifmhH4FAqroyXWVLLzLWvhFoISUbmW/fBQcuS92BlQjh6uJT6Z8+asqeEJMPNTND/IgrPz3rJhKzfD0DOyGkLaSYqWcbEUiyXOm4yTuh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782454833; c=relaxed/simple;
	bh=43ve7jHLzO9bDCex13r9R5HoqCsOvjxeeQp99NENhws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CA3GbQsYRld3EiDNqeblN9Xh4PCznYiNXAmbeJh8spO5bcoJJT+zidDk9mMjxUqSTvS1lXCxgkRdJKOZO64LUAxIrlyHgD0UsqtfLgbhgPCpiQrY/7bgXcP4qJGcj4DyuHsIEZFiANogMfKpU8YCLdrQ67Y6cvOGaYnzJtGZx5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WU/L1yfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WU/L1yfE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B55691F000E9;
	Fri, 26 Jun 2026 06:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782454831;
	bh=oXt3TI3KYVr+qcWdZITB8qJGMGwNWpZ94QcTDSJRm/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WU/L1yfEC2pGmaOfTfMjPKOjwaMy0wyqdhnFLjCOILvjO2REFqtZVx96g76tlKyUe
	 YcEVbk80irMUnaISGeH+dezCvaCemGir7VhLVow6Wq8lTBAeQiOq9/62OGD+8upClT
	 tlNeTpLiRSS5oxeCR/AnFOw0Ymd4DcP898QGin6SjmjjQUk6KUiyRydTSUqDw0Jf7S
	 JMVYe8xMPkJFaxtJ5xdEkA6oy3hB59HQfI2xBlGv+Pg4NwqBhOZ33N8zX1c1d3TiZ+
	 uMOMt8d3gN3nuMZBCvKoV69Knv8A9LV18xmyXIsSCdYBUUoqyD0osWt98ZI9jGevfj
	 4klA4fkf4VUpg==
Date: Thu, 25 Jun 2026 23:20:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260626062031.GO6078@frogsfrogsfrogs>
References: <20260625120803.2462291-1-hch@lst.de>
 <20260625120803.2462291-3-hch@lst.de>
 <20260625174758.GE6078@frogsfrogsfrogs>
 <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com>
 <20260626043319.GC8078@lst.de>
 <20260626061637.GA10337@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626061637.GA10337@lst.de>

On Fri, Jun 26, 2026 at 08:16:37AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 26, 2026 at 06:33:19AM +0200, Christoph Hellwig wrote:
> > On Thu, Jun 25, 2026 at 11:32:40AM -0700, Joanne Koong wrote:
> > > Yes, that works. I think that's a good idea. fuse only needs
> > > submit_read logic for readahead. The change would just be:
> > 
> > A nice, I'll fold that in.
> 
> Btw, can I get a signoff from you for this?  It looks like splitting
> this into a separate patch actually works better.  If you have a
> preferred commit log I'd take that as well instead of mine.
> 
> This is what I'm currently testing:
> 
> https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/iomap-read-submit-bio

For both of the patches at the end of the branch,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

