Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795596037;
	b=NeN7ZFcgoo+PSFhrtU7kBff92TBSQUMDaJhM0dqQIrS3QNTuqz6NLusEhYnaCsAEfFS/
	 /wgm8Og2vaTKnsEHO9DnA4Be+Bl2TqSMrCOaELUYsF1ZVqjzfiUW4F5kRFB4yPIhQpath
	 LOw6dWCkgXZR6XVeQsWDDw8gUTMxFCOEdZGwRk84MQexgxqNMB1+ZmTa/+0xRoqlJObWl
	 gZQWWnUVnmDZ2exLnkELoB3bbxZKTPjvC5IfBYQK5YOMTnOaJ2lHK7DwFOn+C1jXMwPb/
	 mxFjMUSne+Lt7hxnfqyq9SPwI2wwL/D53KQfu1Kfr/FQgf7fNYoLcTsB96hQmslZjjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795596037;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qg+RvjAxAqVRXTguFTp+y0qVDSwQqE5pABUxvpIUIx0=;
	b=FDHVXbXCqdwGQKEN3IOef2iMgRwqhYO+GXJY6u4dWWckZfdO7G7osofesjkEAOS3Asdz
	 Vk83oBIDZLLm+BxKx7seTUlZBPEyWsR9bHGQULWh8GaQRg08eC/hmoT3YwBkVw0oJBXj2
	 FjbtDwroufDD17Nru1sCd2wfak4mrXHYtmw+CqBKz8LcvGbYE+qFNWrGGTQYXQ33C06zP
	 fXecSGVuYe1EeLETms9a1O6Vd2Wq/pJnS9T+8+LY9a+1LbAnlK6X8Qzth6jsQWETEKm64
	 y7UoXIdRZHckTKeXeCNGLdCEinoHL8+hQLAL2JYueyDn+ELMFCqCd/JYp1E3otge8+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgiDG0ms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D373606A327;
	Wed, 25 Nov 2026 08:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgiDG0ms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03C11F01564;
	Wed, 25 Nov 2026 08:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795596036;
	bh=qg+RvjAxAqVRXTguFTp+y0qVDSwQqE5pABUxvpIUIx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BgiDG0msrAFIsOfOGvm9hpeFfFEefN5pkLuD1SqZ6vFDFSUl69TnDjoSAUpfuhqFg
	 BsWuc3X0QFrFR2TThe9J3r/tIODeLdEPiFEPQeaBsDsODuBUZh9/2IgZpr3e5k2nIi
	 3sJlx5l9qe+4W6kRoyDPpCqAhl+grgbmmJmPW1GupUDsXlRY6r8H8N6Ppz/AM0tQSK
	 qLCPclk1VZKErezpAIPsOCFAPJMfpi4KX5sfXMJ/YAi3MhYAz4Cl+4bzFJhHQ0y213
	 j3SPBM6GlJ8zID3PchgrkDvlbrFkP68nOFdPCD77K+vlI2/NNcI/aY3v3qEVrY/77F
	 tio8msW5LwfTQ==
Date: Wed, 25 Nov 2026 09:40:33 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: what should we do about xfs/136?
Message-ID: <awae4V7kaESFV-NW@cronus.toxiclabs.cc>
References: <awaK2LnBPb8f36Ig@infradead.org>
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
In-Reply-To: <awaK2LnBPb8f36Ig@infradead.org>

On Tue, Nov 24, 2026 at 11:14:32PM -0800, Christoph Hellwig wrote:
> Hi all,
> 
> I stumbled upong xfs/136 because it is the only test in the attr2 group.
> It also isn't in any other group, and takes more than 25 minutes and to
> run in my usual test setup, and then the output doesn't match the
> expected one at all and it fails.
> 
> It goes back to:
> 
> commit 7dcf3ce6f95603965b51c53d0a48864b0c6e8268
> Author: Tim Shimmin <tes@sgi.com>
> Date:   Tue Oct 17 06:10:19 2006 +0000
> 
> and apparently wasn't run much at all for a long time.
> 
> Should we just kill it?
> 

Sounds good to me
