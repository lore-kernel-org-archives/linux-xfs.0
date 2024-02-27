Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8054D9E2
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 04:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709007836; cv=none; b=Xk+o4fH7uWxY8wX7ewTToNhoOOssr3w4Rs7r84PF+dnowvd2vgArN/z6tnOGQdS/EUzg4MEQwYC/lXPeWiP3/7n0jEmkDcnsXIpRd3GCtxku8ZrayDx+5s9Yvy+c8eR9D0Ceb0+qJDfkHvm53da7fbrL81GVZnrajdblxIos8yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709007836; c=relaxed/simple;
	bh=5Ag61F9nkbcncWlG83sAczWAGiPKgjTLNzcx/NInwug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FiOhyriadfTBYCBFcnLUauHEwniympAKFKs6ipLVHTH+qxworwg9rTHqYi++jIfG6mp+HcHFhCodJv9mc8zUkcIueyin+D3ncsmN1hMKYxzB122SZdHmo69/wWPF6kvReGYiGeEI9YnizCvl8lhs9hjvrjCACW5mSARs24hIiy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ogdjs3/x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ogdjs3/x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709007833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DXemS4YmjkSB4jwwgKrOkkaFhO+nICzv28dt7FQYGcA=;
	b=Ogdjs3/x7H7VPhnqbcThOXCaKypr3TibkXpcoVnWOoudp3bsVw1i+C+qyKaIb17tBgOumM
	a88PcbgSjA0AhOJeEzaL9Sjh57zqIjZ7mEESIolfEIhIncXQKnQ5HEfuR8gG05jafyF5Sy
	6bHfalDDdcZ7gPArLf5BdxL6ypR+ZWk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-21afqcyhMMWr1Te0GGg_JQ-1; Mon, 26 Feb 2024 23:23:51 -0500
X-MC-Unique: 21afqcyhMMWr1Te0GGg_JQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5cf35636346so2869281a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 20:23:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709007830; x=1709612630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXemS4YmjkSB4jwwgKrOkkaFhO+nICzv28dt7FQYGcA=;
        b=ePrTibVCIWakLtzCrYXVod8+M9x6fnTAc1acTPGwpYbCwnqDZOOrt8k6TOy+ULVsV8
         HsiadG5PgEtWVyCtmOEzdHUc9NpZn1Wc6n41Bz/LvkrwsbpZd3WGEcrPQwCzrY9winis
         esGNBOst/IPKKf7Am7LRaaxNWCdxYRyOBEvZocj1zMG4tluv+MScSEeBcq57FY1KmEO1
         phiD9GW4tIgp/HvOv6XevPe5Z1AXQ43EVk2IsdRM9+jVlYXOFniXXlCR2ibMeElW9i/S
         evcGepzlGSph2MHxpS6dXdPy9E1HNGNCGStOj6B25dkZY+LBg7sXKE9C9QyuNIJXgvYB
         PnVw==
X-Gm-Message-State: AOJu0Yw/hgGqP1zrXfGPYkilYmN7KmM3n+5GuLexnGENSa7+QsgeNBTR
	8WhdLwcnObg1NR1M1s9bB6VRZlTdejUjTsZNZ7dxxHI3nh3Yx0z4TfWzJCAlAquXZFFjeUkL9Qt
	Gs9KRQ+AOdptV8BYarhNljnOvGcgoo0UcYOmbrRd72ugpPkW81gX4v74Tu9dBeuAoi8NQ
X-Received: by 2002:a05:6a21:8cc4:b0:19c:9b7b:66a with SMTP id ta4-20020a056a218cc400b0019c9b7b066amr1262742pzb.49.1709007830373;
        Mon, 26 Feb 2024 20:23:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1h8cU3GJ+GksiO0o1zjDmbaL3uTKC+Gz5ZMmUtkQNpPmPPUHysrE8z437h/4uGDyRY8mWMA==
X-Received: by 2002:a05:6a21:8cc4:b0:19c:9b7b:66a with SMTP id ta4-20020a056a218cc400b0019c9b7b066amr1262735pzb.49.1709007830057;
        Mon, 26 Feb 2024 20:23:50 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id li16-20020a17090b48d000b0029ab712f648sm3595539pjb.38.2024.02.26.20.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 20:23:49 -0800 (PST)
Date: Tue, 27 Feb 2024 12:23:46 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/8] generic/192: fix spurious timeout
Message-ID: <20240227042346.joa66rfv5324mnmp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915261.896550.17109752514258402651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915261.896550.17109752514258402651.stgit@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 06:01:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I have a theory that when the nfs server that hosts the root fs for my
> testing VMs gets backed up, it can take a while for path resolution and
> loading of echo, cat, or tee to finish.  That delays the test enough to
> result in:
> 
> --- /tmp/fstests/tests/generic/192.out	2023-11-29 15:40:52.715517458 -0800
> +++ /var/tmp/fstests/generic/192.out.bad	2023-12-15 21:28:02.860000000 -0800
> @@ -1,5 +1,6 @@
>  QA output created by 192
>  sleep for 5 seconds
>  test
> -delta1 is in range
> +delta1 has value of 12
> +delta1 is NOT in range 5 .. 7
>  delta2 is in range



> 
> Therefore, invoke all these utilities with --help before the critical
> section to make sure they're all in memory.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

This patch makes sense to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

Just better to give 1 or 2 whitespaces to diff output message (especially the
lines with "+") in commit log :) I always need to change that manually before
merge the patch :-D

Thanks,
Zorro

>  tests/generic/192 |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/generic/192 b/tests/generic/192
> index 0d3cd03b4b..2825486635 100755
> --- a/tests/generic/192
> +++ b/tests/generic/192
> @@ -29,17 +29,27 @@ delay=5
>  testfile=$TEST_DIR/testfile
>  rm -f $testfile
>  
> +# Preload every binary used between sampling time1 and time2 so that loading
> +# them has minimal overhead even if the root fs is hosted over a slow network.
> +# Also don't put pipe and tee creation in that critical section.
> +for i in echo stat sleep cat; do
> +	$i --help &>/dev/null
> +done
> +
>  echo test >$testfile
> -time1=`_access_time $testfile | tee -a $seqres.full`
> +time1=`_access_time $testfile`
> +echo $time1 >> $seqres.full
>  
>  echo "sleep for $delay seconds"
>  sleep $delay # sleep to allow time to move on for access
>  cat $testfile
> -time2=`_access_time $testfile | tee -a $seqres.full`
> +time2=`_access_time $testfile`
> +echo $time2 >> $seqres.full
>  
>  cd /
>  _test_cycle_mount
> -time3=`_access_time $testfile | tee -a $seqres.full`
> +time3=`_access_time $testfile`
> +echo $time3 >> $seqres.full
>  
>  delta1=`expr $time2 - $time1`
>  delta2=`expr $time3 - $time1`
> 

