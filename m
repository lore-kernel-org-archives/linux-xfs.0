Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4266128695
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 11:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760960979; cv=none; b=B3DveOHh4TDeVgiPgx1LQHGcGH6IhLtMOP4z8uxUYALh4nCaG+ChJPID8cZFWOAEqk9CtK9hocVRXQVh40YhPuvRIwfBBD+64y3C2aQaCI8KCie3Hyu4uePHBkCEOZKKX9BkYDZgc/60gXZ+JEtNfP051JH3D0QnKXf2T5SMAs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760960979; c=relaxed/simple;
	bh=wJv8ecqSNR2EpDt1F1JKeylSLQSNPsOCHzPbjAOXenk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ob26eRCjlXyc+MW+ulWQJeAn25nHcFcIzl0Bwj5ukcNWe9dQPZ5CUCbaFvycNdJ4rUmgBDu6f2ViVgSjsvlnyQvpSY471YOztsZE2zfyBTSOGF+guJdMR10dRYhPKqsXx40Qj8MqSaStIF8Q+48A1kEcfpxdI7700ANdnfbk+8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EFC56227AA8; Mon, 20 Oct 2025 13:49:31 +0200 (CEST)
Date: Mon, 20 Oct 2025 13:49:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Message-ID: <20251020114930.GA16997@lst.de>
References: <20251017060710.696868-1-hch@lst.de> <4iiJsTfGvQ1w-tO5wCGYxYCAVzsB3qLGXOMX9x_QjbtgyJXOwF13wT3aL3kXsNNFFgqhtt2fLOdCEyvxCYxPWQ==@protonmail.internalid> <20251017060710.696868-2-hch@lst.de> <lxx3ievmo7icudhyniqxxfu7tf3svvuwzdyab24piyfirt23mz@uclls5yx7y6d>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lxx3ievmo7icudhyniqxxfu7tf3svvuwzdyab24piyfirt23mz@uclls5yx7y6d>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 17, 2025 at 02:37:02PM +0200, Carlos Maiolino wrote:
> This looks good, but I think it's worth to add a:
> 
> Fixes: 080d01c41 ("xfs: implement zoned garbage collection")
> 
> 
> If you agree I can update both nitpicks above when I pull the series,
> otherwise, feel free to add to the next version:

Sure.  Let's see if I need a resend for another reason, but otherwise
your tweaks look good.

