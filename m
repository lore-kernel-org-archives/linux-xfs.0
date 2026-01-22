Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968E632BF26
	for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 07:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769066472; cv=none; b=LglR9R8grWW1CHY5YuSg4kDXoagjqrdJ1LoHQmff+rP3REx20kuAQAt5pIjlP6swHcWW5l9L9Kmg+ypr/Bhgkoi4R8Wbyx6vXURZusYdRnEDZtpSAprEPBRKy/YInTfpkni6792Whvpvb3AyrgV8gj/7KW1HNuvMv4YKiWp8f2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769066472; c=relaxed/simple;
	bh=SxcONQsF6MjmeNPm6XPEu9NpglWa3Hf4iHN8GK7LgIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tm1XgD5NESUlYTK8vGSf1j8vJhBBsfia3jDI0FEYYLo2x7isqRKxHhMfSw+FhcgmP987zIvnhWPI4jHEFg7SeE441+AiNWqRwB4UlyA/+WsbJhxEo/wKt8SK/LmUoIiEz0ORZIFfOCIdJVEehPEmPLpkbeyGFAJOSkltpzDTu2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KChR+2vT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dT3CEFE2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KChR+2vT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dT3CEFE2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769066468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qslT+6XhgV1DLTYR/u+J/nSX2XrGFjhj3ShPzwpoNw0=;
	b=KChR+2vT8KMRSPLPuavIv+yHrrpUrxgEWOfEi03p5dFeOvQTjua6oXOxGfRZz+9IT8mKB0
	mcK1f3hURHM2YkbUJUXxm4YGCL3wpAZ2JsIJkUz7ipO6Kc4PwnK8IjeX5ocw1Lfu2aBY9V
	1fNzJe+0fBQGCQRQuZ3LsUphV3CLIkA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-Cqdgc_vmPXGk8qRRWBg5PQ-1; Thu, 22 Jan 2026 02:21:06 -0500
X-MC-Unique: Cqdgc_vmPXGk8qRRWBg5PQ-1
X-Mimecast-MFC-AGG-ID: Cqdgc_vmPXGk8qRRWBg5PQ_1769066466
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso1417524a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 23:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769066465; x=1769671265; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qslT+6XhgV1DLTYR/u+J/nSX2XrGFjhj3ShPzwpoNw0=;
        b=dT3CEFE2QMmAqv/PM8iN+b3xh/LP5xJSXGUNUbe8f6pNfcz/R4cCpYs4qqbanT1pn4
         p1EhuZv6ICH9/IaRxXSFpNruJtOLFpj9W18Zq5BiJJWl+SN0KcG/B4m6Evb9lmyGDnma
         VRRIvjVWl8yNaMWeFfP0Lli/aRd2A/95Yp442xCt1VHK7aP8Hh67hZ51oye+6FkkspAU
         +ISmVTIQSDau6nQJtJHFuK56Us7S1Cf0mevLexiJJGcBMJe4Bd+TJu7M0GVMpZThH8Xl
         m93RFShvcocM8cp5KeZfpDLtRnIpT4cP1tEemr2ElMHLmC2MaovHSf+IptgqMNoxiLt+
         WODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769066465; x=1769671265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qslT+6XhgV1DLTYR/u+J/nSX2XrGFjhj3ShPzwpoNw0=;
        b=E7DPq+jvTKBakm3cdQZIseT7XKNBxcohnakxahWTsaGTljshrMe/wSJhG3fJdn6d0A
         N9+MQN8BXVV8LFW01GNetGoWrvttRzA0nyZKVpgV5taum/Uwp7mJModqRfzipFtAbuVQ
         4NIskie1Aucxs+6+7buF2h1O+Zm5PeWGiHvvh83aT5W/CbTuJEAo4O+tpR3g0AwWmfqp
         7YvN63bVIQi8SXn0xz5FITBuQbZ8lmam9QNIekSQapv2NRQlAbl0adQqUPUmM8/v9v6G
         wPSyhiS9C+VLTLOQLkDaWskNlWq4gKSJ9mf+yAQFIvg+V7UCvjyVjp1C+Y993+vBz9Ic
         f6KA==
X-Forwarded-Encrypted: i=1; AJvYcCUYQvfzoYEnWqK7XMXZGfC9w+zL/WPHhQZU+2u6Cha7DV0Hh6Jndo15+ya+RLiLWB/iTCtAJ6s1Zxg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+4T/DmaU2cthCPeTM0Ll/Zk8VZ1GKlkc4egBmbXq7Tj5exS4B
	tz0xFmPBkK7zspPhN/rMziM9JahuQ1Pdm76UKOOdNCQgRe6tsw0pTGDi3GMNdiS+I8CLBy2gnD6
	OVgu+1qOoHZiPX3OC9s1m2xROWSO+q9d4+VdVTsfMk/5yw3bVLCKTrOsYD3m9IA==
