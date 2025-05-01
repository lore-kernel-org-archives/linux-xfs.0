Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7C9213255
	for <linux-xfs@vger.kernel.org>; Thu,  1 May 2025 09:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746090665; cv=none; b=VKuCx+2ZiAQnLi1jGXBS49EiQHYgcbwhTKjkFNzghCUw11QPgPieE7PROZPk64e5R6P7I7QCC2BtyoSTdnWyRY1Tlrn5xORKwASxbO3R98o/I3m3w1I1x2CSskUWPwBGcNEx5c7NUK6MG2BG6edhU2D1Ww5YLRTuRsU6AvQHDlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746090665; c=relaxed/simple;
	bh=QEmXOiaRmXnU0Pvpj2r5Tc5dFQl/2TPO2eRzIxZTpSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loXEotHMAzA3eDEYgBTpFhWviwQvRjT6OpEUn5W72xpGctAZ+h7lD4csWlqamlSbf/tXwXgQfFxFtAjRi1BlCLWxNA2oBFc/IKo2gBzYWLD2LEP8/RWfXTfPWbPb5u7dUTMtYQ8DxopYDo3EZuNpMvhdjmOfpe4Y8T5m1VGprBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UGfiMCbr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UGfiMCbr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746090662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QxhIn1Sw5963uslvOW25nDRRIDUs0PbP3KlVBu7IStA=;
	b=UGfiMCbrscUxrsZ84gCm94Hpb35IQcjOF6doNElFdEfPzOiPD/qJRwRwsuJ7tkQCIfDat5
	HXlg391WoFdPUePnbELHiiYhiRxaaE9wZcvYCZeyGRBfpfN6ADNMBT4XZN17FVMgiFmQip
	eWdjaoSU9B8NavJPN1QRxNFyqCfldbU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-toJo4Z6wO4eV6e4bo--DWg-1; Thu, 01 May 2025 05:11:01 -0400
X-MC-Unique: toJo4Z6wO4eV6e4bo--DWg-1
X-Mimecast-MFC-AGG-ID: toJo4Z6wO4eV6e4bo--DWg_1746090660
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-736cb72efd5so752133b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 May 2025 02:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746090660; x=1746695460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxhIn1Sw5963uslvOW25nDRRIDUs0PbP3KlVBu7IStA=;
        b=TpMxrkCnUJ9rHi5yP+bzw4cX8eAL6GkYZHDsWrBmqZJAlOnvwIV6kBP2yIUc4qy7pf
         qwChCootAB0YNwipTDitW0Knj8xzwyPghNC02Dzq7qrowDqU454bVD4PV8DiuN5G8dY3
         gZDtbspQ1ZHgaslxkODGUdNkETTSf4PIQkRECKMWnXDOFeS/fSCXSUdTWoAdnQ8JkPeM
         Roe0sRxjW+1+WMuKhaK/iAon0yTInuataDs+eLRqvERBDmO1Jpq6vaBbM6Jedgp8+XjC
         dlp2by6qt+hYAq10HbPr4boMSSzIHTpqxdDSQxFJJE58OaTRXEWo/hDru9iZGiPTdez4
         Mniw==
X-Forwarded-Encrypted: i=1; AJvYcCVxYxMV8FASllh3PK0WmXHzD3jeMPK1GM/9YqqgSi++j9kyr7X76IE1UFoXRVRjwf2HzM0Og181H+o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsYZgeVE61Ao36lgCbgGzCPNKo8JT0H6idEAiMG88aKlMTUI9g
	kkmpEpowY/A1P6BEMwGxHSxG3P2GFS8Za5LWHdmQPaiNj1dao49GofALG/5a3/UZkwepBUgczrn
	QsbC3jxCiVM6haajF0PtVIcjuBR/kvQJbJhfmkqP34TEXKemqwdTAmeZ+Hg==
