Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD751D1726
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732040316; cv=none; b=KI9gW7+AnD1MuKfkEwbE+BQjyoXNuQKqpYuwmPQUHKwWYGOw7XK+9Rx2CnUhlz/PEBh4u7Kp72exuON6ViMnDNKCShDGhvWgDsA9fmNWdAQThOHmbgG0m8jY8gd392/X0OgDXVMujaxZ1oaaGNh46Su1HtzAVaDumlUG/TNKSlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732040316; c=relaxed/simple;
	bh=NMdnR9cLo3Pq2DTPPA4o/nnEZUR675BHQiC6nxA0e4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gAmcnjIzR13kXNYiBELBGIlkFvOWUEjv++w9fOfVZTDSUmFdb0Lf8tt2Ug+wWhURoGRKcSm2OQX5LrKHFaGRzVVh664pxZLqWctArw4Z2tkSVBNcPUxwB59Nt96TqojVdbRWDvc4ApF1RhJKsohfZFhzqz3VTGN9Y6l45wCwnjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qwfmfw5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qwfmfw5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8C5C4CED0;
	Tue, 19 Nov 2024 18:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732040315;
	bh=NMdnR9cLo3Pq2DTPPA4o/nnEZUR675BHQiC6nxA0e4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qwfmfw5BCEXzaXL5og8NdwTGGaUm1thZcs5zc+R+G/tj1R8cO6l2a6KnIem/Vh3Xn
	 +i9k4DMeO7pkdKMYG43cXuJMAl9au5+2GlWurrDWz/2Vp7DVbVkKvydtN6KVs1d+0p
	 UxAZquKyzqZ53KOlnJRy2dm4SdJYOa0XYxbiQBw5L9fsry0RukRTfSFgnN73dj94OX
	 y5yAlaNeZeEafwzTKL5Ol5XlIMUr/Q2Rpsu1t9vMaoCEwdUNQaJk43WHTqAVjmathD
	 3Pq3rHQTODybJ0euPTuuoRbFPyTNliKxINpl29JibTB5U91yXmb0SmURaj2a2phIe7
	 WCmDLjQvke00Q==
Date: Tue, 19 Nov 2024 10:18:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: keep quota directory inode loaded
Message-ID: <20241119181834.GA9438@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084464.911325.18182055244953182778.stgit@frogsfrogsfrogs>
 <ZzwmAevNy-Tcl9R0@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzwmAevNy-Tcl9R0@infradead.org>

On Mon, Nov 18, 2024 at 09:45:37PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 18, 2024 at 03:05:17PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In the same vein as the previous patch, there's no point in the metapath
> > scrub setup function doing a lookup on the quota metadir just so it can
> > validate that lookups work correctly.  Instead, retain the quota
> > directory inode in memory so that we can check this.
> 
> The commit log here feels a bit sloppy - it keeps the quotadir inode
> in memory for the entire life time of the file system, and not just
> the scrub as the above implicitly would imply to me.  Maybe clarify
> this a bit?

Ok, how about:

"In the same vein as the previous patch, there's no point in the
metapath scrub setup function doing a lookup on the quota metadir just
so it can validate that lookups work correctly.  Instead, retain the
quota directory inode in memory for the lifetime of the mount so that we
can check this meaningfully."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
