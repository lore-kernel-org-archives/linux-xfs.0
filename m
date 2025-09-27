Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0CB2D73AE
	for <linux-xfs@vger.kernel.org>; Sat, 27 Sep 2025 13:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758980553; cv=none; b=Pxm2FKuO4DHvQIXDVTnyl/rMwt1/K7LGIDJDeozg8M7Emx2ykTgVWTtPtYgS5GKi4gXJJRbEkW20kyuxQwBk8y28wXqw1OCpBRCUdeLcMVhw3G1JltSjeEhb49uXAMFPW7Zz+9U9/uhzof9eHHyN/YVedyr3dxWkBM9aA8pKVgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758980553; c=relaxed/simple;
	bh=haVa2FYln1DFT4lQrDBmGPxlqVCrDYMvGAXepYOSysY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCUqxJBjsHBqFjdAmyIISr5HQbDikHDMya5dh+miscX1HfFETDJFGRklomz5hWBAOBeoLATTROejq5goRl9Z/sAZf/4/lxCpy5NqqD0bXX3xvGSc1EmByS3YOEHcfKWillVdYmIQ6SgUJQ5h1/LOzMEeQqEqZU8y/8TGvu+UjmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fb5ouB0N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fb5ouB0N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758980550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LmkIvQPM2ADXSUqY6gn5wB5OFGrkKwBAfwHOpfjikvE=;
	b=fb5ouB0NYTHRZH4FZBFnzuBqBNcS2lslRXHz4EuLFWrsj+vpP0ZA4KVBvU45vyeYmh5OVn
	sTPo/QD7sjeqIRnLB188kc0+Y5nTKyXXWqm37mwnoYWtgg94fvRHL4XKI0+BYAeMx27L5L
	K1/PINkUKHbDKqiCxWkeZKbcIOt4TkY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-xxpCbjGxOIC3qhj7Z5fZFA-1; Sat, 27 Sep 2025 09:42:29 -0400
X-MC-Unique: xxpCbjGxOIC3qhj7Z5fZFA-1
X-Mimecast-MFC-AGG-ID: xxpCbjGxOIC3qhj7Z5fZFA_1758980548
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b56ae0c8226so2244700a12.2
        for <linux-xfs@vger.kernel.org>; Sat, 27 Sep 2025 06:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758980548; x=1759585348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmkIvQPM2ADXSUqY6gn5wB5OFGrkKwBAfwHOpfjikvE=;
        b=KsX8XdJXtwPk6tucQ0GKxoRmH6swfRbXGF/4T5MD1NUjdJgIX0OfP1nHhjxY8h/d4G
         iEUVH1QghdeaDc8USgTFdVQ9P1JRIHkNS1OM7MBgs7tj4BHjpwKWuSch8Mhfjd7WTrZt
         O8Yq3lSUofqfZFUQEALdINzH/fJqCOUzgAgVhAz3jgYHoyNONfajNNRPdjRJ93YjvXbx
         COv0OSnM7rPmZnkbE/nTg+ktWp5faaWNyq6wRID+VfQ5qcgBj9G/HxrOCcWwAkNpVlXg
         XHoBWY3H1Ha6pGmM94d4md4bvTwMzHFn/Bmt5yivBOZ+F+izMxG+GtcJFqkbDfdOoBX7
         DokA==
X-Forwarded-Encrypted: i=1; AJvYcCU3s46s44VObrHkv/hZK4gk2HnJK93TSAxAKoSkrdn+qOsva6FU3p9NvGbAiCSbk8rzvq+dWOGRNwM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwPhNVokrDBBCmfAmNrym3h8cUtIMBQrpnPQspsf8ULweGqtpe
	AGenIV7w05A1WWKY6S7RUHdkkxv/P6LThNEuZe56jAW/vq4pR6INAlwhlcZhJqV/fmX1BIHKQ+R
	q4psCh8byH8RB4mUBSlHj1Ljhzo77wHOi5QyN4zAmFQByWjDnCHxE9dW3q/9yTA==
X-Gm-Gg: ASbGncsSmHvQ0FWOstvItaYrtuh5dB/kQaul/xHYxQw1s6PXCenCXR5pTMGdTD3P8GA
	LQcIlNadDUMALG9xstYU06spk0bACaF4yxXHyTYhdcUkNcZJZ9qcOBTeSEnmEjX164e+rvO6HqW
	sYbdCKnGjZbee8FZ+/C9E2EBU54Y275BJiFJ/hQzho7QJxPPa0v9TgzsZ/TpECr7anVmnFCu1cL
	QrIdck7e4aCg3MGpEqkzLvtOrTB3uQ1yT4iGzk0EfpnTJHQAR9utqXKBe96rWO7K94InQgB9JVx
	tyNQtRYW5fuKqnCPsi0OC6IZM/qH1DzsCiCT/5yTRWxugYIAp1edvXjIZV1HtGkHjF7gsOCoJZc
	yud6r
X-Received: by 2002:a17:902:ef44:b0:246:a543:199 with SMTP id d9443c01a7336-27ed596f868mr122801695ad.54.1758980547981;
        Sat, 27 Sep 2025 06:42:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHB9dCScFCS3vj2Ifiurh+Svb1BBDypwlPwTMJaD8FpwkzjA3KPv0tqx1q6bqQCdr7SZyufPA==
X-Received: by 2002:a17:902:ef44:b0:246:a543:199 with SMTP id d9443c01a7336-27ed596f868mr122801445ad.54.1758980547487;
        Sat, 27 Sep 2025 06:42:27 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6adcac9sm81400315ad.148.2025.09.27.06.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 06:42:27 -0700 (PDT)
