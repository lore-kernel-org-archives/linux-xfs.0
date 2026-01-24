Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216C1EACE
	for <linux-xfs@vger.kernel.org>; Sat, 24 Jan 2026 05:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769233644; cv=none; b=uVP82A5wNkXG4QYLoOs6gp8vNIUKZWmraH7IrKV4hBw6CryObgLgcX3uD2zAkouyW10IlrqO3sQ0kBGE5/lfsO5/EithdQWDAu8izLsedxZBNzw/BiFL30oNgUhoj4eWkqbGSkYhZ9Qo9PLNuB/KkMzdHIsXUYx1/TFpOeX0kkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769233644; c=relaxed/simple;
	bh=J85VsNgvoiH5DkDE7Ny5cHLFzXfBk4QwQhMWYnr6eeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAUbLt9dQgbt4idrXUNWaW1+yzfs8R3mY63zglTdBQ55uyVRPozkMbhOWL4Tar21atsMwetrkSGPOlqW5PClQa2VVU/oQ2nm4aI8ty3fLboIGkQAVX8KnYTPVonQwFqf3SswtlwoX1mknGu/au9jUn8mw1qyMQglbH1ot/x40UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZX2iiC7W; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rl+zBwJ9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZX2iiC7W";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rl+zBwJ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769233640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XigFiWB5XsbpjAsILWRqUR/lcAHzH2pfsn89FJ8Y6xA=;
	b=ZX2iiC7W6P5SkXw12DYOGm5psukFO3pUrIpfjwrsZksozfnieBoo42aBwUzDqHEG0nMt5K
	ojLzQWxQJKKXiG4bP8Y2fkB9Q9vPykqJB3b2kFXkv8cJUT0Vay8iH9jjHQM8/CK6p+YRbE
	G/yjfU074QD0VUoGY6x076xukmW7BOM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-HHpU0m06Oc60Ft1rCTACyw-1; Sat, 24 Jan 2026 00:47:18 -0500
X-MC-Unique: HHpU0m06Oc60Ft1rCTACyw-1
X-Mimecast-MFC-AGG-ID: HHpU0m06Oc60Ft1rCTACyw_1769233637
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c5eed9a994dso1409253a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 21:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769233637; x=1769838437; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XigFiWB5XsbpjAsILWRqUR/lcAHzH2pfsn89FJ8Y6xA=;
        b=Rl+zBwJ9JPy3X2brtvkd2hA5xCpqb2N2irl2p4lLtYOOHwH5EJeoruoDRc14yjsP8B
         lceNubNKpA9qbr57S4bJO36YxHNihNLpJJ6d0eqlegTCQHmPLVxbLtEYX1IV2jBUSWI8
         /LmInUktOxmzE6NveflcaZ2nwzxF8i3nAjLlg8IkPoiIvVD50mmr9SRNYIMLwDUM0RPv
         +mtn5ty2EGP4Aea5W60+Pn8CgNM5AsqOk2BWOxHDBYhmNTF484CXJwF9xmK2tvQb08x5
         t6DqK73sMeUAAftJPRNmdxnIamlLsMJdnYIG1P0jpcEJdHOfffD6Q2nQl/1wPu5cYu0E
         JfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769233637; x=1769838437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XigFiWB5XsbpjAsILWRqUR/lcAHzH2pfsn89FJ8Y6xA=;
        b=Y1OMLLo+pARy0cgbqXumskxeG7o8+JWhQFGR1BC5se0YvXsuE6khLv5TN2jupTeho+
         j+cr3pz2KHXAOT/J7VemkNAObdsVmpLa1VBwJcn1Fa74Wj8M42jAW9u7NEbPKsRdyNg5
         WNUAdAqdAAh7GKdsLdAHCeKYwxqUpBE7Twv9aPw7eFNrek2iI74mOoAIsnR6YOmbm7fA
         o5v1/9zyuYn+dxV+Jjfy+x5299QJJcF3g7gVsr1hUh8jue0cEVf/st3dy3IqhsZ5bvS6
         ZgcgAkaQyZV8BgsakPz8KATBbL7Q+gknWuhfhruOrEYy0zmtKuEnUvL0VIN1KZLFxVfk
         oQMg==
X-Forwarded-Encrypted: i=1; AJvYcCX0DsprhU9JaCMIvupiRtazCsQmGE9C05iSTVkt1LhUW4vvZYJmDE/6KIYBStHgRK3NY6iacxOA1jU=@vger.kernel.org
X-Gm-Message-State: AOJu0YztMS99/k1KU158yx/8KPirliwjBvurpAJJ2xJjsO4k1PGEIWtL
	UIh1UuDJBitqm8BBfcvHhVl+gJI3SuWmzRBCZcsTDBE3lWyrVo/F5KQwX3z+HR8NsAJINAMcKSw
	rsPUnliBCQcZAKgbTr8LfpcCfuYTypDVjgUmAA7y8c0WEhGODg5rVBOX1snEsUA==
