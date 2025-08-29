Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2809221F0A;
	Fri, 29 Aug 2025 22:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756506420; cv=none; b=d2r0bXLN7h72E86Vj0f+lnJfa0h2NN0Sa0B1j9ZEkm00RZ2BMAK/cXe+f/285X/pQBhSryTNNm/BI/g2WyFXYZDKEOsZsYVNevMHYSCkz4RToXfKcEBrQlPRdZ2cJxmEnz+Zr0Scb5Y0BHDX4e6AzAxez5X7Z8qX8nv5df2WPn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756506420; c=relaxed/simple;
	bh=j/YdZQe3xJEzwu+XqNX5pywVdgDjPY2BGsWaNYHoG1k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=as+2aMSfy+aWoVHcZMZW9sJVU3luSi3rUUaSIHI419hJVGEhQ8oSEcXCP2zJ/gvixsy/B0xJHrnyVw886g7+QBV7Vfn1r7ihpni6f/0SE/a7Kjlu06ASq4sSnX3UdsgNMMCs75U61lmbM06v3zen64O/dyk43kmMyp8LZceIcnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=eCQac718; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="eCQac718"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A1C2A40AF9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1756506417; bh=ojWBnnTJ/iRSd90zU3DwhKelLYJNMqUQ5zslR9ZTfGE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eCQac718TyN9xe1J0uqFnmebvZmJWkyqWfrYFSxRAw+D11i+QTs8L7zJUFi22Zcbf
	 UPo4pqjHe/VmpvDmo7uFZdJs1c56A3VOlVoW7enXqdSOz8bFa+ZIGog16znZ379W5k
	 eMYEds8BjedI1e7fJwhRGuqhXmWhOcqyB3wJvfiJHNT/2SjdyKIRqgM0TPwlPcD1La
	 3TWDPN3Us5xQXWItHnO7hTuVN/qKvDL5epe2WfBgWHOiKUXhoBRmOjwrxjUv925ae4
	 +PtRBNvbeBQEsduThBqZk3SEF1Dpy0Es6zoJQAbOPRBvDmm3cfpHfp15z5IeMysxnu
	 qWrj5dREelG+w==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id A1C2A40AF9;
	Fri, 29 Aug 2025 22:26:57 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Alperen Aksu <aksulperen@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
 skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev, Alperen
 Aksu <aksulperen@gmail.com>
Subject: Re: [PATCH] Documentation/filesystems/xfs: Fix typo error
In-Reply-To: <20250821131404.25461-1-aksulperen@gmail.com>
References: <20250821131404.25461-1-aksulperen@gmail.com>
Date: Fri, 29 Aug 2025 16:26:56 -0600
Message-ID: <87zfbh3gsv.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Alperen Aksu <aksulperen@gmail.com> writes:

> Fixed typo error in referring to the section's headline
> Fixed to correct spelling of "mapping"
>
> Signed-off-by: Alperen Aksu <aksulperen@gmail.com>
> ---
>  Documentation/filesystems/xfs/xfs-online-fsck-design.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

jon