Date: Sat, 27 Sep 2025 21:42:22 +0800
From: Zorro Lang <zlang@redhat.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/513: remove attr2 and ikeep tests
Message-ID: <20250927134222.p4zss33wiydx7uve@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250925093005.198090-1-cem@kernel.org>
 <20250925093005.198090-2-cem@kernel.org>
 <U0YSQNAPJPxdjhRuMKtVrn5xeRxslOHWmqaK5CBJVb8e4kouZQJMwV5DuEzY7FXc_H284GanCX6ODMEH3OKxdg==@protonmail.internalid>
 <20250926153237.ahnp3bgdffsvz7qg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <apyibmyaeixj7my7c36ljib3sqkmjvttnpfyderar6erhq6qhx@xdox3y22d4pr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apyibmyaeixj7my7c36ljib3sqkmjvttnpfyderar6erhq6qhx@xdox3y22d4pr>

On Sat, Sep 27, 2025 at 09:29:50AM +0200, Carlos Maiolino wrote:
> On Fri, Sep 26, 2025 at 11:32:37PM +0800, Zorro Lang wrote:
> > On Thu, Sep 25, 2025 at 11:29:24AM +0200, cem@kernel.org wrote:
> > > From: Carlos Maiolino <cem@kernel.org>
> > >
> > > Linux kernel commit b9a176e54162 removes several deprecated options
> >                       ^^^^^^^^^^^^
> > 
> > I think this's a commit id of xfs-linux, not mainline linux. Anyway,
> > this patch makes sense to me.
> 
> Yes, because these patches are not in Linus's tree yet, I'll send them
> on 6.18 merge window. I just thought it would make sense to send them to
> fstests ASAP.

Sure, it's good to me to merge this into fstests at first, as xfs list already
acked and merged :)

> 
> 
> > 
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > 
> > 
> > > from XFS, causing this test to fail.
> > >
> > > Giving the options have been removed from Linux for good, just stop
> > > testing these options here.
> > >
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > >  tests/xfs/513     | 11 -----------
> > >  tests/xfs/513.out |  7 -------
> > >  2 files changed, 18 deletions(-)
> > >
> > > diff --git a/tests/xfs/513 b/tests/xfs/513
> > > index d3be3ced68a1..7dbd2626d9e2 100755
> > > --- a/tests/xfs/513
> > > +++ b/tests/xfs/513
> > > @@ -182,12 +182,6 @@ do_test "-o allocsize=1048576k" pass "allocsize=1048576k" "true"
> > >  do_test "-o allocsize=$((dbsize / 2))" fail
> > >  do_test "-o allocsize=2g" fail
> > >
> > > -# Test attr2
> > > -do_mkfs -m crc=1
> > > -do_test "" pass "attr2" "true"
> > > -do_test "-o attr2" pass "attr2" "true"
> > > -do_test "-o noattr2" fail
> > > -
> > >  # Test discard
> > >  do_mkfs
> > >  do_test "" pass "discard" "false"
> > > @@ -205,11 +199,6 @@ do_test "-o sysvgroups" pass "grpid" "false"
> > >  do_test "" pass "filestreams" "false"
> > >  do_test "-o filestreams" pass "filestreams" "true"
> > >
> > > -# Test ikeep
> > > -do_test "" pass "ikeep" "false"
> > > -do_test "-o ikeep" pass "ikeep" "true"
> > > -do_test "-o noikeep" pass "ikeep" "false"
> > > -
> > >  # Test inode32|inode64
> > >  do_test "" pass "inode64" "true"
> > >  do_test "-o inode32" pass "inode32" "true"
> > > diff --git a/tests/xfs/513.out b/tests/xfs/513.out
> > > index 39945907140b..127f1681f979 100644
> > > --- a/tests/xfs/513.out
> > > +++ b/tests/xfs/513.out
> > > @@ -9,10 +9,6 @@ TEST: "-o allocsize=PAGESIZE" "pass" "allocsize=PAGESIZE" "true"
> > >  TEST: "-o allocsize=1048576k" "pass" "allocsize=1048576k" "true"
> > >  TEST: "-o allocsize=2048" "fail"
> > >  TEST: "-o allocsize=2g" "fail"
> > > -FORMAT: -m crc=1
> > > -TEST: "" "pass" "attr2" "true"
> > > -TEST: "-o attr2" "pass" "attr2" "true"
> > > -TEST: "-o noattr2" "fail"
> > >  FORMAT:
> > >  TEST: "" "pass" "discard" "false"
> > >  TEST: "-o discard" "pass" "discard" "true"
> > > @@ -24,9 +20,6 @@ TEST: "-o nogrpid" "pass" "grpid" "false"
> > >  TEST: "-o sysvgroups" "pass" "grpid" "false"
> > >  TEST: "" "pass" "filestreams" "false"
> > >  TEST: "-o filestreams" "pass" "filestreams" "true"
> > > -TEST: "" "pass" "ikeep" "false"
> > > -TEST: "-o ikeep" "pass" "ikeep" "true"
> > > -TEST: "-o noikeep" "pass" "ikeep" "false"
> > >  TEST: "" "pass" "inode64" "true"
> > >  TEST: "-o inode32" "pass" "inode32" "true"
> > >  TEST: "-o inode64" "pass" "inode64" "true"
> > > --
> > > 2.51.0
> > >
> > 
> 

