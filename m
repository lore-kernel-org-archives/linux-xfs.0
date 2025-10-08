Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A447285C91;
	Wed,  8 Oct 2025 14:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759933973; cv=none; b=a6iJfrtkfHV9ZNRKSP0/lQf9deS3rMlYI7BERZQHyHjllvCUciRrRQspFTJCqTYOO+ExL+pXajFWKRUEb1KnpSBvP9DX+9gwsV1XSKPMsi4RrFGNHnUERG0K+4maB51StGOUc0ImkmLvC0LsxTGlXr5gWhjU8T1oFrCxjzpqnMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759933973; c=relaxed/simple;
	bh=MA6hkKHaul7hn4yYbTdalAKIDdkaqLokPC0jQdJLmto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlRX8E8G2WLkqlorfZi2KKzs5yid4dBuC82eaNZXynJULdyO9zC8sGN2kGdwL7liMLYjS4NPecAtwqyvJhTP/w+0+11+xtiSDSXohg3WNpHUYCL5l9Uy65TTN5RR14SSIgVvS0Gjw3Z1Le1SycYJlGgQvLaH2TsL87Qoag0heIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYmvyAio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYmvyAio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2D7C4CEE7;
	Wed,  8 Oct 2025 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759933971;
	bh=MA6hkKHaul7hn4yYbTdalAKIDdkaqLokPC0jQdJLmto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jYmvyAio4j3p2s6BGwVGe4QppK9+kIOWJQ3KymKfJfbQJ38WKErcdKbLxDWNnbWKt
	 JpsrBJ6whAo43NEmB/NAbdrMCbuBmC9IcSCSJ6cEipQARR/8dTJCFpudrdm7Lq/tt/
	 RVT5P1XSF5hfBMHCv/tSbTX3BwabZRhVcaXdfwuAoEDM2gczfSI3Yfm5dx7jHf7ema
	 yW9acB5e2Y2OGNzW3w8XNVbRQPoIzF7nVLz4qN8Pv5GNhlEZsCR+nL6LvG04fqFi3U
	 ZYWvvNuYpoRM3As9nPN9BDnYlycGQRtvs1JZt+VBim1Q+tn44/XhcVULvg2d6wR5yP
	 1tj92MemNHdCw==
Date: Wed, 8 Oct 2025 16:32:46 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@lst.de>, 
	Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org, 
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] common/zoned: add _require_zloop
Message-ID: <z2xxqinggezjyzxja5dbbxv7vse4vj6yokjsmgqnz3beocakzn@aijc76tkhc5d>
References: <20251007125803.55797-1-johannes.thumshirn@wdc.com>
 <1yn4r4LE-EcilzakubeTd1wvm4GRktTqOkfFO2h3NnwiVa3rZ3kESiYW3x8kjmQEh-rCklWvyXT6kin8D0TlYw==@protonmail.internalid>
 <20251007125803.55797-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007125803.55797-2-johannes.thumshirn@wdc.com>

On Tue, Oct 07, 2025 at 02:58:01PM +0200, Johannes Thumshirn wrote:
> Add _require_zloop() function used by tests that require support for the
> zoned loopback block device.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  common/zoned | 8 ++++++++
>  1 file changed, 8 insertions(+)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/common/zoned b/common/zoned
> index eed0082a..41697b08 100644
> --- a/common/zoned
> +++ b/common/zoned
> @@ -37,3 +37,11 @@ _zone_capacity() {
>  	       grep -Po "cap 0x[[:xdigit:]]+" | cut -d ' ' -f 2)
>      echo $((size << 9))
>  }
> +
> +_require_zloop()
> +{
> +    modprobe zloop >/dev/null 2>&1
> +    if [ ! -c "/dev/zloop-control" ]; then
> +	    _notrun "This test requires zoned loopback device support"
> +    fi
> +}
> --
> 2.51.0
> 
