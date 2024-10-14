Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9CA1AAE39
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 14:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915262; cv=none; b=OK8i1mrtwoPk7FXqEZEEQ2jZXG1u3kpL2n1j/3MvNlWfykVqtTyIbqDAHfjs6JZy3cV1F2cG3l6SuS36pQO4Htg4/k38IJLthXxB1UkjZNmbDYDwaApUSoBIF5XkBFdDKG9hhIgdYjrTqx05o/k3gAVhlOyXOtamnK7HteG5qVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915262; c=relaxed/simple;
	bh=p1uWY716fhmZBfPVnp/WYc1UWmzhDrhhqnmrtPA7o1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFbiB39bpNILmpucG/x56UdA9BAqhxdb2ZTcdAKi/fBN04ccBNFn2jT3+hOoHpMZ7z+0OlUvyeNyToUtQzsREuBdV0tYYqMQRXrEIai+FbLimFBLC9xN6JcN/Ye/y8mDsu+r1JAx/7n6lIdIkl/1vl/4w6u/YFfr4gW1Lh16uB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KxWwEc7/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KxWwEc7/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728915260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6gbvnHPHmaOqJLz1nj9wAvViCC9PDyYSP+xt85t+Frk=;
	b=KxWwEc7/up5UchqM7pLaxBCK773Vr2GOv2SytfqGBpCBLxLbisd1ZlYsVAwCcbbdq1f9HY
	0ATJVv1Qx6PPKjsAiSZuofYSC5K1KQj4bwOXrexpqBahZLnjhtz81NC6ec38IgfX8+rpZS
	kFbwFEGSL3SwQxQSbe9KAA8ALXlfVmE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-Ztz_Feb6NCejy_rfEdj3-Q-1; Mon, 14 Oct 2024 10:14:18 -0400
X-MC-Unique: Ztz_Feb6NCejy_rfEdj3-Q-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-204e310e050so56650715ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 07:14:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728915257; x=1729520057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gbvnHPHmaOqJLz1nj9wAvViCC9PDyYSP+xt85t+Frk=;
        b=vxVMp+WmMJsMM5iMLNGgymOtjPzpGv+zmp5QN5gNUsa/NiD+seUgb/3HCHzrOnyeK/
         /uULPpS5+9j69snIrjRkvSOF6N22aV/ibdo6elwAegxLsuO4QNXlGdAbnd5skbno75A6
         Cq5JFNqCoHyJ3Q50ceQbPQXBorvQkJ8wtnfJOs7lqnyeIWj17R41JNmjAhZCCpKBCZLU
         kOM2P46+FTPpvraFz9pv/Dz7Sug9nCk1UQ1DEeoTOA6Xqhs9JhBVNZ/uC0qxg2KyLFK4
         IUBunIhbAkdeGlebKzMXee/QgwAY45Bobaq7avdoBDRrNBsBr5SCRgJ3GI4Ykw3VvzHE
         YO+g==
X-Forwarded-Encrypted: i=1; AJvYcCXf5uQD8ysCWIjQM4MNzshWMARXxfidiyLoht7CGWUozNsWMuH5yHCPu+bOY5fj3W51NKnxaKvvxkY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu0KTIjCHJsPtGW6YYj/RpOpMoi4BzN7KTYVmRsc9FEoG97xU5
	QDJoWm6wwgoYERvQgl7arYEJMMZ3WXxKc+Nf/0Wewov/R+IpaDyZXksH2g+/JHRQLmaEKcIuzZR
	QFXOKySa3v8qGQwOwGbkBaAH281gzAAKYZ0TY9TMu6EpfrIaF6UtLJCQjP4Pyhh8ybhNF
X-Received: by 2002:a17:903:2344:b0:20c:5cdd:a9e with SMTP id d9443c01a7336-20ca147e9damr146247625ad.28.1728915257177;
        Mon, 14 Oct 2024 07:14:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGG6sDbAcTmZ325ycjPkXMURRGc2o3NVlrK/e6e3Jryp8immaR8i2iQOjILaCrnYlQS1vrYCA==
X-Received: by 2002:a17:903:2344:b0:20c:5cdd:a9e with SMTP id d9443c01a7336-20ca147e9damr146247205ad.28.1728915256682;
        Mon, 14 Oct 2024 07:14:16 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c0e75absm66923005ad.164.2024.10.14.07.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 07:14:16 -0700 (PDT)
