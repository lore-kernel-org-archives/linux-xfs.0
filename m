Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8352D8371
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756227451; cv=none; b=XeOZNHCNkVKFLhz1e0MiyV2L2T+eLWYv+uZvoPVtXPh0xWE3Fxpx0m9CqmvGHEE4WuGLa9adyaM5ddIyKkzflmyAabp4dl7SYcSl9mRRWkb43ocJEvRZ1MpgcQl335GxIOuagp7Atj1Rawa3IE50GFJQX4bcJhwlw7EybINL1GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756227451; c=relaxed/simple;
	bh=jKTBXGMPXt0A/iFsjplgW+IX6UA5YkvqlQOQIKjIqv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHyFaZ23jqrro8dP+xcqPhf4l9j+oNifk/ku4pa+BavfsSaXingy5L/+BeRYunAGnyVHLrKVlmKQZdrAm0/wtMrn+XyBqRufi52m7uP7iAOycajXzPn2XOm0Q4ofUHHvPOIOZijYMhHJC+wzBzgT+kdIPlCKDYLvd09x9DJkpVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rnM8Ui2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rnM8Ui2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC12AC4CEF1;
	Tue, 26 Aug 2025 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756227451;
	bh=jKTBXGMPXt0A/iFsjplgW+IX6UA5YkvqlQOQIKjIqv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rnM8Ui2nGxlsIm8HHQADjqQL/+TUdQA09FsabWP92AS5pczD7Y2h8XuXDi1z9PM8b
	 b29BQiHmbcGq37mQ+cHepM4ZdMC4I4iyrIuNEetlHB/tEDz5cms5R01zkzKwmI6ldG
	 bJJKGmvwy26qerZeDl+0HHHJzZyelxpJ1Z43VZV2kdrsE3oVxYhwO8dZYqnQavCAJE
	 EpAmQ3++GH/l+HEpYYDnRiL7XHYMs9U2ZG1SGoq2tYmpWqIfTAHMc9s2h40xZdsT7o
	 2e6yMU9U4+CqdYLxIxacv/UHjimMRCbEt36gqDLc+q7Y6XJR0nPrCoVDFzT+9Dik04
	 W0BXWjQil8X1Q==
Date: Tue, 26 Aug 2025 10:57:28 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Message-ID: <aK3neNcY1vA9lubz@kbusch-mbp>
References: <20250825111510.457731-1-hch@lst.de>
 <20250825152936.GB812310@frogsfrogsfrogs>
 <20250826131447.GA527@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826131447.GA527@lst.de>

On Tue, Aug 26, 2025 at 03:14:47PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 25, 2025 at 08:29:36AM -0700, Darrick J. Wong wrote:
> > > -		if (xfs_is_cow_inode(ip))
> > > -			da.d_miniosz = xfs_inode_alloc_unitsize(ip);
> > > -		else
> > > -			da.d_miniosz = target->bt_logical_sectorsize;
> > > +		da.d_mem = roundup(st.dio_mem_align, sizeof(void *));
> > 
> > ...though one thing I /do/ wonder is whether this roundup() should be in
> > the vfs statx code?  Do people need to be able to initiate directio with
> > buffers that are not aligned even to pointer size?
> 
> I've added Keith to Cc who is on a quest to reduce alignment requirement
> as much as possible to add some input.  But as the new statx interface
> never had it, adding it now seems off.  Also dword (4 byte) alignment
> is pretty common in all kinds of storage specifications, so being able
> to support this for things running on top of file systems seems like
> a good idea in general.

Yeah, dword dma support is so common in part because that's the
granularity of PCIe TLP lengths.

Not sure what to say about this patch right now, but it triggered
a thought: if I can successfully get filesystem and block layers to
tolerate the hardware's minimum alignments, how is user space to know
it's allowed to send IO aligned to it? The existing statx dio fields
just refer to address alignments, but lengths are still assumed to be
block sized.