X-Gm-Gg: ASbGncsg50YrBFnkb9g1kfAFYGBqwLS02P486ApBJ8Q0BR5uY7kG2VxZlSgNXlBOptq
	G3MFg90QZc/tadU4eeIF7OPHzI1/YlqIC5ZREEKu1njJkV16ZYdVwsq+UI+nyrmqPAdePAlbXj/
	4kBrYgEbkVqpuTKgO7s5OZdkUkMIIrEvyzRqDYrm4qXsmka27D+ZIP0Drx/PvQBK/K8+yQwq0CD
	skygMRMEpH4HI8iYs/QCIpQ59kyW7A4jVA1oZbTO8pQY+1hTw7uLvSeiN7T/Q76jjaPlGdEPYqu
	0/s9JB5iC1eM6xQNuLpi8fF+NPXXQzwVFshfjSQzgy/U9/J6GqMf
X-Received: by 2002:a05:6a00:399f:b0:736:b9f5:47c6 with SMTP id d2e1a72fcca58-74049254c95mr2293520b3a.16.1746090659927;
        Thu, 01 May 2025 02:10:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFb5/7x8ZBKSA+i2VN4Rh2/jV2SOh0H2mngKBWWKI7BKImnX6gIaLln1uDeV0hnSozdCGsAzw==
X-Received: by 2002:a05:6a00:399f:b0:736:b9f5:47c6 with SMTP id d2e1a72fcca58-74049254c95mr2293497b3a.16.1746090659522;
        Thu, 01 May 2025 02:10:59 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404fa42fb0sm353535b3a.166.2025.05.01.02.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 02:10:59 -0700 (PDT)
Date: Thu, 1 May 2025 17:10:53 +0800
From: Zorro Lang <zlang@redhat.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, djwong@kernel.org,
	zlang@kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH v3 1/2] common: Move exit related functions to a
 common/exit
Message-ID: <20250501091053.ghovsgjb52yvb7rj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1746015588.git.nirjhar.roy.lists@gmail.com>
 <7363438118ab8730208ba9f35e81449b2549f331.1746015588.git.nirjhar.roy.lists@gmail.com>
 <87cyctqasl.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cyctqasl.fsf@gmail.com>

On Thu, May 01, 2025 at 08:47:46AM +0530, Ritesh Harjani wrote:
> "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com> writes:
> 
> > Introduce a new file common/exit that will contain all the exit
> > related functions. This will remove the dependencies these functions
> > have on other non-related helper files and they can be indepedently
> > sourced. This was suggested by Dave Chinner[1].
> > While moving the exit related functions, remove _die() and die_now()
> > and replace die_now with _fatal(). It is of no use to keep the
> > unnecessary wrappers.
> >
> > [1] https://lore.kernel.org/linux-xfs/Z_UJ7XcpmtkPRhTr@dread.disaster.area/
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > ---
> >  check           |  2 ++
> >  common/config   | 17 -----------------
> >  common/exit     | 39 +++++++++++++++++++++++++++++++++++++++
> >  common/preamble |  3 +++
> >  common/punch    | 39 +++++++++++++++++----------------------
> >  common/rc       | 28 ----------------------------
> >  6 files changed, 61 insertions(+), 67 deletions(-)
> >  create mode 100644 common/exit
> >
> > diff --git a/check b/check
> > index 9451c350..bd84f213 100755
> > --- a/check
> > +++ b/check
> > @@ -46,6 +46,8 @@ export DIFF_LENGTH=${DIFF_LENGTH:=10}
> >  
> >  # by default don't output timestamps
> >  timestamp=${TIMESTAMP:=false}
> > +. common/exit
> > +. common/test_names
> 
> So this gets sourced at the beginning of check script here.
> 
> >  
> >  rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.report.* $tmp.arglist
> >  
> <...>
> > diff --git a/common/preamble b/common/preamble
> > index ba029a34..51d03396 100644
> > --- a/common/preamble
> > +++ b/common/preamble
> > @@ -33,6 +33,9 @@ _register_cleanup()
> >  # explicitly as a member of the 'all' group.
> >  _begin_fstest()
> >  {
> > +	. common/exit
> > +	. common/test_names
> > +
> 
> Why do we need to source these files here again? 
> Isn't check script already sourcing both of this in the beginning
> itself?

The _begin_fstest is called at the beginning of each test case (e.g. generic/001).
And "check" run each test cases likes:

  cmd="generic/001"
  ./$cmd

So the imported things (by "check") can't help sub-case running

Thanks,
Zorro

> 
> -ritesh
> 

