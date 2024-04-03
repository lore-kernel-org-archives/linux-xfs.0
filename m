Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B38171A7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 06:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712126055; cv=none; b=POREX3s9ChJPC/il9UVYrBDDgX9KsEjtQeVQ9+dl/vWy5s6qqBA+rMtvWx64L8CZ5kJ+AvajMLDdlGLNvEu1sIHqVmSWvDHEtWYpqPiAF8MZ4GXdcrOS6BeO5OabXFRlt0xF+NYM+yPkPpZM8XVbqLDefa3OwPCjefRDl8CuVnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712126055; c=relaxed/simple;
	bh=01iyNj8iidz39psJMI5W39R8BCtiBgSwlP6w2Ccjpnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=En9HaMEEjn/8TJwVxDnH9jFYbHzsNxqoO36CVWb2ZVzlKpZvKixNedE9BbBGnpG3mUXWdj/k6sHSm1Atwodh+wal7gx8J0WbPnk9gjWbDl08GCj0cIRt34NJQL7gsbqu2016hm9knUvuHisdzBBv58eEyoWOxKsKhA0wvtPF1es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=PtYYq/+J; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="PtYYq/+J"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e28856ed7aso7805475ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 23:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712126053; x=1712730853; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LipPMy6gHKKFzEVh8un5K9NQcpzqdsCvNz1z10g0RiA=;
        b=PtYYq/+JHvuJ/2M3BPmBHw9qcdbtZGl7mKSzqXj+zPNEY4g9hR6DXq0hCTQqmF0iWA
         cB9gcsDS4OdfMwCwEQbPkOLASf/nFgqMpmAJMrf9cGg1jS0IzVppQ/uuAIsASbci5OyQ
         KeFbGPirTkOB37gW6dDQOR6aA7k3pmE6tDeKuD6U8qiPFT6HL8KRULIj+rMnQ0e0nnlv
         OGhtJGh1J2cDL8lSahCqNusPDOJKZfvgQqgzgu0E9sJv4KdIJGXYqFXIBM42YSPgjBOX
         YhSz0MLGvteqFMOl5uhMUyu+wd90zhbylX6PcSLBAy7qTVGbu+JiqIXG0/lSXhM9vE90
         Q/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712126053; x=1712730853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LipPMy6gHKKFzEVh8un5K9NQcpzqdsCvNz1z10g0RiA=;
        b=AWWRs5wx61Iw+j8suVVgq47TUHXeW8Oh+lCNi1lzpIrODXDJHoXdx0aiXnzojhiQG8
         fM9Zq5cQbuw3QOoPM46yt96Hciym7oIwJicxj1H2+alR12cB2IvksurD6F0+zoDYgxKB
         zNMlKta+TZepauOU7lZjnOEBWJAA26sdQYI9JwjsrCuWKdVFcGokixuLrbIBbEb9Xs9A
         esOtzar34XWrFTeJQVSvCDBDS7OsD7ajTPITuT6su9fxkZjygyRMxjqWFAVt02TooH+D
         s7XsNoII35p3k7GHDLuCVm/bLqZ6H5o2pRCLvXEehypE689mxPUwUK5QTD5JCNvIr+zj
         tapg==
X-Gm-Message-State: AOJu0Yz60VJ842ejFuXvZ/UOKeRq2Qofog5yhirEyGhDTkh+GrP2UOd6
	zHbrxRinPLdk7hJIM9E2JQd8vmYTZ/PYA3l/gn6vTVUNDn9y/+7eaW9oXGkmleY=
X-Google-Smtp-Source: AGHT+IH5XOhkyQkZSinNMUGoawCAgGakmx1Imhl6rPUBAQJaWOsIbFF65EYoKvS2b6C5BPWHtL69KA==
X-Received: by 2002:a17:902:d385:b0:1e2:887a:68a7 with SMTP id e5-20020a170902d38500b001e2887a68a7mr1755848pld.33.1712126052699;
        Tue, 02 Apr 2024 23:34:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id ks7-20020a170903084700b001e27aaabc0csm734177plb.78.2024.04.02.23.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 23:34:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rruCI-002ELZ-00;
	Wed, 03 Apr 2024 17:34:10 +1100
Date: Wed, 3 Apr 2024 17:34:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 2/4] xfs: xfs_alloc_file_space() fails to detect ENOSPC
Message-ID: <Zgz4YXUp+fFEN3qp@dread.disaster.area>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-3-david@fromorbit.com>
 <ZgzdtYGyVN1-UQdM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgzdtYGyVN1-UQdM@infradead.org>

On Tue, Apr 02, 2024 at 09:40:21PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 03, 2024 at 08:38:17AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_alloc_file_space ends up in an endless loop when
> > xfs_bmapi_write() returns nimaps == 0 at ENOSPC. The process is
> > unkillable, and so just runs around in a tight circle burning CPU
> > until the system is rebooted.
> 
> What is your reproducer?  Let's just fix this for real.

Run the reproducer in this bug report on a TOT kernel, and the
XFS_IOC_RESVSP call will livelock:

https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com/

That has nothing to do with delalloc - free space accounting was
screwed up by a reserve blocks ioctl, and so when allocation fails
it just runs around in a tight circle and cannot be broken out of.

Regardless of the reproducer that corrupts free space accounting,
there is no guarantee that allocations will succeed even if there is
free space available. Hence this loop must have a way to break out
when allocation fails. This becomes even more apparent with the
forced alignment feature - as soon as we run out of contiguous free
space for aligned allocation, allocations will persistently fail
when there is plenty of free space still available.

Given that the fix was for something that doesn't currently exist
(RT delalloc) the only sane thing to do right now is revert the fix
and push that revert back to the stable kernels that are susceptible
to this livelock. 

I don't know exactly how the orginal delalloc issue was triggered,
let alone had the time to time to understand how to actually
fix it properly. The code as it stands contains a regression and so
the first thing we need to do is revert the change so we can
backport it....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
