Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792612595;
	b=yg0Ylgn0OvaRVK44Tv6NJnbZxDrzgLLt1r8OS2I/7DtFovyuZLaQlLgq+l5xe5tBS6M9
	 bM19J+60NEMvzWITzN/QpcDwUQ0y5COiuEFbmu8F0e/40ScqDuHuENfardeyleDgDVVi3
	 6/Uc7GIFj+g2Cq+21ZJvGoGKm+MW2ddZ4bwFapgnhEeiy7yOLlh3sPjEK6fSSY48nJKUV
	 GVsON2SDrqmLNC/C+BdSe5K/7tMe89ikyLh9hqaZBMBhWcMa8uP79cN05qLGm3BOJMfQP
	 cpkN6UeQoE+SzHPGt9pQ691XSsqWTOAgWVNSOQ0RydH3UALw9dKi0oAS5RFD9pcLHcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792612595;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qOAnv85W4JwFnIRgSq5H+NNM8GTJd8gUj1t3+7MUB2o=;
	b=u1/VeTD9n2X4ooHZP5D1n0RodC3nlU0bmym3DXlOoHudljA4GmXDnO7wEynWwnYyOQaU
	 LlifsGugyOY4WvqtIgBLaYQ2FhdZ/rA33byG04jbWwwjlp0/GrY4s/oW8xvWXk+lOJSWD
	 NHHNK08aKk/sgeUcBDs5iVSge3u1dIdsudH7Z13ofSQdEhQrNHeKBnJWzaQq13M0hG0Rd
	 pNdgdQyGtdWUXP17fldsbOZPlShzeBLiTrVtbxZOzHYWVd0HzJqf2tEguEGBwuu1hnX5e
	 Nk3QNQaU/veMh+ME94upVxyhUye8AcFYAgh016Kf/4HeXNobjSax53eLgACQQR8Inkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FGovYpkd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE94606A319
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FGovYpkd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C9D1F000C1;
	Wed, 21 Oct 2026 19:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612594;
	bh=qOAnv85W4JwFnIRgSq5H+NNM8GTJd8gUj1t3+7MUB2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FGovYpkdQht4kuk1l9P7zl4TqbXqM9EA5iZc3xZYpSnsPNgK9qve1aDLrQg/oTmKC
	 I+TiVpVMWAilCGMxmZCIHxsi8Bc16Rod9eHzqFwDsLp+vm/sOpOJIpBTDXBMchgvlQ
	 BRx7WVyqrjdLPSkOmxOPgYniPsVAb7SjJUgPWUdtqkjmLttGqz+rACbf1p02DmOURl
	 2jCmkyasvsh3QXsrX1ekYtE6ytPudQjzdWPqKCVw2CgagJ7jvmg7lwEUSXGI6LDRqU
	 NELAp357ql+PdXBCabN2He9zEFmV7yCfo6nD1qcdT9JOm/zyOXRMcdFXMGu5gDVqAz
	 kT5yRAlJWyURQ==
Date: Thu, 22 Oct 2026 06:56:26 +1100
From: Dave Chinner <dgc@kernel.org>
To: Akemi Yagi <toracat@elrepo.org>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, chandan.babu@oracle.com
Subject: Re: [BUG] XFS Assertion failed: lock_flags != 0 in
 xfs_file_dio_write_aligned (kernel 7.2.6+)
Message-ID: <atkY6iLboERBtgJJ@dread>
References: <CABA31Dp=R3nnFpRGLhw0T80derEGq4eQbHE9FccOUPnLK9qerQ@mail.gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABA31Dp=R3nnFpRGLhw0T80derEGq4eQbHE9FccOUPnLK9qerQ@mail.gmail.com>

On Wed, Oct 21, 2026 at 10:44:16AM -0700, Akemi Yagi wrote:
> Hi,
> 
> This bug happens on the vanilla, unmodified upstream kernel. It was
> reported to kernel.org Bugzilla (#222082) but mistakenly closed as a
> distro bug due to an ELRepo build tag.
> 
> The details reported by the original submitter can be found in the
> link to the ELRepo bug tracker.

Not actually a bug in the code. The code is suboptimali, but
functions correctly in production kernels. We will fix it, but the
real problem here is the distro kernel configuration.

i.e. The production kernel is configured with CONFIG_XFS_DEBUG=y.
That adds lots of debug checks that will crash the kernel for issues
that aren't actually bugs but indicative of potential problems
developers need to be aware of when writing new code. It
also results in lower performance and -really bad- allocation
behaviour which accelerates filesysetm age-based degradation.

Have the distro turn off CONFIG_XFS_DEBUG, and your problem will go
away, regardless of whatever we do upstream.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
