Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004F51CDA3F
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 18:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731695310; cv=none; b=gV7gQQim0C4aDuWTXLBG5B+BW3mIItcHQc9ylh29UW4SMwqUeJiM6IAjUL+IFBSCaO4ZTgBzrziKtiohSkbT3POiIAcsKa/2FWu0M+5jAfxQhxrx2B/QnKp6x2DsPrQ675dIyXEju1GzQuKngPW0ntBlV0GTiJ1G5xisjHIwQEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731695310; c=relaxed/simple;
	bh=S8bo5gRxhwbvbPFUaZTwkGPy5avN4Ir2BNfyf5lFqig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMyU2IxKsgmd93ui4zzga6m0MMLsjI7fzjd2FX5kOS78rBMFnPDAqWOXN8qp8R637hll8yN0CnIsZCcvcuylkiYP8lCkPXe9F5hYDkUz4Khb/0+7wxpuadq3XkZjqX9iF7BGG+DUrPm4k0KLF4nAu3FxJASk905NRRivn3FkhbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hOyEpt9Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOyEpt9Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731695307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2rZfIY4WtRjA5tOjZUmmORwO6XW8y/lGMFezNbVVDQ=;
	b=hOyEpt9QUI0qqXliPsXN2A2AUCpcCqX95GlZD/GwI56snuuODizW81fbiQ8ovdC6AyFkPu
	f+rGvYbgs+DZBqGfrjWQplUe/iBGoAedK6pnlFH0XoHOtKavL9I6qL7ngtp06e448ffvUL
	Ubo86qmlalOs9ef6ApDgYbO8UlrxHm8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-jn2zif1jNUazoDf3q9rt8Q-1; Fri, 15 Nov 2024 13:28:26 -0500
X-MC-Unique: jn2zif1jNUazoDf3q9rt8Q-1
X-Mimecast-MFC-AGG-ID: jn2zif1jNUazoDf3q9rt8Q
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-720738f8040so1708196b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 10:28:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731695305; x=1732300105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2rZfIY4WtRjA5tOjZUmmORwO6XW8y/lGMFezNbVVDQ=;
        b=qZc/1sOBRO5o+xFh99BGElEt84LhVeMHndKx8lqtlLwrg0pYhOMHr+rOpfveGwleMZ
         b9GNy/hE0Q6aJov+5ZJvDtHWoYb0Tee+ZBasyIV+ov1ys4HN+gOctOV24JRwZRTfX1BU
         e1ym026sXK1EBC0wl4JrK1A33dTqy8v6dE9DLFqhLXAfqyHrdCbKsrHuiKkCtkfr5PFn
         hvPIvfwojHMJvBo9TQln8vpDm5HSj4ZpDKImXEtt6HvafNiD4JQBzKzDdCW841Vg5ubk
         4fnncBGOqEacWR5yeMF5lWLiaGzQSwndgb97jbNovedXCVaySY0UMywbd3Ezfbx57UEO
         Y2ug==
X-Forwarded-Encrypted: i=1; AJvYcCUkbV9PA/IvgdbMhBjhkKX9frzu9brDDfQ8IfLEEor+Ml7Hbp9khrgDzpSwgiSl33iXPGXKT14MFGM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSXKHbW6NsRU2SkWDPBAzsctCfngzW+6V8jBHCwrUA5IBUPkmL
	hvQhILTX/4UyKeSMTTP1SZJ4ImHAHQVnbM4wjkK5jmc+4DXrOlOok5RfUlBlCV0XaY95p0VVd8B
	5nZTPpTEEFW0HCL91l9doVmqg7rTbfw33RVSbKfP2d5qw7R7ltnwMajs7zA==
X-Received: by 2002:a05:6a00:2ea4:b0:71e:5b4a:66d4 with SMTP id d2e1a72fcca58-72476b970dbmr4738932b3a.9.1731695305364;
        Fri, 15 Nov 2024 10:28:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEsfPAGt3ghPP3Zw0FeWXfeqrnu3ZLmNQeSm8/semrsabZWDhNQrZH4RawmAGaJcamuoezNzg==
X-Received: by 2002:a05:6a00:2ea4:b0:71e:5b4a:66d4 with SMTP id d2e1a72fcca58-72476b970dbmr4738889b3a.9.1731695304939;
        Fri, 15 Nov 2024 10:28:24 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724771e5cf3sm1713562b3a.143.2024.11.15.10.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 10:28:24 -0800 (PST)
