Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879D335E92B;
	Tue,  1 Sep 2026 08:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250358; cv=none; b=id1WNNoutkWwbhahlRR0hBj9KEkTmCtrzf/kdq0OtubH3jNTl1kou5F1PedbevPLiF5rvptmKUQ+kDrHu4GY7+UzzvkRMKseoieia9aM+RkSPkwtRTpCqlTAaLuFWt6U2CT+VEq2K1DtPINmwrtaRMvffX9nXYAYpd5/f8rBi5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250358; c=relaxed/simple;
	bh=+bi4WYUWQnEbbigkPDRYmSwamoF/90Ny/75J/FqgmHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ub4TRURWVmxrEFs22ic+mZW8vp4+drkXnTpbJ2dihLuicK5anCaj44869nsWJYNCRJW/NvknfGtAe35K7qtKUpfdBAsyr74YYjkiZEK+VeHuLJCGenPxAf5dCzWMpNsRyi3lBjKi8sUYXKwqd6KCOl6upUi09PDBXEEUat6GlIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EEBB168AFE; Tue,  1 Sep 2026 10:12:32 +0200 (CEST)
Date: Tue, 1 Sep 2026 10:12:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/17] block,iomap: fix protection information
 verification with initial bvec offset
Message-ID: <20260901081232.GC22531@lst.de>
References: <20260831064010.2574896-1-hch@lst.de> <20260831064010.2574896-11-hch@lst.de> <20260831175222.GD1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831175222.GD1933798@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 31, 2026 at 10:52:22AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 31, 2026 at 09:39:58AM +0300, Christoph Hellwig wrote:
> > When reconstructing a bvec_iter from an ioend for protection information
> > verification, iomap currently ignores the offset into the initial
> > bio_vec.
> > 
> > This can't happen for buffered I/O an direct I/O to user addresses, but
> 
> "...buffered I/O or a direct I/O..." ?

I'd say:

This can't happen for buffered I/O or direct I/O to user addresses

