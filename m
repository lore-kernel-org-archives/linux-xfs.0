Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D7C2C028F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769594976; cv=none; b=LtjJBW5D14BGWoyHdTTxCAMvAvYo5JToeFPswqZwsZkcZajTTm+XdFju581RXt+wOO84fQecd78zPoYBgpxMWrsyvBto20/7GH08/rp0au3qcs8RvDqLCiAw2Phywae3CbhTcl3Uox9OBWMjzNTQ0XmEyKEjZPiVKp515hQcY70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769594976; c=relaxed/simple;
	bh=1DJm8hs9H0jKhmqZ6X/Yr3oGRM6JlWHyZ7wl10JgoS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mchw1kF8qQM96PIRpVIZ9UJioMIh2AYnZlDDnk0e0zEgS54M5i5JpK4tu/c0UIPf5YXO0vlMh3yfPBHkOp/Kc7Wgr364AWo5MdSi2yzUvgJh5k6SzdsXK4ncmSruxu/6kvVaRvlDB5kbIzZs11xKyskLi7SmlNx22mZUv8b0QMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOUz/fdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOUz/fdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9899AC19421;
	Wed, 28 Jan 2026 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769594976;
	bh=1DJm8hs9H0jKhmqZ6X/Yr3oGRM6JlWHyZ7wl10JgoS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SOUz/fdfrGoF6wC+b1UGsqg7SKnWc59wTxcHnEhLXmlGaqPFH3D1IMJJmdZaImHTG
	 jMEaX7Nydq0WlhYMxJg4XgaKgCty6qxudgn8b1YyCsxEMmi+8pCx1T6wuoeQ63Vj0O
	 QC5qWRcmPT5J+eP/si5I6GgeDpWKf4XvSULSSqKNQ8xetgPoMP7XOjna4XAf+mJw9x
	 iK4MNLEwcJm12DoL5oeaZakG1Wqz10nNusJsJ4Q/JSyxPiBKVr/II0Gzz170giP0mW
	 MQ8ThkqybQp09iWZVo40ACQ5IIFlZVrbm7OEZJ7Y27nagSro0bw/5HU0yTUb0oCwQH
	 e3T200F9CPw4w==
Date: Wed, 28 Jan 2026 11:09:31 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@meta.com>, Keith Busch <kbusch@kernel.org>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use a seprate member to track space availabe in
 the GC scatch buffer
Message-ID: <aXnemInJ6bkOS5wL@nidhogg.toxiclabs.cc>
References: <20260127151026.299341-1-hch@lst.de>
 <20260127151026.299341-2-hch@lst.de>
 <20260128055622.GA1925@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128055622.GA1925@lst.de>

On Wed, Jan 28, 2026 at 06:56:22AM +0100, Christoph Hellwig wrote:
> ... and I clearly can't spell "separate".  Carlos, if this goes
> ahead, can you fix it up?  Otherwise I'll do it for the next version.

No problem.
