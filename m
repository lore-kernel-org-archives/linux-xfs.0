Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B298F231A26
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 07:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752375; cv=none; b=US/56WeSq6mY9a/vbVA6zpRk/05OLa3iqcT4FNvrvBcToTr3GfC0SUXWQ+OkJcDGs8MKDeZL5125XpYBCQVBhUgXYRk64ydEXP8ArmBtuPSpdBR1NM6zjrm2yDWBXhzUvkQQB8l+yrClU4h9X+TGAZfMs87NODUmCaVevcEmDdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752375; c=relaxed/simple;
	bh=wLozaj4SlbOu8BnS6Fx0NJAAN0QAbuX9qBkio9GVFks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEXcW9Dr/ol4oFa1JqIRMpwkMx9dGt4RD/aTwDMnW/r4Um59nasMmPmvP72EiwyyG4ChF/H97wWo6d0cqGlJE9Cd9PR+dxwJ5sxldarX70pMlkQLKsYQPk7TW9VQwzDTsXA75rw9zUbi8hKzcZrLkXviBYZn7UqUALKEEZq7tv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FR88nlRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FR88nlRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F0AC4CED6;
	Mon, 13 Jan 2025 07:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736752374;
	bh=wLozaj4SlbOu8BnS6Fx0NJAAN0QAbuX9qBkio9GVFks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FR88nlRJ2DnVglx2RF+83KmdLnw/2WsOKAiroq5ikbN0DEPfg+Q6Gvd3N7IvDBU4h
	 vhXpRYIShU5Z9GpOlc1qn3ux8ZN7nvcpnGhcmSC6TFDGgZ9CUoqu7HPINsJ7cmqc5M
	 t7NDuHbiqVULU9Hpp7guP2pVyJE7RhNBG4oOv3uQTlkIC/RwLJUGtC0xeRDAlSTgY7
	 0xmpKIHrvTPlm7mAi0Zyblj4IhffXySRlYeG58ClYVwqhMwTEXHXbYiuGXeNXtuKPN
	 U7JrjsIuIYk9KwuwebZobW7X8enK0fEeH09ZzsLp3JlCenweNWmENHNjWgFfEZw3gN
	 /eMN9w3Db7oqg==
Date: Sun, 12 Jan 2025 23:12:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: simplify xfs_buf_delwri_pushbuf
Message-ID: <20250113071253.GY1306365@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-6-hch@lst.de>
 <20250107020810.GW6174@frogsfrogsfrogs>
 <20250107060656.GC13669@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107060656.GC13669@lst.de>

On Tue, Jan 07, 2025 at 07:06:57AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 06:08:10PM -0800, Darrick J. Wong wrote:
> > > -	 * after I/O completion, reuse the original list as the wait list.
> > > -	 */
> > > -	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
> > > +	bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC);
> > > +	bp->b_flags |= XBF_WRITE;
> > > +	xfs_buf_submit(bp);
> > 
> > Why is it ok to ignore the return value here?  Is it because the only
> > error path in xfs_buf_submit is the xlog_is_shutdown case, in which case
> > the buffer ioend will have been called already and the EIO will be
> > returned by xfs_buf_iowait?
> 
> A very good question to be asked to the author of the original
> xfs_buf_delwri_submit_buffers code that this go extracted from :)
> 
> I think you're provided answer is correct and also implies that we
> should either get rid of the xfs_buf_submit return value or check it
> more consistently.

<nod>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

