Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275F8227BB3
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716224; cv=none; b=UufyCfafNJ51eTHI4OxEV+oh3jqpD5GvyDmJ+DQAkgeC7u82Ie/Yw/wd9wdfDHqij7C1svp4WbRLuDszbWVM+osWzE+mqef9JzgHMtb68OgQ9ejkjIVKQb9ro3nh7fWrb5sGBiZNRfLNBr+/VzpvP9vAyXjfYauc2qoWWcmn4kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716224; c=relaxed/simple;
	bh=zh/qXK+ak8PwgHAAqFK4hNz61S60TCjTxw7qLtxWF4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3fb0Bz4h4PlLK4mMsjK3zNuXEuG1NQ+0xrP301NBVopkVj6B4BIthEtwNXeUT4LMNepCwbgK6bSQP0oeb4pZ12/gjzyt01Rk9+xCMlRE1IDfueLmUcQiMpDfVqI+NZeiLUukIP560G1NqFpTExyj/1fx/Q/a44WKXnJUpXbAwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=CoV3NlSg; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CoV3NlSg"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2166360285dso105699925ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738716222; x=1739321022; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g0iRm9x2LMXl7kJy/z60Aj584XIH4WOLVzd+nGN7624=;
        b=CoV3NlSg6ErlOuRiA+rm8zjy1kTcOaO4K2pf94bU9rQeOyAFybOdoLA9rqRyQcMewz
         wZmaYjD4+ZAJd3R2wXnfIWZUpUjLKTF3deXshvzOMpBhEigzzfLgKQcH5aaCt9mOriko
         DjmQWWagCAATuJ4H1+LER3bYEx+/cOEvmHwcFOKr0mJ5BQOw8D8JteAvJmEdnG3RtEOy
         Fms9O8pRlELnaHTvef4S3SJ7cYASDdjQ7fqLcyZt77dZ+oCH1scqAbMVYlRbYwbFhdGr
         mDpUuzkw3Ryd6JAo/Z5OapXhthGzXbMGh1xX/EgalYJb/qRcygtb9F1jXxUXrky6xX5C
         IR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716222; x=1739321022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0iRm9x2LMXl7kJy/z60Aj584XIH4WOLVzd+nGN7624=;
        b=R6SJJ6hZuMrR7uUT2GXeGcu0JzqagVpOuGZV1xUMchRUnO1TTN8JbCYTtL9eCTJz+1
         oOaT0Mu42t1Kt37o5Yl22qEHIhjYf09tQ6hgVPx9RyFMtYhXfjYG5soFpDpRpzcDFq//
         4l9A9W6Zt8OtcCmgSGs+RNZOBUC4kCKJ6Kcj5UpFUjzYAk/5aCJoFoDRqyZslAGqhz8q
         FAicBqLVuJSbxiL3O5XdAfStv8J3gt+GvhI6RY6tz+7Vo9pzvoYjK7RLtZdNq7SY0fEz
         ryd4kx0CY6NaXSrynZPw5eb0L5Bf5OpkxlQRLixEPO+o2ExhAe0HvrbvvKray1YyD0aW
         uz6w==
X-Forwarded-Encrypted: i=1; AJvYcCXXZDH471Reld+yfYm6f+bXL5hiVxdPKHABZHEJakpacYuOvx+VNcb78i4wIDQe40vNju3OyWHJRyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmEz9Cqzq9+6oTeLTtx9YGKN+TBrqALbH0Tr1ka5gEx/VnyOA/
	/lnuqxIM2kOKe+ODsLX5t4Kh37FnP/VXmA9R/G/rM3Gt7VstMA1a7df0hvYptWY=
X-Gm-Gg: ASbGncu7IjYT7KwqvyQwPq2XxiOekvsaYPY64bB0L+F3RoMent1yOGR+YXxr3im8imH
	WTBFCCqhzhUwSIx1ihD1m1FV/JvRlCYg7cDYXs6Mqr/VkGlafu5ijnFWjk8SPC+YIKnY8LEAVqT
	nyc/NaNOBqFot3k5zQ/59ZJwBQddIOzUtptSO0e8giH/WhV1DjhJS+nQ/JbBuyQGYq9laStf1ew
	UT5xXHF5SceMXG/mWQjT3e/pkWLlmHGphyqylWAtmvJ0PLIG3LAv6tpnZ/NA9PfTmmG2prV3IAZ
	vL2aiQMPrYQWWmlgkMPK63z/IDRfNVPw8Sf3DeGx4PnggIZ/tNYdwJYZ
X-Google-Smtp-Source: AGHT+IHc47nqoA1L7H0418ID+lzLwiPTkUuy4rsOahnwRbDH6WrXPtvEc9ERGpg5MrMlxEaglgcgiw==
X-Received: by 2002:a17:902:ced1:b0:216:69ca:7714 with SMTP id d9443c01a7336-21f17e2bfecmr15168365ad.11.1738716222360;
        Tue, 04 Feb 2025 16:43:42 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f01fb52efsm22688315ad.74.2025.02.04.16.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:43:41 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTVz-0000000EjNc-2o6q;
	Wed, 05 Feb 2025 11:43:39 +1100
Date: Wed, 5 Feb 2025 11:43:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/34] generic/650: revert SOAK DURATION changes
Message-ID: <Z6K0OxHiHMeqoRmL@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406442.546134.7449017953421049612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406442.546134.7449017953421049612.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:28:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Prior to commit 8973af00ec21, in the absence of an explicit
> SOAK_DURATION, this test would run 2500 fsstress operations each of ten
> times through the loop body.  On the author's machines, this kept the
> runtime to about 30s total.  Oddly, this was changed to 30s per loop
> body with no specific justification in the middle of an fsstress process
> management change.
> 
> On the author's machine, this explodes the runtime from ~30s to 420s.
> Put things back the way they were.
> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/650 |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/generic/650 b/tests/generic/650
> index 60f86fdf518961..2e051b73156842 100755
> --- a/tests/generic/650
> +++ b/tests/generic/650
> @@ -68,11 +68,11 @@ test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
>  fsstress_args+=(-p $nr_cpus)
>  if [ -n "$SOAK_DURATION" ]; then
>  	test "$SOAK_DURATION" -lt 10 && SOAK_DURATION=10
> +	fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
>  else
> -	# run for 30s per iteration max
> -	SOAK_DURATION=300
> +	# run for 3s per iteration max for a default runtime of ~30s.
> +	fsstress_args+=(--duration=3)

Works for me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
