Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EC73358BC
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 10:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771581616; cv=none; b=WVdYO1jM8QP98t5AraxZaWYArQLB/gbRHuLVqsQT1sYrNAYUl+rwbznoS3goAriBn7cZCR++lHdwHyT89q+bZ5TkY4Bl2Q51IiIfp808vP4UttZ/g/rG6JUlthsXcqt2qRTvqfa602PDSIhKjwfL4YxkQ5PUG1JJA2ogZMmi4mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771581616; c=relaxed/simple;
	bh=rFa1JNOOh8Ssk8Y8ywFKJB6552RP7UBIeqsSW/gEraI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=JX7LyDMv04ASjLgG8DvUloEk1rwTKdmJPMjXTmWRPWqtgvmoiCY4PP0gKay+b6qlFB5b9i/zq3oLv5YcIs66r+4gZHx0Q4p9b1yjEfjeVltcSjevhI7iyOOoOOXEL9H2qievxlYJK+jvMfutVUNobaFF6ukkS6HcS2tql9wI7xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BdzFF0e/; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BdzFF0e/"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35621aa8c7fso1046233a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 02:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771581615; x=1772186415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E21Ynhw++H4r3Jkl9ZIAjOT6EVhP7EbsgEinOa2T0OU=;
        b=BdzFF0e/jLSJTHcSA34sOUbNrNEJhWIPpyKxBf6/g8NkOVhBCaaI/FiDCUer/sLl3b
         x/RArfUs6pkTvtlVoRKyXHL+iRwGRCxhb0893hOFk5jYOZwUH4jSxYkGyumDIZG1HdGQ
         l5pWszK6La+t+3qmFg5VG/MMFhTqE2lA9FfGhIV/XAcsfm7jCUupKNxJDHpsgm3fve5q
         1KjixJdnBfSc8/xSkeHXMGIO77Dgu+RmpdCDNM3X86KZnq4sjAqh4/bt+bxHC1LWI467
         dI9N0eNv/9iLs8/bDrhAhARk+jXVLIm2Bdg8cWm+8a6aKDH4DSMPXKUw54z+HhOx1/EC
         YaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771581615; x=1772186415;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E21Ynhw++H4r3Jkl9ZIAjOT6EVhP7EbsgEinOa2T0OU=;
        b=WoyHToHxD6itZz/tfEDQp/f1abbI1dSi809uXs/NR6o6A2tSrODFbGAlHWw9gl/Fzg
         J3zeLxXeqjPgc9zLoMNQpZvUan9NJHyOSA+KUKC3timwemFP/XkAICSdWALA//GyNC3P
         Fq0kBshGbtN6tJ6+Mtp8sXFVHb/bESuxi/sf64mWE8sJwXbM2vdbX7qt9c7ZXqMXRl8y
         P6WqnwFmyRRSo9s09gZa5jK9VDcAFtczbJMuGoQkx1YOuCVdJhoVF49PFWi8/HphcZv8
         VBQwZ2D6ch6rZBbzmk/FV2rnD3cxugRXayKYLl+OuqltsGlryeYJPKz1yuj6tMC2tT2W
         k6Aw==
X-Forwarded-Encrypted: i=1; AJvYcCX33HpLU2WN4Wj8RMWKD2Y5R7W+lb/1jGVPphNL8UgQPcZk32NxdPUia3MNGOpQMuzxVzAvxjeUVZw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfElNinVG3otpi6KrmHnjyFjWRqTlRI/kfHUAZ4g35YITW6ZSQ
	lv8lVhwAZFgHsx8lQcl6KaCX3ZjghZVWI39aO1aUwlIlDzyEKkoxpd4b
