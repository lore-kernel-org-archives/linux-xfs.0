Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94BC19ADBA
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 11:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756381351; cv=none; b=e+OQMdcutOFCNB3rir7+b51tYMNWY6XC8GDGTLNIKJHfQVsflbnvMeN39VP46Dn/sdm5cXv7SN3OFd07l16Lrl4/lgh9MAeq8b+JTgCiuyYFsooMFKO2fPr1YBSBME95mhoGZ8nKxktxohsrHHNNni+7DAm23zCJPJppAuq6j6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756381351; c=relaxed/simple;
	bh=pXGKWFVyVsRQelEkZGduol4s3jmhYKFx2akcAoEt+EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H44caZfHWmuCPreH0OaF7dvkj612C7qpfGfNquaBn4ikqRO+/MkpLio6svvbObjnP/+2S1vPuA8UGPANmXaUv3QsuzNqISdeoMXPrPXDbKbqdUSBlNP5ccO1xk+hZK2B4hh83dLuZk3+zf/3FM5P+O2fzXEVMCGW2NGKZn2WbIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=mLPKNi9J; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="mLPKNi9J"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e931c858dbbso619152276.0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 04:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1756381348; x=1756986148; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g2mtr4MahWN1CaeWoRERBafDml3LAYcHAVZcXe/+ugQ=;
        b=mLPKNi9J5ZHe7J0F5ExCMHZi80W3+MBpqsLUqPcu7z8vLe7wAPSnR5y/plrVPe0q9w
         FGiFGR4045PqryGPrpcMAhx9JrbkkMovLSGxymx7id3DvG5ZBuQYNF73/NxEE1Sm/NJo
         ogqfMyX560Tga3w9aFBZamZzjX2y8BJ5+X4xzxRcEnQ0uEpnIZIiFxJ8yVVy2dL+uQ1J
         aj7zwqJ1zFh0RYk8GntjbpclGFWKYlqmzEzqMDibuEbcuoPbFwMG/Q+WeijHPI/0fqmV
         QThshVmhegEeJxXLVLFWX0bI03bHfJlZqSWDacjywovrKOLPcc3TR1f1XEtSMIMzNm8L
         DItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756381348; x=1756986148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2mtr4MahWN1CaeWoRERBafDml3LAYcHAVZcXe/+ugQ=;
        b=HUEgO5jF+SuGjmQkuQmdJxKbaburF8vFl5yIBiRkndSGqvGqH4pkla9sa4Npf9CXQe
         kBWIJNDjXq+tvvJMRfhICH+Dthlm47VMkJRgDm+C7hXnvD41U49HSxns3/zi8MWsVqQd
         dVnzDoFB211H50fA3CiGWl4Nf+G3ittXj/459LbX2EVNRyHOSsiZHRPolCzxxft+FE/g
         oEZEjpbj4twqgEE6PO++2NIR9FonwcZ6zoPaxuv5GcGnYUbxei1/iBcRKGxQyCUS8+rZ
         /a40NTz0APZwkjhjYQ1t5yfYhu3asiIdifVKtUtkX5I7EtVI+bbzAmxn3aqaPOghwig/
         HuQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHN+gLAuXYR+wEv+OuajVYH89bEUHXfllC0kupuPDIiL5uk2epT4LlgvZz7ENjP/CKCsOmjDOF7ZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxedtNOYqEBM8FWfuZ9UJywT4CCez8E+EsWiXeKpwVp5YzrZAPg
	4F64om9oz1UjtndzeBPOZE9VpH41KL2jZHFZhwdzy6gvaXkuAkmUfwO1IYvZfZBS5uk=
