Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281DD29CE7
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 04:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723091114; cv=none; b=kD/ICQ0eVhtLbJTvIxo2ZnI5H3cVE7j97u9Q4zShJft37mChBiEROltIX1qzqjU/6bcPyeIxNP4Ep5v2wXCk+yOROLJ6xV0JWaC9n4c5yOAgD0HZJMEgwC2T6gJ41L+++NiQZallZwgHxbAdJ764eSCMntyXMOHI71TNoNO3goE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723091114; c=relaxed/simple;
	bh=OeW6UIca7b7KeYJ6B1qSCWfM0uAGt3QA+e5SZ4szTMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1XF8B007KUPKc0+T63OfBHPCYU8cKDEDAhEvpz4bVKVooouf7F45X8P0wbwjcirSUEMDTzIcz5RKFkaUSM+jdhDBum8/m03aBnB1vAFiQPqSqxeesQDHjlCUtjraQJ5WmvFwcAGXdnmuWS8UWHDCwlWHCN51T+hMyIA/H268A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ggb/Bu6G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggb/Bu6G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723091111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l7FBaH/Enu2fqH7IdyZtcncwK82UJJd9odzq6hZn+qo=;
	b=ggb/Bu6GmFLHKiocpdV0wq/fUMcTUVycwOfES38HX2zJ1hX6PGTF/y0PZ/F2kHLwdooasM
	7jcl4bZUrmPZzXamstTt0O2h+LIvl8+bESdP79ebHyhr1SFBvzlEhY20p91LE+OwnWJPFe
	mG4ihXy6//JGNNW6Uq8EEe+oklFnj98=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-I7xS4VIcNLe0j9jLIFU_8A-1; Thu, 08 Aug 2024 00:25:09 -0400
X-MC-Unique: I7xS4VIcNLe0j9jLIFU_8A-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3db13ab203aso727079b6e.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 Aug 2024 21:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723091108; x=1723695908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7FBaH/Enu2fqH7IdyZtcncwK82UJJd9odzq6hZn+qo=;
        b=hmsbcpyMOZ1g4fujxJ07ESNqo3U2jENS7wOtH8rPRO3LPR4veCe1fYNHd8Bg92vwBM
         KCCOOhRe0W9HyvNe42K/FHt9BtP5CFRdRVb6tIjsVvjz8w4bu4tG6W7330zXbMGPGlqF
         C7o3qwCBveEpOQwJ/1yRgEjvI+euR77I4hKfWaEY18GX4gMvMaxYW6OHXg4sHHM6gOCB
         cYyciHyvZjmO9wdvssLQb1WkvW6JZYJ80SU5DJS1l2RuVuESiIO+vxBdWSKzVZ/2xdg1
         W3nANzwKR3zAzOBYRYwmUKAyewRqwVjmmANg4BP2uEiFOdKeCZ8QD3Mxd5chk3iPYSpi
         C6vw==
X-Forwarded-Encrypted: i=1; AJvYcCXSXQ8bm3iaUseHDezP3Os7T+VZo83w5MDaDqdX/gQpO6/nRDZQ+axeVFC6GdVVKSEkFlFmGCpsEKFB6toAznNKC+9GiRAuhT2R
X-Gm-Message-State: AOJu0YySF0BcD0egtFHACbgNeJrp1OTshDeUXAKOFXJvXPbHPWRFNveI
	wO1nLpCd8ARanYeChIdoKFby9rGAIB9awPuHhv5hr2fDnZarngqGa8hgUevFTftSPuYicpYXazC
	pr/dsas9ni/InNzrAySAb6rofh92DYcp/vZN+nZN6gJe2ulYkiZE/ESniNg==
