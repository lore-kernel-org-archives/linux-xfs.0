Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966F132861B
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010909; cv=none; b=WoeK9Ce3CaQ0zWm/yhpbq7LZUHTKI1Bb5YWDkF6HwO3uBYlzdTNaFLA0bILcOYJ/hpfBzJCjGT35JZo2/j/5lLZqvdU3YnQ5RCXhiB+3zr3Evij8SK/KgUM+VVrw+icQTFt9ETf8XzFfqSs8Ww04JS2Uik9Q+D7UIA9Ftan1k1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010909; c=relaxed/simple;
	bh=YM3NH93xYXj9sUhVNH9M9Yb1Vj4QuP/NFYtUFkeACZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGvDa5ZATd6OI9HYjSG7O+Lhc1at/tghFWfNuyq8afagtzht0TaPsYoDJfJBRvA3hBkMtF7A2VddVgq/ExwIwUUa9WlDc8aCNnw4RnfzBrlDMJRVji6bGTKJLaTOL9L+CmqK9TFKJ26oDvffQmDqmUbfZV4njoCVujK8+tm39L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EkT1pWvg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WsawmIvx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EkT1pWvg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WsawmIvx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769010904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcuqY+HviRhw9xk3P1lll77IB09Wj9BycPhi1D64cSI=;
	b=EkT1pWvgYf/0wHgIu1od0LJxeYalA5K2zPrpxwdtGDqzpVWG67MIWPxWflSqu9eF46W9PL
	CfbmD1Jt/BDdLAH2h1LsXLvGvqN56KYPE2XKnR24y5zou6FlQe4YRpK3/v+hE6zGII5Cfv
	3eT7xKvbYZz8juDOPcMe3tLFcQZWtWA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-N0TMPm1LOUipFufzdjcEZA-1; Wed, 21 Jan 2026 10:55:03 -0500
X-MC-Unique: N0TMPm1LOUipFufzdjcEZA-1
X-Mimecast-MFC-AGG-ID: N0TMPm1LOUipFufzdjcEZA_1769010902
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f1f69eec6so63397285ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769010901; x=1769615701; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NcuqY+HviRhw9xk3P1lll77IB09Wj9BycPhi1D64cSI=;
        b=WsawmIvxmybDwqdY8BVKUjBMwP+b9Ezynw2XjUuMfMdO0a8AitCas+vuGwX8S+J1ml
         1xJ2W/10dkiMiYPg5st02xgS1HeFLpwSJpoTuy/WK5fpJwqZuiv0SG8bpekWeQ4IcDrD
         5xYlfh3ksKK0WB1GuHBRwBvLbucJnfohE4JDsgj7NaWVREUb7SNFSjpc4FbnJhJbe59U
         iLZTM4T0f5cNn8Z4cWRYX0uYJYEpp7HKcb/X1Je/V6oOEUyE1s4a8OFo/83MwhP3iz7P
         rNsB+/5HexIQrGrnhqzgSg2axmODKl9KoDy5+4CmJK75bZbVrrBW5/6m1rWMRfeZXU0J
         LOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769010901; x=1769615701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NcuqY+HviRhw9xk3P1lll77IB09Wj9BycPhi1D64cSI=;
        b=oFM7rZ8wIZHgWDBEAxXZ1qqygmGLTrXRekQ8Yqn+2L2N+O3MhHnbKj48oLQGXW+V9O
         bkpblkCZdc/WW88Bp4vl+/FSy+R7HWXsdHw5yNbiJuDMg33QFmV0A+FdhI7T2ZD7Ey4t
         RlyQGsCJVu7sIWe0RCycLRdfOBKzVdZoLFmB/iG077UF8i8GT4bUfrXal3rDMHQijqZi
         3lv/iO8eyhOi2aICR92tXngXgm/fB75HF0Qh9d6PZ/CQ7XQMiU1RmSgoTeWfe3QruRmL
         PYOJ9lGeC54m5LAH0Ir8Rt19hyUq6SZi45FIx87ByR/Qk3MFXgx5Ll7Mvmj2hgBphLrW
         wCPA==
