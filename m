Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7C1313E3F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 18:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773426942; cv=none; b=mBKz/Na1BWoO2H3/nxL4WdF00R4xDEAAMRjsUMq6i414suKp5g47pqPw7IP2vYEuC0uL4+2z8C7srT3YNZO4KO9jkry3vol9hjcZ+goN9NqZ5wm/Jh0gayoy/GGYjk77KdLErC6TKlSzWZLMSpe7gdCMqqvB+b/ZXWCpBj6TMc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773426942; c=relaxed/simple;
	bh=C+C7Hq9RfsHLmfpwq9IWWel1EXBKsEjt5ny2Kqq6sFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCG/nZP3pY1bastP1fSa6LSbXaMMWI8+FlLiMZkQvvx53PxBLBJht2uhHl531iYthg+mXxvwlNPBV8owvlTBlwOthx+X7jP7oM1zYmJIWI8+y4TfGPjS1Dmq1WDXMwXXoBjSM8fmUZnVK2EDy2vIH92Jftu+fqKJEx5dJpc154Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jt8ZMms+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=X2mnsLiy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jt8ZMms+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2mnsLiy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773426940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGg1ehoJ3UZZ5E5AzBVQaHQTybGzojLcsJEBh4pbVNQ=;
	b=Jt8ZMms+LYwp1MR2aAACRBQztsEYOqLYW7yTlrNjDdOD0A5sfp1TKZWaou9AzhqESLt4Vt
	4bVO4GrN7mjq3/tq36efgVXDsktxW6lLl5qPUxP1+xVbD4pT1DgHCgmS+WtJLjQmrFhVGq
	a0YT2MJ55tKbBz56CedjmFWZH8FkD6I=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-3X0oyUkYNGGTXjYnjks4Cg-1; Fri, 13 Mar 2026 14:35:38 -0400
X-MC-Unique: 3X0oyUkYNGGTXjYnjks4Cg-1
X-Mimecast-MFC-AGG-ID: 3X0oyUkYNGGTXjYnjks4Cg_1773426938
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c73783c96baso1129267a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 11:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773426938; x=1774031738; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xGg1ehoJ3UZZ5E5AzBVQaHQTybGzojLcsJEBh4pbVNQ=;
        b=X2mnsLiyTMM6m48lCtwAZYUrlwlzZdagz1ATBOfqr+fJeWzmPmgg2osoYclzk8GboS
         52rEGsSik7ZjRufOBZR/kQ15MJ8F8EE18yP/DRegqyPrfBV2gYe1oXO5BOYH5+W4Fj+V
         DEnyIpEFHqDfo8DWmvPPBUAhyQn5zWGAPLN7MjDuzdSsLzTK/JSoXvzvGiJk7HjqRNJI
         feh+LEjjeblEOX9Wp9pWxLDKmLnWdI16CecqeXVZkLlDPR2s3YsMaYQSD9Q/iKx5SY8o
         r9jSNfVn5xotV5zO0dVudogUWojvGhfT1FCvz3YM9SkI2JopPJpE3NEEBrGg7BNtx8PR
         kF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773426938; x=1774031738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGg1ehoJ3UZZ5E5AzBVQaHQTybGzojLcsJEBh4pbVNQ=;
        b=Y9XRFsZyyidIsA44UTgJsxZsuzRrnvBtffDrsRBN0Rb2shDU0aHwB+u8TfWnKZ3iDW
         RTmETdAiXO5zWwaZbJeFw8DESh/Bylegt6GY+tDnLZTxrZlCMtajtP6uuxRdo/yaIktL
         uu7PIMaX4rZnP2XBm4vm5B3rQQeNk+QfhAV7DEP5Jg+eVXRVmdt1VI88c1edeKtbhUFW
         UN7dh6S5xjHICj1wiDumS5eN6PSvV+RXMIvMDHLAIbYBU2WxelxPkJojm++186gjKai8
         ATAVkjvuU5PMqB+L+WmuMryI8pmBg94xpGY58HVJ2XFVqluPZK5fj7/aCtEC1qTfjUBc
         d20g==
X-Forwarded-Encrypted: i=1; AJvYcCUgtViMfWswCqJLAA43HS/YD5izm/U2M/Sy7Lp2W5KnsZhsi2ImMJ+9yZLimsNRPHYbDMT17XNFp80=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF/PEKY4Kl7lK6g0RDvS7JjmMDGPQ/eAVnJdlK62ayeKe7WeQ9
	ZRITVs7d3uPI+vj7OvKQZ45wWACE0iGBNjwhPL5Iz/uyRereNUS3vNujZ/7JbK22WAR4poljNPl
	cFIRHd6RbcxoDTO3vSoWfQe1QfRwA65BNGO5wDYAAh/SG/U1lRsl4txAOsKFnBA==
X-Gm-Gg: ATEYQzzyMKk/1unwK+CnNwgODQBCcX+hZ+8G7MGX5rIU/BQAZonneAiaP9ju0GxPlBj
	53+fY3+Lx1Bs4lwq7buh44a7+h0B0mh7Uuum2eIhQB4MJ4a9JhlqRAnx/QmRgrgA3sJieghtiYz
	OWDmtfrWpw9+sqXj2IyN0fK79aUGwasZULKa0HXSwtKQA1nLg4DYalv+WajOUWHzI0VXOtEolji
	MlSCHBAGaP7FmIHsT7uBnwoF94bHkKfNXSp6vwwIenHmXHofC2/IFZENAg1SxaEQPMkxRmF/cj3
	05ucJzWVE60Jm9uT5W1JgPviynTLgcSmkIT7e109ZdoUdz7lgLDqzm+689M+oleAfjmyqmUoONi
	ETSJmiL2OgfeQWEwTTkcyKsILTo2TV6nTE9yYqXLGWxr4lSQp56fQwfAaER71XA==
