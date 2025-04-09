Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F751D86F2
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 05:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744175102; cv=none; b=rVU8UJZN08mNdAa/6ei/lx7l/8gGF4dts3Akl3oZNeWszKg4tcDI+hwjr4L66+pDGGXnabMxWijCw74dV4QBi8MIGpihQtgDdX86K6wuz6DhIVNUmWitrzLau6+mqN4s/M2g9osoneseL90U/ASObfEq38RHFosnfYlJbed2HZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744175102; c=relaxed/simple;
	bh=UqMD5apIFlDteCOIyX/lwa0HCAXVdzeqy/bejU0wBtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3nWbBRX2F01Z3ZpST1ZHzYyqOFehP76LtJRWLQe8bqA6t/68u1Q6EBAyVbvDcbZ664fpkYoRuiIjI507MJGa2/FECuyiWfAHHKzlaCWzhgEUhiCLAYM1vxSyI0qRper14ETQ0h66epK8iA7APGDNLGZoSRmnoXISc0NCHXhQgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OUf5AQm/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OUf5AQm/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744175098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1y3iAg9Agds/Ogx11q6UpGaQVkkfD7b35TZnTxtdUOA=;
	b=OUf5AQm/rud5i4xRWtwXfQjG7+q1nmBulEHErVzSnSnSPCMfNNGN1/YZvKOJYXzu1bjrnR
	bxoOpr/QZIdxZFjCLIhdCM2Qysip76ySu3vGItsuxl2qVo30tZbRo8Ma1VAm6Rr//0j+CX
	DObQFH65iZOrzjrZiRCs3MCvF7qqVCo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-i6bqrIulOKaViq3hFTV6-w-1; Wed, 09 Apr 2025 01:04:57 -0400
X-MC-Unique: i6bqrIulOKaViq3hFTV6-w-1
X-Mimecast-MFC-AGG-ID: i6bqrIulOKaViq3hFTV6-w_1744175096
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-306b51e30ffso3450595a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 Apr 2025 22:04:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744175096; x=1744779896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1y3iAg9Agds/Ogx11q6UpGaQVkkfD7b35TZnTxtdUOA=;
        b=Y6i89+21mv/q5ec1HrVSNSUwhH295cPXhM16czEe+XJHJDB0uiVBBP58zbiLHgeJXo
         bT8x3Gb136rdNY8E0ruN6Ru7k4WS3aKFfS8iROr27c/dsidYuQaRetOl/varIewIdW7u
         fsnLnJM5wVxdVGkVCUc8WlrBb42i31LMbgxXCQbu1IFYpUK2Ue/hhJgr3QU9Dn2CFMC6
         TtBHD+y5naIvyfHQHefxpkvFoiXw292yGA8jMjyAAcVsQvsipEScLw7C7FKMCIIb7EbI
         im3nL5D5GVN9WEdPpgM4CwwU271nWiFD4Xj/o1HyEJhrqExfZdDcI11Ue2FfUYIj9ptf
         3wlg==
X-Forwarded-Encrypted: i=1; AJvYcCXcExVzxz73lDjz7380L4jB5y5S1vfeaArUD1ZveFQpEKTqdCrT+AhPQouho/nnLciwLtgd+jIYKY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YygGkIL1fR6JqDBj3xtS12TM6E69aZV25CiLud06K7mxg+RAum0
	zBWU5+5nR45E/Bt9z2mluQ/FxAN/IR/slzIhzFy07Ag+uVLxf9fGFjqE48r3v2+TQngLbOITcst
	+gZuDdhUewL+fZfaX0nSaPVLk/AHWTVMfNw4RlQI7X0VIo7KgJqa7rKLuYA==
X-Gm-Gg: ASbGncuKJSiqS+jS1slHb2fIWzcck6b5s0z1XLY1MprI0Oic6RYR7tBq+HBvxF3+cL1
	bg40Q89SZIST0Kw6hBzea/GtO0rsmQF929nWNcaA81YMLxSKNDcwwCrALSQ5bfs5x7zNqxPZ/LB
	wZ7cCYvwCaWorPIoxspZzOEop+ZPL5H9etrc0THlwDZIGdlmvyaUnZiSIMMdS4UUNirnoRR92bm
	YbtKaFcXNThey7vOFZeZlKxvgtPW2Ge2zBXo1twd1mmOxJ5CJ4Lc+/652ptLxP8SPlH2xbujHy5
	3sH3OSL6T8ktCGBEcIqezpHH6WGaaYsbd1K3q0gLHT/5b9aFw5vtMkbe
X-Received: by 2002:a17:90b:5488:b0:2ff:6488:e01c with SMTP id 98e67ed59e1d1-306dbc390e9mr2115569a91.29.1744175096036;
        Tue, 08 Apr 2025 22:04:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDcrE2k0N742zHbBe7oI20IFqxVkjJZoXi1LOt1Rkg6ayMeaOnkhcBhB907+V8zBE2CUb15g==
X-Received: by 2002:a17:90b:5488:b0:2ff:6488:e01c with SMTP id 98e67ed59e1d1-306dbc390e9mr2115544a91.29.1744175095663;
        Tue, 08 Apr 2025 22:04:55 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7cb544csm2383045ad.167.2025.04.08.22.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 22:04:55 -0700 (PDT)
Date: Wed, 9 Apr 2025 13:04:51 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v3 2/6] generic/367: Remove redundant sourcing if
 common/config
Message-ID: <20250409050451.tzw5e2g5fpk3ktne@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1744090313.git.nirjhar.roy.lists@gmail.com>
 <ffefbe485f71206dd2a0a27256d1101d2b0c7a64.1744090313.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffefbe485f71206dd2a0a27256d1101d2b0c7a64.1744090313.git.nirjhar.roy.lists@gmail.com>

On Tue, Apr 08, 2025 at 05:37:18AM +0000, Nirjhar Roy (IBM) wrote:
> common/config will be source by _begin_fstest
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/367 | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tests/generic/367 b/tests/generic/367
> index ed371a02..567db557 100755
> --- a/tests/generic/367
> +++ b/tests/generic/367
> @@ -11,7 +11,6 @@
>  # check if the extsize value and the xflag bit actually got reflected after
>  # setting/re-setting the extsize value.
>  
> -. ./common/config
>  . ./common/filter
>  . ./common/preamble
>  
> -- 
> 2.34.1
> 
> 

