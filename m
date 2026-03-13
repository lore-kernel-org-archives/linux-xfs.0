Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375102FF672
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773425940; cv=none; b=JgK4TqmS0+aIgxUPr96oEovUut1ApeDo1CXNR92Kh4ngFYmlN5HYQkxCI/ie0g73l4bny4M87CPKTZC5rscDHXTSBS23UgK1vPG70rhKc/LZ7yE+wjNl7nVNynqB72pqyfYDDPhfedL1PcWhtomXIHMpGov4QzxQXOnw+ZB7q5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773425940; c=relaxed/simple;
	bh=SyWkhZl5QWjnl/ygrKTz/4AjrADUsIachLIVufoC67U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgZSIJoXAu6Nkycr8X6pQmIvInSHizFKzUUWlpfm3K3Cra7RdQr8TJMsfxW884bUsU2CRpVpYqdNhOHz+WIx4qCr8oGoB9dF8/mPbMHcoIxS28nXaupyx4705LIaw4+Y2l96oM0J7gb8deB177pHIQsBYPMP1gE0duxME7GFvqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bbeO1WkZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=F7/6Bjd7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bbeO1WkZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="F7/6Bjd7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773425938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CfHkBqrrPcwelnP7I3yoE0n27Ml9ocYK3ty32ugod7s=;
	b=bbeO1WkZYhMaLrP33MP2nkkH3R2ykMJhl3J9C9du4tsWPhsX1TqodYlp9G6bvYObOv5fq1
	BvJGHbkaCNd95LmmxBq97Q5wot0pTf3f7bU8WYS67d3nLXh8CakToD2Lf4BaJMiYSJxvVE
	xQADQNSkjuF1wQpU7lCBr8XWVfFOiyE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-P8vXjhhPN1eY0wH6e5OHWQ-1; Fri, 13 Mar 2026 14:18:56 -0400
X-MC-Unique: P8vXjhhPN1eY0wH6e5OHWQ-1
X-Mimecast-MFC-AGG-ID: P8vXjhhPN1eY0wH6e5OHWQ_1773425936
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2aebfa0af7dso125555095ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 11:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773425935; x=1774030735; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CfHkBqrrPcwelnP7I3yoE0n27Ml9ocYK3ty32ugod7s=;
        b=F7/6Bjd7gnnkvQr30MW9vK22psZlvytUjgGuMWMz8lJd/RINQqBki7sEkmyTe9gp33
         y6hlI5rGnxWqEXWh/8zfiDCbn+IjhNh3EMBEtdBGS1ENQb04RA8Rj1BE6JQLOsYMFueN
         eujWRMfTY0OJ6XWyUoaBxtftDyi//zplnTHBAcY8j+NlGSSou9miACLE+SBIkzmL4deL
         1fZ5l06RW2hdeJiN0ZVTWWzc/1rXS+VuLy1ghPjjbdLb8zQcknqJ1ACW0QHcXroO08Il
         tDEHzL0t3/b3peB3P/1O/ZqiiqCH9pkgtf1++mno/wF0Mtf1Pe5YiXYzQ3oj7L3hlMlu
         kpwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773425935; x=1774030735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfHkBqrrPcwelnP7I3yoE0n27Ml9ocYK3ty32ugod7s=;
        b=bKg14aM+DJl+3c8gZLZuu4fGMkJxJBIhkg7NAZMI7Pr8h36yYnGn88hK1i7fek0Db7
         reIEwT3624C5QwgIxFpTc+bmkBXBOEmSOsbDZ5MSIjrf3H7+8ihMsGvm9ysyfeAZRZKI
         /zRfLpLVy9+Xo5EDSbYskN+rknH9RdzjFWiJf4Zecb8+HYL86OdBebW5EgotWYPIT4zt
         6ha9sQQQKzlEkH4ny8bQhyi1m0Gv8u9axCxc3m6ImwPKQDYLf0uXQea/RKQwtFJN5l9R
         xrAwcKyOnNa58I/S/x+Be78DMPr8pMbmwWcafng1JT593hCyOh7DadsO78Xc80OwTJBI
         buGg==
X-Forwarded-Encrypted: i=1; AJvYcCXX+5WcIf2dO/eLH6K1utji4mdB9/Yf97U1lT2+GDK7XB6Yqa0f32H2jkvOQAhragwpgFOR50khY3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJeEYqPMoWfirTJ7/n+nfjHWbjs1+6rShmELUnhvDDy4FtVa+z
	R0nG4LGG8cCdvFOKdd0wPVCAgeAZWCkKGi1NSVsGfn5Y9HNizwGlcNPohoxAeDWv5I3LVDufoUE
	B+5uJSHYC4J6om1gTLwaqChMAzfRKK26PBntbNZsgqQL5MmZd6Vmu/aZhy5ehzA==
