Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3611F3BB54
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 05:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736918817; cv=none; b=bkZuC78yRPpst0qUSsO9gDpVosJFN5ZF8I0H0Dz9PxAwYQR2M4tPSYQtTA6T6UJJ6QKT0epGOvjyfqJns5mQERbkhtPPWguocn9IkmgXI+HV0mF1gHsQB1adFY4UkhaaeH2EyoXoyYYQmB3/HEj1/SHatRveHDznvBtWMtxfZgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736918817; c=relaxed/simple;
	bh=SamHc4m/6M8Bvc037zqqTssj+wig71+9TA8S+7i54Qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4sHz21f3qbxIZItt57bIEmAu1TliQk9oTK4Qowv1i1XZlr36TVKuq4WE2hygrQuGqlwi45KdcdoJVAJML0Y7kOt7vnTdVW9WhoOicmI/Fn402DpHvqvrbJ1bx3t5jqtiDweSSIhjCveuoSlrKHb6oeNe12l28Vp/kdxToxYw2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQ5hX5pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQ5hX5pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98360C4CEDF;
	Wed, 15 Jan 2025 05:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736918816;
	bh=SamHc4m/6M8Bvc037zqqTssj+wig71+9TA8S+7i54Qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gQ5hX5prQcRxYmgEb9xiSQxu5z3Vw2fwpuUGY5diwyYdcSf8sf1Qdtu9Dk5kQe7Bj
	 NpBY4wtDYRbA222RhYpfu83ogyvNb/tJlXLXdp5IcQLyBTBFcv1tNNHN+E/8zoOfqo
	 2ne6r3H5OtC7X2xSMSf+3Gzk5PsEsf6mc56aV7jIlcq7yVdPCbLp1MSHHpqfmaHPLy
	 YAG3YIz6LfwND4erOpBg8U2KZaT/j1Npdt1Atfrz/Real8YDmeXC2x9khIVrhNEBah
	 jlswNOJN2mLK8f8MzyZ9GQLW191odv5DMV/adrde98sNx6K6DeBuPj4BZHneiHeutM
	 bEpJLkvpSdHCg==
Date: Tue, 14 Jan 2025 21:26:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] build: initialize stack variables to zero by default
Message-ID: <20250115052656.GB3566461@frogsfrogsfrogs>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
 <173689081941.3476119.6143322419702468919.stgit@frogsfrogsfrogs>
 <20250115052155.GD28609@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115052155.GD28609@lst.de>

On Wed, Jan 15, 2025 at 06:21:55AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 14, 2025 at 01:41:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Newer versions of gcc and clang can include the ability to zero stack
> > variables by default.  Let's enable it so that we (a) reduce the risk of
> > writing stack contents to disk somewhere and (b) try to reduce
> > unpredictable program behavior based on random stack contents.  The
> > kernel added this 6 years ago, so I think it's mature enough for
> > xfsprogs.
> 
> Hmm, this tends to paper of bugs quite badly.  But I guess we'd better
> paper over bugs in the same way as the kernel code.

Yeah, I've been thinking about this one for a couple of weeks -- yeah,
it does paper over uninit variable bugs, but since the kernel does it
we had better do that too if we want to keep porting random kernel code
to support libxfs. :/

> Reluctantly-Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for reviewing!

--D
