Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF7D3E0C67
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773431637; cv=none; b=HfMMcNQMlPtwylEryOf3BaRqtyNlir+m+r1X8x+f0D1iXvP4+hsMfFIviGFO2Y/PHDu8QOMvzWf0NRPhGsAErAjAEEZLqHe0sYtK5xw2aY9lc7hzmgiwxZyvH9J0e6N5RJ5hQASd3AwDRBepTZTuWrS9D33ttQKG20bBW2xEXZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773431637; c=relaxed/simple;
	bh=G29mf2Qgm5ygiOndKM4tUqhHWKZ3UrxSChJA+XwfIf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xl32FAfbEa8ecqbxme2GNbGQsDnjIP/XYVy260TLybYKxHpd2Jf6OMuXUAzvFFj86P6OlZUMQR+NVh6SJVrCS3taHtuegQB3tZfR7pjLab9XItAunTitOnWO6crymRtoL7fzgpao4Bx6T4m+4zRWRpCB16o1FHErbS6d3mW//kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LOFOqnb5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJYr4yVp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LOFOqnb5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJYr4yVp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773431631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vJzgvEdIH17TTB9mAGCyg7x5h540icsf9aACeOx91e4=;
	b=LOFOqnb5q9hrTVeQ1XHtMBTl9pZ7eoUUggeT52MTYwhFW67di67HeFeD2ETtwlMgc+Iibf
	3cwoLrgsH7FEzbu00xKuyl/ruO50fLnUrSC3GIYucUqzPaolcZoa8xI/zSWZ0rOq5N2AU4
	+wpXNVs4MLNp7Kt/rsMwDLA3Uo+WKJA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-a18BMvilPDeScYGVh6feAQ-1; Fri, 13 Mar 2026 15:53:50 -0400
X-MC-Unique: a18BMvilPDeScYGVh6feAQ-1
X-Mimecast-MFC-AGG-ID: a18BMvilPDeScYGVh6feAQ_1773431629
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c739120475fso1364358a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773431629; x=1774036429; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vJzgvEdIH17TTB9mAGCyg7x5h540icsf9aACeOx91e4=;
        b=JJYr4yVprOMvxsj7gQqFKHzEonNJg5nGXchmDcVKZGwJjIFY5vIrqoiemH9E6osj6y
         lUed4MF/hFRp3G9/ZfaWAZH7eKZK5o+NW8NijgjOT7FfvsGQA4OopiK2tJm0Jwus+a47
         xXIqRK6ZK589PiKbn/ok90nPNL5eOCsndgvs6SUrZSEUpHTjmI3YOSGclKovg2xbuOwO
         Iura/ZBu9o9eqg/z+MV4bNayYDnQtGygIjJzS1/q2uhicrfQbTdibWxsX5bPkAmDJfGS
         8u6cNAHptZJCNytmKvEyHKmQEqJkLgq5CQm7iV0bAAZW6Q7LtrVlfv3at5mHeZejNdOw
         u9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773431629; x=1774036429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vJzgvEdIH17TTB9mAGCyg7x5h540icsf9aACeOx91e4=;
        b=ddgGC3fa1H2W1ITJ7FlWm5R0pV9FtUQQtOcdS5nUl8DNzqT8pNi4p2FB0fdLNy0U+i
         gditlBUa43kH4bQFK+lhp0qWkj70DYKNoFdwxQR/tIoOmK6FOTJrs1XGiYf6iecdreRi
         BOE4xGNczJFbz0aYsAkiLtplW1fAWD3w7lcJyeyQpzu1n7pimM+EZ7GtxLh1K/DJCfUk
         uc2dd8glV3jTSGkojgdJjTGMTHgeDPhXLt34hGIiiQSS9lmjR8kU1PSY6P87MNgOraWT
         6BPVSv2iqOIQnRzq1ieYNdFI1PNTKUFz8tg1o+TgiNXroG3nKIl1XHxBnotzEhre/xhg
         eC/g==
