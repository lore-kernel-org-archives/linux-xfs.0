Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3562815EA6
	for <linux-xfs@vger.kernel.org>; Thu,  4 Apr 2024 21:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712267188; cv=none; b=gepo7z7DBAGGVB9d3grypOrHdZ+3r7U41NAXroiUcXazk21v4ZTAkVyfMh56r/1axQWaqZK5SAgHmwNopdqnbL6Xnf1feenVPteeob0xMqEz3o0wHyZkS5z3qKQbWn5xEPXjf+r1ckkLwc/CS2ZjZgNf2o7suwlGZ3bWfBYDCig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712267188; c=relaxed/simple;
	bh=nTYYhOm9gxnffO7tJe8iIqrB5MxlJxHbRkb58OWR2dk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fu3pYzVDp7uG1t7tb9U1d3iQdi/NT+Ok5rYv1+NphHgvkxl3mc/5xvwWRvFyA75nLb2VkMBgc6YeJqx6VKUxPz1LD0x0qtzJ2D1jLzfJl6nRMDoPt1qsjUB/xlSb6M8DGPh4EgiRBGLggFr0kguJU3IYGAy6Bi5bfpqVbB9Ny+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=I1sSXQk8; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="I1sSXQk8"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e73e8bdea2so1358332b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Apr 2024 14:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712267186; x=1712871986; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PAT7bztQSrSeww6mgHBlY9itDpDqDxKb6Tv5CCWsgO4=;
        b=I1sSXQk8n6AniRhspXdYGBf/S1KqBIWVGuCm0LrnhRoQbpwTPY+6eroAi+mOdGx0qw
         hsE3TefEUmpCVCkA8GnZM2yNIob8SHqBv5kBjG7e2ERnRrBEa8EIYjbsoONJS0sE9DwJ
         aeoFE6sdNNmXew7Nv6jo8hTmt3LnKWZzy4mQGyyC5MEU83ygjMMlrbSWB06bTS8Sm57w
         oQI5Xxa/uL/5GkbEZdK1wC8Hr+WrlcWN4gg9ZQDcCH4g/Kwu1QEO1QFPu79NRjzKieNL
         32iQp7ptKm1dP95YR2i22ssCnw01TPtRHIXXqNenkPSrTcAKLC/RAAi94ur56J4vP6xT
         l17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712267186; x=1712871986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAT7bztQSrSeww6mgHBlY9itDpDqDxKb6Tv5CCWsgO4=;
        b=rNziV/+QjzR2gONEP99nJwXgcace8DY9RogCp3iTq11ThR4giaGw5+AC4vSkXIhGQO
         MTkQdhfb+BFSkfkRtXZmBwDCJ37NeMFueqnkzQdgNtnKzYTBdxrGevqSAy5Mg5HA2xsn
         JvvV41alIm8T0ww0RxGJZaSwz9af14SAHO5UbKzwSRwAA+Rr9QN/HoVFKWJPWBW2Y6cg
         zdN8+W6T2FAkhjyUkYwohp8LyHw4Oeytbp8CXEE8Wvb9zpIIIwU4y5KVwHVOHETPnPZC
         F8X7UPGvqmcxwJ5PU72M9LE+BCPQ1vPTe0xFsX3ZB9HyDuiqGwLXelZEJLKLdt6Yt1+p
         PPfA==
X-Gm-Message-State: AOJu0YzO9vq78k5gVTLKPhSCLj5/xt+VhbP36PmcOlKgTWe9ofqG6lYP
	BS2NR0UqWWescxXwCIPpJqvqmZJZCMff2ab5IkiDwPxZMzkRoTZ3zgqO83boOso=
X-Google-Smtp-Source: AGHT+IF5gJXcHehFM5T62YxuzdG6UP2bGAUdTHl/ULYKUiZc1b4by4N19l5WvbAVI5BQ2HZPCURzWA==
X-Received: by 2002:a05:6a20:3945:b0:1a3:c3fe:fcaf with SMTP id r5-20020a056a20394500b001a3c3fefcafmr4626843pzg.9.1712267186247;
        Thu, 04 Apr 2024 14:46:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id h7-20020aa786c7000000b006eadfbdcc13sm123669pfo.67.2024.04.04.14.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 14:46:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rsUud-0049C0-0O;
	Fri, 05 Apr 2024 08:46:23 +1100
Date: Fri, 5 Apr 2024 08:46:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v30.2 1/1] xfs: fix severe performance problems when
 fstrimming a subset of an AG
Message-ID: <Zg8fr9QqgNRacM4Y@dread.disaster.area>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <20240403050718.GU6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403050718.GU6390@frogsfrogsfrogs>

On Tue, Apr 02, 2024 at 10:07:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a 10TB filesystem where the free space in each AG is heavily
> fragmented, I noticed some very high runtimes on a FITRIM call for the
> entire filesystem.  xfs_scrub likes to report progress information on
> each phase of the scrub, which means that a strace for the entire
> filesystem:
> 
> ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>
> 
> shows that scrub is uncommunicative for the entire duration.  Reducing
> the size of the FITRIM requests to a single AG at a time produces lower
> times for each individual call, but even this isn't quite acceptable,
> because the time between progress reports are still very high:
> 
> Strace for the first 4x 1TB AGs looks like (2):
> ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
> ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
> ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
> ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>
> 
> I then had the idea to limit the length parameter of each call to a
> smallish amount (~11GB) so that we could report progress relatively
> quickly, but much to my surprise, each FITRIM call still took ~68
> seconds!
> 
> Unfortunately, the by-length fstrim implementation handles this poorly
> because it walks the entire free space by length index (cntbt), which is
> a very inefficient way to walk a subset of the blocks of an AG.
> 
> Therefore, create a second implementation that will walk the bnobt and
> perform the trims in block number order.  This implementation avoids the
> worst problems of the original code, though it lacks the desirable
> attribute of freeing the biggest chunks first.
> 
> On the other hand, this second implementation will be much easier to
> constrain the system call latency, and makes it much easier to report
> fstrim progress to anyone who's running xfs_scrub.
> 
> Inspired-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_discard.c |  153 ++++++++++++++++++++++++++++++--------------------
>  1 file changed, 93 insertions(+), 60 deletions(-)

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
