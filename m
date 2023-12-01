Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF195953F
	for <linux-xfs@vger.kernel.org>; Fri,  1 Dec 2023 02:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luhepQok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AC9C433C9;
	Fri,  1 Dec 2023 02:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701396419;
	bh=Pns7hUPYVecepWmxyZMsgTbQJOR7a67uaXv/VL/mykA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=luhepQokiVXUL7G43Uwt9YXq9rKL+w2Z1RXxWhKBACkD/0L9bj3+NzhLv/zwNsWK+
	 1+B02vV8ceSoyw06kGIN6KBeo17cR2ZCNqR3duhmhBnOFOwSiUCZA5rD97vnoIy+m4
	 JlVZKKMpNSVCs+pNiJL6tqs5ZjK9/XDvcPsN+1FKWjCCckHRji8ZV4m+nkeypRzC6w
	 4caaxpxEn/EWViJKLBBeIA6dflxyhIfYnM6YBJm5QmaW8HWhG64gv8S83JhK2HXwF8
	 kyZqyIW0Ko1EnfEULjcE64VEavRyfNX4RSFSHrO56t4fShg83UnxxZPQiVBmyKZoQo
	 /02Amx3g0ps6Q==
Date: Thu, 30 Nov 2023 18:06:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] libxfs: check the size of on-disk data structures
Message-ID: <20231201020658.GU361584@frogsfrogsfrogs>
References: <20231108163316.493089-1-hch@lst.de>
 <20231109195233.GH1205143@frogsfrogsfrogs>
 <20231110050846.GA24953@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110050846.GA24953@lst.de>

On Fri, Nov 10, 2023 at 06:08:46AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 09, 2023 at 11:52:33AM -0800, Darrick J. Wong wrote:
> > > +#ifndef BUILD_BUG_ON_MSG
> > > +#define BUILD_BUG_ON_MSG(a, b)	BUILD_BUG_ON(a)
> > 
> > How difficult would it be to port the complex kernel macros that
> > actually result in the message being emitted in the gcc error output?
> > 
> > It's helpful that when the kernel build breaks, the robots will report
> > exactly which field/struct/whatever tripped, which makes it easier to
> > start figuring out where things went wrong on some weird architecture.
> 
> I did try to pull the entire compile time assert machinery from
> the kernels compiler_types.h in, especially as atomic.h already uses
> a differnet part of it.  After it pulled in two more depdendencies
> I gave up, but in principle it should be entirely doable.
> 
> > Otherwise I'm all for porting xfs_ondisk.h to xfsprogs.  IIRC I tried
> > that a long time ago and Dave or someone said xfs/122 was the answer.
> 
> I'd much prefer to do it in C code and inside the libxfs we build.
> If we can agree on that and on killing off xfs/122 I'll look into
> porting the more complex compile time assert.
> 
> The other option would be to switch to using static_assert from C11,
> which doesn't allow a custom message, but at least the default message
> isn't confusing as hell.

I copy-pasta'd the whole mess from compiler_types.h and build_bug.h into
include/xfs.h.  It works, but it might be kinda egregious though.

--D
