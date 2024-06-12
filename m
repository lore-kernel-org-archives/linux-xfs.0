Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F7916B73F
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 08:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718179265; cv=none; b=q+5InhP6FO/wcvoUBlu7zXPP7Z06L7bUB3nDTuW7lZ8Tfm2ApF4Ln53NKkFk9Akjrcd5W5jYHmq3s6hG9S55Trw8nfnAhvsD2Bf1IZWt5lsTTC6UCU+YDxAMqR9yLPN7R7fKkiPi9my5bEnWCZuiFclkj/Lm1vyGnvv3ya5XwUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718179265; c=relaxed/simple;
	bh=0OWZytV7iidTSRsiJbmntqWHMzCgSbj+2IHoc91k3X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BY1bx4tmqC9fkRCvA76Gdrps45W348IAl8YX8yCl7MR8wgBP01krwdujIloh5ng1rWro4AdW0E52REa1+I+NeTmseArdEBXz3irFrn2NQoB2cG6eFIDHO3eJ83+0E/3kBYQGNI1kF0E1ww6+LLQBSjTQb148pTHIx/+w/H6bgWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R2QO4Su2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R2QO4Su2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718179263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p/SC79B0SQx0Kv68DpQnR4beG6Hiq5QD/FW1/evjIEo=;
	b=R2QO4Su2EeoG/thGXVZTzTtlJu+3g+LBjSGXwOcXz40Fap/GV8nIUuSSBOozmG7b+yNFKB
	DtDXufRG1huFD9qXBfRcyKeXlbU6RmxXDnd4tmKKLoPIiG6FbBOHeXVS2ZE3fT94b9uSY6
	VUsHjKeSBMv/jqbbz/vtjYkvb/1rFLQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-AKZpCNk6ODeQLii5uVKiJg-1; Wed, 12 Jun 2024 04:00:58 -0400
X-MC-Unique: AKZpCNk6ODeQLii5uVKiJg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-701ebca37efso5144069b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 01:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718179257; x=1718784057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/SC79B0SQx0Kv68DpQnR4beG6Hiq5QD/FW1/evjIEo=;
        b=rZ+9XzgyyIWA6jPagrd/ZlPFBi81Kda40uQ+cWYPWY/frUXSvzp3MJax5xryc+MwRu
         nOMym9LLVQ34jv/6wLXI86Hm14NKwcRBh1NrMGS/A2GT1I1OIDVxYx1oZIjg9HqZx0w5
         +1yP72gfMr8se6nLxqxO+DoGeLXWMSc3opxEhKHIL3QB67MgRYVlJ6EixXAGmmyNxqJB
         QBRhlBRQt0BobMN4wwc6jLefjb5OWGyj2mmAGrQqWSHkvX4kpNlZ4dol04fUnV+bANpZ
         P1fYxNJTFc4Bz5Dz/3HRwEQL8BKbkVeRQg/HSh1rqD63wUIOdvP35TzAOFodn/vQ9r7T
         3KBA==
X-Forwarded-Encrypted: i=1; AJvYcCXtvJn9MegebE+k9gEns5zsT/4UBWtxNO/pPz6UP6QiisRYHP5kEeAi9qPQuOiXinHvmmUH7iv3y5K41rWdCi60ydhifYqgX28H
X-Gm-Message-State: AOJu0YyDEFyMAnbtNf1R363Fp4TEbNb3h/75MgM0oUS0zruS6YNIneA9
	WwlUWTR9lr29KRKyqGvR7WsFqaNhwixpFFOsGhEdzRaWT7uqgY3lDfXUoICeUNA+pHsOPY1ckLF
	nVVhtXllf3cJvaRJaKhwwHGj+1/74QK/T30slUh0Q+u8NNo7f/Se3W1qlYQ==
X-Received: by 2002:a05:6a20:8423:b0:1b8:7df1:595b with SMTP id adf61e73a8af0-1b8a9ba7d01mr1293390637.21.1718179256882;
        Wed, 12 Jun 2024 01:00:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAPrr/MJx8mrt70uE7M9aB9/SWIUme1NLj1rWoKuRef2sjVdMtlSpkqcr6UXpxn4s/+VwzgQ==
X-Received: by 2002:a05:6a20:8423:b0:1b8:7df1:595b with SMTP id adf61e73a8af0-1b8a9ba7d01mr1293331637.21.1718179256174;
        Wed, 12 Jun 2024 01:00:56 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705a16c7803sm4123812b3a.144.2024.06.12.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 01:00:55 -0700 (PDT)
Date: Wed, 12 Jun 2024 16:00:48 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: patches@lists.linux.dev, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	ziy@nvidia.com, vbabka@suse.cz, seanjc@google.com,
	willy@infradead.org, david@redhat.com, hughd@google.com,
	linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
	p.raghav@samsung.com, da.gomez@samsung.com, hare@suse.de,
	john.g.garry@oracle.com
