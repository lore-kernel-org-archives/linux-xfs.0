Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7F31FECBA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773431795; cv=none; b=pztZJWG8+U5kIbV72XTepfGZY/ba2pM0UrYJbEQ/A5D7X8O+UPFzFDL6v82WAKRoXJ0nCIRPsoFiHB/ghDshD9AZkH70VsI7dDRPHwPGwa/Nkf82xK+AlG/kQggbWpwG/LTEexDz50EUS2tWHSALi2AtT5g0iej9yhJovaNP8xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773431795; c=relaxed/simple;
	bh=TbNXI1sgug1+SQINKfWnHFrd2YZtnHNCI95ceMOc3OE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3NM5r7M4sJL7jrh3oV050tLO8NHSKNeVhQYXOFRZAg5Nup+KGF0ZbYhDCeZjMlByWU0UskVo2FGzoqeRp/NAt10MhbRnJDFgTdLkYZMm94qGBsl2zIFe4jd1CqnvH/Ri8B+H8A30yRvDpFK9h3TpRpiV9pS9gjZsG1LL2A2kHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JnNPOvjq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iGG+XLRG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JnNPOvjq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iGG+XLRG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773431793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6tZGPsVFRpgxRIi0wCgDCA8FBL8TAUH88fvzRN/KkeE=;
	b=JnNPOvjqJ9xBXja3CGcA04Pna5MEuR4AFLLvGiBvtxoV+uXB7MK6YHkFeeEyC3DlRJF7jL
	FXIwDAedFxH3iVmssScjTWQrRl/Nk3FzSuRiivPkEHrDY/ZkPkrnLBT0MbM6BhH5meXcC2
	eA/f4u00D4PHRYU8Dd88MvBYggqc+GY=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-TCfYP5WtN6K-5jK2S5ZCAA-1; Fri, 13 Mar 2026 15:56:32 -0400
X-MC-Unique: TCfYP5WtN6K-5jK2S5ZCAA-1
X-Mimecast-MFC-AGG-ID: TCfYP5WtN6K-5jK2S5ZCAA_1773431791
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae53ec06b0so154713625ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773431791; x=1774036591; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6tZGPsVFRpgxRIi0wCgDCA8FBL8TAUH88fvzRN/KkeE=;
        b=iGG+XLRGoGTph73clgc0YzUjUOAbce22dWsLYngaGjvx54FrVgQf51n4/WHMOqpfrT
         hI9gsI+lSPqP2J5QxRqtWecFu7v7AWXstAD+wMGVtqTSg4wZosQHvzzt/RtX+So0PXp/
         sjKdgakopduOawS2jhODfweasWr6jX2XepaObTaMy72xE8oDWtXOEp2kMMLJQyFzxX2d
         EtH7NGNPSgQNcmqZ6GYZb22hYJeI92jI6M5W8Zi23nnVoDJdQRaAAUQBxHqYENodz6KP
         gae7HbT2vlJlmvD4mL6tQSBD1JUdrWvBY9dB0ZPdhVWz0P8Xly64Zb22koApHAEcZ0aE
         vzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773431791; x=1774036591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6tZGPsVFRpgxRIi0wCgDCA8FBL8TAUH88fvzRN/KkeE=;
        b=bICzuh646pCA0awRpHz88lm7GwtmaM3phyHTrWoNB0tl4rhtkOPhw+zp0jCo8GxR/L
         Tngc6O7wg7eR4uFLlgvpQmDHF+rBUfmUC9690xdCUPEp4UbVZJa7vPRs1WVNlA2l0dAF
         Vq8o9FLbXR4oYt8DiSbtaOX3lGzMLl770QIy7u9MlQHLCIwZtYGHxiJXVlQR1DPG3J3A
         gQZ6D+oAV5OAdofglekTxv8gdbMRl0RbbQlnyIYbjeTbYTZnT0VhXKoqoBKzdbbYEdnm
         XJ/9clEq+cuiPNf0jnKjhxdeO69xXD3K+qSmVzBBiFtpWDN/rcUbQjCevidhfV5Y/RaN
         n/0w==
