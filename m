Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA00B36D9E5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 20:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773432364; cv=none; b=He+HhG7HuzfdQzh4jL4MlxDTMiFInKs0fsD1xk72uIQH3vVaxzUtKEHuQ954kHkEbluokqhNr93KB7yiwtGAPB2nU7YXePIAoIgRRWgfoUSJSI3zwT+v2YKN21Ul2JsbfKHMhGHp7SEIvC8BeBUyIzX8U46JXxX0QeStRVOsX3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773432364; c=relaxed/simple;
	bh=d2HcGH8C5Lz+kdmp7/GIctWDk30DlicURfLmw6aXL8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8Fv07Odohdm0D8Di4Jqhj0kR7D+yrNNyfi/odepfByO28n3q4/h2gfMEKVNZ0EAAiqmlkjzwvWf81RnqgNUHtbwxGeQqEgEMHD2L2V+GVtPXea0fZbICguHPgRBr2N3cMO6H6BQrN0b7wvb2glb1eYhGF3rq6wLv6Q2R4C1UOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YABYsJDr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ANeufVNw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YABYsJDr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ANeufVNw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773432361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yskzO6qztNYYS8nfmy/UeQ3D4Ek9yJ6xWQeq+h+z5KE=;
	b=YABYsJDrKGoiInus0tS6STMNAI+LNeOjh5bJjSz8lCNI0ndiNchPz/FzVKcPaQFHRgCwMi
	AmpzZe2boIUF83nN810ZQOqZ6920NaUEqJmPTU9/TbxVW0fvvZH2mUwNHhuBzuC9vq0MPD
	hjiDOiJzcsg6aY9W/dMwaJtgBjtHCVM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-9q9fEnKNMWK1SgGDALu_pA-1; Fri, 13 Mar 2026 16:06:00 -0400
X-MC-Unique: 9q9fEnKNMWK1SgGDALu_pA-1
X-Mimecast-MFC-AGG-ID: 9q9fEnKNMWK1SgGDALu_pA_1773432359
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ae47b3adacso26185545ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 13:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773432359; x=1774037159; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yskzO6qztNYYS8nfmy/UeQ3D4Ek9yJ6xWQeq+h+z5KE=;
        b=ANeufVNwejX81zWkIhjkI1enTCRc5vSkv3kjZwEI9Zw/4YKb5nbyW6bmuwNTw2Q71R
         nhrJvneKiK/kGIDaAeh/zlCtsXPm6ACVCQrkSKlHLKkadornwQwL7aE9z+cGr4aFinmV
         HzeSXWZIhfzVK5WVPv5lgnkJCPIQSPbrj2fPW6Rdj7qFc6kQMTCpKbdGrsxOu+KX9Ald
         ef9HpDhvgJCKyv78EXhSDIpAFEMSav4vYyrWQ3l9X8Quz3oV9VPLz5mO5aLOJlb5gGF6
         ReaHvp0pj4IO7qAmkSm2+Bsdsnvu7l0OZVmmpUqSK34SGh6KF1omh5yLXcLnqlA2NJyh
         +jgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773432359; x=1774037159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yskzO6qztNYYS8nfmy/UeQ3D4Ek9yJ6xWQeq+h+z5KE=;
        b=UfGutki3JluGt51f3KR/Pc5Jpi1E9AsqZlVtceHiLJoEv3pSWuAETDB5kyjBsiYrgD
         1Mr1hjAPuk4hkULch/fWiWghMk5W9z//uqBNjnNuRl00cX4KdARktCyUYDDUbR8x3cO0
         ujAv/UeNynZWa2BGeOhrD4geXVCD2duFlIj9zxRkJTEQ2luYhuUM2E7M61YRGkXqjeAw
         aXpg2MkhZ9/YlQ7OpirwQSKkrDV4kSqJtI5E/4j2e/+x5Dz9j9XwqQVtYPAOr8IEJcLQ
         LsqNWBK1Au6A1BgJiDXPNXEno4RLpdZ2LGzCPQYJIQ/MnfkJXR9MEM8jXg4pIlVerp1I
         elCw==
