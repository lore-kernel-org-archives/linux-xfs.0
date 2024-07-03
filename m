Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75907282FA
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719982941; cv=none; b=jydm3iPFMnPZALNrhy97k8siULNZ69tgxuukBVt4BHDkIkk+bepqMYo0sYYarNBj1qN5+7la/shPiF/6ySZRbkF1YzVz8g0gvOURZb198KEEbPUITY5fcNuKxRfEBxFNszFQK4tWuWf6XXGCTxfuUrDcQgf1vK5fWnEp1zjkH10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719982941; c=relaxed/simple;
	bh=ANdcKBOdY0TCT17x4mpDzkhWWXrhLfoqSxlY3dQmWhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RI5DgMacGU8QTyGZMe6Jp2EAJuC7AFxzyhtYQk6+5wtZMB2Pzwyue48RhPJ+Gj0RqcGFe/m+D5d3APIrLAol9H9VJ3v9gbUlRJNRrHyr++ISFgmdaqvkny8i3jNQsWr1Y6QoYtSCTv/ay/stSlHvlRAXUr0wBd70Qc4wgqaJQ3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrLHkfPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrLHkfPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5F4C4AF0A;
	Wed,  3 Jul 2024 05:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719982941;
	bh=ANdcKBOdY0TCT17x4mpDzkhWWXrhLfoqSxlY3dQmWhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qrLHkfPi+bGX/WU9oIe6kFXgUl872PYNTs9/1BxfE4/JOZIvrvp5Mu2c4iL2+LCKt
	 SFab52Rbt32ReBquTe5IyGsYy2AxGsnhhB4cw+gAHzRQmtsv+zp4gPS60Y2a/0rd81
	 Gban+nnr3KLUZumFjigvZ7v1swuezw8ZCXmrTiqcRjUXR17HnOjLr7AKMwC/iYpKB3
	 PyfB6xyQpiCDh4i6nzFoGGoM0hIwDc6xCLRaECdlDRxc3r5wnMIpBcd/U9LoFUo+N1
	 bYLY9iRM/RL10qLu1C3GBd4U5B4XRaoBh4rPaURU1i9wYNsXPPri7ob0RBmlez1Dou
	 BmzMHqmvejH8g==
Date: Tue, 2 Jul 2024 22:02:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible code
 points
Message-ID: <20240703050219.GC612460@frogsfrogsfrogs>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
 <171988117657.2007123.5376979485947307326.stgit@frogsfrogsfrogs>
 <20240702052225.GF22536@lst.de>
 <20240703015956.GS612460@frogsfrogsfrogs>
 <20240703042732.GA24160@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703042732.GA24160@lst.de>

On Wed, Jul 03, 2024 at 06:27:32AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 02, 2024 at 06:59:56PM -0700, Darrick J. Wong wrote:
> > > > $ wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
> > > > $ grep -E '(zero width|invisible|joiner|application)' -i UnicodeData.txt
> > > 
> > > Should this be automated?
> > 
> > That will require a bit more thought -- many distro build systems these
> > days operate in a sealed box with no network access, so you can't really
> > automate this.  libicu (the last time I looked) didn't have a predicate
> > to tell you if a particular code point was one of the invisible ones.
> 
> Oh, I absolutely do not suggest to run the wget from a normal build!
> 
> But if you look at the kernel unicode CI support, it allows you to
> place the downloaded file into the kernel tree, and then case make file
> rules to re-generate the tables from it (see fs/unicode/Makefile).

Ah ok got it, will take a closer look tomorrow.

--D