X-Gm-Gg: ATEYQzzBOhWHudmvpAdsQv9XCGgz1KTWejqMqf6PcW/LqzJSO10Buz0wAxjPxlaL3Fz
	SUhLUAowEuAcafzETDmWsOtGnrqn5UPmfif++p73tB2SNjWUGrJ0ZYRzUsaxm8XxSErLGxwxkmq
	y9oyCU4cTBfh19K0MxxS8uFIma733XGjAoeMAldBEYcEZBrTpWgfbddSVyoxHlDU2A6ZkiukFRk
	sR6cLaeeVX3kl8OJ3dq3tOntNIRKiuIFmQhTy+H+gqU/WFCDGE95aLHoYIlFaFSzwXxaLQVK5BO
	tlQY/MoJaMc6b3tyVZ7QWBd+hgQIGAQEBhoAtH14nTmKsqmjnOaz1hd50O+rvAS9Y4pMXXAQEel
	Xz3YzPAnPRH8EuBtS6LyXda2ATPl8Q1bQwCj85jXxi/aZDAHkac2ghFhWB6mf9g==
X-Received: by 2002:a17:902:d484:b0:2ae:d427:d3ff with SMTP id d9443c01a7336-2aed427d732mr22408965ad.36.1773425935459;
        Fri, 13 Mar 2026 11:18:55 -0700 (PDT)
X-Received: by 2002:a17:902:d484:b0:2ae:d427:d3ff with SMTP id d9443c01a7336-2aed427d732mr22408745ad.36.1773425934954;
        Fri, 13 Mar 2026 11:18:54 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece85e9dfsm28224545ad.87.2026.03.13.11.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 11:18:53 -0700 (PDT)
Date: Sat, 14 Mar 2026 02:18:49 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: test health monitoring code
Message-ID: <20260313181849.pofzy7kuyoplumnc@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403795.1186408.11292081408049550687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403795.1186408.11292081408049550687.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:50:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some functionality tests for the new health monitoring code.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/module      |   11 ++++++++++
>  tests/xfs/1885     |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1885.out |    5 ++++
>  3 files changed, 75 insertions(+)
>  create mode 100755 tests/xfs/1885
>  create mode 100644 tests/xfs/1885.out
> 
> 
> diff --git a/common/module b/common/module
> index 697d76ba718bbc..c0529b65ad6e2b 100644
> --- a/common/module
> +++ b/common/module
> @@ -225,3 +225,14 @@ _optional_reload_fs_module()
>  		_test_loadable_fs_module "$@" 2>&1 | \
>  		sed -e '/patient module removal/d'
>  }
> +
> +_require_module_refcount()
> +{
> +	local refcount_file="/sys/module/$1/refcnt"
> +	test -e "$refcount_file" || _notrun "cannot find $1 module refcount"
> +}
> +
> +_module_refcount()
> +{
> +	cat "/sys/module/$1/refcnt"
> +}
> diff --git a/tests/xfs/1885 b/tests/xfs/1885
> new file mode 100755
> index 00000000000000..d44b29d1c57e06
> --- /dev/null
> +++ b/tests/xfs/1885
> @@ -0,0 +1,59 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1885
> +#
> +# Make sure that healthmon handles module refcount correctly.
> +#
> +. ./common/preamble
> +_begin_fstest auto selfhealing quick
> +
> +. ./common/filter
> +. ./common/module
> +
> +_cleanup()
> +{
> +	test -n "$healer_pid" && kill $healer_pid &>/dev/null

I'll add a "wait" at here, and ...

> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_require_test
> +_require_xfs_io_command healthmon
> +_require_module_refcount xfs
> +
> +# Capture mod refcount without the test fs mounted
> +_test_unmount
> +init_refcount="$(_module_refcount xfs)"
> +
> +# Capture mod refcount with the test fs mounted
> +_test_mount
> +nomon_mount_refcount="$(_module_refcount xfs)"
> +
> +# Capture mod refcount with test fs mounted and the healthmon fd open.
> +# Pause the xfs_io process so that it doesn't actually respond to events.
> +$XFS_IO_PROG -c 'healthmon -c -v' $TEST_DIR >> $seqres.full &
> +healer_pid=$!
> +sleep 0.5
> +kill -STOP $healer_pid
> +mon_mount_refcount="$(_module_refcount xfs)"
> +
> +# Capture mod refcount with only the healthmon fd open.
> +_test_unmount
> +mon_nomount_refcount="$(_module_refcount xfs)"
> +
> +# Capture mod refcount after continuing healthmon (which should exit due to the
> +# unmount) and killing it.
> +kill -CONT $healer_pid
> +kill $healer_pid
> +wait

unset healer_pid

others look good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +nomon_nomount_refcount="$(_module_refcount xfs)"
> +
> +_within_tolerance "mount refcount" "$nomon_mount_refcount" "$((init_refcount + 1))" 0 -v
> +_within_tolerance "mount + healthmon refcount" "$mon_mount_refcount" "$((init_refcount + 2))" 0 -v
> +_within_tolerance "healthmon refcount" "$mon_nomount_refcount" "$((init_refcount + 1))" 0 -v
> +_within_tolerance "end refcount" "$nomon_nomount_refcount" "$init_refcount" 0 -v
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1885.out b/tests/xfs/1885.out
> new file mode 100644
> index 00000000000000..f152cef0525609
> --- /dev/null
> +++ b/tests/xfs/1885.out
> @@ -0,0 +1,5 @@
> +QA output created by 1885
> +mount refcount is in range
> +mount + healthmon refcount is in range
> +healthmon refcount is in range
> +end refcount is in range
> 

