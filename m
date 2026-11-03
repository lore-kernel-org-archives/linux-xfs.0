Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793684602;
	b=XLdxp/aK929eegKcVZtx+QUZ+lT380tc48XTdzgNfeW8j31SoaVWd/tGuB9+o2Fpl4hM
	 t0XmuLV0yXevs9AIcW5JFMcWjsw2x6L4J0jca0ALhLFgWjF3NJzDv/eiq6Lbou4SIkSwX
	 +VqlQQVRUIqrnmSAdpmfnllg+UbUFbl/bOsNvt2MZncby20/apgucvqqyK7jSI1ZVaC+/
	 ADnIMVVUZY0L390J+D9EuZBsXxNMW2AMDmdTn3xXPOQb0pzZoBeIRbd4fZFi6X6+AQG1a
	 QiyZYVsrC6SqGK9pq4pl5YriJm0LUH/GBUf8Yqc26wbzls4igUPXyL9n871UKyJxvEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793684602;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=s3Azl86xQ+8gB0JxjiF6IuRVj09NJiywincqOwAL5rY=;
	b=bhbmYHMDuPHVqpifbgjcogYtTiHARwWKz1amV8/8jsqXJRjWZVnqdCI1Ecu4cfU60JC0
	 M7oWUOwDA2orv045eWt+GpR6kJNfYKwcIcUXcngGyi6/yDffDv+gmTA1KiZ4Po2VX25fl
	 Fcbzp3/czp4ehEpwY+LBBzuZi++EjEg/FKOTkFhmup7DC27hLkQ03lEHxfqaGOh6lIH27
	 utq7NGEgdMsiraGiitjvBH0is5SAbpz0Ju/QsHuYYO95i9vlWcAGwnfSIBrNNzztL626y
	 REhb8jnTqO2RZgn+lHNUzXTymP3nC1XwbInilxeQcyFompul5Rj/1FlBcZgI7yxZSgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B71606A329
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 05:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28B71606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA67768AFE; Tue,  3 Nov 2026 06:43:18 +0100 (CET)
Date: Tue, 3 Nov 2026 06:43:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: fix two warnings in xfs_alloc.c
Message-ID: <20261103054318.GC1559@lst.de>
References: <20261029161027.1213438-1-aalbersh@kernel.org> <20261029161027.1213438-2-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029161027.1213438-2-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 29, 2026 at 05:10:22PM +0100, Andrey Albershteyn wrote:
> There's still two warnings in xfs_alloc due to unused alloc_flags var.

Looks good.  At some point we should look into converting these stubs
to inlines, but just as I didn't quite want to jump to that with my
previous series I'm not going to force you here either.

Reviewed-by: Christoph Hellwig <hch@lst.de>
