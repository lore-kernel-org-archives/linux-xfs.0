Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DC920B1EB
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 18:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741111255; cv=none; b=VujyTa6lZ4Gg7S3UF8xaaS9O+qBc7XXAUHQf34sMAJp5bkHx/yZZNzUFeBvUMbL0y9JUJbo8mhHOxH6rFT7xfYx0rUSVaEEaknE89UPWEUIMtMn6JeMBLxB6o64WKnPUaqXWPbsOlu4alQWEKLHJwB7mLhe3yTXKANfHMjBskiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741111255; c=relaxed/simple;
	bh=3WSqMz/LoOIwHMuqPvHCPZ39xMGhc+Vblgx8Y3zTzBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9CfGQil4TwNjBQyMhF8Z+cb1BZDmAW1kEY3l8xoMHN+ISo+cL/pENqZTT2yhBKICYR3lOTWSbuTK+HlfMv2ERTJF9r9a4bOVOm1MhepoS7psPZVBI9C5zinGK5Nw++Bj0vcN7jUZz02EN0hwNvbAtMJFqh3ZGpTOl110kdSKJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YhLABN/b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YhLABN/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741111252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WBecTwctML88vqPy/on9x469GjzYB+S5ZmJ1F5KyEkA=;
	b=YhLABN/bz41xtKzWVWbbtbegzUm/w06OfETVQFq+iu3ai6iZTmyOUU3dxGu9/1Y2sIPJTg
	yqaa8beMi8EIRPLcQdhTFSj21ECqRoisz1W35qQmvVQK67tbFRbvhXPX0tBFPSs19u2FBW
	fA4UHKpWaN1crRN3WufeCBVFO/9mUww=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-ZUWZcMzyO0iHWlPrHv-jEQ-1; Tue, 04 Mar 2025 13:00:46 -0500
X-MC-Unique: ZUWZcMzyO0iHWlPrHv-jEQ-1
X-Mimecast-MFC-AGG-ID: ZUWZcMzyO0iHWlPrHv-jEQ_1741111245
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2fe86c01f5cso11508524a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Mar 2025 10:00:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741111245; x=1741716045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBecTwctML88vqPy/on9x469GjzYB+S5ZmJ1F5KyEkA=;
        b=a6X6dwJBPhVMo7NTqTU2iBREL2mtZKRMCKESzRUqQLzuKs69YTiHBrdp5dMfU6sxw7
         Zqyqg2o/SCYfJQp4i5i59a+HLwAicnTHw8ZTSCEwBt7YYqerx+ogDDgp9GxHOQpuFvib
         fIahu4X0kI+/cCm8ORbTaBhiQsMRQSZ3ain+tdngLSSweaoctVKLtvQHJ90ZCtPut1G1
         50r6Xu0t4B9WbBRJ1tF794g+wYlbAenLtq7z8I0keu/Nm26jGcl0X7uCK+XcEHoyoZzo
         +dbaLjP4TFM34Ho/Lg+n9dw4J4RVZKhvgQYP7OEsZj7Ks2nWwyxTjPN6SVL3AOU/vg7U
         OIwg==
X-Forwarded-Encrypted: i=1; AJvYcCW0CGshxqVo/I9CTP1zIAUIjdzqMXzHJ9tJ1lErfay+HHpgPP9C0lthS8Ubg78KxWijAU+9vlxUNVI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvbcK5jY1v+fWc/76OXIiM87Q1zsQiVxj3tnkR6u628CGjNbpS
	p6E9xZnbHYEd+eVAMED80v9mbG2eO29X+cYr/yEkqNbQJFn1NILyDeKz//1T9gu+pE8Fg/Vex1X
	gvBkNM6Od8ueU+d0P7AyvJjCuv1UwlErTcw9mCTEjvxbfhhMUvGxl8dUKPA==
X-Gm-Gg: ASbGncuH2zSzdnY6gUJGllh6j2jV0ZxutzPQVOrISnOaEHw9DnKwCos9sYLpPw3Z53q
	5pnKFPn3/h0u4ijyh3cjZqP28tUxcSBMIji3w577AA/vE7vr/kVx+KC5nbGUpqmyNQpuexhvVQk
	j2vKP56D0EABq2pHNtLjVfkZB93TD9R0KR3aK3jvujKS/WmPCGyovkTEnnlH5encJBq93cOTaME
	3mH3M9HK28aESPdW5YzkN6Vl6PVKX4yq0+n9JNA+ONOfXWLUblF588V71M7kuV+F4cL9wFwTQnJ
	1Ah8zP+TmuIfKbAdtcb+O4VQqARR3bW6hARAlfxrfBn/AIErxujO/Kk8
X-Received: by 2002:a05:6a21:4613:b0:1ee:dd60:194f with SMTP id adf61e73a8af0-1f2f4e45147mr28203968637.26.1741111245024;
        Tue, 04 Mar 2025 10:00:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrEVpMt1TC86DAQEPPAlMYdw+D+XtbQA6Vq0wy6kj5q/vKdTteC5BmkNy4Tg+w1dtlyrVhuw==
X-Received: by 2002:a05:6a21:4613:b0:1ee:dd60:194f with SMTP id adf61e73a8af0-1f2f4e45147mr28203921637.26.1741111244603;
        Tue, 04 Mar 2025 10:00:44 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af14cd45d19sm7644214a12.35.2025.03.04.10.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 10:00:44 -0800 (PST)
