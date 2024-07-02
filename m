Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7148158853
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719963882; cv=none; b=QZdfqpxu7YpRUTgoXXElTwqdkGF5NGUx4o9vaI6DTihoa8V4DAE7lEmWWxOSdP4K6q0uNPG0ApMPsmFPdidr4oaxc2DfzYEJ2W7k+0SgP0o9/sXyUwDHN90flzbVClBID6HGWkLi+XlMhA6s6CwT1UMqeaCJ1Qn/+XjQwA3qn4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719963882; c=relaxed/simple;
	bh=R1kdNIGoCaWsREHCUMwJVGjiiGc9/mWffR7Nmk/5mdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4mvHzodfIhMQydgXDTmbB3LSkV0cViv9j3OTEicGo9VQrBGj/EPspIMvXzVoYJmk8ltRQ5AD6CSmS+IRb5KllC8Yq/MkW7GimaMzmjaf6sYmuKo65ghAmMjsoaZ13XsCRLGOgCVk9kOU52g48AmPL3Gh3icmiXM7WFa3cAyIwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XBWcy1D0; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XBWcy1D0"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2c8c6cc53c7so3320085a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2024 16:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719963880; x=1720568680; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E8C8pGBl6PwQv/QUgN+lCj1NZP+HloIAvEgarAJ98W0=;
        b=XBWcy1D08mH3db+GL/2YHwmqFqLkTcLuzLhT4toXTi+Gbx4VOwTqTp+Lm+SfHA0lYF
         qA6+6CmeHmy6SXR1Z96UEBZt5J8vSrI2BnQcdddOLJCjWUxz7vGRPYzFzZpJNbOXPsxq
         /cKRFAJa+uAxzT0SjdJY+uYa385+oJUG930ITHy3Ex62z5EVWsmx3CEQSiKxhJ2dOoCQ
         4jiJeddgwNnbiw9NYjaxbgkmPvsPv6NJzXymqiKuY9xRRRA1WXhMb6B9iXznlV4bA0pV
         9AOVpQLQc428Y0OWK9VMnkORzoIiONVx3jvc/2xh81mlOZfmeGqr/KmmAe1QGtp8+MDv
         eS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719963880; x=1720568680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8C8pGBl6PwQv/QUgN+lCj1NZP+HloIAvEgarAJ98W0=;
        b=aMiFvzGWrfRV7HFy0Et0qPox7EYhXy5t1q1gwTdhuH/gRAJUf9s+Mjpw2Dv6x2o2Ws
         3ZvX8JrXc4IFQsPA1S6OGmrisDkHYO2z7tq8VFz/KGUXOUm0yHSc/iw+Dw0kIUioct7V
         w1XJHeQM6M1t0CPzUroFWk8W3/Ln2cl7559hmWMSkyGIg6I55CdM3rPRnE+/6cHqLJwE
         KdMlBRxjzOE4Il6cPSYrDdjvIcWIVLrDezn+PGpAAxlUaqJI+UwISl+Rg8qQXW95Nx8r
         LREO1ZPx24bYBefeZZvPM0AGKzX15NwyEzJqOnrpiST//y3szE4VVC54jYwRzeoVKzSU
         pdcw==
X-Forwarded-Encrypted: i=1; AJvYcCXyLTln81hvKcwyhX7Qwqt35K7yb+2B9lhKNDxYEhP/5cFiBIt3MZyz+iUjkKbDKaPsWNFIVdCr9Va2x2dhD5AVUzm/heVBecg9
X-Gm-Message-State: AOJu0YxfUmIfjeDipoAY21QWq1SNZKNTCt1/TEC+BJv+RTzAWAtldS1W
	x1UXQMhzgeg4aQlqdTzjNA9HkiUSdamL+x+iVMgQ6D29rnUbPlK7VTZ5Q7De1sE=
X-Google-Smtp-Source: AGHT+IETsvkjzYuCKZ9p0+Ku62Va5mDUhoO32TyPvDTm6zW6hZFOLGO3Cd9d34Mox5TYkCVzYBNnjg==
X-Received: by 2002:a17:90b:1884:b0:2c9:6ad7:659d with SMTP id 98e67ed59e1d1-2c96ad76752mr1638316a91.6.1719963879903;
        Tue, 02 Jul 2024 16:44:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91ce4333esm9464957a91.18.2024.07.02.16.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 16:44:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sOnAq-0022iT-21;
	Wed, 03 Jul 2024 09:44:36 +1000
Date: Wed, 3 Jul 2024 09:44:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: alexjlzheng@gmail.com, chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: Re: [PATCH v3 2/2] xfs: make xfs_log_iovec independent from
 xfs_log_vec and free it early
Message-ID: <ZoSQ5BAhpwoYN4Dz@dread.disaster.area>
References: <20240626044909.15060-1-alexjlzheng@tencent.com>
 <20240626044909.15060-3-alexjlzheng@tencent.com>
 <ZoH9gVVlwMkQO1dm@dread.disaster.area>
 <ZoI1P1KQzQVVUzny@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoI1P1KQzQVVUzny@infradead.org>

On Sun, Jun 30, 2024 at 09:49:03PM -0700, Christoph Hellwig wrote:
> On Mon, Jul 01, 2024 at 10:51:13AM +1000, Dave Chinner wrote:
> > Here's the logic - the iovec array is largely "free" with the larger
> > data allocation.
> 
> What the patch does it to free the data allocation, that is the shadow
> buffer earlier.  Which would safe a quite a bit of memory indeed ... if
> we didn't expect the shadow buffer to be needed again a little later
> anyway, which AFAIK is the assumption under which the CIL code operates.

Ah, ok, my bad. I missed that because the xfs_log_iovec is not the
data buffer - it is specifically just the iovec array that indexes
the data buffer. Everything in the commit message references the
xfs_log_iovec, and makes no mention of the actual logged metadata
that is being stored, and I didn't catch that the submitter was
using xfs_log_iovec to mean something different to what I understand
it to be from looking at the code. That's why I take the time to
explain my reasoning - so that people aren't in any doubt about how
I interpretted the changes and can easily point out where I've gone
wrong. :)

> So as asked previously and by you again here I'd love to see numbers
> for workloads where this actually is a benefit.

Yup, it doesn't change the basic premise that no allocations in the
fast path is faster than doing even one allocation in the fast
path. I made the explicit design choice to consume that
memory as a necessary cost of going fast, and the memory is already
being consumed while the objects are sitting and being relogged in
the CIL before the CIL is formatted and checkpointed.

Hence I'm not sure that freeing it before the checkpoint IO is
submitted actually reduces the memory footprint significantly at
all. Numbers and workloads are definitely needed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
