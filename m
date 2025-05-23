Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7DB248F73
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748009035; cv=none; b=PKQezXvwpFkNA/D2hES88IvZNHPWdRUYhKIjPSAw6iAenRGb3R2wN5kdocUDKZzxxvY5A0mw6c43JARr0iOCI4NL+Niptft0FqHousQt/W21KrKXSQBZ/OOEkuNEFmu5bRt2KiBJHvWLOOy79n0boDYzKtdtRfzAaJg6ltsfEEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748009035; c=relaxed/simple;
	bh=DGkXuHEeaKTLfrGvSNgzGoTOQMi11yZ1xm0b38NCK2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trQZQFVzME+raFDLsAVtyWXSSZyO95l+GeWfwUY+1ceBZ0lPrwVjKUj20X74HGUu5ri+a/egCcShKr0kmvZKOmHBpy/eV+bpxYeh0rZz6yr8MGzogSYfzJCOn5LAwL3T/KG8DjEE0se31OqhWe4Ooq5obZCI19SMXlIfQUzpFzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VP+nvUDy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VP+nvUDy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748009032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4YGRKcfNyyUn6jZ4ThCK6xz4VOL69I1YIik12BFOPpw=;
	b=VP+nvUDyAgcvwjfq6QnBqnN2teNZMkQg4aysQwmkOL8s5wOQKNvDKfoDL9T5XL9tz7uXGI
	cx47mq0Jd/C+McqWF/8Hl8jHEnioOoa44rjtLSA1soQAlf3BBS13aIpTMWeUrsCZwmCsjZ
	KGqCg4LA2vnFVgKdWOxXCE+1XGtxHF4=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-54ARXm1MNXeYqFi39yepNw-1; Fri, 23 May 2025 10:03:50 -0400
X-MC-Unique: 54ARXm1MNXeYqFi39yepNw-1
X-Mimecast-MFC-AGG-ID: 54ARXm1MNXeYqFi39yepNw_1748009029
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-740adfc7babso7740349b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 07:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748009029; x=1748613829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YGRKcfNyyUn6jZ4ThCK6xz4VOL69I1YIik12BFOPpw=;
        b=xOXy8aazNZEgOZV44Ew/N5LSqHxjZhZ8+y76jIhdyNUv6iATIFkYDAQf1hJskAIHHq
         MkVnBIierMNd6MDUe0aPqqJErD+elfpx3Yzj1kh/CdIRWsp4RF5XR/Bud3CnvzkBhYBo
         6REnRgrvrBOIOjWhiOmQSqwvMiqjOgROKbpGIk+6e51Bgl6O1SHS2/obVF2Wa9CduoBm
         nMnGlGWHHS5Jck84HXsgmY7HDtOvDJVLKi4NWHwNMzSXa3glJAvYliF6dZjeGYHL9fJh
         BRMQ1h5ccODC2lZm0RSqHCFQP2BkHVwtyfnGXnjJqq0gO2w0++IrS4EaLHFv7yoZXKiS
         Xeag==
X-Forwarded-Encrypted: i=1; AJvYcCWkqjBFmq/EsKfQk70Pubvt69xcs9oPiiSoop2UhvnxHzkN60is00g6qdQMbgpvSqLAMZFcqbfrSnY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5p+GnBEm4yUbGKUTMQmkMaJ8uV9HeJCzu6TaUbrjpZDx4lOrh
	Nr0QXnt9TfVtlhPI7bMw14QqWLFSZv7B820eYPGHSdLrKQFveXA0BlXaMb1n2Jmc24LbJlaE+ye
	EyCAK8UxX6Bgx9Ub24x0Oh8r02yy6b1MX/NZ2ghiOxpr9yPleEN1e3dBsHLjWOw==
X-Gm-Gg: ASbGncsZ6H6vQxL/1pfqmKExATrWc2ZRlKnTlUzz4cLJvEUCwCukvG+l2QtjHWWQtr4
	rirCFC6GYMW2Z17cPSL/XWy6SDQDvdkLiouWuP9mJpN7rODX99rEik0jpkwSUKQTvzKlM2a7EaU
	NW6loonzqU4MAxBlN18m0k2GncrgUJ2EWqwnfw5ztqpkONqp3d7GSCAmBicweRheFpM+pubWZfv
	jeZbt4MIQp79yHQQplaAcLHq2KOOg0w6XaFuKv19bY7PGbJcmvqBdZuaVAWehE6/Ll2+v+NjIcb
	gsiKOkrZfDS5ckUMa3ZM2eC33y1fimfqZK3x8Ll74C8pH3TgSWAz
X-Received: by 2002:a05:6a00:3cc7:b0:732:2923:b70f with SMTP id d2e1a72fcca58-745ed87c9b5mr4232724b3a.11.1748009029362;
        Fri, 23 May 2025 07:03:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGj17p1KKn+GDztyBFqeRvJRnpGGbjfNutmIwYVNXD38chctaNMiPd24PVPyBf3pQmeyrOY5g==
X-Received: by 2002:a05:6a00:3cc7:b0:732:2923:b70f with SMTP id d2e1a72fcca58-745ed87c9b5mr4232686b3a.11.1748009028952;
        Fri, 23 May 2025 07:03:48 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a98a3403sm13273668b3a.177.2025.05.23.07.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 07:03:48 -0700 (PDT)
Date: Fri, 23 May 2025 22:03:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v3 1/2] new: Add a new parameter (name) in the "new"
 script
Message-ID: <20250523140343.nabmzlbss346faue@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1747635261.git.nirjhar.roy.lists@gmail.com>
 <2b59f6ae707e45e9d0d5b0fe30d6c44a8cde0fec.1747635261.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b59f6ae707e45e9d0d5b0fe30d6c44a8cde0fec.1747635261.git.nirjhar.roy.lists@gmail.com>

On Mon, May 19, 2025 at 06:16:41AM +0000, Nirjhar Roy (IBM) wrote:
> This patch another optional interactive prompt to enter the
> author name for each new test file that is created using
> the "new" file.
> 
> The sample output looks like something like the following:
> 
> ./new selftest
> Next test id is 007
> Append a name to the ID? Test name will be 007-$name. y,[n]:
> Creating test file '007'
> Add to group(s) [auto] (separate by space, ? for list): selftest quick
> Enter <author_name>: Nirjhar Roy <nirjhar.roy.lists@gmail.com>
> Creating skeletal script for you to edit ...
>  done.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  new | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/new b/new
> index 6b50ffed..636648e2 100755
> --- a/new
> +++ b/new
> @@ -136,6 +136,9 @@ else
>  	check_groups "${new_groups[@]}" || exit 1
>  fi
>  
> +read -p "Enter <author_name>: " -r
> +author_name="${REPLY:=YOUR NAME HERE}"
> +
>  echo -n "Creating skeletal script for you to edit ..."
>  
>  year=`date +%Y`
> @@ -143,7 +146,7 @@ year=`date +%Y`
>  cat <<End-of-File >$tdir/$id
>  #! /bin/bash
>  # SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) $year YOUR NAME HERE.  All Rights Reserved.
> +# Copyright (c) $year $author_name.  All Rights Reserved.

Dave thought we shouldn't use "author_name" at here:
https://lore.kernel.org/fstests/aC509xXxgZJKKZVE@dread.disaster.area/

If you don't mind, I'll merge PATCH 2/2 this week. If you still hope to
have the 1/2, please consider the review point from Dave.

Thanks,
Zorro

>  #
>  # FS QA Test $id
>  #
> -- 
> 2.34.1
> 
> 

