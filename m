Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A058635D
	for <linux-xfs@vger.kernel.org>; Sun, 16 Mar 2025 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742160361; cv=none; b=TZKItbYGCq/wkaLEF/dc9X+bUNmbvKNezRGKY+dglBI7/aqaeFkRrMoKZSpE3eHwGXptKWdrRUTo5fzZeQFvupHdWY8Bn6vwD9Cvq57qeVm+NBfgyf1S6q7MWCPq6r57osGtivDr7GgRIxC4EpV+q/lg6aOVXr9KtENivjtruas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742160361; c=relaxed/simple;
	bh=qD8bZ82Mea61BnL7OKYFjdzupkRwJnGJj3cqernRGdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAI0SNfMPexDyS4YnfJtZmcmPPTPFwnV1F31ReaATzcgY6SJHs6LATpp9nwu3vO/le7U2VFzUOLN7cxXju/ctvVUN7mlcR3nP53zfdUKOQzeFOef6HtOxXDb8z+ZGa1BqlHlmZMPJgEBz/g+dVGZLfQrDe4KUZVwmI6DLa+Bx4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=A4qs1ENm; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="A4qs1ENm"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225477548e1so61930565ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 16 Mar 2025 14:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1742160358; x=1742765158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5gAIqMZTUydCnSN+znNDpm/huHtmZulJ3wU6OKbJxus=;
        b=A4qs1ENmVp1Pi3SNlTP/aR++JULzfNhEOXipJRstyDEb6IIRT2E4SRky8zvsJsGlE2
         uq9qVqRQvvYTQa7GgahRRODGojL1qQUy/lXwWQuZ/E44/1jlXbKsmCEL2krPAn2310Xc
         g1NbuMVuZBtn0v9LNfoIxOB4eygU8QKGJRSVgYZAE41eeeFm5KVYxAcEc4KeYFYEIbT0
         HbhM982SCJIlTUzE6cR8Log1u5HBFtGTPdmBMpG4l3Nn0oBHKjfhFV0ScEQiShorlvd4
         5c+kNoeFUoSvqRHF/pwkD5tr8kH+bm2f2Ce+DddpFXvE+c2hSDT8JAOrs5TNpRF5c24K
         CXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742160358; x=1742765158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gAIqMZTUydCnSN+znNDpm/huHtmZulJ3wU6OKbJxus=;
        b=U0g8hnVHQtqCVQ5LS987bth43hfJquQEGiXmh+62N5GvUS8ORsk4LbnKZzZL8czsgj
         8mKL7E0jTFEhk0WXNLMTxKwl0/Z2rLF06YMCPZtBDuOb0nQ/UNOiddCWKHyXkMBFFjv9
         4I0uQqGrBLQRTzk+RHs31uprvxqkT2eYMKLSoKpe+MDX2rzGgHClozxxwmP2Td0otvg9
         FHa7xybTA2wSKDBboHCUqwN93PgNl9n2hKXpkdoewxonH84QDQsHscWZfGcMGzAhQwUo
         oOA4tMpqwjfCaTBDbD1pa9vhXKEj7gY0W/fysZXVvqyb7N4SwtAiguZxNnhHqcXxGdEt
         PyEg==
X-Gm-Message-State: AOJu0Yw+oeM3I29Y47SBYqW6MJwqGPThjDHvyA2W6n1QVhmRDjxjzgbX
	2i9ftgWBQW65O6l6+8eeANAp4zRnFzPqIzYYA2Cc1Vmfcqz5o74Zn9kcVMXVjhfDYW3K4twuTFw
	0
X-Gm-Gg: ASbGncsQ3clznopJfgQsDyiydbN8WLl8Zf7OnywX4YTHyHA2nIqnR9sVVC6/YmYzRcB
	UI26tFM8wSS1Iej+hkahsKwrZ7f8SWlkiAjZ8mUdOgsYoFKsJlfYy4un/eXiZegKmpdWxjXLQtt
	8ZUDMCL8WOZ5tYWz0WpqTZ7CXN02mht+okuU7fL9o3FixnQOlkfWuEaiJcOdqNuniAHXAG0v2IB
	o9dfIgSyTnFpIFnxRmxwVBun7udgbUBhb8q+/eVCmIRhFDf4Bpj5dSsrppdjeHiK5pzLul8cyq4
	IB4UT5hSktFTbC5nkOnlFAHWV3JX1kQFyNEwHVAdJJr8B6jzoE2c6w3w9ax2MikyN6s6YGeXZZJ
	8JbajZdvYYeu9X2/HoU85
