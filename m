Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF077605D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 23:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714434600; cv=none; b=UOKV/drZo3AmDi9ZTVtBcGZs/Kzfr7YPW5Zz29oFZOQuD1qGSwB0XwtbkPzIKXqNgedCWwYo2dux8tzum/C1cM7h3MuNfB9Ud83AN04ax8hzsk/e8f7nCeU59RaXEBeNtKj2cdhdxhweYkU00FaOuDMev1VnKmkSAgnT3RxHvY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714434600; c=relaxed/simple;
	bh=j9ywEpiu/jjwOJYPTpZQKnoDHh2+iunxHi0HGXlG3kA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdPI0GR26b+Y9NcrepPIYvVzK29a1u4tTYN/XO0c8dFUpmFgieZBVWkHGHmXFwSv1HIJDzasK7ms7ZmctQBpWdTGbLbA06iE3IoOQQGzxnXneqA+zzpRKdCut4bCx7aTf9bull4XChwlRFMiaOKLj1pNic0MP7wxiTZmlHZsgmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HQeesBs6; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HQeesBs6"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ee0642f718so4589493b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 16:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714434598; x=1715039398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DiddL8zAMvqY9VshCFjzx63U+GcMXjyvOVSjq0kNaIU=;
        b=HQeesBs6GDFTpMYr79a0oFNrxWQ3NLzOBGZzcBH13wjOrRJTnDYksuH1G3e+jal23p
         /mob7mr8FJ39dLi7hsd4E5zjhszfKNgPqbxrQB9/R4DodqsJMdykvQ2sD8wFz/MpFDQ5
         BKiMzlNtF196/2kEHB8lpKpOGzZJzWgoeGvSqzdYaUFKxQkScIrTJUGso74wxCy6HLgg
         TN8hC2x0vk45DWD8BAqySsBtjUpDpD+jqF2YcILV+MTrJ1zh9bZ8BdxA1t8fMQ4r53AB
         397Mw12HyBW0W0vx5+kLhzejjjI+hwjLTubC0euqk0xRyzpvtSZuGFyaLdjUT/RSjILM
         I2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714434598; x=1715039398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DiddL8zAMvqY9VshCFjzx63U+GcMXjyvOVSjq0kNaIU=;
        b=Rakra7G2O+lLJ8zF0483iZozdRmH1SdGejD4uYwiUQ3Y00YBtPIXdWCAGjB/CkBd2g
         bu8NeGjHHCoUyiXUINpUP4veQygwM3CRescTt2Jhi+Vde/AsaPnlqrxeqNI3o5ynCWQS
         bfg/u1MQhHTNeep/0zWOuVzEWGUmNZ0H4DzPzNRhdEKEXyh4Ii4P1lGfC1g1J7K55DN+
         ufaDgwrjSuH3yNF+JwEAWB1LpmDkADC5H45OpK7tP9OcNUS5LxbvrmKzNoTYEjWDLjTy
         e9jsp3R+X9YQTaCaggKdTvHxV8esdmDbRFQqELwVf2XnRq5R4ghMJECmq3ZyxMQWHaeW
         IJVA==
X-Forwarded-Encrypted: i=1; AJvYcCWrDQuA3tU+O3SjAgBzq/nqqfvRae3HXWzEj6dOvUJdryAduVFsmWLZFR2TOrGMUhU1NyJ8lH43+fBsoCt8dcZ7Rh7RZxmt4eHU
X-Gm-Message-State: AOJu0YyFOfUAiq7qh9c7okq6GQ/RqUu7PzqacDYQc+o57LE8okoC/Stg
	2LSCwphUJxWy1HEBrupNs1lVm/wanBrVS74yjfo/z7zjKJJkZ5jbUWOT41w9z8U=
X-Google-Smtp-Source: AGHT+IHuKWC/c4x41+QSZNJd3lcQoUR6wyVRlABzffvTWdUs6RTvtjN3IU97w2Kq/BMHMP9Eb571CA==
X-Received: by 2002:a05:6a21:8181:b0:1a9:793c:59ec with SMTP id pd1-20020a056a21818100b001a9793c59ecmr1438535pzb.13.1714434597446;
        Mon, 29 Apr 2024 16:49:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id lc16-20020a056a004f5000b006f09f711e4esm19265220pfb.151.2024.04.29.16.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 16:49:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s1akr-00FaLP-2v;
	Tue, 30 Apr 2024 09:49:53 +1000
Date: Tue, 30 Apr 2024 09:49:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
	osalvador@suse.de, elver@google.com, andreyknvl@gmail.com,
	linux-mm@kvack.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mm,page_owner: don't remove GFP flags in
 add_stack_record_to_list
Message-ID: <ZjAyIWUzDipofHFJ@dread.disaster.area>
References: <20240429054706.1543980-1-hch@lst.de>
 <3e486c7f-57d4-4a36-a949-0cf19f10bf4f@suse.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e486c7f-57d4-4a36-a949-0cf19f10bf4f@suse.cz>

On Mon, Apr 29, 2024 at 09:59:43AM +0200, Vlastimil Babka wrote:
> On 4/29/24 7:47 AM, Christoph Hellwig wrote:
> > This loses flags like GFP_NOFS and GFP_NOIO that are important to avoid
> > deadlocks as well as GFP_NOLOCKDEP that otherwise generates lockdep false
> > positives.
> 
> GFP_NOFS and GFP_NOIO translate to GFP_KERNEL without __GFP_FS/__GFP_IO so I
> don't see how this patch would have helped with those.
> __GFP_NOLOCKDEP is likely the actual issue and stackdepot solved it like this:
> 
> https://lore.kernel.org/linux-xfs/20240418141133.22950-1-ryabinin.a.a@gmail.com/
>
> So we could just do the same here.

Yes, it is __GFP_NOLOCKDEP that is the issue here, but
cargo-cult-copying of that stackdepot fix is just whack-a-mole bug
fixing without addressing the technical debt that got us here in the
first place. Has anyone else bothered to look to see if kmemleak has
the same problem?

If anyone bothered to do an audit, they would see that
gfp_kmemleak_mask() handles the reclaim context masks correctly.
Further, it adds NOWARN, NOMEMALLOC and
NORETRY, which means the debug code is silent when it fails, it
doesn't deplete emergency reserves and doesn't bog down retrying
forever when there are sustained low memory situations.

This also points out that the page-owner/stackdepot code that strips
GFP_ZONEMASK is completely redundant. Doing:

	gfp_flags &= GFP_KERNEL|GFP_ATOMIC|__GFP_NOLOCKDEP;

strips everything but __GFP_RECLAIM, __GFP_FS, __GFP_IO,
__GFP_HIGH and __GFP_NOLOCKDEP. This already strips the zonemask
info, so there's no need to do it explicitly.

IOWs, the right way to fix this set of problems is to lift
gfp_kmemleak_mask() to include/linux/gfp.h and then use it across
all these nested allocations that occur behind the public
memory allocation API.

I've got a patchset under test at the moment that does this....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
