Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E5B23B61E
	for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 14:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760798610; cv=none; b=aVP+9HYK9yYzPslYwJdKbdrZV3+EUIC7844ygiOD9P4x6FTokuJuiX0NNSpj2B44/aAqfuNd98+peT5DyWFfuy7L75UOfmuulDO+pGoLASqhvfl/P8Og4fNl1uHNDZExHrAdwP8Pw2QqqjNl1mNo2ppQof+QQcQdNLO27lqzMf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760798610; c=relaxed/simple;
	bh=opfjU0v2OxIyWEP92tg2xgp3LRAE5uu/vhAdTNpajdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B04WAjYIW7K8X0Hap1VHsC18KNZ3ByScQHAIr4mK/QfYHHl0EJiUSxZDnc1VklIUMX6ApeKzcTNgAPAfFRgD1jboQlWxBzvOVrm1y2TnPposFdk3zrEhaJ7R+7Cgy6apzTaMef9itDopolpvNiisITEpgm+1MOG60E1hW1mAR1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hMWQRT9d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hMWQRT9d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760798607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mYYjMReaIBtU1+uzq457Di32+sHdvL71gJGa9DZ+Tyk=;
	b=hMWQRT9dSRJ1M306z9ZGVlSc542OrO4qpiaFNo2n2ejmAaBPKMCQXZvC/IUXZRlbCtgtAB
	Vgk2f73FyEGVV3ZrpuFpkWzCFi0JGcSQKye+qHJqmQ8BrZgOTK2MsbvblJXXSJVVg/IhOS
	bZCOu2D/PNitlL1QKDT8OV8GS98xWPk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-nCgqxsgRPWGppXMOWRc4zg-1; Sat, 18 Oct 2025 10:43:26 -0400
X-MC-Unique: nCgqxsgRPWGppXMOWRc4zg-1
X-Mimecast-MFC-AGG-ID: nCgqxsgRPWGppXMOWRc4zg_1760798605
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2904e9e0ef9so53930385ad.3
        for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 07:43:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760798605; x=1761403405;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYYjMReaIBtU1+uzq457Di32+sHdvL71gJGa9DZ+Tyk=;
        b=geHrERXbt7g1Url2hXhL5wKnHaYU/5vvVKTF2al21l+9psjh804eLZxZArjMGz2Uc0
         mUMX8NtnskQREXzzAu8H7qAWAJ7zzjhARXJnz6mvnOzf/9IPWapJmoTdHvLIwH+UCgxW
         sEP8fGRrnv2E6o5FBOVJrlvRxos9RDOO9yyACLQYOhkoG5KzUqLSwaiQNIyfra+mPpQ5
         0GDnRBeBC4no9xM1GD+ObuSdEcvPiDndiLPsp61sf/NTLCBG31spkei/E77jSguxrRUT
         67jZkLre86YAGILl/W0Yd4VP6u7YLcCHmd0lp7OZZr3ktQD30lKKky6+dMw6g3ODKzM8
         vYNw==
X-Forwarded-Encrypted: i=1; AJvYcCWTFfKQ9H7JzhEUTjuaq0Dfebh6DN9fnMT7LHPS/XL9qAdLLbEmD1+HX4s+6PXu1YLpAesfPBVJT24=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx2wqFh7UJQ2M0nqvPENc1P05PuxNpgdSvyWusY3FVGjxRq1FC
	OypwJfmImQyDryGIrep12J8b6HFhOYJkPAhqV9uqA9GisJeAJVduTPRBg4y0fewI4za/+zRNPAg
	fXpsLCk+cTXDIKMoS0D+N1TS+Tx+DlvSlSh9KCeB3X0+eDOJUcRCo3hHgKMXsSw==