X-Gm-Gg: AZuq6aL/95KUG0aSHNXZD8j59ZbuV0+VLPWRlGAecUJoq43QLS1xyADUThViJuEz4jh
	99bjXLqmaa+IxV9xzmQwOYzzb9fHb4u0/IAnjpQznDXmKWsSwhkKG7dEqECBrbFgi6XCHIWrt4O
	IVKRPYFWDAmZjLhTSrFJSXjyheg+s14aan3Ig608RSC+h60HbAj30T5UDPMEzxjxLgGOsDLxPmi
	DDanf9WyOfVV6pCUFZAcvL0ora1yX7lBRJWLaU45CInKFH2ZtWjuYzyzaf0z7/v7u4JxuD3TgWT
	+J/9MlR8pyEpjSN0IIPCwMJHsfCWdwI3mswR8Mu7ldZDYPNgGrJhaI0Ac4oRhJv1VHqSTYp9dze
	jp9+jRrTbIQnLVwiZ5VRqzaS0ariWzxq17pbaI+gWFBptryqLcA==
X-Received: by 2002:a17:90b:4a41:b0:352:fa96:5137 with SMTP id 98e67ed59e1d1-352fa96538emr4747866a91.21.1769066465516;
        Wed, 21 Jan 2026 23:21:05 -0800 (PST)
X-Received: by 2002:a17:90b:4a41:b0:352:fa96:5137 with SMTP id 98e67ed59e1d1-352fa96538emr4747838a91.21.1769066464961;
        Wed, 21 Jan 2026 23:21:04 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf2330d4sm16993342a12.5.2026.01.21.23.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 23:21:04 -0800 (PST)
Date: Thu, 22 Jan 2026 15:21:00 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] misc: allow zero duration for fsstress and fsx
Message-ID: <20260122072100.2aynewdegsdz7stz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260121012621.GE15541@frogsfrogsfrogs>
 <20260121155456.pf6jeprhzua3rdl3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20260121174601.GE5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121174601.GE5945@frogsfrogsfrogs>

On Wed, Jan 21, 2026 at 09:46:01AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 21, 2026 at 11:54:56PM +0800, Zorro Lang wrote:
> > On Tue, Jan 20, 2026 at 05:26:21PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Occasionally the common/fuzzy fuzz test helpers manage to time
> > > something just right such that fsx or fsstress get invoked with a zero
> > > second duration.  It's harmless to exit immediately without doing
> > > anything, so allow this corner case.
> > 
> > Sure, duration=0 is harmless, I'm good with this patch.
> > 
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > Please excuse my nitpicking. I'm curious about the semantics of "--duration=0".
> > Looking at the output of `fsstress -v --duration=0`, it doesn't actually
> > 'do nothing.' Instead, it behaves similarly to duration=1, where fsstress
> > attempts to execute operations before timing out and exiting :-D
> 
> Yeah, I suppose it's possible to do a very small amount of work.
> 
> Would you mind changing that last sentence to read "It's harmless to
> exit almost immediately having done very little work, so allow this
> corner case." prior to commit?

Sure Darick, I can make that change prior to commit :) But I was just
curious to hear your thoughts on:

  if (duration == 0) {
          /* No action is taken if duration is 0 */
          exit(0);
  } else if (duration < 0) {
          fprintf(stderr, "%lld: invalid duration\n", duration);
	  exit(88);
  }

do you feel that makes more sense semantically :)

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > Cc: <fstests@vger.kernel.org> # v2023.05.01
> > > Fixes: 3e85dd4fe4236d ("misc: add duration for long soak tests")
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > >  ltp/fsstress.c |    2 +-
> > >  ltp/fsx.c      |    2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > > index c17ac440414325..b51bd8ada2a3be 100644
> > > --- a/ltp/fsstress.c
> > > +++ b/ltp/fsstress.c
> > > @@ -645,7 +645,7 @@ int main(int argc, char **argv)
> > >  				exit(87);
> > >  			}
> > >  			duration = strtoll(optarg, NULL, 0);
> > > -			if (duration < 1) {
> > > +			if (duration < 0) {
> > >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> > >  				exit(88);
> > >  			}
> > > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > > index 626976dd4f9f27..4f8a2d5ab1fc08 100644
> > > --- a/ltp/fsx.c
> > > +++ b/ltp/fsx.c
> > > @@ -3375,7 +3375,7 @@ main(int argc, char **argv)
> > >  				exit(87);
> > >  			}
> > >  			duration = strtoll(optarg, NULL, 0);
> > > -			if (duration < 1) {
> > > +			if (duration < 0) {
> > >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> > >  				exit(88);
> > >  			}
> > > 
> > 
> > 
> 

