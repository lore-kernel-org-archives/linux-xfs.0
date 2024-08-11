Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8251A28FC
	for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2024 23:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723420100; cv=none; b=Cc3Hm2/1GNCVepsGsj8/oK7BQW3e5MlXs3zfpH3z0puMPVCCZD8MGXqL0QuZO6pRJusubE2mgOmO3HGDgQ+vmaauJPUuDCtJKh4lHKvaM2ARMJ7inn/Nja4zy94YHstydHQMILRbH0RlFaFENE4RsHaR+TruG+Vz+ro2xtQd2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723420100; c=relaxed/simple;
	bh=H1UW/xKzcvMJ+r/Jpwah8D+T8dcCF//bd6lL85sfbtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbwPFKRfPZWOq+0634WvrRTwxMf1shc3a8T0TEc1BdIatxynsu73fPV0fz4YrrOoj4w9xkI0dHWJFmvfw1vJN1mUiRRvK8jRY/4Sdd8obBWrdEwHrY6TIay6i4vyj5x8NIhIII6LmulMnkhKZ1u+RAAtMRRPv3+EXEiJAnFkgFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=oIAsuYc3; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="oIAsuYc3"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2cb6662ba3aso2481357a91.1
        for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2024 16:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723420098; x=1724024898; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lv42EnrcBPnXVT76SapYmuJuHXzchC2VmcEA3YFI6Ms=;
        b=oIAsuYc3lQ1Ah8oQayk+XUoc4srByP+0vxVWGkNePW1YAYnI0PF0YNvSN4D/cFiTYU
         /uTlIH//XZuR/Gd1teQg14EDr4qk9gfAGbY+rFaQh4Q4q8d28Rh3Vb7Mnvv/Xe70JdcU
         7Mvd9lzl4k+oRYQplXV3UqCSuWTzJSBQhoETgJGV19PzioMuRnlHjj5l87mDBdpluZ5Y
         Nt+IHE14vI0rvIlcCbrxu3etYpZkbsWOr7FTaAem8nojJROjwOi1+g9ysaSfmcJen4Te
         mn2HxCgN9nb30CTnIzELYEf8RYNxprYzX2/XzjLSBHdQ4eiRKD81R+bFcPh4qSXUv2Jv
         naLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723420098; x=1724024898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lv42EnrcBPnXVT76SapYmuJuHXzchC2VmcEA3YFI6Ms=;
        b=dTHAieqvyigByQdQSKFVIeBsJlW+LPj31ECf2iRkN4xagf2rWwRZq3fc0PP0SknBNA
         FTtoBNetlBPLHz6WeuKpI5FXOSQRFi1QXM9PyTS12Y5WhDHLw53jutm/wImzS1ziHm8o
         WWY0PLVxI6H8AoUOmztK0zNPuXeSmyKpkyAe+immVCyeNcbpAUtao/zTyzzzeOKf+pvM
         /m5ZPPJZJX7ootVmtA2OAunfgJs80cDLJ/8O9PuddulEeDgQ5M+w+mpiZpm2jUQwIDL0
         fbJA1iVoF4R+Rp0YtvagZ0jBy7qHmIChhEvCLsDcLeC0qG07TmJtCsBwQg/fWYvy7xC2
         WzTw==
X-Forwarded-Encrypted: i=1; AJvYcCVOYIrHU2fX8yygq4aSRyx2vuaF5gATvYNdPoW37pxxMIrE4inke5QOjKVjw0B54bEKumYzkFvVBNJBKpNCQNATM+qz6ZI0bU3b
X-Gm-Message-State: AOJu0YxC2AJep3lsnGEJQOD6FdXWWYz7zsfbJTw4TF7JQ8IK4wgU9mbD
	Twn9n02XG/0AURmZ/8pY33qmpAoWA70af9uhk+04lrvqKp5+QQvFF8Hcwy3AB5/XLFyOiZhzzwV
	B