X-Forwarded-Encrypted: i=1; AJvYcCVd7fi/RZ1tkEIHKfcQas6OHaIVio4ie5zTkuYJprf2tTB+ob0xXUKLsfN5JjLY2S0Q355Pkuyz2iA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS874ayne71BpL6lcZqX3xXvPb6b7+PkU+kxa9B6PcHTBon69T
	Tm/kP+BwjQxpWDTv/6vMirNXTBjjhfTVN5L6vNKZcjglx87SadFtyMyIQs6PgXHgs/aWolkT+AG
	K4hJHEGW6AMHyhIuoL9676n//8NWMkR7eKr203hgNlHiLEQEIAjlzRNEo0niHZw==
X-Gm-Gg: ATEYQzxIXEgHwscRHlBG1ftmDfDE+99hWgZZD2Y3t6z77seu4QGttprFmim+3bmlSIo
	imFNl4VcKNZnXVzvdmzCPMNxArD8pmgb+/aKPvk96wEzjfFc8xhOQtuSrJ7agvZniL/kLNWmXh0
	v3/3QrgDOelVmI4v1OaMsj+mvfzwch5105ekEYc2NJTkygdDsUO1tx3aP9FvHXNVzXNz3rx2oXg
	tiuV1vBnKxHRJI5369w6Y9nZbvMl/3sebtvuvw//S4d7biwSv7DEYxOU3bsq5FQw+7i42jmAGwU
	bgrrqSthtEdCK0wIbSMSAQBMRQq4A+9VQ4YSOjTSdHp93UccezlA7gWTa1x1U8SwrUDmp+Ss94w
	zBLVx6/JCg/cYTuu9kDd0RcRL03af9OE4GsT3HmxHjVMVg2mxh94oRwoBj5TrwA==
X-Received: by 2002:a05:6a21:62c6:b0:398:9820:f6fa with SMTP id adf61e73a8af0-398ecd61585mr3983598637.53.1773432358967;
        Fri, 13 Mar 2026 13:05:58 -0700 (PDT)
X-Received: by 2002:a05:6a21:62c6:b0:398:9820:f6fa with SMTP id adf61e73a8af0-398ecd61585mr3983575637.53.1773432358479;
        Fri, 13 Mar 2026 13:05:58 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73eba9c625sm2464214a12.13.2026.03.13.13.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:05:58 -0700 (PDT)
Date: Sat, 14 Mar 2026 04:05:53 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/14] xfs: test xfs_healer can follow private mntns
 mount moves
Message-ID: <20260313200553.xujzlttj66eg7mgm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260310033846.GH1105363@frogsfrogsfrogs>
 <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <20260312142130.GG1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312142130.GG1770774@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 07:21:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that when xfs_healer needs to reopen a filesystem to repair
> it, it can still find the filesystem even if it has been mount --move'd.
> This requires a bunch of private namespace magic.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/xfs/1904     |  129 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1904.out |    3 +
>  2 files changed, 132 insertions(+)
>  create mode 100755 tests/xfs/1904
>  create mode 100755 tests/xfs/1904.out
> 
> diff --git a/tests/xfs/1904 b/tests/xfs/1904
> new file mode 100755
> index 00000000000000..78e8f5dcb0e834
> --- /dev/null
> +++ b/tests/xfs/1904
> @@ -0,0 +1,129 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1904
> +#
> +# Ensure that autonomous self healing fixes the filesystem correctly even if
> +# the original mount has moved somewhere else via --move.
> +#
> +. ./common/preamble
> +_begin_fstest auto selfhealing
> +
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/systemd
> +
> +if [ -n "$IN_MOUNTNS" ]; then
> +	_mount --make-rprivate /

