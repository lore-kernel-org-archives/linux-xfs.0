Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61CE289E03
	for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 23:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970686; cv=none; b=fYHJ3mYKye15YA685+LXTuAoNGAriEja5LnHJNC8YXU6UCOEocF0+2YvzWtrdI5vScTEGU+ZxaDs0/fa4x5h6K/SqgA8LG2djBL9DBvT87+PjCdA7Mfi73El7jPSIld6sQ7kyLt4/1aPrzK0i31/pXcgXfmyAq00IxwlSXE3nqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970686; c=relaxed/simple;
	bh=8neD6MWQfw+EyFFux2CEmOhjmwenh3NYJpAggAD9C10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cww1TP20IYnC3NVDH/BUfz7VHIXCEDig2BBy4+4yLpRGlS30rnQSA+a86MW8TLlfRumeaSL9AUSfmWAfAipqgfHn2bg6dTwXkh2N3BGJBsVxohZaOJcXDOU3QNgqFCbdgb9YjeCn3XXkQQGxeUsUao8Qrajhl1SXIoB92jhNiLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=jICrypSr; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="jICrypSr"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2243803b776so111223545ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 16:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1745970684; x=1746575484; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQB7I1cCDGP31Ffgc304vw5DAP8c3CZYgZKW54rrDxM=;
        b=jICrypSrSlUI0uNGsY4hr6lYY5WvpZ2GGe7xE8zmy2GsspQpY9N4wSUN/ITzWXx2+N
         5/1w4PYJY4Hy5gWu0bETa7nE1o6lwOIKoAr7CMFMb14kOnFMW4eBPo/ya11a9NrvPnnG
         h4pJpAtcIbsb2D1oiGiPDMmHZ6UTYWmHvlTKgtzsez1Tq1vVmFQwwkg8TlVNHm7XBANc
         8zmLVffMra3OQbJwdHGkw+PHXOusK1RBJJISyc//7wBCqxI9GZR/CS2CvoqnMr4NBkKn
         IVY4D0c+X/pcMxSytZWpT5mJ1iH4qPbmDcPsU7mdqEFE/zvobFsK0RXnJVa6qLm9xJp4
         bItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745970684; x=1746575484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQB7I1cCDGP31Ffgc304vw5DAP8c3CZYgZKW54rrDxM=;
        b=AmyqtUavBvJu97TzGmrdroazEsOCU8To4YDP6z9w1Yqxe5y2gCLR+7POoqdkLvmfUZ
         DrGApFhuR/VwytoJ3QwakFw1NWENqpBmosDwKR0GDUcDyzAsqie/517yaUUVrSH0lOMt
         E9JygTSAxl/ZvhwRHsXmYCQq1EWC1WSkf1QI5j0JCLoKGPmJgE6DYd8l0wfoht/RL608
         neCeU4EVC0InkOsceN9XvOJWNJEZVUT92Cl1r2egqFrmCm5Alsagd5iqgeiNLIO8OOfq
         arnAaTByvmZzjCZUHEsmIc0tiof2wov+PYiNjKAcbMpdpz83I9r+QbVd04/5T/SDUUfc
         Qhxg==
X-Forwarded-Encrypted: i=1; AJvYcCXXpKgJVsfOXYoa2EkBTFx5i9RBNdnL1aB4yGfcXF8zvpCkmYHyL8HrPb3kYHGPOfGFZtqEto+p5TE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywre9Qaosyuys9I2b2MjAwEYp3efz/D7CjmxrDA3AigJ9sP7XZ7
	P1BOd+XbEZn15NVI1usGqx8FJWAM/+42DWBtOXXgABk/RKpJffcJCl5qqnZEMMc=
X-Gm-Gg: ASbGncsO+DUlAILMQc+mrimmr+bw9MEtc1KMPbRxFlmqiPeDj08Hwo0zq41ntzkMPVY
	j7KX4Ijj/UwiGjTcaoc1nMXXzJ98M7YbBScfvOBXviN7FT5PQ6S9WOsZ7EG7aWgG0edXeETu0W1
	Llc9QpfcQx1nnAzb8E7xdUZvKH1IgiJNLxWBKHHvYWzbShVow53yf66/cowBVx1T6Lq+/C2leK7
	dWyN6oYBtnPjFsWaXIEzQOMn4cQ5aR5ohO+yi74PAPoq3PjJR3QDRVYGhhphlVop0WTwNGrPDPc
	D/X9eMqPToiA+dgV0OqavtdO2fYy0FK9un9YnpDjJ/vS8vxQTSKqM735r91c5fSKJVteORj4YmD
	OxlA=
