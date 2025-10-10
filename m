Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5FC13AD1C
	for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 09:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760088640; cv=none; b=uN+DXN5l93qvQHMnI4XeuYq4VJG18A7GBEk8DB8ucqPY6mYcQsW25X16XnirM1+T4FXYcQ5TX754WgSzL3JvIVsljgHbpIWnc1DHZwe4VBXrNAskfeZk0WEcg7lZIvOaFSN3FrgMvbT+6a1V0b4VUIBTCpFIpl+KKhG9/0Bq784=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760088640; c=relaxed/simple;
	bh=Mj1VFJrp5c9ZO6C9l+r3P2v9gziELaHnsFG5WfCZSmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPZJjXMrXFJlCNXzn0triKLn1Zw9UqMjchPK9Z43RlgvQuIQHhU5YPfTKXeRg1Etym648uk1EJI9Hh8/b7KNbIR891Y0ZkoR+bZHxpb6snzJG/JzH4QoRxxfR8vOhEx6FxtMzSuONTBAkWolwdkcxeeEPGNPKpSoFy8CvgbwIeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EtXqlnWa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EtXqlnWa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760088637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m19Suyk+a/n7mC2eYJunRdPA51fybU8+8EZ/+1nO9VI=;
	b=EtXqlnWamSfoAVhBUZ4vLoMwrgCfDqIg2u8ynOn5BYBf5H+UG1pgl2zcgTnO6HgKRSA52B
	rWuhWOfL8AuBcI5ByJ8AqvMCE8OSh5R/Zx3fe2ZWu24l/WXnvwV1s8J5xrhzG+1ir4r+wQ
	CecO9z7AFbYn6Q+kVMKTLslDyp3pmQw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-sdPyazhtP1SlHxlOaKSyVw-1; Fri, 10 Oct 2025 05:30:33 -0400
X-MC-Unique: sdPyazhtP1SlHxlOaKSyVw-1
X-Mimecast-MFC-AGG-ID: sdPyazhtP1SlHxlOaKSyVw_1760088632
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e473e577eso12144055e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 02:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760088632; x=1760693432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m19Suyk+a/n7mC2eYJunRdPA51fybU8+8EZ/+1nO9VI=;
        b=qX7Hp19DOyqXtEz1y1Jn2T7sUM9ljnGZVDPIUY/yti6XgN/2NSXwc3VvZKgxeF++Px
         OKeS1zEfvaeTMqp07NLEUVOMTii3IwjNJLrIpBkKbTHbNHKjFWgrdi7/1V+eaYT+4tan
         jztB4OPu5eTPm0CYQlJbZ+e1Nv83yx8lgHErX+sHL3SXzMCWkWTANBqiY+kpSh2vZR9E
         G9Ac1Pa0IpZZsF3edFRK4HF9J6Ug2ql0N1xpD9vhND3E6e0yp22bh5Je20zRr8CQRf+r
         TWiD3iI2lPYV35XqbFeHYnHRvfXI6e83aqdlQz2BBLogDEfzhVc9nSnKyHqtjeN5TXsw
         AODw==
X-Forwarded-Encrypted: i=1; AJvYcCUYrI0CWU74BwPtiqOFkDLkzZ+nKmV7NFl6ER9EY+fqFg2bfYR80hH92QV4T3n6cdYKWcvuXxAG0Zk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7RNYB2YqTiR4WqNotGOYWiJoyFPgfDGLLKoOlsJUFurRE9S2E
	EOBPtXX0PaMRYnk8kUk3U6hr7JvktJJeP4w+GgZyAWmxpp3CMPKsCaPYSGn3LKKYJViWbolUhaK
	Km1ACg1XKne8Q7q5wpmlD9Zio+qSq22Zd1V6JmLcXB7gMVBakRsI8JVEhIU27
X-Gm-Gg: ASbGncsap4JaQRu2EyYEK/pZVZhBZSVv4ZIoRsv7Bhn6i7077z89k8dGcM80vqSGZ5N
	TFLLcxN4wQmkNqiqqmL4hC9FBzowJZgGBQFKrSCBITQg/oriLibtZnylWk19/HiQSRebo6E8BIw
	zTVOQpfu3WcEmAwJ3DRE34vAHMMl5sUQ2swDxq5cwXhoVO4qCtnLwU51hMcj9giJeyGd5XWqZHh
	oMw3hMYEmDtDlDNNpbdw9g+XiEkDkW7vYyPX3haZ0GuM860u338jlNMTQyu6fb6wHYl4tqrehE3
	KcCSuHqNmkQN+AySRvWN0l9zBq5JPje7AOzw4S01EN/NVfpBe0MEPh80scMP
