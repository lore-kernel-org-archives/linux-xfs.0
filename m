Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD3EC001E0
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Oct 2023 04:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjJWEqv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 00:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjJWEqv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 00:46:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C583D52;
        Sun, 22 Oct 2023 21:46:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9DBC433C8;
        Mon, 23 Oct 2023 04:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698036408;
        bh=3tpEaovGrmNIgrXljEbjRcuzZ6GNx4xTynhxj4BHZZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gY4mPMZ3pajtqKMoZ+0PzCWUzcOaJWmmAhrkn7HHlng88kRhYm1NqKdu553dCQStr
         OdBOpzQrK0qGUsJriIF1HxocSqve65RniM8aJldSnF/rb9mpx3lYgFV6oF/PY3r+Yz
         VEy4OY1qtuq96j3aAYu2iP0f32nYlo/pDS6ObhYodiuexJlHsajoDM13dXyAfgee8e
         SUxCQlSLdROJtFY+MmzJ4Phs0vjhN6L7YiiCGObGnAFAGsLutmP1f4+AC/rctWmKhZ
         PzNoLJvVFAF380I9XFEXw7Sn2RlfGD/Brr9tfdbJAbKNHblcgJtnVtm3+Kcmymm/iS
         ZCx4eegvwqfuA==
Date:   Sun, 22 Oct 2023 21:46:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] generic/251: check min and max length and minlen for
 FSTRIM
Message-ID: <20231023044647.GE11391@frogsfrogsfrogs>
References: <20231019143627.GD11391@frogsfrogsfrogs>
 <20231021131448.jjayss67pq5ztjdy@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20231021230024.GT3195650@frogsfrogsfrogs>
 <20231022061834.2km47c7vmhp5uen2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231022061834.2km47c7vmhp5uen2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 22, 2023 at 02:18:34PM +0800, Zorro Lang wrote:
> On Sat, Oct 21, 2023 at 04:00:24PM -0700, Darrick J. Wong wrote:
> > On Sat, Oct 21, 2023 at 09:14:48PM +0800, Zorro Lang wrote:
> > > On Thu, Oct 19, 2023 at 07:36:27AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Every now and then, this test fails with the following output when
> > > > running against my development tree when configured with an 8k fs block
> > > > size:
> > > > 
> > > > --- a/tests/generic/251.out	2023-07-11 12:18:21.624971186 -0700
> > > > +++ b/tests/generic/251.out.bad	2023-10-15 20:54:44.636000000 -0700
> > > > @@ -1,2 +1,4677 @@
> > > >  QA output created by 251
> > > >  Running the test: done.
> > > > +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> > > > +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> > > > ...
> > > > +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> > > > 
> > > > Dumping the exact fstrim command lines to seqres.full produces this at
> > > > the end:
> > > > 
> > > > /usr/sbin/fstrim -m 32544k -o 30247k -l 4k /opt
> > > > /usr/sbin/fstrim -m 32544k -o 30251k -l 4k /opt
> > > > ...
> > > > /usr/sbin/fstrim -m 32544k -o 30255k -l 4k /opt
> > > > 
> > > > The count of failure messages is the same as the count as the "-l 4k"
> > > > fstrim invocations.  Since this is an 8k-block filesystem, the -l
> > > > parameter is clearly incorrect.  The test computes random -m and -l
> > > > options.
> > > > 
> > > > Therefore, create helper functions to guess at the minimum and maximum
> > > > length and minlen parameters that can be used with the fstrim program.
> > > > In the inner loop of the test, make sure that our choices for -m and -l
> > > > fall within those constraints.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > 
> > > Hi Darrick, with this patch I 100% hit below failure (on default 4k xfs
> > > and ext4):
> > > 
> > > # ./check generic/251
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> > > MKFS_OPTIONS  -- -f /dev/loop0
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch
> > > 
> > > generic/251 260s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/251.out.bad)
> > >     --- tests/generic/251.out   2022-04-29 23:07:23.263498297 +0800
> > >     +++ /root/git/xfstests/results//generic/251.out.bad 2023-10-21 21:02:37.687088360 +0800
> > >     @@ -1,2 +1,5 @@
> > >      QA output created by 251
> > >      Running the test: done.
> > >     +5834a5835
> > >     +> aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
> > >     +!!!Checksums has changed - Filesystem possibly corrupted!!!\n
> > >     ...
> > >     (Run 'diff -u /root/git/xfstests/tests/generic/251.out /root/git/xfstests/results//generic/251.out.bad'  to see the entire diff)
> > 
> > Huh.  I don't see that on ext4 on my machine.  Can you send me all your
> 
> The failure on ext4:
> 
> # ./check generic/251
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> MKFS_OPTIONS  -- -F /dev/loop0
> MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch
> 
> generic/251 249s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/251.out.bad)
>     --- tests/generic/251.out   2022-04-29 23:07:23.263498297 +0800
>     +++ /root/git/xfstests/results//generic/251.out.bad 2023-10-22 14:17:07.248059405 +0800
>     @@ -1,2 +1,5 @@
>      QA output created by 251
>      Running the test: done.
>     +5838a5839
>     +> aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
>     +!!!Checksums has changed - Filesystem possibly corrupted!!!\n
>     ...
>     (Run 'diff -u /root/git/xfstests/tests/generic/251.out /root/git/xfstests/results//generic/251.out.bad'  to see the entire diff)
> Ran: generic/251
> Failures: generic/251
> Failed 1 of 1 tests
> 
> > /root/git/xfstests/results//generic/251* files so that I can have a
> > look?
> 
> Sure, thanks! There're .full and .out.bad files:
> 
> # cat results/generic/251.full 
> MINLEN max=100000 min=2
> LENGTH max=100000 min=4
> # cat results/generic/251.out.bad 
> QA output created by 251
> Running the test: done.
> 5833a5834
> > aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
> !!!Checksums has changed - Filesystem possibly corrupted!!!\n
> 
> The SCRATCH_DEV is loop0, its info as below:
> # xfs_info /dev/loop0
> meta-data=/dev/loop0             isize=512    agcount=4, agsize=720896 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=2883584, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Huh.  What filesystem contains the file that /dev/loop0 points to?

