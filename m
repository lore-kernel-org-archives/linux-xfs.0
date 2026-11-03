Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693752;
	b=JgJPZT7XeXg+tqHZYNknFwX8998F9Ipntq/Zhx5xl9BzquNe31fRDVUrIH6O+9i+cM9Q
	 iMIcJdAZsLzpYStjM0P4TFuMMmzF2wTwee4p/caIZ1HfDzfsmTRNvFy/09TiRHtLntoDV
	 9YX71D8tdS8jLMGeJ/y1tV5O8WgHcUsD9NkEFPcf+8RiiJ3DTL07Mufl7zVKsO3JCErxy
	 h4UrprU9Zz7B3kPWWVhxT6GxiNCKuYD6+zWUjOpYEnrOcbAm9E0IwcvvFfZRfwnOhyIkV
	 WB0hpDLdPCpcs8VnPLBCAo1299X4FeXJp3YNTSckI6xanMcGLkXM6zaqLNjEmDCuxKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693752;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gHDSfJqhVoMZ/3ap7h8vd+jbebAPpjHCB6dvMe7GO4U=;
	b=00sVR0BREOvhQ1rkAVK228TsMJeuTFXwz09/FFetegrJ21BgbqXWPRntLNMfVgVmq6jc
	 XqXyvZAC+hcWgEpcz3ZNRxm+OLHeA4Y13WZ5Ahs1alNbdMghHFOTrBwYg8Hwf8fYb+Lrg
	 RzyRd7cl5nm1raw81JE8B0ItHSIRy2nW9A5yIyYNDyCy5J7iqtxrck5TSIFtb+e3Lv5S9
	 hAr5KbmMSfjLjTUybsZG1vhYc6ap0L1xIDULTgPncDdMGcUVRguEkVAlwaGd/+ahijDmj
	 /Ns6wH+gheNnXUM2ES/ziMRi3/PvivLqtkkV8rMU4yjoiBSoLMg9bE9OItq7L0KM5ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IJeVmWGH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C027606A32F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 08:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IJeVmWGH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A0B1F000C1;
	Tue,  3 Nov 2026 08:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693751;
	bh=gHDSfJqhVoMZ/3ap7h8vd+jbebAPpjHCB6dvMe7GO4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IJeVmWGHJsvVXAmJv2k4Xr+KcJ48woWkJyYRglWsGI2EWiFybLJI0Kvu61dkTgapK
	 yTcsj7NgitDtGAxzWd+rskwEUMmC9w6XZqchG2sbPfbl0mgNZwWTBk87mKai4yggtI
	 7c967EFIu8Z7jvjAJSISVNgcQ/4snWy2/BJ8AONo7Fj2ePSCnuhpYkZrIBiP9FZT5d
	 ToclFt+yxnTTnaqGq7kSa3aUPspgn10yUKK5tdb0T1TJM1hbL/uZ694/BqusMgzP5L
	 qlqfS63qTb8N7KXhFzThbOArGVVjuiW6a+fVCcD2em9eYKLtIbQKdlAxlvrf2Q8iC6
	 yj9MrexSAQg6Q==
Date: Tue, 3 Nov 2026 09:15:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix recovery of partial attr removals
Message-ID: <aumYJ0oQRtbSByEN@nidhogg.toxiclabs.cc>
References: <20261028081125.2209827-1-hch@lst.de>
 <auh1xhogpIaw2d5t@nidhogg.toxiclabs.cc>
 <20261103074953.GD3678@lst.de>
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
In-Reply-To: <20261103074953.GD3678@lst.de>

On Tue, Nov 03, 2026 at 08:49:53AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 02, 2026 at 12:52:38PM +0100, Carlos Maiolino wrote:
> > Uff.. I think this goes waaaay back, even before CRC?!
> 
> The logic yes.  I don't think the bug was there.  The other interesting
> bit is that back in the day the INCOMPLETE flag was only ever set when
> removing a remote attribute.  I think this made sense, as there's no
> point in setting it for a local form one.
> 
> > Giving this wasn't a proble before LARP, I'd probably be inclined to set
> > a Fixes pointing towards 1d08e11d04d2.
> >
> > Not because it imminently fixes that patch, but that the broken behavior
> > kind of started after that. Cc stable probably v5.19. I don't think
> > there is any point before that.
> 
> Fine with me if no one chouts.  I assume you'll just add it?

Yeah, I can do that for you assuming nobody else chimes in.