X-Received: by 2002:a05:600c:8b22:b0:46e:4882:94c7 with SMTP id 5b1f17b1804b1-46fa9b02c6amr75031555e9.28.1760088632084;
        Fri, 10 Oct 2025 02:30:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEValMKthgp8I9VN0cd5Fx0yrOVtvxfOWumQ9lQuIn4WkPIIugbGuRT1eABE90tSGUAw2wzQw==
X-Received: by 2002:a05:600c:8b22:b0:46e:4882:94c7 with SMTP id 5b1f17b1804b1-46fa9b02c6amr75031225e9.28.1760088631453;
        Fri, 10 Oct 2025 02:30:31 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb482ba41sm39161405e9.4.2025.10.10.02.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 02:30:31 -0700 (PDT)
Date: Fri, 10 Oct 2025 11:30:30 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v4 1/3] file_attr: introduce program to set/get fsxattr
Message-ID: <g25qhhy73arfepcubtsvrhfc3e3e2dktoludzpfwqxvkcphkxf@4n5s4jpvxmpr>
References: <20251003-xattrat-syscall-v4-0-1cfe6411c05f@kernel.org>
 <20251003-xattrat-syscall-v4-1-1cfe6411c05f@kernel.org>
 <20251005103656.5qu3lmjvlcjkwjx4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <7mytyiatnhgwplgda3cmiqq3hb7z6ulwgvwbkueb5dm2sdxwlg@ijti4d7vgrck>
 <20251009185630.GA6178@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009185630.GA6178@frogsfrogsfrogs>

On 2025-10-09 11:56:30, Darrick J. Wong wrote:
> On Mon, Oct 06, 2025 at 11:37:53AM +0200, Andrey Albershteyn wrote:
> > On 2025-10-05 18:36:56, Zorro Lang wrote:
> > > On Fri, Oct 03, 2025 at 11:32:44AM +0200, Andrey Albershteyn wrote:
> > > > This programs uses newly introduced file_getattr and file_setattr
> > > > syscalls. This program is partially a test of invalid options. This will
> > > > be used further in the test.
> > > > 
> > > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > > ---
> > > 
> > > [snap]
> > > 
> > > > +	if (!path1 && optind < argc)
> > > > +		path1 = argv[optind++];
> > > > +	if (!path2 && optind < argc)
> > > > +		path2 = argv[optind++];
> > > > +
> > > > +	if (at_fdcwd) {
> > > > +		fd = AT_FDCWD;
> > > > +		path = path1;
> > > > +	} else if (!path2) {
> > > > +		error = stat(path1, &status);
> > > > +		if (error) {
> > > > +			fprintf(stderr,
> > > > +"Can not get file status of %s: %s\n", path1, strerror(errno));
> > > > +			return error;
> > > > +		}
> > > > +
> > > > +		if (SPECIAL_FILE(status.st_mode)) {
> > > > +			fprintf(stderr,
> > > > +"Can not open special file %s without parent dir: %s\n", path1, strerror(errno));
> > > > +			return errno;
> > > > +		}
> > > > +
> > > > +		fd = open(path1, O_RDONLY);
> > > > +		if (fd == -1) {
> > > > +			fprintf(stderr, "Can not open %s: %s\n", path1,
> > > > +					strerror(errno));
> > > > +			return errno;
> > > > +		}
> > > > +	} else {
> > > > +		fd = open(path1, O_RDONLY);
> > > > +		if (fd == -1) {
> > > > +			fprintf(stderr, "Can not open %s: %s\n", path1,
> > > > +					strerror(errno));
> > > > +			return errno;
> > > > +		}
> > > > +		path = path2;
> > > > +	}
> > > > +
> > > > +	if (!path)
> > > > +		at_flags |= AT_EMPTY_PATH;
> > > > +
> > > > +	error = file_getattr(fd, path, &fsx, fa_size,
> > > > +			at_flags);
> > > > +	if (error) {
> > > > +		fprintf(stderr, "Can not get fsxattr on %s: %s\n", path,
> > > > +				strerror(errno));
> > > > +		return error;
> > > > +	}
> > > 
> > > We should have a _require_* helper to _notrun your generic and xfs test cases,
> > > when system doesn't support the file_getattr/setattr feature. Or we always hit
> > > something test errors like below on old system:
> > > 
> > >   +Can not get fsxattr on ./fifo: Operation not supported
> > > 
> > > Maybe check if the errno is "Operation not supported", or any better idea?
> > 
> > There's build system check for file_getattr/setattr syscalls, so if
> > they aren't in the kernel file_attr will not compile.
> > 
> > Then there's _require_test_program "file_attr" in the tests, so
> > these will not run if kernel doesn't have these syscalls.
> > 
> > However, for XFS for example, there's [1] and [2] which are
> > necessary for these tests to pass. 
> > 
> > So, there a few v6.17 kernels which would still run these tests but
> > fail for XFS (and still fails as these commits are in for-next now).
> > 
> > For other filesystems generic/ will also fail on newer kernels as it
> > requires similar modifications as in XFS to support changing file
> > attributes on special files.
> > 
> > I suppose it make sense for this test to fail for other fs which
> > don't implement changing file attributes on special files.
> > Otherwise, this test could be split into generic/ (file_get/setattr
> > on regular files) and xfs/ (file_get/setattr on special files).
> > 
> > What do you think?
> 
> generic/772 (and xfs/648) probably each ought to be split into two
> pieces -- one for testing file_[gs]etattr on regular/directory files;
> and a second one for the special files.  All four of them ought to
> _notrun if the kernel doesn't support the intended target.

