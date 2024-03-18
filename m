Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E822B1E862
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 00:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710720021; cv=none; b=YAYHDpxhrPVfd1M0ZOnPEWhfK4XXy4+fvOVPCNYjGr0KrNBXT1Gh9KcuhRo7yhMHmwUDZJyyjvpAdFoTFdA8IgRwU2PnvobLL0r1ua2NYtnMf3zPYZGuLZlgZsWWQ5c9viwE6aR/CHadonxOkQ9Z3UucNNd0lFRIRMB/Q1ielGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710720021; c=relaxed/simple;
	bh=3SpPS+T0R8jq26YsU77UckwCe+HlSqUHg7JClZHkLN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNt4fifkJsDH1KEmwIjJ8MLSBycFiaSKB5dqsvOy1FyCEdFI7tG5G02SQ2p3Xfdpi/Kwhe1Eym5HNUWGnjR1TAwGymWAbZfl9BfhKXPPJ4g9fWba/cG1niQUDqyTYh3JDmoQ53NNTNPzpjk56h2My30u2ihGMpe9MU//Iu/+gHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=i35k2cCe; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="i35k2cCe"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e00d1e13acso1918605ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2024 17:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710720019; x=1711324819; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RCp8tq96v/iKPJoQFV9jbZOSuGa6rnBCL6IWJ7u4O3k=;
        b=i35k2cCeZIVFqJU62lDNJDAWDqcE9nibR7X/0D3qFvvZIfb9mlcXi5KzyowsAN/kfA
         4d5SJLHICJ1OJbpjSYUKc1NUTmEdpkyxKh4KpLDZd8qBLwa3+gwJKJJlttTbxS60jeRL
         SYfNt9PkeeNJyUH531i2y30cVOv29GIvRYd87NiTg7ce3R0WjWEN+RcmTIPHxa1KdkHg
         KvD8IdBVTgC5hQgR+pcpaSKtQbnfas85vXMNExxMRCAvRu6PjBj5LkXcowbpspxt7lV3
         ZJ6VQ+NhEXzDfYM9KTf1eCCXgmjS/EhVNRX5x1zFfx92xiYI+uUOkfqpdaQQAjTpWEE7
         Kyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710720019; x=1711324819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCp8tq96v/iKPJoQFV9jbZOSuGa6rnBCL6IWJ7u4O3k=;
        b=sAI7JnNkVFlea1mvp+QOQwKM0ZUrWG1w+MeJYNT157vCFoy1tLd8gQZcXx/5O1Tleh
         Zpxq5B4GTvMIb6qmgeFwebAuRpOgOulhOQglddTvvylzuHkW9A18UgFUyF6RlAgUy0MH
         Tvc3H73CEnKaIG5CoXV1TZZhszeMtswlm1ZmU2KVozKYIu6uiJIZfWmDB9SlMpbqdpNc
         a/Don2fHw4asCz1VYN9ri+fqRwKe5c+FIRHDq8uWK1wePVZT25GdMnNW3k56zsVPtVTC
         +dBRSg0on6yF0Azp0LaHehzWrcaBQbFYVBk+eR/6sqY1rneJosW6yB4idrwvwcOhmqNa
         7d8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXI7Yiib87dSDbQ1Y8OWrhu0B2EDVyjLqmMZIYPcYMcaL2zgSXDiKpTsoS2jdwp6MmXS56UcB5JBmfh9zdF95unLKF7iiR/ZJDV
X-Gm-Message-State: AOJu0Yzd/Q7Wcu3JvbILNOgOPK/tFhdlweXg02f4rWAPW2rOAzffDTS3
	EOtSD5TYu+b9Y+E7OV6XXhn5hx4LO97mQnl7JO4E4BJKjAZPl3kHL1Jqua/Uc6c=
X-Google-Smtp-Source: AGHT+IHBsY7pjUnF3wiJaNzGsUfOtFyfPSjjHJDICognGEc+7Me57cuusONT9Yo3TSLXdODVhCxinQ==
X-Received: by 2002:a17:903:32cd:b0:1de:e3d5:cdde with SMTP id i13-20020a17090332cd00b001dee3d5cddemr11549900plr.5.1710720018751;
        Sun, 17 Mar 2024 17:00:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902e88c00b001dd55986b75sm1396821plg.183.2024.03.17.17.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:00:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rm0QJ-003NRv-1k;
	Mon, 18 Mar 2024 11:00:15 +1100
