Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DC93FE373
	for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2026 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777568246; cv=none; b=jYErfas0Ul/Q9jbLJ19x4Tp+atBEn4vyumA5noCXmcs8OLtzUJ+UHzOHgFT20BDCKx0qD8QkMJBzb80izz6Yj7adDCwK85mAtXToIOWilLkT+x5aXGtpf18vvsc4jNNfunBDJD43HN0toAWbBqPHGiWxBzhulGGMwEMkzb+44Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777568246; c=relaxed/simple;
	bh=mDR9afFLBIKGkd9QqjEVHZIm30y6nz3Y7uxOYbjchSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/7XY7LicGpf984d6u0/X9eP8K8Z89vNiaa7jPkut85+8k6ASdKRgNp+gL68JKA/WLq2YWJGp8hlw28YEmr9iwHD+7QNpXMOvDvY5jfnNdtrsuGw1Ic9uTFelcDI76NC3ZHePhrLGbsdEqucrK3iSWQCaGFc54ZEyuga4e73B/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdlGx4It; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdlGx4It"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11DBC2BCB3;
	Thu, 30 Apr 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777568246;
	bh=mDR9afFLBIKGkd9QqjEVHZIm30y6nz3Y7uxOYbjchSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XdlGx4ItLLY8vpxpWuuUnvArNbIj9Zc9xREirPR9/Mj4F3XmWILHQk4CZzdFh3iou
	 /dQq7AId9wf3j/Fg4aYvzSlq4RzF0Vh+k83sojgg/pOn8NHS504pBHlcHXvUPpflyK
	 2oWyjXx/mFgueG5YZTbIn7CiwbQxosuI6EAfAd6iitmwkVsAdABr7PLrtGxSsvClT0
	 HKmdBICjzH16JVvZHPJxD0gEh3TuJfZCWI/kcGtL866NWPfI1lzkusIxGb3gBQOu/D
	 fwWtZ0rY/9UYtbSjbsbw6+5PjKAiNKirzEjwwbzzmapcT11hhSt/VSLl920NwS8PLr
	 O9UhQZCSAswmQ==
Date: Thu, 30 Apr 2026 18:57:21 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Patrick Fischer <patrick.fischer@siedl.net>, 
	Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub_all: fix deadlock if lsblk produces a lot of
 output
Message-ID: <rqtvmfqbp3bypw4ueczjdo4r4sip2h52jigp6oej7ystol2vlh@ewcstbssx336>
References: <20260430155406.GF7751@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430155406.GF7751@frogsfrogsfrogs>

On 2026-04-30 08:54:06, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Patrick Fischer reported a deadlock in find_mounts() that is the result
> of lsblk producing so much output that it fills the pipe buffer.  When
> this happens, lsblk blocks on write()ing the pipe, at which point
> waiting for lsblk to exit will also block forever.
> 
> Now that we can be reasonably assured that everyone has Python 3.5
> (because RHEL6 is long dead), we can replace this whole mess with a call
> to subprocess.run that captures the output.  The json library can
> convert a byte array directly to a python dict, which means we don't
> need to concatenate iterated lines or any of that stuff anymore.
> 
> Reported-by: patrick.fischer@siedl.net
> Link: https://lore.kernel.org/linux-xfs/323580211.1220195.1777554001363.JavaMail.zimbra@siedl.net/
> Cc: <linux-xfs@vger.kernel.org> # v4.15.0
> Fixes: f1dca11cad1308 ("xfs_scrub: create a script to scrub all xfs filesystems")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
