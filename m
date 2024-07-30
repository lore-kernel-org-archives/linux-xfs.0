Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38A3168489
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 22:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722379441; cv=none; b=pDxzXETZmCxkm6lpq/r6QfNo0279DYeQcBvtjb/KkDtOayaDfcgmSs6Rryuzp/UHjM6mgqcql9JHhJpsjd8/IDImq0jp9E6owewzguhOIJebVwkq2Z4fvYFvex/sHWjxE1ochcZBFg7Qz/S2dz++mLBxyAmE9IBM3St6yaiRz1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722379441; c=relaxed/simple;
	bh=vWeLE0u1ovFEPvisw1YmnmOnuh4vXy05dBAsYT2nlkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQEekAcXTS4ogJIPHPJq3Y8djii8BTM8AbiRBkFQ7xHa1wQrq61bdJbGLSW7l6QkQs8Wwr9B2PI8NC8LnZef2fXWbx1MrBjTf2idZiOgDgN+DkA0MhQ2XRmWspHqYoz3+6leUqxZ/yqbaHyq4PQ/RPagkra2xIO6ZbkaT2grorc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=g5B+h6mj; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="g5B+h6mj"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70d19c525b5so3444532b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 15:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722379439; x=1722984239; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K3J+SD8oOACcE3LeguHpzGn7J/40Pg1QP7PNJYjzk44=;
        b=g5B+h6mjLuCjQ0byBMb5y3/+07G8UzoMU70nyK+PNPSEAe8LpAf8qrWZkL6wcFREeu
         xmpRsRMdKr856Di3ve/kN70qvo9egh1pxaJpqloUhQznia9ZcPjmqD0OTTj9u38mmrfI
         ySmiXVCQaNe2/8wmQ2SSsgn6+IfOPNo9bohzrBxFFIMLBh4lBl0khN78CYZWWy7Z99BQ
         L8iDW5HugTpHDn8tjOERy7gtuyrU9ojM9zSlQP3PdkKxwPpZl0t5VuC7JuOkYebU5fIG
         L2cUHNXeUotGIdYCjLwML8RI77vYMS99S1kUmrAlJ2WywS2y/PAllAsR5spIZB/sxNZg
         +zGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722379439; x=1722984239;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3J+SD8oOACcE3LeguHpzGn7J/40Pg1QP7PNJYjzk44=;
        b=iPhL0e42F3TH2edVRY+ZEfCsGctCyVkFytHzlht09rZwcp1qsPNpx411jwS4puZVjk
         iSjOXJR7CxCuQO3Hz+Mpkf+Vezba2RX5ytGV2LB3BIk8cM5YHauiDn1sEYJZB0Z2FezQ
         kCUnj8JWUdszN0tQ0JgYcDm7c8SrzDrOwIo4ikRe0/r+zkxRuZgeHAheqWU4pWB29Lhx
         4NqfVul8i+f3HmyGY8IGn0xyzTMWnX7gpadTVNgtD4FD07tzq8EQ6JdpHZQ6gM+nuV0L
         FiWsxBVX8VcqlEzdjDK2xAQ5aa35miHZw/k6ZsNFWC1f6LGHGvM2Farl/qW3N+0FrMvT
         JW6w==
X-Forwarded-Encrypted: i=1; AJvYcCXzlwUmsqkqFKZbhrqjYJ+0efxMPZ+XdydAuyWxuD68Ccwsmp+yOqMc46/cOAVP18DZgQLXmYXXfyOqvisDbCmzbHENQSdmjjvr
X-Gm-Message-State: AOJu0YwlL1ida0iI/r/K8aTxa4x+fySpPk2kQULtAwGO3vX5XTe7Zsok
	TeAi1jlHewhw2T6K6HTmojOf6zaM6Md8ab/nO3nm+Rz1pfdDDYvftxIjsk87r54gHdDCuxQ59vW
	v
X-Google-Smtp-Source: AGHT+IFDjQIiwrab12GKGTqu4IUatOv5e9nNPUT34e8H9v8tUT9fpV3ZotwUTAx63NQTyPSu+7RAbQ==
X-Received: by 2002:a05:6a20:a11a:b0:1c4:87b9:7ef9 with SMTP id adf61e73a8af0-1c4a13afc20mr12148285637.42.1722379438855;
        Tue, 30 Jul 2024 15:43:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28c5635esm11223202a91.4.2024.07.30.15.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 15:43:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sYvZT-00HE6Q-2K;
	Wed, 31 Jul 2024 08:43:55 +1000
