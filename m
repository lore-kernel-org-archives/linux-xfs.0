Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AD714AA9
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919535; cv=none; b=a9wVFMKkt5ZkGPuvaHMFNTy8chX+g/cuazbMPIlA7cnwHpNUkG2QuboE5XwQMd2dIGRc7uKk92a8ZybomIEyq6yGFEsF6Kj/DzoxRDYVPolzdqIw1fGjVQpdsUWtOb/Zaukt/Qi4TySqblo4e9VMX4YzqYoA1TS4w/UzyckNv7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919535; c=relaxed/simple;
	bh=KaF+MqFJKO7HBArj82BczM9d2atO34wNK8ojJaTQQXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrDWTq553eToU7U72nJMnq+WuiP62DiyLEd73X1YSuzkh0JuZqEwlsUpOyu8oVZfPqbH/Q8OpvCyra4NDHp0od5Z1cFDiOOS8W/IsRKxKzJZeC+QpzrGD77gzL1miAh/IgE37DG66ZSIAoLKhaWQCYsLUcLaMo2Ax6rdEtfnLcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJc/zlyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJc/zlyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859E5C4CEC3;
	Mon, 14 Oct 2024 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728919534;
	bh=KaF+MqFJKO7HBArj82BczM9d2atO34wNK8ojJaTQQXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LJc/zlyBMMw2Pqj8jaFNfjac1scU7ACKSbXHGDtkIiSGJJBXpDVs9B2APDCR5FvCo
	 r58GAT2/7uIIj9jKp4+Q1hi+5dOgYh2tJ6jPy1JzJg+94S2xUCiM6hbsvmwTKgx6SC
	 5L9LpM376DGL9qwA9kkh6uvXZuRwGvvpQfY29C5qc4QOiZ4ePhYWk5PrEbHgWMag8h
	 /cKXbdLvWaCwjkUUr1njwg7GZCfBHXvo0Y6T185pY46TTnebPer15+ejREJ9tWqZ8v
	 h+zq1kE1ubk6HpoMAr1r6BpDCeiaBYRICRb8EWox9yWqb27ccPMvFw0nXEfnGxXSh6
	 9J01o/tEwhY5Q==
Date: Mon, 14 Oct 2024 08:25:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <20241014152533.GF21853@frogsfrogsfrogs>
References: <20241011182407.GC21853@frogsfrogsfrogs>
 <Zwy0S3hyj2bCYTwg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zwy0S3hyj2bCYTwg@infradead.org>

On Sun, Oct 13, 2024 at 11:03:55PM -0700, Christoph Hellwig wrote:
> On Fri, Oct 11, 2024 at 11:24:07AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Check this with every kernel and userspace build, so we can drop the
> > nonsense in xfs/122.  Roughly drafted with:
> 
> Is ondisk.h the right file for checks on ioctl structures?  Otherwise
> looks good.

Dunno -- maybe those should go in xfs_fs.h, but I'm hesitant to ship
that kind of noise to every customer. :)

--D
