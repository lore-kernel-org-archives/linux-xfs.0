Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE722E62B7
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773431323; cv=none; b=eN25luAySANySQoJzylpCe0cs/mZo9ikE3S1ap5P1mbtAJNn4wowf0ljlJv3jzPUqX3LwlX8ZsRQ2slVkAK4BquJ9RjJmtcJjkpcQUEz+rkePZ237HFAVU+LvCHejb4KS50F72O9TethYoqwtxA5z8JS9HezhVc3ivl2AnDi3gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773431323; c=relaxed/simple;
	bh=mZPY8nTrnKHOnFexUlrscyFSq1eAaLDfCFQKfBNhlZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPVc0n52j2JXZTJIbGYBaWqLt6coRUOfHfbLq/yKGvJ5+Is8fQG8744kgGPm2XD8dDKtRw03yBz7Uwxsu7lys118Jt82XSVkF//Kek9tW+PrLU/mXgiW0/1Nstnyi9WbgdICKzMRBzDiKtP+0IeWbe1eV3FnnQudzCquce114lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IgPx5kjC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ov2GNYgJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IgPx5kjC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ov2GNYgJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773431321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fuq+2KVuAj3637lQGm/+ZOyEsMtxD8FrsDXfJtf7qWs=;
	b=IgPx5kjCoV5iAc15jvWWcLOc/lxJOmJK4CPXMUNq3pFFHlxU1UGfjJV0xtd/86SBTUHwk+
	IYJzcuFqeFEYymKHhiMKYbkK1w4E6GUnvs+75unilFrtk7xG83qm2RZ1rkR7d6R3qAQCRL
	IURF/hupffBWhslyyw45tuR5A3OI9G8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-b1lJ8OhKN9GXaZhIfR0XlQ-1; Fri, 13 Mar 2026 15:48:40 -0400
X-MC-Unique: b1lJ8OhKN9GXaZhIfR0XlQ-1
X-Mimecast-MFC-AGG-ID: b1lJ8OhKN9GXaZhIfR0XlQ_1773431319
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso3234014a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773431319; x=1774036119; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fuq+2KVuAj3637lQGm/+ZOyEsMtxD8FrsDXfJtf7qWs=;
        b=Ov2GNYgJ8o9/JXEnkQnr1xNUnxPhXLx/rV/qP1RucEe6ShNEUznMLjl+CrgxDFCC9M
         EIN3eOP0JWvKLDdL5NuzvUoEr1BN4TemDi0aoIKMD6TO/WKGwuGkq5gJpqqlX9OfdXAp
         W2/Dv1Y92sYPruCSUA38y8oYWFVigksTXnQHnjkfruJlxypSBhkLs7MmnBKdV/XPs+iu
         /RDaGC8nIaZbydGmWNs69BICRJuuHcDqZB4CAFm+bxSP4ZOCWOhWaQlucjyDc6eXlp1N
         1LH6bFu0kzNcyHodWJJ2h9VXXA+A3wIDVI6rRPBnwmb5nJVRxKPZlXzwJNRzlm0W5meE
         BWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773431319; x=1774036119;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fuq+2KVuAj3637lQGm/+ZOyEsMtxD8FrsDXfJtf7qWs=;
        b=Br8bV7YKP13eEmVD+0dj2xl579APhZe3oym5tmvth5iNHPfRcJnhs+w185zv+RFQyK
         HFi+cEEIwWFPCf36BjgVaavhH5sS6i4DGCUba99//ZpaHnqAEeWMJMvJN/CMppSzDe8+
         4RivFqEzqXAjPe0PCgRTzHOEQQMNEqHwgu9LSDtqdnImbJj1Mh5vWwnv090+dkFVp7S7
         RQeq5RVTzn2HykyhrVWtAkJo2XRnZZOAqeMXRqrccPwx+44ulsNByr8oQUvJ1XAgNGPV
         hTe93kjqoxqxOdJgSVXTGkym8iIhhxcoAd44yG+jMEyNmzulFW2jBeolHboaYOWQdaXj
         VGAw==
X-Forwarded-Encrypted: i=1; AJvYcCVeFPnxKcMFU+JOlY1rFOM4Tuslw6K4YxI3etN/l571oI1SV/eObQ+aCaY2Ln/P4I8t9Zw9aTXIMCk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkA8UPUeSS3LlASv6EZS5RzYKFMH1FDns0+psWiY0JUCTEMt3j
	wmCg+iqMMhNYxus+DAaRW2uMO/Ce59wF/Ik1EJrwbD+F3rrVTVW4Mcl/1n+2fdIBNRCkfyr3OSd
	GD8mg+SQG8/+oZ27iU78+pGl7GekE5/ROg80+bniVUsXVRMwT5O3aU+y5GhiVACu3nvNgFQ==