X-Gm-Gg: ASbGncsTJyJ7kjrkN88x41UD66fMN3HBefHcQoWY7QD8V9rsRdKjnnaYXVeXZiNu4M3
	53tkdVJcpkN2bdBhlQB86VW+NUhBz9gJh90swkzieXW9yAAHsbbWrg6VkNs9ez/phXwVNzPDmEp
	uS5phqjh4uGGX7fN/GdcOXMaeCQOyYIGmalnu3Qoq+NCvWQWpdzUJ2Tl73q39oN7yzqbT4ac4r4
	Ti2FJfbW01OzYGZMfDiiWXiYHe67F5yLUqPRIK+dZcfEcFB2IiCq6xcox/k7JyPxfwtDL0Hf/lm
	F/rs1FLFb8mGHrCcJqkk0gKPk3vIIdiqtBmX6hNpcufcls+lS/lJXsV1m/TSL6hpcohbr9WSOm/
	QvSMrMl3Z9j1BrVSGHb/psQn4ZUbXOivTKF7mN2w=
X-Received: by 2002:a17:903:3bc4:b0:26d:353c:75d4 with SMTP id d9443c01a7336-290c99a9669mr86544205ad.0.1760798604898;
        Sat, 18 Oct 2025 07:43:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7oWUaquXvDx/1kREYhuLrs9SDFE8IKYZeEcMDukZISV/b1Uiir1gKKOoYa2ZVllOVWwMSmw==
X-Received: by 2002:a17:903:3bc4:b0:26d:353c:75d4 with SMTP id d9443c01a7336-290c99a9669mr86543995ad.0.1760798604438;
        Sat, 18 Oct 2025 07:43:24 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5850sm28306035ad.66.2025.10.18.07.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 07:43:23 -0700 (PDT)
Date: Sat, 18 Oct 2025 22:43:18 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] common/attr: fix _require_noattr2
Message-ID: <20251018144318.owo63ppez7ormj5f@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
 <20251017171325.b35z55fbubi3kxut@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20251017225546.GI6178@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017225546.GI6178@frogsfrogsfrogs>

On Fri, Oct 17, 2025 at 03:55:46PM -0700, Darrick J. Wong wrote:
> On Sat, Oct 18, 2025 at 01:13:25AM +0800, Zorro Lang wrote:
> > On Wed, Oct 15, 2025 at 09:38:32AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > attr2/noattr2 doesn't do anything anymore and aren't reported in
> > > /proc/mounts, so we need to check /proc/mounts and _notrun as a result.
> > > 
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > >  common/attr |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > 
> > > diff --git a/common/attr b/common/attr
> > > index 1c1de63e9d5465..35e0bee4e3aa53 100644
> > > --- a/common/attr
> > > +++ b/common/attr
> > > @@ -241,7 +241,11 @@ _require_noattr2()
> > >  		|| _fail "_try_scratch_mkfs_xfs failed on $SCRATCH_DEV"
> > >  	_try_scratch_mount -o noattr2 > /dev/null 2>&1 \
> > >  		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
> > > +	grep -w "$SCRATCH_MNT" /proc/mounts | awk '{print $4}' | grep -q -w noattr2
> > 
> > How about use findmnt? e.g.
> > 
> >     grep -qw noattr2 <(findmnt -rncv -M / -o OPTIONS)

Sorry, the "/" should be $SCRATCH_MNT.

> > 
> > > +	local res=${PIPESTATUS[2]}
> > 
> > Then the PIPESTATUS isn't needed either.
> > 
> > I can help to do this change if you agree.
> 
> Yes, that works!  Excellent suggestion.

The patch 1,2,3,5,7,8 has been acked/reviewed, do you need I merge these patches
in the release of this weekend at first, as this's a random fixes patchset. Or
I can wait your next version, then merge the whole patchset when it's all get
reviewed ?

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > >  	_scratch_unmount
> > > +	test $res -eq 0 \
> > > +		|| _notrun "noattr2 mount option no longer functional"
> > >  }
> > >  
> > >  # getfattr -R returns info in readdir order which varies from fs to fs.
> > > 
> > 
> > 
> 

