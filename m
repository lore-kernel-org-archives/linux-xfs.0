Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5F317C21E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734110034; cv=none; b=aJkGLPlKcGgJxwGEpOB7Ne7e08xYRzGSH7+5nkSIVdDZgCbNb88n+24UCwC+jFm8QXVTabfW/E606KKGsuoWkT9fNtCSfdgMXaleDmDWy0qXA0jU/85mdP43NYF3XOTyO/Rz7PHSRgXx/RfLCi0Lf8WOdVHSXHwgZTqwZ2bA0+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734110034; c=relaxed/simple;
	bh=X1hjV9ROfDThyjRiXKW8odyPLecIL6rzXclpEK4+tkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXuTMcIsTul/mH6UK6iEPiwFyt1fljtLXYu3jhu7qK2ahyXNKjc+meEWsFH6gZPmOBc6SkpamMZz41Wq1ZMO1rkmBsPSSSDadw7DjnnaUB8OytW9WVXmxVp8WCKNCjR/FlzszWdtfxqF1fRxaKUQew1g8A6FDEbawypsJSn9Dbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N33cHABX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N33cHABX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998D4C4CED0;
	Fri, 13 Dec 2024 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734110033;
	bh=X1hjV9ROfDThyjRiXKW8odyPLecIL6rzXclpEK4+tkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N33cHABXQunznWxkcFoQSsfFoCjeUSHhlfhyaHbDeuS1cx06tgv5cDox5ZLnsszYK
	 hOxuyNqzNVRe/CThRy6QMWaFDJPvbPkVdV9rZL0fKqLm9enojz684PgxOc5BdK3ZQ5
	 wmTqhK9BQQtNa7MbH7J1B+nv1O4pIbLdWTiEwE6Wc+xFmsI441V9g9aH7CZDGoIr80
	 //tUBfGHSTNi8H7jP8war66ITZYmBRN6ofG5CeeS+fl9cf9Rb2YUqHEE7YPE8p8iPe
	 HpaVUBFUxP+9gHcrNdpwVrbqRTdFJQ8Zk2nZ+JbG4sp7cwKrFFbKDLdc+bubaSrHo4
	 tzI953t0j6TpA==
Date: Fri, 13 Dec 2024 09:13:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/43] xfs: don't call xfs_can_free_eofblocks from
 ->release for zoned inodes
Message-ID: <20241213171353.GL6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-22-hch@lst.de>
 <20241212221523.GF6678@frogsfrogsfrogs>
 <20241213052841.GN5630@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213052841.GN5630@lst.de>

On Fri, Dec 13, 2024 at 06:28:41AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 02:15:23PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 11, 2024 at 09:54:46AM +0100, Christoph Hellwig wrote:
> > > Zoned file systems require out of place writes and thus can't support
> > > post-EOF speculative preallocations.  Avoid the pointless ilock critical
> > > section to find out that none can be freed.
> > 
> > I wonder if this is true of alwayscow inodes in general, not just zoned
> > inodes?
> 
> Maybe I'm missing something, but AFAICS always_cow still generates
> preallocations in xfs_buffered_write_iomap_begin.  It probably shouldn't.

For non-zoned alwayscow I think it's trying to generate preallocations
in the cow fork to reduce fragmentation of the bmbt since we don't have
to write in the linear order.

Unless... you're talking about preallocations in the data fork?

> Btw, the always_cow code as intended as the common support code for
> zoned and atomic msync style atomic writes, which always require hard
> out of place writes.  It turns out it doesn't actually do that right
> now (see the bounce buffering patch reviewed earlier), which makes it
> a bit of an oddball.  I'd personally love to kill it once the zoned
> code lands, as just running the zoned mode on a regular device actually
> gives you a good way to test always out of place write semantics,
> which ended up diverging a bit from the earlier version after it hit
> the hard reality of hardware actually enforcing out of place writes.

Which patch is the bounce buffering patch?

/me hands himself another cup of coffee

--D
