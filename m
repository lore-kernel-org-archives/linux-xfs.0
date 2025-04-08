Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE4A22ACFA
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 14:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122479; cv=none; b=UgC1onWFMvi2cyPSA3/1xSa4lk0Ktp5qV5DD4jPLa4AvJlf+QCYPH7f0S5rKrkXLrIDsJaaxGNkM/u6LbuRTAOSWvvo2Exjl6lo6YyuYe62lqaTee0+7KmFCMWo3FaYD87lYoVadC+e4qBB/juiQGwevV+udKm71gtLZOeSiOiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122479; c=relaxed/simple;
	bh=8sVTW6TceJNB34RYjY9n6ubg4DVVdtoWsa7Sh4zjrSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSL1kNF433NxBmRID3OUqduqNXV1CYGzTzDxlOSH0xC8vhrSrMGSSEAEnoNsJjQyYMTE4BAZZcbaizXod6YiqcwcZ6NRrEI+DGy0n1MaR59Ftz7VZ0c4Phlcp1G3VlhTavBrmjxi4JOw7yR7xJ66LCOkPnEyLiscP5/5y1/VOkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UMlmBo/V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMlmBo/V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744122476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8RFZ7s3rxzl+Ts3s9RalLsIVjWLHrI7+8FF2waxdV8s=;
	b=UMlmBo/Va5211E5YuTyigYQairEMEX6tdxOla0xvf7yJezF9whPkZOfHPR/oe0fMOWWzVT
	nY13qB2mFIXPKgsbxqN3Xd/ogMG6b9X3tMKQdyv/K0QU1pSJsbdlhuQoJ1yjHznrfwhLNc
	l95e4w5q6SmYTpQi7aWbc13Rci/W6kM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-e1My27-qNuiDdH3EQgQmhg-1; Tue, 08 Apr 2025 10:27:54 -0400
X-MC-Unique: e1My27-qNuiDdH3EQgQmhg-1
X-Mimecast-MFC-AGG-ID: e1My27-qNuiDdH3EQgQmhg_1744122473
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-22647ff3cf5so48660285ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 08 Apr 2025 07:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122473; x=1744727273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RFZ7s3rxzl+Ts3s9RalLsIVjWLHrI7+8FF2waxdV8s=;
        b=L/UKUGmLl/qnigOMb1yMoivXQj82q3FaWjZD9/HQJhcuqcrmxzR/G+DKzeyoC34Jmc
         bPch8k4bgMCliZ61qiBbwKRGzECOsIsEd20WZKgZYUxzRrbUECtb8ntAi/wpJMpQICfb
         UGt89OxkKB/XSiFWzdhE2VDDbdRUTUhimExBJPxWOUj6HJT5LDUenVAWYOwc/oc1Talf
         LAD+YCRlkCR+1ELSFdUY6nBClDCxPKcBcQMWMlYm+vkL0YZQbJ+1xqmXoKwIlItnA3Fz
         +LxTwa7+pggpMyjk/+qT8gyym41r2wCq7GUHrhJDai4kY0OysZaC0sH1Rge8rJNkZfd1
         uW2A==
X-Forwarded-Encrypted: i=1; AJvYcCUBl0ODU45Dh+cjHjz7L2Eem52uvJVfj7ItnJ9vywyP0CRoSGFdMLr+teeXSwlxjH+XiBeapXK1cLg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA0ge6D8F9/129FG4JlgJfHVkaAkQnsibZhhG0+rvPmcewog9f
	FK3lgCKMPzRbB/wqj8BrtQ6iuVHcDIv3mSbhya+4ctRWHmD/5S+SP0yEivxjdyKQ087inxzwnlO
	YVDasHQSH/YJOVk0+Xr2r1dYtwqCuCz6ZnFsUc6yw3KxaxVngdu8+QD4f6Q==