X-Forwarded-Encrypted: i=1; AJvYcCVDo8Q6Yu/CioJyD0ehkA9HAtLlMvtRbX48NoACclSnKcRYw5/YVtnZ5ahENpBxYvtsPuCo3bprMIg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr7PIcelI/C9ut7dpGz4abeAUqTqfcQAd/ZAIts40zY4IUH0m3
	Upix0QKkiT/6ptN4Koi8DpWhxL4fxO7RcK3TZCv+S60Pzn0Xco+9e41+slMgEmp3zDLNdBochXb
	atBVOroqIV1jkrZ8mh/TpuB1r/j46ARHWwdeyKrAyocz7CozLOX9Lni4jWILA8aD53jDdonEB
X-Gm-Gg: AZuq6aJfdg/N3U5acjHkQ1yD23vjbPz2sWqPjq6Ey+YoErJE+Lwgs8rq0U9epa9FwRB
	v11clJ7yIWwzfM4zkHdX+tUyJ2Pk4W2KYkSmCXl2UEFp2R2DAH0wkzXaNZgmzVNbK6p0a5Hwh/a
	TDvpEXx5k+meTj26dYKkSEJ+DszYmT9uYcrUFmsw5CpgkMMhyBFwY2cXh1YAe/vyY8nL/GtMOtc
	KfsxwXo7JSZohqT4V/a2lO1VsDIuF16yYIeTkfADGv3MzwYk5EN4PURNq99WR8uOCarzvDgtHGX
	C/zAewSjA4PZm7okC0TJ0wpYljZnzNrolUy+HCVhCk8fqtkR6rnQUrTWFbaYuYSI+0cpUzJPwMk
	5X27p4YFhZk57IqQkHQjNm4J5MvVwW5s8nTLy9SNYB1kIsmlYNw==
X-Received: by 2002:a17:903:1a0b:b0:29e:bf76:2d91 with SMTP id d9443c01a7336-2a76b05f199mr56501495ad.42.1769010901517;
        Wed, 21 Jan 2026 07:55:01 -0800 (PST)
X-Received: by 2002:a17:903:1a0b:b0:29e:bf76:2d91 with SMTP id d9443c01a7336-2a76b05f199mr56501355ad.42.1769010900953;
        Wed, 21 Jan 2026 07:55:00 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dbb7fsm159634955ad.64.2026.01.21.07.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 07:55:00 -0800 (PST)
Date: Wed, 21 Jan 2026 23:54:56 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] misc: allow zero duration for fsstress and fsx
Message-ID: <20260121155456.pf6jeprhzua3rdl3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260121012621.GE15541@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121012621.GE15541@frogsfrogsfrogs>

On Tue, Jan 20, 2026 at 05:26:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Occasionally the common/fuzzy fuzz test helpers manage to time
> something just right such that fsx or fsstress get invoked with a zero
> second duration.  It's harmless to exit immediately without doing
> anything, so allow this corner case.

Sure, duration=0 is harmless, I'm good with this patch.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Please excuse my nitpicking. I'm curious about the semantics of "--duration=0".
Looking at the output of `fsstress -v --duration=0`, it doesn't actually
'do nothing.' Instead, it behaves similarly to duration=1, where fsstress
attempts to execute operations before timing out and exiting :-D

Thanks,
Zorro

> 
> Cc: <fstests@vger.kernel.org> # v2023.05.01
> Fixes: 3e85dd4fe4236d ("misc: add duration for long soak tests")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  ltp/fsstress.c |    2 +-
>  ltp/fsx.c      |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index c17ac440414325..b51bd8ada2a3be 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -645,7 +645,7 @@ int main(int argc, char **argv)
>  				exit(87);
>  			}
>  			duration = strtoll(optarg, NULL, 0);
> -			if (duration < 1) {
> +			if (duration < 0) {
>  				fprintf(stderr, "%lld: invalid duration\n", duration);
>  				exit(88);
>  			}
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 626976dd4f9f27..4f8a2d5ab1fc08 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -3375,7 +3375,7 @@ main(int argc, char **argv)
>  				exit(87);
>  			}
>  			duration = strtoll(optarg, NULL, 0);
> -			if (duration < 1) {
> +			if (duration < 0) {
>  				fprintf(stderr, "%lld: invalid duration\n", duration);
>  				exit(88);
>  			}
> 

