Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2BD19750B;
	Wed,  5 Feb 2025 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738770672; cv=none; b=rEEJuFB3ejREX55BQ7pi5YTy+vGUG3WBd0pwpXHclnqKeynG1701cI2y2H0Rnts6bEb9QMAUIkCkU4RnrtHguBIPL79fmC5w6/Ob9J5NvrHt7TtaSM+V7PnVs0F3/tI5fJcq1pMIZcFQpQT2XjJCW2rNeTF9M9aI4h+THg2LgKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738770672; c=relaxed/simple;
	bh=amksPL2cWtehM5y0ISMX9glIU1hO6w599r04br8VT1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyKFFhKx/ZUNf+NiHZPrT8y83LnTinZdsmBlxAXxkYA4O44ahTO5fG5wWNVY9h70uOHB9aECsXeo2+BgQz3BwnuotbkFQHhKuounnLydNPNq4VIEVOFn/ZSIRkrS5t+rRqmn5bMM2k7JlvH08Ok0wExpcb5vnLpEQ6LAe3QtJiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5T8Wa+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5T8Wa+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B7EC4CED6;
	Wed,  5 Feb 2025 15:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738770672;
	bh=amksPL2cWtehM5y0ISMX9glIU1hO6w599r04br8VT1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E5T8Wa+F8/Qo4nb2I+0VRMgivNEnsHjiOm5YXeez/PJOlzX78esLOZCcTAFfOR4GZ
	 z5Se6I6a0CwOq7/HX44qiAlI1j+CakSaHMmoQqmOudi7/HDWE3ZQk1TB5BWAX1dw4W
	 /Fw50NGd4x1a+ROjHRWBk1RECd3t1zmR535pLjcGnAAIEc2D0IQ20KCAtLrR6fZx0/
	 t/K2n3AtPCgxIXGLNm2hVPtjuWxCd5yQT3ERDztr8R3ReHCxusQ+2nl/1Y8AuJyKtP
	 8vuZzfZ8NL/u9ueyNvgBYYJOHC+Kuz6wlSp9LhgxM7fEl1BhQ3ElzI55uwixxEqaOp
	 twbtZAFkYJd8A==
Date: Wed, 5 Feb 2025 07:51:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/614: query correct direct I/O alignment
Message-ID: <20250205155111.GE21828@frogsfrogsfrogs>
References: <20250204134707.2018526-1-hch@lst.de>
 <20250204171258.GD21799@frogsfrogsfrogs>
 <20250205154422.GC13814@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205154422.GC13814@lst.de>

On Wed, Feb 05, 2025 at 04:44:22PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 04, 2025 at 09:12:58AM -0800, Darrick J. Wong wrote:
> > Hmmmm... I have a patch with a similar aim in my dev tree that
> > determines the lba size from whatever mkfs decides is the sector size:
> > 
> > # Figure out what sector size mkfs will use to format, which might be dependent
> > # upon the directio write geometry of the test filesystem.
> > loop_file=$TEST_DIR/$seq.loop
> > rm -f "$loop_file"
> > truncate -s 16M "$loop_file"
> > $MKFS_XFS_PROG -f -N "$loop_file" | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > . $tmp.mkfs
> > seqfull=$0
> > _link_out_file "lba${sectsz}"
> > 
> > What do you think of that approach?
> 
> That sound sensible.  Where is that patch, it doesn't seem to be
> in the realtime-reflink branch that I'm usually working against.

It's one of the few zoned changes I have in the fstests branch:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=zoned_2025-02-04

--D