X-Gm-Gg: ASbGncuxi0e9Bxjy5X0aFfAJZdDsOU6B+jnq8zwmeueRTArSHUQVfgj7iy0kWUgD02r
	bleLgWLrwEwKR8RvidXHYalapUZosAce2kLB7aIu0Ji6DahnoyVa/hDcY4PTJ4V+uZqTzmeZhkf
	DKemyLCyU1oOWXEyOn1e872rkOChDcFGFyt2O6lhNUJHiXq1lOlgZOvArgF1uc6ceoupO7J63bW
	0RjBT2LcJ6BgHWQnP67Ea6tsf8wvwueAtIQeTBnVrvlxYSuA7g388rJWaK2yqU6T0dBRW79oDHG
	FQklor25/AtaLqmN2QOWzGFpOZ/CtVgHgY8pmrPbjGnd/k9Uqe8Bcron
X-Received: by 2002:a17:902:d4ca:b0:223:5e76:637a with SMTP id d9443c01a7336-22a95539beamr160554655ad.23.1744122473112;
        Tue, 08 Apr 2025 07:27:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgjgb0MlkszrbH2eNw4gben2vOMbEpUncigfF9I1M6mhJaVYcdLSb8ZfEimongz+/9tzu4Rg==
X-Received: by 2002:a17:902:d4ca:b0:223:5e76:637a with SMTP id d9443c01a7336-22a95539beamr160554245ad.23.1744122472750;
        Tue, 08 Apr 2025 07:27:52 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d9ea0801sm10573244b3a.119.2025.04.08.07.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:27:52 -0700 (PDT)
Date: Tue, 8 Apr 2025 22:27:48 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v2 5/5] common: exit --> _exit
Message-ID: <20250408142747.tojq7dhv3ad2mzaq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1743487913.git.nirjhar.roy.lists@gmail.com>
 <f6c7e5647d5839ff3a5c7d34418ec56aba22bbc1.1743487913.git.nirjhar.roy.lists@gmail.com>
 <87mscwv7o0.fsf@gmail.com>
 <20250407161914.mfnqef2vqghgy3c2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <877c3vzu5p.fsf@gmail.com>
 <3c1d608d-4ea0-4e24-9abc-95eb226101c2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c1d608d-4ea0-4e24-9abc-95eb226101c2@gmail.com>

On Tue, Apr 08, 2025 at 12:43:32AM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 4/8/25 00:16, Ritesh Harjani (IBM) wrote:
> > Zorro Lang <zlang@redhat.com> writes:
> > 
> > > On Fri, Apr 04, 2025 at 10:34:47AM +0530, Ritesh Harjani wrote:
> > > > "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com> writes:
> > > > 
> > > > > Replace exit <return-val> with _exit <return-val> which
> > > > > is introduced in the previous patch.
> > > > > 
> > > > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > <...>
> > > > > ---
> > > > > @@ -225,7 +225,7 @@ _filter_bmap()
> > > > >   die_now()
> > > > >   {
> > > > >   	status=1
> > > > > -	exit
> > > > > +	_exit
> > > > Why not remove status=1 too and just do _exit 1 here too?
> > > > Like how we have done at other places?
> > > Yeah, nice catch! As the defination of _exit:
> > > 
> > >    _exit()
> > >    {
> > >         status="$1"
> > >         exit "$status"
> > >    }
> > > 
> > > The
> > >    "
> > >    status=1
> > >    exit
> > >    "
> > > should be equal to:
> > >    "
> > >    _exit 1
> > >    "
> > > 
> > > And "_exit" looks not make sense, due to it gives null to status.
> > > 
> > > Same problem likes below:
> > > 
> > > 
> > > @@ -3776,7 +3773,7 @@ _get_os_name()
> > >                  echo 'linux'
> > >          else
> > >                  echo Unknown operating system: `uname`
> > > -               exit
> > > +               _exit
> > > 
> > > 
> > > The "_exit" without argument looks not make sense.
> > > 
> > That's right. _exit called with no argument could make status as null.
> Yes, that is correct.
> > To prevent such misuse in future, should we add a warning/echo message
> 
> Yeah, the other thing that we can do is 'status=${1:-0}'. In that case, for
                                           ^^^^^^^^^^^^^^
That's good to me, I'm just wondering if the default value should be "1", to
tell us "hey, there's an unknown exit status" :)

Thanks,
Zorro

> cases where the return value is a success, we simply use "_exit". Which one
> do you think adds more value and flexibility to the usage?
> 
> --NR
> 
> > if the no. of arguments passed to _exit() is not 1?
> > 
> > -ritesh
> 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 

