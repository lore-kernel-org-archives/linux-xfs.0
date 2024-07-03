Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE08F381D9
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719982559; cv=none; b=dV4TAWSdhWidlNqJsJwMk3d+jb0QI8Qr3AsVztBtIq6d3m1JMCVu3dLZdjQL798+h5NIR7UOpfngTiteX6ihop7k3B8mSHLbKYElyYOTlxokyyQr/mb/mv14Ht4/RWL4Htxdm1EYBDeL7ZAawajHqgtEN9Qncl9ar9ZBzNfEDXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719982559; c=relaxed/simple;
	bh=WaSbek0vJTTKDuf45DkPzagNeZCg8G6+pdL0Hps4XeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EwrdN8u9jvh5hXGbqJ2wXaOH2r2usGq7fdDqKzy6ABqxm7EpU+xauM1MB428KOAKwfzpjUU8Ml8BGS48EhCykm7W/iXmAVY/E2HJPLwToqBQLf2tYTl9g9ndyaRnjNPM3byYer2gkhqpiVx5a8CJrOecZY2Ov8D/mJ2ldeGbcn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqwCn237; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqwCn237"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA45C32781;
	Wed,  3 Jul 2024 04:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719982559;
	bh=WaSbek0vJTTKDuf45DkPzagNeZCg8G6+pdL0Hps4XeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HqwCn237jDGJLhhVCEX8hy0iOOl+fvEmbUUdWPTMeID9DnXi+ibgFh9Cu0T7J0NMx
	 baffze2EB54++SdB5vL0vfUvb/EAXzztFxb1xRmNYNrhzoHPOGASHLdjaTIavRdW5i
	 7ehdukmLmcNTkmRMclkl+5KHd7XUpCwFoZX4+a/KaJrsVysUTTXSyDducsXW9dPCWK
	 OZnfkssANhNKj3zMSI7cShkADT8vF1Dvya9OFQ1B4Ggs67N95CImBkc2hBvk0IPoZE
	 wgEoKilFYVv5PvSt9XhyfRajt3vOwt6qrTuMx/OmPU1o5NhovBoYFfK8IWhlkq/bp2
	 jeEmawHSGf1bw==
Date: Tue, 2 Jul 2024 21:55:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libfrog: hoist free space histogram code
Message-ID: <20240703045559.GA612460@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
 <171988118595.2007921.8810266640574883670.stgit@frogsfrogsfrogs>
 <20240702053238.GH22804@lst.de>
 <20240703024738.GU612460@frogsfrogsfrogs>
 <20240703043009.GC24160@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703043009.GC24160@lst.de>

On Wed, Jul 03, 2024 at 06:30:09AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 02, 2024 at 07:47:38PM -0700, Darrick J. Wong wrote:
> > Or change "blocks" to "value" and "extents" to "observations":
> 
> > The first option is a bit lazy since there's nothing really diskspace
> > specific about the histogram other than the printf labels; and the
> > second option is more generic but maybe we should let the first
> > non-space histogram user figure out how to do that?
> 
> Actually the second sounds easy enough even if we never end up using
> it for anything but space tracking.

Ok, will do that tomorrow.

--D
