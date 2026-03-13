Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E205F32A3FD
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773428034; cv=none; b=fNvh5G3dFkM9fegxJmzVinDJDpYBkUBVG05UfSm/HsyJ12vi1Sm8xBsu0ar8AYqghBKZnUkixAyFRqPZHs+IdpADLJjkMlQov42nct+e1O2/VOvQmWwG5jqEz6ZMcJfvUkahHcmuI+/mpFvSNhtYd6P9UCukRlhV903HpNS+1pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773428034; c=relaxed/simple;
	bh=fiX3dLaDKkTJ8AzkOojn/ylV+qAkxyXU5sjdDzoGfQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s70cl9QparvU81O+6me74xeEzd2lyUBTbmcrVAJ10sYlpwYX781MxQWcx77khPKUVX7cths2zIRelo0h/ltsKQEHaeU+DUAcP7VkyRfT6f8j8QxsJlOVEhUAcHTw3ygVCSZC3vzOOuDe10eRUY8pkg35Uv21S1cjRydM69VU6fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IzA10+8S; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ewnroe3X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IzA10+8S";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewnroe3X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773428031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YVTDRbeVYUMemjP79G0TcdV/DrYN4LEMASqzNTpFd+8=;
	b=IzA10+8SJfcaEzCeBQhOtJBrmwL3NFhnFbiyKgFmFfAQo/z4TBzqNPId1k0k0mICPtMepf
	SQX8w7yUydUYdElG7C/fHu3CWf9xsJAESNQNmjZb10BMxlKinzP8UK8OszDYxk678HTN2P
	td584wCdqq1T5JKp/JIwL9n7hMpREMo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-9-kGI_6HOAiXL-rIzqs2pA-1; Fri, 13 Mar 2026 14:53:50 -0400
X-MC-Unique: 9-kGI_6HOAiXL-rIzqs2pA-1
X-Mimecast-MFC-AGG-ID: 9-kGI_6HOAiXL-rIzqs2pA_1773428029
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aed1beaa73so8833415ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 11:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773428029; x=1774032829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVTDRbeVYUMemjP79G0TcdV/DrYN4LEMASqzNTpFd+8=;
        b=ewnroe3XziDp664FXNCExhZRT1PWkAixvGc5mE7o6SoP5cFE68lzVRCkLhWqWBxNAp
         4MM06jHYqUqAqAmQcrDfzRaDTmcOxJlONUm6xGSIFa1TMyq6jkBhuX1nqcHNAC4JyJF1
         lUuGVkEGTBwA6IOIRHtLjQmx79WWuHnegwt1wIJ0nYBGWt64kv5gpgio/Gc2XNSaT1uq
         TTa95FXx0r1Mel6ScxBTMQ+CnmaLL71SMp6hwTeuTDCicGn1Ru4IF3JXaE6spQ0wOOwO
         ehJO+zMbTo0Pc2Neg44PysvyjRhLA5dr07S2YF8Hvnn/TQTZZjOzP7tG7Air0DdcrKGt
         8sMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773428029; x=1774032829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVTDRbeVYUMemjP79G0TcdV/DrYN4LEMASqzNTpFd+8=;
        b=gl7o64h6Jfc/07vFqbPL84uCQscMiLABIqrX01zRGa9/r53SlsjS1IsMLhoixoY+ur
         JHDZW7s4lMcr8O6yWCvcfgH0TYY+WGO8Dm6PzdR+/dqhlxMXAm+gfQIODPWUDIzzh5bG
         x17TSVvDd//ImoFAL4jyoED1FV05iJOKig/sVPhYpAkMjJyiNvkOk88BhyLOW4fQO6CT
         JHtpQ+1lYFkZYnwl5/BE84/UUqCFYZgcfTKlPkrvayJcYIROdGorewW+CS8NGqQ2asnp
         EEyBXdCjVGBzb2wP7WWfu6ZfmML1kbG9lZvczc6g0HBCpbmm4XY3BhMisRP2geCYSkYV
         jieA==
X-Forwarded-Encrypted: i=1; AJvYcCWGdlnRSKXMQLaCa3L/d7GUBAA4pvbILD56zKyxGo7MboR4+mj/A59Gm7iia7tWmykQCtZe2YJjAMw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1B5krdpqDdle5s2vu+lwKDH9FjG0KrfM17uN8GdLWNr5Whrc5
	/BUVUpHpBZXwDOuxg1NYSdkepWOqvhbnHbPQRp0weC2b+tjHSbRQ7ielc+F2T4ASmbpbfYub0Fh
	E+76Kjztz0rk85FkCYODubkRdUKOWFGP7ip8du3eGhBJPMHNEhg3eNbmZPjBhUg==
X-Gm-Gg: ATEYQzxi7PgfFsdjJvSGMLa8yoAgRgCLFtcsU8e0cC+bz77hpAh7lovEelEYH3e7qD3
	9C2zVwJ2V4Kh4UV2sNQgeVwY9DJq4KQrlDyWQumO4zeqgfeZLuvR3LTCYELXs8djNLlr8D2tZxQ
	soV/tHOMiIDZLKlmFBHLa7fnjJiG9hGRbGQ9fNrR9Cjhn/agv6T3DznVP5xn8N4y+ooJCxxWWgr
	8Y2bJCn/9VNakmXxBwMfH8b58EuoHyT6R1fWFo5dLfVnqDiRRhSVlUl3bbape3CZK9S+TSIyW9H
	7+0CJR4eegdIbGz2D2w9hOwe+soBCB8bpnPPJTrAYOZW4V9FbZ04IHVYuKkT7Wc5O2ZJ+npW5iC
	c020SrNyJeA49oQadMiz8qZpm+oqMZT8NwkUS/ym8TEDn32QEI6SORcgXrvxNng==
