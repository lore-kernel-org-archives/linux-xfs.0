Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2243B212FAD
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 08:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750839722; cv=none; b=QRMY9ZgnB5UKQSNdAggIOhIAVDt5xkcxtKPWNk97IGgxbunfa7vVSSx0FKwmx6g5GTkK9ZWxkA+fiRMfc8JVAJ+biQc4phTHLJ82DBjquu80zvYcexxGVJityN/yvGK9iczCP5sGLT3TLQfnel95jUDvFmHMinqNnk7/chkffgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750839722; c=relaxed/simple;
	bh=aHeIfq8RoUTmCd8TeN60Da/DttEP006kbRFZ7O2GOxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+CNaQ/L44F+7Zq9GwGJsbpAnvx1aYg5yhs7luntwPyVpfvJc0G1nxRTkdJAvzwhjx/ai4dr8IbmPfZY/4F7tvmL5AR9FefxxiC7zkI8xB1+SugSr+fDU6OuC/Z+B9Jcc+tR+0LrkAV46TRfimih6cwL6zYD4iiVWyyUh8+EdBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2JZgZXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2JZgZXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C04C4CEEA;
	Wed, 25 Jun 2025 08:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750839721;
	bh=aHeIfq8RoUTmCd8TeN60Da/DttEP006kbRFZ7O2GOxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s2JZgZXbLq4zXnyDXHyymQvS0U1wzsczlHCwtiOmuDnRW+oSLbpm4lBndb/KEoTQA
	 Wo9RztJkkhj/883mxNbwnkyHyGbIVbaX+DZTyU9L+5C580bK9GnIQfnQOWbvLEx/19
	 CAMzcRGBkoEilA2JFwiabmYBhK4DOqEDQeoVuY6+SNm0IhnbiGAF8zOE9SKaS0Jl2w
	 sO1Ayai263YIpEVM6Efq8swN35ESv0hn+FaN+ZPpTG9WG+LW3yye0+1//31YAO2Xtf
	 XljL73iruxrmoUdOqZVpCRVTQvrjrQp9m7NqUtGCi5cP3KoYe+MuMLq6moMH5sUzy7
	 4fHUr93YqwK8A==
Date: Wed, 25 Jun 2025 10:21:57 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org
Subject: Re: [PATCH 2/2] xfs: kill xlog_in_core_2_t typedef
Message-ID: <rmplqrbhdd5swc272wdil72xf3uf6fba3zrz62rfaqeddqom36@mglwox6n6kun>
References: <20250620070813.919516-1-cem@kernel.org>
 <20250620070813.919516-3-cem@kernel.org>
 <l8M6Dc4aeuOAw0QoChSIVccpNIhHJ4nvP04x13gNL5tT3oDmuYZjx88sHpW7itR3j_uqchSbJu3mak6vDjwkkw==@protonmail.internalid>
 <20250624135953.GB24420@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624135953.GB24420@lst.de>

On Tue, Jun 24, 2025 at 03:59:53PM +0200, Christoph Hellwig wrote:
> I'm all for killing this typedef, but the name of both the union and the
> typedef is just horrible as it describes an on-disk log record.
> 
> Maybe replace the union name with something like xlog_rec or xlog_record
> first, update the comment above the definiton and only then kill the
> typedef?
> 

Yes, that sounds much better.
