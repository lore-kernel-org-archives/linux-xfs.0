Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A881259484
	for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2024 13:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734873448; cv=none; b=SjS7PCyxBlsnYnLKsw0Dm6XWDC+pkkZAnrNqnRTkmDdCAF5zWw6vYQWQ7Y55G2MfoqN0bLK/wL/1oi2F2AjBSqkLjG6C2oYc7oAuhxBfalYZ0CCoT+yHyZojHznySZRcgl02/ePGLvhW5rHXj9v8Uhwh+pvNg4XMxYlx96uX26U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734873448; c=relaxed/simple;
	bh=KiEDN6IM6AxzbivPQSx1WyE4Jr+peAAeSa0y5yUJliw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaRmDfGv9aOCV2r5bUg6HHZwgztzjiFzcIR0470YyvCBvLRJuhGEkCetzC9/i7t9TijafsZmsHHeF8PZuty9e+unOb7QQJqGruWRav8o5Vl10uSX/akAeYBl3+mTGC9wn/LlM5nupwoAwfbaHlouAjepZBW/0URov3TYxZEcckc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4mMLv9w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4mMLv9w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734873445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tCZ27iwJNeA5kN1ByuginRyvw6IOQeUqQCNx0v/T2sA=;
	b=N4mMLv9wzoiGGoOysk1UYxRcSdb3bp/l+hCDOdreo53WB+MMoVcYlc2XWjGPT4WQSdnwjg
	BPv5384rwIGJQbVbug8Qlx9DIWCWEGDmZUreNTbqGbpcSqApEvhfvrTeB9lI4Ikww+iW5o
	dPpfLT56iyQ9z43lHissd1o+iO4dDzQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-68gdgl-gP76foQ4U4blqUA-1; Sun, 22 Dec 2024 08:17:22 -0500
X-MC-Unique: 68gdgl-gP76foQ4U4blqUA-1
X-Mimecast-MFC-AGG-ID: 68gdgl-gP76foQ4U4blqUA
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-728f1c4b95aso2875583b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2024 05:17:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734873441; x=1735478241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCZ27iwJNeA5kN1ByuginRyvw6IOQeUqQCNx0v/T2sA=;
        b=OyGkiTSwwKBlMMyP0L8nSSSSNJYsKH58PlsgOu5iR2fZpgDZFkbHOX6aiYMBst+wie
         FidiuGz1ISVSkZzhshqfLs0+p3Y3CXCe/CjOmmoyYteKxXuA12zcn4BRn32Q7Mr4bqJ7
         Rl//171vMZhEomSSlepNf3K0/gyINMW01gyBJj/Mfpx8qZvrZo44r9CDCM22+izIJkE5
         CoXYF3iETGGU6LAraog7YpY9fjCRhxonLrgdKnRi42JVdRksQxaWfxi+vwd23E9X6F0a
         Tv9znEz0kePxaY9xh6H+M3FKNsDBXXmk6z/tOFVotid3PwiqjPUM3KuVCdvUvYOHLhm9
         1iyg==
X-Forwarded-Encrypted: i=1; AJvYcCXM3k5GX9NG3wjwBQbGWlFUOyJbqepW6vIDCqlGvkRsjQ9pI4kxg48nc+bMQGph6zwqMXG8VFonemA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgL7q6WZl1iIIxzM66WCWCQ1aUtCiJtyv5VOdWlrFynNO66O5y
	Qu1UroTc1Eqkl66CSGQzL/p1K2+vKgHVr5KfjsG2jkQE9UcsDZjGD4oJz2ws0B6Md3RPoZ10Vup
	klEwfI6u/fxXzLYcrVr1WpI/9rWrnYwFOC9nlqcoZ/weWqwOQEByZfpFY+/OGxHe2Eb5F
X-Gm-Gg: ASbGnctI5BcCl+4STCBNfKeYJguzUIIulUgM5eVtXPA17WISo2RdhkL/4vHzlsOj03h
	gIL3cQBwVbPrnVc3U0PKrjU9UcgW7JnQ85zklQVmW4v7oqqbX0ODkP3Bb6HMCnYyVQRqzi0Ji4A
	XpfrqAcIHGmYQlvBM5speRWHBecspCCSfTnQvXeQPH7NQnGV6Yh0rcc8D3Je652DjF9JGxU9/lZ
	Kq+JV18yqtRxPVNKEVhv5bwqkDvi7mDlmfJOfw57pEj4t4skYkG47qP5yIflAMC8xjB3KwnG8PG
	uCCNYBBP1+XXLsvl8Ti4MQ==