X-Received: by 2002:a17:902:d492:b0:2ae:6192:8d78 with SMTP id d9443c01a7336-2aeca92b73bmr41543635ad.1.1773428029360;
        Fri, 13 Mar 2026 11:53:49 -0700 (PDT)
X-Received: by 2002:a17:902:d492:b0:2ae:6192:8d78 with SMTP id d9443c01a7336-2aeca92b73bmr41543195ad.1.1773428028334;
        Fri, 13 Mar 2026 11:53:48 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56ea5bsm39978325ad.5.2026.03.13.11.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 11:53:47 -0700 (PDT)
Date: Sat, 14 Mar 2026 02:53:44 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: test io error reporting via healthmon
Message-ID: <20260313185344.nlwn3swby6iht5cw@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403831.1186408.9334207319061853105.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403831.1186408.9334207319061853105.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:50:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new test to make sure the kernel can report IO errors via
> health monitoring.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/xfs/1878     |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1878.out |   10 ++++++
>  2 files changed, 103 insertions(+)
>  create mode 100755 tests/xfs/1878
>  create mode 100644 tests/xfs/1878.out
> 
> 
> diff --git a/tests/xfs/1878 b/tests/xfs/1878
> new file mode 100755
> index 00000000000000..1ff6ae040fb193
> --- /dev/null
> +++ b/tests/xfs/1878
> @@ -0,0 +1,93 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1878
> +#
> +# Attempt to read and write a file in buffered and directio mode with the
> +# health monitoring program running.  Check that healthmon observes all four
> +# types of IO errors.
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
> +	_dmerror_cleanup
> +}
> +
> +. ./common/filter
> +. ./common/dmerror
> +
> +_require_scratch_nocheck
> +_require_xfs_io_command healthmon
> +_require_dm_target error
> +
> +filter_healer_errors() {
> +	_filter_scratch | \
> +		grep -E '(buffered|directio)' | \
> +		sed \
> +		    -e 's/ino [0-9]*/ino NUM/g' \
> +		    -e 's/gen 0x[0-9a-f]*/gen NUM/g' \
> +		    -e 's/pos [0-9]*/pos NUM/g' \
> +		    -e 's/len [0-9]*/len NUM/g' \
> +		    -e 's|SCRATCH_MNT/a|VICTIM|g' \
> +		    -e 's|SCRATCH_MNT ino NUM gen NUM|VICTIM|g' | \
> +		uniq
> +}
> +
> +# Disable the scratch rt device to avoid test failures relating to the rt
> +# bitmap consuming all the free space in our small data device.
> +unset SCRATCH_RTDEV
> +
> +echo "Format and mount"
> +_scratch_mkfs > $seqres.full 2>&1
> +_dmerror_init no_log
> +_dmerror_mount
> +
> +_require_fs_space $SCRATCH_MNT 65536
> +
> +# Create a file with written regions far enough apart that the pagecache can't
> +# possibly be caching the regions with a single folio.
> +testfile=$SCRATCH_MNT/fsync-err-test
> +$XFS_IO_PROG -f \
> +	-c 'pwrite -b 1m 0 1m' \
> +	-c 'pwrite -b 1m 10g 1m' \
> +	-c 'pwrite -b 1m 20g 1m' \
> +	-c fsync $testfile >> $seqres.full
> +
> +# First we check if directio errors get reported
> +$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT >> $tmp.healthmon &

healer_pid=$!

> +sleep 1	# wait for program to start up
> +_dmerror_load_error_table
> +$XFS_IO_PROG -d -c 'pwrite -b 256k 12k 16k' $testfile >> $seqres.full
> +$XFS_IO_PROG -d -c 'pread -b 256k 10g 16k' $testfile >> $seqres.full
> +_dmerror_load_working_table
> +
> +_dmerror_unmount
> +wait	# for healthmon to finish

unset healer_pid

> +_dmerror_mount
> +
> +# Next we check if buffered io errors get reported.  We have to write something
> +# before loading the error table to ensure the dquots get loaded.
> +$XFS_IO_PROG -c 'pwrite -b 256k 20g 1k' -c fsync $testfile >> $seqres.full
> +$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT >> $tmp.healthmon &

healer_pid=$!

> +sleep 1	# wait for program to start up
> +_dmerror_load_error_table
> +$XFS_IO_PROG -c 'pread -b 256k 12k 16k' $testfile >> $seqres.full
> +$XFS_IO_PROG -c 'pwrite -b 256k 20g 16k' -c fsync $testfile >> $seqres.full
> +_dmerror_load_working_table
> +
> +_dmerror_unmount
> +wait	# for healthmon to finish

unset healer_pid

> +
> +# Did we get errors?
> +cat $tmp.healthmon >> $seqres.full
> +filter_healer_errors < $tmp.healthmon
> +
> +_dmerror_cleanup
> +
> +status=0
> +exit

_exit 0

Others look good to me, I'll change these when I merge this patch.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> diff --git a/tests/xfs/1878.out b/tests/xfs/1878.out
> new file mode 100644
> index 00000000000000..f64c440b1a6ed1
> --- /dev/null
> +++ b/tests/xfs/1878.out
> @@ -0,0 +1,10 @@
> +QA output created by 1878
> +Format and mount
> +pwrite: Input/output error
> +pread: Input/output error
> +pread: Input/output error
> +fsync: Input/output error
> +VICTIM pos NUM len NUM: directio_write: Input/output error
> +VICTIM pos NUM len NUM: directio_read: Input/output error
> +VICTIM pos NUM len NUM: buffered_read: Input/output error
> +VICTIM pos NUM len NUM: buffered_write: Input/output error
> 

