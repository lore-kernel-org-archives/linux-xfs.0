Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC4C19FA93
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758900951; cv=none; b=XpFN7vJYqYoR9IOL+nwckkks3061o5TTn+NHbuXt9IvFScUthzijXDPrx3YUTIHLcZzg52mFlHL2/DtVz6qh86WrSIz526+mA4zkWNsa38MfibK99qB7glgW/ZG6+/b15yhB2pgAl7BZWbcPp/MM64c80IF+wTzELfJ+Is7wV5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758900951; c=relaxed/simple;
	bh=DIY1/K7PAISZ3lY0wenUqREBig6mZBSOUoa1uwmn2vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIz4baTKIY6OgNyBS1tS2aCu+oWAKISJwdlp/H2UsRqd7Hyu16WX+NBACMP9I6Z9uexrOUXQNhh7jxmqQdmoqNmtGl5p23TfJtPocg3JPEXmKEHpqdDUpiM71tOca6VmTp44lVB79DR7sQJY95B9xVMRLbaXPoRh7NBKDgbOD5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fSvlQLTg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fSvlQLTg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758900949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UMnZJwNq/Qh9pPuQIYwq9bT1GHx7kd5Vb/OSc2d1dpI=;
	b=fSvlQLTgdbHzKQPP2CM91FCq8m7MfxsFvowcSUKqUKy6e6q9aZCWo0JASH3XFWe3T9kLIC
	+y+rIDbepJZwVaThL2M8Qk354mNWd/1vZ0Led3+zs9Jt9/8yKyFc9Fw391a+5z2H5jXDiB
	eeNnEI0Ak8A3P13RL8FR86OLTYfV3u0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-lUqzNEDPPnOzyzwdwjfibA-1; Fri, 26 Sep 2025 11:35:47 -0400
X-MC-Unique: lUqzNEDPPnOzyzwdwjfibA-1
X-Mimecast-MFC-AGG-ID: lUqzNEDPPnOzyzwdwjfibA_1758900946
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-780f914b5a4so2437424b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 08:35:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758900946; x=1759505746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UMnZJwNq/Qh9pPuQIYwq9bT1GHx7kd5Vb/OSc2d1dpI=;
        b=sRP2XBXxfpMkEz6We0KKqOkuCKU1v+HrHGQotpb4zXHaXXCFb9OeYpwjdv7iFZ80Wd
         H7yXAHVjmOSgCe9yultn/JkXEGsKFyucvmhQunJJ4AGlUGnp280418JBV5J6GySq7T2Y
         KdCutiEhRJKeBecopJrS62e1KEAY8Jx/re4tDZO2wmfNeHjpMDmYcJ2km7Q0p/npG1t4
         SCcBwaJligarTZD8RzDykWdI7OnEyzMpu5/p6/7lOsPmkvT+AynmKRrHo6csjnrGF+iq
         LPA9pa6eba1Jp8fuKgSst7l7JL1Y4e4Z1gBBjT3OXrTd1eNH2VHFdubgGMCu1v1r11rk
         7s0A==
X-Forwarded-Encrypted: i=1; AJvYcCX3Xgsd10AwU1E+0hCLOLDHB37p2835yhnWeVSuqDdiVvzXsKq/kh9j3L7FEtlcf7pWLDdnO/BTga8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX+j/rcQjSq34VTOALuKArkPL0hPb7mjrTxUffu0p3KLnyBZFa
	4EyMeiuoSO6LY2wTsJm2rn0a0KIB48hVbxufe3lSoiuICIzO8vRzktIVHehSdiCf8RimQXueOM9
	RS2g1/CAZsm0nzE0SJZfKwo/ICQAN+FJnIQQlA9nJ1xBAcOQV7vJagDl63VVPCA==
