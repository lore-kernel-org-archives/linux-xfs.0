Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4805215B11D
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 22:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723155360; cv=none; b=opcB9eMYTzsQusDpUVHSwJNHW9PwPSiQ8imNjH35jt1yUKxNfPID2xbgEHnfcBe1HbA0zYcSE+oSvyUyX/fDAMIgD6lp1qBPBGh42xwIy90drSUvFVuhttWFqRN7j1Mtflps69f/FD94yg3VMN/ITElgjwMBllAh8gI3jITiXu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723155360; c=relaxed/simple;
	bh=exENGfnpxAkEBxf+oAhPYpjb9Lo66i2NS4XjrUnzyh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuiqQ3glxif/9nbWH0a/0HNyu5967W/yryHPDtJku+dre9miofMCoKWnVkNx9EYyOtCM2fV5M0BW7wkdW/pDayJt3taXFS/mB+j9SrTB+BwQEyGlpeWgfzmicurhq9RpO0CM88cENcb9W0C9m1o27KEXUAYnF2CN/mzwqfDOOdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xGr3SXt7; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xGr3SXt7"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-6e7b121be30so1079610a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 15:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723155359; x=1723760159; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fPoNozmItBTCtYaD8f/bm1mT3QLydoo7yknEwoaTs1U=;
        b=xGr3SXt7eG9R+RErdGG5Yu64gnNs2v3fcuH+6db9py21Fvrq10bCmBCdGN+zMqNfUO
         OWGnrxGAKPuNFIEbKa9c6RTro0jZB3IAeQLroPVDYbLpXp4LslKw6OK0koN1+M3nq6Z9
         yZCWhpIhvqCy1wChLOGaL5hWbZtJBeMI5cQhUnjVYFLBhFbZL2gffzNKzm/QSfTK7+LB
         CR+Kvv0t9mO8c8671gsoHulBCe4FEuAN1K5xsEBgagLbOFHxkl0FyxMK5sD6CU4PSnYO
         IkesPypFHzY2EapC5flS008E0rtsM0vuCK+N4HfrlCha1bdxVQYN0G78mOd3PXqhOvdB
         eX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723155359; x=1723760159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPoNozmItBTCtYaD8f/bm1mT3QLydoo7yknEwoaTs1U=;
        b=xSDvYMvqmHBnecS86UEGEWzpuCko81kKSMIIAvVZyo1yIlc2qzZQnChY37xy5DNaih
         V/XdbZIVYR3Yi0UF+q7yXt3VSFgN2wXA6Ewd1VMPXL3cq9PBcybcgkH+sJZHGw7vxjIx
         xgjyhfCKX+SsNQp6p02lzm4sSVF3r7mFF0Jy27QpLP0T1Tun4BIh+PjvGhwxdMBr5P+c
         Xwb5gcDboGhztbXcrCaN425LHLWaSLD0JeADnBzACrIpyrw5K2FA7Ymhdp4N3EKllUyE
         xTu8+xagSgYkB7TqnqTx3Qnnw3kd4014pZe/AGcWToZPJkUqQJhcR9NrUfOWIgUYvDN3
         kuDQ==
X-Forwarded-Encrypted: i=1; AJvYcCW55n68rkc4qGzo9moENozAozCdaAugalCXjgt/dwC/HvItiJtInw/NbhEStxHG7HxaBGqsET6fCm3yG/Fp/kX1pOumKWaO9Se2
X-Gm-Message-State: AOJu0Yz0L7PmPXj0aGljeFvWq88E5Rb2uGoest8vfydL/zUsn521kwBS
	j8zTZwJfZ9P1dION89uutGpkRUQnzkUDTR2r1i4iAQ/1qE4iJWESwQacCPqpjdc=
X-Google-Smtp-Source: AGHT+IGYb+VJppD0Q3Q/VxC7gerhv3j7lcSOY+aPPjer9GdOi5mky/V7oggcjnnGpaBi8Q6wRw0F5w==
X-Received: by 2002:a17:902:e892:b0:1fc:6a81:c5a1 with SMTP id d9443c01a7336-2009521fa1dmr39597765ad.12.1723155358600;
        Thu, 08 Aug 2024 15:15:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff59178772sm129200895ad.195.2024.08.08.15.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 15:15:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scBQJ-00ACjo-2z;
	Fri, 09 Aug 2024 08:15:55 +1000
Date: Fri, 9 Aug 2024 08:15:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 00/16] fanotify: add pre-content hooks
Message-ID: <ZrVDm+Tjuv6tWlY3@dread.disaster.area>
References: <cover.1723144881.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1723144881.git.josef@toxicpanda.com>

On Thu, Aug 08, 2024 at 03:27:02PM -0400, Josef Bacik wrote:
> v1: https://lore.kernel.org/linux-fsdevel/cover.1721931241.git.josef@toxicpanda.com/
> 
> v1->v2:
> - reworked the page fault logic based on Jan's suggestion and turned it into a
>   helper.
> - Added 3 patches per-fs where we need to call the fsnotify helper from their
>   ->fault handlers.
> - Disabled readahead in the case that there's a pre-content watch in place.
> - Disabled huge faults when there's a pre-content watch in place (entirely
>   because it's untested, theoretically it should be straightforward to do).
> - Updated the command numbers.
> - Addressed the random spelling/grammer mistakes that Jan pointed out.
> - Addressed the other random nits from Jan.
> 
> --- Original email ---
> 
> Hello,
> 
> These are the patches for the bare bones pre-content fanotify support.  The
> majority of this work is Amir's, my contribution to this has solely been around
> adding the page fault hooks, testing and validating everything.  I'm sending it
> because Amir is traveling a bunch, and I touched it last so I'm going to take
> all the hate and he can take all the credit.

Brave man. :)

> There is a PoC that I've been using to validate this work, you can find the git
> repo here
> 
> https://github.com/josefbacik/remote-fetch
> 
> This consists of 3 different tools.
> 
> 1. populate.  This just creates all the stub files in the directory from the
>    source directory.  Just run ./populate ~/linux ~/hsm-linux and it'll
>    recursively create all of the stub files and directories.
> 2. remote-fetch.  This is the actual PoC, you just point it at the source and
>    destination directory and then you can do whatever.  ./remote-fetch ~/linux
>    ~/hsm-linux.
> 3. mmap-validate.  This was to validate the pagefault thing, this is likely what
>    will be turned into the selftest with remote-fetch.  It creates a file and
>    then you can validate the file matches the right pattern with both normal
>    reads and mmap.  Normally I do something like
> 
>    ./mmap-validate create ~/src/foo
>    ./populate ~/src ~/dst
>    ./rmeote-fetch ~/src ~/dst
>    ./mmap-validate validate ~/dst/foo

This smells like something that should be added to fstests.

FWIW, fstests used to have a whole "fake-hsm" infrastructure
subsystem in it for testing DMAPI events used by HSMs. They were
removed in this commit:

commit 6497ede7ad4e9fc8e5a5a121bd600df896b7d9c6
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Thu Feb 11 13:33:38 2021 -0800

    fstests: remove DMAPI tests

    Upstream XFS has never supported DMAPI, so remove the tests for this
    feature.

    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    Acked-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Eryu Guan <guaneryu@gmail.com>

See ./dmapi/src/sample_hsm/ for the HSM test code that was removed
in that patchset - it might provide some infrastructure that can be
used to test the fanotify HSM event infrastructure without
reinventing the entire wheel...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
