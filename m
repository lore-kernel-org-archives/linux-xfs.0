Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DA6142623
	for <linux-xfs@vger.kernel.org>; Fri,  1 Nov 2024 05:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730440101; cv=none; b=gG985o7KJI4N1hEOIeEvuD370jEspqNJQF6IquO+eVtg3BZEeyuuPPevGnfH9TbMt8Yap30fdQNcOcrMh9MVYyHR/5F4c2AWoCRJPEvb7HcpVyGxBD9BhuF1CmaTkFbwoBvo1Wua+NXFKhsvmySnLUuePxk9GFUoeHhR1PHwMu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730440101; c=relaxed/simple;
	bh=l4Jf412+kHWCxyNzTYcMaXRBT+VkrgaDC4jQy7sq84A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6JNh95m6kYVMZPpJZo3dbjOtCiw3EzRLRLRcteB48XEEvl4uWTJPE+tm9dS/zL+h+ZpHUnM6w3dM2LXobXAuWpyT4eT6u236oIVDiN7cuuJzF7XIKk3M1oQcQGuFLLYjkdkIf8XVZ1fvGED0AGjdYIJornQwBHOIz5Kd4yGfx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AyLs3c3j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AyLs3c3j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730440097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sr70nr/cEn3VuMWhSDNCFFANoox2dWav/Nn0mL42AK8=;
	b=AyLs3c3jGtFdXmNWftERvIbJnV46YyEm2xZdfrXsjieDWeCXb6DlP6DBYxpD2jtf1lxnWQ
	/H9xiqXfh8VAN2BfsyL8AO+Kj4b9ANDeWgE0cxZSYd4ZyQ6fxUry+oNJfd1oChDc8E1k/s
	HXyjMZF3HKN4CR43J0txzgmU1CVWhVs=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-MrnZhVdXN4CvFNRbgCse2A-1; Fri, 01 Nov 2024 01:48:15 -0400
X-MC-Unique: MrnZhVdXN4CvFNRbgCse2A-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2e2fb583e4cso2038418a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 22:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730440095; x=1731044895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sr70nr/cEn3VuMWhSDNCFFANoox2dWav/Nn0mL42AK8=;
        b=Fs8yxsK/mb1t73V72IqH4fdk1Vdo8RBBU6gDlWSjQbWYQ3iQNbb0FmNbUqeGchjNPU
         kHlZLWm8L9X0921y/AhNz+cWRt9HD5NOy4wXsuWOdWnTMpLR6YXHLAqfB4G+v6NmIphp
         5JJ8hpZu3kSInv8fSgNpz1D2t5DToTnKETML0hzjymHTAPG4x1I6nU6pn5cJKsa4NDJ3
         LmUV/ya/0yN1BnMzVVUTLNA0u8Uf1CLDJuJHVo9UxOAjz1uML4fMwwzfSRE6amLI0vwg
         QO9spp0V2XOuIjh8EBd3SAed09aVb7+cPRIgyBqU3gzCe1bCtkO3OVECwred7Ozo16cj
         L5rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzqodN9i9ThkBitoGpoDqRBuz2HSrV0OGcEF+UnhMW2bcx6HiEyAhI4fgaayF0BM5TWAMEOrScsMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLKV9zK9NTQU1VRdJS6OA0M5D6mY9dEwKT1ebeHKhICVEoIHoe
	3p2DnO2e8z9M7j+DqNn5s/0l7/Yx1vjGa7dtToIqE3u2ygWcdsCkScRm56GaAe8ruWftKqtfrrk
	YheHI2ZYYUQcD1g6+Hw2ZThFuJxRDbtTvH8SDTCBSDyXelGKV3TVm5ebyuQ==
X-Received: by 2002:a17:90a:4e0a:b0:2e2:c6b9:fd4a with SMTP id 98e67ed59e1d1-2e8f1072087mr24713599a91.18.1730440094732;
        Thu, 31 Oct 2024 22:48:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVJByF/lHIUmW9LhohJRCmWJ7MdBrnnXXkyT+x8dAuHMjL5WnsJqPnnxgJj9Nug9z3toThvA==
X-Received: by 2002:a17:90a:4e0a:b0:2e2:c6b9:fd4a with SMTP id 98e67ed59e1d1-2e8f1072087mr24713581a91.18.1730440094171;
        Thu, 31 Oct 2024 22:48:14 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211056eedcdsm16533855ad.45.2024.10.31.22.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 22:48:13 -0700 (PDT)