--D

> More other information:
> # rpm -qf /usr/sbin/fstrim
> util-linux-2.39.2-1.fc40.x86_64
> # uname -r
> 6.6.0-rc6-mainline+
> # rpm -q xfsprogs
> xfsprogs-6.4.0-1.fc39.x86_64
> 
> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Ran: generic/251
> > > Failures: generic/251
> > > Failed 1 of 1 tests
> > > 
> > > And test passed without this patch.
> > > 
> > > # ./check generic/251
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> > > MKFS_OPTIONS  -- -f /dev/loop0
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch
> > > 
> > > generic/251 260s ...  249s
> > > Ran: generic/251
> > > Passed all 1 tests
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > >  tests/generic/251 |   59 ++++++++++++++++++++++++++++++++++++++++++++++-------
> > > >  1 file changed, 51 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/tests/generic/251 b/tests/generic/251
> > > > index 8ee74980cc..40cfd7c381 100755
> > > > --- a/tests/generic/251
> > > > +++ b/tests/generic/251
> > > > @@ -53,14 +53,46 @@ _fail()
> > > >  	kill $mypid 2> /dev/null
> > > >  }
> > > >  
> > > > -_guess_max_minlen()
> > > > +# Set FSTRIM_{MIN,MAX}_MINLEN to the lower and upper bounds of the -m(inlen)
> > > > +# parameter to fstrim on the scratch filesystem.
> > > > +set_minlen_constraints()
> > > >  {
> > > > -	mmlen=100000
> > > > -	while [ $mmlen -gt 1 ]; do
> > > > +	local mmlen
> > > > +
> > > > +	for ((mmlen = 100000; mmlen > 0; mmlen /= 2)); do
> > > >  		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> > > > -		mmlen=$(($mmlen/2))
> > > >  	done
> > > > -	echo $mmlen
> > > > +	test $mmlen -gt 0 || \
> > > > +		_notrun "could not determine maximum FSTRIM minlen param"
> > > > +	FSTRIM_MAX_MINLEN=$mmlen
> > > > +
> > > > +	for ((mmlen = 1; mmlen < FSTRIM_MAX_MINLEN; mmlen *= 2)); do
> > > > +		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> > > > +	done
> > > > +	test $mmlen -le $FSTRIM_MAX_MINLEN || \
> > > > +		_notrun "could not determine minimum FSTRIM minlen param"
> > > > +	FSTRIM_MIN_MINLEN=$mmlen
> > > > +}
> > > > +
> > > > +# Set FSTRIM_{MIN,MAX}_LEN to the lower and upper bounds of the -l(ength)
> > > > +# parameter to fstrim on the scratch filesystem.
> > > > +set_length_constraints()
> > > > +{
> > > > +	local mmlen
> > > > +
> > > > +	for ((mmlen = 100000; mmlen > 0; mmlen /= 2)); do
> > > > +		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> > > > +	done
> > > > +	test $mmlen -gt 0 || \
> > > > +		_notrun "could not determine maximum FSTRIM length param"
> > > > +	FSTRIM_MAX_LEN=$mmlen
> > > > +
> > > > +	for ((mmlen = 1; mmlen < FSTRIM_MAX_LEN; mmlen *= 2)); do
> > > > +		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> > > > +	done
> > > > +	test $mmlen -le $FSTRIM_MAX_LEN || \
> > > > +		_notrun "could not determine minimum FSTRIM length param"
> > > > +	FSTRIM_MIN_LEN=$mmlen
> > > >  }
> > > >  
> > > >  ##
> > > > @@ -70,13 +102,24 @@ _guess_max_minlen()
> > > >  ##
> > > >  fstrim_loop()
> > > >  {
> > > > +	set_minlen_constraints
> > > > +	set_length_constraints
> > > > +	echo "MINLEN max=$FSTRIM_MAX_MINLEN min=$FSTRIM_MIN_MINLEN" >> $seqres.full
> > > > +	echo "LENGTH max=$FSTRIM_MAX_LEN min=$FSTRIM_MIN_LEN" >> $seqres.full
> > > > +
> > > >  	trap "_destroy_fstrim; exit \$status" 2 15
> > > >  	fsize=$(_discard_max_offset_kb "$SCRATCH_MNT" "$SCRATCH_DEV")
> > > > -	mmlen=$(_guess_max_minlen)
> > > >  
> > > >  	while true ; do
> > > > -		step=$((RANDOM*$RANDOM+4))
> > > > -		minlen=$(((RANDOM*($RANDOM%2+1))%$mmlen))
> > > > +		while true; do
> > > > +			step=$((RANDOM*$RANDOM+4))
> > > > +			test "$step" -ge "$FSTRIM_MIN_LEN" && break
> > > > +		done
> > > > +		while true; do
> > > > +			minlen=$(( (RANDOM * (RANDOM % 2 + 1)) % FSTRIM_MAX_MINLEN ))
> > > > +			test "$minlen" -ge "$FSTRIM_MIN_MINLEN" && break
> > > > +		done
> > > > +
> > > >  		start=$RANDOM
> > > >  		if [ $((RANDOM%10)) -gt 7 ]; then
> > > >  			$FSTRIM_PROG $SCRATCH_MNT &
> > > > 
> > > 
> > 
> 
