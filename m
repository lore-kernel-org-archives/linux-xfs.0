Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793625362;
	b=I38WfeqboWhVd2fmTTnqYt3xE46tddSheoVyX4mv16ECFGvfcsEglmpBZBtkGhCf9GZK
	 4h4bUwYO0gQawq/KKunfe48DjOKXF1229awjYe3kfCl/BPnBTELRDuEI06zgCa5ntdMx9
	 xXKl5UJqUwZUAhwSDmc5iKGGZvL6sS4HvHJPh88qyYy4Fq6ux7/YEehgKWghoKFcy4hgD
	 VKhSKVMi/6WNU3gxFPn8vEroQ1j1boGUao7Vw4WEMba1Th4ix49M6Qy8T+X+TDR7899hW
	 jzGThqGzbKB33i+Kf5UC5bhb5anYkIAlzCJbqV9YxBO9OQ5WL5qGUck6aQE0W1T2YIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793625362;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=hr2xIU6xrmK268e2tjqyWaLuC6iXaAu71XJKefrAu64=;
	b=lWQAg5eztuVjOnKrQ6Xa20pGItpSOPBQmXunY2dNtErI3y73uWzgx6wPNhNM70TiREY+
	 NikfH6PUDnJ4ywUAANhu5xZctG67fh7/Dw/sEo9OYfgktdwqBFqDMximfhITLzZcc7ali
	 aMwfQM/2cCYk+P9pdt4FpqygE6UAv+EdLUvi5/1Zb/sx0Pu7OP9founp4Q8ZnsZhdfhvD
	 P9aiirzRt4ozAQwdiQwGxqh9MlcVH5f+e0Rg5CT7/cXekOMFuOnSPnVVDe1gT4kk2QIxc
	 7hrKuH7LyaJx8HQllnBisKb+ecf0hWmOsIYmo34OCK70eecica3hXVNXEObmjm5zf6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F2Yuctrv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BAF606A326
	for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2026 13:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F2Yuctrv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDD91F00A16;
	Mon,  2 Nov 2026 13:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793625361;
	bh=hr2xIU6xrmK268e2tjqyWaLuC6iXaAu71XJKefrAu64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F2YuctrvNhTFjvkzdACn2MSacCw1XFiTc0Gqo1KZZTQIMPsmw6q7ViVsjtEpwGbUD
	 lzsFo8tIYcieiCT6Z6Ryxh0bTooR9XAtwWAWOKUZJOuDRkMrTONuajXXKnLww2LKc4
	 ZOO1fagXsAEC0zd1KJRXHZR8eHis4PN4wpDVnUs0yFN86wLOtOMbtV/1cFAzJ3g6rh
	 UR/JKaj61pKo27YEoMupiywv+CdvAeTEOxUVKouc1m2n1sgFjmaxe+RDWA2JOBd5u0
	 SUcg+SSCmxqz/YuAgkn2NsbqBYJiKEIFxQEsVbN0IlivALn50aRX8Ro7sL7eujahtQ
	 urahDCjPnooGQ==
Date: Mon, 2 Nov 2026 14:15:56 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: fix libxfs compiler warnings
Message-ID: <auiNBtY1AUlrljhy@nidhogg.toxiclabs.cc>
References: <20261027154237.1997484-1-hch@lst.de>
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
In-Reply-To: <20261027154237.1997484-1-hch@lst.de>

On Tue, Oct 27, 2026 at 04:42:14PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series has a few fixes so that xfsprogs compiles warning free on
> Debian unstable.
> 

For the series:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
