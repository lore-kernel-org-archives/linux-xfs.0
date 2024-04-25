Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7383A268
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 05:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714023122; cv=none; b=hVJuGhjNsRif6rDxqcUTUoJ0x3JNtMLIWkpE7GQ6Nt0u5zxi40sqR4DXO0/FQuRGmJE9X/uQHduYdmaG50pSpMHKLK602nNLSX+IoaaTPsQtljP1BKmCsRsoJNyOObT0T47mCaW+u+/RXbukczBFysJw2TI+i6MclSChWTm3k4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714023122; c=relaxed/simple;
	bh=7zEfJIiF3FivC8A8nCfn1uyLMo6vziSgrYc4tCU5fE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBuHwB+KMVK3k4kGYGEKIIoZCoMm/n29P82EpNpFW9eaXUFS1MkTzs26X93so2F2Uo7PL85ZAxzecqPZmo1e8OZ3UQ7eYqAYuWABtMm/maXVMMSnh6T4yR76zCQQquILxC8vSWgm9EZc3DI4PeBQb7Lo+tjck3m5oDMa2f3MrDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GA60m/EL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GA60m/EL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714023119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TXt+za/0JniFUhxuXePW/X/JHM72efTXKoPa8YCXUF0=;
	b=GA60m/ELuL3meQDg7DMP2hJvcnp7HH5dgkozTlu9ZR1LFHylZSvaK9v7rQKCILhoBgCi7J
	LbO5Y3jIepyEshwvVxR0E/7cf7qE0dBAAyojKP2TjMoeQqWppeLqK4K9IRWr81PbfxXFAS
	H53ouJDoJGpD5XBnMeY5LGLACbP3TKs=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-BRdNLNxsNoK498QdBT_-ug-1; Thu, 25 Apr 2024 01:31:57 -0400
X-MC-Unique: BRdNLNxsNoK498QdBT_-ug-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6ed11726f61so892335a34.0
        for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 22:31:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714023116; x=1714627916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXt+za/0JniFUhxuXePW/X/JHM72efTXKoPa8YCXUF0=;
        b=LafWV4YkvfM8CSbZf1841I+W3hNZVgrSBOuhlD+vsrTodriHgKcQdgHzefa7aTMSxK
         3xskgxgh8T36+w0RaEE/FEHLwEg4wnokds0hMenqCY7wp1tWsdauxDqVbJBRrMfqYu5H
         j5OIdjLgDl3h8M9bc6f14OYlkumcRGxjV3+QxzRwIJ8m96LYosfabjVeKnl0p8YLB3Lr
         W9SBq0uOxnFGfnlSKcQ4sl4OMVhoPbs3QbIZOzpoJzIWQOzlRs1S94HVHiQkgj0XCZsl
         mL5X7clz7s/OKPnd4mOJV2ucW5tZ+L6XFr/9b6o0BgivhdSzt1kDjxve6HLVP097IJ8k
         LpWg==
X-Forwarded-Encrypted: i=1; AJvYcCUfo/aZ5O1AkyYZoBNnQhNz2suKz95kPLiWvrdffHQ6JcdtXjcA62ka/w99JVnCcsoQVDgwRNR3N70to65nrUlr8bB/c9XWFn1P
X-Gm-Message-State: AOJu0Yyg+L2msEK9I+SsuuJgXFxCLSTNXpdKh+kuCRKaxGq+Wi/n9IKN
	5h9Ia4EvnBpswx6biGZi6bRgi2Pk4GtsxyjWhEeb6mwffBH/6jlW+xBeH0kzL2QsPFMh3xqwSb2
	9FZU0iRTOAj7Hb/K3as9rPurV/A+9B7vBwvM63vUWHSJuWTET3em1ZQFJDw==
X-Received: by 2002:a9d:4e92:0:b0:6ea:2789:8b62 with SMTP id v18-20020a9d4e92000000b006ea27898b62mr5918162otk.19.1714023116346;
        Wed, 24 Apr 2024 22:31:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExurcrNElXyLE2fPdow34mnWbyvknAw7mkB5c43l+DZ+XlqhkPienYAmSwwKvMbS+xxLYbAw==
X-Received: by 2002:a9d:4e92:0:b0:6ea:2789:8b62 with SMTP id v18-20020a9d4e92000000b006ea27898b62mr5918140otk.19.1714023115768;
        Wed, 24 Apr 2024 22:31:55 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l185-20020a6391c2000000b005ffd8019f01sm6334919pge.20.2024.04.24.22.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 22:31:55 -0700 (PDT)