Date: Wed, 5 Mar 2025 02:00:40 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] fstests: test mkfs.xfs protofiles with xattr support
Message-ID: <20250304180040.7yoddqyciqajw47d@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173706975660.1928701.8344148155038133836.stgit@frogsfrogsfrogs>
 <173706975673.1928701.14882814105946770615.stgit@frogsfrogsfrogs>
 <20250302131544.5om3lil64kw5nnyo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20250304174242.GA2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304174242.GA2803749@frogsfrogsfrogs>

On Tue, Mar 04, 2025 at 09:42:42AM -0800, Darrick J. Wong wrote:
> On Sun, Mar 02, 2025 at 09:15:44PM +0800, Zorro Lang wrote:
> > On Thu, Jan 16, 2025 at 03:35:04PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Make sure we can do protofiles with xattr support.
> > > 
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > 
> > This test always fails on my side, as below (diff output):
> > 
> >    ...
> >    Attribute "rootdata" has a 5 byte value for SCRATCH_MNT/directory/test
> >    Attribute "bigdata" has a 37960 byte value for SCRATCH_MNT/directory/test
> >    Attribute "acldata" has a 5 byte value for SCRATCH_MNT/directory/test
> >   +Attribute "selinux" has a 28 byte value for SCRATCH_MNT/directory/test
> >    *** unmount FS
> >    *** done
> >    *** unmount
> > 
> > Looks like the $SELINUX_MOUNT_OPTIONS doesn't help the mkfs protofile
> > with xattrs.
> 
> Oops.  Ok then, I'll filter them out below...
> 
> > Thanks,
> > Zorro
> > 
> > 
> > >  tests/xfs/1937     |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/1937.out |  102 +++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 246 insertions(+)
> > >  create mode 100755 tests/xfs/1937
> > >  create mode 100644 tests/xfs/1937.out
> > >
 
[snip]

> > > +	echo "*** verify FS"
> > > +	(cd $SCRATCH_MNT ; find . | LC_COLLATE=POSIX sort \
> > > +		| grep -v ".use_space" \
> > > +		| xargs $here/src/lstat64 | _filter_stat)
> > > +	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
> > > +		|| _fail "bigfile corrupted"
> > > +	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
> > > +		|| _fail "symlink broken"
> > > +
> > > +	$ATTR_PROG -l $SCRATCH_MNT/directory/test | _filter_scratch
> 
> ...so they don't spill into the golden output.  As this is already in
> patches-in-queue, do you want me to send a fixpatch on top of that?

If you just need a simple filter, I think you can tell me what do you
want to change, I can amend the commit simply. Or if you need to change
more, only re-send this patch is good to me :)

Thanks,
Zorro

> 
> --D
> 
> > > +
> > > +	echo "*** unmount FS"
> > > +	_full "umount"
> > > +	_scratch_unmount >>$seqfull 2>&1 \
> > > +		|| _fail "umount failed"
> > > +}
> > > +
> > > +_verify_fs 2
> > > +
> > > +echo "*** done"
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/1937.out b/tests/xfs/1937.out
> > > new file mode 100644
> > > index 00000000000000..050c8318b1abca
> > > --- /dev/null
> > > +++ b/tests/xfs/1937.out
> > > @@ -0,0 +1,102 @@
> > > +QA output created by 1937
> > > +Wrote 2048.00Kb (value 0x2c)
> > > +*** create FS version 2
> > > +*** check FS
> > > +*** mount FS
> > > +*** verify FS
> > > + File: "."
> > > + Size: <DSIZE> Filetype: Directory
> > > + Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 4 
> > > +
> > > + File: "./bigfile"
> > > + Size: 2097152 Filetype: Regular File
> > > + Mode: (0666/-rw-rw-rw-) Uid: (3) Gid: (0)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./block_device"
> > > + Size: 0 Filetype: Block Device
> > > + Mode: (0012/b-----x-w-) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 Device type: 161,162
> > > +
> > > + File: "./char_device"
> > > + Size: 0 Filetype: Character Device
> > > + Mode: (0345/c-wxr--r-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 Device type: 177,178
> > > +
> > > + File: "./directory"
> > > + Size: <DSIZE> Filetype: Directory
> > > + Mode: (0755/drwxr-xr-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 2 
> > > +
> > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_0"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_1"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_2"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_3"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_4"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./directory/test"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./directory_setgid"
> > > + Size: <DSIZE> Filetype: Directory
> > > + Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
> > > +Device: <DEVICE> Inode: <INODE> Links: 2 
> > > +
> > > + File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./pipe"
> > > + Size: 0 Filetype: Fifo File
> > > + Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./setgid"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (2666/-rw-rwsrw-) Uid: (0) Gid: (0)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./setugid"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (6666/-rwsrwsrw-) Uid: (0) Gid: (0)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./setuid"
> > > + Size: 1348680 Filetype: Regular File
> > > + Mode: (4666/-rwsrw-rw-) Uid: (0) Gid: (0)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +
> > > + File: "./symlink"
> > > + Size: 7 Filetype: Symbolic Link
> > > + Mode: (0123/l--x-w--wx) Uid: (0) Gid: (0)
> > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > +Attribute "userdata" has a 5 byte value for SCRATCH_MNT/directory/test
> > > +Attribute "rootdata" has a 5 byte value for SCRATCH_MNT/directory/test
> > > +Attribute "bigdata" has a 37960 byte value for SCRATCH_MNT/directory/test
> > > +Attribute "acldata" has a 5 byte value for SCRATCH_MNT/directory/test
> > > +*** unmount FS
> > > +*** done
> > > +*** unmount
> > > 
> > 
> 