X-Received: by 2002:a05:6a00:35c9:b0:71e:6c3f:2fb6 with SMTP id d2e1a72fcca58-72abde65a60mr16799738b3a.8.1734873441539;
        Sun, 22 Dec 2024 05:17:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhKVpn8PabeeEpUUjxPKJHzrKNeN4vf1QATxTU5gx0n5lbiFepTXrTWYMATwg/YuPEyEC2ag==
X-Received: by 2002:a05:6a00:35c9:b0:71e:6c3f:2fb6 with SMTP id d2e1a72fcca58-72abde65a60mr16799709b3a.8.1734873441155;
        Sun, 22 Dec 2024 05:17:21 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8fb8adsm6308045b3a.143.2024.12.22.05.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2024 05:17:20 -0800 (PST)
Date: Sun, 22 Dec 2024 21:17:16 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/43[4-6]: implement impatient module reloading
Message-ID: <20241222131716.xx3hl6r6hntpj44m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
 <173328390016.1190210.6222399993436200525.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328390016.1190210.6222399993436200525.stgit@frogsfrogsfrogs>

On Tue, Dec 03, 2024 at 07:46:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These three tests try to reload the xfs module as a cheap way to detect
> leaked inode and dquot objects when the slabs for those object are torn
> down during rmmod.  Removal might not succeed, and we don't really care
> for that case because we still want to exercise the log recovery code.
> 
> However, if (say) the root filesystem is xfs, then removal will never
> succeed.  There's no way that waiting 50 seconds(!) per test is going
> to change that.  Add a silly helper to do it fast or go home.
> 
> Reported-by: sandeen@sandeen.net
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/module |   11 +++++++++++
>  tests/xfs/434 |    2 +-
>  tests/xfs/435 |    2 +-
>  tests/xfs/436 |    2 +-
>  4 files changed, 14 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/module b/common/module
> index a8d5f492d3f416..697d76ba718bbc 100644
> --- a/common/module
> +++ b/common/module
> @@ -214,3 +214,14 @@ _patient_rmmod()
>  
>  	return $mod_ret
>  }
> +
> +# Try to reload a filesystem driver.  Don't wait if we can't remove the module,
> +# and don't let failures related to removing the module escape.  The caller
> +# doesn't care if removal doesn't work.
> +_optional_reload_fs_module()
> +{
> +	MODPROBE_PATIENT_RM_TIMEOUT_SECONDS=0 \
> +		MODPROBE_REMOVE_PATIENT="" \
> +		_test_loadable_fs_module "$@" 2>&1 | \
> +		sed -e '/patient module removal/d'
> +}

Thanks for fixing this error report, it looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> diff --git a/tests/xfs/434 b/tests/xfs/434
> index c5122884324eb0..fe609b138d732b 100755
> --- a/tests/xfs/434
> +++ b/tests/xfs/434
> @@ -74,7 +74,7 @@ _scratch_unmount 2> /dev/null
>  rm -f ${RESULT_DIR}/require_scratch
>  
>  echo "See if we leak"
> -_test_loadable_fs_module "xfs"
> +_optional_reload_fs_module "xfs"
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/435 b/tests/xfs/435
> index 0bb5675e1dba23..22c02fbd1289bb 100755
> --- a/tests/xfs/435
> +++ b/tests/xfs/435
> @@ -52,7 +52,7 @@ _scratch_unmount 2> /dev/null
>  rm -f ${RESULT_DIR}/require_scratch
>  
>  echo "See if we leak"
> -_test_loadable_fs_module "xfs"
> +_optional_reload_fs_module "xfs"
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/436 b/tests/xfs/436
> index 1f7eb329e1394e..6a9d93d95f432f 100755
> --- a/tests/xfs/436
> +++ b/tests/xfs/436
> @@ -69,7 +69,7 @@ _scratch_unmount 2> /dev/null
>  rm -f ${RESULT_DIR}/require_scratch
>  
>  echo "See if we leak"
> -_test_loadable_fs_module "xfs"
> +_optional_reload_fs_module "xfs"
>  
>  # success, all done
>  status=0
> 