I'd like to add this case and other cases related with mount propagation in this
patchset to "mount" group. I'll do it when I merge this patchset. Others look and
test good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +	findmnt -o TARGET,PROPAGATION >> $seqres.full
> +
> +	_scratch_mount
> +	_scratch_invoke_xfs_healer "$tmp.healer" --repair
> +
> +	# Move the scratch filesystem to a completely different mountpoint so that
> +	# we can test if the healer can find it again.
> +	new_dir=$TEST_DIR/moocow
> +	mkdir -p $new_dir
> +	_mount --move $SCRATCH_MNT $new_dir
> +
> +	df -t xfs >> $seqres.full
> +
> +	# Access the broken directory to trigger a repair, then poll the directory
> +	# for 5 seconds to see if it gets fixed without us needing to intervene.
> +	ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
> +	_filter_scratch < $tmp.err | _filter_test_dir
> +	try=0
> +	while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> +		echo "try $try saw corruption" >> $seqres.full
> +		sleep 0.1
> +		ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
> +		try=$((try + 1))
> +	done
> +	echo "try $try no longer saw corruption or gave up" >> $seqres.full
> +	_filter_scratch < $tmp.err | _filter_test_dir
> +
> +	# List the dirents of /victimdir to see if it stops reporting corruption
> +	ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
> +	try=0
> +	while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> +		echo "retry $try still saw corruption" >> $seqres.full
> +		sleep 0.1
> +		ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +		try=$((try + 1))
> +	done
> +	echo "retry $try no longer saw corruption or gave up" >> $seqres.full
> +
> +	new_dir_unmount() {
> +		_unmount $new_dir
> +	}
> +
> +	# Unmount to kill the healer
> +	_scratch_kill_xfs_healer new_dir_unmount
> +	cat $tmp.healer >> $seqres.full
> +
> +	# No need to clean up, the mount ns destructor will detach the
> +	# filesystems for us.
> +	exit
> +fi
> +
> +_cleanup()
> +{
> +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
> +	cd /
> +	rm -r -f $tmp.*
> +	if [ -n "$new_dir" ]; then
> +		_unmount "$new_dir" &>/dev/null
> +		rm -rf "$new_dir"
> +	fi
> +}
> +
> +_require_unshare
> +_require_test
> +_require_scrub
> +_require_xfs_io_command "repair"	# online repair support
> +_require_xfs_db_command "blocktrash"
> +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> +_require_command "$XFS_PROPERTY_PROG" "xfs_property"
> +_require_scratch
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +_xfs_has_feature $SCRATCH_MNT rmapbt || \
> +	_notrun "reverse mapping required to test directory auto-repair"
> +_xfs_has_feature $SCRATCH_MNT parent || \
> +	_notrun "parent pointers required to test directory auto-repair"
> +_require_xfs_healer $SCRATCH_MNT --repair
> +
> +# Configure the filesystem for automatic repair of the filesystem.
> +$XFS_PROPERTY_PROG $SCRATCH_MNT set autofsck=repair >> $seqres.full
> +
> +# Create a largeish directory
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> +echo testdata > $SCRATCH_MNT/a
> +mkdir -p "$SCRATCH_MNT/some/victimdir"
> +for ((i = 0; i < (dblksz / 255); i++)); do
> +	fname="$(printf "%0255d" "$i")"
> +	ln $SCRATCH_MNT/a $SCRATCH_MNT/some/victimdir/$fname
> +done
> +
> +# Did we get at least two dir blocks?
> +dirsize=$(stat -c '%s' $SCRATCH_MNT/some/victimdir)
> +test "$dirsize" -gt "$dblksz" || echo "failed to create two-block directory"
> +
> +# Break the directory, remount filesystem
> +_scratch_unmount
> +_scratch_xfs_db -x \
> +	-c 'path /some/victimdir' \
> +	-c 'bmap' \
> +	-c 'dblock 1' \
> +	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
> +
> +# mount --move only works if mount propagation is disabled, so we have to start
> +# a subshell with a separate mount namespace, disable propagation for the
> +# entire directory tree, and only then can we run our tests.
> +IN_MOUNTNS=1 unshare -m bash "$0"
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1904.out b/tests/xfs/1904.out
> new file mode 100755
> index 00000000000000..34a46298dd439a
> --- /dev/null
> +++ b/tests/xfs/1904.out
> @@ -0,0 +1,3 @@
> +QA output created by 1904
> +QA output created by 1904
> +ls: reading directory 'TEST_DIR/moocow/some/victimdir': Structure needs cleaning
> 

