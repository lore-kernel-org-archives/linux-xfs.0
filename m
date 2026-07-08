Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105B345104C;
	Wed,  8 Jul 2026 12:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515478; cv=none; b=Ncgc4pXRbkwEhtLqsTA0lUKMx0m6xRWCs4Eq5S7e5MnillU8tLNkXumyz+2b9685yRB9dxfm059rr+G5EPRN6W8mhAfKPdH0C5mPlmLOoeg0oUY0cuxFopTlhIrEzRSew73ZXkOZM4QBwRPEs1YF6R3HMLR0llRzhr8j6dHPhuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515478; c=relaxed/simple;
	bh=2nsy+U8/jvKFoEkZxvZyqeFRNpW/H0zUM/v60PSDbhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f345Y3rUtEQq2H3k/xiweNo2rn5N1yMkJYK7KdDerW+ga7YqtDQR+cdArFEeSh8tbVBXculFrw0nyrGhLufXdhoxCkRB3nGId1YImjlfeEMP09EnRF1Myqwl0UJ0AnOJwM0bRSMnHvw59IPiOzcCrui8FFp1GOWgAdwbK529Z0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3dKqu8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3dKqu8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7D61F000E9;
	Wed,  8 Jul 2026 12:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783515476;
	bh=/u7xOFWq0MPHcv4h5HiuOVhg7bQiqrwHhTVc9XaeB8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P3dKqu8er7liiFlmlziRsMnzTn9DXUfsSa9FTlxumgklYti+tHVbkYmP64P03QZA/
	 NuCkgMvO1InGR1y1Qqru4oVrMrdLko8s5PaWl8KPue0qqtXrDwYTr4/M7FwG5+e/g7
	 I5Xx/vzymQXT73nyrb1HRZipPTVCy/M9Vp+0ft+oFFVDfLxqEex+IRglCT27MrqyA0
	 qvo4COEomnsIVjS59Pd4BazXmF0nY06PO+IFdLeS5Ai8dCtsQAugvW1ziRC05dbf+s
	 1oJKanT7cdlYG4o/5ooEPpRg+6Y83iwJjmq7O5GwfKmZUPCgM/3UnkZrjZUQuzmXYW
	 ofOYs75v0rnGQ==
Date: Wed, 8 Jul 2026 14:57:52 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Missing signoff in the xfs tree
Message-ID: <ak5JQyi_1aAvttiv@nidhogg.toxiclabs.cc>
References: <ak4uhSXlLF3Gr576@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4uhSXlLF3Gr576@sirena.org.uk>

On Wed, Jul 08, 2026 at 12:03:33PM +0100, Mark Brown wrote:
> Commit
> 
>   92d2d133c6cb3 ("xfs: fail recovery on a committed log item with no regions")
> 
> is missing a Signed-off-by from its committer

Updated it, thanks for the heads up