Date: Thu, 25 Apr 2024 13:31:50 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	willy@infradead.org, p.raghav@samsung.com, da.gomez@samsung.com,
	hare@suse.de, john.g.garry@oracle.com, ziy@nvidia.com,
	linux-xfs@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [RFC] fstests: add fsstress + writeback + debugfs folio split
 test
Message-ID: <20240425053150.tx7pdosbfv5adat6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240424224649.1494092-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424224649.1494092-1-mcgrof@kernel.org>

On Wed, Apr 24, 2024 at 03:46:48PM -0700, Luis Chamberlain wrote:
> Stress test folio splits by using the debugfs interface to a target
> a new smaller folio order. This is dangerous at the moment as its using
> a debugfs API which requires two out of tree fixes [0] [1] which will
> be posted shortly. With these patches applied no crash is possible yet.
> However, this test was designed to try to exacerbate races with folio
> splits and writeback, at least running generic/447 twice ends up
> producing a crash only if large folio splits with minimum folio order
> is enabled.
> 
> With the known fixes for the debugfs interface, this test produces no
> crashes even after 3 hour soaking for 4k and LBS. We should enhance
> this test a bit more so to reproduce the issues observed by running
> generic/447 twice.
> 
> This also begs the question if something like MADV_NOHUGEPAGE might be
> desirable from userspace, so to enable userspace to request splits when
> possible.
> 
> If inspecting more closely, you'll want to enable on your kernel boot:
> 
> 	dyndbg='file mm/huge_memory.c +p'
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/commit/?h=20240424-lbs&id=80f6df5037fd0ad560526af45bd7f4d779fe03f6
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/commit/?h=20240424-lbs&id=38f6fac5b4283ea48b1876fc56728f062168f8c3
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
> 
> For those that want to help stress test folio splits to an order, hopefully
> this will help start to enable this. Perhaps there are better ways to create
> more easy targets to stress test folio splits, and in particular try to
> reproduce the issue which so far is only possible by running generic/447 twice
> on LBS. The issue with generic/447 on LBS is not observed on 4k, and this test
> produces no crashes on LBS...
> 
>  common/rc             | 20 +++++++++
>  tests/generic/745     | 97 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/745.out |  2 +
>  3 files changed, 119 insertions(+)
>  create mode 100755 tests/generic/745
>  create mode 100644 tests/generic/745.out
> 
> diff --git a/common/rc b/common/rc
> index d4432f5ce259..1eefb53aa84b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -127,6 +127,26 @@ _require_compaction()
>  	    _notrun "Need compaction enabled CONFIG_COMPACTION=y"
>  	fi
>  }
> +
> +# Requires CONFIG_DEBUGFS and truncation knobs
> +SPLIT_DEBUGFS="/sys/kernel/debug/split_huge_pages"
> +_require_split_debugfs()
> +{
> +       if [ ! -f $SPLIT_DEBUGFS ]; then
> +           _notrun "Needs CONFIG_DEBUGFS and split_huge_pages"
> +       fi
> +}

The global SPLIT_DEBUGFS isn't necessary, you can just use:

  $DEBUGFS_MNT/split_huge_pages

And this remind me we have a _require_debugfs helper in common/rc, but
it's not used by any one test case. And it looks like not correct:

  _require_debugfs()
  {
      #boot_params always present in debugfs
      [ -d "$DEBUGFS_MNT/boot_params" ] || _notrun "Debugfs not mounted"
  }

I can't find "boot_params" in /sys/kernel/debug/. So we might need to
fix this helper, and then call it in debugfs related test cases.

I'll send another patch to talk about that fix. For this case, it needs
_require_debugfs and $DEBUGFS_MNT.

> +
> +_split_huge_pages_file_full()

May we have a comment to explain what this common helper for? Thanks.

> +{
> +	local file=$1
> +	local offset="0x0"
> +	local len=$(printf "%x" $(stat --format='%s' $file))
> +	local order="0"
> +	local split_cmd="$file,$offset,0x${len},$order"
> +	echo $split_cmd > $SPLIT_DEBUGFS
                           ^^^^^^^^^^^^^
$DEBUGFS_MNT/split_huge_pages is good enough.

> +}
> +
>  # Get hugepagesize in bytes
>  _get_hugepagesize()
>  {
> diff --git a/tests/generic/745 b/tests/generic/745
> new file mode 100755
> index 000000000000..0a30dbee35bd
> --- /dev/null
> +++ b/tests/generic/745
> @@ -0,0 +1,97 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2024 Luis Chamberlain. All Rights Reserved.
> +#
> +# FS QA Test No. 734
> +#
> +# Run fsstress in a loop, and in the background force some writeback and
> +# folio splits for every file. If you're enabling this and want to check
> +# underneath the hood you may want to enable:
> +#
> +# dyndbg='file mm/huge_memory.c +p'
> +. ./common/preamble
> +_begin_fstest long_rw stress soak smoketest dangerous_fuzzers

Just double check, is it a dangerous_fuzzers test, and not good to be in auto group?

> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +}
> +
> +# Import common functions.
> +. ./common/filter

