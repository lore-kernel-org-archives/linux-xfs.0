Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8863E61FEB
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 05:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731649382; cv=none; b=If/DsK+cn828B2MXj+uM0U5L7DkkQHYf2IsXXnK31lpDRAuXl5T24a6AApJdPvrjLWPo+UmnOZfx+4V6PHeExw9Wpb6pe9k9ooEfKEUGfMo2YdJVUnptVrMbZeXu9tNnP0PF0rbW41bxaOyrKNRkV1qkICZP6HsgLHOepy/9rdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731649382; c=relaxed/simple;
	bh=psd79CktBVvNz5cRmc0prFkxRYlqdjtN5VrS32XoZd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oitVaxDjLhm0FfvfexnjcJjLNm06tiXZecRbAe2/Eknww88+mSs5uYe6N3abuABmNSNgnmzEZFCRWxAnViyCiOUGM6GthyFojT7W3KiEPK4zUEH77K4mPDM2SCZCo6RgAkTg06B/BjYknwtX0A1qbOT2GlFpIzjYJkGhfGqKE9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ekleskzs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ekleskzs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731649379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AjdVIfuH7TOXOVQnaaki3TYwfiPZMvjKxLeVf16wA8Q=;
	b=Ekleskzspk/wMh1PgiHT/VH6p0iVSNZ32buUv9U1agcl9TlRaEpmO1o1GOF4F46270wXq7
	ALULTtj8iSQO2PjUDMHMjmypcylG+zXYgd9XQyEMGsnOGDLXaXckPNfJdukvBytc39oeos
	y8ejucp46jJC4x61uc8OqO4CVP5yGv8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-_yW9CbOxPnyaevhG1jX38Q-1; Fri, 15 Nov 2024 00:42:57 -0500
X-MC-Unique: _yW9CbOxPnyaevhG1jX38Q-1
X-Mimecast-MFC-AGG-ID: _yW9CbOxPnyaevhG1jX38Q
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ea050e557dso1636935a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 21:42:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731649376; x=1732254176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AjdVIfuH7TOXOVQnaaki3TYwfiPZMvjKxLeVf16wA8Q=;
        b=vI8xgyH/DmoPEyfYnOTZTLS0ytSF5P54wu8XjJNWb3H23UQWdsaabdom/4xDhBeVZr
         luwx5KjlqyRHf4Bot36rArH1LILtRbDVnjTW8t7kDguedhhzXR79b1TlvugCl2g4CxwH
         nYFPxVoKtwMWfXMsInyKq/nH0O6AWbS60hEvWkvF4LXB9HRg7vz+J6TIAYnX3x4oor2V
         usAG9r8A3NqeEharKm4jtCr1jXPQtQzjh1pv2sggwLuNyz2UuUCW7pWFA6npM6+AdMIw
         TN2gY5zDzXHZdzQQdNjhb576rIgzbO70RD0NBG5dOWQSXrUFON2g5cqs2NFD/4T/ckvx
         91KQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKDHsp8dmEtcMlW1zg8QlFXZjFv1UlnFzKuYxqz9CErSo3u1ukrrIDmQ/0gyzlMIj5qiCW1REhGP4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7iG+yFrG3rHFVo4SOTiS+/e4nwlX20G47nzB/dAsFVDs1TteG
	NS29+YUZy2oIGO/Wg+y9M2KJLvKYk3DxsbujUUIhH8csbM5eC7STgp++5lOwRVLFlmwGojSYNFG
	N1lyzpCWER67g2efb4ZrAzGANXYK4ko1sxc54Y/csJA0uiGyZ4xou+t4QkSyUr/rBFXsQ
X-Received: by 2002:a17:90b:17c2:b0:2e2:d74f:65b6 with SMTP id 98e67ed59e1d1-2ea154f3f7amr2023001a91.10.1731649376027;
        Thu, 14 Nov 2024 21:42:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqEh62Hc2rbhox2WCNiW3VHGYhH+LKQA8Hasq4O+w6vgdwRuFTozmKPzPGHcmOeYGPdY+kWA==
X-Received: by 2002:a17:90b:17c2:b0:2e2:d74f:65b6 with SMTP id 98e67ed59e1d1-2ea154f3f7amr2022981a91.10.1731649375432;
        Thu, 14 Nov 2024 21:42:55 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ea02495b26sm2159289a91.21.2024.11.14.21.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 21:42:55 -0800 (PST)
Date: Fri, 15 Nov 2024 13:42:51 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] generic/757: fix various bugs in this test
Message-ID: <20241115054251.azrrmicopowrlqaa@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
 <173146178859.156441.16666438727834100554.stgit@frogsfrogsfrogs>
 <20241114052328.rnm54xeqxnvkaluc@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241114053019.GM9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114053019.GM9438@frogsfrogsfrogs>