X-Received: by 2002:a05:6808:1899:b0:3d9:28cd:67a6 with SMTP id 5614622812f47-3dc3b41d09dmr758024b6e.15.1723091108402;
        Wed, 07 Aug 2024 21:25:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFwSL7Ej3AoBLWJrRYryoAo2sRrRCUl1AIn9W1dF51xiN8qj5gq7U6MYS0L4YLrWfsa9AKOQ==
X-Received: by 2002:a05:6808:1899:b0:3d9:28cd:67a6 with SMTP id 5614622812f47-3dc3b41d09dmr758009b6e.15.1723091108041;
        Wed, 07 Aug 2024 21:25:08 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710cb2d3c8bsm293499b3a.121.2024.08.07.21.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 21:25:07 -0700 (PDT)
Date: Thu, 8 Aug 2024 12:25:04 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove all traces of xfs_check
Message-ID: <20240808042504.fvsvi5tbuxfvi75j@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240806225606.GC623922@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806225606.GC623922@frogsfrogsfrogs>

On Tue, Aug 06, 2024 at 03:56:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfsprogs stopped shipping xfs_check (the wrapper script) in May 2014.
> It's now been over a decade since it went away, and its replacements
> (xfs_repair and xfs_scrub) now detect a superset of the problems that
> check can find.
> 
> There is no longer any point in invoking xfs_check, so let's remove it
> from fstests completely.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Finally :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  README            |    6 ++---
>  common/fuzzy      |   11 --------
>  common/xfs        |   69 ++---------------------------------------------------
>  crash/xfscrash    |   18 --------------
>  tests/xfs/017     |    6 ++---
>  tests/xfs/114     |    2 +-
>  tests/xfs/291     |    3 +-
>  tests/xfs/307     |    6 -----
>  tests/xfs/307.out |    3 --
>  tests/xfs/308     |    3 --
>  tests/xfs/308.out |    1 -
>  tests/xfs/310     |    2 --
>  12 files changed, 10 insertions(+), 120 deletions(-)
> 
> diff --git a/README b/README
> index 477136deb0..024d395318 100644
> --- a/README
> +++ b/README
> @@ -202,10 +202,8 @@ Extra XFS specification:
>     xfs_repair -n to check the filesystem; xfs_repair to rebuild metadata
>     indexes; and xfs_repair -n (a third time) to check the results of the
>     rebuilding.
> - - Set FORCE_XFS_CHECK_PROG=yes to have _check_xfs_filesystem run xfs_check
> -   to check the filesystem. As of August 2021, xfs_repair finds all
> -   filesystem corruptions found by xfs_check, and more, which means that
> -   xfs_check is no longer run by default.
> + - The FORCE_XFS_CHECK_PROG option was removed in July 2024, along with all
> +   support for xfs_check.
>   - Set TEST_XFS_SCRUB_REBUILD=1 to have _check_xfs_filesystem run xfs_scrub in
>     "force_repair" mode to rebuild the filesystem; and xfs_repair -n to check
>     the results of the rebuilding.
> diff --git a/common/fuzzy b/common/fuzzy
> index 3cd7da4ae6..0dd88302cd 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -383,17 +383,6 @@ __scratch_xfs_fuzz_field_offline() {
>  	test $res -eq 0 && \
>  		(>&2 echo "${fuzz_action}: offline scrub didn't fail.")
>  
> -	# Make sure xfs_repair catches at least as many things as the old
> -	# xfs_check did.
> -	if [ -n "${SCRATCH_XFS_FUZZ_CHECK}" ]; then
> -		__fuzz_notify "+ Detect fuzzed field (xfs_check)"
> -		_scratch_xfs_check 2>&1
> -		res1=$?
> -		if [ $res1 -ne 0 ] && [ $res -eq 0 ]; then
> -			(>&2 echo "${fuzz_action}: xfs_repair passed but xfs_check failed ($res1).")
> -		fi
> -	fi
> -
>  	# Repair the filesystem offline
>  	__fuzz_notify "+ Try to repair the filesystem (offline)"
>  	_repair_scratch_fs -P 2>&1
> diff --git a/common/xfs b/common/xfs
> index 7706b56260..bd40a02ed2 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -270,43 +270,6 @@ _xfs_get_fsxattr()
>  	echo ${value##fsxattr.${field} = }
>  }
>  
> -# xfs_check script is planned to be deprecated. But, we want to
> -# be able to invoke "xfs_check" behavior in xfstests in order to
> -# maintain the current verification levels.
> -_xfs_check()
> -{
> -	OPTS=" "
> -	DBOPTS=" "
> -	USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
> -
> -	OPTIND=1
> -	while getopts "b:fi:l:stvV" c; do
> -		case $c in
> -			s) OPTS=$OPTS"-s ";;
> -			t) OPTS=$OPTS"-t ";;
> -			v) OPTS=$OPTS"-v ";;
> -			i) OPTS=$OPTS"-i "$OPTARG" ";;
> -			b) OPTS=$OPTS"-b "$OPTARG" ";;
> -			f) DBOPTS=$DBOPTS" -f";;
> -			l) DBOPTS=$DBOPTS" -l "$OPTARG" ";;
> -			V) $XFS_DB_PROG -p xfs_check -V
> -			   return $?
> -			   ;;
> -		esac
> -	done
> -	set -- extra $@
> -	shift $OPTIND
> -	case $# in
> -		1) ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
> -		   status=$?
> -		   ;;
> -		2) echo $USAGE 1>&1
> -		   status=2
> -		   ;;
> -	esac
> -	return $status
> -}
> -
>  _scratch_xfs_options()
>  {
>      local type=$1
> @@ -392,16 +355,6 @@ _test_xfs_logprint()
>  	$XFS_LOGPRINT_PROG $TEST_OPTIONS $* $TEST_DEV
>  }
>  
> -_scratch_xfs_check()
> -{
> -	SCRATCH_OPTIONS=""
> -	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> -		SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
> -	[ "$LARGE_SCRATCH_DEV" = yes ] && \
> -		SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
> -	_xfs_check $SCRATCH_OPTIONS $* $SCRATCH_DEV
> -}
> -
>  # Check for secret debugging hooks in xfs_repair
>  _require_libxfs_debug_flag() {
>  	local hook="$1"
> @@ -765,7 +718,7 @@ _xfs_skip_online_rebuild() {
>  	touch "$RESULT_DIR/.skip_orebuild"
>  }
>  
> -# run xfs_check and friends on a FS.
> +# run xfs_repair and xfs_scrub on a FS.
>  _check_xfs_filesystem()
>  {
>  	local can_scrub=
> @@ -856,24 +809,8 @@ _check_xfs_filesystem()
>  		ok=0
>  	fi
>  
> -	# xfs_check runs out of memory on large files, so even providing the
> -	# test option (-t) to avoid indexing the free space trees doesn't make
> -	# it pass on large filesystems. Avoid it.
> -	#
> -	# As of August 2021, xfs_repair completely supersedes xfs_check's
> -	# ability to find corruptions, so we no longer run xfs_check unless
> -	# forced to run it.
> -	if [ "$LARGE_SCRATCH_DEV" != yes ] && [ "$FORCE_XFS_CHECK_PROG" = "yes" ]; then
> -		_xfs_check $extra_log_options $device 2>&1 > $tmp.fs_check
> -	fi
> -	if [ -s $tmp.fs_check ]; then
> -		_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (c)"
> -		echo "*** xfs_check output ***"		>>$seqres.full
> -		cat $tmp.fs_check			>>$seqres.full
> -		echo "*** end xfs_check output"		>>$seqres.full
> -
> -		ok=0
> -	fi
> +	# xfs_check used to run here, but was removed as of July 2024 because
> +	# xfs_repair can detect more corruptions than xfs_check ever did.
>  
>  	$XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
>  	if [ $? -ne 0 ]; then
> diff --git a/crash/xfscrash b/crash/xfscrash
> index 579b724db3..037b3df1e5 100755
> --- a/crash/xfscrash
> +++ b/crash/xfscrash
> @@ -110,24 +110,6 @@ _check()
>      fail=0
>      
>      if [ $expect -eq 0 ]
> -    then
> -        _echo "   *** Checking FS (expecting clean fs)"
> -    else
> -        _echo "   *** Checking FS (expecting dirty fs)"
> -    fi
> -    
> -    
> -    if [ $expect -eq 0 ]
> -    then
> -        _echo "      *** xfs_check ($LOG/check_clean.out)"   
> -        _xfs_check $TEST_DEV &> $LOG/check_clean.out || fail=1
> -        [ -s /tmp/xfs_check_clean.out ] && fail=1
> -    else
> -        _echo "      *** xfs_check ($LOG/check_dirty.out)"   
> -        _xfs_check $TEST_DEV &> $LOG/check_dirty.out || fail=1
> -    fi
> -    
> -    if [ $fail -eq 0 -a $expect -eq 0 ]
>      then
>          _echo "      *** xfs_repair -n ($LOG/repair_clean.out)"   
>          xfs_repair -n $TEST_DEV &> $LOG/repair_clean.out || fail=1
> diff --git a/tests/xfs/017 b/tests/xfs/017
> index efe0ac119b..f961425409 100755
> --- a/tests/xfs/017
> +++ b/tests/xfs/017
> @@ -55,10 +55,10 @@ do
>              | head | grep -q "<CLEAN>" || _fail "DIRTY LOG"
>  
>          echo ""                             >>$seqres.full
> -        echo "*** XFS_CHECK ***"            >>$seqres.full
> +        echo "*** XFS_REPAIR ***"           >>$seqres.full
>          echo ""                             >>$seqres.full
> -        _scratch_xfs_check                  >>$seqres.full 2>&1 \
> -            || _fail "xfs_check failed"
> +        _scratch_xfs_repair -n              >>$seqres.full 2>&1 \
> +            || _fail "xfs_repair -n failed"
>          _try_scratch_mount -o remount,rw \
>              || _fail "remount rw failed"
>  done
> diff --git a/tests/xfs/114 b/tests/xfs/114
> index 343730051b..510d31a402 100755
> --- a/tests/xfs/114
> +++ b/tests/xfs/114
> @@ -78,7 +78,7 @@ $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
>  
>  echo "Remount"
>  _scratch_unmount
> -_scratch_xfs_check
> +_check_xfs_scratch_fs
>  _scratch_mount
>  
>  echo "Collapse file"
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index 831c50d7b5..0141c075be 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -94,9 +94,8 @@ for I in `seq 1 2 5000`; do
>  done
>  
>  _scratch_unmount
> -# Can xfs_repair and xfs_check cope with this monster?
> +# Can xfs_repair cope with this monster?
>  _scratch_xfs_repair >> $seqres.full 2>&1 || _fail "xfs_repair failed"
> -_scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
>  
>  # Yes they can!  Now...
>  # Can xfs_metadump cope with this monster?
> diff --git a/tests/xfs/307 b/tests/xfs/307
> index 25d15a9c0d..7559d90414 100755
> --- a/tests/xfs/307
> +++ b/tests/xfs/307
> @@ -119,9 +119,6 @@ fi
>  
>  _dump_status "broken fs config" >> $seqres.full
>  
> -echo "Look for leftover warning in xfs_check"
> -_scratch_xfs_check | _filter_leftover
> -
>  echo "Look for leftover warning in xfs_repair"
>  _scratch_xfs_repair -n 2>&1 | _filter_leftover
>  
> @@ -130,9 +127,6 @@ _scratch_xfs_repair >> $seqres.full 2>&1 || echo "xfs_repair failed?"
>  
>  _dump_status "supposedly fixed fs config" >> $seqres.full
>  
> -echo "Look for no more leftover warning in xfs_check"
> -_scratch_xfs_check | _filter_leftover
> -
>  echo "Look for no more leftover warning in xfs_repair"
>  _scratch_xfs_repair -n 2>&1 | _filter_leftover
>  
> diff --git a/tests/xfs/307.out b/tests/xfs/307.out
> index b264ed0280..846b2a9813 100644
> --- a/tests/xfs/307.out
> +++ b/tests/xfs/307.out
> @@ -4,10 +4,7 @@ We need AG1 to have a single free extent
>  Find our extent and old counter values
>  Remove the extent from the freesp btrees
>  Add the extent to the refcount btree
> -Look for leftover warning in xfs_check
> -leftover CoW extent (NR/NR) len NR
>  Look for leftover warning in xfs_repair
>  leftover CoW extent (NR/NR) len NR
>  Fix filesystem
> -Look for no more leftover warning in xfs_check
>  Look for no more leftover warning in xfs_repair
> diff --git a/tests/xfs/308 b/tests/xfs/308
> index 813c4d8d4e..3c88869e45 100755
> --- a/tests/xfs/308
> +++ b/tests/xfs/308
> @@ -128,9 +128,6 @@ _scratch_unmount
>  
>  _dump_status "supposedly fixed fs config" >> $seqres.full
>  
> -echo "Look for no more leftover warning in xfs_check"
> -_scratch_xfs_check | _filter_leftover
> -
>  echo "Look for no more leftover warning in xfs_repair"
>  _scratch_xfs_repair -n 2>&1 | _filter_leftover
>  
> diff --git a/tests/xfs/308.out b/tests/xfs/308.out
> index 383cd07e9d..39a288be68 100644
> --- a/tests/xfs/308.out
> +++ b/tests/xfs/308.out
> @@ -7,5 +7,4 @@ Add the extent to the refcount btree
>  Look for leftover warning in xfs_repair
>  leftover CoW extent (NR/NR) len NR
>  Mount filesystem
> -Look for no more leftover warning in xfs_check
>  Look for no more leftover warning in xfs_repair
> diff --git a/tests/xfs/310 b/tests/xfs/310
> index eb310d8ccd..34d17be97f 100755
> --- a/tests/xfs/310
> +++ b/tests/xfs/310
> @@ -65,7 +65,6 @@ nr_rmaps=$(xfs_db -c 'agf 0' -c 'addr rmaproot' -c 'p' $DMHUGEDISK_DEV | grep ",
>  test $nr_rmaps -eq 1 || xfs_db -c 'agf 0' -c 'addr rmaproot' -c 'p' $DMHUGEDISK_DEV | grep ",$inum,[0-9]*,1,0,0"
>  
>  echo "Check and fake-repair huge filesystem" | tee -a $seqres.full
> -$XFS_DB_PROG -c 'check' $DMHUGEDISK_DEV
>  $XFS_REPAIR_PROG -n $DMHUGEDISK_DEV >> $seqres.full 2>&1
>  test $? -eq 0 || echo "xfs_repair -n failed, see $seqres.full"
>  
> @@ -82,7 +81,6 @@ nr_rmaps=$(xfs_db -c 'agf 0' -c 'addr rmaproot' -c 'p' $DMHUGEDISK_DEV | grep ",
>  test $nr_rmaps -eq 1 || xfs_db -c 'agf 0' -c 'addr rmaproot' -c 'p' $DMHUGEDISK_DEV | grep ",$inum,[0-9]*,1,0,0"
>  
>  echo "Check and fake-repair huge filesystem again" | tee -a $seqres.full
> -$XFS_DB_PROG -c 'check' $DMHUGEDISK_DEV
>  $XFS_REPAIR_PROG -n $DMHUGEDISK_DEV >> $seqres.full 2>&1
>  
>  echo "Done"
> 

