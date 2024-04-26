Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04E22D03D
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714167412; cv=none; b=UryNUpOo00jc5jnI4oTJpDpUQEFUKd3Ng2Inu2dNXro6fmy9FFfa9Nc1bmUNamXFdzuNXqvCMSFS8gbUOkB3BFDCmBj7x2WL0NUho97BX2EuZ34NZ0f2V0vwf60Cz/30B1Gw5sqSq0GgOuMbsuvRlKRCx/sZLgx2xc+bhFVuBBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714167412; c=relaxed/simple;
	bh=k76bPd0gjWNDHnKIQuP6Q1j9Ush0tI3sOfqwGGeCkDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fsWR1c/M7+Y2HZUTdnmq4qVE93ERAXAghyjBm0WHQP3amvFxk5LOE5r3WJHuzd9Da6kjg5Fy4qv8cJ44nuFgUk0+E6QCivFpdo9rYI8YAA/r89nEE6nFMhINyWQnUmJ0pAKJ18vhT3yutCJZnXjnoZOP5lVD72UqOJSjh/7e22Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Bl5f0noG; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Bl5f0noG"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a2da57ab3aso2321162a91.3
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714167410; x=1714772210; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QJtFmQ5+PxyI0zzkbzopCLLSCW05zynZDvU06FC33Kg=;
        b=Bl5f0noGE1n1Ctu1BYJlPVz59G/XZMK75leLLRKjCqXPb3cM9RYK8TlSVyS4gnkDcB
         6KoL3j5dkj/qUPCueBL28J8F2wpbJ3Ns78ZFVw1aW4Si0vE+huy08/p3BvJlMQZrB3CE
         zoOIhwI+pJFdWwdXeTrqUaoJxwGmjYZwdrh2wylTwhwgLzAChWW0VLnsuf99S+fssSDp
         5xocCq2VN9HO8ipK20CZE8A8+YINEFYXGrCS1UqIaxVcpxawMrloToA2dJcms11R9Q0L
         4BFFTDbh3jwyU2gGsIARs3Y6cwbX19uJAg8BKWgy+pZwXacQObds8ikjj7ZNOYhJ9fNf
         7+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714167410; x=1714772210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJtFmQ5+PxyI0zzkbzopCLLSCW05zynZDvU06FC33Kg=;
        b=rw1cBJ+UZNLSZNsckKKGGiHjy2Wul7Twmr5JnfAz0+OkeOBxv6lRx/qI84jXSaqVQQ
         snfi9y6nv24Q4RtiK6uaiqv+6vcB2dYXs3I5DW7JK8JOzf/+xI+YP7mEBxFhuBh5Pd0c
         2dS4HqKzB8FbbLEbTmk2POxsC+myzocNlkwED7x4RWpCCwBg4IZjzNuoDq36x4fSzKZc
         w5CAljl+Uf3fMJnN5ef2ldLm9AzkQc02gsno8xA3kSW4qF35qIS/cFdZ028qkLeSkVxp
         bOSo8dAqH353mTi+u5vN1S7iR4sifF+A9mxch8asUUnq9a+3qnVpxnb+hPCjv2wnKVj+
         1Edg==
X-Forwarded-Encrypted: i=1; AJvYcCUxfbIipKhZ3arJikARr6WARC8DU2PAodNzBTHTsIecp/hzgiSKWTsFwul7nN039XVj8IjLbvKBrZQXWH65vJl6pTJTwrN1Wh9i
X-Gm-Message-State: AOJu0Yyd8GhMbX5GrS+bOR7IheLUiXJf/U4dC9f4FRLUSaYmGyxQKH1p
	77aeIlrs92v6VIts+ceUQ6SE37RD79G9sL/NvNVn+sm+lTFoAtHL5+WqMMx/h8I=
X-Google-Smtp-Source: AGHT+IFmc+RCoBKTzXGahw3W04/QE6IHRfllxdX6+wwRlssyDfe4FaWZC8l9940dp7jrpXgq341nDw==
X-Received: by 2002:a17:90a:a114:b0:2ae:8f3f:9bf2 with SMTP id s20-20020a17090aa11400b002ae8f3f9bf2mr3953512pjp.42.1714167410039;
        Fri, 26 Apr 2024 14:36:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id gn5-20020a17090ac78500b0029f349cc253sm16734964pjb.54.2024.04.26.14.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:36:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s0TFP-00C0ca-09;
	Sat, 27 Apr 2024 07:36:47 +1000
Date: Sat, 27 Apr 2024 07:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Sam Sun <samsun1006219@gmail.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	djwong@kernel.org, chandan.babu@oracle.com,
	syzkaller-bugs@googlegroups.com, xrivendell7@gmail.com
Subject: Re: [Linux kernel bug] KASAN: slab-out-of-bounds Read in xlog_cksum
Message-ID: <Ziweb7egkq2Ltn0d@dread.disaster.area>
References: <CAEkJfYO++C-pxyqzfoXFKEvmMQEnrgkQ2QcG6radAWJMqdXQCQ@mail.gmail.com>
 <ZipWt03PhXs2Yc84@infradead.org>
 <ZiphYrREkQvxkE-U@bfoster>
 <ZitF8eqWEYECruXo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZitF8eqWEYECruXo@infradead.org>

On Thu, Apr 25, 2024 at 11:13:05PM -0700, Christoph Hellwig wrote:
> On Thu, Apr 25, 2024 at 09:57:54AM -0400, Brian Foster wrote:
> > On Thu, Apr 25, 2024 at 06:12:23AM -0700, Christoph Hellwig wrote:
> > > This triggers the workaround for really old xfsprogs putting in a
> > > bogus h_size:
> > > 
> > > [   12.101992] XFS (loop0): invalid iclog size (0 bytes), using lsunit (65536 bytes)
> > > 
> > > but then calculates the log recovery buffer size based on the actual
> > > on-disk h_size value.  The patch below open codes xlog_logrec_hblks and
> > > fixes this particular reproducer.  But I wonder if we should limit the
> > > workaround.  Brian, you don't happpen to remember how old xfsprogs had
> > > to be to require your workaround (commit a70f9fe52daa8)?
> > > 
> > 
> > No, but a little digging turns up xfsprogs commit 20fbd4593ff2 ("libxfs:
> > format the log with valid log record headers"), which I think is what
> > you're looking for..? That went in around v4.5 or so, so I suppose
> > anything earlier than that is affected.
> 
> Thanks.  I was kinda hoping we could exclude v5 file systems from that
> workaround, but it is needed way too recent for that.

Any v5 filesystem with reflink and/or rmapbt enabled can be
excluded, as they didn't get added until 4.8 or after. All new
filesystems from here on should at least have reflink enabled, so
just returning EFSCORRUPTED and aborting recovery would be fine for
those filesystems....

OTOH, I think anyone using a 6.x kernel should be using a 6.x
xfsprogs, too, so maybe we should just remove the workaround from
upstream kernels altogether?

> Maybe we can specificly check for the wrongly hardcoded
> XLOG_HEADER_CYCLE_SIZE instead of allowing any value?

We probably should do that, too.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
