Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576694A35
	for <linux-xfs@vger.kernel.org>; Sat,  8 Mar 2025 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741416241; cv=none; b=szbQAglQIUWZgtL1CTz0QDzkEC3XS8ulia0G8q6aKg3PhqhR07rvyioA2r9HDSLKkENkdDe86TwNzG6hpOTygYcYJWms5xU3lkQGBzxzU/rp/Vm6ovgGlGSnpmek/TiqyOop/kaX3IwfBzLKq7Dy+cm0n5cRFKzWDjwt23uvsTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741416241; c=relaxed/simple;
	bh=UtKF8Vg/8ur3x9ZZufYsKRKBGlH122N5R3zj7Hw67+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lLriqvN8cZ06GS/YT3x6m+24vxxqKzOKLxiniHm6tL/hfcFrbxuTQAKDc84U/E8W+5CZDSTZov8uBoLaEzcXy8VJjtuGQslTII1CO84DoaMonseFvBvPkeETTTQSNPela3BgghW91Qg681zytrIB3rPMaa4jZMYYxGaoUjcYGYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XVgz4JYP; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XVgz4JYP"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22113560c57so49670975ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 07 Mar 2025 22:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741416237; x=1742021037; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7XYd6bILvV5S9oc7kfROdvIGE+piMUFy2TT1wDFAAs=;
        b=XVgz4JYPbICcYstIjrVqj42hOBnrp1eXLLfvNDdBC8iohlUs8vJlpZFFfy0v7Gk7hR
         uJV2w6kFuLuQHvLiRg73yX/FWNvclFt941gRoWvfOtKpP9wVSyi3vYjme8uGSUCTRbTh
         Id/K4ob38oUXP1yAjqFPAoM/nIbmkM1Wgpn9Xn3U/NzIZcUNiPuW9/nBuXJHRnvp1N18
         4CoBETKcRJV+gN4jJ6zaeKkMsixI3KtURKfpbQ/8grjrm7LrjKNBBgbjILpdJnK2yuJp
         7hAUDfVmsCRX/8XvxpIpy/Md2vp5bxSzNyEdsZxh1y33ZtUgsRQbLjlzRnLy7I5jMsEA
         8RwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741416237; x=1742021037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7XYd6bILvV5S9oc7kfROdvIGE+piMUFy2TT1wDFAAs=;
        b=NxehbpZ3kmgCyKuk3+p61lgHWKsiqVq43xVCAUQmx62+gdavlwhPC+pd+5acyS5osu
         S/gJVJiVj9tpAGdKh8j3mymkZyaI4p6hkN7Xj4QZmB3wKrKhuYCAcSQzESdA6QANWkOr
         tcFpcncHByp2riaoTLGq4GZx3J244WaIRHRky7wFFGo1FDT4M2gPP8HaMtAmWlbWZbu8
         wkXN9/GT3E/HQbI4i0AifH4DcbRQFdksXFs+6ziXKSjJjtDF45eBw17ZLAVQnxHZWGd8
         oKuFcUAnJOlHHnvglDaiRU9iLksvilRZmVcYxGTJOv1ePUcYcIbXbRneuhPRn7iQ4Xu7
         6HLg==
X-Forwarded-Encrypted: i=1; AJvYcCXXveivi94pyTblcJfO2cVG6/JCRND0wMcc+8iyMsOj4uiYznKKL+KQ6UvL46qbktfz16EjpwpM74E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzTwmnlc9qNoN1Q/UXfIqOhPlWe/60fJx6vJffJxQLlU6MtK3h
	ibSDU+RrldvT8WLT4XzST/RMNgHRDfe5bjq2YVuyIgc5ig7vNs9A2swRQEMy+gU=
X-Gm-Gg: ASbGnctHbsAqMrUJLF13vCjDu8/LZY/IYZHghwV7Dz7lXg3ucYLobfw+ligD+i8Xw1s
	O1lPwxNp9fIAFAxwY7/hf+B6GVs0aM29SS7DN2CrC5eW5d4c0RY7CTRLrVN6dT1Qqme7B+gOGHA
	j72Fu+f9HFOlSCguHo39HM438bWUtZjBQH51xsk8evXf4lfzOvtZLXG2OlFbfWA70RLuhEDhGff
	5pphO2A5Z4H2nUoa6QCP0uUpv2kyI4i1t/1shGmljSsonu2XGXPP4SedR5nVcQYvf0RgPIe/sLF
	3K3irl/yEX04/BgSDHHC0dvZ/qzM/i/TvESkAaBjeWGdYEFuPoQa71m9Ng6JjepXmvPeb6iFEqB
	A6+8ZtBiCAk3ZkOuoPeN7
X-Google-Smtp-Source: AGHT+IF/hoytkHf/78nzK/gEIzqXnGG5MP6Y8FgGhVp8Zx6LE+l7N0K13IdyKh5Omm9Q6AhxhqYyLg==
X-Received: by 2002:a17:903:98b:b0:223:397f:46be with SMTP id d9443c01a7336-22428ad4a09mr106979815ad.47.1741416237682;
        Fri, 07 Mar 2025 22:43:57 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e816csm40661065ad.54.2025.03.07.22.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 22:43:57 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tqnuc-0000000ALct-08Dn;
	Sat, 08 Mar 2025 17:43:54 +1100
Date: Sat, 8 Mar 2025 17:43:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
Message-ID: <Z8vnKRJlP78DHEk6@dread.disaster.area>
References: <20250228094424.757465-1-linyunsheng@huawei.com>
 <Z8a3WSOrlY4n5_37@dread.disaster.area>
 <91fcdfca-3e7b-417c-ab26-7d5e37853431@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91fcdfca-3e7b-417c-ab26-7d5e37853431@huawei.com>

On Tue, Mar 04, 2025 at 08:09:35PM +0800, Yunsheng Lin wrote:
> On 2025/3/4 16:18, Dave Chinner wrote:
> 
> ...
> 
> > 
> >>
> >> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
> >> 2. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
> >> CC: Jesper Dangaard Brouer <hawk@kernel.org>
> >> CC: Luiz Capitulino <luizcap@redhat.com>
> >> CC: Mel Gorman <mgorman@techsingularity.net>
> >> CC: Dave Chinner <david@fromorbit.com>
> >> CC: Chuck Lever <chuck.lever@oracle.com>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> Acked-by: Jeff Layton <jlayton@kernel.org>
> >> ---
> >> V2:
> >> 1. Drop RFC tag and rebased on latest linux-next.
> >> 2. Fix a compile error for xfs.
> > 
> > And you still haven't tested the code changes to XFS, because
> > this patch is also broken.
> 
> I tested XFS using the below cmd and testcase, testing seems
> to be working fine, or am I missing something obvious here
> as I am not realy familiar with fs subsystem yet:

That's hardly what I'd call a test. It barely touches the filesystem
at all, and it is not exercising memory allocation failure paths at
all.

Go look up fstests and use that to test the filesystem changes you
are making. You can use that to test btrfs and NFS, too.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
