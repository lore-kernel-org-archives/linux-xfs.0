Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC425B096
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 11:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778586513; cv=none; b=UetdOj7uA0vGd/Xc46Kp0Ql1RuqSqRKV+l0uKFF1GJdGT60KnEI4uDE7FYJwgl6KvBOaZMhZ3tF6MO9egij/wKFVDdkxisTh2j/0KNxjAxFONJKrd/GWHVTBxrrNlbT0Pc+UBRjYK7HrUsbhfpxhuAEbH8Xn0z7VPcD8wJz6RBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778586513; c=relaxed/simple;
	bh=w1U8vOiGZum4pJzIRoGG3wAExJ3LpxoueR2T1kBz3tI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmhtA2tp7/hJkxEusjeK+0Xs801Rs9okKClYz+SpmNyELQdYNzDAS+Cqh74MD/hIA8AF27Hv3EgjB1f47A7I7Nhh3x5ObW1A1mTAEjybw2bG3b+oQ1f1OubGVvsJvae6ZVj0JAiX4dgC66qD8i+VlKxbfET/wuajOyansDUU9pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bKzIdCnZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FwqeFCbm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bKzIdCnZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FwqeFCbm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778586510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gapdPLUjhiPuTjuBqJ6AOpL/kiIySqyYKRqXt63/IJg=;
	b=bKzIdCnZowf63bwye9PZySeWWAD5z2GzsOOGUslmj8emojvAZuuUVRwhpy7SlLS/0GpIQH
	mgGyfxx35sSsuy8jMCHshCKJYDAfoXIND8w6rZvyRKL7AvoMw3zcjHsbUZWRPPb3B21CU6
	lhNbx5slMmDyxQcP+RCdA7fZ2qMGo1M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-uC7lta-5M0emIQtCGFjZAQ-1; Tue, 12 May 2026 07:48:29 -0400
X-MC-Unique: uC7lta-5M0emIQtCGFjZAQ-1
X-Mimecast-MFC-AGG-ID: uC7lta-5M0emIQtCGFjZAQ_1778586508
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44a122a5128so4162397f8f.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 04:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778586508; x=1779191308; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gapdPLUjhiPuTjuBqJ6AOpL/kiIySqyYKRqXt63/IJg=;
        b=FwqeFCbmmIuHgT9qMEupH4hounAVfjNMJZ+oTNTqtcSZOSUNB4AdxAJBuNOWQfcE9u
         gQQ+pimr43drbIVsSd5QV2Mh3yqf1sYiJA+8Ni91iEeyfubsTynmBrQvvwC91WCVA+8H
         tBIPoEd3Lq9At+xJRt4Tzm4BVcE9sT1a2WVA1zF5f9fy3ycep9h6cJvds1O0b3ei8kfj
         oSAINxohSLi/++gLVW5TvNYCXqqRjrMVoSAAyV4p4Sx1C2hA91y8K/2BkFII8RSLS5ml
         A27qgC/hJtoyqoG86gEDsixFJphLNL+GkvnjmGSMDlP1IIObT7OxCNZjO3Jz9f1j/C4w
         IRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778586508; x=1779191308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gapdPLUjhiPuTjuBqJ6AOpL/kiIySqyYKRqXt63/IJg=;
        b=Vzb7yEV4Uhq+z4WVfVQ0aXtGejPKLKbd1ECNiBodeyr63vKWR1Tta+pNHJ16v05nek
         vhflnmKMzQ2sJAvxX8WZq143sm3wNjj/RIoluu6WjljZiHAc0HNEfbfpgSkaIPGPJI1Y
         Z1SMNR7RyiqjV2+F6t8TJDidihLTIOjzTZLOcj4fDESCmPNhAD3bpGY+iMb8IIUduRbU
         3cNyRv0mBYgRxVBhAb1Lofeh3L9CuDpdrIbw5EfD1Z5t3SnHgrOSSN2W2y+NSodFc66p
         o+PWD7AbE+Kmhw18MO5nnj7CZQqpWYcO4XanORvfLzRGPcj4ilSO3FSCBW68jAK3nvBI
         w7Vw==
