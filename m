Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13721287505
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762380812; cv=none; b=V8z2Zt+9RX/H8R9i5arTGc42806KBA0p2efdmbHQyEs3yUB2RtfYzOVQAeIWc9Zz97/BGgj6A6VXXYFSNMmFrqgjaGQdxyP1/HpEbakm7vzciMpqYIz+7rzZlvZJUEdscUnZuRFmKc6M21zw9zt3T949JM30M6WK3eHuYq3ueIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762380812; c=relaxed/simple;
	bh=R8VnyiP1LMPZKAjMMT5M/OFK27GfbpUtb63JOhbFmQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eSe6j+qFuEYRLL7KIICeq+yn4HyYsSBZgAy2+O/T+uwvLL4x4nPVPOpBZxrfS9tDnnLfWPk0xeDym6Kvf1K8nOYBZ8UV3MJBSg33gciu5pK/hmTxkffwiMfjo6TJsVHOYOp6Acki/+CaHX2EcCXfBNjVE1Dw5C9ahKMFnm3K2sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxcWkdYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxcWkdYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99355C4CEFB;
	Wed,  5 Nov 2025 22:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762380811;
	bh=R8VnyiP1LMPZKAjMMT5M/OFK27GfbpUtb63JOhbFmQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JxcWkdYA+mreMO6C/R2g1IjGw9ezQxIhxk2UpS7OmRtM+hVeLwwxoZrZIU6GLLZiR
	 tfhTF5njPkltyZ4KCtmW0mBluh1TuwoNBYGOyWmeHut1rk7HlLwt3/elHXQCBkHn9E
	 NJnXn/nWdWXvUWAysVEsp9SeEFtDx23bJ8VLdrxibz6qNoOaenUfwhYhL0Xkexm+YZ
	 LiNGp4+Pm/GsimmZIh2k8/pbe9c5QkPJLjc2Y9go+StdLq9nn3FPUe5Bsi63UdI0Cw
	 RqMdOjBQOah7L6wlvXQZ+6tVphJEqyJc0q8iI4PaZsko09QBMQ/5Pwl5T7uDQSvYt3
	 3X/KFz9b2A5iA==
Date: Wed, 5 Nov 2025 14:13:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: set lv_bytes in xlog_write_one_vec
Message-ID: <20251105221330.GF196370@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-3-hch@lst.de>
 <20251101000409.GR3356773@frogsfrogsfrogs>
 <20251103104318.GA9158@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103104318.GA9158@lst.de>

On Mon, Nov 03, 2025 at 11:43:19AM +0100, Christoph Hellwig wrote:
> On Fri, Oct 31, 2025 at 05:04:09PM -0700, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index ed83a0e3578e..382c55f4d8d2 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -858,14 +858,15 @@ xlog_write_one_vec(
> > >  	struct xfs_log_vec	lv = {
> > >  		.lv_niovecs	= 1,
> > >  		.lv_iovecp	= reg,
> > > +		.lv_bytes	= reg->i_len,
> > 
> > I'm surprised that nothing's noticed the zero lv_bytes, but I guess
> > unmount and commit record writes have always wanted a full write anyway?
> > 
> > Question: if lv_bytes is no longer zero, can this fall into the
> > xlog_write_partial branch?
> 
> The unmount format is smaller than an opheader, so we won't split it
> because of that, but unless I'm misreading things it could fix a bug
> where we'd not get a new iclog when needed for it otherwise?

Yes, I think you're right about that.  Currently we always call
xlog_write_full on the unmount record, and there's no check that
write_len <= *bytes_left so I guess we just memcpy off the end of the
buffer IF it happens to be the case that the current iclog has exactly
enough space for the unmount ophdr but not the xfs_unmount_log_format.
In that case you'd get the ophdr at the end of the log, but not the
"Un".

Maybe this needs to get turned into a proper bug fix?  Though you'd
think we'd have heard about this by now if it were a real occurrence.
OTOH some people might just xfs_repair -L and get away with it.

> The commit record is just an an opheader without any payload, so there
> is no way to even split it in theory.

Agreed.

--D
