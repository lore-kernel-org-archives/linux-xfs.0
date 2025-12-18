Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90B71624C5;
	Thu, 18 Dec 2025 04:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766031154; cv=none; b=ACqqTWm530LSDMSb4+VZ7wShkE/NlTW0Hq6NHSHkcuPqM1/sI8nUcCXqmCRDe/VCYXR0v+uq8F8ghlxihuKwz1yK6bRg+WncI2Eypp646odlJZXj6LgljMZ0U6LM16NKZoMo3jifN2pGsrHLn902kWf6UsyiqopTtRe9GbzKYmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766031154; c=relaxed/simple;
	bh=X9aZiq5TPCCR3pfb5ByiaDaiFXS82MJv8O4ohs17Lyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ez/qczoVujsRigy1axiLa6lvOcX4mWtH75zgFW5ZMDcKRpHscq84z4EDqp1F6vVPsltLVr0jLFOXyh6AqikkPDYTqfOYeRCKkp9giL//4IWFsgAVIj6bxj0tYfM8n97HF2XzUbsNBZQpzBJDLJ+YfXktH+KfaOvnfdEUR3Dq7ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRLcKrYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRLcKrYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30774C4CEFB;
	Thu, 18 Dec 2025 04:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766031153;
	bh=X9aZiq5TPCCR3pfb5ByiaDaiFXS82MJv8O4ohs17Lyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NRLcKrYFwhSGiu5Q5+cUjPvVa8rivq1A1st0nIKxkgxFc6DOp/0kNdE7v9uK912lZ
	 LF3SCmSyk5PWsK+fs6u5yrSPH3F5MuK0O43ZtNYcqeETE6qV4j/Oq8u279FPnLrQJm
	 UUPNfRFDMYTFtKx8hIownXUsGxIAWP/tG/l8glE9cdc9ZGKHMwi6sL81UR+JtKGq7q
	 ggi9OGJ91wlh0cQ8xlgGduFr/iZnBfNHK++V371bZtP5emlMMjupaBrudw78LJI+ad
	 D+Vytnq0KCqfBwWVQtOMl630Nd3H65PiLXBbWaX6ObnXtKr0Z7Xp9oBJyvDeFrTDyQ
	 TmwWEiwNjGlaw==
Date: Wed, 17 Dec 2025 20:12:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/649: fix various problems
Message-ID: <20251218041232.GW7725@frogsfrogsfrogs>
References: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
 <176590971773.3745129.6098946861687047333.stgit@frogsfrogsfrogs>
 <aUKFBx09MGp4Z2bu@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUKFBx09MGp4Z2bu@infradead.org>

On Wed, Dec 17, 2025 at 02:25:11AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 16, 2025 at 10:29:56AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix a couple of problems with this new test:
> 
> It looks like this patch got dropped again?  While my git repository
> has the commit ID, I can't find the test in the patches-in-queue or
> for-next branches.
> 
> The changes themselves look sane to me.

You might've pulled my for-next branch.  IIRC I've never sent this one
to the list, so Zorro has never seen it.

--D
