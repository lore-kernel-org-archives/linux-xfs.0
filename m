Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250B740858
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709143663; cv=none; b=DZoYhhcKNgGHsXG3RSnD1Sh8kwEfyvdzWDL7GGl437JXA/M/t2aHKNpU9ewWWedcjGWKsILf8t7RQS56jD/hDiau3i6yaIeyxyWgZiV4FdlN07HneuwRk0QUycPjks4PZu2mox7Oj4oq9XTuuEuz1JryMPFG7w4+UiRPjCSHLbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709143663; c=relaxed/simple;
	bh=DLoeU2ZrguqM/mRBYV4SA1ZdCIH4LokRDgadr5VMNvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ECON6FmrOEi35GAmMfuH98dWiFudmQP2GWKvlDVK6/vVMI8+i2cnM0QcF/JEUqrw0il7S+xYnE1C2inVwN8HKLkoDsoEZ9dQuv+NxuGxIaDFLYFpV7YbQdRG+VImG4dYUGCgy3IuAj2B7tzqIPewrqkTmLMmkrRKJSbrWR5Cjlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxYKg1RM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxYKg1RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ADEC433F1;
	Wed, 28 Feb 2024 18:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709143662;
	bh=DLoeU2ZrguqM/mRBYV4SA1ZdCIH4LokRDgadr5VMNvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dxYKg1RMCwdkouQ6jgkI765qaW1zWYWeOKImhenpmROsyyzWPHX7ABnvZXJ3KVtOx
	 DyShO0pUT4HhY2nLJn6F8VyY2TuWvOayHTTfsW2mo6i8vhd6Wzsttmqx6PyLAp3/eY
	 QbxnsLbDBdoBDEVFHK9XYOlMbpcyTlFOSS5M/+Kpf587DNpHPNMccIbzazTImFKnBp
	 k1ZRR9zVEElaeolsne9B1SZ+SkR0qzYC7rvbd6+W1gWq/J5DhdWUURepTaQZIoAXIV
	 IYKi5N71t7lO3Vf75WjtulCeALwUNhYS6DnFCbMwFy9bcCajNrfKI/gXoXqbyAX8sa
	 HX8//ZcqYIxCg==
Date: Wed, 28 Feb 2024 10:07:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/6] xfs: create an xattr iteration function for scrub
Message-ID: <20240228180741.GL1927156@frogsfrogsfrogs>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
 <170900013728.939212.1549856082347244818.stgit@frogsfrogsfrogs>
 <Zd9pLkEZUrmuizXW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9pLkEZUrmuizXW@infradead.org>

On Wed, Feb 28, 2024 at 09:11:10AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 26, 2024 at 06:30:14PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a streamlined function to walk a file's xattrs, without all the
> > cursor management stuff in the regular listxattr.
> 
> So given that the Linux xattr interface doesn't have cursors

Which IMO is a deficiency that really ought to be rectified.  It's also
totally stupid that it returns E2BIG if the fs returned a list longer
than 64k even if the caller passed in a sufficiently large buffer.

>                                                              and they
> are only around for the XFS listattr by handle interface, why can't
> the normal listxattr syscall also use this cursors-less variant,
> which probably more efficient?  (assuming it is, maybe a little more
> explanation on why you've added this variant would be useful).

It's slightly more efficient since we don't have to keep the
xfs_attr_list_context updated or pay the initial "resynch" cost.  The
context itself is zero-initialized, so it'll pointlessly walk the leaf
entry array after loading the buffer.

The scrub listxattr implementation has the extra overhead of creating a
dabno bitmap while it walks multi-block attr structures so that it can't
get locked in a cycle.  xdabitmap_set can allocate memory for bitmap
records, which we might not want for code that userspace calls.

Another difficulty in porting xfs_vn_listxattr to use this is that we'd
have to hoist both this and xdabitmap out of scrub.

> No need to hold this series for optimizing regular listxattr, just
> thinking out loud here.

<nod> I guess we could share, but if I were to spend time on fixing
listxattr I'd rather upgrade the interface to use a cursor and gain the
ability to return more than 64k of names.

--D