On Wed, Nov 13, 2024 at 09:30:19PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 14, 2024 at 01:23:28PM +0800, Zorro Lang wrote:
> > On Tue, Nov 12, 2024 at 05:37:29PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Fix this test so the check doesn't fail on XFS, and restrict runtime to
> > > 100 loops because otherwise this test takes many hours.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/757 |    7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/tests/generic/757 b/tests/generic/757
> > > index 0ff5a8ac00182b..9d41975bde07bb 100755
> > > --- a/tests/generic/757
> > > +++ b/tests/generic/757
> > > @@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
> > >  cur=$(_log_writes_find_next_fua $prev)
> > >  [ -z "$cur" ] && _fail "failed to locate next FUA write"
> > >  
> > > -while [ ! -z "$cur" ]; do
> > > +for ((i = 0; i < 100; i++)); do
> > >  	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
> > >  
> > > +	# xfs_repair won't run if the log is dirty
> > > +	if [ $FSTYP = "xfs" ]; then
> > > +		_scratch_mount
> > 
> > Hi Darrick, can you mount at here? I always get mount error as below:
> > 
> > SECTION       -- default
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 dell-per750-41 6.12.0-0.rc5.44.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Oct 28 14:12:55 UTC 2024
> > MKFS_OPTIONS  -- -f /dev/sda6
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch
> > 
> > generic/757 2185s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//default/generic/757.out.bad)
> >     --- tests/generic/757.out   2024-10-27 03:09:48.740518275 +0800
> >     +++ /root/git/xfstests/results//default/generic/757.out.bad 2024-11-14 13:18:56.965210155 +0800
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
> > # dmesg
> > ...
> > [1258572.169378] XFS (sda6): Mounting V5 Filesystem a0bf3918-1b66-4973-b03c-afd5197a6d21
> > [1258572.193037] XFS (sda6): Starting recovery (logdev: internal)
> > [1258572.201691] XFS (sda6): Corruption warning: Metadata has LSN (1:41116) ahead of current LSN (1:161). Please unmount and run xfs_repair (>= v4.3) to resolve.
> > [1258572.215850] XFS (sda6): Metadata CRC error detected at xfs_bmbt_read_verify+0x16/0xc0 [xfs], xfs_bmbt block 0x2000e8 
> > [1258572.226825] XFS (sda6): Unmount and run xfs_repair
> > [1258572.231796] XFS (sda6): First 128 bytes of corrupted metadata buffer:
> > [1258572.238411] 00000000: 42 4d 41 33 00 00 00 fb 00 00 00 00 00 04 00 9e  BMA3............
> > [1258572.246585] 00000010: 00 00 00 00 00 04 00 60 00 00 00 00 00 20 00 e8  .......`..... ..
> > [1258572.254766] 00000020: 00 00 00 01 00 00 a0 9c a0 bf 39 18 1b 66 49 73  ..........9..fIs
> > [1258572.262945] 00000030: b0 3c af d5 19 7a 6d 21 00 00 00 00 00 00 00 83  .<...zm!........
> > [1258572.271117] 00000040: 17 2f 1b e4 00 00 00 00 00 00 00 00 04 b1 2e 00  ./..............
> > [1258572.279291] 00000050: 00 00 00 4b 15 e0 00 01 80 00 00 00 04 b1 30 00  ...K..........0.
> > [1258572.287462] 00000060: 00 00 00 4b 16 00 00 4f 00 00 00 00 04 b1 ce 00  ...K...O........
> > [1258572.295635] 00000070: 00 00 00 4b 1f e0 00 01 80 00 00 00 04 b1 d0 00  ...K............
> > [1258572.303811] XFS (sda6): Filesystem has been shut down due to log error (0x2).
> > [1258572.311123] XFS (sda6): Please unmount the filesystem and rectify the problem(s).
> > [1258572.318791] XFS (sda6): log mount/recovery failed: error -74
> > [1258572.324798] XFS (sda6): log mount failed
> > [1258572.365169] XFS (sda5): Unmounting Filesystem eb4b7840-2c01-4306-9a6c-af2e7207a23f
> 
> I see periodic corruption messages, but generally the mount succeeds and
> the test passes, even with TOT -rc6.

Still fails on -rc7+ [1]. Even with `xfs_repair $SCRATCH_DEV` before mount, it still fails [2].
But `xfs_repair -L` helps, the test can keep running after that.

Do you think it's a xfs issue, or a case issue (xfs need a log cleanup at here?).

Thanks,
Zorro

[1]
# ./check -s default generic/757
SECTION       -- default
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 dell-per750-41 6.12.0-0.rc7.58.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Nov 11 15:23:45 UTC 2024
MKFS_OPTIONS  -- -f /dev/sda6
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch

generic/757 2185s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//default/generic/757.out.bad)
    --- tests/generic/757.out   2024-10-27 03:09:48.740518275 +0800
    +++ /root/git/xfstests/results//default/generic/757.out.bad 2024-11-15 03:06:59.462739215 +0800
    @@ -1,2 +1,5 @@
     QA output created by 757
    -Silence is golden
    +mount: /mnt/scratch: cannot mount; probably corrupted filesystem on /dev/sda6.
    +       dmesg(1) may have more information after failed mount system call.
    +mount -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch failed
    +(see /root/git/xfstests/results//default/generic/757.full for details)
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/757.out /root/git/xfstests/results//default/generic/757.out.bad'  to see the entire diff)
Ran: generic/757
Failures: generic/757
Failed 1 of 1 tests

[2]
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

> 
> --D
> 
> > > +		_scratch_unmount
> > > +	fi
> > 
> > 
> > >  	_check_scratch_fs
> > >  
> > >  	prev=$cur
> > > 
> > 
> > 
> 

