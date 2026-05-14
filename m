Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8C9410D2F;
	Thu, 14 May 2026 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769935; cv=none; b=j4WGq2I9sq9Ny9s0AeWbp6VnFAbFVgkMjb5dQUCdzN3c2WUuYC+0AXaVPiA8Q1IxZFtnsrZCBqDVSI8WTpI3Ro+YQS/o/MLZ3KtjPd4lJt7gKysHkzTbojrrM7+6awwq2fb++QJRn79XYE5thFeY7h+hyr5esGDq4XdIn8cDp1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769935; c=relaxed/simple;
	bh=2qZuHfbfe/Z8WtjdkV0iRt3axSD1dBb6MqNL3sxzrzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YIgTa7hxu9NsI8DsKbYxrZfZKqQ+5FEMHAvFkO+ttby1sKwdEwT2zPy7bvgSMwqKhuGnBE31/xOWdUb+ZUgOxgQaCKsbSQHit8VW9PM8zWPoQniB+BZyS16DI1dyqiBwZOh6Hm1cjdoZTPWyHX0m/9LHm/BF8rZLAxt8VXn6Dp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CyKePlhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CyKePlhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D836DC2BCB3;
	Thu, 14 May 2026 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778769934;
	bh=2qZuHfbfe/Z8WtjdkV0iRt3axSD1dBb6MqNL3sxzrzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CyKePlhO8KfKKYjS+viJglQYn9fTTlpO7vQKlmu3OYg/JjWQIv1o7cClvolAGqeN4
	 k20ITN10g0R1N5rGbSlmzG1JDUXXTS7NRGlSOuOacn7WjzF/tpVnmUVFCFtP2+FXGg
	 3/6FODIA3WsUzNFWO+5xDPKbJ9YpaOLHM4adGcbnNQbDCR0lZtKeLpH62CUzXELQ3U
	 fvceZDVsOwnd3Wt7C8QnI/qGCIKGgsoJtb6qOHoez88Ksib5YZsJuj2EmNFAj0kSGW
	 3/iyVXAfl9fwdztT8Fb4ltVFoPeQisz3N9X7gLQr7Cco+KfghTSOby6QNcRSPjU3mX
	 qPjnKZUEubPbQ==
Date: Thu, 14 May 2026 07:45:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] common/rc: Add helper to calculate percentage of
 free space available
Message-ID: <20260514144512.GX9544@frogsfrogsfrogs>
References: <20260514113910.866888-2-lukas@herbolt.com>
 <20260514113910.866888-4-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514113910.866888-4-lukas@herbolt.com>

[fix linux-xfs cc on everything]

On Thu, May 14, 2026 at 01:39:09PM +0200, Lukas Herbolt wrote:
> It calculates percentage of filesystem available space and returns it
> in MB. This helper will be used in the following test/generic fixes.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

Looks fine to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  changes v2:
> 	spelling and description
>  common/rc | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 5fe44e2158ff..9fc733ebdcf4 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6189,6 +6189,16 @@ _require_fanotify_ioerrors()
>  	_notrun "$FSTYP does not support fanotify ioerrors"
>  }
>  
> +# Computes a percentage of the available space in a filesystem and
> +# returns that quantity in MB. The percentage must not contain a percent
> +# sign ("%").
> +# usage example:
> +# _mb_pct_of_available_space <mount point> <percent>
> +#
> +_mb_pct_of_available_space()
> +{
> +        _df_device $1 | $AWK_PROG -v pct=$2 '{printf "%.f", (($5*(pct/100))/1024)}'
> +}
>  ################################################################################
>  # make sure this script returns success
>  /bin/true
> -- 
> 2.54.0
> 
> 
