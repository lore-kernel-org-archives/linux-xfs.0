Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2597B366
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 00:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711412116; cv=none; b=Ql8ujfgQ1d4yTgyKS7tuZIoq4N/ZWHepBtEiOqL/0cASa0m0UxkUiDQ3h0ycCr3SfKNR9k9E/i6RLIVNr3ofKuhjYLiORLxJ1mZLc2BXSMIpFEHFNkE0vZG+YvWKn/g2SttstRMgCfXp6IBdS9FgHU9OaxrlJYUc0lNrsEu6BVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711412116; c=relaxed/simple;
	bh=gURvE797QnZrqh66mYPXVCubuukjQ+ByPkXPaAgRfMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eULjIh+1+GyG+Ebr9RZOppV2u5bfvKLYnvtAbziNObVaCN2KyHFCaqEnOuDePp6kyhPX7KS9WUUFR/Q74eCXAIGTJvV2jTxaeigGGI9rqL+2VSh3pQlEi1kP4fUkpmi0V5pHBDz8AyYlt+ozj0lHto+0tXBnSea0SLHrJP1wMIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjIPxP81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjIPxP81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97032C433F1;
	Tue, 26 Mar 2024 00:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711412115;
	bh=gURvE797QnZrqh66mYPXVCubuukjQ+ByPkXPaAgRfMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QjIPxP81t44TtUKD5ljhFuhIti188fNE2QwENweOT+LZK7cUKaQJKmRaPXWGdQfVM
	 1P+OvUnJImI+7ablFY0Z2OxA7FkpAP7BtD/j86AmxElQgzwHwLONDwSMctYgILBrne
	 zSaDbPPcOTX+n/N6/ZeEVqCm2F/IpK1lRt8a9bkWXswE0Kk2eS5lz6YZg0oHH9Gqbw
	 KqgBrNswPCGHWVcwUhZQwZI/ScqCDh50LyL2N4zifXVHAIp2Qnxm7L28rIfRiVg0ue
	 1tEgW1cXVN40z3/Y4k01LlTXcJ4OWIZE143nIpTQwj5OC0CA+HSHeC3KoNgMIXI/F3
	 2kDI/J4zvcizw==
Date: Mon, 25 Mar 2024 17:15:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] include libgen.h for basename API prototype
Message-ID: <20240326001515.GD6390@frogsfrogsfrogs>
References: <20240325170941.3279129-1-raj.khem@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325170941.3279129-1-raj.khem@gmail.com>

On Mon, Mar 25, 2024 at 10:09:41AM -0700, Khem Raj wrote:
> basename prototype has been removed from string.h from latest musl [1]
> compilers e.g. clang-18 flags the absense of prototype as error. therefore
> include libgen.h for providing it.
> 
> [1] https://git.musl-libc.org/cgit/musl/commit/?id=725e17ed6dff4d0cd22487bb64470881e86a92e7

The basename(3) manpage makes reference to glibc's POSIX implementation
modifying the string argument passed in.  Is that going to cause
problems with the existing callsites in xfsdump?

--D

> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  common/main.c    | 1 +
>  invutil/invidx.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/common/main.c b/common/main.c
> index 1db07d4..ca3b7d4 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -16,6 +16,7 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> +#include <libgen.h>
>  #include <stdio.h>
>  #include <unistd.h>
>  #include <stdlib.h>
> diff --git a/invutil/invidx.c b/invutil/invidx.c
> index 5874e8d..c4e2e21 100644
> --- a/invutil/invidx.c
> +++ b/invutil/invidx.c
> @@ -19,6 +19,7 @@
>  #include <xfs/xfs.h>
>  #include <xfs/jdm.h>
>  
> +#include <libgen.h>
>  #include <stdio.h>
>  #include <fcntl.h>
>  #include <unistd.h>
> -- 
> 2.44.0
> 
> 
