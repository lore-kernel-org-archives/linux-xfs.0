Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00804204F8B
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 23:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736465312; cv=none; b=aovcRBXlXAaoYglYfMON8yDns5M12ovHVAUr+ybXOndU/Q8RATSlGKGLnKq/izzyfXLRU+kfhObnllVuOlhu+JVQYbLjE28bRWNM1pqcc1ycertumWJBKVsy3tLuYZaei5iIplq6nFqI9uBBYEdeCKRnVF4BDW6ZbUazdoiZCKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736465312; c=relaxed/simple;
	bh=wNVedT0+5ueuw21lfoE9AwRpuPN8Dbn7hRSM2sm7VFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uu9kscwg95+UqbISkidM/VV11KXxVQWw7PFw9xb5vQAh2APhZM8K6sWuaz7ZZVUgQIN37tRcDhJJnKNm8Gvw9ioPvOSTHcx0R5tF6Tdl1MdEMAtMvkuBuZZ1L4SJhGqhDZpxh63KpHyhjGPg4ke7Mg+sE7HklLgiDkS6zCLL2pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=NSjpRpyy; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="NSjpRpyy"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2f441904a42so2583952a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2025 15:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736465310; x=1737070110; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QCd1luRCqJAyHxYbVfgNe3mydTTEDXhNVLI5rrCJRPA=;
        b=NSjpRpyyqUGButCEMN4U0UaJeQUzkI7v1dFlj4ec0UsPhL2JCvsGjJySMcbxZdyqSO
         49bQNqS8sxYcCrJblnUBJzx8zwPgnEoqd2mThLhtxGFfbWf4vrx234B70xYEUsWlS0Qv
         6xd1DmhBc2BwbpAJAfGhSwJAaxaHnLHy0VaMI8pkd038h6+dAF90SB5IuW6yXjXdOVC9
         xcpY9gfSGv3KGFnNFOgCaOTGW6zTwza6DioElD78WzYJRfab5xmg8l+y0r9qNUisYw0v
         /LTZdI8Wmh01ejBnJ5jQLYuRHR/cHrTTcURLTCSYlBhqwPUgZw52FIh+Gir33n/RH2Wm
         uuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736465310; x=1737070110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCd1luRCqJAyHxYbVfgNe3mydTTEDXhNVLI5rrCJRPA=;
        b=quwEez2xXFNkwptvKh8omCFWguHq8/EaIiVY38iIzyO9Piy+6SV5LWiK50OyUimltB
         VZ2OoUkxdKVrxa8P4M75gQ8/rI8Y9v2AiK4Cw46SHc7VVvnaV/0tzTbryCGj4Dce0s8r
         P8R89fKkrBsX2xBgsDDVAMGPonuvS6xvnrPkXzfoduHKqC9q7yvNPveEUXwZYA063G7t
         m0yS6I0Ddzv7kIy4akgaEBYauBKWEsO3cBrg7IM5ojwn244AhWEmqoW8NOEOkhmFehui
         VobdaB3jml8XuRIW4SYT7G5nQh0qG0Gnk/t/tL0LoppBda/7STo5ZsxT2MMznnh4dsI4
         Fb2A==
X-Forwarded-Encrypted: i=1; AJvYcCXiNyreY3rjDSEDbcN/T48ZgQkw0vKJ/WnvL+5goyXeakD5AR1w8oi49oOWgVLL71q7uL96PV1rbrc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2xby/1G5XLBB5yL0FGqsaAfbOjrRDVT4naFZ9+TOxK3iJFK9x
	0Gza1MMvRU70Rh7Ltv6ZhFBDZrOuP9rFpR8VOfaK8jRoVOYY3GCqwKscKqtcae0=
X-Gm-Gg: ASbGncvYueb58iEjqVyg4iCMqB628638HVs1dFb2clCXdFqw4tdZkYMIkfpzpFkq690
	s9xZ4FEBgP3t8gT6r5CRh3KkkuZHwLugBsHPNVZBz4aM7Pa3uw5Ry1c7dSvg+bojUcvqGFv2BcG
	I4J8JLbj6/I8co4EtSm+I3XNqlpkjAXGB4xNiyAEQOiLHPYqqxX5KPy+BgP7zcp069QQhsPRqIe
	AXd2SfYKB0iVino/SCSZPPAN9k+CNjxQBkcbAXORDXIRt6cexBa3ioGIV0f5EzX102Mnal4NU0r
	huF6o+tb5eVSkcyUNoXnSYdjVlnPVYiC