X-Forwarded-Encrypted: i=1; AFNElJ+HRqQ1Can3EBhh+JMIJv59dnHI3eUSqlcM4E0CIrNsjVSl9hdsu2sKVfIW8zj4l2qVmrKvKcfmbYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKAUg/ME+IydWN9d/BSe9iYUvZZJ9ptp3+bciImlA7IOlwKw32
	5df/MzlBzldfNh6TzLGySUulK5rutfybIUhH5lvbaA2aAwnzwiCVD1f6ttxuBeEhy0v9AGJrfPB
	83vMPw7IqVk8paSlge3dVEymxm92m9fLLKxFkvLPL/QXhVq+Dxnobwb/0ZgjqJgC/DXK/
X-Gm-Gg: Acq92OEpeKJCix5x5hI1VXTP89121OP3GFltKlm2QpO9A1nues3TnUJB+xaOxyCNtHf
	Drle7oCgIlBNS7o/Jp+zmu+NRcoyvRlzrc0AdDWwoFCrBNzANz95pYSikPzXFkZuBL5OeCe8Q02
	O7/U1yeTXzqVmD4JZ9vypm8lLkLcQSeEic+G94fYizqYtWUzrb5N5ATxHnKve0k4Sdj0/CDTb2y
	/cPv9hMBPfuvQTXvS6KVOvLaNCGHvPtdsb4P52AVXxbXvzMqd50BITQRYNVpZYHEO005mT1lNyT
	iIPuBBK1yxuS1Q5hraoZXDy/Hh1fEUFOtobtDQIWTGoAYBv87VLLUkCzWpvpTzIg+Jh1KTkJDZO
	SgbJ5MG6+jdc=
X-Received: by 2002:a05:6000:4013:b0:43d:6787:9934 with SMTP id ffacd0b85a97d-45460e3f3d6mr28257111f8f.9.1778586508039;
        Tue, 12 May 2026 04:48:28 -0700 (PDT)
X-Received: by 2002:a05:6000:4013:b0:43d:6787:9934 with SMTP id ffacd0b85a97d-45460e3f3d6mr28257062f8f.9.1778586507487;
        Tue, 12 May 2026 04:48:27 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e4bbebdsm35277222f8f.5.2026.05.12.04.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 04:48:27 -0700 (PDT)
Date: Tue, 12 May 2026 13:48:25 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] platform_defs.h: fix __counted_by_ptr annotation
Message-ID: <qnp7uxdaslz5u2pb5rvvb577opgw5xrcqbeplob4ukgakbcggp@htp7i6k432xx>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
 <177819182658.3486034.17713563256078765686.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177819182658.3486034.17713563256078765686.stgit@frogsfrogsfrogs>

On 2026-05-07 15:11:27, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The kernel userspace headers for Linux 7.0 provide the __counted_by_ptr
> macro, so we shouldn't define it separately on those platforms:
> 
>   In file included from radix-tree.c:11:
>   ../include/platform_defs.h:334:9: error: "__counted_by_ptr" redefined [-Werror]
>     334 | #define __counted_by_ptr(member)
>         |         ^~~~~~~~~~~~~~~~
>   In file included from /usr/include/linux/posix_types.h:5,
>                    from /usr/include/linux/types.h:9,
>                    from /usr/include/linux/sched/types.h:5,
>                    from /usr/include/x86_64-linux-gnu/bits/sched.h:63,
>                    from /usr/include/sched.h:43,
>                    from /usr/include/pthread.h:22,
>                    from ../include/platform_defs.h:19:
>   /usr/include/linux/stddef.h:73:9: note: this is the location of the previous definition
>      73 | #define __counted_by_ptr(m)
>         |         ^~~~~~~~~~~~~~~~
> 
> Do the customary ifndef wrapper thing.
> 
> Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> Fixes: df91bc3bdc9b81 ("xfs: annotate struct xfs_attr_list_context with __counted_by_ptr")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

ops, I haven't tried with new headers

do you have -Werror enabled by default?

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