X-Gm-Gg: AZuq6aLbny6nbr/rRbs7jJGJFRvPx1EMseth3o6diMuFXmIdF+rvvLWCrjKx+Dy8eXU
	s4SJqczR2jXLTDUJIUZuHVtW0s2Ov/y0JRPcCqf6i+YQ4RIxHOmJuq0YlnVSm7Q273w0dd4OWZH
	ArsAzjddjhr32X1Zoox7SbuwgNN3H8t/xm4U23k1nPcXg2L/B42zLrrJg+LWs7Ud5UP9lrYYjZq
	Gk9grAYeQqaa9thooUAcscXugBcgrre6h8vflqp9E1GDy3w6YF5aPbdH9ocuutK0wL5ReutdBwI
	jsq4xMqaGud/i94j2Udr+x/TCvkVEUij8Cvy0iHoXy8HoQ9pTrilFrQd/4blLIIOyD4gVfamLeH
	yhM9KMp1eUm3vXwS/nEfeOeg0MRrczL39leeIX8iE7vZ8u1SabA==
X-Received: by 2002:a05:6a21:618e:b0:35e:d74:e4b6 with SMTP id adf61e73a8af0-38e6f6c626amr5583900637.7.1769233637147;
        Fri, 23 Jan 2026 21:47:17 -0800 (PST)
X-Received: by 2002:a05:6a21:618e:b0:35e:d74:e4b6 with SMTP id adf61e73a8af0-38e6f6c626amr5583886637.7.1769233636721;
        Fri, 23 Jan 2026 21:47:16 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a16a106sm3444458a12.15.2026.01.23.21.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 21:47:15 -0800 (PST)
Date: Sat, 24 Jan 2026 13:47:11 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] misc: allow zero duration for fsstress and fsx
Message-ID: <20260124054711.3psxdefyfx6z5ps5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260121012621.GE15541@frogsfrogsfrogs>
 <20260121155456.pf6jeprhzua3rdl3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20260121174601.GE5945@frogsfrogsfrogs>
 <20260122072100.2aynewdegsdz7stz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20260122161351.GA5916@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122161351.GA5916@frogsfrogsfrogs>

On Thu, Jan 22, 2026 at 08:13:51AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 22, 2026 at 03:21:00PM +0800, Zorro Lang wrote:
> > On Wed, Jan 21, 2026 at 09:46:01AM -0800, Darrick J. Wong wrote:
> > > On Wed, Jan 21, 2026 at 11:54:56PM +0800, Zorro Lang wrote:
> > > > On Tue, Jan 20, 2026 at 05:26:21PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Occasionally the common/fuzzy fuzz test helpers manage to time
> > > > > something just right such that fsx or fsstress get invoked with a zero
> > > > > second duration.  It's harmless to exit immediately without doing
> > > > > anything, so allow this corner case.
> > > > 
> > > > Sure, duration=0 is harmless, I'm good with this patch.
> > > > 
> > > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > > 
> > > > Please excuse my nitpicking. I'm curious about the semantics of "--duration=0".
> > > > Looking at the output of `fsstress -v --duration=0`, it doesn't actually
> > > > 'do nothing.' Instead, it behaves similarly to duration=1, where fsstress
> > > > attempts to execute operations before timing out and exiting :-D
> > > 
> > > Yeah, I suppose it's possible to do a very small amount of work.
> > > 
> > > Would you mind changing that last sentence to read "It's harmless to
> > > exit almost immediately having done very little work, so allow this
> > > corner case." prior to commit?
> > 
> > Sure Darick, I can make that change prior to commit :) But I was just
> > curious to hear your thoughts on:
> > 
> >   if (duration == 0) {
> >           /* No action is taken if duration is 0 */
> >           exit(0);
> >   } else if (duration < 0) {
> >           fprintf(stderr, "%lld: invalid duration\n", duration);
> > 	  exit(88);
> >   }
> > 
> > do you feel that makes more sense semantically :)
> 
> That would also work. Would you rather have the exits-immediately
> version?  

If both versions are good to you, I perfer the "exits-immediately" one, at least
it fits the semantics of 0 better :)

To save your time I can make this change when I merge it if you agree with that
too. Let me know if there's anything else you'd like to add.

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > > 
> > > > > Cc: <fstests@vger.kernel.org> # v2023.05.01
> > > > > Fixes: 3e85dd4fe4236d ("misc: add duration for long soak tests")
> > > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > ---
> > > > >  ltp/fsstress.c |    2 +-
> > > > >  ltp/fsx.c      |    2 +-
> > > > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > > > > index c17ac440414325..b51bd8ada2a3be 100644
> > > > > --- a/ltp/fsstress.c
> > > > > +++ b/ltp/fsstress.c
> > > > > @@ -645,7 +645,7 @@ int main(int argc, char **argv)
> > > > >  				exit(87);
> > > > >  			}
> > > > >  			duration = strtoll(optarg, NULL, 0);
> > > > > -			if (duration < 1) {
> > > > > +			if (duration < 0) {
> > > > >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> > > > >  				exit(88);
> > > > >  			}
> > > > > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > > > > index 626976dd4f9f27..4f8a2d5ab1fc08 100644
> > > > > --- a/ltp/fsx.c
> > > > > +++ b/ltp/fsx.c
> > > > > @@ -3375,7 +3375,7 @@ main(int argc, char **argv)
> > > > >  				exit(87);
> > > > >  			}
> > > > >  			duration = strtoll(optarg, NULL, 0);
> > > > > -			if (duration < 1) {
> > > > > +			if (duration < 0) {
> > > > >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> > > > >  				exit(88);
> > > > >  			}
> > > > > 
> > > > 
> > > > 
> > > 
> > 
> > 
> 

