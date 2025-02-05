Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCE6163
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738714146; cv=none; b=Z59zEiHm/d5bWL+prPSMuU1t4XD2y/GYQCIFbC6o3GOgACD7SSziNYSxbYpcFVM2BKXc9gCODJQydErDlumrL3HuY2+aTX9kptkIlFy7qsdmDTb+gaYnGUo2+lB/j6oLGBV4mGBC+3BF+LIB8eB0aTgxjctLS+nmLFn6NcCV7qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738714146; c=relaxed/simple;
	bh=DlxSGXZU0DWaOR8mpKXyWlkBQrLiAdDhmztPP7zY+KY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kYvh5zP/1BIcjhWTJfblVd7wSxOcnnwGwW/hSm1XVqIKQLcqUfpKdyBoiUJwVMj1WZ5BYAeTUvfSQjnNqB4sp3Fu0QWDr+y7W7pIZruotXWAzv46iMY4UsJZpQhp8+DFLwkETLN7DrAzoZff/dom3xDl9ltwHbRyBzLY3imsrNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=07drgkKR; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="07drgkKR"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f9d3d0f55dso1256839a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738714144; x=1739318944; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uYQa5iksrp/AjhZ2SgU2sWhfZ2J+sJFerGxdTl91K2I=;
        b=07drgkKRqRC0YwUrGkh+DJz6rC3qB6Y9xoPBvXvO70sMgvwuaC7+hNWeJOoSn5m99g
         3nR0g6kYyTmdtqgihj/ri7Di5v2D2BnEFR4YPnxCRR1dfNS6iOnWJ8I1NrzPAKPcmNEF
         8ffmKFO1xn5hQzAmr8zwuTCDP4L6HHP+3os6q9oK8bEwSYgOMBevWPrdLrlEU3q0IN3p
         79BwTAfxXJGKm+3qV5C1YyzTIBexElcmVWQfRkZDbAp+hMlpuPPoz/xK3NlFNgu7O3Xr
         PwIZFD/HoU+hROgAuEPzcUm+hEivel4CR7ez8BwnrDJiu2mWhnpG5ooc3ToHmlfpSKv6
         +o4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738714144; x=1739318944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uYQa5iksrp/AjhZ2SgU2sWhfZ2J+sJFerGxdTl91K2I=;
        b=JuiyfxV1m6u6yfV2c707plTsJr1/9jlZNZKr3kEoxR6K6E7VpdRK/Ulv8+xjCtXK7H
         VAKFEbp9iNSNEnNH/nkFkGNzfU8+9ScOyDWyJo6AaRUkGB+LwpCfmmVLC8T74QzqUxHc
         HuwaCofMGQkYqeU5waNSlSF5c+bSKfQVhzx0/mi6/lkpXAZuubKPqUYQxCVVy8MVSAOB
         1nOEaDfeXZ7iJdSS5WiByuu3cS0ms+03tRsXt4e6zpenBdZ2D+hG1AvzB17jlq42y2GO
         p2mMA037FFhNOOlo5Yl5WAksJMPD+Y4FQXZfG2Mqt6VRU7g7v8naiPqYYxRy202tEWWp
         ezfw==
X-Forwarded-Encrypted: i=1; AJvYcCUYFm0taGfASzjTZAM1RtyKYoMMw1AmJq68WNheFsk6y124jbCpG/jYLLxorw/UUmzb5j81Dn/IfvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOdDCcEr9Mm2P9W4CYKaGF8QULKGFZ9WJjp64U1KNkx9w8XFAb
	nab+mVnblqNvCh/P0IWNSKfznGbF2tH8/ggHlWndgfnUI12Dce4ojdcFRsqB12E=
X-Gm-Gg: ASbGnct8dS3cmAeMDqnyDUQ25e18lkfJH41K0MF7u5EpqjVznGgnRDhT0c9uNe7oJOp
	Zznk5oM5+r79oZPKjY01kSMKbs0q3yZpZ9Nw8H303flw/dpYei4yl211MvdKs9UMEbYoDhmM/EX
	lPQqv2EtWu5+/e/7LPHwus6m8m+Y/gtfiQPT9oio3X2hMdiN58+1z/JC22m6tJXGpiRV3FdmX4q
	J1uU2VdlCyj0tTR7llyka8CmjlMVaXVp4qZg79eZYlEXm9uLH40E9Nx1dktsSiBNdDgFqXmH+uS
	j2Y/HGflrXAg+eXFLwmQb16bZKFYBA9cxY/rfiMYTjxaN6PKv7JH1G8E
X-Google-Smtp-Source: AGHT+IF1nTgQm/3zR702eOCluilvUQRBDi7woD+dIuPFWUp5+iYLkJaePkAZZsHIqqwx/+84D+IQPg==
X-Received: by 2002:a05:6a00:114a:b0:725:e057:c3de with SMTP id d2e1a72fcca58-7303521441cmr1328278b3a.23.1738714144338;
        Tue, 04 Feb 2025 16:09:04 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe653fa85sm10975781b3a.77.2025.02.04.16.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:09:03 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfSyT-0000000Eilg-38Kc;
	Wed, 05 Feb 2025 11:09:01 +1100
Date: Wed, 5 Feb 2025 11:09:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/34] common/dump: don't replace pids arbitrarily
Message-ID: <Z6KsHTzj1meFDVAF@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406214.546134.16846124942782280576.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406214.546134.16846124942782280576.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:24:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the next patch we'll run tests in a pid namespace, which means that
> the test process will have a very low pid.  This low pid situation
> causes problems with the dump tests because they unconditionally replace
> it with the word "PID", which causes unnecessary test failures.
> 
> Initially I was going to fix it by bracketing the regexp with a
> whitespace/punctuation/eol/sol detector, but then I decided to remove it
> see how many sheep came barreling through.  None did, so I removed it
> entirely.  The commit adding it (linked below) was not insightful at
> all.
> 
> Fixes: 19beb54c96e363 ("Extra filtering as part of IRIX/Linux xfstests reconciliation for dump.")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/dump |    1 -
>  1 file changed, 1 deletion(-)
> 
> 
> diff --git a/common/dump b/common/dump
> index 3761c16100d808..6dcd6250c33147 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -907,7 +907,6 @@ _dir_filter()
>      -e "s#$SCRATCH_MNT#SCRATCH_MNT#g"       \
>      -e "s#$dump_sdir#DUMP_SUBDIR#g"   \
>      -e "s#$restore_sdir#RESTORE_SUBDIR#g" \
> -    -e "s#$$#PID#g" \
>      -e "/Only in SCRATCH_MNT: .use_space/d" \
>      -e "s#$RESULT_DIR/##g" \

Looks fine, if it causes problems further down the line then we can
implement a better filter.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
