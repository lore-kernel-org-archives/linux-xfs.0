Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD1200AE;
	Wed, 19 Jun 2024 16:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718814709; cv=none; b=YpdKt9zB1z+o6/7YP8IKjIn6uPP2O36RkJ1lAj9LtBqk+FOXziH0/zIoPAWS7XmuWRurWL6MO0HtfGDu8E2A/DuN3sn2qs+ksFqlppzUVq+AQML9I4GID1FmqJDl/4ZVCZIAQspSWPWXqi4wYlzwNUfOtT6zfwJ0rl2bnM7XUDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718814709; c=relaxed/simple;
	bh=w+/VtiOPtA6u0PkVDosOFQLoGV0X0t4lroE/i+IV9is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+2xBywIm+lgDulsHh4RXPeF3LyItAt3LMRR4QUXQz+Z5+J6XBKil6TlQQbj0mMiluZDId/ff2dA1bnt30P2TvFFlqAFIun3PsBqB5zv1pn2MpOqkva73UU7BCiVbIXcFsAe6EPv8Xp3Ap7DTSa8a/cEWsOUfYD73Mga/NYTyAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXLHAxgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXLHAxgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3493C2BBFC;
	Wed, 19 Jun 2024 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718814708;
	bh=w+/VtiOPtA6u0PkVDosOFQLoGV0X0t4lroE/i+IV9is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tXLHAxgoTCThvJdf0WfapfnrtMZ/RVyrjTkNqaWrFRBdyBirY1K4SlcAl14WvHf5s
	 77QFAxgEPWeoUCeqhaiDIvN4/3Rwyw5B50jVrP23xIJFoBsxItvlQt1JMyvbnakaOF
	 1Sa4aBoGXtTqlzvRMY7h02gwBa9UdMIayqrS8ozEEYXQWyFGSnJ+rfcRKuizRmnAhL
	 cYHbya8pDJGSb+IPHu80pFusL5MrIXCgmkvREihwpv+MHCX63YiYLpziGhZQWbZWnI
	 2w1rHUXKuQFal79+8CVd3sCE7PrjjtkrqYm6Evp0z+i8X37iIO52kXGcyEzUQpKDrE
	 LOPbdQc01yFVg==
Date: Wed, 19 Jun 2024 09:31:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] generic/717: remove obsolete check
Message-ID: <20240619163148.GN103034@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145359.793463.11533521582429286273.stgit@frogsfrogsfrogs>
 <ZnJ2Ehz8PIcQ5m6R@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnJ2Ehz8PIcQ5m6R@infradead.org>

On Tue, Jun 18, 2024 at 11:09:22PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 17, 2024 at 05:47:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The latest draft of the EXCHANGERANGE ioctl has dropped the flag that
> > enforced that the two files being operated upon were exactly the same
> > length as was specified in the ioctl parameters.  Remove this check
> > since it's now defunct.
> 
> The last draft is what got merged into 6.10-rc as far as I can tell,
> so maybe update the commit message for that?

"The final version of the EXCHANGERANGE ioctl..."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