Date: Fri, 1 Nov 2024 13:48:10 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241031193552.1171855-1-zlang@kernel.org>
 <20241031220821.GA2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031220821.GA2386201@frogsfrogsfrogs>

On Thu, Oct 31, 2024 at 03:08:21PM -0700, Darrick J. Wong wrote:
> On Fri, Nov 01, 2024 at 03:35:52AM +0800, Zorro Lang wrote:
> > The xfs/157 doesn't need to do a "sized" mkfs, the image file is
> > 500MiB, don't need to do _scratch_mkfs_sized with a 500MiB fssize
> > argument, a general _scratch_mkfs is good enough.
> > 
> > Besides that, if we do:
> > 
> >   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> > 
> > the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs fails
> > with incompatible $MKFS_OPTIONS options, likes this:
> > 
> >   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
> >   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> > 
> > But if we do:
> > 
> >   _scratch_mkfs -L oldlabel
> > 
> > the _scratch_mkfs trys to keep the "-L oldlabel", when mkfs fails
> > with incompatible $MKFS_OPTIONS options, likes this:
> > 
> >   ** mkfs failed with extra mkfs options added to "-m rmapbt=1" by test 157 **
> >   ** attempting to mkfs using only test 157 options: -L oldlabel **
> > 
> > that's actually what we need.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > This test started to fail since 2f7e1b8a6f09 ("xfs/157,xfs/547,xfs/548: switch to
> > using _scratch_mkfs_sized") was merged.
> > 
> >   FSTYP         -- xfs (non-debug)
> >   PLATFORM      -- Linux/x86_64
> >   MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/sda3
> >   MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch
> > 
> >   xfs/157 7s ... - output mismatch (see /root/git/xfstests/results//xfs/157.out.bad)
> >       --- tests/xfs/157.out       2024-11-01 01:05:03.664543576 +0800
> >       +++ /root/git/xfstests/results//xfs/157.out.bad     2024-11-01 02:56:47.994007900 +0800
> >       @@ -6,10 +6,10 @@
> >        label = "oldlabel"
> >        label = "newlabel"
> >        S3: Check that setting with rtdev works
> >       -label = "oldlabel"
> >       +label = ""
> >        label = "newlabel"
> >        S4: Check that setting with rtdev + logdev works
> >       ...
> >       (Run 'diff -u /root/git/xfstests/tests/xfs/157.out /root/git/xfstests/results//xfs/157.out.bad'  to see the entire diff)
> >   Ran: xfs/157
> >   Failures: xfs/157
> >   Failed 1 of 1 tests
> > 
> > Before that change, the _scratch_mkfs can drop "rmapbt=1" option from $MKFS_OPTIONS,
> > only keep the "-L label" option. That's why this test never failed before.
> > 
> > Now it fails on xfs, if MKFS_OPTIONS contains "-m rmapbt=1", the reason as I
> > explained above.
> > 
> > Thanks,
> > Zorro
> > 
> >  tests/xfs/157 | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/tests/xfs/157 b/tests/xfs/157
> > index 9b5badbae..459c6de7c 100755
> > --- a/tests/xfs/157
> > +++ b/tests/xfs/157
> > @@ -66,8 +66,7 @@ scenario() {
> >  }
> >  
> >  check_label() {
> > -	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> > -		>> $seqres.full
> > +	_scratch_mkfs -L oldlabel >> $seqres.full 2>&1
> 
> Hans Holmberg discovered that this mkfs fails if the SCRATCH_RTDEV is
> very large and SCRATCH_DEV is set to the 500M fake_datafile because the
> rtbitmap is larger than the datadev.
> 
> I wonder if there's a way to pass the -L argument through in the
> "attempting to mkfs using only" case?

As I know mkfs.xfs can disable rmapbt automatically if "-r rtdevt=xxx" is
used.

How about unset the MKFS_OPTIONS for this test? As it already tests rtdev
and logdev by itself. Or call _notrun if MKFS_OPTIONS has "rmapbt=1"?

Any better idea?

Thanks,
Zorro

> 
> --D
> 
> >  	_scratch_xfs_db -c label
> >  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> >  	_scratch_xfs_db -c label
> > -- 
> > 2.45.2
> > 
> > 
> 

