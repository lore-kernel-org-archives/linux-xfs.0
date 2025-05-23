Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2501296157
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 15:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748013080; cv=none; b=LWhWLmLbiyMgrmLPsSC3HInz1lEti9VxTtnF29cQG0N6tQaFKM4vr2qRbl3UNS6xzGMOMmCPDuJNp4n5OTXd/wJKETTiHurGGT+szPEh0fa9gxKWZUS0j3WC4s0Bsip4pUVJMxozO+sEtVEJ24sPg+EObAdhdqQY4KqRfEQHSi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748013080; c=relaxed/simple;
	bh=+tReRAgv0vI30RDuIgS++Ebwbd8kzKFBgqf3nLvaLf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXSxgLMGMgiyIQVeTHNH77OqFPFr7sGaXuLbhBBfuJQvr/Q/Ag+fzUAdsJcaFi1ETLycBiPIwplszeD20GbXob0B4K3VepRVegUj1oHz3hTaXmCZAS0axvn40rsiL7PmZ9HW3gRC7Ocm6VTAN0qsfNVOP9yMsMORQrEbmJG2jg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ma2L2Irn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ma2L2Irn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748013078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voaSsyYj2YOmvOIrQ6J0fboFnlH7C77mXI0eP3uhd0k=;
	b=Ma2L2Irn5TfdIW7kB+LanM6o6cxuu1dMVhY7sDz2ciJ3tPpDEOS281bnoB85jrSu/tN912
	Ng1bWCgs2fu9MykCWqtdJQPy+sV5ZLUZWKdhDYeO8g0JtLh7XkNyOevqWQ5w955Y9Dekr5
	NlsN2CUJFpeN2mkVGYe8OJ9tOaAt5VM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-5v6dcunXO4mxNC9kwuQKmg-1; Fri, 23 May 2025 11:11:15 -0400
X-MC-Unique: 5v6dcunXO4mxNC9kwuQKmg-1
X-Mimecast-MFC-AGG-ID: 5v6dcunXO4mxNC9kwuQKmg_1748013075
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-742d077bdfaso65527b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 08:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748013074; x=1748617874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=voaSsyYj2YOmvOIrQ6J0fboFnlH7C77mXI0eP3uhd0k=;
        b=DpfiDsvijaBIVEMupHi8he4kLiShn3bZ0BHCi4t/FaCnIqd5yDLYZSf5sN6z3ZHsis
         vprpWV3C5Sp4l7YtdhQVQg8CYha3sYsZshqCKy321dpPbxj0zWWMJ1VG1pkD+piwMz8y
         U063NBugleHQzfsWX5cXNZPsHJ9eXSVL66pkAaHakLS8iHQxiHsxsidyc8h7rLgNMXiH
         JofKSmoFx/ZF6U3o5CZZd/25MMoE0xw11l5cCazRMS0ENlMOVu+taAbVQ2mzIb9CJ0DH
         h5XN69jb/V1BwcTPCfl2VMnp4bFDKJsB6q3J/vBzQhSjS4mJuCOOQbD/4i2QAf5FG5ps
         NeQw==
X-Forwarded-Encrypted: i=1; AJvYcCVbR9ByioQRPAA54hPM1XFF5p/KJ1bz4P5pkKyVLZcAxJUYKsKulVf9GbF3Yu3LHuMpB/IlFdpJKzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRhWDtXN6zqyQUaVHxGLAJCL7aeljOE8guABQgeqLvOoB2CNqo
	hVRDmhaozn0r7QcdTw7yMAINiU11UYFRRlsm52o0wlRNHrch0LFy7e87atmOzc/r5QH0jcHDvey
	bLgRY5xxfxDhpdSZor/aftG8jeKnDKuRIeni8jHZxpHk+FMMcPRcI08rBE9YJlw==
X-Gm-Gg: ASbGncsGQOhQZv6Xos51V8bKEpZQlrZ2OxJ9Bhpxsd6XYF6SOwENIR26zVpzISoLLQH
	+rGfI/k7dGYuzHwa5U5sFymksWw5rsz88RyZG5OZWD5VZhJLEiifQxxaM/qIMrcBiZziMNnvO3y
	h/O4NkHFSpxSKKicah6mhsFnXbMn02+UJam1d1pVByxVE1reW+vk5hwClUEJBxPfgWqEWvxdAZS
	o6D090cOwEAbbq/VmBLGpc07uweCU/j9vxsu9U/2Xjrb7jc5jWFHFLUhn1Xr4yjEgqNzeg01eoa
	ckh7DsKby1Me6C5eC+hDdPgJspHfwKgGfWbqm+1kfUmutGEJHybY
X-Received: by 2002:a05:6a00:1705:b0:742:da7c:3f30 with SMTP id d2e1a72fcca58-745ed8f5cffmr5029423b3a.19.1748013074606;
        Fri, 23 May 2025 08:11:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbaSPNwoZLNrAuqi+CqpvcPBlF151WSA0skLZzhPzzTFD58zs05MmaKUwsU1qXxvi/84EA2Q==
X-Received: by 2002:a05:6a00:1705:b0:742:da7c:3f30 with SMTP id d2e1a72fcca58-745ed8f5cffmr5029380b3a.19.1748013074227;
        Fri, 23 May 2025 08:11:14 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a970e1a3sm12784504b3a.71.2025.05.23.08.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 08:11:13 -0700 (PDT)
Date: Fri, 23 May 2025 23:11:08 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v4 1/2] new: Add a new parameter (copyright-owner) in the
 "new" script
Message-ID: <20250523151108.axky3xfznd5yackb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1747892223.git.nirjhar.roy.lists@gmail.com>
 <72c4879ec3f037db0478bdf0c64c1fbc6585cea7.1747892223.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72c4879ec3f037db0478bdf0c64c1fbc6585cea7.1747892223.git.nirjhar.roy.lists@gmail.com>

On Thu, May 22, 2025 at 05:41:34AM +0000, Nirjhar Roy (IBM) wrote:
> This patch another optional interactive prompt to enter the
> copyright-owner for each new test file that is created using
> the "new" file.
> 
> The sample output looks like something like the following:
> 
> ./new selftest
> Next test id is 007
> Append a name to the ID? Test name will be 007-$name. y,[n]:
> Creating test file '007'
> Add to group(s) [auto] (separate by space, ? for list): selftest quick
> Enter <copyright owner>: IBM Corporation
> Creating skeletal script for you to edit ...
>  done.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  new | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/new b/new
> index 6b50ffed..a7ad7135 100755
> --- a/new
> +++ b/new
> @@ -136,6 +136,9 @@ else
>  	check_groups "${new_groups[@]}" || exit 1
>  fi
>  
> +read -p "Enter <copyright owner>: " -r
> +copyright_owner="${REPLY:=YOUR NAME HERE}"
> +
>  echo -n "Creating skeletal script for you to edit ..."
>  
>  year=`date +%Y`
> @@ -143,7 +146,7 @@ year=`date +%Y`
>  cat <<End-of-File >$tdir/$id
>  #! /bin/bash
>  # SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) $year YOUR NAME HERE.  All Rights Reserved.
> +# Copyright (c) $year $copyright_owner.  All Rights Reserved.
>  #
>  # FS QA Test $id
>  #
> -- 
> 2.34.1
> 
> 