X-Forwarded-Encrypted: i=1; AJvYcCXwLTZVFeo7TdeJL6ttXAaUYzjHZ/SR4kFTFNQyWYGzkqq5wNzYRgl+grjScFy2Sbz6Ve369ZYXbGA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yywhtf526w6CeJ6UtHNUBMJKR20ve/+ZnAsFSWBcemr38n0hDGj
	AXX+2pVyw8mbw+HPO5cN36AuK3TE4EZxjD6xPMA4RbP26epbK5+720oMPPt0Mns//8qq3lZzrn8
	wob9hsavgZuixFKM8PeOecxVnR/UzOOMcaPnaEc6la8KQGD7tozT21X4hFsda1A==
X-Gm-Gg: ATEYQzzHuHAudEIwqRHVRqpyDC3YMhMn/kNG/VzdDF/JLJER61MIyX/CoWLwLCC7LMb
	PYsVZ2Wr6wvHXLELgbu5fMTWmzU6A/H6UeI5UiHwyV3Vwu1mNucG+xQGCbrMoryTnfCtKxl7SpC
	50LZcafQOS82iMdgCTmUktoI3lja8OYm4BMqjWmHDGkh9fHJQr65aHLzPhLXb+A+nJeSt4dxv2B
	RfAnSPJCHnaCrlqvgsfIETY4AZSJC06GNoxn7wIQ/9ZIuMn3Y9eKBTOa2iCKY9QB4alxXbsHCBu
	xNIAlPg86NjL30y5w88DtPu7aicF9TeND5jiIZs/xfHsa1MA24UPg6TpCJGmXj5S9cI+EY575G/
	Lhr5xZT/ezMpxR+lI3887v2mkWom8JYAmbp5ZLmPwNpWvrPIu9fJgJGKPvtSBBw==
X-Received: by 2002:a05:6a20:1449:b0:398:849a:8482 with SMTP id adf61e73a8af0-398ecd54bbdmr3978528637.51.1773431628881;
        Fri, 13 Mar 2026 12:53:48 -0700 (PDT)
X-Received: by 2002:a05:6a20:1449:b0:398:849a:8482 with SMTP id adf61e73a8af0-398ecd54bbdmr3978508637.51.1773431628351;
        Fri, 13 Mar 2026 12:53:48 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73eb9966d9sm2552827a12.11.2026.03.13.12.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:53:47 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:53:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/14] xfs: test xfs_healer wont repair the wrong
 filesystem