Date: Mon, 14 Oct 2024 22:14:12 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20241014141412.vfiv62euxavhyyyq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240924084551.1802795-1-hch@lst.de>
 <20240924084551.1802795-2-hch@lst.de>
 <20241001145944.GE21840@frogsfrogsfrogs>
 <20241013174936.og4m2yopfh26ygwm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241014060725.GA20751@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014060725.GA20751@lst.de>

On Mon, Oct 14, 2024 at 08:07:25AM +0200, Christoph Hellwig wrote:
> On Mon, Oct 14, 2024 at 01:49:36AM +0800, Zorro Lang wrote:
> > Thanks for reworking this patch, it's been merged into fstests, named
> > xfs/629~632. But now these 4 cases always fail on upstream xfs, e.g
> > (diff output) [1][2][3][4]. Could you help to take a look at the
> > failure which Darick metioned above too :)
> 
> What do you mean with upstream xfs?  Any kernel before the eofblocks
> fixes will obviously fail.  Always_cow will also always fail and I'll
> send a patch for that.  Any other configuration you've seen?

Sorry, I've lost old test results. From my current test results, the x/629
and x/632 fails [1][2] on pmem device (xfs) with linux v6.12-rc2+
(HEAD=cfea70e835b9180029257d8b772c9e99c3305a9a). The .full output as [3],
the .out.bad output as [4][5]. Besides that, I hit x/629 failed on a loop
device on s390x once (as [6]) with same v6.12-rc2+ kernel.

Thanks,
Zorro

[1]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 hpe-dl360gen11-01 6.12.0-rc2+ #1 SMP PREEMPT_DYNAMIC Sun Oct 13 15:36:13 EDT 2024
MKFS_OPTIONS  -- -f -f -b size=4096 -m crc=1,finobt=1,rmapbt=0,reflink=0,inobtcount=1,bigtime=1 /dev/pmem0
MOUNT_OPTIONS -- -o dax=always -o context=system_u:object_r:root_t:s0 /dev/pmem0 /mnt/fstests/SCRATCH_DIR