X-Gm-Gg: ASbGncs8WYxArVPR4qmZiwz6IodUYBa91eNlgo0SD88erN0Vqt7iEMAppM+hjLFBAfB
	gdt7ibL3iJjgwg5LMf2bC9CrO1MyHGo3h9AkXGb6O9196wv97wpjNrdamjve7YznXJXULa+8NHT
	fEq/d2QiksW/oWTrsyR31oASNIyjbnXjG+F4Nufuz2Y2mYvDieJ3V5OM7jLDVbMAc4wnf5UpJCL
	m1XE/UfpZEBhi9CuPlwjYJ2XDiEfDk9OFSyoVFGQLaF+s1qImCSE5Lv3ZL1FMRsWi1eLYnPsTka
	3uOqz/lNXaQulhFEFEZa8Lb3Bwd4NRd+Y/al8lqMRuqFnMGMPiFpRJr1rh7mlSAQkvS5hJPC2/z
	IpJs4/g8ZvIxEQAsGAX9+wtSvv1v9LWwwdw1RQCilxZJFQm7vjKR1jenW9mM=
X-Google-Smtp-Source: AGHT+IHzU9aYDYU3YAH3hfgvOIUS16goFJso3B9bUXGDolR4NrbvimCaMQ06YKvjMpun0m8FzBSWLA==
X-Received: by 2002:a05:6902:c06:b0:e96:f9fe:2f31 with SMTP id 3f1490d57ef6-e96f9fe30f7mr5099573276.42.1756381347519;
        Thu, 28 Aug 2025 04:42:27 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff17093e9sm38418147b3.7.2025.08.28.04.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 04:42:26 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:42:25 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, amir73il@gmail.com
Subject: Re: [PATCH v2 16/54] fs: delete the inode from the LRU list on lookup
Message-ID: <20250828114225.GA2848932@perftesting>
References: <cover.1756222464.git.josef@toxicpanda.com>
 <646d132baae6e5633064645e677dada101681850.1756222465.git.josef@toxicpanda.com>
 <aK980KTSlSViOWXW@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK980KTSlSViOWXW@dread.disaster.area>

On Thu, Aug 28, 2025 at 07:46:56AM +1000, Dave Chinner wrote:
> On Tue, Aug 26, 2025 at 11:39:16AM -0400, Josef Bacik wrote:
> > When we move to holding a full reference on the inode when it is on an
> > LRU list we need to have a mechanism to re-run the LRU add logic. The
> > use case for this is btrfs's snapshot delete, we will lookup all the
> > inodes and try to drop them, but if they're on the LRU we will not call
> > ->drop_inode() because their refcount will be elevated, so we won't know
> > that we need to drop the inode.
> > 
> > Fix this by simply removing the inode from it's respective LRU list when
> > we grab a reference to it in a way that we have active users.  This will
> > ensure that the logic to add the inode to the LRU or drop the inode will
> > be run on the final iput from the user.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Have you benchmarked this for scalability?
> 
> The whole point of lazy LRU removal was to remove LRU lock
> contention from the hot lookup path. I suspect that putting the LRU
> locks back inside the lookup path is going to cause performance
> regressions...
> 
> FWIW, why do we even need the inode LRU anymore?
> 
> We certainly don't need it anymore to keep the working set in memory
> because that's what the dentry cache LRU does (i.e. by pinning a
> reference to the inode whilst the dentry is active).
> 
> And with the introduction of the cached inode list, we don't need
> the inode LRU to track  unreferenced dirty inodes around whilst
> they hang out on writeback lists. The inodes on the writeback lists
> are now referenced and tracked on the cached inode list, so they
> don't need special hooks in the mm/ code to handle the special
> transition from "unreferenced writeback" to "unreferenced LRU"
> anymore, they can just be dropped from the cached inode list....
> 
> So rather than jumping through hoops to maintain an LRU we likely
> don't actually need and is likely to re-introduce old scalability
> issues, why not remove it completely?

That's next on the list, but we're already at 54 patches.  This won't be a hot
path, we're not going to consistently find inodes on the LRU to remove.

My rough plans are

1. Get this series merged.
2. Let it bake and see if any issues arise.
3. Remove the inode LRU completely.
4. Remove the i_hash and use an xarray for inode lookups.

The inode LRU removal is going to be a big change, and I want it to be separate
from this work from the LRU work in case we find that we do really need the LRU.
If that turns out to be the case then we can revisit if this is a scalability
issue.  Thanks,

Josef