Message-ID: <20260313195343.cmcmy7x7trafwn7n@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403996.1186408.2147128379746061809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403996.1186408.2147128379746061809.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:53:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that when xfs_healer needs to reopen a filesystem to repair it, it
> won't latch on to another xfs filesystem that has been mounted atop the same
> mountpoint.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/1901     |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1901.out |    2 +
>  2 files changed, 139 insertions(+)
>  create mode 100755 tests/xfs/1901
>  create mode 100755 tests/xfs/1901.out
> 
> 
> diff --git a/tests/xfs/1901 b/tests/xfs/1901
> new file mode 100755
> index 00000000000000..c92dcf9a3b3d48
> --- /dev/null
> +++ b/tests/xfs/1901
> @@ -0,0 +1,137 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1901
> +#
> +# Ensure that autonomous self healing won't fix the wrong filesystem if a
> +# snapshot of the original filesystem is now mounted on the same directory as
> +# the original.
> +#
> +. ./common/preamble
> +_begin_fstest auto selfhealing
> +
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/systemd
> +
> +_cleanup()
> +{
> +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
> +	cd /
> +	rm -r -f $tmp.*
> +	test -e "$mntpt" && _unmount "$mntpt" &>/dev/null
> +	test -e "$mntpt" && _unmount "$mntpt" &>/dev/null
> +	test -e "$loop1" && _destroy_loop_device "$loop1"
> +	test -e "$loop2" && _destroy_loop_device "$loop2"
> +	test -e "$testdir" && rm -r -f "$testdir"
> +}
> +
> +_require_test
> +_require_scrub
> +_require_xfs_io_command "repair"	# online repair support
> +_require_xfs_db_command "blocktrash"
> +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> +_require_command "$XFS_PROPERTY_PROG" "xfs_property"
> +
> +testdir=$TEST_DIR/$seq
> +mntpt=$testdir/mount
> +disk1=$testdir/disk1
> +disk2=$testdir/disk2
> +
> +mkdir -p "$mntpt"
> +$XFS_IO_PROG -f -c "truncate 300m" $disk1
> +$XFS_IO_PROG -f -c "truncate 300m" $disk2
> +loop1="$(_create_loop_device "$disk1")"
> +
> +filter_mntpt() {
> +	sed -e "s|$mntpt|MNTPT|g"
> +}
> +
> +_mkfs_dev "$loop1" >> $seqres.full
> +_mount "$loop1" "$mntpt" || _notrun "cannot mount victim filesystem"
> +
> +_xfs_has_feature $mntpt rmapbt || \
> +	_notrun "reverse mapping required to test directory auto-repair"
> +_xfs_has_feature $mntpt parent || \
> +	_notrun "parent pointers required to test directory auto-repair"
> +_require_xfs_healer $mntpt --repair
> +
> +# Configure the filesystem for automatic repair of the filesystem.
> +$XFS_PROPERTY_PROG $mntpt set autofsck=repair >> $seqres.full
> +
> +# Create a largeish directory
> +dblksz=$(_xfs_get_dir_blocksize "$mntpt")
> +echo testdata > $mntpt/a
> +mkdir -p "$mntpt/some/victimdir"
> +for ((i = 0; i < (dblksz / 255); i++)); do
> +	fname="$(printf "%0255d" "$i")"
> +	ln $mntpt/a $mntpt/some/victimdir/$fname
> +done
> +
> +# Did we get at least two dir blocks?
> +dirsize=$(stat -c '%s' $mntpt/some/victimdir)
> +test "$dirsize" -gt "$dblksz" || echo "failed to create two-block directory"
> +
> +# Clone the fs, break the directory, remount filesystem
> +_unmount "$mntpt"
> +
> +cp --sparse=always "$disk1" "$disk2" || _fail "cannot copy disk1"
> +loop2="$(_create_loop_device_like_bdev "$disk2" "$loop1")"
> +
> +$XFS_DB_PROG "$loop1" -x \
> +	-c 'path /some/victimdir' \
> +	-c 'bmap' \
> +	-c 'dblock 1' \
> +	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
> +_mount "$loop1" "$mntpt" || _fail "cannot mount broken fs"
> +
> +_invoke_xfs_healer "$mntpt" "$tmp.healer" --repair
> +
> +# Stop the healer process so that it can't read error events while we do some
> +# shenanigans.
> +test -n "$XFS_HEALER_PID" || _fail "nobody set XFS_HEALER_PID?"
> +kill -STOP $XFS_HEALER_PID
> +
> +
> +echo "LOG $XFS_HEALER_PID SO FAR:" >> $seqres.full
> +cat $tmp.healer >> $seqres.full
> +
> +# Access the broken directory to trigger a repair event, which will not yet be
> +# processed.
> +ls $mntpt/some/victimdir > /dev/null 2> $tmp.err
> +filter_mntpt < $tmp.err
> +
> +ps auxfww | grep xfs_healer >> $seqres.full
> +
> +echo "LOG AFTER TRYING TO POKE:" >> $seqres.full
> +cat $tmp.healer >> $seqres.full
> +
> +# Mount the clone filesystem to the same mountpoint so that the healer cannot
> +# actually reopen it to perform repairs.
> +_mount "$loop2" "$mntpt" -o nouuid || _fail "cannot mount decoy fs"
> +
> +grep -w xfs /proc/mounts >> $seqres.full
> +
> +# Continue the healer process so it can handle events now.  Wait a few seconds
> +# while it fails to reopen disk1's mount point to repair things.
> +kill -CONT $XFS_HEALER_PID
> +sleep 2
> +
> +new_dir_unmount() {
> +	_unmount "$mntpt"
> +	_unmount "$mntpt"
> +}
> +
> +# Unmount to kill the healer
> +_kill_xfs_healer new_dir_unmount
> +echo "LOG AFTER FAILURE" >> $seqres.full
> +cat $tmp.healer >> $seqres.full
> +
> +# Did the healer log complaints about not being able to reopen the mountpoint
> +# to enact repairs?
> +grep -q 'Stale file handle' $tmp.healer || \
> +	echo "Should have seen stale file handle complaints"
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1901.out b/tests/xfs/1901.out
> new file mode 100755
> index 00000000000000..ff83e03725307a
> --- /dev/null
> +++ b/tests/xfs/1901.out
> @@ -0,0 +1,2 @@
> +QA output created by 1901
> +ls: reading directory 'MNTPT/some/victimdir': Structure needs cleaning
> 

