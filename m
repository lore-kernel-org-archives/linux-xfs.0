Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E7F78F43
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 04:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737519550; cv=none; b=NIjpS324nKthyi4kcVLFLv8lhrqyBp9ytVe6XpwTHwUYl5zIL5KbLhsjC8iL3onX1+xg9g0d7wglY9LvQ+eiDW+OtAkqIpFXiLjHP3706IPyINgx7eD+z8C1IltheRVRYjDGI6d1/uYzI0WhJpHfSDvnQd/8rCyyddQ0Z0qNv2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737519550; c=relaxed/simple;
	bh=JG0CQBkzu4EfxKaPxKR1zi9VKeZFzsdXf08p/gbxXuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzTlVJooOBm/P/rhne5s4c5Od7t++KTMt1KPEoGLjGvadJTiMqb/Yi9NNXkaZiB7woXALTOCKTATZHLEDmRWhO8V+hxfCDn8cvvk0e3hokLoKEincEmiMzHjvXcZh5qkaTyJonguQYyq+dlIZbXI0GZqT8RjNIQ3rUu1aYAkmyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=r/o3ygpv; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="r/o3ygpv"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ef714374c0so699941a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 20:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737519548; x=1738124348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bdlLkCODvsE17qSC5n73WWnIq7rNqHzzruEgL85deP0=;
        b=r/o3ygpv8r9XD+fqRs6u4wFsgtYS2kbu23wfHVxnIXckKL6GoJv6CfvhDdVtGla5aG
         BIKIq+Ov7Ty43wBwpSz2nxhi/xnOz+FEMLYDs9zSQCVj5aA/9PayemUBgb700ztvwZMp
         2650hHCeC4rheZjdDXIIcU/S76l0jywyVFyO5rHnPkmweOz1sP26WseFCp0MiFbEVnLG
         fJ7iA7lWUjHb8DqBZyoGFCsDeEsq1ruzo/XGk82cqFYxCdCtoIkqvRBWpVeMG0jkQt0f
         LK1YSFY2euVPBjfeqsqx6snpTqJEiQmSidOGN9tibm0RidI/cpbt1TkbGiPaipf7DQLk
         bXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737519548; x=1738124348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdlLkCODvsE17qSC5n73WWnIq7rNqHzzruEgL85deP0=;
        b=AEaedlszRvSNvGjtq2kTx4tffWv8/HVk5zyQVJgm+hgUAAhf4RdgDX+RevY98tZYVE
         bPGATR52IWwW93cYtMiiXdc183kYxxyAsiJmatU3gI5n6+X3mt3qYK0w7GGH25Ug69qm
         MiX+hiRe7gdSTFO9ka0YVc31x4n4wtmhGMtuOZnDjiMSLKZ69H8zh+PZvpqopQe91a7W
         3MECowCSjxsy/mSIVtZ4VLzZhjsCdK2iaeAE/DccRNXPmPE26J9DiK2EW2WPwb57I7Yy
         q8YJDm3aDa7ghtOKNxiS1JWmIohaw+qA4nlgJrzCQhWE0LbHRW7hJjnyS52SLkNC1Jg2
         9gqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVGMySfLkhSIYMfDZ3Xr8Po9Gr37ZmxdrgAJI91nEfcnHsLIOSWyAdKg5rbfJXM1DPwWL2o2uDPu4=@vger.kernel.org
X-Gm-Message-State: AOJu0YylfltGlyEGUyB3iM2wtJr7fsG319GM52i1ju1bHWMGrc1C2swB
	OK0gtWFkaxeGyV5cqmk1drNtPmAgL0WMPqjOqSj7iZ6W9Ic6n2VHnbnInhEHzMtu0XhVreaaMrA
	Q
