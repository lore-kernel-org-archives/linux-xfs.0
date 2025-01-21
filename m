Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642F94689
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 03:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737429130; cv=none; b=faPQqj6CquzCP9LnIukHsOeAIE88+ABNTlWyxctqbdfViMWULWNVO/asLAQMRO/gRsPerNoMkwNryjc7zPrcFw7jy9KZhY8XaFd62I6MSap/rExf/Q0JxGsa6wIKXF2WLGnmfmVna7ahYO1OQSIsRWYWCOH8SUlIUvzBmh7ar+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737429130; c=relaxed/simple;
	bh=jdBB3WcVAlLDR104nU0eZfrdYAP0wQ3R+T5Q0viMPx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1JB7wxPYYElc9bNRhanL+MqPIdgT879vTyEEMlAwAin2s+FtMTO9DMIiiUhX0zRtGFM9CLCZ96XBevq9tF2JeBfppxxegIuDVryEN+/ray8T0DGux5MVfAC4V1xHumUtWWVdLI5jpsfpLAQWnj3GypAOgmcrjl0O1rA3z0oIfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SZaWHE6H; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SZaWHE6H"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f13acbe29bso9427456a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 19:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737429128; x=1738033928; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2yfEyLgrQXxbc3ohBQkJp6FXL5SmdHTuhNk/dbJkOBA=;
        b=SZaWHE6HIFRCBq+m7fGj9yH+XVvRevJk2B/pq/VSLIVWsUzzr/T2gfY9Ck8nsS6iPJ
         WFPKJu+GZsowqrWCn8kS8xzpa9o8IaD92ER46kQYnHNyd3W/J3R+7nzc9iwPGumib9Fc
         FM4WyCNh/oRCAiXALTFR/jZRk7rf18E9uNFFf35tcF/Q06AOV5a6xqIXkOZqfBVhHt1j
         UXfhZneCElshanZ7DvPSe9xk6uY0TjiXWQjHvlamBb2RdttwN7wfvYt9hItxHszlWQZ7
         UtOi2vIgc394rQLvbh+s7Cxp52uzjL39NkLO0BXduMdS04VlN18HTOHyPHbfIU+7JD4t
         ApBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737429128; x=1738033928;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yfEyLgrQXxbc3ohBQkJp6FXL5SmdHTuhNk/dbJkOBA=;
        b=ByacqW4nw2Pp5IAbUBmDHd9n+hjENq3udAELu4p4hV6eAGrLY4aZPdQoeo/BCFUdwB
         HM7pOEMpw7qQ7Rd342dqhugGwDG1jNLw0U2ya4PRRCeP2j5Tiozhm8iyMkv0Hc14RzXQ
         NSshiuuRH0dsMsZBAUYh3/AnMJqvZlVMfV1oVukNNRSoWFCx6agKJHBd6vv3r+WSsCwY
         iRniDUTk70vY7wedGe2f+498NSnZODziMR/jJe/0nylQaJku04YXgFhsCVEIKLr6HnYq
         AEPvdRD7DYw6ETNwr4l+WFvspnShRmGSPpq5PkCCQBBDwMUNRhsAZsRNTMdhrp6rNIba
         CWkw==
X-Forwarded-Encrypted: i=1; AJvYcCWlnlmIGPfqmqzT5cDC/xHWN66mgYJL5Z7xvLFSGzi7VGKEOmt27i3OF6RDRhRfeZAQJux7K/upSnA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxCTWDEXxOI0A4XCikPD5IToSFqzjf+bf7HYNvXQTOvUgSHue0
	IMNjbQKk7czc123VUxsrKPDSbYMH1IYpODAYrn5FPtRvjluUPiYf+0NjrrFw5P8=
X-Gm-Gg: ASbGncsE0g9Lkasi5jk3rZGuYf0kdaKXLwdrNBKUJ9NoGaW36q1WWy14VhjM/B08Z66
	oQ0lOpjzzpAAd/U4DI7nhrAyNQ1mKKIK9kownsanP24rbkTCgMPk1G/WaARyamzBxyiwdWu7Ru2
	iT3KSs64iDAo4zpisIfeQVizqrnmQEPloWB1t5AfWjhgWEHLWgtbjPmaNjvkf07zkHd+4A/iqJb
	fxXG1uBnIjr8SnRzqyGe1zGp9NGIxz1xvZf0UXjjpweYmEVlHUvFibg5GpteY5mUG3pLWJA5MEt
	WVhq4VjB7Pc62t/A9/TN8WjSbqiuuduvkL8=
X-Google-Smtp-Source: AGHT+IHhDHA/SNMmcNQAqXF/msD8RfM1bIYsgz6TlE2GwXTSan708AdG1E2mDRK7LyN6NVGe3rUYvA==
X-Received: by 2002:a05:6a00:3a09:b0:725:41c4:dbc7 with SMTP id d2e1a72fcca58-72db1b605e4mr25046126b3a.4.1737429128586;
        Mon, 20 Jan 2025 19:12:08 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab9c8e37sm7827143b3a.119.2025.01.20.19.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 19:12:08 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta4gP-00000008VDT-3NyC;
	Tue, 21 Jan 2025 14:12:05 +1100
Date: Tue, 21 Jan 2025 14:12:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/23] generic/482: _run_fsstress needs the test
 filesystem
Message-ID: <Z48QhXVLqwCO0KIQ@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974137.1927324.11572571998972107262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974137.1927324.11572571998972107262.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:26:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The test filesystem is now a hard dependency of _run_fsstress because
> the latter copies the fsstress binary to a different name on the test
> filesystem:
> 
> generic/482       - output mismatch (see /var/tmp/fstests/generic/482.out.bad)
>     --- tests/generic/482.out   2024-02-28 16:20:24.262888854 -0800
>     +++ /var/tmp/fstests/generic/482.out.bad    2025-01-03 15:00:43.107625116 -0800
>     @@ -1,2 +1,3 @@
>      QA output created by 482
>     +cp: cannot create regular file '/mnt/482.fsstress': Read-only file system
>      Silence is golden
>     ...
>     (Run 'diff -u /tmp/fstests/tests/generic/482.out /var/tmp/fstests/generic/482.out.bad'  to see the entire diff)

Ah, because I hadn't added dm-logwrite support to check-parallel
this test wasn't being run....

However, this patch doesn't need to exist - this dependency is
removed  later in the series by using the changes to use a unique
session ID for each test and so the fsstress binary doesn't need to
be rename. The change in this patch is then reverted....

I'd just drop this patch (and the later revert).

-Dave.

> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/482 |    1 -
>  1 file changed, 1 deletion(-)
> 
> 
> diff --git a/tests/generic/482 b/tests/generic/482
> index 8c114ee03058c6..0efc026a160040 100755
> --- a/tests/generic/482
> +++ b/tests/generic/482
> @@ -68,7 +68,6 @@ lowspace=$((1024*1024 / 512))		# 1m low space threshold
>  
>  # Use a thin device to provide deterministic discard behavior. Discards are used
>  # by the log replay tool for fast zeroing to prevent out-of-order replay issues.
> -_test_unmount
>  _dmthin_init $devsize $devsize $csize $lowspace
>  _log_writes_init $DMTHIN_VOL_DEV
>  _log_writes_mkfs >> $seqres.full 2>&1
> 
> 
> 

-- 
Dave Chinner
david@fromorbit.com