X-Received: by 2002:a05:6a21:a345:b0:398:6b26:dbfb with SMTP id adf61e73a8af0-398ecd72520mr3976597637.49.1773426937677;
        Fri, 13 Mar 2026 11:35:37 -0700 (PDT)
X-Received: by 2002:a05:6a21:a345:b0:398:6b26:dbfb with SMTP id adf61e73a8af0-398ecd72520mr3976568637.49.1773426937070;
        Fri, 13 Mar 2026 11:35:37 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0725be23sm6350248b3a.15.2026.03.13.11.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 11:35:36 -0700 (PDT)
Date: Sat, 14 Mar 2026 02:35:32 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/14] xfs: test for metadata corruption error reporting
 via healthmon
Message-ID: <20260313183532.eletb2euiscm5yol@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403813.1186408.6579877651738146939.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403813.1186408.6579877651738146939.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:50:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Check if we can detect runtime metadata corruptions via the health
> monitor.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/xfs/1879     |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1879.out |    8 ++++
>  2 files changed, 101 insertions(+)
>  create mode 100755 tests/xfs/1879
>  create mode 100644 tests/xfs/1879.out
> 
> 
> diff --git a/tests/xfs/1879 b/tests/xfs/1879
> new file mode 100755
> index 00000000000000..75bc8e3b5f4316
> --- /dev/null
> +++ b/tests/xfs/1879
> @@ -0,0 +1,93 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1879
> +#
> +# Corrupt some metadata and try to access it with the health monitoring program
> +# running.  Check that healthmon observes a metadata error.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick eio selfhealing
> +
> +_cleanup()
> +{
> +	cd /

test -n "$healer_pid" && kill $healer_pid &>/dev/null
wait

> +	rm -rf $tmp.* $testdir
> +}
> +
> +. ./common/filter
> +
> +_require_scratch_nocheck
> +_require_scratch_xfs_crc # can't detect minor corruption w/o crc
> +_require_xfs_io_command healthmon
> +
> +# Disable the scratch rt device to avoid test failures relating to the rt
> +# bitmap consuming all the free space in our small data device.
> +unset SCRATCH_RTDEV
> +
> +echo "Format and mount"
> +_scratch_mkfs -d agcount=1 | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> +. $tmp.mkfs
> +_scratch_mount
> +mkdir $SCRATCH_MNT/a/
> +# Enough entries to get to a single block directory
> +for ((i = 0; i < ( (isize + 255) / 256); i++)); do
> +	path="$(printf "%s/a/%0255d" "$SCRATCH_MNT" "$i")"
> +	touch "$path"
> +done
> +inum="$(stat -c %i "$SCRATCH_MNT/a")"
> +_scratch_unmount
> +
> +# Fuzz the directory block so that the touch below will be guaranteed to trip
> +# a runtime sickness report in exactly the manner we desire.
> +_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" -c 'fuzz bhdr.hdr.owner add' -c print &>> $seqres.full
> +
> +# Try to allocate space to trigger a metadata corruption event
> +echo "Runtime corruption detection"
> +_scratch_mount
> +$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT > $tmp.healthmon &

healer_pid=$!

> +sleep 1	# wait for program to start up
> +touch $SCRATCH_MNT/a/farts &>> $seqres.full
> +_scratch_unmount
> +
> +wait	# for healthmon to finish

unset healer_pid

Others look good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +
> +# Did we get errors?
> +check_healthmon()
> +{
> +	cat $tmp.healthmon >> $seqres.full
> +	_filter_scratch < $tmp.healthmon | \
> +		grep -E '(sick|corrupt)' | \
> +		sed -e 's|SCRATCH_MNT/a|VICTIM|g' \
> +		    -e 's|SCRATCH_MNT ino [0-9]* gen 0x[0-9a-f]*|VICTIM|g' | \
> +		sort | \
> +		uniq
> +}
> +check_healthmon
> +
> +# Run scrub to trigger a health event from there too.
> +echo "Scrub corruption detection"
> +_scratch_mount
> +if _supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV; then
> +	$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT > $tmp.healthmon &
> +	sleep 1	# wait for program to start up
> +	$XFS_SCRUB_PROG -n $SCRATCH_MNT &>> $seqres.full
> +	_scratch_unmount
> +
> +	wait	# for healthmon to finish
> +
> +	# Did we get errors?
> +	check_healthmon
> +else
> +	# mock the output since we don't support scrub
> +	_scratch_unmount
> +	cat << ENDL
> +VICTIM directory: corrupt
> +VICTIM directory: sick
> +VICTIM parent: corrupt
> +ENDL
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1879.out b/tests/xfs/1879.out
> new file mode 100644
> index 00000000000000..2f6acbe1c4fb22
> --- /dev/null
> +++ b/tests/xfs/1879.out
> @@ -0,0 +1,8 @@
> +QA output created by 1879
> +Format and mount
> +Runtime corruption detection
> +VICTIM directory: sick
> +Scrub corruption detection
> +VICTIM directory: corrupt
> +VICTIM directory: sick
> +VICTIM parent: corrupt
> 

