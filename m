Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE6EC004C0
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Oct 2023 13:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjJUNPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Oct 2023 09:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjJUNPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Oct 2023 09:15:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A356D51
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2023 06:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697894095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=88kKvR/QvmUFQ2EQ4+M3EZF9rOsP4Vwrjwk+guy9Id4=;
        b=dWrdoHgBzg6TbI18Tea9Oci4lu/TPC5HCfbleZlfLTshh4vhA8fLwkj+AHKseiMD81EX+5
        rpQt0svGWrzgsIxUiqfsAG+U2gqlXzGJDpMbjkNQ5IJbYiZHn/GDr6GStjA6AEGnLFiDPF
        Kxjp75siqpgkN6363zBhPRqLIfD989U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-T_U24gu7PYStS0LVilA1Bg-1; Sat, 21 Oct 2023 09:14:54 -0400
X-MC-Unique: T_U24gu7PYStS0LVilA1Bg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-27d11401561so1504583a91.0
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2023 06:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697894093; x=1698498893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88kKvR/QvmUFQ2EQ4+M3EZF9rOsP4Vwrjwk+guy9Id4=;
        b=PKYsClB4U6n7yMBgNoNpniOuFVx9gNw4pHJf38H6TV+NwYjVnSWz4Vn3eQdBFfQnBe
         Qe6jvD8lzxg3078rZ6lDO3eObAGErOR4VfKE2JrwFp3gwTqpGR71AsPSPDIl/Vt1Eate
         k/R5ABvRCrDFhwYOyp2MvaZwoBObbF6oqOD0963BAROTatbmMCBTR2m4tnPenC78oXMv
         DclK/zTXTR9prQYI4JEh1IyGloPnBlxcgc9nd0dINVXFPTny1orb1f5yjoYMnyfTKfCq
         QNI2D2cvVFyM5yhpD7zZ3p1VjwLOL7H884OvqkCeMJM65Gdf7+lU5w1CfwTOLmu3wqQu
         W71A==
X-Gm-Message-State: AOJu0YxQerMhCq+o9GcMXHvjUldnKy1rVexrne+pkqQa6Jk9X2JTT/jO
        0S7tQQyiuXNT7EVmHPDYnMJS/1Ml+4BqxpKbf3aiuwDceJyQwF3EZrJ9/Vt7N4q356wnOJDYwpN
        vurvgE0lMTTo0rluI3fvDySvNz0qpsjs=
X-Received: by 2002:a05:6a20:3ca9:b0:12c:b10d:693d with SMTP id b41-20020a056a203ca900b0012cb10d693dmr4592597pzj.6.1697894092941;
        Sat, 21 Oct 2023 06:14:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNiom7w2ymCOyGFTwsF68OMsR5nwN/MyvpzZ2I7bgaoN2de33VjR42vrOzUlWtOFxTNkgvQw==
X-Received: by 2002:a05:6a20:3ca9:b0:12c:b10d:693d with SMTP id b41-20020a056a203ca900b0012cb10d693dmr4592577pzj.6.1697894092493;
        Sat, 21 Oct 2023 06:14:52 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o67-20020a634146000000b005742092c211sm3055320pga.64.2023.10.21.06.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Oct 2023 06:14:52 -0700 (PDT)
Date:   Sat, 21 Oct 2023 21:14:48 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH] generic/251: check min and max length and minlen for
 FSTRIM
Message-ID: <20231021131448.jjayss67pq5ztjdy@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231019143627.GD11391@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019143627.GD11391@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2023 at 07:36:27AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then, this test fails with the following output when
> running against my development tree when configured with an 8k fs block
> size:
> 
> --- a/tests/generic/251.out	2023-07-11 12:18:21.624971186 -0700
> +++ b/tests/generic/251.out.bad	2023-10-15 20:54:44.636000000 -0700
> @@ -1,2 +1,4677 @@
>  QA output created by 251
>  Running the test: done.
> +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> ...
> +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> 
> Dumping the exact fstrim command lines to seqres.full produces this at
> the end:
> 
> /usr/sbin/fstrim -m 32544k -o 30247k -l 4k /opt
> /usr/sbin/fstrim -m 32544k -o 30251k -l 4k /opt
> ...
> /usr/sbin/fstrim -m 32544k -o 30255k -l 4k /opt
> 
> The count of failure messages is the same as the count as the "-l 4k"
> fstrim invocations.  Since this is an 8k-block filesystem, the -l
> parameter is clearly incorrect.  The test computes random -m and -l
> options.
> 
> Therefore, create helper functions to guess at the minimum and maximum
> length and minlen parameters that can be used with the fstrim program.
> In the inner loop of the test, make sure that our choices for -m and -l
> fall within those constraints.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Hi Darrick, with this patch I 100% hit below failure (on default 4k xfs
and ext4):

