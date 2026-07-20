Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C139F2D6E6C;
	Mon, 20 Jul 2026 23:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784588864; cv=none; b=cS5jczZhWneOQ5UXTRSHiImkssITYLyyGhIOVTH3VcwQ994j9TvmtgO9VaY+3jMSJDEn4LStnGC4l5CgJJN5X33zIFoh8hznn5N58IY3ao8RJ3jLBwPbpAtzx/GiyJVVd0gtNSKJoLhgbuKgxQyGX9RyfoX+gvBsM2MUnaEzXc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784588864; c=relaxed/simple;
	bh=bzTZMhlAY7qsmrWmOeFX3q3Gnmu/VG+BYPPg2Dgny04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IfwqA7VYYmyA0ci2O/7n4tWSj3scFMbzh7zM2SKQ3CPEbL/YYE3CMAmj223eVytgPNGFdgLC0u3NZzVX+/rbH2deonoGP+gaPSnHf2Qt24jvloWH7k+0U0IgwrkFXUnAurMGyKhQpoQIWrWyhruecfWMJQO/zpOeTxKKIzNFRw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEnX/Ccd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEnX/Ccd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7691F000E9;
	Mon, 20 Jul 2026 23:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784588863;
	bh=2WQ7uYV2iyjTLs53PecBKvYJdjDrpB5dN+q5hhyjX9Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eEnX/CcdzKqK3KWB1S+2D4xDaEJPR+xi7GgeRSgDTABQbQ3e/Y+4ulu6KgNeZ4tg6
	 hLEWEAO7NzrisaU2yQ9IAnfX3OeV2MmJaj7imfwARgMvyxRQ5uZw5ivSIdNRf5gShE
	 mGwa/GOPBi+paAaKSLBWo/zjRZ7X7f3yJBwJO7v10Z3IFNmNPcSjhsDODQqTBQO/vD
	 nK0eeKpXu42bgj6liWPIUl5IdpKxpWVQQC9cBF3NRczGad2VZjgefubOPd+f48yTiG
	 DVEfx8URHIgb860DWMOmYGoqU+JXj1WHV4CB2XuCASN2IP1Vpi4xRVRSUyb3s1Nt8O
	 5a+Tl5bFMZKWQ==
Message-ID: <d2c1b12e-c6ab-4614-b851-c42b808fc6eb@kernel.org>
Date: Tue, 21 Jul 2026 08:07:40 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Filip Blagojevic <filip.blagojevic@wdc.com>,
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260720140849.2269776-1-hch@lst.de>
 <20260720140849.2269776-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260720140849.2269776-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/20/26 23:08, Christoph Hellwig wrote:
> When using XFS with a main device on an SSD that stores metadata and a RT
> device to store data on a HDD, we fail to take the I/O sizes for the RT
> device into accounting, leading to up to 5% slower read performance when
> using an SSD for metadata vs storing data and metadata on the HDD.
> 
> Fix this up by taking the RT settings into account at mount an restoring
> the old settings at unmount time, unless the BDI settings have changed
> from those set by XFS.
> 
> Reported-by: Filip Blagojevic <filip.blagojevic@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

[...]

> +/*
> + * When using a RT device some or all data I/O is using the RT device, but
> + * the BDI is inherited from the main data device.  When the underlying block
> + * device for the RT device has larger I/O sizes, the BDI settings might be
> + * incorrect, which is especially bad if the main device is a SSD and the
> + * RT device is a HDD, as the io_opt fixup in blk_apply_bdi_limits is missing
> + * for this case.
> + *
> + * Update the BDI values to the max of the data and RT device to cover our

s/data/main ?
I am still confused about the proper name for the device holding metadata :)

Other than this, this looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