X-Google-Smtp-Source: AGHT+IGnw8oR5NQn26f2EFS9oWO/RFCD5rSfC11L3dAtCqKaPeKK28nVDtSMdG8CZUfJ9vzhi5Hg2w==
X-Received: by 2002:a17:903:1c4:b0:21f:b483:2ad5 with SMTP id d9443c01a7336-22df350d4d0mr15944745ad.20.1745970684135;
        Tue, 29 Apr 2025 16:51:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4d76ce1sm109571705ad.40.2025.04.29.16.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 16:51:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1u9ujR-0000000F0V9-0vM9;
	Wed, 30 Apr 2025 09:51:21 +1000
Date: Wed, 30 Apr 2025 09:51:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v2 1/2] common: Move exit related functions to a
 common/exit
Message-ID: <aBFl-eKBBwG-QxCm@dread.disaster.area>
References: <cover.1745908976.git.nirjhar.roy.lists@gmail.com>
 <a2e20e1d74360a76fd2a1ef553cac6094897bff2.1745908976.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2e20e1d74360a76fd2a1ef553cac6094897bff2.1745908976.git.nirjhar.roy.lists@gmail.com>

On Tue, Apr 29, 2025 at 06:52:53AM +0000, Nirjhar Roy (IBM) wrote:
> Introduce a new file common/exit that will contain all the exit
> related functions. This will remove the dependencies these functions
> have on other non-related helper files and they can be indepedently
> sourced. This was suggested by Dave Chinner[1].
> 
> [1] https://lore.kernel.org/linux-xfs/Z_UJ7XcpmtkPRhTr@dread.disaster.area/
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  common/config   | 17 +----------------
>  common/exit     | 50 +++++++++++++++++++++++++++++++++++++++++++++++++
>  common/preamble |  1 +
>  common/punch    |  5 -----
>  common/rc       | 28 ---------------------------
>  5 files changed, 52 insertions(+), 49 deletions(-)
>  create mode 100644 common/exit

Neither of my replys to v1 made it to the list [1], so I'll have to
repeat what I said here.

I did point out that I had already sent this out here:

https://lore.kernel.org/fstests/20250417031208.1852171-4-david@fromorbit.com/

but now this version is mostly the same (except for things noted
below) so I'm good with this.

> 
> diff --git a/common/config b/common/config
> index eada3971..6a60d144 100644
> --- a/common/config
> +++ b/common/config
> @@ -38,7 +38,7 @@
>  # - this script shouldn't make any assertions about filesystem
>  #   validity or mountedness.
>  #
> -
> +. common/exit
>  . common/test_names

This isn't needed. Include it in check and other high level scripts
(which need to include this, anyway) before including common/config.

> diff --git a/common/exit b/common/exit
> new file mode 100644
> index 00000000..ad7e7498
> --- /dev/null
> +++ b/common/exit
> @@ -0,0 +1,50 @@
> +##/bin/bash
> +
> +# This functions sets the exit code to status and then exits. Don't use
> +# exit directly, as it might not set the value of "$status" correctly, which is
> +# used as an exit code in the trap handler routine set up by the check script.
> +_exit()
> +{
> +	test -n "$1" && status="$1"
> +	exit "$status"
> +}
> +
> +_fatal()
> +{
> +    echo "$*"
> +    _exit 1
> +}
> +
> +_die()
> +{
> +        echo $@
> +        _exit 1
> +}

This should be removed and replaced with _fatal

> +die_now()
> +{
> +	_exit 1
> +}

And this should be removed as well. 

i.e. These two functions are only used by common/punch, so change
them to use _fatal and _exit rather than duplicating the wrappers.

> diff --git a/common/preamble b/common/preamble
> index ba029a34..9b6b4b26 100644
> --- a/common/preamble
> +++ b/common/preamble
> @@ -33,6 +33,7 @@ _register_cleanup()
>  # explicitly as a member of the 'all' group.
>  _begin_fstest()
>  {
> +	. common/exit
>  	if [ -n "$seq" ]; then
>  		echo "_begin_fstest can only be called once!"
>  		_exit 1

Please leave a blank line between includes and unrelated code.

-Dave.

[1] Thanks Google, for removing mail auth methods without any
warning and not reporting permanent delivery failure on attempts
to send mail an unsupported auth method.

-- 
Dave Chinner
david@fromorbit.com