X-Google-Smtp-Source: AGHT+IGsjgJbMq+rrDBSTleSGK9YC0Who1RM0mxob13kS7WzpGuKh6166p7SaPhdmSZZKRWcSAScXQ==
X-Received: by 2002:a17:90b:8d4:b0:2c9:75a7:5c25 with SMTP id 98e67ed59e1d1-2d1c4c2dae7mr18635261a91.15.1723420097623;
        Sun, 11 Aug 2024 16:48:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9db44dasm6846990a91.45.2024.08.11.16.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 16:48:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sdIIG-00DoFU-2u;
	Mon, 12 Aug 2024 09:48:12 +1000
Date: Mon, 12 Aug 2024 09:48:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: check XFS_EOFBLOCKS_RELEASED earlier in
 xfs_release_eofblocks
Message-ID: <ZrlNvJairwgvACh2@dread.disaster.area>
References: <20240808152826.3028421-1-hch@lst.de>
 <20240808152826.3028421-8-hch@lst.de>
 <ZrVOvDkhX7Mfoxy+@dread.disaster.area>
 <20240811085952.GB12713@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240811085952.GB12713@lst.de>

On Sun, Aug 11, 2024 at 10:59:52AM +0200, Christoph Hellwig wrote:
> On Fri, Aug 09, 2024 at 09:03:24AM +1000, Dave Chinner wrote:
> > The test and set here is racy. A long time can pass between the test
> > and the setting of the flag,
> 
> The race window is much tighter due to the iolock, but if we really
> care about the race here, the right fix for that is to keep a second
> check for the XFS_EOFBLOCKS_RELEASED flag inside the iolock.

Right, that's exactly what the code I proposed below does.

> > so maybe this should be optimised to
> > something like:
> > 
> > 	if (inode->i_nlink &&
> > 	    (file->f_mode & FMODE_WRITE) &&
> > 	    (!(ip->i_flags & XFS_EOFBLOCKS_RELEASED)) &&
> > 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> > 		if (xfs_can_free_eofblocks(ip) &&
> > 		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> > 			xfs_free_eofblocks(ip);
> > 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> > 	}
> 
> All these direct i_flags access actually are racy too (at least in
> theory).

Yes, but we really don't care about racing against the bit being
set. The flag never gets cleared unless a truncate down occurs, so
we don't really have to care about racing with that case - there
will be no eofblocks to free.

If the test races with another release call setting the flag (i.e.
we see it clear) then we are going to go the slow way and then do
exactly the right thing according to the current bit state once we
hold the IO lock and the i_flags_lock.

> We'd probably be better off moving those over to the atomic
> bitops and only using i_lock for any coordination beyond the actual
> flags.  I'd rather not get into that here for now, even if it is a
> worthwhile project for later.

That doesn't solve the exclusive cacheline access problem Mateusz
reported. It allows us to isolate the bitop updates, but in this
case here the atomic test-and-set op still requires exclusive
cacheline access.

Hence we'd still need test-test-and-set optimisations here to avoid
the exclusive cacheline contention when the bit is already set...

> > I do wonder, though - why do we need to hold the IOLOCK to call
> > xfs_can_free_eofblocks()? The only thing that really needs
> > serialisation is the xfS_bmapi_read() call, and that's done under
> > the ILOCK not the IOLOCK. Sure, xfs_free_eofblocks() needs the
> > IOLOCK because it's effectively a truncate w.r.t. extending writes,
> > but races with extending writes while checking if we need to do that
> > operation aren't really a big deal. Worst case is we take the
> > lock and free the EOF blocks beyond the writes we raced with.
> > 
> > What am I missing here?
> 
> I think the prime part of the story is that xfs_can_free_eofblocks was
> split out of xfs_free_eofblocks, which requires the iolock.  But I'm
> not sure if some of the checks are a little racy without the iolock,

Ok. I think the checks are racy even with the iolock - most of the
checks are for inode metadata that is modified under the ilock (e.g.
i_diflags, i_delayed_blks) or the ip->i_flags_lock (e.g.
VFS_I(ip)->i_size for serialisation with updates via
xfs_dio_write_end_io()). Hence I don't think that holding the IO
lock here makes any difference here at all...

> although I doubt it matter in practice as they are all optimizations.
> I'd need to take a deeper look at this, so maybe it's worth a follow
> on together with the changes in i_flags handling.

*nod*

-Dave.

-- 
Dave Chinner
david@fromorbit.com