I didn't see any filters called in this case, so don't need to
import it.

> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_test

I didn't see TEST_DIR or TEST_DEV in this test case, so don't need
_require_test

> +_require_scratch
> +_require_split_debugfs
> +_require_command "$KILLALL_PROG" "killall"
> +
> +echo "Silence is golden"
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +nr_cpus=$((LOAD_FACTOR * 4))
> +nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
> +
> +fsstress_args=(-w -d $SCRATCH_MNT/test -n $nr_ops -p $nr_cpus)
> +
> +# used to let our loops know when to stop
> +runfile="$tmp.keep.running.loop"
> +touch $runfile
> +
> +# The background ops are out of bounds, the goal is to race with fsstress.
> +
> +# Force folio split if possible, this seems to be screaming for MADV_NOHUGEPAGE
> +# for large folios.
> +while [ -e $runfile ]; do
> +	for i in $(find $SCRATCH_MNT/test \( -type f \) 2>/dev/null); do

May I ask why the "\( .. \)" is needed?

> +		_split_huge_pages_file_full $i >/dev/null 2>&1

Just make sure, don't you want to output to $seqres.full file to get more information
for debug, if something wrong.

> +	done
> +	sleep 2
> +done &
> +split_huge_pages_files_pid=$!

This split_huge_pages_files_pid isn't be used anywhere, you can deal with it in
_cleanup.

> +
> +blocksize=$(_get_file_block_size $SCRATCH_MNT)
> +export XFS_DIO_MIN=$((blocksize * 2))

Oh, I even forgot we have this parameter in fsstress.c :)

> +
> +test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
> +
> +# Our general goal here is to race with ops which can stress folio addition,
> +# removal, edits, and writeback.
> +
> +# zero frequencies for write ops to minimize writeback
> +fsstress_args+=(-R)

But you set "fsstress_args=(-w -d $SCRATCH_MNT/test -n $nr_ops -p $nr_cpus)" above,
so you zeros frequencies of non-write operations (-w) and then zeros frequencies of
write operations (-R). Do you want to use "-z" directly, to zeros frequencies of
all operations ?

> +
> +# XXX: we can improve this, so to increase the chances to allow more
> +# folio splits. Also running generic/447 twice triggers a corner case we can't
> +# capture here on folio splits and write_cache_pages, increasing the chances of
> +# this test to cover that same corner case would be ideal.
> +#
> +# https://gist.github.com/mcgrof/d12f586ec6ebe32b2472b5d634c397df
> +fsstress_args+=(-f creat=1)
> +fsstress_args+=(-f write=1)
> +fsstress_args+=(-f dwrite=1)
> +fsstress_args+=(-f truncate=1)
> +fsstress_args+=(-f zero=1)
> +fsstress_args+=(-f unlink=1)
> +fsstress_args+=(-f fsync=1)
> +fsstress_args+=(-f punch=2)
> +fsstress_args+=(-f copyrange=4)
> +fsstress_args+=(-f clonerange=4)
> +
> +if [[ "$FSTYP" != "xfs" || "$FSTYP" == "ext4" ]]; then
> +	fsstress_args+=(-f collapse=1)

Can you explain why the FALLOC_FL_COLLAPSE_RANGE is special, and not suitable
for xfs?

And I think the range of $FSTYP" != "xfs" contains "$FSTYP" == "ext4", so
this logic makes me confused.

> +fi
> +
> +$FSSTRESS_PROG $FSSTRESS_AVOID "${fsstress_args[@]}" >> $seqres.full
> +
> +rm -f $runfile
> +wait > /dev/null 2>&1

Better to move this to _cleanup. e.g.

rm -f $runfile
[ -n "$split_huge_pages_files_pid" ] && kill $split_huge_pages_files_pid
$KILLALL_PROG -9 fsstress
wait


Thanks,
Zorro
> +
> +status=0
> +exit
> diff --git a/tests/generic/745.out b/tests/generic/745.out
> new file mode 100644
> index 000000000000..fce6b7f5489d
> --- /dev/null
> +++ b/tests/generic/745.out
> @@ -0,0 +1,2 @@
> +QA output created by 745
> +Silence is golden
> -- 
> 2.43.0
> 
> 