X-Google-Smtp-Source: AGHT+IG/5Q578DjCveg9JaO823tbnhLo8oakfZBibJAGmQeQmtAxVy6/Nob3GutzgxgT5LxDJacaLw==
X-Received: by 2002:a17:903:120a:b0:224:e33:8896 with SMTP id d9443c01a7336-225e0a19539mr136629755ad.11.1742160358565;
        Sun, 16 Mar 2025 14:25:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371167d931sm6406623b3a.99.2025.03.16.14.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Mar 2025 14:25:57 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ttvUY-0000000E0yl-2ZBI;
	Mon, 17 Mar 2025 08:25:54 +1100
Date: Mon, 17 Mar 2025 08:25:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>
Subject: Re: [report] Unixbench shell1 performance regression
Message-ID: <Z9dB4nT2a2k0d5vH@dread.disaster.area>
References: <0849fc77-1a6e-46f8-a18d-15699f99158e@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0849fc77-1a6e-46f8-a18d-15699f99158e@linux.alibaba.com>

On Sat, Mar 15, 2025 at 01:19:31AM +0800, Gao Xiang wrote:
> Hi folks,
> 
> Days ago, I received a XFS Unixbench[1] shell1 (high-concurrency)
> performance regression during a benchmark comparison between XFS and
> EXT4:  The XFS result was lower than EXT4 by 15% on Linux 6.6.y with
> 144-core aarch64 (64K page size).  Since Unixbench is somewhat important
> to indicate overall system performance for many end users, it's not
> a good result.

Unixbench isn't really that indicative of typical worklaods on large
core-count machines these days. It's an ancient benchmark, and it's
exceedingly rare that a modern machine is fully loaded with shell
scripts such as the shell1 test is running because it's highly
inefficient to do large scale concurrent processing of data in this
way....

Indeed, look at the file copy "benchmarks" it runs - the use buffer
sizes of 256, 1024 and 4096 bytes to tell you how well the
filesystem performs. Using sub-page size buffers might have been
common for 1983-era CPUs to get the highest possible file copy
throughput, but these days these are slow paths that we largely
don't optimise for highest throughput. Measuring modern system
scalability via how such operations perform is largely meaningless
because applications don't behave this way anymore....

> shell1 test[2] basically runs in a loop that it executes commands
> to generate files (sort.$$, od.$$, grep.$$, wc.$$) and then remove
> them.  The testcase lasts for one minute and then show the total number
> of iterations.
> 
> While no difference was observed in single-threaded results, it showed
> a noticeable difference above if  `./Run shell1 -c 144 -i 1`  is used.

I'm betting that the XFS filesystem is small and only has 4 AGs,
and so has very limited concurrency in allocation.

i.e. you're trying to run a massively concurrent workload on a
filesystem that only has - at best - the ability to do 4 allocations
or frees at a time. Of course it is going to contend on the
allocation group locks....

> The original report was on aarch64, but I could still reproduce some
> difference on Linux 6.13 with a X86 physical machine:
> 
> Intel(R) Xeon(R) Platinum 8331C CPU @ 2.50GHz * 96 cores
> 512 GiB memory
> 
> XFS (35649.6) is still lower than EXT4 (37146.0) by 4% and
> the kconfig is attached.
> 
> However, I don't observe much difference on 5.10.y kernels.  After
> collecting some off-CPU trace, I found there are many new agi buf
> lock waits compared with the correspoinding 5.10.y trace, as below:

Yes, because background inactivation can increase the contention on
AGF/AGI buffer locks when there is insufficient concurrency in the
filesystem layout. It is rare, however, that any workload other that
benchmarks generate enough load and/or concurrency to reach the
thresholds where such lock breakdown occurs.

> I tried to do some hack to disable defer inode inactivation as below,
> the shell1 benchmark then recovered: XFS (35649.6 -> 37810.9):
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7b6c026d01a1..d9fb2ef3686a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -2059,6 +2059,7 @@ void
>  xfs_inodegc_start(
>  	struct xfs_mount	*mp)
>  {
> +	return;
>  	if (xfs_set_inodegc_enabled(mp))
>  		return;
> 
> @@ -2180,6 +2181,12 @@ xfs_inodegc_queue(
>  	ip->i_flags |= XFS_NEED_INACTIVE;
>  	spin_unlock(&ip->i_flags_lock);
> 
> +	if (1) {
> +		xfs_iflags_set(ip, XFS_INACTIVATING);
> +		xfs_inodegc_inactivate(ip);
> +		return;
> +	}

That reintroduces potential deadlock vectors by running blocking
transactions directly from iput() and/or memory reclaim. That's one
of the main reasons we moved inactivation to a background thread -
it gets rid of an entire class of potential deadlock problems....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
