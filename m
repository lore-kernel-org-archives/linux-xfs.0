Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC00E20E334;
	Tue, 21 Jul 2026 10:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630713; cv=none; b=T2Fowszw62glbqntRSKNrcMf/LI6ppCygV8OoomQyK7TGpuPEWZyaTw16NlsjmYguE+44As5DESFq81fZpLlI29P27cAPtrf/eRoDzjO5/fq28lWPs3TEXjZ3ljF8pk8jgKWWG3LtH/vfRrRLcz+dcSFQtM7dcvSvLGJddmLa4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630713; c=relaxed/simple;
	bh=DB/NE2LVwCm9qhXHU7Mr42jRyFJY5WmrVDAPbskDGI4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oF1/pq7q7v6I4D0gSgjxZCTcEYx7GLyHBuj7t9TaezNEeX0idy3blZEjSHd/ZdxxCFeRMM6TOV3iBCkJcSTht5QXDa6CpnZ5Hm0eaFLMGJrJdY1DQVwr4IWuTuKyU1KeXIvMAA7MsNPQ5lUZoDlsD99AkMxVdUqOKEcI3lOotCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tmjl8pRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tmjl8pRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6901F0155F;
	Tue, 21 Jul 2026 10:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630697;
	bh=jJnlVRreKDBrxmLILlAYFGS4xSEfO/Pl3sPEh2YQ+z8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Tmjl8pRpNhrPZ0d1iFtzgISErSJeLJHTqYEfiMN/v5ZA3GI81I7hURB7uf04YXZD1
	 UvGlnp8i2ynqnbZKQzdfu7vQketO+zXfPOV5l2dRXznDoxpBnYdPn9QHxJdoID+jGQ
	 gp/I2tox98O2GjBO62BOLictw11garpe3q7wmQ8cdZlUD86sO2diWXaPbWY0wH6Col
	 TdTmjNw9zspXlFdUb/6/WbZdj4vUxTzH8WHiiZchfH6x4SS2CJzrHF820fotfZSZQs
	 A8cN7x0y+wk/zfdWY7Bz/4XyIOni2HvshiX6IZ2nrKpM6h0Ws8wETWrgRzGgSBzQzA
	 wx+xUx9vIYamA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Filip Blagojevic <filip.blagojevic@wdc.com>, 
 Matthew Wilcox <willy@infradead.org>, Damien Le Moal <dlemoal@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260720140849.2269776-2-hch@lst.de>
References: <20260720140849.2269776-2-hch@lst.de>
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
Message-Id: <178463069559.324722.16769567501803840266.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 20 Jul 2026 16:08:47 +0200, Christoph Hellwig wrote:
> When using XFS with a main device on an SSD that stores metadata and a RT
> device to store data on a HDD, we fail to take the I/O sizes for the RT
> device into accounting, leading to up to 5% slower read performance when
> using an SSD for metadata vs storing data and metadata on the HDD.
> 
> Fix this up by taking the RT settings into account at mount an restoring
> the old settings at unmount time, unless the BDI settings have changed
> from those set by XFS.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: update BDI {io,ra}_pages values based on the RT device limits
      commit: 39de8c9f3e4bc059bb0bc85a39affcf52664c1ed

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