Date: Sat, 16 Nov 2024 02:28:21 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] generic/757: fix various bugs in this test
Message-ID: <20241115182821.s3pt4wmkueyjggx3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
 <173146178859.156441.16666438727834100554.stgit@frogsfrogsfrogs>
 <20241114052328.rnm54xeqxnvkaluc@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241114053019.GM9438@frogsfrogsfrogs>
 <20241115054251.azrrmicopowrlqaa@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241115173027.GG9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115173027.GG9425@frogsfrogsfrogs>

On Fri, Nov 15, 2024 at 09:30:27AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 15, 2024 at 01:42:51PM +0800, Zorro Lang wrote:
> > On Wed, Nov 13, 2024 at 09:30:19PM -0800, Darrick J. Wong wrote:
> > > On Thu, Nov 14, 2024 at 01:23:28PM +0800, Zorro Lang wrote:
> > > > On Tue, Nov 12, 2024 at 05:37:29PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Fix this test so the check doesn't fail on XFS, and restrict runtime to
> > > > > 100 loops because otherwise this test takes many hours.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  tests/generic/757 |    7 ++++++-
> > > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > > 
> > > > > 
> > > > > diff --git a/tests/generic/757 b/tests/generic/757
> > > > > index 0ff5a8ac00182b..9d41975bde07bb 100755
> > > > > --- a/tests/generic/757
> > > > > +++ b/tests/generic/757
> > > > > @@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
> > > > >  cur=$(_log_writes_find_next_fua $prev)
> > > > >  [ -z "$cur" ] && _fail "failed to locate next FUA write"
> > > > >  
> > > > > -while [ ! -z "$cur" ]; do
> > > > > +for ((i = 0; i < 100; i++)); do
> > > > >  	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
> > > > >  
> > > > > +	# xfs_repair won't run if the log is dirty
> > > > > +	if [ $FSTYP = "xfs" ]; then
> > > > > +		_scratch_mount
> > > > 
> > > > Hi Darrick, can you mount at here? I always get mount error as below:
> > > > 
> > > > SECTION       -- default
> > > > FSTYP         -- xfs (non-debug)
> > > > PLATFORM      -- Linux/x86_64 dell-per750-41 6.12.0-0.rc5.44.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Oct 28 14:12:55 UTC 2024
> > > > MKFS_OPTIONS  -- -f /dev/sda6
> > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch
> > > > 
> > > > generic/757 2185s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//default/generic/757.out.bad)
> > > >     --- tests/generic/757.out   2024-10-27 03:09:48.740518275 +0800
> > > >     +++ /root/git/xfstests/results//default/generic/757.out.bad 2024-11-14 13:18:56.965210155 +0800
> > > >     @@ -1,2 +1,5 @@
> > > >      QA output created by 757
> > > >     -Silence is golden
> > > >     +mount: /mnt/scratch: cannot mount; probably corrupted filesystem on /dev/sda6.
> > > >     +       dmesg(1) may have more information after failed mount system call.
> > > >     +mount -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch failed
> > > >     +(see /root/git/xfstests/results//default/generic/757.full for details)
> > > >     ...
> > > >     (Run 'diff -u /root/git/xfstests/tests/generic/757.out /root/git/xfstests/results//default/generic/757.out.bad'  to see the entire diff)
> > > > Ran: generic/757
> > > > Failures: generic/757
> > > > Failed 1 of 1 tests
> > > > 
> > > > # dmesg
> > > > ...
> > > > [1258572.169378] XFS (sda6): Mounting V5 Filesystem a0bf3918-1b66-4973-b03c-afd5197a6d21
> > > > [1258572.193037] XFS (sda6): Starting recovery (logdev: internal)
> > > > [1258572.201691] XFS (sda6): Corruption warning: Metadata has LSN (1:41116) ahead of current LSN (1:161). Please unmount and run xfs_repair (>= v4.3) to resolve.
> > > > [1258572.215850] XFS (sda6): Metadata CRC error detected at xfs_bmbt_read_verify+0x16/0xc0 [xfs], xfs_bmbt block 0x2000e8 
> > > > [1258572.226825] XFS (sda6): Unmount and run xfs_repair
> > > > [1258572.231796] XFS (sda6): First 128 bytes of corrupted metadata buffer:
> > > > [1258572.238411] 00000000: 42 4d 41 33 00 00 00 fb 00 00 00 00 00 04 00 9e  BMA3............
> > > > [1258572.246585] 00000010: 00 00 00 00 00 04 00 60 00 00 00 00 00 20 00 e8  .......`..... ..
> > > > [1258572.254766] 00000020: 00 00 00 01 00 00 a0 9c a0 bf 39 18 1b 66 49 73  ..........9..fIs
> > > > [1258572.262945] 00000030: b0 3c af d5 19 7a 6d 21 00 00 00 00 00 00 00 83  .<...zm!........
> > > > [1258572.271117] 00000040: 17 2f 1b e4 00 00 00 00 00 00 00 00 04 b1 2e 00  ./..............
> > > > [1258572.279291] 00000050: 00 00 00 4b 15 e0 00 01 80 00 00 00 04 b1 30 00  ...K..........0.
> > > > [1258572.287462] 00000060: 00 00 00 4b 16 00 00 4f 00 00 00 00 04 b1 ce 00  ...K...O........
> > > > [1258572.295635] 00000070: 00 00 00 4b 1f e0 00 01 80 00 00 00 04 b1 d0 00  ...K............
> > > > [1258572.303811] XFS (sda6): Filesystem has been shut down due to log error (0x2).
> > > > [1258572.311123] XFS (sda6): Please unmount the filesystem and rectify the problem(s).
> > > > [1258572.318791] XFS (sda6): log mount/recovery failed: error -74
> > > > [1258572.324798] XFS (sda6): log mount failed
> > > > [1258572.365169] XFS (sda5): Unmounting Filesystem eb4b7840-2c01-4306-9a6c-af2e7207a23f
> > > 
> > > I see periodic corruption messages, but generally the mount succeeds and
> > > the test passes, even with TOT -rc6.
> > 
> > Still fails on -rc7+ [1]. Even with `xfs_repair $SCRATCH_DEV` before mount, it still fails [2].
> > But `xfs_repair -L` helps, the test can keep running after that.
> > 
> > Do you think it's a xfs issue, or a case issue (xfs need a log cleanup at here?).
> 
> I'm not sure.  Does your sda6 device support discards?  My VMs'
> SCRATCH_DEVs usually support it, and I noticed that all the other
> generic/ _log_writes_init tests set up a dm-thin volume so that the
> replays can always zero out the whole device before jumping to a
> snapshot.

No, it doesn't support discard, but it's multi-scripted:

# mkfs.xfs -f /dev/sda6
meta-data=/dev/sda6              isize=512    agcount=25, agsize=1064176 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0  
data     =                       bsize=4096   blocks=26604400, imaxpct=25
         =                       sunit=16     swidth=32 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=179552, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

But you remind me, I remember Brian did below changes for dmlogwrites test.

fc5870da4 generic/470: use thin volume for dmlogwrites target device
3713a3b37 generic/457: use thin volume for dmlogwrites target device
96bcbcabd generic/455: use thin volume for dmlogwrites target device

commit 96bcbcabd0f34dcd57f9349c8eea09523d69a817
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 1 09:47:26 2020 -0400

    generic/455: use thin volume for dmlogwrites target device
    
    dmlogwrites support for XFS depends on discard zeroing support of
    the intended target device. Update the test to use a thin volume and
    allow it to run consistently and reliably on XFS.

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > [1]
> > # ./check -s default generic/757
> > SECTION       -- default
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 dell-per750-41 6.12.0-0.rc7.58.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Nov 11 15:23:45 UTC 2024
> > MKFS_OPTIONS  -- -f /dev/sda6
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch
> > 
> > generic/757 2185s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//default/generic/757.out.bad)
> >     --- tests/generic/757.out   2024-10-27 03:09:48.740518275 +0800
> >     +++ /root/git/xfstests/results//default/generic/757.out.bad 2024-11-15 03:06:59.462739215 +0800
> >     @@ -1,2 +1,5 @@
> >      QA output created by 757
> >     -Silence is golden
> >     +mount: /mnt/scratch: cannot mount; probably corrupted filesystem on /dev/sda6.
> >     +       dmesg(1) may have more information after failed mount system call.
> >     +mount -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch failed
> >     +(see /root/git/xfstests/results//default/generic/757.full for details)
> >     ...
> >     (Run 'diff -u /root/git/xfstests/tests/generic/757.out /root/git/xfstests/results//default/generic/757.out.bad'  to see the entire diff)
> > Ran: generic/757
> > Failures: generic/757
> > Failed 1 of 1 tests
> > 
> > [2]
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> > ERROR: The filesystem has valuable metadata changes in a log which needs to
> > be replayed.  Mount the filesystem to replay the log, and unmount it before
> > re-running xfs_repair.  If you are unable to mount the filesystem, then use
> > the -L option to destroy the log and attempt a repair.
> > Note that destroying the log may cause corruption -- please attempt a mount
> > of the filesystem before doing this.
> > 
> > > 
> > > --D
> > > 
> > > > > +		_scratch_unmount
> > > > > +	fi
> > > > 
> > > > 
> > > > >  	_check_scratch_fs
> > > > >  
> > > > >  	prev=$cur
> > > > > 
> > > > 
> > > > 
> > > 
> > 
> > 
> 

