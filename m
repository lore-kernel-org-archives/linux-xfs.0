Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C17F19C54E;
	Fri, 24 Jul 2026 06:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874196; cv=none; b=pDw2Q1mqRwX9Z4nSzZtvKwjuTntsYm/VUIeBlp30w0pD/YjxJPlEl8En0y9mXOOSUBnj0TFFP+j6mPXA9MDob4Ex4pARaVE00rxPMB8+91bDusF6MAM8TnEPHuk6f87fiEBqSwRPptUOu1BR32gRdPcVxxWNiaac6P9fpz6hnUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874196; c=relaxed/simple;
	bh=WS0+YnHEvOlREHQs0pQ09zAvODOmye8WAmyk/tfagr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O//eYNGy9kfDnv/qn48eFdauuGdwn/JogBtjWUU45q2o4Ha2sCzXGij2Kp3m7BfMX6TCufogTJiCz56XbQVEJJQVU5Y18jYNAejCu/q7GJaslmMhcFeK34Dsi2oW3ng1h1LZHyvOuITHmvpVM/0a8YDrkeuRds0I+N/eht74rts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C08C68BEB; Fri, 24 Jul 2026 08:23:12 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:23:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 19/22] iomap,xfs: move integrity verification to the
 file system
Message-ID: <20260724062312.GD4953@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-20-hch@lst.de> <20260723210216.GI2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723210216.GI2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 02:02:16PM -0700, Darrick J. Wong wrote:
> Sounds good to me.  I gather the idea here is that direct reads go
> straight into the user's buffer, and if they're evil and mess with the
> buffer contents during the read to make the PI verification fail, we can
> then retry the read with a bounce buffer out of spite for userspace?

Yes.

