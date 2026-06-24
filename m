Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E135337CD3C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782320999; cv=none; b=XKOjGHaosJGbszpjl0Q8HjI6tmdc/qK4GlXHPOy/cEz5PAFenvtSQvYsD6MG/8P+Uz2QucDJz/dwv+deTDQLxOocSKEA4+omPivGyvgFgFiAqbw89pVzX1NOVda5y6n0hJ+ZU/Sljfy9iSMQWZ0BKts2Hv4TcxmDt344nf5WF6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782320999; c=relaxed/simple;
	bh=XuZ6zvm+BciqaSSsKLXYYGsBI0GKXATbOEQJow+16uY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmjVLpoWZAGq8S5uQQfY+V5whL1TPTCZ1CCCa/dCDqpYoIdePMazJ+cqPY/D5RcutqB10Xzsijx+WfsuC83JD1nSQx7z46r3zQYMe3sCZcN4LgpdwdAi8IUmlZ2BEZ9WFp/4rmyBzmIQQssXRLKSdhx/emLV4V1aXHUJJXoEAcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEMpcczS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEMpcczS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4031B1F000E9;
	Wed, 24 Jun 2026 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782320996;
	bh=AJ9EQRYcRIjkupzFbedGf2/HUWNrq9PopkwwhXUYz/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SEMpcczS4ZfuHatnMXuoQPAeqb0fVe/pCfHchHsw2k0e3GzBk1hjxSDa9zcg19jom
	 dmwbUQOLywOvUSKPJL8LWxlLFBPCsg0pdC2MssHL8MQhQwqI8NE7F9Eplrx1GURuJe
	 yLBXGyg1zN8gwkHSfeEB2V8tNYq+UtiVbqFtSA/ByxU9oTlMVq0Kz/I5i4ugAuzgzv
	 3NPxHPWlmjgtkHJ7+1QlRQsZk18hiAxcVWqqnhoAsqL4QXr9plbaRtdFINXjbcDbZM
	 gD/6/VjMGscX2pnz8duBa+IM1xEY23dW/rs6gXoCRus5wBPTmGYyS8IWAOcU3fLw5W
	 VpjuVvgbYIMYQ==
Date: Wed, 24 Jun 2026 10:09:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuh <liuhuan01@kylinos.cn>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: remove duplicate include of convert.h
Message-ID: <20260624170955.GN6078@frogsfrogsfrogs>
References: <20260622024311.26681-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622024311.26681-1-liuhuan01@kylinos.cn>

On Mon, Jun 22, 2026 at 10:43:11AM +0800, liuh wrote:
> The header file "libfrog/convert.h" is included twice in xfs_mkfs.c.
> Clean it up by removing the redundant second inclusion.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index dd8a48c3..64e8a6a6 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -15,7 +15,6 @@
>  #include "libfrog/dahashselftest.h"
>  #include "libfrog/fsproperties.h"
>  #include "libfrog/zones.h"
> -#include "libfrog/convert.h"
>  #include "proto.h"
>  #include <ini.h>
>  
> -- 
> 2.43.0
> 
> 
