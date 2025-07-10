Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7815F2FCE3E
	for <linux-xfs@vger.kernel.org>; Thu, 10 Jul 2025 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752172019; cv=none; b=XalhVcKLQOfMQu7Ec2SiVF/ibLyLXc2+DPKoMkyVEzlI2191F6g07FaLsNyu5jt4LCib3cSV2yrNChQ4Cnl7jmbXxNV3qIsc9zFpTz5FIZiPfJ34Zq6M4jANWM3VsdODKphdhw44RefEUtVb4gCqmW5fpTpX+f9pO0ikZB8Lnw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752172019; c=relaxed/simple;
	bh=iq+ZUqK++wkHXj6FNVn+ASkFWaDZawFdwTiSpzCvAjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I66npC5uUjrHo+gjtngS/OR0/RYgIva1AWakNmTqVw/QSmI8wJaggbQCpzxJSqzJnPViSLeTXMXVWFOupfJ12Wo+2a7fjtIA/+DK0UZPCx2oKMjmwZvJ+S1jQoDhQ2SQKJUrapZOfCKc0ebYSA+iOFXyPAuJbV1NHRpJKbR964A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KLybWWnf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KLybWWnf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752172016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J348mQ9Ny7AZVltIJUdzXzLNg32fYYHhBKVgidGAgyE=;
	b=KLybWWnfDmK7t5Sa+R/MxajUyUlkdlMeANuqjjUtbM86PR8Kbc0WJ2LZ5MvSAA/TKSZDbd
	IDe3Wlu9UmaLtVSzI5GVzXHofJzGZX9ydKs3TezhVh6Jfp+dU2+Qm7wdYB2cUY4+KUlw5V
	mMOPSw0mLVzHsqqj57fxf1q7O+aPPLk=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-wzSNUkDvNqiGwPyJLSFcng-1; Thu, 10 Jul 2025 14:26:55 -0400
X-MC-Unique: wzSNUkDvNqiGwPyJLSFcng-1
X-Mimecast-MFC-AGG-ID: wzSNUkDvNqiGwPyJLSFcng_1752172014
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b00e4358a34so941801a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 10 Jul 2025 11:26:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752172014; x=1752776814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J348mQ9Ny7AZVltIJUdzXzLNg32fYYHhBKVgidGAgyE=;
        b=Sktp+WAsUQ3rG6+VdBvVSPILZloNdozazoK5R/OIYhcNffNi94cwwm7lgMnXzzzg+w
         w/zFQ8cWVHMSECZ58rLUO2O1iYONIgCuLvRZzWbRWAsNYItuqFwCreGuf/F+aX6WHe9Q
         feAk7u7EfAcNtn3N9pFaWEPI8wLdi+Sld5JYs+zlactPtKnPwQDQ9wMLtM8sG8K+mPeB
         7vp0yqEc2/J+go4MFDc3SXUuSlOptKO83yh0IOfYQg83zjoyNgdF647X8IWre6R8/DHK
         EWk5GFbUT1/MjtODj+DJiVzN7IAEkLeF6pWqU2p9H5E2nO8B8YfrWvMpfQsauPmR4C0W
         RqBw==
X-Forwarded-Encrypted: i=1; AJvYcCVhDc+5Fz2DwS2zX0ShTJUzyZGX3IXsZqnmJRXlgDZfcVQx1dfkgY8bR2zV+GNWsZxMFiw28Z7Uji4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVW/PuDmg3/AIBNj6LAQbFNo11AvUFCqIWNLI937FEsKqdgzYn
	nUiIrCOug9JQCL+WMglZXMeUPEcDiAEbLYBTwLdZOxqtzjWgDSfUQd7JP7EOhkS+V+DEcyXfDIo
	h1wiOUJPfOG/Td2dUQuFyHqnNxmdOi6wDI2a4dayB8h4eVUZcVJIMVX0A/0o/Nw==
X-Gm-Gg: ASbGncsVrZWozsq2cVTYODx+eC+SkAu+PWVMylbnHfJto7lzullZfTT9XVcT47R9gkK
	r1FYRtX3eMD1BthOOpEs1AFNddnCyhJmB+HENRpLVFYdM2mxZQRePoTaqKf7xGjTuONdb/olQtR
	Pp8erVgGofFU/haP5Z9mfC1R+HqR8INLh4CnmHmV3CJbfbHLHavcBtmGMC5yfryepPqi9tWbIOG
	Npa/bOfLD6wD+MxLfMQ0XCPne7etzqTSGGOrBqn32d/WAsl/L2Ue+qV+F0vywxzIm0K07zqQiVb
	tzPsMyf7B1LnSFI3adezWcLFoTb0awzcW1zjRT0p7lkQSQQEvN18QPA2B3hcDfc=
X-Received: by 2002:a17:90b:578f:b0:312:e731:5a6b with SMTP id 98e67ed59e1d1-31c4cd1933cmr598367a91.32.1752172013885;
        Thu, 10 Jul 2025 11:26:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaIbeIJkuybssjHpWeq+WMbUDmu4Y39zxjUXpLpZVMv05lVhzb/KVS9iaIa8uH1KUZlJFZnQ==
X-Received: by 2002:a17:90b:578f:b0:312:e731:5a6b with SMTP id 98e67ed59e1d1-31c4cd1933cmr598344a91.32.1752172013547;
        Thu, 10 Jul 2025 11:26:53 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c3003faa6sm6109257a91.4.2025.07.10.11.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 11:26:53 -0700 (PDT)
Date: Fri, 11 Jul 2025 02:26:49 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 1/2] fstests: check new 6.15 behaviors
Message-ID: <20250710182649.qcj66vrx3njvkyw6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <20250710161610.GC2672039@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710161610.GC2672039@frogsfrogsfrogs>

On Thu, Jul 10, 2025 at 09:16:10AM -0700, Darrick J. Wong wrote:
> On Wed, May 21, 2025 at 03:40:53PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Adjust fstests to check for new behaviors introduced in 6.15.
> > 
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> > 
> > With a bit of luck, this should all go splendidly.
> > Comments and questions are, as always, welcome.
> 
> Hrm, can we get the first two patches into for-next, please?
> 
> I'll work on the last two and repost when they're ready.

Sure Darrick :)

> 
> --D
> 
> > --D
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=linux-6.15-sync
> > ---
> > Commits in this patchset:
> >  * xfs/273: fix test for internal zoned filesystems
> >  * xfs/259: drop the 512-byte fsblock logic from this test
> >  * xfs/259: try to force loop device block size
> >  * xfs/432: fix metadump loop device blocksize problems
> > ---
> >  common/metadump   |   12 ++++++++++--
> >  common/rc         |   29 +++++++++++++++++++++++++++++
> >  tests/generic/563 |    1 +
> >  tests/xfs/078     |    2 ++
> >  tests/xfs/259     |   25 +++++++++----------------
> >  tests/xfs/259.out |    7 -------
> >  tests/xfs/273     |    5 +++++
> >  tests/xfs/613     |    1 +
> >  8 files changed, 57 insertions(+), 25 deletions(-)
> > 
> > 
> 

