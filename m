Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFB3A954
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 00:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718325943; cv=none; b=NNMEiqSvhuMqy9ULg4KzSNpswsKd42XIKx81Fb8m/o62C3rPWoOUq6f4x/uLqCjVhILnvOfO2l5Dv1RGIACO7tjBdw6ssgCmqkFRbKctFnzUNdZzNFjBdH6mQ0pjx3GYPP24LkkQ6dbjPfHWDJ73x+8noAfdqr5CHR/CgO73ubs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718325943; c=relaxed/simple;
	bh=bpHlxSukW3/POvTPgy6napF5T4+JY3YV1uNPoxDqLt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiw17fVbtQJOmLTpHH+IGTwl8/aVbvDiBugqkiveV+bLUfZzVFw8rmgD/+EiPwyFunoqMcrSTrHFBHPplwi6AbF9dmNagdkDszPqWUd0NniOJxo2ZXJpq10TO/5QocMDzxPJI3AtOxLyxFIZijslk0GqAwGrcnDC9ckjTRbfo0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=azo7f2gU; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="azo7f2gU"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1f32a3b9491so15807895ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 17:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718325942; x=1718930742; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xytt2Cem59UFhpax45WZCM0+Lvi5BEJx8h9vzoNZrWQ=;
        b=azo7f2gUAJles7QaLhQuwb/g7I0JKYpryKEfZzgdlS3kq8pJw2/a2w0bK4TqbjRI37
         Na0UOozG6wDV9eUMHFhY/bF8IUuHh1OeKEa16cJxe7EBZEoHKrX9Xb5n/g/hz39tkXaX
         KzdwsMaNknAaJwEEVg3SefNeZtfMiqT8l57RKr5jr+7NCk+kBLdSYl1q1ZoJbeZ7T3gq
         fiauZdKpW9BGuCB7YQXCW606/OUx3wYuwQcRBbsuIikW2S6UzhpqXlig73EyEJcB1p5J
         8QG0/jq+4/1YBSSxisMAqwIB2ru9M2heJ6pSae3+ZYSNSZbH1YazA4S5/ADkxvl0nRQc
         O8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718325942; x=1718930742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xytt2Cem59UFhpax45WZCM0+Lvi5BEJx8h9vzoNZrWQ=;
        b=q3Vs59UFDpzFXS7V6gdOT9/3DSkr71npjrcSOgAJVu+ofG7lmCgP98/Etr2C12HBNw
         kE+XGYYrZCZmT9n29AqRpjMj9kst/5v9Zy9dctYJ222SzT1jF7p7QDjBl0iP9KRcy0ll
         FPvDF05OYmNS79cdxUxz5PijlxK8XWU3Wz/0qleZda9EkHkxIv8dlFKfAZz1nz7/Ovl+
         RE8oXjgBs8HU6oxCcIsaxMP8tlnr4KX1lVcu7Ei+8duIR43v7GzT9kt4TuKGGBZDNj1s
         dH0BOEmTiatiZEfQ6EDkMYQUJwdEw3R3PfBqH3c1K6aFHMTn/W3vNF99tvybVxgazhI5
         uyJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKsFk34fD+jDdURCVWtkc3iE5zHwbslShQJQHo7piSeJ504n0OvXZ/YFRUVj4bm8KcLeSoOa3COZi4jgANe5VkHqKgegsG06EN
X-Gm-Message-State: AOJu0YyU3Vy5mM2ltddVK6cwD04oxaZS3IxrO9nEoxaNH+iNGHth4QO2
	fCpog+wVN71v2q6ulpFsO8N3ay+pdWQa1BG4I4LcBXdQNpnjOnmgig33DpjoFbU=
X-Google-Smtp-Source: AGHT+IFo1/y69PVr3DxYw/D7kJPVxnFpqEVUYF0BVUTt7WiGqE60SqjAbLFjHDi3EV2rkVwJgXeuYw==
X-Received: by 2002:a17:902:654e:b0:1f7:2561:cd98 with SMTP id d9443c01a7336-1f862a03dd7mr9979175ad.60.1718325941425;
        Thu, 13 Jun 2024 17:45:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f337fbsm20328875ad.263.2024.06.13.17.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 17:45:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sHv4T-00F6BX-2a;
	Fri, 14 Jun 2024 10:45:37 +1000
Date: Fri, 14 Jun 2024 10:45:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] bringing back the AGFL reserve
Message-ID: <ZmuSsYn/ma9ejCoP@dread.disaster.area>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1718232004.git.kjlx@templeofstupid.com>

On Thu, Jun 13, 2024 at 01:27:09PM -0700, Krister Johansen wrote:
> Hi,
> One of the teams that I work with hits WARNs in
> xfs_bmap_extents_to_btree() on a database workload of theirs.  The last
> time the subject came up on linux-xfs, it was suggested[1] to try
> building an AG reserve pool for the AGFL.
> 
> I managed to work out a reproducer for the problem.  Debugging that, the
> steps Gao outlined turned out to be essentially what was necessary to
> get the problem to happen repeatably.
> 
> 1. Allocate almost all of the space in an AG
> 2. Free and reallocate that space to fragement it so the freespace
> b-trees are just about to split.
> 3. Allocate blocks in a file such that the next extent allocated for
> that file will cause its bmbt to get converted from an inline extent to
> a b-tree.
> 4. Free space such that the free-space btrees have a contiguous extent
> with a busy portion on either end
> 5. Allocate the portion in the middle, splitting the extent and
> triggering a b-tree split.

Do you have a script that sets up this precondition reliably?
It sounds like it can be done from a known filesystem config. If you
do have a script, can you share it? Or maybe even better, turn it
into an fstest?

> On older kernels this is all it takes.  After the AG-aware allocator
> changes I also need to start the allocation in the highest numbered AG
> available while inducing lock contention in the lower numbered AGs.

Ah, so you have to perform a DOS on the lower AGFs so that the
attempts made by the xfs_alloc_vextent_start_ag() to trylock the
lower AGFs once it finds it cannot allocate in the highest AG
anymore also fail.

That was one of the changes made in the perag aware allocator
rework; it added full-range AG iteration when XFS_ALLOC_FLAG_TRYLOCK
is set because we can't deadlock on reverse order AGF locking when
using trylocks.

However, if the trylock iteration fails, it then sets the restart AG
to the minimum AG be can wait for without deadlocking, removes the
trylock and restarts the iteration. Hence you've had to create AGF
lock contention to force the allocator back to being restricted by
the AGF locking orders.

Is this new behaviour sufficient to mitigate the problem being seen
with this database workload? Has it been tested with kernels that
have those changes, and if so did it have any impact on the
frequency of the issue occurring?

> In order to ensure that AGs have enough space to complete transactions
> with multiple allocations, I've taken a stab at implementing an AGFL
> reserve pool.

OK. I'll comment directly on the code from here, hopefully I'll
address your other questions in those comments.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
