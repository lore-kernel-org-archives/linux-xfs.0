Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B703F4FA
	for <linux-xfs@vger.kernel.org>; Sun,  7 Sep 2025 05:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757222295; cv=none; b=ARuYS5lY/vNyZbm+HdCm3Hr6g9OYkjNz+NpCiJEfstNLooISJ00bByVBkxvpm7B3w3MtEvhpOy+xphyHuQFJXKkntGBmOPG96NyyRTF95B0Vc77jailvN4Oky2ptlE+jFv5FVvI/CF2JflWLjHqnVYqn2bYgnc8pQjdT1+UgyYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757222295; c=relaxed/simple;
	bh=qwccVuzbUesgD3QoZMWodzkcU8xN7J0ykW7Ze0ZXgK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWhtUMGHXZn7TfARG4g5TyTm29aL9Di8DJ76+VLxrfT0ZQPcVEqsRLLr6xT9EkPXOTVHvz33MEUnf5tWxev/8iPa061p96fOgonVKizFo3Ngp7ppkkyIl1xDF5B4lfCNr2+tPCYHaiXmK8DfO6sPNzQerbqgCgxWUU3EbEPAys0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T+ak4fXz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T+ak4fXz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757222291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OblASZcrr7kB2yJKEylAwifpAWWyy4KUP/8RCxYnVGo=;
	b=T+ak4fXzwMnGbGfZcOyCWWH17x8dfYw0u+JTbZ/rWvlD6k51mAQ24i8pivRZzQ88uJKFz+
	brJuaziumt3PeH9HqShuw1HV1nB5zUxFXhhHZXODf2ykmvE5cFn9X51HY9FOgiEMGdKKRd
	qd3HXgDVMfUzh9IzZXa3wh9yJb6TlJw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-CHcDOwinNnKjUpiemRR_JA-1; Sun, 07 Sep 2025 01:18:10 -0400
X-MC-Unique: CHcDOwinNnKjUpiemRR_JA-1
X-Mimecast-MFC-AGG-ID: CHcDOwinNnKjUpiemRR_JA_1757222289
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-24c9304b7bcso36643625ad.3
        for <linux-xfs@vger.kernel.org>; Sat, 06 Sep 2025 22:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757222289; x=1757827089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OblASZcrr7kB2yJKEylAwifpAWWyy4KUP/8RCxYnVGo=;
        b=Dyzzs+q3bACDgag6yNkp4b+VvwyJuq0Wr5/M63RUW1WmgsAFodGYxRe3Zbg+o/Fmip
         c9J5LfqRU2GcS9zYnKJFzVNT+pZvTZ6BO9kGGdLnS586o5nan3OZnYplPo/SFDtL1Anl
         TBwYwFlasQxDtEWHx6uiQEjD/DKfmBWD5KsgVvigh5ZvyZMfSpgjOnuL6R9iQ9XGPZOs
         i/abo8LnZNDj2dQsrCozk/ATGpqNcaKQcn320CreKo7suxVB4QoI9xDrHiEZ67zhdNIk
         RuFuGAadmyZtgku3lOHLRxLCawznAeIb2pZkW1SEG6qof1Pjvjo9Vcd4dA9TgJJohcRB
         +tlg==
X-Forwarded-Encrypted: i=1; AJvYcCWb5PaJHBO/q+hGLEcUSo8nxByoKeKMCpPj4wWgqwx2PToEjYrQTJ3YZrEruuDq9SaMoZGnW3Es9L0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbRHu4Mc0L0o/JKnSXEu7ju2GZ13DLvOE8iFIN+rX2OSD8dtTl
	0t+1csSAK+zSGIfkdqZJkWwWQNMVFKN9FpRgG4MQhBEJGjGgROw/QyESuiAYXIsSgBBxXy1mfSw
	Kho9phj0xNpxLTd8zKwoJuvHimxVAGQTLyggADwIyiwvZsdA2HA80u6EOtKUI9w==