Date: Mon, 18 Mar 2024 11:00:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: Max theoretical XFS filesystem size in review
Message-ID: <ZfeED+CLpgPkONAx@dread.disaster.area>
References: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>
 <ZcQYIAmiGdEbJCxG@dread.disaster.area>
 <ZfOSZnYi-02SoBIJ@bombadil.infradead.org>
 <ZfOg3dTO/R43FGiZ@dread.disaster.area>
 <ZfO2-wefNDEJGL5w@casper.infradead.org>
 <ZfSK68T9jJp8_Q-w@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfSK68T9jJp8_Q-w@bombadil.infradead.org>

On Fri, Mar 15, 2024 at 10:52:43AM -0700, Luis Chamberlain wrote:
> On Fri, Mar 15, 2024 at 02:48:27AM +0000, Matthew Wilcox wrote:
> > On Fri, Mar 15, 2024 at 12:14:05PM +1100, Dave Chinner wrote:
> > > On Thu, Mar 14, 2024 at 05:12:22PM -0700, Luis Chamberlain wrote:
> > > > Joining two 8 EB files with device-mapper seems allowed:
> > > > 
> > > > truncate -s 8EB /mnt-pmem/sparse-8eb.1; losetup /dev/loop1 /mnt-pmem/sparse-8eb.1
> > > > truncate -s 8EB /mnt-pmem/sparse-8eb.2; losetup /dev/loop2 /mnt-pmem/sparse-8eb.2
> > > > 
> > > > cat /home/mcgrof/dm-join-multiple.sh 
> > > > #!/bin/sh
> > > > # Join multiple devices with the same size in a linear form
> > > > # We assume the same size for simplicity
> > > > set -e
> > > > size=`blockdev --getsz $1`
> > > > FILE=$(mktemp)
> > > > for i in $(seq 1 $#) ; do
> > > >         offset=$(( ($i -1)  * $size))
> > > > 	echo "$offset $size linear $1 0" >> $FILE
> > > > 	shift
> > > > done
> > > > cat $FILE | dmsetup create joined
> > > > rm -f $FILE
> > > > 
> > > > /home/mcgrof/dm-join-multiple.sh /dev/loop1 /dev/loop2
> > > > 
> > > > And mkfs.xfs seems to go through on them, ie, its not rejected
> > > 
> > > Ah, I think mkfs.xfs has a limit of 8EiB on image files, maybe not
> > > on block devices. What's the actual limit of block device size on
> > > Linux?
> > 
> > We can't seek past 2^63-1.  That's the limit on lseek, llseek, lseek64
> > or whatever we're calling it these days.  If we're missing a check
> > somewhere, that's a bug.
> 
> Thanks, I can send fixes, just wanted to review some of these things
> with the community to explore what a big fat linux block device or
> filesystem might be constrained to, if any. The fact that through this
> discussion we're uncovering perhaps some missing checks is already
> useful. I'll try to document some of it.

I don't really care about some random documentation on some random
website about some weird corner case issue. Just fix the problems
you find and get the patches to mkfs.xfs merged.

Realistically, though, we just haven't cared about mkfs.xfs
behaviour at that scale because of one main issue: have you ever
waited for mkfs.xfs to create and then mount an ~8EiB XFS
filesystem?

You have to wait through the hundreds of millions on
synchronous writes (as in "waits for each submitted write to
complete", not O_SYNC) that mkfs.xfs needs to do to create the
filesystem, and then wait through the hundreds of millions of
synchronous reads that mount does in the kernel to allow the
filesystem to mount.

Hence we have not done any real validation of behaviour at that
scale because of the time and resource cost involved in just
creating and mounting filesystems at that scale. Unless you have
many, many hours to burn every time you want mkfs and mount a XFS
filesystem, it's just not practical to even do basic functional
testing at this scale.

And, really, mkfs.xfs is the least of the problems that need
addressing before we can test filesystems that large. We do full
filesystem AG walks at mount that need to be avoided, we need tens
of GB of RAM to hold all the AG information in kernel memory (we
can't demand free per-AG information yet - that's part of the
problem that makes shrink so complex), we have algorithms that do
linear AG walks that depend on AG information being held in memory,
etc. When you're talking about an algorithm that can iterate all AGs
in the filesystem 3 times before failing and having 8.4 million AGs
indexed, this is a serious scalability problem.

IOWs, we've got years of development ahead of us to scale the
filesystem implementation out to handle filesystems larger than a
few PiB effciently - mkfs.xfs limits are the most trivial of things
compared to the deep surgery that is needed to make 64 bit capacity
support a production-quality reality....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
