Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB16208D0
	for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 07:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760774240; cv=none; b=NrzkSUn69xdY5X6ovNzjERbzZX8/4YN4zCZwBE1RG3AAwlQpf3q2ILhRW9g8lTdYpMxp3Uc2TpZ3J5NvvYnKSqB+seXqNdR3jF/J/hwhUBBZCXPXHZI+ISfr6btGlSOehWTJsBuUWfL2jPeiLRdeeHDGPSO++K4b4mw4R/A/l4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760774240; c=relaxed/simple;
	bh=Z2Uq0P+iZsBkehpUjLTNEIiTicpbWvHyUuBvYMsqPSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6p0AgOoNRUptInZM5zCJJie9QMCN12Io+Os2p5nVC6+lgefcdD45UpmqhJpy/vlH+eastK24iTGtrbdbYaJjRsh9XzC2bg+7dJRVNpi0DwGwHry5ECjP5ntGISLqtMmzKvWq6JD5niPkZ1GF2Cu1xdukI4ZSb2TmK/mtEANCHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QaAspI+4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QaAspI+4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760774237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x7S+blNX9xelf5f+/pE2M5lnWf5xx/0K07w1RR+FrCg=;
	b=QaAspI+4qWRAnAqtzbwwy45YMvuiLNunybgRbMQm0GUk54bEAd8/sqo5WbFOPJwlEa6FdU
	SaIbpHG4qQ+u2U0SD6ULHWIiZqgNy+ZwQ4RJTG3ldxxRQbhJdTzh+NS6o8a1Opy55bss6t
	x3nosO46xHgwuRgbVrf46GP6sbxYxY8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-BOChi6W8PJyfnH5SptKfGw-1; Sat, 18 Oct 2025 03:57:15 -0400
X-MC-Unique: BOChi6W8PJyfnH5SptKfGw-1
X-Mimecast-MFC-AGG-ID: BOChi6W8PJyfnH5SptKfGw_1760774235
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-76e2eb787f2so2522338b3a.3
        for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 00:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760774234; x=1761379034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7S+blNX9xelf5f+/pE2M5lnWf5xx/0K07w1RR+FrCg=;
        b=GKym+X5Rl5qUTCbGoPjGMNLqEBZXnuDojV4gL9f32Wb4HQFSiw6YKtM9gHHvcRIIFC
         9Flq1PGBDhLsIjWdyzIhqA2rppGbjS+KWIxGS3/oVwXg3H49+zDpiXTgam2drf42swtt
         tztc8hkpa3XhyNI+uz7Qmmjy99tTW7LsZArkMfov/eCxdTClQ7r5CIOs7ELwGJbgffnr
         1exOpfpEMtVmTola28UmJ7/HDMnavOB5J0Emz1eORYALohp0nSc/1M75a0185Zsbu1xy
         HcSTMhIUL74yoxpp79Ws+jUhkKyyQpXBgzhTBc2ozjihsJt5n+5UlmhcCzXBDHvh0SOX
         DVhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiU4n9nHU7nfsIBZesAxrQyQ2ElCUQ2iOhBjZybyjyIXgdS/am5W85qRBKLw5qDMac2vr7YnIWVKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJd+Kz7900ao9cHqXPXSiGEnJdVRknwX4MNB5voZqPlUBKPeBr
	FPNCTaXHBxvCUyhVNvLurLTnBy98b7E8J77M5+hmH+st50Cwx7dFcZDykkP87boCvZXouWIoH3c
	M4XrlhwX7JxL4QxQ2sALmp0qXsOVQmTR9VAO78d3cvnAmOB76SXaYjWUCpjOHtA==
X-Gm-Gg: ASbGncuez2o6IRH+Xj+6TQbAmoUQtJUxVW9sZkDuVISCmaucYzfbTcjwpsIldVbm/6N
	DWsQ1VjJ6spKVBXvlKT8UW4Tqt3Lc1oX1XMVFuHuhKpB2TKv2b1qtCwog3MHIXbEmlI/39LYSqq
	WumsbmHwILjRWTkOKUPJ3Ub3+fjSoZlCUgEWLkDB1bzqj569jUyuSAJF0CszOTfyQ+O8KCreKjr
	BxE4BV/W1/TKtLyweHO6DOkV9uzgTr+1U49COaV4T3HeCDhhH79hxbv90+u9Pba4mVBYetT/sTb
	s5erqGWB50ysqvhVK1a1DgIe1B5ZfuGZX/pBB6ujvIAqTWEodU+uq2RnvddL6N47bvwQoFYg1qZ
	JFdd7M0Yd/YnCgvfQzajcmqWWbgtLi6A9p/vadLY=