Subject: Re: [PATCH 3/5] fstests: add fsstress + compaction test
Message-ID: <20240612080048.dnbc3rzmeo7jtubv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240611030203.1719072-1-mcgrof@kernel.org>
 <20240611030203.1719072-4-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611030203.1719072-4-mcgrof@kernel.org>

On Mon, Jun 10, 2024 at 08:02:00PM -0700, Luis Chamberlain wrote:
> Running compaction while we run fsstress can crash older kernels as per
> korg#218227 [0], the fix for that [0] has been posted [1] that patch
> was merged on v6.9-rc6 fixed by commit d99e3140a4d3 ("mm: turn
> folio_test_hugetlb into a PageType"). However even on v6.10-rc2 where
> this kernel commit is already merged we can still deadlock when running
> fsstress and at the same time triggering compaction, this is a new
> issue being reported now this through patch, but this patch also
> serves as a reproducer with a high confidence. It always deadlocks.
> If you enable CONFIG_PROVE_LOCKING with the defaults you will end up
> with a complaint about increasing MAX_LOCKDEP_CHAIN_HLOCKS [1], if
> you adjust that you then end up with a few soft lockup complaints and
> some possible deadlock candidates to evaluate [2].
> 
> Provide a simple reproducer and pave the way so we keep on testing this.
> 
> Without lockdep enabled we silently deadlock on the first run of the
> test without the fix applied. With lockdep enabled you get a splat about
> the possible deadlock on the first run of the test.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=218227
> [1] https://gist.github.com/mcgrof/824913b645892214effeb1631df75072
> [2] https://gist.github.com/mcgrof/926e183d21c5c4c55d74ec90197bd77a
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  common/rc             |  7 +++++
>  tests/generic/750     | 62 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/750.out |  2 ++
>  3 files changed, 71 insertions(+)
>  create mode 100755 tests/generic/750
>  create mode 100644 tests/generic/750.out
> 
> diff --git a/common/rc b/common/rc
> index e812a2f7cc67..18ad25662d5c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -151,6 +151,13 @@ _require_hugepages()
>  		_notrun "Kernel does not report huge page size"
>  }
>  
> +# Requires CONFIG_COMPACTION
> +_require_vm_compaction()
> +{
> +	if [ ! -f /proc/sys/vm/compact_memory ]; then
> +	    _notrun "Need compaction enabled CONFIG_COMPACTION=y"
> +	fi
> +}
>  # Get hugepagesize in bytes
>  _get_hugepagesize()
>  {
> diff --git a/tests/generic/750 b/tests/generic/750
> new file mode 100755
> index 000000000000..334ab011dfa0
> --- /dev/null
> +++ b/tests/generic/750
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Luis Chamberlain.  All Rights Reserved.
> +#
> +# FS QA Test 750
> +#
> +# fsstress + memory compaction test
> +#
> +. ./common/preamble
> +_begin_fstest auto rw long_rw stress soak smoketest
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $runfile
> +	rm -f $tmp.*
> +	kill -9 $trigger_compaction_pid > /dev/null 2>&1
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +
> +	wait > /dev/null 2>&1
> +}
> +
> +# Import common functions.
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +
> +_require_scratch
> +_require_vm_compaction
> +_require_command "$KILLALL_PROG" "killall"
> +
> +# We still deadlock with this test on v6.10-rc2, we need more work.
> +# but the below makes things better.
> +_fixed_by_git_commit kernel d99e3140a4d3 \
> +	"mm: turn folio_test_hugetlb into a PageType"
> +
> +echo "Silence is golden"
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +nr_cpus=$((LOAD_FACTOR * 4))
> +nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
> +fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
> +
> +# start a background trigger for memory compaction
> +runfile="$tmp.compaction"
> +touch $runfile
> +while [ -e $runfile ]; do
> +	echo 1 > /proc/sys/vm/compact_memory
> +	sleep 5
> +done &
> +trigger_compaction_pid=$!
> +
> +test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
> +
> +$FSSTRESS_PROG $FSSTRESS_AVOID "${fsstress_args[@]}" >> $seqres.full
> +wait > /dev/null 2>&1

Won't this "wait" wait forever (except a ctrl+C), due to no one removes
the $runfile?

Thanks,
Zorro

> +
> +status=0
> +exit
> diff --git a/tests/generic/750.out b/tests/generic/750.out
> new file mode 100644
> index 000000000000..bd79507b632e
> --- /dev/null
> +++ b/tests/generic/750.out
> @@ -0,0 +1,2 @@
> +QA output created by 750
> +Silence is golden
> -- 
> 2.43.0
> 
> 

