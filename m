Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49D51B0F14
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 07:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729840169; cv=none; b=NA0yKJsMxEXmMdSXJokMJrVjyMCZzMtL/ZHTDHhbq8SOCH7XLjuS3w5Bt2YOys9Q0e7voFzIiai9XFucawanqf4uxmuIdTcKHWqOznJdhDzoa6bp6aZRYi4ojkRR/exz1by8o9j6AKpFnOnV1GNpx0j2/l04XKWKfS0v8xydUFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729840169; c=relaxed/simple;
	bh=v+d+yOPP8wYvkjtoYov65gkr8gZMoo34pqrO3+iI9cE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1YicmU0TjqGSk+SPtmAktk4yLwaAPA1/Pq49eid85qnheEtX/JtYGrZXxi/60oGlUXl13MAQGEDgjvH+XfycHsNBhQec+NUdH48k7nAWTH9RekwL9MK+UxfqpX51aGtJQHNkA+WH8CRmN5nTfRUAY1gWAFXmnVlXRDsRU06J+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SgUUsyph; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SgUUsyph"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7db238d07b3so1164060a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 00:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729840167; x=1730444967; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Il81+fKWvc3sFrEb/oXL1PU3sWta77/4Qv/NEUSwTPQ=;
        b=SgUUsyphrP+ac12Lz5euYzewvCjOH5hBpqcV0hWfuXNRr4k+RJP/yy2X1BC915evzA
         HdLD20m0hDCpaBXz1XHBKMxJdkPmbx+/+Oic4Gnt5xFIZjw5nmF7H7AR8MjnSKcvk5sw
         Uvzt9JdwL3cjkmAeCFFz5CwMB9Wc4QFrxardq1+YKCKA5mStSYQfZjDI4GLDTv3Htrrz
         mnNrsWCWaNJAjXgryFeT7crcQomI0nB4vPevJx3MySrU9r///mBwb/LSWg6X1yGOAdAn
         LmeoALONfRdeYPVqLY7xJ6826pXtE5BAZdI4n7ap68A7cEGR2vbBOYLqWo3k1jzFCjwr
         oS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729840167; x=1730444967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Il81+fKWvc3sFrEb/oXL1PU3sWta77/4Qv/NEUSwTPQ=;
        b=Y5db1kz/oafpPz872skPFwMcIL6Y4w8jF75HTxPSc1gIzSW9bHrU7qaVwcJZ02FMtC
         ogCrq/wGDwd4lJ36MaZ+BxdvGIEu6kaha7CHSthCQX1ItyuraCrTQbd9W/d1TAVH/kpZ
         PXOjYYXFgZ/5g7Ll/WBX7hohyYLGq96/tAC0zhrcYKQmvNxULdX7Rj8eG+6bEZUQzBWx
         ucaQedKG8hLlU4swyar7oJlsqehDWtF7UyhTOeemQcJiJvzmc8hENEHdRkLnIlt8Ho9I
         qzEzMLB+k5Uc6d+jiNdi4duykbhwYwzfVkeiz7MdaAwV3livL14Ut9uQz/q6Mz0nxbDR
         CNzw==
X-Forwarded-Encrypted: i=1; AJvYcCUcO8sVEMxLhLn93kvbVEvXojXJ8WuZnqcsUEE+krJn1yQ+F6alY/5HtT1KYSBQGqctmJBtBGE2xVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9nb13wjEqU/80+eEbWrAX6BNrqaD5MZ7Q/GourzViAb71CC9L
	DyNhxavKeZrp8GwfnNcTMwm2qTD187Ez5PW2yCuCdjwsxVRdaer0hBzJ22URWmHA2AEt4GOCs6X
	l
X-Google-Smtp-Source: AGHT+IEunfT3jydLgKIpG/C/BUgRgj/e/o46LsP4/ImmpwMbVJFvTPS4/f0H4xVYWORV9p/v6jIWrg==
X-Received: by 2002:a05:6a21:394c:b0:1d9:2659:5da9 with SMTP id adf61e73a8af0-1d989a99601mr5824967637.18.1729840167168;
        Fri, 25 Oct 2024 00:09:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7205793190bsm475502b3a.54.2024.10.25.00.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 00:09:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t4ERo-005U5W-0R;
	Fri, 25 Oct 2024 18:09:24 +1100
Date: Fri, 25 Oct 2024 18:09:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH] xfs: Reduce unnecessary searches when searching for the
 best extents
Message-ID: <ZxtEJN/dTw9JipJe@dread.disaster.area>
References: <20241025023320.591468-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025023320.591468-1-chizhiling@163.com>

On Fri, Oct 25, 2024 at 10:33:20AM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Recently, we found that the CPU spent a lot of time in
> xfs_alloc_ag_vextent_size when the filesystem has millions of fragmented
> spaces.
> 
> The reason is that we conducted much extra searching for extents that
> could not yield a better result, and these searches would cost a lot of
> time when there were millions of extents to search through. Even if we
> get the same result length, we don't switch our choice to the new one,
> so we can definitely terminate the search early.
> 
> Since the result length cannot exceed the found length, when the found
> length equals the best result length we already have, we can conclude
> the search.
> 
> We did a test in that filesystem:
> [root@localhost ~]# xfs_db -c freesp /dev/vdb
>    from      to extents  blocks    pct
>       1       1     215     215   0.01
>       2       3  994476 1988952  99.99

Ok, so you have *badly* fragmented free space. That going to cause
lots more problems than only "allocation searches take a long
time". e.g. you can't allocate inodes in a AG that is fragmented
this badly - not even sparse inode clusters....

> Before this patch:
>  0)               |  xfs_alloc_ag_vextent_size [xfs]() {
>  0) * 15597.94 us |  }
> 
> After this patch:
>  0)               |  xfs_alloc_ag_vextent_size [xfs]() {
>  0)   19.176 us    |  }

Yup, that's a good improvement.


> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 04f64cf9777e..22bdbb3e9980 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1923,7 +1923,7 @@ xfs_alloc_ag_vextent_size(
>  				error = -EFSCORRUPTED;
>  				goto error0;
>  			}
> -			if (flen < bestrlen)
> +			if (flen <= bestrlen)
>  				break;
>  			busy = xfs_alloc_compute_aligned(args, fbno, flen,
>  					&rbno, &rlen, &busy_gen);

Yup, I think that works fine. We aren't caring about using locality
as a secondary search key so as soon as we have a candidate extent
of a length that that the remaining extents in the free space btree
can't improve on, we are done.

Nice work!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