I see, yeah that's what I thought of, I will split them and send new
patchset soon

> 
> Right now I have injected into both:
> 
> mkfifo $projectdir/fifo
> 
> $here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> 	_notrun "file_getattr not supported on $FSTYP"

Thanks! Looks like a good check to use

> 
> to make the failures go away on 6.17.
> 
> --D
> 
> > [1]: https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=8a221004fe5288b66503699a329a6b623be13f91
> > [2]: https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=0239bd9fa445a21def88f7e76fe6e0414b2a4da0
> > 
> > > 
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > > +	if (action) {
> > > > +		fsx.fa_xflags |= (fa_xflags | unknwon_fa_flag);
> > > > +
> > > > +		error = file_setattr(fd, path, &fsx, fa_size,
> > > > +				at_flags);
> > > > +		if (error) {
> > > > +			fprintf(stderr, "Can not set fsxattr on %s: %s\n", path,
> > > > +					strerror(errno));
> > > > +			return error;
> > > > +		}
> > > > +	} else {
> > > > +		if (path2)
> > > > +			print_xflags(fsx.fa_xflags, 0, 1, path, 0, 1);
> > > > +		else
> > > > +			print_xflags(fsx.fa_xflags, 0, 1, path1, 0, 1);
> > > > +	}
> > > > +
> > > > +	return error;
> > > > +
> > > > +usage:
> > > > +	printf("Usage: %s [options]\n", argv[0]);
> > > > +	printf("Options:\n");
> > > > +	printf("\t--get, -g\t\tget filesystem inode attributes\n");
> > > > +	printf("\t--set, -s\t\tset filesystem inode attributes\n");
> > > > +	printf("\t--at-cwd, -a\t\topen file at current working directory\n");
> > > > +	printf("\t--no-follow, -n\t\tdon't follow symlinks\n");
> > > > +	printf("\t--set-nodump, -d\t\tset FS_XFLAG_NODUMP on an inode\n");
> > > > +	printf("\t--invalid-at, -i\t\tUse invalid AT_* flag\n");
> > > > +	printf("\t--too-big-arg, -b\t\tSet fsxattr size bigger than PAGE_SIZE\n");
> > > > +	printf("\t--too-small-arg, -m\t\tSet fsxattr size to 19 bytes\n");
> > > > +	printf("\t--new-fsx-flag, -x\t\tUse unknown fa_flags flag\n");
> > > > +
> > > > +	return 1;
> > > > +}
> > > > 
> > > > -- 
> > > > 2.50.1
> > > > 
> > > 
> > 
> > -- 
> > - Andrey
> > 
> > 
> 

-- 
- Andrey

