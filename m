Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815A71A5B8F
	for <linux-xfs@vger.kernel.org>; Thu, 29 May 2025 04:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748493397; cv=none; b=ud+t/EcVhr/tcupGaoMSzOms0wXc1eUTEJSSmZ3oXSIt98D3rbiXUeU993AdXAzkR18h/4ZaoHn8Ecez8+1260IjrkWIuOWKASKlUyd0PKLXMmbVvxCCJZfr0lsuCZI8leOJeEO+72tlfXVNjB10Xe1/3no0q4z36wBcz/z2Rqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748493397; c=relaxed/simple;
	bh=/aAE8PQ4Eq42jFjznP25L4UOSJMqseibpFa1FKn+2DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tldLi4VVs3XhGY9fe+1qTCLF/Kyrz1+TBW4bgOahqX7xNfvm+NXsxrsImPCCWZq0fsZ6m7ZU/wqDtfT41Gpwab0291ERMTiyqVIj3Zd6CC+YGbONkV27SjRbBCALHBIRaU/xVpjPoNKSask1uyQ5dhhmw3Q0z+0CImQsNQwbR2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LQxYFuOO; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LQxYFuOO"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-234b9dfb842so5066355ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 May 2025 21:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1748493394; x=1749098194; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+1O4w2je/tYdlFGEn+TC9L2CRnIFOJ94HhRwCNdSpXA=;
        b=LQxYFuOO0XgGNGcYrDOfyZY5HwA8uoF28DELWWYOZo+SjTRqql/zmbpgW3VWRUf/3u
         k9wFWRVGNJFUmHsHEN7RTvzlIYkLADBSrn/uPbFjdreO5/nXjlKBt0h0sS579lK2wpzH
         FUCAdQcIHZVOlNAoEUW/RB0WEr7YqcGZAwK/0j2jvax4rOYT8LwOrBT1aeqOFcIUDwws
         VIId44lbrtnFjTJyxKT4C1SBFcRApAzHhnR0CUHL9B3RuXjriM3A7bqnmCDNBFFmm4Yf
         GEluvCMPDAmpYQoO/TbcQSBNJIr5UqSJrQr3izpAa8cUMcCYGcLIRiIJnrc2zYNttkkM
         8v3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748493394; x=1749098194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1O4w2je/tYdlFGEn+TC9L2CRnIFOJ94HhRwCNdSpXA=;
        b=n4PHVmOfjORQXedjXzCcIL1oHkQSHLrVZY9a4AMnceZGZGC+sjfrIPizedjz6/IpOy
         tdaVoxCQZqhevweQPEf/YNFQEF2nqIaUSqZyaF2kQyz566dCp7yb5yW/Olx41khUvL6m
         oTp6Mz3hvQ8cm9rc8rf+5Vstht5L2LDC53di9pNLfX4TSUJCHr78qbA+jDhHaw7MM0t4
         jc5zJjEICkRCxWrq0SterF2ABUReAGKVBVG3oxhE+3jhXXgW59ewYXQL8Y7JN9mi0VuJ
         re/BTtjPrSnyO9AOJxP7nnGZlzDtn8h8ypeVMwejB8mtm/VRtAEXwHfjLAN3NsMBssBt
         uF9w==
X-Forwarded-Encrypted: i=1; AJvYcCXjCAKK5K0cvu4X1pP6w4SOqRtSD0AkWFG5FzHtymIdDltOFVDHAaj+cxZ2+aGDhwJAvQWXHmmkN40=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWbFLAY/g0jYiz+fREvXCiQYk8QI3apOPV2/l/Ft82AG46A2T9
	Z3hI/5Hwcm2WHtbus4p135TvRPQ6AxPa8z5m2XHa9EQuOqQIrcCiwJIoZO4SyyWF18Y=
X-Gm-Gg: ASbGncvNE/7w82wxqeJWk+P9vGbIjITxYayDbBW2RFBc/1h/L60J6oZnYvTCftlVeHj
	2AkcPoFG2LhkMf3+dvxhDaVg48xr4e5PSrCTmMFNA+ed0UHw3UxnwVE+OB/H831OyXgjaTLMlVb
	xjbKkkF6tu4MmWZFSqsLTEy58L0q+GzUDG+t7J3YxXpJyzsj8F/zLZlcpgs9evt2NoKHlbtEmY2
	P7L6fGFCu6CTR5WCHA0FtKuqBGGjSMrid9SZEXuW5/Mw3bApUxxuErMS2jwjEdERA+FMi4XEZPC
	moejfo5Evj0fqK7tSVUn9nXeyFchU0g1v6agPpkpU8Rp6HUO5e/LBfodP/vkdrUGMZNqH7RmPeB
	pONWoKC0DcT3l+L8q