X-Received: by 2002:a05:6a00:1a90:b0:783:c2c4:9aa5 with SMTP id d2e1a72fcca58-7a220b10802mr9447602b3a.32.1760774233562;
        Sat, 18 Oct 2025 00:57:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7kk3RQ/EXfDR19z64ks2wGlksMjm9yPZc4Lm4p08VIb21uyZ8Zl3sF94kRP58OLHX+4kFfw==
X-Received: by 2002:a05:6a00:1a90:b0:783:c2c4:9aa5 with SMTP id d2e1a72fcca58-7a220b10802mr9447580b3a.32.1760774233014;
        Sat, 18 Oct 2025 00:57:13 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a2300f2598sm1962322b3a.40.2025.10.18.00.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 00:57:12 -0700 (PDT)
Date: Sat, 18 Oct 2025 15:57:08 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr special
 file support
Message-ID: <20251018075708.t7agddy5ceisek2e@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
 <20251017174633.lvfvpv2zoauwo7s7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20251017225448.GH6178@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017225448.GH6178@frogsfrogsfrogs>

On Fri, Oct 17, 2025 at 03:54:48PM -0700, Darrick J. Wong wrote:
> On Sat, Oct 18, 2025 at 01:46:33AM +0800, Zorro Lang wrote:
> > On Wed, Oct 15, 2025 at 09:38:01AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > On XFS in 6.17, this test fails with:
> > > 
> > >  --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
> > >  +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
> > >  @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
> > >   Can not set fsxattr on ./foo: Invalid argument
> > >   Initial attributes state
> > >   ----------------- SCRATCH_MNT/prj
> > >  ------------------ ./fifo
> > >  ------------------ ./chardev
> > >  ------------------ ./blockdev
> > >  ------------------ ./socket
> > >  ------------------ ./foo
> > >  ------------------ ./symlink
> > >  +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
> > >  +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
> > >  +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
> > >  +Can not get fsxattr on ./socket: Inappropriate ioctl for device
> > > 
> > > This is a result of XFS' file_getattr implementation rejecting special
> > > files prior to 6.18.  Therefore, skip this new test on old kernels.
> > > 
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > >  tests/generic/772 |    3 +++
> > >  tests/xfs/648     |    3 +++
> > >  2 files changed, 6 insertions(+)
> > > 
> > > 
> > > diff --git a/tests/generic/772 b/tests/generic/772
> > > index cc1a1bb5bf655c..e68a6724654450 100755
> > > --- a/tests/generic/772
> > > +++ b/tests/generic/772
> > > @@ -43,6 +43,9 @@ touch $projectdir/bar
> > >  ln -s $projectdir/bar $projectdir/broken-symlink
> > >  rm -f $projectdir/bar
> > >  
> > > +file_attr --get $projectdir ./fifo &>/dev/null || \
> > > +	_notrun "file_getattr not supported on $FSTYP"
> > 
> > I'm wondering if a _require_file_attr() is better?
> 
> It's checking specifically that the new getattr syscall works on special
> files.  I suppose you could wrap that in a helper, but I think this is a
> lot more direct about what it's looking for.

Please correct me if I'm wrong. The new syscall is created for setting extended
attributes on special files, therefore I suppose if there's file_setattr syscall
and it can work on regular file, then it can work on any other files the fs supports.
If this's correct, _require_file_attr can use file_attr to try to set and get
attr on a regular file in $TEST_DIR, to make sure the whole file_set/getattr
feature is supported. Is that right?

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > +
> > >  echo "Error codes"
> > >  # wrong AT_ flags
> > >  file_attr --get --invalid-at $projectdir ./foo
> > > diff --git a/tests/xfs/648 b/tests/xfs/648
> > > index 215c809887b609..e3c2fbe00b666a 100755
> > > --- a/tests/xfs/648
> > > +++ b/tests/xfs/648
> > > @@ -47,6 +47,9 @@ touch $projectdir/bar
> > >  ln -s $projectdir/bar $projectdir/broken-symlink
> > >  rm -f $projectdir/bar
> > >  
> > > +$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> > > +	_notrun "file_getattr not supported on $FSTYP"
> > > +
> > >  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > >  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> > >  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > > 
> > 
> > 
> 

