Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058BB22F16E;
	Mon, 10 Nov 2025 19:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762804258; cv=none; b=QJMXVdKSc/L499wq9XsvrB8Eb9hVkaDkbiMvb4BSVnxVblKIxUgGpm20hgJlRdF+5I0isOEPlEi4r042DZtdleNFWNx/iQ6k/fSNJviRxJGYH99cIvC4cd7vwXvmn8uzus+jm6fp3W7soggL0Sw0GobgXIQ+YzcBz+RWK0fGrhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762804258; c=relaxed/simple;
	bh=3NxLbzOK6pQPWeOxJ+wxVISR/rXhKFaYfxxqTlzmR0g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hKApLlSuACgi14fAvDe5+/8g7q1cNRvOn0AvyuieByacoxFyturfI0PlYHlv1JCwvw3KrRz1yGK4JiMUVRxlOXgX6jAtETL3867FIEqDEeOASTbCAi/A9zCpdD3JzMxOVS6HVd84I+8eHjSg0zTcXWXxZQAE+BJuFgkuSosv5jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=VkfigeL7; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="VkfigeL7"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 1CE1940AFB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1762804256; bh=X1hAUoPbaMDn/hVezN7Lq6BnoNMyq+L9B5N8wjAWho4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=VkfigeL7KYc8ETrkLftTmxxp/lxp5YOpt8VstGM40piGOUKi6sd4ZqugSpx2qsD+z
	 T1TRCaBf+K0YnhAfbuaprWTIz7KyWY+2CoNDnmMGT3Pg5f8rNW9TPDZN9QJl4dZorY
	 By54it9ZuLy33aseWuWzVCiPgkQWmpVGyRCGH12Sj0io1GZcWgkPkr/QH9TbIVyHRR
	 ME/AtIFm56DrPquewSlo1cRwX8BmPv1qt1CCcM7oiuMN5ACGoHkdXuLudcD7Ugm9Yq
	 8KHFO1X8DGc10syNuz/Zq6pD4tehbLo2CY7d8P150UlBjaov6BOGgR4oafHOMp8uRT
	 lrB/PT8tlueKQ==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 1CE1940AFB;
	Mon, 10 Nov 2025 19:50:56 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Gou Hao <gouhao@uniontech.com>, cem@kernel.org, hch@lst.de,
 djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, gouhaojake@163.com, guanwentao@uniontech.com
Subject: Re: [PATCH V2] xfs-doc: Fix typo error
In-Reply-To: <20251105013506.358-1-gouhao@uniontech.com>
References: <20251104093406.9135-1-gouhao@uniontech.com>
 <20251105013506.358-1-gouhao@uniontech.com>
Date: Mon, 10 Nov 2025 12:50:55 -0700
Message-ID: <87a50ty8dc.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gou Hao <gouhao@uniontech.com> writes:

> Hi Christoph, Darrick,
> Thank you for the reviews. Here is the v2 patch with the commit message fixed as suggested.

This kind of stuff should go below the "---" line so that whoever
applies the patch doesn't need to edit it out.

> Subject: [PATCH V2] xfs-doc: Fix typo error
>
> Online fsck may take longer than offline fsck...
>
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  Documentation/filesystems/xfs/xfs-online-fsck-design.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I've applied it, thanks.

jon