X-Google-Smtp-Source: AGHT+IH28s/MbJDw6bEncMP9oCvQpv59vZmeG7FDL7dNflBoPr2CfbmvUaO+SNELsoj3li0K4cyhGg==
X-Received: by 2002:a17:90b:53c7:b0:2ee:9e06:7db0 with SMTP id 98e67ed59e1d1-2f548f3400fmr12666455a91.11.1736465310272;
        Thu, 09 Jan 2025 15:28:30 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f5593fecc6sm2055390a91.19.2025.01.09.15.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 15:28:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tW1ww-00000003sh1-1nP1;
	Fri, 10 Jan 2025 10:28:26 +1100
Date: Fri, 10 Jan 2025 10:28:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chi Zhiling <chizhiling@163.com>, Amir Goldstein <amir73il@gmail.com>,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4BbmpgWn9lWUkp3@dread.disaster.area>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108173547.GI1306365@frogsfrogsfrogs>

On Wed, Jan 08, 2025 at 09:35:47AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 08, 2025 at 03:43:04PM +0800, Chi Zhiling wrote:
> > On 2025/1/7 20:13, Amir Goldstein wrote:
> > > Dave's answer to this question was that there are some legacy applications
> > > (database applications IIRC) on production systems that do rely on the fact
> > > that xfs provides this semantics and on the prerequisite that they run on xfs.
> > > 
> > > However, it was noted that:
> > > 1. Those application do not require atomicity for any size of IO, they
> > >      typically work in I/O size that is larger than block size (e.g. 16K or 64K)
> > >      and they only require no torn writes for this I/O size
> > > 2. Large folios and iomap can usually provide this semantics via folio lock,
> > >      but application has currently no way of knowing if the semantics are
> > >      provided or not
> > 
> > To be honest, it would be best if the folio lock could provide such
> > semantics, as it would not cause any potential problems for the
> > application, and we have hope to achieve concurrent writes.
> > 
> > However, I am not sure if this is easy to implement and will not cause
> > other problems.
> 
> Assuming we're not abandoning POSIX "Thread Interactions with Regular
> File Operations", you can't use the folio lock for coordination, for
> several reasons:
> 
> a) Apps can't directly control the size of the folio in the page cache
> 
> b) The folio size can (theoretically) change underneath the program at
> any time (reclaim can take your large folio and the next read gets a
> smaller folio)
> 
> c) If your write crosses folios, you've just crossed a synchronization
> boundary and all bets are off, though all the other filesystems behave
> this way and there seem not to be complaints
> 
> d) If you try to "guarantee" folio granularity by messing with min/max
> folio size, you run the risk of ENOMEM if the base pages get fragmented
> 
> I think that's why Dave suggested range locks as the correct solution to
> this; though it is a pity that so far nobody has come up with a
> performant implementation.

Yes, that's a fair summary of the situation.

That said, I just had a left-field idea for a quasi-range lock
that may allow random writes to run concurrently and atomically
with reads.

Essentially, we add an unsigned long to the inode, and use it as a
lock bitmap. That gives up to 64 "lock segments" for the buffered
write. We may also need a "segment size" variable....

The existing i_rwsem gets taken shared unless it is an extending
write.

For a non-extending write, we then do an offset->segment translation
and lock that bit in the bit mask. If it's already locked, we wait
on the lock bit. i.e. shared IOLOCK, exclusive write bit lock.

The segments are evenly sized - say a minimum of 64kB each, but when
EOF is extended or truncated (which is done with the i_rwsem held
exclusive) the segment size is rescaled. As nothing can hold bit
locks while the i_rwsem is held exclusive, this will not race with
anything.

If we are doing an extending write, we take the i_rwsem shared
first, then check if the extension will rescale the locks. If lock
rescaling is needed, we have to take the i_rwsem exclusive to do the
EOF extension. Otherwise, the bit lock that covers EOF will
serialise file extensions so it can be done under a shared i_rwsem
safely.

This will allow buffered writes to remain atomic w.r.t. each other,
and potentially allow buffered reads to wait on writes to the same
segment and so potentially provide buffered read vs buffered write
atomicity as well.

If we need more concurrency than an unsigned long worth of bits for
buffered writes, then maybe we can enlarge the bitmap further.

I suspect this can be extended to direct IO in a similar way to
buffered reads, and that then opens up the possibility of truncate
and fallocate() being able to use the bitmap for range exclusion,
too.

The overhead is likely minimal - setting and clearing bits in a
bitmap, as opposed to tracking ranges in a tree structure....

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