X-Google-Smtp-Source: AGHT+IHIgAO2lsClFdwJkF17Bm7HKwxTZ8x+hNA5gd6TNfZdL6Y3/KIDmW7/6Xy7Y8KRZoEajill7g==
X-Received: by 2002:a17:903:41cc:b0:232:202e:ab18 with SMTP id d9443c01a7336-23414f6f7femr234658245ad.26.1748493393680;
        Wed, 28 May 2025 21:36:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506cd3558sm3979585ad.122.2025.05.28.21.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 21:36:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uKV0I-00000009UZb-1kfn;
	Thu, 29 May 2025 14:36:30 +1000
Date: Thu, 29 May 2025 14:36:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [QUESTION] xfs, iomap: Handle writeback errors to prevent silent
 data corruption
Message-ID: <aDfkTiTNH1UPKvC7@dread.disaster.area>
References: <CALOAHbDm7-byF8DCg1JH5rb4Yi8FBtrsicojrPvYq8AND=e6hQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbDm7-byF8DCg1JH5rb4Yi8FBtrsicojrPvYq8AND=e6hQ@mail.gmail.com>

On Thu, May 29, 2025 at 10:50:01AM +0800, Yafang Shao wrote:
> Hello,
> 
> Recently, we encountered data loss when using XFS on an HDD with bad
> blocks. After investigation, we determined that the issue was related
> to writeback errors. The details are as follows:
> 
> 1. Process-A writes data to a file using buffered I/O and completes
> without errors.
> 2. However, during the writeback of the dirtied pagecache pages, an
> I/O error occurs, causing the data to fail to reach the disk.
> 3. Later, the pagecache pages may be reclaimed due to memory pressure,
> since they are already clean pages.
> 4. When Process-B reads the same file, it retrieves zeroed data from
> the bad blocks, as the original data was never successfully written
> (IOMAP_UNWRITTEN).
> 
> We reviewed the related discussion [0] and confirmed that this is a
> known writeback error issue. While using fsync() after buffered
> write() could mitigate the problem, this approach is impractical for
> our services.

Really, that's terrible application design.  If you aren't checking
that data has been written successfully, then you get to keep all
the broken and/or missing data bits to yourself.

However, with that said, some history.

XFS used to keep pages that had IO errors on writeback dirty so they
would be retried at a later time and couldn't be reclaimed from
memory until they were written. This was historical behaviour from
Irix and designed to handle SAN environments where multipath
fail-over could take several minutes.

In these situations writeback could fail for several attempts before
the storage timed out and came back online. Then the next write
retry would succeed, and everything would be good. Linux never gave
us a specific IO error for this case, so we just had to retry on EIO
and hope that the storage came back eventually.

This is different to traditional Linux writeback behaviour, which is
what is implemented now via iomap. There are good reasons for this
model:

- a filesystem with a dirty page that can't be written and cleaned
  cannot be unmounted.

- having large chunks of memory that cannot be cleaned and
  reclaimed has adverse impact on system performance

- the system can potentially hang if the page cache is dirtied
  beyond write throttling thresholds and then the device is yanked.
  Now none of the dirty memory can be cleaned, and all new writes
  are throttled....

> Instead, we propose introducing configurable options to notify users
> of writeback errors immediately and prevent further operations on
> affected files or disks. Possible solutions include:
> 
> - Option A: Immediately shut down the filesystem upon writeback errors.
> - Option B: Mark the affected file as inaccessible if a writeback error occurs.

Go look at /sys/fs/xfs/<dev>/error/metadata/... and configurable
error handling behaviour implemented through this interface.

Essential, XFS metadata behaves as "retry writes forever and hang on
unmount until write succeeds" by default. i.e. similar to the old
data IO error behaviour. The "hang on unmount" behaviour can be
turned off by /sys/fs/xfs/<dev>/error/fail_at_unmount, and we can
configured different failure handling policies for different types
of IO error. e.g. fail-fast on -ENODEV (e.g. device was unplugged
and is never coming back so shut the filesystem down),
retry-for-while on -ENOSPC (e.g. dm-thinp pool has run out of space,
so give some time for the pool to be expanded before shutting down)
and retry-once on -EIO (to avoid random spurious hardware failures
from shutting down the fs) and everything else uses the configured
default behaviour....

There's also good reason the sysfs error heirarchy is structured the
way it is - it leaves open the option for expanding the error
handling policies to different IO types (i.e. data and metadata). It
even allows different policies for different types of data devices
(e.g. RT vs data device policies).

So, got look at how the error configuration code in XFS is handled,
consider extending that to /sys/fs/xfs/<dev>/error/data/.... to
allow different error handling policies for different types of
data writeback IO errors.

Then you'll need to implement those policies through the XFS and
iomap IO paths...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
