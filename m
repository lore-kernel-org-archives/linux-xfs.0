Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8E9378D94;
	Wed, 29 Apr 2026 15:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777478294; cv=none; b=UVjzMWTTzxv6oMib5T0YWohGZPWNBSFhRXqRXEHGojwj1mSR0we/OzOINBL7M3jomYIaH8ah+yjuxH8M+21KywhZXo1QplBp4/B0121PF6j7EvflIP+Oax2ch72Fd7D7wkPDiFNLVpBOk1meuu1PFAeZgr/2z6aoPsQbr6RAaI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777478294; c=relaxed/simple;
	bh=KsPVkbPTQvZIiITBc96uAYQ++oG/gAhe9Qiffk/P85Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZ1buBuhaOUxGwU5o1S6uwQQ8MUSf/GE0iwuJYkQI7Opueb01JOjXO9hqUksH5ZSKANR+KaABT67xxISGG6KjSJ5FAdRuqTzaiQuKjMjbt4F5YR1m6NbRmsldvLn8hGfj3BLald2voj5JilM4+Mo0H0gQNy4GvL0ruekdOefQlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMAoj6Mq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMAoj6Mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC226C19425;
	Wed, 29 Apr 2026 15:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777478293;
	bh=KsPVkbPTQvZIiITBc96uAYQ++oG/gAhe9Qiffk/P85Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aMAoj6Mqk3ZG5lbBajvPAKetVT0ONLYQMou++2W3WY4dgnSaOFB4SnyhRmOO3124t
	 O3MOWCw6/L8tqcik2gUmkW1WjGSPW4N2V2I08HFymF3W6EDcJxNWLQmnMc0a203ASJ
	 Z6IKi6GnQiDAWEVuq/DwAcSVG9zj3o0ir2PfhE+ykJwU8qT9IG+EXq53GVo+x0Jw10
	 SyGqlT64alXKAt0+57OF70Z86EmPKmRqb82uHYbpNGIOt7Y1FELpxZ++aSayW0sqah
	 k9/i1YLqeqJXaH6UGpwVpTXYSl0fw77TtDD3xr03n3W2jjGJhTFZ4TnSPjKWODM9bs
	 4tnwa73lQgVcQ==
Date: Wed, 29 Apr 2026 08:58:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, hch@lst.de
Subject: Re: [bug report] xfs/806 sporadic failure
Message-ID: <20260429155813.GD7751@frogsfrogsfrogs>
References: <ae7-c9s0KVBRsSy3@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae7-c9s0KVBRsSy3@shinmob>

