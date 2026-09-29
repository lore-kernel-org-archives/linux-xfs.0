Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA025437FC;
	Tue, 29 Sep 2026 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790695473; cv=none; b=Osvqkb4qWWhhqLsGw0QhmwQab1XMjhxIt6/BqyNvFoySe11EB7NFftmeHuL1nIBMSBszSvZjHyyjppMxUn6Xm9TyD2Aip7GAdgAAqHxH4LhbnBqwdvIfACRE3pDtNjpphSYNLQ2tTojBuczTNT8F8NcgW+1gDht/48iT00Srq9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790695473; c=relaxed/simple;
	bh=NJWaAHGwqRuvhgUYsL5iRl6v5EPp9UWX3pSpWkN9o+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rt8Q1mlduzYm6u/wWh6cvWz79Pi0TEodQq1wq2tno3dimhuYB4WTy4COtpvG2Drj47p8clr8gwtGU0/11ePp9fFEp3Oj4Vf0Z9whgYmr/RxPa6vPx0G+dA7SPehMQKuXW01ity2PZxbgB4wOP5O4QcnskMuGcaiehob8DIqKbRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBQesqE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBQesqE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247D51F000FF;
	Tue, 29 Sep 2026 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790695461;
	bh=z4vAsBXA6xuQ/4WSe/djhRH2thpSynsoQVTtFtD+KeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bBQesqE0vzABBGkqG1upJOuKRy/WK2y6Y+0Jpx4fontXELKoIvtt4WFz9F3G4CSEA
	 kMwT/utoc6ES8wHTGMV0NJEXSoedCZdZ5mFEVofr8ZafCEJl6TGozXgzGyAWNN7Qgw
	 0gQdASq3sdmVU9tt4AGSF/rEUn6KpRXdujER5KbmKPvFvMP9ByKGrv9A1xTZ0AqKpr
	 F1F3KKgkx7O3+tJmIIzsKa6yXgKYfuiFyO1FSiVErN7vspqloLoV7OFffE0YKSWK+l
	 7kammpG0d1cTrpw76x3pXsipqi0Evx9typRinHabfWtC9IMEBRuYhzR9G+LrwsYjQJ
	 spP9MdcLdExFQ==
Date: Tue, 29 Sep 2026 17:24:18 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: use bio_complete_in_task for buffered write
 failures
Message-ID: <arvYEMNrsM02-JzJ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260928091111.3986811-1-hch@lst.de>
 <20260928091111.3986811-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928091111.3986811-3-hch@lst.de>

On 2026-09-28 11:11:08, Christoph Hellwig wrote:
> Use bio_complete_in_task to defer the bio completion handler to task
> context instead of the homegrown deferral.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
