Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C243F1898F2
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 04:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737434276; cv=none; b=jRRK0tTFWHTzH+L6gDcl/U0OsQ732uXMItj60lTnH1eIZgxSem9QT6Bqkmj9Z7DjRtjqPfDga6naBCuYcE5Z+GQACHPuUUrxUNeIsly0zzmsO9AWHuklW5hb94uzz2MfyjIBvfMoUEXUb/121k3D2+J/p018XGotgASFFK4pTxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737434276; c=relaxed/simple;
	bh=8OlPF81GtW+haeVNBajnVshiiytFy9dhH3EfEcV6ozg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzqrSr6vbAZCUSYAKW/e0/CBX85BM+8b2L7Gw1uhjgNVW8wEwtK/eQWg1/GnJGCMg18FRR7Gn3Es7/q+1LuMdHmmLT7q2jEgovjMBWJpgGmv6mzHoAo9L/4JvoWDhnwbGS7egohXrTCaJCb8lT70iN5bn0LRQ+Y/1jzIoST1t6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=z/QAckl5; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="z/QAckl5"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2166022c5caso81855565ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 20:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737434274; x=1738039074; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9jpi/sxdFX+CtpSIqZXZHd2S6z76106XCibW+Y420Ec=;
        b=z/QAckl5w9+jSMPXXiopy4RxYHhlbKAP0M1oweyr1LRWjJbs5ud8lJbwVWq8Oehrw7
         l8GVv3chyFWSdOD0nvQqJeCQhbDtgGuqQV/Rdcfs6H0LXJ0wak84L+Hg+JAwIHUGWFTq
         lIFfkY+6VuOULajqADK6Tl/b8l6aOrcvVxprTtNPtHvj+KVG0+XiTc5IOFmO1JWZ9+iB
         geBk20TgtS6/tW3dJ1djgbxSlYi2BIvMg2HQo3k3BvX7N/IEvFI71neaaxxXeDphIHuk
         ZmO/VqrGwyLMQ4j9UFDp960gSdGm4w3/2702kVqxC3F+z9m3hsB36PXYzmxYwq7e1pAi
         DOPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737434274; x=1738039074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9jpi/sxdFX+CtpSIqZXZHd2S6z76106XCibW+Y420Ec=;
        b=IqNQsMbPO5kA9D276U3piey2xoRnUtsvTo2UMBYWBmlKxfus5e+la23viM1CTx90CT
         knw/2Wc/+Pm5dZRVbovMcX/ymrwZTc/kHRzV58oyumkMK4Af8PjiDeFdfPEGorgC5YDo
         Xr93mZZoj1OCEDNznrPkSGU230VlOp3ruIOtBnJc/krw23PNBqTXb7JNn6MYdMh/rRL5
         S4OFPz5gE+kYu35FxD43FT/8UvrH0F6l3qN0oqWSfChO23EWLdTS/glpu1l/RsRcpg5J
         cQ9M2NksAlLkH09ry1AKE7nwEXlKUFE0V90+z5Qc2QkfweSJpSf6vcI2o6uV/tdco/tK
         Stvw==
X-Forwarded-Encrypted: i=1; AJvYcCWaJbOyaDAHJYjUtaKrE+J7bolp2rwplLGFfQ4ZJPDm8tXe9hoz44E50c/x/wpgQafMwcX34ZS8tfI=@vger.kernel.org
X-Gm-Message-State: AOJu0YznulHYIjLQ33+P0cSQMyajNVIVfbZXDzmQHSJYnRK6JZB9mtO+
	UmbcubaWG380shF1DiICXPiSiO5/jbj61FPJew4xih6HJFAVKegXzK6t/qe0Q90=
X-Gm-Gg: ASbGncv9IZPnCp19sRHaRJYmrAon5XtaRfZFUCcwD4EOyBCYRkk66YVTHsglSCOsrdu
	o92LeSmP0vgggIjSdO68jFlPKSK5cfpx3xCbh1qDU1Gt3IqY4L/rBn7QK0YYp7CI3q19b5/S1+E
	8KW5KNwHYSPcUdu9LZYRFgX0qrMDHEx33zr3fruvSdu+QXyio1aeuynzeYw1IlaWOcd4H+LnUKa
	SmsEzMxQ1IQKaXQjPoBWCSQdHd3cmpJ8r1dUiHabT3DPhBPdr1h1Eh5ZEeN8kY3Gi7fNGEYrEaY
	nqgYoGFkb8iYUm8K8NRz13fW0yNmu6G9iWs=
X-Google-Smtp-Source: AGHT+IH5wviTB2AbJq2TCOjP0gSwJ7RSxjLmwHTZl9PD1W4uKJk8p9eNG/m7lvyZtJIoEOj2XuKFzQ==
X-Received: by 2002:a17:902:ebce:b0:21c:15b3:e3a8 with SMTP id d9443c01a7336-21c355b78d9mr215678675ad.37.1737434274054;
        Mon, 20 Jan 2025 20:37:54 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d3d7d98sm68938805ad.177.2025.01.20.20.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 20:37:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta61P-00000008Wn7-29TX;
	Tue, 21 Jan 2025 15:37:51 +1100
Date: Tue, 21 Jan 2025 15:37:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/23] preamble: fix missing _kill_fsstress
Message-ID: <Z48knyv7dpNUsELU@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974258.1927324.7737993478703584623.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974258.1927324.7737993478703584623.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:28:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit 8973af00ec212f added a _kill_fsstress to the standard _cleanup
> function.  However, if something breaks during test program
> initialization before it gets to sourcing common/rc, then you get
> failures that look like this:
> 
>  --- /tmp/fstests/tests/generic/556.out  2024-09-25 12:09:52.938797554 -0700
>  +++ /var/tmp/fstests/generic/556.out.bad        2025-01-04 22:34:01.268327003 -0800
>  @@ -1,16 +1,3 @@
>   QA output created by 556
>  -SCRATCH_MNT/basic Casefold
>  -SCRATCH_MNT/basic
>  -SCRATCH_MNT/casefold_flag_removal Casefold
>  -SCRATCH_MNT/casefold_flag_removal Casefold
>  -SCRATCH_MNT/flag_inheritance/d1/d2/d3 Casefold
>  -SCRATCH_MNT/symlink/ind1/TARGET
>  -mv: 'SCRATCH_MNT/rename/rename' and 'SCRATCH_MNT/rename/RENAME' are the same file
>  -# file: SCRATCH_MNT/xattrs/x
>  -user.foo="bar"
>  -
>  -# file: SCRATCH_MNT/xattrs/x/f1
>  -user.foo="bar"
>  -
>  -touch: 'SCRATCH_MNT/strict/corac'$'\314\247\303': Invalid argument
>  -touch: 'SCRATCH_MNT/strict/cora'$'\303\247\303': Invalid argument
>  +./tests/generic/556: 108: common/config: Syntax error: "&" unexpected
>  +./tests/generic/556: 10: _kill_fsstress: not found
> 
> It's that last line that's unnecessary.  Fix this by checking for the
> presence of a _kill_fsstress before invoking it.
> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/preamble |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/common/preamble b/common/preamble
> index 78e45d522f482c..0c9ee2e0377dd5 100644
> --- a/common/preamble
> +++ b/common/preamble
> @@ -7,7 +7,7 @@
>  # Standard cleanup function.  Individual tests can override this.
>  _cleanup()
>  {
> -	_kill_fsstress
> +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
>  	cd /
>  	rm -r -f $tmp.*
>  }

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