X-Gm-Gg: ASbGnctxTOX4mHNPBIB7CFan3HdAsSymMkje12wb3af/XA+tyY8WpMJI1UL6Nnbo7Dc
	uFdTWTwDR9AKYw2B2jnNGrqTgRMbrKjTHLnLe0nPkmi4PZxTQMb8egdGWMW7QU0QOJYBj2oEWh8
	u+V1VYaZUhtGp/Sw2slWb850S/oS2/Uq2bJmk9J35443K6fk2/3AWLIQK+o0D+8LJHSbua7bQEn
	izkqguXbLGTWfWMtIaW5Qwxoq+96ZfAKj5vJjWLGJVBnaujWPRQMKnucwNwxQlxFlSibQYivodK
	Pd/00+sEAjejx1hEqJGbxBbZ33CnaQSV4eBY61VJHlRiNF3F+5+EsD2hhgAcoBMXrmuV2Vc+/IN
	R56Yw
X-Received: by 2002:a17:902:7c98:b0:249:33db:34b with SMTP id d9443c01a7336-25174374976mr39073075ad.42.1757222288999;
        Sat, 06 Sep 2025 22:18:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErgKrN3nawKeRdKJYtoByqaDG+aENeILCXOZaM7UN1gFx5Yj70HtS39XlJA3mnEHXugO/6/A==
X-Received: by 2002:a17:902:7c98:b0:249:33db:34b with SMTP id d9443c01a7336-25174374976mr39072895ad.42.1757222288607;
        Sat, 06 Sep 2025 22:18:08 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b020a7cb5sm146860015ad.115.2025.09.06.22.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Sep 2025 22:18:08 -0700 (PDT)
Date: Sun, 7 Sep 2025 13:18:03 +0800
From: Zorro Lang <zlang@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, djwong@kernel.org,
	tytso@mit.edu, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 02/12] common/rc: Add _require_fio_version helper
Message-ID: <20250907051803.t4av26vmf7zodzjl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1755849134.git.ojaswin@linux.ibm.com>
 <955d47b2534d9236adbd2bbd13598bbd1da8fc04.1755849134.git.ojaswin@linux.ibm.com>
 <1b12c0d9-b564-4e57-b1a5-359e2e538e9c@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b12c0d9-b564-4e57-b1a5-359e2e538e9c@oracle.com>

On Tue, Sep 02, 2025 at 03:50:10PM +0100, John Garry wrote:
> On 22/08/2025 09:02, Ojaswin Mujoo wrote:
> > The main motivation of adding this function on top of _require_fio is
> > that there has been a case in fio where atomic= option was added but
> > later it was changed to noop since kernel didn't yet have support for
> > atomic writes. It was then again utilized to do atomic writes in a later
> > version, once kernel got the support. Due to this there is a point in
> > fio where _require_fio w/ atomic=1 will succeed even though it would
> > not be doing atomic writes.
> > 
> > Hence, add an explicit helper to ensure tests to require specific
> > versions of fio to work past such issues.
> > 
> > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > ---
> >   common/rc | 32 ++++++++++++++++++++++++++++++++
> >   1 file changed, 32 insertions(+)
> > 
> > diff --git a/common/rc b/common/rc
> > index 35a1c835..f45b9a38 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -5997,6 +5997,38 @@ _max() {
> >   	echo $ret
> >   }
> > +# Check the required fio version. Examples:
> > +#   _require_fio_version 3.38 (matches 3.38 only)
> > +#   _require_fio_version 3.38+ (matches 3.38 and above)
> > +#   _require_fio_version 3.38- (matches 3.38 and below)
> 
> This requires the user to know the version which corresponds to the feature.
> Is that how things are done for other such utilities and their versions vs
> features?

I don't like to use "version" to be the _require_ condition either. fstests always
recommend "checking if the feature/behavior is really supported" at first, not a
hard version limitation. Some old downstream software might backport new upstream
commits, the version is useless for them.

Thanks,
Zorro

> 
> I was going to suggest exporting something like
> _require_fio_atomic_writes(), and _require_fio_atomic_writes() calls
> _require_fio_version() to check the version.
> 
> Thanks,
> John
> 
> 