X-Gm-Gg: ASbGncsSv/DO4R7kUl0ioaNLrnxkA3wJXttT4F11HQYcwZkXQRRzLlQp6uBfLiYJBmn
	rOgpuFyYjBJzReUKGjH1i28X3UVeJzktVyXICp3S108HoFpGqu2nSsmn3sXMeZWuiTMgEs5CJBw
	oWxbn3eVWktXVXfy4ociDI7Kz10ZwJ8VAtohi+lvnpR4JhWwTEBaZCVhJCLM1JnkJDKYiU+JKlv
	z8y60ChDq31LMtaz/Xs/gtpEmW+OECKjrFFWpXpDwdxJQfxAs3Tr4uR7ETrgkjJTd7f/VoaP1gP
	octXlq4pEtH980KrD5BP/wSXrfH1kFi2gng=
X-Google-Smtp-Source: AGHT+IHUR7n4PGomaS045lySnWmnDu2iRph+5H3AhNVt3r5dS1ktgCWBx7MOwKAmaSRxspCM//EHTQ==
X-Received: by 2002:a17:90b:38c6:b0:2ef:949c:6f6b with SMTP id 98e67ed59e1d1-2f728e472dcmr43289443a91.13.1737519547882;
        Tue, 21 Jan 2025 20:19:07 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7e6a78914sm408689a91.11.2025.01.21.20.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 20:19:07 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1taSCm-00000008wLB-2pU9;
	Wed, 22 Jan 2025 15:19:04 +1100
Date: Wed, 22 Jan 2025 15:19:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/23] generic/032: fix pinned mount failure
Message-ID: <Z5BxuB8SuqgjOJA3@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974288.1927324.17585931341351454094.stgit@frogsfrogsfrogs>
 <Z48qm4BG6tlp5nCa@dread.disaster.area>
 <20250122040834.GW1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122040834.GW1611770@frogsfrogsfrogs>

On Tue, Jan 21, 2025 at 08:08:34PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 21, 2025 at 04:03:23PM +1100, Dave Chinner wrote:
> > On Thu, Jan 16, 2025 at 03:28:49PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > generic/032 now periodically fails with:
> > > 
> > >  --- /tmp/fstests/tests/generic/032.out	2025-01-05 11:42:14.427388698 -0800
> > >  +++ /var/tmp/fstests/generic/032.out.bad	2025-01-06 18:20:17.122818195 -0800
> > >  @@ -1,5 +1,7 @@
> > >   QA output created by 032
> > >   100 iterations
> > >  -000000 cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  >................<
> > >  -*
> > >  -100000
> > >  +umount: /opt: target is busy.
> > >  +mount: /opt: /dev/sda4 already mounted on /opt.
> > >  +       dmesg(1) may have more information after failed mount system call.
> > >  +cycle mount failed
> > >  +(see /var/tmp/fstests/generic/032.full for details)
> > > 
> > > The root cause of this regression is the _syncloop subshell.  This
> > > background process runs _scratch_sync, which is actually an xfs_io
> > > process that calls syncfs on the scratch mount.
> > > 
> > > Unfortunately, while the test kills the _syncloop subshell, it doesn't
> > > actually kill the xfs_io process.  If the xfs_io process is in D state
> > > running the syncfs, it won't react to the signal, but it will pin the
> > > mount.  Then the _scratch_cycle_mount fails because the mount is pinned.
> > > 
> > > Prior to commit 8973af00ec212f the _syncloop ran sync(1) which avoided
> > > pinning the scratch filesystem.
> > 
> > How does running sync(1) prevent this? they run the same kernel
> > code, so I'm a little confused as to why this is a problem caused
> > by using the syncfs() syscall rather than the sync() syscall...
> 
> Instead of:
> _scratch_sync -> _sync_fs $SCRATCH_MNT -> $XFS_IO_PROG -rxc "syncfs" $SCRATCH_MNT
> 
> sync(1) just calls sync(2) with no open files other than
> std{in,out,err}.

Sure, but while sync(2) is writing back a superblock it pins the
superblock by holding the s_umount lock. So even if the sync process
is killable, it still pins the dirty superblock for the same
amount of time as syncfs.

Oh, in the sync case unmount blocks on the s_umount lock rather than
returns -EBUSY because of the elevated open file count with syncfs.
Ok, gotcha, we've been using different definitions for the phrase
"mount is pinned". :/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