xfs/629       - output mismatch (see /var/lib/xfstests/results//xfs/629.out.bad)
    --- tests/xfs/629.out	2024-10-13 16:02:57.113908110 -0400
    +++ /var/lib/xfstests/results//xfs/629.out.bad	2024-10-14 01:52:24.553081084 -0400
    @@ -1,9 +1,17 @@
     QA output created by 629
    -file.0 extent count is in range
    -file.1 extent count is in range
    -file.2 extent count is in range
    -file.3 extent count is in range
    -file.4 extent count is in range
    -file.5 extent count is in range
    ...
    (Run 'diff -u /var/lib/xfstests/tests/xfs/629.out /var/lib/xfstests/results//xfs/629.out.bad'  to see the entire diff)
Ran: xfs/629
Failures: xfs/629
Failed 1 of 1 tests

[2]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 hpe-dl360gen11-01 6.12.0-rc2+ #1 SMP PREEMPT_DYNAMIC Sun Oct 13 15:36:13 EDT 2024
MKFS_OPTIONS  -- -f -f -b size=4096 -m crc=1,finobt=1,rmapbt=0,reflink=0,inobtcount=1,bigtime=1 /dev/pmem0
MOUNT_OPTIONS -- -o dax=always -o context=system_u:object_r:root_t:s0 /dev/pmem0 /mnt/fstests/SCRATCH_DIR

xfs/632       - output mismatch (see /var/lib/xfstests/results//xfs/632.out.bad)
    --- tests/xfs/632.out	2024-10-13 16:02:57.166908766 -0400
    +++ /var/lib/xfstests/results//xfs/632.out.bad	2024-10-14 01:55:32.671284956 -0400
    @@ -1,33 +1,65 @@
     QA output created by 632
    -file.0 extent count is in range
    -file.1 extent count is in range
    -file.2 extent count is in range
    -file.3 extent count is in range
    -file.4 extent count is in range
    -file.5 extent count is in range
    ...
    (Run 'diff -u /var/lib/xfstests/tests/xfs/632.out /var/lib/xfstests/results//xfs/632.out.bad'  to see the entire diff)
Ran: xfs/632
Failures: xfs/632
Failed 1 of 1 tests

[3]
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=655360 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0  
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=300954, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[4]
QA output created by 629
file.0 extent count has value of 520
file.0 extent count is NOT in range 2 .. 40
file.1 extent count has value of 627
file.1 extent count is NOT in range 2 .. 40
file.2 extent count has value of 776
file.2 extent count is NOT in range 2 .. 40
file.3 extent count has value of 725
file.3 extent count is NOT in range 2 .. 40
file.4 extent count has value of 672
file.4 extent count is NOT in range 2 .. 40
file.5 extent count has value of 709
file.5 extent count is NOT in range 2 .. 40
file.6 extent count has value of 660
file.6 extent count is NOT in range 2 .. 40
file.7 extent count has value of 703
file.7 extent count is NOT in range 2 .. 40

[5]
QA output created by 632
file.0 extent count has value of 762
file.0 extent count is NOT in range 1 .. 16
file.1 extent count has value of 800
file.1 extent count is NOT in range 1 .. 16
file.2 extent count has value of 800
file.2 extent count is NOT in range 1 .. 16
file.3 extent count has value of 794
file.3 extent count is NOT in range 1 .. 16
file.4 extent count has value of 800
file.4 extent count is NOT in range 1 .. 16
file.5 extent count has value of 787
file.5 extent count is NOT in range 1 .. 16
file.6 extent count has value of 788
file.6 extent count is NOT in range 1 .. 16
file.7 extent count has value of 800
file.7 extent count is NOT in range 1 .. 16
file.8 extent count has value of 799
file.8 extent count is NOT in range 1 .. 16
file.9 extent count has value of 800
file.9 extent count is NOT in range 1 .. 16
file.10 extent count has value of 793
file.10 extent count is NOT in range 1 .. 16
file.11 extent count has value of 800
file.11 extent count is NOT in range 1 .. 16
file.12 extent count has value of 800
file.12 extent count is NOT in range 1 .. 16
file.13 extent count has value of 800
file.13 extent count is NOT in range 1 .. 16
file.14 extent count has value of 800
file.14 extent count is NOT in range 1 .. 16
file.15 extent count has value of 800
file.15 extent count is NOT in range 1 .. 16
file.16 extent count has value of 800
file.16 extent count is NOT in range 1 .. 16
file.17 extent count has value of 800
file.17 extent count is NOT in range 1 .. 16
file.18 extent count has value of 800
file.18 extent count is NOT in range 1 .. 16
file.19 extent count has value of 797
file.19 extent count is NOT in range 1 .. 16
file.20 extent count has value of 782
file.20 extent count is NOT in range 1 .. 16
file.21 extent count has value of 800
file.21 extent count is NOT in range 1 .. 16
file.22 extent count has value of 800
file.22 extent count is NOT in range 1 .. 16
file.23 extent count has value of 800
file.23 extent count is NOT in range 1 .. 16
file.24 extent count has value of 792
file.24 extent count is NOT in range 1 .. 16
file.25 extent count has value of 777
file.25 extent count is NOT in range 1 .. 16
file.26 extent count has value of 799
file.26 extent count is NOT in range 1 .. 16
file.27 extent count has value of 800
file.27 extent count is NOT in range 1 .. 16
file.28 extent count has value of 793
file.28 extent count is NOT in range 1 .. 16
file.29 extent count has value of 800
file.29 extent count is NOT in range 1 .. 16
file.30 extent count has value of 797
file.30 extent count is NOT in range 1 .. 16


[6]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/s390x s390x-kvm-003 6.12.0-rc2+ #1 SMP Sun Oct 13 15:47:15 EDT 2024
MKFS_OPTIONS  -- -f -m crc=1,finobt=1,reflink=1,rmapbt=1,bigtime=1,inobtcount=1 -b size=1024 /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR

xfs/629       - output mismatch (see /var/lib/xfstests/results//xfs/629.out.bad)
    --- tests/xfs/629.out	2024-10-13 15:56:03.564908748 -0400
    +++ /var/lib/xfstests/results//xfs/629.out.bad	2024-10-13 18:45:54.344510502 -0400
    @@ -1,9 +1,16 @@
     QA output created by 629
    -file.0 extent count is in range
    -file.1 extent count is in range
    -file.2 extent count is in range
    -file.3 extent count is in range
    -file.4 extent count is in range
    -file.5 extent count is in range
    ...
    (Run 'diff -u /var/lib/xfstests/tests/xfs/629.out /var/lib/xfstests/results//xfs/629.out.bad'  to see the entire diff)
Ran: xfs/629
Failures: xfs/629
Failed 1 of 1 tests
> 

