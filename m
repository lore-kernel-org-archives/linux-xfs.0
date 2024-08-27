Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2811D175E;
	Tue, 27 Aug 2024 17:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781087; cv=none; b=lyWyTTKrqArRJdlW4FshopQuuNuMiFv7PZMZ6y/BzNjsp2hjfarRWoybgbnAb+pHW7yCcMiKRDjqydEfKFyOVPKikjxTus+ve1goHUbas/U9QYJVNSCz6KrSa1q240uFlGFFYb9a8iJ3X8eMu8WGRTrBQDLf+fo9PcguDoZtFTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781087; c=relaxed/simple;
	bh=pM9F5ebIcjHOlukmBAOFV0YzpQW9okpnELVxUnb/9NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBqzFy+CNV1ZlkxZ7U1S4DNI69eYXCvsnUukX1e0v2kzdGbLkpE1S9ZOPCFLACbJ0ei4V9YpSUPd7871yMD9bzWOi5sC9rzP74stsadsAAucqOd6+WGm+Oka8qTzSibu0C+c97mkhyAxwaeDACAmHgpXFRGzCzfDmKvTPeU63tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVnOcpx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVnOcpx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B79C4FDF0;
	Tue, 27 Aug 2024 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724781085;
	bh=pM9F5ebIcjHOlukmBAOFV0YzpQW9okpnELVxUnb/9NA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oVnOcpx1DE24N1+3EurUeGnePlGvAkao3BX9uhcWdzjgpH7y/ct8GP+OaimzSDqW8
	 Cc6Tn/LBEsMdhdLFo1jMt3CUWpnStMp7l5Ek5T23FrCPlWwSpqihxzZG1SZk319DPU
	 UGYLnAyJtCtLOjts47kce5lt3D/TwczwH3BWVUPqXJHzRjhomN9mxYjLJQ0K7G6agf
	 dpAu3Gqs3ovkYMvwA/y6T3408Snx/iGcTDZ7BgvBQoy/zy0n7GJo3S/tSXQ+rvuikx
	 qRzrNk/5Rp86PdsFrc2mhKb+RSDNpItFoDoWGnpDm4Pu978IP5yFa8UGzf4QaAPhaR
	 T7OFc6kPiyi4g==
Date: Tue, 27 Aug 2024 10:51:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: regression on generic/351 in 6.11-rc5?
Message-ID: <20240827175124.GA1977952@frogsfrogsfrogs>
References: <20240827020714.GK6047@frogsfrogsfrogs>
 <Zs1bL4H1dR_HVPmT@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs1bL4H1dR_HVPmT@infradead.org>

On Mon, Aug 26, 2024 at 09:50:55PM -0700, Christoph Hellwig wrote:
> On Mon, Aug 26, 2024 at 07:07:14PM -0700, Darrick J. Wong wrote:
> > Has anyone else noticed the following regression in generic/351 between
> > 6.11-rc4 and -rc5?
> 
> Yes, I'm seeing this with a fresh -rc5 build.

Aha, it wasn't the scsi lbpme patch like I thought; it was a different
patch in the block layer that got overly aggressive about not querying
write same queue limits.  Patch incoming.

--D