X-Forwarded-Encrypted: i=1; AJvYcCWbPa4cCWNksm5tkjMpWI7yFa4gP8CdUww177nnHpCW7LinwrlZFEXNIuWhxy1ri3EWUjwpk5sXG+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHz5tcPDl0QiaDtRDhnQ8adrURpUHA6E76YU4r3mI+zPq5ZyyW
	6nuLU2gPphGhiqMXD8l7aabSsrVGAu1fPjjTtth3lCZOLtzKeMKt4QXki8hquPtvW0LbOyStA6t
	A+onyAGcYa2FwQ0s2NvKtnJ4/j1SMoO0JdGy2tscvjYL6NyVH+zDLdFQ/U20WiT3BsIaDdw==
X-Gm-Gg: ATEYQzy47GACWJKdiQZmcJjiqDkbCkuJVdvTGUjNCZwLaPd6RHrrWQlIsE1iC70Z64E
	7aElLcxAZdDlFcKE8wVpUMtyrsbmgLtf8v95TIyWk1bXbk9JzlQud37vkhWnYNKOxoRMwWXcgxn
	zlnvbhIzajSmGZWkboeez1cLzsodjIGkY8bOL/j2qYSHFYqMVXvtEdhtmh5ZKVmyqcJnbQ2q2mJ
	ijTyXc/lbEKw8hGFzv4kftZ/50bkRTqpe3LjmOnMW96zSfel/yxrbqGw/hzP1Tb6lmrearmN0Jj
	atr+H/LZwxpGqNS9kRIWCOnudW9UVMM1xjZLx4zYuSmfhqm9miaxeFkOJFgmN4p1aZwVDub/HoE
	PUclXIadfhUCI2+YH21TmletDK8cHyN9H20LTmxwU0dmIv9901WsN6uOQqL9DCg==
X-Received: by 2002:a17:903:19e3:b0:2ae:aa16:ad13 with SMTP id d9443c01a7336-2aecab2f6c1mr45561575ad.45.1773431790659;
        Fri, 13 Mar 2026 12:56:30 -0700 (PDT)
X-Received: by 2002:a17:903:19e3:b0:2ae:aa16:ad13 with SMTP id d9443c01a7336-2aecab2f6c1mr45561365ad.45.1773431790194;
        Fri, 13 Mar 2026 12:56:30 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56ca17sm33036915ad.13.2026.03.13.12.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:56:29 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:56:25 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/14] xfs: test xfs_healer background service