# ./check generic/251
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
MKFS_OPTIONS  -- -f /dev/loop0
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch

generic/251 260s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/251.out.bad)
    --- tests/generic/251.out   2022-04-29 23:07:23.263498297 +0800
    +++ /root/git/xfstests/results//generic/251.out.bad 2023-10-21 21:02:37.687088360 +0800
    @@ -1,2 +1,5 @@
     QA output created by 251
     Running the test: done.
    +5834a5835
    +> aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
    +!!!Checksums has changed - Filesystem possibly corrupted!!!\n
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/251.out /root/git/xfstests/results//generic/251.out.bad'  to see the entire diff)
Ran: generic/251
Failures: generic/251
Failed 1 of 1 tests

And test passed without this patch.

# ./check generic/251
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
MKFS_OPTIONS  -- -f /dev/loop0
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch

generic/251 260s ...  249s
Ran: generic/251
Passed all 1 tests

Thanks,
Zorro

>  tests/generic/251 |   59 ++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/generic/251 b/tests/generic/251
> index 8ee74980cc..40cfd7c381 100755
> --- a/tests/generic/251
> +++ b/tests/generic/251
> @@ -53,14 +53,46 @@ _fail()
>  	kill $mypid 2> /dev/null
>  }
>  
> -_guess_max_minlen()
> +# Set FSTRIM_{MIN,MAX}_MINLEN to the lower and upper bounds of the -m(inlen)
> +# parameter to fstrim on the scratch filesystem.
> +set_minlen_constraints()
>  {
> -	mmlen=100000
> -	while [ $mmlen -gt 1 ]; do
> +	local mmlen
> +
> +	for ((mmlen = 100000; mmlen > 0; mmlen /= 2)); do
>  		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> -		mmlen=$(($mmlen/2))
>  	done
> -	echo $mmlen
> +	test $mmlen -gt 0 || \
> +		_notrun "could not determine maximum FSTRIM minlen param"
> +	FSTRIM_MAX_MINLEN=$mmlen
> +
> +	for ((mmlen = 1; mmlen < FSTRIM_MAX_MINLEN; mmlen *= 2)); do
> +		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> +	done
> +	test $mmlen -le $FSTRIM_MAX_MINLEN || \
> +		_notrun "could not determine minimum FSTRIM minlen param"
> +	FSTRIM_MIN_MINLEN=$mmlen
> +}
> +
> +# Set FSTRIM_{MIN,MAX}_LEN to the lower and upper bounds of the -l(ength)
> +# parameter to fstrim on the scratch filesystem.
> +set_length_constraints()
> +{
> +	local mmlen
> +
> +	for ((mmlen = 100000; mmlen > 0; mmlen /= 2)); do
> +		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> +	done
> +	test $mmlen -gt 0 || \
> +		_notrun "could not determine maximum FSTRIM length param"
> +	FSTRIM_MAX_LEN=$mmlen
> +
> +	for ((mmlen = 1; mmlen < FSTRIM_MAX_LEN; mmlen *= 2)); do
> +		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> +	done
> +	test $mmlen -le $FSTRIM_MAX_LEN || \
> +		_notrun "could not determine minimum FSTRIM length param"
> +	FSTRIM_MIN_LEN=$mmlen
>  }
>  
>  ##
> @@ -70,13 +102,24 @@ _guess_max_minlen()
>  ##
>  fstrim_loop()
>  {
> +	set_minlen_constraints
> +	set_length_constraints
> +	echo "MINLEN max=$FSTRIM_MAX_MINLEN min=$FSTRIM_MIN_MINLEN" >> $seqres.full
> +	echo "LENGTH max=$FSTRIM_MAX_LEN min=$FSTRIM_MIN_LEN" >> $seqres.full
> +
>  	trap "_destroy_fstrim; exit \$status" 2 15
>  	fsize=$(_discard_max_offset_kb "$SCRATCH_MNT" "$SCRATCH_DEV")
> -	mmlen=$(_guess_max_minlen)
>  
>  	while true ; do
> -		step=$((RANDOM*$RANDOM+4))
> -		minlen=$(((RANDOM*($RANDOM%2+1))%$mmlen))
> +		while true; do
> +			step=$((RANDOM*$RANDOM+4))
> +			test "$step" -ge "$FSTRIM_MIN_LEN" && break
> +		done
> +		while true; do
> +			minlen=$(( (RANDOM * (RANDOM % 2 + 1)) % FSTRIM_MAX_MINLEN ))
> +			test "$minlen" -ge "$FSTRIM_MIN_MINLEN" && break
> +		done
> +
>  		start=$RANDOM
>  		if [ $((RANDOM%10)) -gt 7 ]; then
>  			$FSTRIM_PROG $SCRATCH_MNT &
> 

