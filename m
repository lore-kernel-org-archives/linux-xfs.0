Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667C01F19A
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136254; cv=none; b=MOxMdc7EzY2bF0wyZgJgZRATQfs6Lm31bIrLH54GLWgkKZsOHX3GZz88tIgDskXbQuXg2/vSlIGSZt8SUo0styZpIY4r2GH8h8wWLClzSWicJvNDDljnCqZodZW2+JLlMOF4md5LpdMvM2JK3cjKxQlzTdr11bks/G3+JmyEgPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136254; c=relaxed/simple;
	bh=6ztHIsSjQXcx+M3PSQ/Rm5chIuGmGP6dl8bgYw1wFXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rk19y/P9N3mtkYAfoU7vB4c8ly3ndd68axDhJjgjnr8g5DpBhZvvGcCeoALQyPtGbAWUnGtYXWw8R4lX0UcqbpXf/igVRfD8jUXqUzsHCnMJAeSIGzWk6LYAyLaauA1LVUOGEXrYKzFUgpFGJn7+VqzZMCX4bE/VwzcSUnTs8Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jnkNu9v9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jnkNu9v9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F4BC32782;
	Thu,  8 Aug 2024 16:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723136254;
	bh=6ztHIsSjQXcx+M3PSQ/Rm5chIuGmGP6dl8bgYw1wFXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jnkNu9v9+Wkt9vaOSvnlIK4Z2kbT2gFnOOnlKgnLynIG+eEsq/6ZwI5y4dD/GgNbQ
	 2XrUlAjhDvhS67rQ/mGTsnY2mQgl/Mg16iMcJUPkmJQZW8AKGxPpUcghrOoNQ3H7+u
	 4sKRP2OPeuvEmZEYk2dCc+ZFL1Kwjt3/gg67Yl4jVRwcNPJX5vwJDllA4o0MvdMrF9
	 5gOJndOSUoI0S7cP+94ykVmAeXgercd9D+ftiq4+/a6nMWGI41EPvm1KA4hflsR8J7
	 xZztDC6dPAVCOedCkLzHLVD/lJsufsTzciNR17b4+0rcACYPNHg2nSTTcxTPpwojW+
	 MGRoWUdgOlypg==
Date: Thu, 8 Aug 2024 09:57:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] design: document new name-value logged attribute
 variants
Message-ID: <20240808165733.GQ6051@frogsfrogsfrogs>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
 <172305794118.969463.1580394382652832046.stgit@frogsfrogsfrogs>
 <20240808140844.GB22326@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808140844.GB22326@lst.de>

On Thu, Aug 08, 2024 at 04:08:44PM +0200, Christoph Hellwig wrote:
> The subject is wrong now that this is not generic name/value but
> specifically parent pointers.

Oops.  Will change to "design: document new logged parent pointer
attribute variants".

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