Message-ID: <20260313195625.m72q7gmek7wgzitc@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311404015.1186408.8347077076824913709.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311404015.1186408.8347077076824913709.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:53:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that when xfs_healer can monitor and repair filesystems when it's
> running as a systemd service, which is the intended usage model.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/1902     |  152 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1902.out |    2 +
>  2 files changed, 154 insertions(+)
>  create mode 100755 tests/xfs/1902
>  create mode 100755 tests/xfs/1902.out
> 
> 
> diff --git a/tests/xfs/1902 b/tests/xfs/1902
> new file mode 100755
> index 00000000000000..6de2d602d52cdb
> --- /dev/null
> +++ b/tests/xfs/1902
> @@ -0,0 +1,152 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1902
> +#
> +# Ensure that autonomous self healing fixes the filesystem correctly when
> +# running in a systemd service
> +#
> +# unreliable_in_parallel: this test runs the xfs_healer systemd service, which
> +# cannot be isolated to a specific testcase with the way check-parallel is
> +# implemented.
> +#
> +. ./common/preamble
> +_begin_fstest auto selfhealing unreliable_in_parallel
> +
> +_cleanup()
> +{
> +	cd /
> +	if [ -n "$new_svcfile" ]; then
> +		rm -f "$new_svcfile"
> +		systemctl daemon-reload
> +	fi
> +	rm -r -f $tmp.*
> +}
> +
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/systemd
> +
> +_require_systemd_is_running
> +_require_systemd_unit_defined xfs_healer@.service
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
> +# Break the directory
> +_scratch_unmount
> +_scratch_xfs_db -x \
> +	-c 'path /some/victimdir' \
> +	-c 'bmap' \
> +	-c 'dblock 1' \
> +	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
> +
> +# Find the existing xfs_healer@ service definition, figure out where we're
> +# going to land our test-specific override
> +orig_svcfile="$(_systemd_unit_path "xfs_healer@-.service")"
> +test -f "$orig_svcfile" || \
> +	_notrun "cannot find xfs_healer@ service file"
> +
> +new_svcdir="$(_systemd_runtime_dir)"
> +test -d "$new_svcdir" || \
> +	_notrun "cannot find runtime systemd service dir"
> +
> +# We need to make some local mods to the xfs_healer@ service definition
> +# so we fork it and create a new service just for this test.
> +new_healer_template="xfs_healer_fstest@.service"
> +new_healer_svc="$(_systemd_service_unit_path "$new_healer_template" "$SCRATCH_MNT")"
> +_systemd_unit_status "$new_healer_svc" 2>&1 | \
> +	grep -E -q '(could not be found|Loaded: not-found)' || \
> +	_notrun "systemd service \"$new_healer_svc\" found, will not mess with this"
> +
> +new_svcfile="$new_svcdir/$new_healer_template"
> +cp "$orig_svcfile" "$new_svcfile"
> +
> +# Pick up all the CLI args except for --repair and --no-autofsck because we're
> +# going to force it to --autofsck below
> +execargs="$(grep '^ExecStart=' $new_svcfile | \
> +	    sed -e 's/^ExecStart=\S*//g' \
> +	        -e 's/--no-autofsck//g' \
> +		-e 's/--repair//g')"
> +sed -e '/ExecStart=/d' -e '/BindPaths=/d' -e '/ExecCondition=/d' -i $new_svcfile
> +cat >> "$new_svcfile" << ENDL
> +
> +[Service]
> +ExecCondition=$XFS_HEALER_PROG --supported %f
> +ExecStart=$XFS_HEALER_PROG $execargs
> +ENDL
> +_systemd_reload
> +
> +# Emit the results of our editing to the full log.
> +systemctl cat "$new_healer_svc" >> $seqres.full
> +
> +# Remount, with service activation
> +_scratch_mount
> +
> +old_healer_svc="$(_xfs_healer_svcname "$SCRATCH_MNT")"
> +_systemd_unit_stop "$old_healer_svc" &>> $seqres.full
> +_systemd_unit_start "$new_healer_svc" &>> $seqres.full
> +
> +_systemd_unit_status "$new_healer_svc" 2>&1 | grep -q 'Active: active' || \
> +	echo "systemd service \"$new_healer_svc\" not running??"
> +
> +# Access the broken directory to trigger a repair, then poll the directory
> +# for 5 seconds to see if it gets fixed without us needing to intervene.
> +ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +_filter_scratch < $tmp.err
> +try=0
> +while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> +	echo "try $try saw corruption" >> $seqres.full
> +	sleep 0.1
> +	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +	try=$((try + 1))
> +done
> +echo "try $try no longer saw corruption or gave up" >> $seqres.full
> +_filter_scratch < $tmp.err
> +
> +# List the dirents of /victimdir to see if it stops reporting corruption
> +ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +try=0
> +while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> +	echo "retry $try still saw corruption" >> $seqres.full
> +	sleep 0.1
> +	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +	try=$((try + 1))
> +done
> +echo "retry $try no longer saw corruption or gave up" >> $seqres.full
> +
> +# Unmount to kill the healer
> +_scratch_kill_xfs_healer
> +journalctl -u "$new_healer_svc" >> $seqres.full
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1902.out b/tests/xfs/1902.out
> new file mode 100755
> index 00000000000000..84f9b9e50e1e02
> --- /dev/null
> +++ b/tests/xfs/1902.out
> @@ -0,0 +1,2 @@
> +QA output created by 1902
> +ls: reading directory 'SCRATCH_MNT/some/victimdir': Structure needs cleaning
> 

