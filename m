Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A33F17335C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729012091; cv=none; b=shElDlohQYAhM3mchRCKVxKIoNCgPFkoD7aqNs3kofd6IfC9mgmx9fyCvOf9MME3WcXJUfaGiV8IaN0H00MaSKnAZqhOf1zOwEZLJhC9DOR4xY2fyIOTyjpABkiKBe7kZZfD/ZO01l5Xe7SeOeKIUiUIctZymG7AvKl7xrTbLwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729012091; c=relaxed/simple;
	bh=PSdXxn5m2voq2YLCgN737azhPfJWHRzFteXacGBrahg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVZv8pn3PAjV0aILQqcCEc7RfE+loF43ioOvl3xMOHmoK9MvHnmVADVNHx6nK07SiBfhy4sRb+3glDqYqjql+kDGtUauVEgk5rEYCLdkeTsfZIenLo/PKPjpBAVHbsn1m4M77tYRZc+hEcPaQAA5PePXMSOpiJ/BsxIejjx3/hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvU1XJHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvU1XJHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25779C4CEC6;
	Tue, 15 Oct 2024 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729012091;
	bh=PSdXxn5m2voq2YLCgN737azhPfJWHRzFteXacGBrahg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UvU1XJHuF0uB5EXd9gVqzWGKm7JQ8DFtebEval4PjpZufTtspehk1GpuxwljUkWE+
	 sMswAvKqflgEfnErsxo//m2sWBQKwsdDQt+vq+pxmY+joC7pgafp+yQmjwLomW/IY4
	 zmyUfwD1V66IeqrAirVu6/cYcrroey0KTZWxgdC731akJ1i1QCCJFrtaWBlxc9l3ZS
	 J/uip0fdC/2LR0C3RsORWgR6GBEpHvtmj44y6rNpMmMmqQ3cm3yB/SokSZcrWZ8bl2
	 8jM1HpHP01DzXssYCfYhw9zIaxuUFWYtJUU03nQQazjJQF3x3zP4P20xtgvC5Q4Eby
	 1rqarZOez6gYA==
Date: Tue, 15 Oct 2024 10:08:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <20241015170810.GB21853@frogsfrogsfrogs>
References: <20241011182407.GC21853@frogsfrogsfrogs>
 <Zwy0S3hyj2bCYTwg@infradead.org>
 <20241014152533.GF21853@frogsfrogsfrogs>
 <Zw35FgISfIdk1gSl@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw35FgISfIdk1gSl@infradead.org>

On Mon, Oct 14, 2024 at 10:09:42PM -0700, Christoph Hellwig wrote:
> On Mon, Oct 14, 2024 at 08:25:33AM -0700, Darrick J. Wong wrote:
> > On Sun, Oct 13, 2024 at 11:03:55PM -0700, Christoph Hellwig wrote:
> > > On Fri, Oct 11, 2024 at 11:24:07AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Check this with every kernel and userspace build, so we can drop the
> > > > nonsense in xfs/122.  Roughly drafted with:
> > > 
> > > Is ondisk.h the right file for checks on ioctl structures?  Otherwise
> > > looks good.
> > 
> > Dunno -- maybe those should go in xfs_fs.h, but I'm hesitant to ship
> > that kind of noise to every customer. :)
> 
> Yeah.  Maybe just rename xfs_ondisk.h to xfs_size_check.h?

Sounds good to me.

--D