Date: Wed, 31 Jul 2024 08:43:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 9/9] spaceman/defrag: warn on extsize
Message-ID: <Zqlsq7BxTa29bWqP@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-10-wen.gang.wang@oracle.com>
 <20240709202155.GS612460@frogsfrogsfrogs>
 <3DC06E8A-486F-44D3-8CEA-22554F7A5C7E@oracle.com>
 <ZpW+6XCI4sf6kC+n@dread.disaster.area>
 <C635810C-9669-42F8-BD6F-48C15B1AEFD7@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C635810C-9669-42F8-BD6F-48C15B1AEFD7@oracle.com>

On Mon, Jul 22, 2024 at 06:01:08PM +0000, Wengang Wang wrote:
> 
> 
> > On Jul 15, 2024, at 5:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Thu, Jul 11, 2024 at 11:36:28PM +0000, Wengang Wang wrote:
> >> 
> >> 
> >>> On Jul 9, 2024, at 1:21 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> >>> 
> >>> On Tue, Jul 09, 2024 at 12:10:28PM -0700, Wengang Wang wrote:
> >>>> According to current kernel implemenation, non-zero extsize might affect
> >>>> the result of defragmentation.
> >>>> Just print a warning on that if non-zero extsize is set on file.
> >>> 
> >>> I'm not sure what's the point of warning vaguely about extent size
> >>> hints?  I'd have thought that would help reduce the number of extents;
> >>> is that not the case?
> >> 
> >> Not exactly.
> >> 
> >> Same 1G file with about 54K extents,
> >> 
> >> The one with 16K extsize, after defrag, it’s extents drops to 13K.
> >> And the one with 0 extsize, after defrag, it’s extents dropped to 22.
> > 
> > extsize should not affect file contiguity like this at all. Are you
> > measuring fragmentation correctly? i.e. a contiguous region from an
> > larger extsize allocation that results in a bmap/fiemap output of
> > three extents in a unwritten/written/unwritten is not fragmentation.
> 
> I was using FS_IOC_FSGETXATTR to get the number of extents (fsx.fsx_nextents).
> So if kernel doesn’t lie, I got it correctly. There was no unwritten extents in the files to defrag.

The kernel is not lying, and you've misunderstood what the kernel is
reporting as an extent. The kernel reports the count of -individual
extent records- it maintains, not the count of contiguous regions it
is mapping. Have a look at the implementation of fsx.fsx_nextents in
xfs_fill_fsxattr():

	if (ifp && !xfs_need_iread_extents(ifp))
                fa->fsx_nextents = xfs_iext_count(ifp);
        else
                fa->fsx_nextents = xfs_ifork_nextents(ifp);


We have:

inline xfs_extnum_t xfs_iext_count(struct xfs_ifork *ifp)
{
        return ifp->if_bytes / sizeof(struct xfs_iext_rec);
}

Which is the number of in-memory extents for the inode fork. Not
only does that include unwritten extent records, it includes delayed
allocation extents that don't even exist on disk.

And if we haven't read the extent list in from disk, we use:

static inline xfs_extnum_t xfs_ifork_nextents(struct xfs_ifork *ifp)
{
        if (!ifp)
                return 0;
        return ifp->if_nextents;
}

Which is a count of the on-disk extents for the inode fork which
counts both written and unwritten extent records.

IOWs, both of these functions count unwritten extents as separate
extents to written extents, even if they are contiguous.  That means
a single contiguous extent with an unwritten region in the middle of
it:

	0	1	2	3
	+WWWWWWW+UUUUUUU+WWWWWWW+

Is reported as three extent records - {0,1,W}, {1,1,U}, {2,1,W} -
and so fsx.fsx_nextents will report 3 extents despite the fact that
file is *not* fragmented at all.

Hence interpretting fsx.fsx_nextents as a number that accurately
reflects actual extent fragmentation levels is incorrect. If you
have a sparse file or mixed written/unwritten regions, the extent
count will be much higher than expected but it does not indicate
that the file is fragmented at all.

Applications need to look at the actual extent map that is returned
from FIEMAP to determine if there is significant fragmentation that
can be addressed, not just the raw extent count.

> (As I mentioned somewhere else), though extsize is mainly used to
> align the number of blocks, it breaks delayed-allocations.
> In the unshare path, there are N allocations performed for the N
> extents respectively in the segment to be defragmented. 

That's largely irrelevant to the issue at hand.  If there is
sufficient free space in the filesystem, the allocator will first
attempt and succeed at contiguous allocation. Hence the size of each
allocation is irrelevant as they will be laid out contiguously given
sufficient large contiguous free space.

Indeed, this is how allocation for direct IO works, and it doesn't
have problems with fragmentation of files for single threaded
sequential IO for the same reasons....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
