Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F1915575D;
	Thu, 14 Nov 2024 05:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731562221; cv=none; b=OcAtxeIwjYyJri6X8BHi229CbfY4lw711sPiIAga9EKeemnd3PKOJ/bIMvKqdiiW1/NJyqsYOszxG3pvailft5tPnDMjAIPqAwzlWtDkiDOkWUdDI0kA15RP0h18hRMW/ALQ+ffa8oU8IUcGnwnqhOFTmXOnbohE+J2BKv47NMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731562221; c=relaxed/simple;
	bh=ng4+N57HWcDv6JVL1KnJomhQayM5TciGWgjaHaW3NZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0RuqlPofLLzyPb+CvpXMsdWUIsVVvc7Xbb61Xfw75L3ETEDIwPK9I+FasLY0W/sXGKEniEyVo0sVTd0UaELtnsAJT0cuADLOFGhgZTWw1VZ3YtiS+U/Lo+Wa/9AXKuYkjlBU1t6/tmhADGn3yxZML/e9wSmD56WV/CaHvjeDdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yc3E3TCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yc3E3TCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9221CC4CED0;
	Thu, 14 Nov 2024 05:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731562220;
	bh=ng4+N57HWcDv6JVL1KnJomhQayM5TciGWgjaHaW3NZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yc3E3TCpvooy5QFeiVgZMTMdIJQAOE/UXWt/JRD+Ruf9XCRThomrjzDPnoBcd2Y7B
	 Mu8XQt2vqcfnDs3pPFESEm+iikr7aafEvPi7farzzU1tHPvqnVWDZB0ylbhhkluuDh
	 CSyA3HEStOim8SyB8Y+M6vLD3E4CJ0SDpzMXzMFwyJ/gyMILQzxG/vJBOhkhsfvipr
	 mBexJiVqGzVm1t47Np0m6BgIUXroa0qLmUOBeQtjuBYUmEcw01pZbd75CPqf6uHViN
	 dIMZy/yzkAL083qGdTXAn8cKzGiv5vB/VDQ+y7Yd2gVQbIc/WUeI8IwdrrVTBRA0C+
	 svJGpz6qUim2w==
Date: Wed, 13 Nov 2024 21:30:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] generic/757: fix various bugs in this test
Message-ID: <20241114053019.GM9438@frogsfrogsfrogs>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
 <173146178859.156441.16666438727834100554.stgit@frogsfrogsfrogs>
 <20241114052328.rnm54xeqxnvkaluc@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114052328.rnm54xeqxnvkaluc@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Nov 14, 2024 at 01:23:28PM +0800, Zorro Lang wrote:
> On Tue, Nov 12, 2024 at 05:37:29PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix this test so the check doesn't fail on XFS, and restrict runtime to
> > 100 loops because otherwise this test takes many hours.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/757 |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/generic/757 b/tests/generic/757
> > index 0ff5a8ac00182b..9d41975bde07bb 100755
> > --- a/tests/generic/757
> > +++ b/tests/generic/757
> > @@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
> >  cur=$(_log_writes_find_next_fua $prev)
> >  [ -z "$cur" ] && _fail "failed to locate next FUA write"
> >  
> > -while [ ! -z "$cur" ]; do
> > +for ((i = 0; i < 100; i++)); do
> >  	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
> >  
> > +	# xfs_repair won't run if the log is dirty
> > +	if [ $FSTYP = "xfs" ]; then
> > +		_scratch_mount
> 
> Hi Darrick, can you mount at here? I always get mount error as below:
> 
> SECTION       -- default
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 dell-per750-41 6.12.0-0.rc5.44.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Oct 28 14:12:55 UTC 2024
> MKFS_OPTIONS  -- -f /dev/sda6
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch
> 
> generic/757 2185s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//default/generic/757.out.bad)
>     --- tests/generic/757.out   2024-10-27 03:09:48.740518275 +0800
>     +++ /root/git/xfstests/results//default/generic/757.out.bad 2024-11-14 13:18:56.965210155 +0800
>     @@ -1,2 +1,5 @@
>      QA output created by 757
>     -Silence is golden
>     +mount: /mnt/scratch: cannot mount; probably corrupted filesystem on /dev/sda6.
>     +       dmesg(1) may have more information after failed mount system call.
>     +mount -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch failed
>     +(see /root/git/xfstests/results//default/generic/757.full for details)
>     ...
>     (Run 'diff -u /root/git/xfstests/tests/generic/757.out /root/git/xfstests/results//default/generic/757.out.bad'  to see the entire diff)
> Ran: generic/757
> Failures: generic/757
> Failed 1 of 1 tests
> 
> # dmesg
> ...
> [1258572.169378] XFS (sda6): Mounting V5 Filesystem a0bf3918-1b66-4973-b03c-afd5197a6d21
> [1258572.193037] XFS (sda6): Starting recovery (logdev: internal)
> [1258572.201691] XFS (sda6): Corruption warning: Metadata has LSN (1:41116) ahead of current LSN (1:161). Please unmount and run xfs_repair (>= v4.3) to resolve.
> [1258572.215850] XFS (sda6): Metadata CRC error detected at xfs_bmbt_read_verify+0x16/0xc0 [xfs], xfs_bmbt block 0x2000e8 
> [1258572.226825] XFS (sda6): Unmount and run xfs_repair
> [1258572.231796] XFS (sda6): First 128 bytes of corrupted metadata buffer:
> [1258572.238411] 00000000: 42 4d 41 33 00 00 00 fb 00 00 00 00 00 04 00 9e  BMA3............
> [1258572.246585] 00000010: 00 00 00 00 00 04 00 60 00 00 00 00 00 20 00 e8  .......`..... ..
> [1258572.254766] 00000020: 00 00 00 01 00 00 a0 9c a0 bf 39 18 1b 66 49 73  ..........9..fIs
> [1258572.262945] 00000030: b0 3c af d5 19 7a 6d 21 00 00 00 00 00 00 00 83  .<...zm!........
> [1258572.271117] 00000040: 17 2f 1b e4 00 00 00 00 00 00 00 00 04 b1 2e 00  ./..............
> [1258572.279291] 00000050: 00 00 00 4b 15 e0 00 01 80 00 00 00 04 b1 30 00  ...K..........0.
> [1258572.287462] 00000060: 00 00 00 4b 16 00 00 4f 00 00 00 00 04 b1 ce 00  ...K...O........
> [1258572.295635] 00000070: 00 00 00 4b 1f e0 00 01 80 00 00 00 04 b1 d0 00  ...K............
> [1258572.303811] XFS (sda6): Filesystem has been shut down due to log error (0x2).
> [1258572.311123] XFS (sda6): Please unmount the filesystem and rectify the problem(s).
> [1258572.318791] XFS (sda6): log mount/recovery failed: error -74
> [1258572.324798] XFS (sda6): log mount failed
> [1258572.365169] XFS (sda5): Unmounting Filesystem eb4b7840-2c01-4306-9a6c-af2e7207a23f

I see periodic corruption messages, but generally the mount succeeds and
the test passes, even with TOT -rc6.

--D

> > +		_scratch_unmount
> > +	fi
> 
> 
> >  	_check_scratch_fs
> >  
> >  	prev=$cur
> > 
> 
> 