On Mon, Apr 27, 2026 at 03:16:44PM +0900, Shin'ichiro Kawasaki wrote:
> Hello Darrick and all,
> 
> Recently, I observed a sporadic failure of xfs/806. If does not fail always,
> but fails in steady manner in the last a few months. I would like to ask if
> anyone has any insights about the failure.
> 
> I started observing that failure in February. It was observed with various test
> target devices, zoned/non-zoned, null_blk/tcmu/HDD. The failure was not
> recreated easiliy. Recently, I found that I can recreate the failure in stable
> manner using dm-crypt on my SMR HDDs and by repeating the test cases from
> xfs/803 to xfs/806.
> 
>    The failure can be recrated by running xfs/806 many times (> 200 times), but
>    it looks recreated sooner by repeating xfs/803 to xfs/806.
> 
> The failure is observed with recent xfs/for-next branch.
> 
> On falure, the fstests console looks like this:
> ------------------------------------------------------------------------------
> xfs/803      12s ...  12s
> xfs/804      12s ...  12s
> xfs/805      9s ...  9s
> xfs/806      13s ... - output mismatch (see /home/kts/kernel-test-suite/src/xfstests/results//xfs/806.out.bad)
>     --- tests/xfs/806.out       2026-03-26 22:40:32.089917897 +0900
>     +++ /home/kts/kernel-test-suite/src/xfstests/results//xfs/806.out.bad       2026-04-27 09:21:27.164750487 +0900
>     @@ -1,6 +1,7 @@
>      QA output created by 806
>      Info: TEST_DIR/806.mount: Checking and repairing per autofsck directive.
>     -Info: TEST_DIR/806.mount: Disabling scrub per autofsck directive.
>     +mount: /var/kts/test/806.mount: /var/kts/test/806.somefile is already mounted.

Huh.  It's very strange that the fs is still mounted, yet the unmount
didn't print anything about that.

>     +Info: TEST_DIR/806.mount: Checking and repairing per autofsck directive.
>      Info: TEST_DIR/806.mount: Checking per autofsck directive.
>      Info: TEST_DIR/806.mount: Optimizing per autofsck directive.
>     ...
>     (Run 'diff -u /home/kts/kernel-test-suite/src/xfstests/tests/xfs/806.out /home/kts/kernel-test-suite/src/xfstests/results//xfs/806.out.bad'  to see the entire diff)
> Ran: xfs/803 xfs/804 xfs/805 xfs/806
> Failures: xfs/806
> ------------------------------------------------------------------------------
> 
> As you can see, the mount command fails with the "/var/kts/test/806.somefile is
> already mounted." message. The test case does mount multiple times. The step of
> mount failure is not always same, but the failure message is same always.
> 
> Dmesg does not leave anything looks suspecious to me [1].
> 
> FYI, here I share the steps I use to recreate the failure. I use a QEMU test
> node with Fedora 43. SMR HDDs are exposed to the QEMU VM via PCI passthrough.

Fedora 43, so xfsprogs isn't new enough to have xfs_healer.

>   # Set up dm-crypt on two SMR HDDs, /dev/sdc and /dev/sdd. Offset and size are
>   # chosen to have 16 conventional zones and 144 sequential write required zones.
>   $ sudo dd if=/dev/random of=/tmp/keyfile bs=1 count=256
>   $ sudo cryptsetup open --batch-mode --type plain --cipher aes-cbc-essiv:sha256 --key-size 256 --key-file /tmp/keyfile --offset 382730240 --size 83886080 /dev/sdc test1  
>   $ sudo cryptsetup open --batch-mode --type plain --cipher aes-cbc-essiv:sha256 --key-size 256 --key-file /tmp/keyfile --offset 382730240 --size 83886080 /dev/sdd test2
> 
>   # prepare local.config
>   $ cat ./local.config
>   export TEST_DIR=/var/kts/test
>   export TEST_DEV="/dev/mapper/test1"
>   export KEEP_DMESG=yes
>   export FSTYP=xfs
>   export MKFS_OPTIONS=""
>   export SCRATCH_MNT=/var/kts/scratch
>   export SCRATCH_DEV="/dev/mapper/test2"
>   export FSX_AVOID=-a
> 
>   # format TEST_DEV
>   $ sudo mkfs.xfs /dev/mapper/test1
> 
>   # repeat test cases from xfs/803 to xfs/806 200 times.
>   $ for ((i=0;i<200;i++)); do echo $i; if ! sudo ./check xfs/803 xfs/804 xfs/805 xfs/806; then break; fi; done
> 
> With the steps, the failures is recreated at 20th repeat at earliest, or 120th
> repeat when it takes longer.
> 
> Using this environment, I did quick printk debug, and found that do_umount()
> in fs/namespace.c returns -EBUSY on failure case. But I'm not sure why it
> happens.
> 
> Quote from fs/namespace.c:
> ------------------------------------------------------------------------------
>         event++;
>         if (flags & MNT_DETACH) {
>                 umount_tree(mnt, UMOUNT_PROPAGATE);
>                 retval = 0;
>         } else {
>                 smp_mb(); // paired with __legitimize_mnt()
>                 shrink_submounts(mnt);
>                 retval = -EBUSY;   <===================================== here
>                 if (!propagate_mount_busy(mnt, 2)) {
>                         umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
>                         retval = 0;
>                 }
>         }
> ------------------------------------------------------------------------------
> 
> Any advice will be welcomed. If I can do anything in my test environment,
> please let me know.

Hrmm.  Let me try this case (loop image on test fs on dmcrypted smr hdd)
in the lab when I'm back from travelling tomorrow.  I wonder if there's
some sort of delay in unmounting, though nothing stands out immediately.

--D

> 
>   System maintenance is planned for my test machines in the first week of May.
>   So, my action on my test environment may take some time.
> 
> 
> [1] dmesg
> 
> [ 1966.727914] [ T137522] run fstests xfs/803 at 2026-04-27 13:47:54
> [ 1972.747786] [ T138553] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1973.406021] [ T138576] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
> [ 1973.419142] [ T138576] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1973.568485] [ T138576] XFS (dm-0): Ending clean mount
> [ 1973.570947] [ T138576] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
> [ 1973.577722] [ T138576] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
> [ 1973.937017] [ T138621] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1975.775968] [ T137522] run fstests xfs/804 at 2026-04-27 13:48:03
> [ 1977.795592] [ T139088] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
> [ 1977.807396] [ T139088] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1977.922463] [ T139088] XFS (dm-0): Ending clean mount
> [ 1977.925319] [ T139088] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
> [ 1977.932679] [ T139088] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
> [ 1978.971340] [ T139191] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1980.413770] [ T139283] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
> [ 1980.426461] [ T139283] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1980.550420] [ T139283] XFS (dm-0): Ending clean mount
> [ 1980.552682] [ T139283] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
> [ 1980.558805] [ T139283] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
> [ 1983.784203] [ T139478] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1984.571368] [ T139670] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
> [ 1984.582316] [ T139670] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1984.698207] [ T139670] XFS (dm-0): Ending clean mount
> [ 1984.700759] [ T139670] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
> [ 1984.708996] [ T139670] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
> [ 1985.237069] [ T137522] run fstests xfs/805 at 2026-04-27 13:48:13
> [ 1991.545779] [ T140080] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1992.390589] [ T140272] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
> [ 1992.400273] [ T140272] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 1992.510456] [ T140272] XFS (dm-0): Ending clean mount
> [ 1992.513019] [ T140272] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
> [ 1992.519907] [ T140272] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
> [ 1993.060516] [ T137522] run fstests xfs/806 at 2026-04-27 13:48:21
> [ 1996.241717] [ T140594] loop0: detected capacity change from 0 to 20971520
> [ 1996.286338] [ T140594] XFS (loop0): Mounting V5 Filesystem cdb36045-8330-48c7-b1a4-82c5d7ed21e1
> [ 1996.308568] [ T140594] XFS (loop0): Ending clean mount
> [ 1996.388493] [ T140613] XFS (loop0): Unmounting Filesystem cdb36045-8330-48c7-b1a4-82c5d7ed21e1
> [ 1996.599702] [ T140615] loop0: detected capacity change from 0 to 20971520
> [ 1996.638831] [ T140615] XFS (loop0): Mounting V5 Filesystem 3218c7d6-c4a4-4f5a-b9bc-c1ba7ada7e6d
> [ 1996.661288] [ T140615] XFS (loop0): Ending clean mount
> [ 1996.727650] [ T140630] XFS (loop0): Unmounting Filesystem 3218c7d6-c4a4-4f5a-b9bc-c1ba7ada7e6d
> [ 1996.927360] [ T140632] loop0: detected capacity change from 0 to 20971520
> [ 1996.965520] [ T140632] XFS (loop0): Mounting V5 Filesystem 15db07f7-722e-401e-8f22-856ceeedeed6
> [ 1996.983714] [ T140632] XFS (loop0): Ending clean mount
> [ 1997.058905] [ T140651] XFS (loop0): Unmounting Filesystem 15db07f7-722e-401e-8f22-856ceeedeed6
> [ 1997.256820] [ T140653] loop0: detected capacity change from 0 to 20971520
> [ 1997.294703] [ T140653] XFS (loop0): Mounting V5 Filesystem 98713c32-802b-4179-8ec6-fcc89968b76e
> [ 1997.312428] [ T140653] XFS (loop0): Ending clean mount
> [ 1997.385745] [ T140672] XFS (loop0): Unmounting Filesystem 98713c32-802b-4179-8ec6-fcc89968b76e
> [ 1997.574544] [ T140674] loop0: detected capacity change from 0 to 20971520
> [ 1997.616104] [ T140674] XFS (loop0): Mounting V5 Filesystem 45368b30-8413-48b4-becc-4e787f833e42
> [ 1997.638100] [ T140674] XFS (loop0): Ending clean mount
> [ 1997.916462] [ T140706] XFS (loop0): Unmounting Filesystem 45368b30-8413-48b4-becc-4e787f833e42
> [ 1998.076829] [ T140708] loop0: detected capacity change from 0 to 20971520
> [ 1998.113814] [ T140708] XFS (loop0): Mounting V5 Filesystem 2f115ed5-8d6d-4a03-97fb-4b2215947ec6
> [ 1998.132609] [ T140708] XFS (loop0): Ending clean mount
> [ 1998.225237] [ T140727] XFS (loop0): Unmounting Filesystem 2f115ed5-8d6d-4a03-97fb-4b2215947ec6
> [ 2000.147618] [ T140793] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 2001.085155] [ T140984] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
> [ 2001.094211] [ T140984] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> [ 2001.212889] [ T140984] XFS (dm-0): Ending clean mount
> [ 2001.215370] [ T140984] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
> [ 2001.221959] [ T140984] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
> [ 2001.680831] [ T141027] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
> 
