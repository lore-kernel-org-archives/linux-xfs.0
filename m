Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07791382
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 00:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731456727; cv=none; b=k4JhB5QPfCPxOa5NY5qlVp8cQBzUxGPo6kcYmcqnhnUdrcmdDQf+vjX7hZdYoX0nV1fvknMAYiusjA6bKqYTu+4vm5KmP0vL+lkuY2ZTRKbYnAhzx8cMW1tlS7VTANevJAwGc54aVt4WC6mHOLISQFl/o6tRM0riPP0Ur7c6UwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731456727; c=relaxed/simple;
	bh=D4dUXinN3a/7SY6s2ikWa/3yWdu6XM9wsIHGLEs7tvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoazzGZpx2I9t6a1a6MaP9kSnOLQOMaYAl77OQHnVF432H+srSS2/kn1U7QHvPoxVhCsfm+vgFzqHZXepjaf+JP8GVLRNJW5VaakyIZ+I5tkRuC4h3dKVeY5Amh0VSkpv8J7zztFUxVcXy3TLrYFH+7KRCeaiAroBhHs8CE7zsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ny91xjo5; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ny91xjo5"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20ce5e3b116so56099335ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731456725; x=1732061525; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PcGYr90K+ldealbaRUPu8LQefQ0BSZZasBXOygULFvk=;
        b=ny91xjo5cQRkERkceDiCzTDu3bRu2cm6dAf9cMp+DZDTVrckfmvVOPvcpiCtsWey1x
         eZLiBV0GUvgRyVl0MtYccNvOfAp1OXclfhOgF0vhBsYgdo9wC5AqVxBKWB7tJag6lYt5
         yAIgleQAW0enBnMQ8rBSWSTCn6XT7uzrgDh5y0tP8kim1Hjxv25j7pPmIETvnzJ51que
         dMq8OSEAAa85/daEs5jFTdkDQVDner9Dq3AzeTbHMf/3HWzFKc6BSWS+gUvcLrO1lGOC
         aliPZ3v77vJuzl++AmG+xL0taUUShBFosM3ApOhdjDm/REZgf8hHSoRQproNybFPfOuW
         Vg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731456725; x=1732061525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PcGYr90K+ldealbaRUPu8LQefQ0BSZZasBXOygULFvk=;
        b=lLfMgiXu6M/OX4X6FaZmZiSLosK7uRSCHFPU0UUXEEG0sEBIqBEjdSeST0ZIVo0f1H
         pLDUxt5gwXbCd5A5ysPpn4l6t4TCIqOcLjwNKsLQKp3beA/CQbzR9OSjDRhCvXp3l6nF
         My5Zyc7xiANSe1AZKzpSYPzOgJYnlECaKfuYtm/b7Zqxw5QIVch/QLku4RdtBfTxhdaK
         NeI5Umpc1xg0xX4Iik25zBE9lfYe3rGlxDH9wOsiaBCf+EwsoSbA8hePjzDLTezDC09k
         WLJUT4Xbk9EbUFVdlTPPUDTKP7PG09oPA9ttJ1aLNJwGMcxiwAL2/jsI0vdkKvf0GAER
         /Tiw==
X-Gm-Message-State: AOJu0Yw+ucq6FigXLKtYbwOaW5JUr337nYa4k8pf9Dk2cY972nI3cUeU
	qUmqMt3CmpCR9yyhT/l4KbfJoJa7aPXHR/K7xAYerzjFJJNbwwJ10SmBj7DuNxUISpjmtloPTwf
	M
X-Google-Smtp-Source: AGHT+IEkUwa0D1tUJc7kgMoIbJXBg8fFS4ycUR6MbGNhNN1M/44xhZtARrNva+ChOUO3jYuqTnYhAQ==
X-Received: by 2002:a17:902:d4cb:b0:211:18bc:e74b with SMTP id d9443c01a7336-21183d10abcmr240065315ad.1.1731456725240;
        Tue, 12 Nov 2024 16:12:05 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e6e192sm98924205ad.232.2024.11.12.16.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 16:12:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1tB0zK-00Dr4W-0S;
	Wed, 13 Nov 2024 11:12:02 +1100
Date: Wed, 13 Nov 2024 11:12:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 1/3] xfs: fix sparse inode limits on runt AG
Message-ID: <ZzPu0mxbqVjplwOj@dread.disaster.area>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-2-david@fromorbit.com>
 <20241112231539.GG9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112231539.GG9438@frogsfrogsfrogs>

On Tue, Nov 12, 2024 at 03:15:39PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 13, 2024 at 09:05:14AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The runt AG at the end of a filesystem is almost always smaller than
> > the mp->m_sb.sb_agblocks. Unfortunately, when setting the max_agbno
> > limit for the inode chunk allocation, we do not take this into
> > account. This means we can allocate a sparse inode chunk that
> > overlaps beyond the end of an AG. When we go to allocate an inode
> > from that sparse chunk, the irec fails validation because the
> > agbno of the start of the irec is beyond valid limits for the runt
> > AG.
> > 
> > Prevent this from happening by taking into account the size of the
> > runt AG when allocating inode chunks. Also convert the various
> > checks for valid inode chunk agbnos to use xfs_ag_block_count()
> > so that they will also catch such issues in the future.
> > 
> > Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
> 
> Cc: <stable@vger.kernel.org> # v4.2
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 271855227514..6258527315f2 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -855,7 +855,8 @@ xfs_ialloc_ag_alloc(
> >  		 * the end of the AG.
> >  		 */
> >  		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
> > -		args.max_agbno = round_down(args.mp->m_sb.sb_agblocks,
> > +		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
> > +							pag->pag_agno),
> 
> So if I'm reading this right, the inode cluster allocation checks now
> enforce that we cannot search for free space beyond the actual end of
> the AG, rounded down per inode alignment rules?
> 
> In that case, can this use the cached ag block count:
> 
> 		args.max_agbno = round_down(
> 					pag_group(pag)->xg_block_count,
> 					args.mp->m_sb.sb_inoalignmt);
> 
> rather than recomputing the block count every time?

Eventually, yes. I have another series that pushes the pag further
into these AG size checks all over the code to try to avoid this
entire class of bug in the future (i.e. blindly using mp->m_sb ag
parameters without considering the last AG is a runt).

I am waiting for the group rework to land
before I did any more work on that conversion. However, it is not
yet in the for-next branch, so I'm assuming that it isn't due to be
merged in the upcoming merge window because that's about to open
and none of that code has seen any time in linux-next of fs-next...

I want this fix to land sooner rather than later, so I used
xfs_ag_block_count() to avoid conflicts with pending work as well
as not require me to chase random dev branches to submit what is a
relatively simple bug fix....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
