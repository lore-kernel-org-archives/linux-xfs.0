Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D078B652
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 01:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724637537; cv=none; b=HK9k4SA7FCpuLWKmuO9VCsBi6fDYRpvQwOXDjrMzRIADYMeKmj8hPgWSdBeV/fPENMwWXWhrBVN7L+B5rM2eidd0fUCjxlQE3y//yqxmsA8a1zJ5u4dTOXjIIRp8v3D56azzuDN/+zcaBBbukW1lx9TXEYo/6LmZP2NIekqdxwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724637537; c=relaxed/simple;
	bh=tCdwbRHtcMelgi08iVGEDSAwRjZ9dyjpxrI1JKmf6g8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5IzHpKzM4C3OLBZEyAEvfCw/FGUPciSbHqI1T2r9T+EDkjsz3W2rhM3mHaIZOBqlqtrAX1RBc1p5z7JMM/Qm6rBSsSh5g0RTXtq0Bc9cHc3gxF9RFR51GrTOKPwvhBmOsGY9dWRuTwCkAmGTXLLX7nC8Ot/S3y7limny8eOIlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=BJCnDzjC; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="BJCnDzjC"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-39d380d4ffcso13636135ab.0
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 18:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724637535; x=1725242335; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=crIqAWi/VyS0bF3DmU8GL4KdTwoKnJYeqOLmkHyhtoE=;
        b=BJCnDzjC+ehhGgMCZc9Mq+PTFCveOQdR2Kyh4kK+0roe7uuHrtKjFJ8yIYz7vQKxpD
         B0sf57GjQ2Ro8CBRPqP3Lcd24RTEAC/MhyuKuE9DGIxjvF/wRgYkDT5puyWEZNgU00Sd
         kRCVVdd3ijehqJGXmTiv8aGZoaUZrM+LCIm7uGv/P5LRU3kO7xs42DeNUqH07/BVSgxM
         6RTmRdaBT/O23fHedVEBIss5AWhZXkvoWjVGJL+q9uOyJKDkWiqe3LhY7XXSt3RGlIe4
         oHfwM4Ah/j9+6U1dMKJAfXWkMm8Q0zNkBjKETrkSgRGYKfOVLKXQs9Ut8oYyFqUVDS26
         25DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724637535; x=1725242335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crIqAWi/VyS0bF3DmU8GL4KdTwoKnJYeqOLmkHyhtoE=;
        b=NnxYZ9NETbIYW/liQixuXEuXJGb2uyCsH8Z1Hupb2lvIc/9Zg0N9itYXjNNJJzWRVw
         3kJ1U98h309qViRMVxAGjGaBnP6IU1V4mHbzM30LKihTwaSoDaUdi0+FxXT7iM10imuG
         LBULqb0DReKBAdK83UIoc45+w76s4nI3YI1pRCBXOlnuA3jDTDJ5UFsRKDNntVE+gtLz
         KvK9n99Tv7+NoxZ4VPoGj0jhT/kr2nAJGxmCkFyAHWu7gqK8BRdBcu4OE50eF3isu3In
         kxgMw6sT3iKpsWlqqVxEYmJtNBkZCkwU7ugzQmOeOuhtMh9FFInxF82ZNi69aMVQFIjN
         KSrg==
X-Forwarded-Encrypted: i=1; AJvYcCW4WLIGz/+BqKMHFeyVOBkOWWeWyuELkPyd0GDOENgMQudS+Zu8LJPSft3Hq/se+zh172LvwyNrmwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWS134whYYaGqq7Zs+M4pBtAWj1rR72Ek/0Tnvy/dNh52Y2csb
	rdqOy8dbpB1ZQKhDSwBRdpkwhbX8/CfT60RMYzcO6svVQIxUfq13YCFIACxnerCF6KiekR9ARGa
	k
X-Google-Smtp-Source: AGHT+IHiuVDgBUI9Ls16offfATSGm+JV2rgVcCSf7w7mF7GU/0x3y9xehv73joKPudSgr2iWTWz4Rw==
X-Received: by 2002:a05:6e02:1a21:b0:381:e4a3:2 with SMTP id e9e14a558f8ab-39e3c9c0c74mr94299045ab.21.1724637535125;
        Sun, 25 Aug 2024 18:58:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7cd9acbff78sm6674782a12.36.2024.08.25.18.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 18:58:54 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siP0N-00CqIF-2F;
	Mon, 26 Aug 2024 11:58:51 +1000
Date: Mon, 26 Aug 2024 11:58:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/24] xfs: move RT bitmap and summary information to the
 rtgroup
Message-ID: <ZsvhW8GIVq+j4eDV@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087522.59588.18128505844339338904.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087522.59588.18128505844339338904.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:18:49PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Move the pointers to the RT bitmap and summary inodes as well as the
> summary cache to the rtgroups structure to prepare for having a
> separate bitmap and summary inodes for each rtgroup.
> 
> Code using the inodes now needs to operate on a rtgroup.  Where easily
> possible such code is converted to iterate over all rtgroups, else
> rtgroup 0 (the only one that can currently exist) is hardcoded.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c        |   40 +++-
>  fs/xfs/libxfs/xfs_rtbitmap.c    |  174 ++++++++--------
>  fs/xfs/libxfs/xfs_rtbitmap.h    |   68 +++---
>  fs/xfs/libxfs/xfs_rtgroup.c     |   90 +++++++-
>  fs/xfs/libxfs/xfs_rtgroup.h     |   14 +
>  fs/xfs/scrub/bmap.c             |   13 +
>  fs/xfs/scrub/fscounters.c       |   26 +-
>  fs/xfs/scrub/repair.c           |   24 ++
>  fs/xfs/scrub/repair.h           |    7 +
>  fs/xfs/scrub/rtbitmap.c         |   45 ++--
>  fs/xfs/scrub/rtsummary.c        |   93 +++++----
>  fs/xfs/scrub/rtsummary_repair.c |    7 -
>  fs/xfs/scrub/scrub.c            |    4 
>  fs/xfs/xfs_discard.c            |  100 ++++++---
>  fs/xfs/xfs_fsmap.c              |  143 ++++++++-----
>  fs/xfs/xfs_mount.h              |   10 -
>  fs/xfs/xfs_qm.c                 |   27 ++-
>  fs/xfs/xfs_rtalloc.c            |  415 ++++++++++++++++++++++-----------------
>  18 files changed, 763 insertions(+), 537 deletions(-)

I'm finding this patch does far too many things to be reviewable.
There's code factoring, abstraction by local variables, changes to
locking APIs, etc that are needed to simplify the conversion, but
could all be done separately before the actual changeover to using
rtgroups.

There's also multiple functional changes in the code - like support
for growfs using rtgroups and moving to per-rtg summary caches - so
it's really difficult to separate and review the individual changes
in this.

Can you please split this up into a couple of separate steps? One
for all the local variable conversions and "no change" factoring,
one to move the summary cache code, one to add the grwofs support
and, finally, one to actually convert everything over to use
rtgroups directly?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
