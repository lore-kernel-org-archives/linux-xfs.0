Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E81D3E3D90;
	Fri, 10 Jul 2026 10:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783679944; cv=none; b=ghyKO9w68IqHsuamNjE3K2KO3G7RZeeQnW3DYXEbs7Lsf58/WKVOisWSPAsfzXoSv3VW3GcIRoTwjzC0QGUFwTUYHYf6ByDY6i8yclRe7fV0yrSfRmoftw85WJsMmKOat/qkrY482bTBk+/x+Qx4aWMZbdlrW1Uz0r1KHjH7Tcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783679944; c=relaxed/simple;
	bh=w7qW3stQuIsLqkR2o5vwdFCbRPLYd8v/m9KwvRDEfo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1m0eGMEOo92dKbs9lBwZi9fCBaCKLawSSHCY2d0RP7jqoqpUk37Rs2XWfNu7Kcfd2EbNPC7CxeR2bykTYyjSmu9+Z9Ys/Iz/buPpkzj/jSn5TWa/5I5uCpRlpdpgFlnw97cdJU6BEIY6cWovAupEBy78GtObHeplHSud0roJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKcRXOri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKcRXOri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3D81F000E9;
	Fri, 10 Jul 2026 10:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783679942;
	bh=O0b9QDRqZks374+uiS/Ng/4ACV0jy52ju7+YMc5MnWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WKcRXOrijkWnmhJEB2CvAJdJ2aE5JPJfRn5rv0eO+C6DJXqIzMS0k5QbGouU2OR0t
	 sXf9f4HQnvEMxMD13g2lcI5SogKWvNITPGSwx3BLMuJA8ev17vY4GZRSWFJ5ajMMvu
	 ENkAyCvlK2fRdwkyrOe7ZZMIutJg0mvewLr1mJTrL0rVgta7SzYHKUlx4ID0eipLdD
	 DdDJHYfoLHhqlX1llZSdt2BIcvVrrSCqDwuhHH3wO6ocJMzNlLt2zKS+9Iv81lSwTK
	 tvXfnoIvz/X2fq9oTz6T9nBosJFkIAvAiMfXAt+Ij/L3ICPSL5qfIIKkDti27rP6cr
	 Dnlim9yUwP4nQ==
Date: Fri, 10 Jul 2026 12:38:56 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org
Cc: hch@lst.de, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, djwong@kernel.org, 
	linux-unionfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v11 00/20] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <alDJjTPiKRQ0d8bi@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>

I will go through the new round of sashiko.dev comments and check if
there's more fixes to be done (looks like double unlock is valid
one).

-- 
- Andrey