X-Gm-Gg: ATEYQzwsz0cUtJXi4ZGoJUHt40PFVVCi5Y8c9HAgwHZY7D8chX6vVxrFHQwgO6asY5B
	SB+m201x9bzUqCEbAtBnK9kndJFlwoDI56/4aZ3f10ZT+TWydLD+MBzSfwmnVq8C5V+IqLn/uwf
	Yj46bWnk5wwkYFiSqHjZsK++Rg1wyh+vzx5q12mo8oLsoyWW8O271FQusbNX4FpU+oCE/YU/KgN
	TcXgXxbKbJlTsbl9nglSCnTbjxCQHNItCW/GuzKTFK/lNvazLJESGh2VDEITnbY1m16HGADWqVL
	5bNWMVHadvfUgpdJJLO0ODzWz5X2EgsXUy8I7gGRln26kAKbWqCoNfVZqBo639/pAtWkI/39Cqq
	2InWk4O+uxhwk1NOnxLHBpJ9QOZMSA4TNRBn6QhvtG2WCQ2SIM9GB22EDSwbkmw==
X-Received: by 2002:a17:90b:52cc:b0:353:49f2:1e7a with SMTP id 98e67ed59e1d1-35a21feda5bmr3797446a91.17.1773431318651;
        Fri, 13 Mar 2026 12:48:38 -0700 (PDT)
X-Received: by 2002:a17:90b:52cc:b0:353:49f2:1e7a with SMTP id 98e67ed59e1d1-35a21feda5bmr3797426a91.17.1773431318219;
        Fri, 13 Mar 2026 12:48:38 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a241c13absm1369900a91.3.2026.03.13.12.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:48:37 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:48:34 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/14] xfs: test xfs_healer can initiate full filesystem
 repairs
Message-ID: <20260313194834.qscjtk62idrmhd66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403959.1186408.14105703850831556113.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403959.1186408.14105703850831556113.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:52:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that when xfs_healer can't perform a spot repair, it will actually
> start up xfs_scrub to perform a full scan and repair.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/1899     |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1899.out |    3 +
>  2 files changed, 111 insertions(+)
>  create mode 100755 tests/xfs/1899
>  create mode 100644 tests/xfs/1899.out
> 
> 
> diff --git a/tests/xfs/1899 b/tests/xfs/1899
> new file mode 100755
> index 00000000000000..5d35ca8265645f
> --- /dev/null
> +++ b/tests/xfs/1899
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1899
> +#
> +# Ensure that autonomous self healing works fixes the filesystem correctly
> +# even if the spot repair doesn't work and it falls back to a full fsck.
> +#
> +. ./common/preamble
> +_begin_fstest auto selfhealing
> +
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/systemd
> +
> +_require_scrub
> +_require_xfs_io_command "repair"	# online repair support
> +_require_xfs_db_command "blocktrash"
> +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> +_require_command "$XFS_PROPERTY_PROG" "xfs_property"
> +_require_scratch
> +_require_systemd_unit_defined "xfs_scrub@.service"
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
> +filter_healer() {
> +	_filter_scratch | \
> +		grep 'Full repairs in progress' | \
> +		uniq
> +}
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
> +	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' \
> +	-c 'path /a' \
> +	-c 'bmap -a' \
> +	-c 'ablock 1' \
> +	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' \
> +	>> $seqres.full
> +_scratch_mount
> +
> +_scratch_invoke_xfs_healer "$tmp.healer" --repair
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
> +# Wait for the background fixer to finish
> +svc="$(_xfs_scrub_svcname "$SCRATCH_MNT")"
> +_systemd_unit_wait "$svc"
> +
> +# List the dirents of /victimdir and parent pointers of /a to see if they both
> +# stop reporting corruption
> +(ls $SCRATCH_MNT/some/victimdir ; $XFS_IO_PROG -c 'parent') > /dev/null 2> $tmp.err
> +try=0
> +while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> +	echo "retry $try still saw corruption" >> $seqres.full
> +	sleep 0.1
> +	(ls $SCRATCH_MNT/some/victimdir ; $XFS_IO_PROG -c 'parent') > /dev/null 2> $tmp.err
> +	try=$((try + 1))
> +done
> +echo "retry $try no longer saw corruption or gave up" >> $seqres.full
> +
> +# Unmount to kill the healer
> +_scratch_kill_xfs_healer
> +cat $tmp.healer >> $seqres.full
> +cat $tmp.healer | filter_healer
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1899.out b/tests/xfs/1899.out
> new file mode 100644
> index 00000000000000..5345fd400f3627
> --- /dev/null
> +++ b/tests/xfs/1899.out
> @@ -0,0 +1,3 @@
> +QA output created by 1899
> +ls: reading directory 'SCRATCH_MNT/some/victimdir': Structure needs cleaning
> +SCRATCH_MNT: Full repairs in progress.
> 

