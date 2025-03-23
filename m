Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1CD1AA791
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 07:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742716461; cv=none; b=n/i7eCfGwYmYYtFKwaSIS8Q7VEnCYpgECH2yGlDfSW92ncMLVx5pJe+Fq7NKwjJSd0hN9X4L7+Jq7fVcRG3gKHggty2qZZfUsuf60/GBK/lYV67SREMBWvhRG40gyHnaHMLw7hvRPQ6nV8vff8RvLg4zLpxSazfCqPPURDTf1eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742716461; c=relaxed/simple;
	bh=Ikf4OwQxZ5XlArkmB1Mr/wq9twk0fvi3fsx/Ai7aOvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VpqZlckCttqthz2WQciTreEg9ieWI6F15qSyLU++q584Yg++FmUg6nqrabrApxLTv+mxpOD/dKIcTZOUEAcOlcYIZvq08oMz4K9JYL2rjN7xHaEKdgkgrrSy4qGeaknJNyLDe3bJPesYvfIDm1DhsYDCg7I6wB7uHrDXbJqTtB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ly6Mhwnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ly6Mhwnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447BCC4CEE2;
	Sun, 23 Mar 2025 07:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742716460;
	bh=Ikf4OwQxZ5XlArkmB1Mr/wq9twk0fvi3fsx/Ai7aOvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ly6MhwntTZv4+jHh91ipYh6gd7a4TWZ5ebG7q+NKNpzTi6Go2OlaMbgepD4LXBK1x
	 ugMkHSeNCywhwAHza+/oDcxXkmX0xJdzpQRdAT66TYINNrAjrfktaJ4AUwp3w0xjEd
	 r631TcPCUlItOpag1anfsbv014urWjkqAUjIJxu7tsl65FXPdvJ8m5PceqSJW3s2r8
	 W6TCKUVrETmvpki/mKJVM3WKI4o6ox4G145zfBY7imxMrXsetsxzizWHDuZrdttsTx
	 1rTLv0H/SZfxn4DIrFFu6MMH8zx4lys4LO1MTvcAmO57XnlcHXnBxZpaezgW/d40pW
	 3L+9B134vQn2A==
Date: Sun, 23 Mar 2025 08:54:15 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <dchinner@redhat.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: mark xfs_buf_free as might_sleep()
Message-ID: <hmefzhhbz22qudfiza4onfpry2jdh5itzslu5itc45ni5j3hel@wizc7agqu656>
References: <20250320075221.1505190-1-hch@lst.de>
 <iehRDkchwLyn5czaoM6iHGrNaM7A235ISuVTw_D6fpn8zuuiMCqofPep2K2Xn0Pgo__30TcjbKGoIBCld0AM1Q==@protonmail.internalid>
 <20250320075221.1505190-3-hch@lst.de>
 <dswaua7ynkossegyqw25x3ghilbjsxalatbto2xrbek74j7u5o@mxhq3mhukk3j>
 <oSNKT5znFNmM4YvT6XP7J_FyaH78ELAzaszW4QdSsjOF2Qy9pNQdQ9elpHZIE3tRcwQ1WrRSX0YeL6LMxsECYg==@protonmail.internalid>
 <20250323062921.GB30617@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250323062921.GB30617@lst.de>

On Sun, Mar 23, 2025 at 07:29:21AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 21, 2025 at 10:21:35AM +0100, Carlos Maiolino wrote:
> > If I followed it correct, vunmap can be caught via
> > xfs_buf_free_pages(). If that's the case, wouldn't make
> > more sense to put might_sleep() inside xfs_buf_free_pages()
> > giving it is not called only from xfs_buf_free()?
> 
> xfs_buf_free_pages has been folded into xfs_buf_free in for-next.
> 

Woops, looked at the wrong code base... Thanks for the heads up.