X-Gm-Gg: ASbGncv6VOsdkH+rr7fQ1ryWvSKJJ7k86y/rt8X9h36SxYexbu19icF3k2VuloHOaGE
	IlsPoYFNIncJesqU1f9UFGnXOpoGbJDnAhabaAeKOaEx78AplxEQltQJlhRpwAUH9+GCvTaYNMw
	WbagymXNaftP+9VWTRyHJy3M2Ijk3T9NhLERChBECaK0bU+UcA9xC+yigTty2rWwb8d5hDPfHFZ
	AJ+0c6tlspgMW/pI3R37rVtcloZoOIun35O1m4poeQacpwHvhvlEFqRgGyKbanf7x+vXgjUmnHi
	qGqKRHw4voQguhldjDPN3ekivEu3Z6nwDsVIgR7p1grfKbD93IDMLdjNXxvd9A0LK8nKsZJIlLc
	+6Z2E
X-Received: by 2002:a05:6a21:a8a:b0:2fa:52a0:e838 with SMTP id adf61e73a8af0-2fa52a0e86bmr1863145637.36.1758900946178;
        Fri, 26 Sep 2025 08:35:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcI6P0UwKryoSs2/8FpENei96l+FfS1D9JGd5pXUeSXa5ves2yT85gWQSP1/Q9ATYqMG6Hnw==
X-Received: by 2002:a05:6a21:a8a:b0:2fa:52a0:e838 with SMTP id adf61e73a8af0-2fa52a0e86bmr1863110637.36.1758900945648;
        Fri, 26 Sep 2025 08:35:45 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7810238cdd1sm4667586b3a.3.2025.09.26.08.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 08:35:45 -0700 (PDT)
Date: Fri, 26 Sep 2025 23:35:41 +0800
From: Zorro Lang <zlang@redhat.com>
To: cem@kernel.org
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/613: remove attr2 tests
Message-ID: <20250926153541.zemxeuidyugeh3v2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250925093005.198090-1-cem@kernel.org>
 <20250925093005.198090-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925093005.198090-3-cem@kernel.org>

On Thu, Sep 25, 2025 at 11:29:25AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Linux kernel commit b9a176e54162 removes several deprecated options
> from XFS, causing this test to fail.
> 
> Giving the options have been removed from Linux for good, just stop
> testing these options here.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  tests/xfs/613     | 6 ------
>  tests/xfs/613.out | 4 ----
>  2 files changed, 10 deletions(-)
> 
> diff --git a/tests/xfs/613 b/tests/xfs/613
> index 9b27a7c1f2c2..c26a4424f486 100755
> --- a/tests/xfs/613
> +++ b/tests/xfs/613
> @@ -163,12 +163,6 @@ do_test()
>  }
>  
>  echo "** start xfs mount testing ..."
> -# Test attr2
> -do_mkfs -m crc=0

OK, as attr2 option is removed earlier than V4 xfs, so the _require_xfs_nocrc
is helpless for this case. Thanks for fixing this,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> -do_test "" pass "attr2" "true"
> -do_test "-o attr2" pass "attr2" "true"
> -do_test "-o noattr2" pass "attr2" "false"
> -
>  # Test logbsize=value.
>  do_mkfs -m crc=0 -l version=1
>  # New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
> diff --git a/tests/xfs/613.out b/tests/xfs/613.out
> index 2a693c53c584..add534bd63a9 100644
> --- a/tests/xfs/613.out
> +++ b/tests/xfs/613.out
> @@ -2,10 +2,6 @@ QA output created by 613
>  ** create loop device
>  ** create loop mount point
>  ** start xfs mount testing ...
> -FORMAT: -m crc=0
> -TEST: "" "pass" "attr2" "true"
> -TEST: "-o attr2" "pass" "attr2" "true"
> -TEST: "-o noattr2" "pass" "attr2" "false"
>  FORMAT: -m crc=0 -l version=1
>  TEST: "-o logbsize=16384" "pass" "logbsize=16k" "true"
>  TEST: "-o logbsize=16k" "pass" "logbsize=16k" "true"
> -- 
> 2.51.0
> 