X-Gm-Gg: AZuq6aJZOQkhdb4w6ATTwNR+qlMu7HlWIjmNZFf5J1Z/DLy/FXSXI0C2LJKnIKKmPEV
	NWDYhmzKo3a3K6dT0IQf9FgugI/X7ZuoM8q0HdYvaIJwTDegmaGANI7kImG+/Bd94T8VGgLeZQH
	EcPZZGndJW8HsyWmRkEDvnSDNGDlBpe+yikjptw+T/2XGgAnioqYixmEBZVr0Yc75IxWYapfbWR
	czWEFnxZDsUnptsAjKgG/K0tuaHExK+gBaN0+fTZf1Cz3Dt3+4x7CtcZgzxlvTY28+AXD7eWVGv
	phi60XK1AVIWR+FCbGepmF3CRK7ixkZ17C5MDUgnxFK5RJabW8uDqZ8ozKxjeiSqhlyrZ5ZrFZ5
	2Lu/OYWDdcxthqDGFRLmkbi5UZ3EKjhKTseB5wdM258RPWuyZgh8e9Sn8bbeHKiLeYAHUqDy6tx
	BTNgl9tVUTtwZ1Q87sGLVD0FT9WJvpkj+cVSk/9Eh5/ezcbe4SVJWcXPoYcUyCaUGzKkz19SDOa
	uz1
X-Received: by 2002:a17:90b:2541:b0:343:6108:1712 with SMTP id 98e67ed59e1d1-35844f9bf28mr19807914a91.18.1771581615001;
        Fri, 20 Feb 2026 02:00:15 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.114])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3589d7f1774sm2444331a91.1.2026.02.20.02.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 02:00:14 -0800 (PST)
Message-ID: <f8ea8da2649595f2edcb57a9776748cbced391a7.camel@gmail.com>
Subject: Re: [PATCH v3] xfs: Fix error pointer dereference
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Ethan Tidmore <ethantidmore06@gmail.com>, cem@kernel.org,
 djwong@kernel.org
Cc: neil@brown.name, brauner@kernel.org, jlayton@kernel.org,
 amir73il@gmail.com,  jack@suse.cz, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org,  stable@vger.kernel.org
Date: Fri, 20 Feb 2026 15:30:08 +0530
In-Reply-To: <20260219200715.785849-1-ethantidmore06@gmail.com>
References: <20260219200715.785849-1-ethantidmore06@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2026-02-19 at 14:07 -0600, Ethan Tidmore wrote:
> The function try_lookup_noperm() can return an error pointer and is not
> checked for one.
> 
> Add checks for error pointer in xrep_adoption_check_dcache() and
> xrep_adoption_zap_dcache().
> 
> Detected by Smatch:
> fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:
> 'd_child' dereferencing possible ERR_PTR()
> 
> fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error:
> 'd_child' dereferencing possible ERR_PTR()
> 
> Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopts a file")
> Cc: <stable@vger.kernel.org> # v6.16
> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> ---
> v3:
> - Add dput(d_orphanage) before returning error code in 
>   xrep_adoption_check_dcache().
> - Revert xrep_adoption_zap_dcache() change back to v1 version.
> - Include function names where error pointer checks were added.
> v2:
> - Propagate the error back in xrep_adoption_check_dcache().
> - Add Cc to stable.
> - Add correct Fixes tag.
> 
>  fs/xfs/scrub/orphanage.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> index 52a108f6d5f4..682af1bcf131 100644
> --- a/fs/xfs/scrub/orphanage.c
> +++ b/fs/xfs/scrub/orphanage.c
> @@ -442,6 +442,10 @@ xrep_adoption_check_dcache(
>  		return 0;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> +	if (IS_ERR(d_child)) {
> +		dput(d_orphanage);
> +		return PTR_ERR(d_child);
> +	}
>  	if (d_child) {
>  		trace_xrep_adoption_check_child(sc->mp, d_child);
>  
> @@ -479,7 +483,7 @@ xrep_adoption_zap_dcache(
>  		return;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> -	while (d_child != NULL) {
> +	while (!IS_ERR_OR_NULL(d_child)) {
>  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
>  
>  		ASSERT(d_is_negative(d_child));

Based on my reviews in the previous version[1], this looks good to me.
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
[1] https://lore.kernel.org/all/61386abf00c817e65ab70c994ed584fde339f9ed.camel@gmail.com/

