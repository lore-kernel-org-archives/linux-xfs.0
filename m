Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EEF6D6EB
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 06:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FuxoJQug"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6daf9d5f111so1322944b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jan 2024 22:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1704782300; x=1705387100; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4TaeSH40N71iN6ubwRI7GllyLH9ez7WY9LyVXx/rgDM=;
        b=FuxoJQugjAAiveJScWdUUWsFXKon25BFdNW3M3l7wmRt5YE2DZj7v8S63UvaF9tEUM
         +X2vstkGQ/fIZIekAjYEztZTd105unQ2lgv7PIFdrfqRLUrZHysj8AnHCa4LVv5FqBoY
         I9vdTYHQz12bD/9C7+8yM9esAoow0dVEatEnNYgY1ARf7ug7Pq7SBxD7aphf8Ph4QyMu
         FJnU7/rchUai83pcmtHXBnVdfj6gYJ4OULNKrDJmrN3qa2amGi8HNiL4SI4ZUS+M/pZj
         Vnm98Pfpw/wRKG+Z20M7tClY0IXMjH7kArgTBJ3mQgyyXnaxT6tnMG9vqwUOm3pyNMtW
         foww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704782300; x=1705387100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4TaeSH40N71iN6ubwRI7GllyLH9ez7WY9LyVXx/rgDM=;
        b=rsiy3mg5F5Z8/RF/Ox725oJLjFcPFD4ZXCzRjF+R1LSzC3Ziml9w7jXg4XGmenIQPy
         Q4jTLHzyuVm+q5EgA+Q9QTwoTKIhjUZi4xS7RCsBKDa7PPC+ScthPO7PXLlepCVfyMKA
         0PfmCma3lFFPydurZxNS+0FNpW4xUXmScc6z58m1AoncbszYZClIlpA1QoT91WqmOi+W
         0pe00BCtlE9ExgSmMnkQAGzTqZ3J5fanByhVyyCtzRpJH4VyPBnbPf2pOnDd1IgkxOcV
         kLu/GkN+Mku191pkDsef3iBV6VuKRvjlhkRKN/8Kp/nIe/3cv9UiAkVP3lIetIc7fcpK
         N4nw==
X-Gm-Message-State: AOJu0Yz4UhhnnUl4gFJg4eDbqp4a1MK8yhqo/SqYLmjgDBBU/jtlsauy
	nXJ86j+gXmNfbzAy0vbA4V9qXyMNwJLP85Mu5SEWS1DQ4rk=
X-Google-Smtp-Source: AGHT+IGcvy1TZgK7ypfITGu1BbkO+7JUrhf4EPDh5ExRxw9cFyAF5T11+KtrqfJUrupDMKjFCM0aTA==
X-Received: by 2002:a05:6a00:2442:b0:6d9:b075:a7d6 with SMTP id d2-20020a056a00244200b006d9b075a7d6mr5294360pfj.19.1704782300358;
        Mon, 08 Jan 2024 22:38:20 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id s15-20020a056a00178f00b006d9be279432sm901476pfg.2.2024.01.08.22.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 22:38:19 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rN5kf-007xpN-00;
	Tue, 09 Jan 2024 17:38:17 +1100
Date: Tue, 9 Jan 2024 17:38:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jian Wen <wenjianhn@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de,
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH v4] xfs: improve handling of prjquot ENOSPC
Message-ID: <ZZzp2ARmwf3FrkUV@dread.disaster.area>
References: <20231216153522.52767-1-wenjianhn@gmail.com>
 <20240104062248.3245102-1-wenjian1@xiaomi.com>
 <ZZtDRe+jzM72Y8mY@dread.disaster.area>
 <20240109061442.GD722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109061442.GD722975@frogsfrogsfrogs>

On Mon, Jan 08, 2024 at 10:14:42PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 08, 2024 at 11:35:17AM +1100, Dave Chinner wrote:
> > On Thu, Jan 04, 2024 at 02:22:48PM +0800, Jian Wen wrote:
> > > From: Jian Wen <wenjianhn@gmail.com>
> > > 
> > > Currently, xfs_trans_dqresv() return -ENOSPC when the project quota
> > > limit is reached. As a result, xfs_file_buffered_write() will flush
> > > the whole filesystem instead of the project quota.
> > > 
> > > Fix the issue by make xfs_trans_dqresv() return -EDQUOT rather than
> > > -ENOSPC. Add a helper, xfs_blockgc_nospace_flush(), to make flushing
> > > for both EDQUOT and ENOSPC consistent.
> > > 
> > > Changes since v3:
> > >   - rename xfs_dquot_is_enospc to xfs_dquot_hardlimit_exceeded
> > >   - acquire the dquot lock before checking the free space
> > > 
> > > Changes since v2:
> > >   - completely rewrote based on the suggestions from Dave
> > > 
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> > 
> > Please send new patch versions as a new thread, not as a reply to
> > a random email in the middle of the review thread for a previous
> > version.
> > 
> > > ---
> > >  fs/xfs/xfs_dquot.h       | 22 +++++++++++++++---
> > >  fs/xfs/xfs_file.c        | 41 ++++++++++++--------------------
> > >  fs/xfs/xfs_icache.c      | 50 +++++++++++++++++++++++++++++-----------
> > >  fs/xfs/xfs_icache.h      |  7 +++---
> > >  fs/xfs/xfs_inode.c       | 19 ++++++++-------
> > >  fs/xfs/xfs_reflink.c     |  5 ++++
> > >  fs/xfs/xfs_trans.c       | 41 ++++++++++++++++++++++++--------
> > >  fs/xfs/xfs_trans_dquot.c |  3 ---
> > >  8 files changed, 121 insertions(+), 67 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> > > index 80c8f851a2f3..d28dce0ed61a 100644
> > > --- a/fs/xfs/xfs_dquot.h
> > > +++ b/fs/xfs/xfs_dquot.h
> > > @@ -183,6 +183,22 @@ xfs_dquot_is_enforced(
> > >  	return false;
> > >  }
> > >  
> > > +static inline bool
> > > +xfs_dquot_hardlimit_exceeded(
> > > +	struct xfs_dquot	*dqp)
> > > +{
> > > +	int64_t freesp;
> > > +
> > > +	if (!dqp)
> > > +		return false;
> > > +	if (!xfs_dquot_is_enforced(dqp))
> > > +		return false;
> > > +	xfs_dqlock(dqp);
> > > +	freesp = dqp->q_blk.hardlimit - dqp->q_blk.reserved;
> > > +	xfs_dqunlock(dqp);
> > > +	return freesp < 0;
> > > +}
> > 
> > Ok, what about if the project quota EDQUOT has come about because we
> > are over the inode count limit or the realtime block limit? Both of
> > those need to be converted to ENOSPC, too.
> > 
> > i.e. all the inode creation operation need to be checked against
> > both the data device block space and the inode count space, whilst
> > data writes need to be checked against data space for normal IO
> > and both data space and real time space for inodes that are writing
> > to real time devices.
> 
> (Yeah.)
> 
> > Also, why do we care about locking here? If something is modifying
> > dqp->q_blk.reserved concurrently, holding the lock here does nothing
> > to protect this code from races. All it means is that we we'll block
> > waiting for the transaction that holds the dquot locked to complete
> > and we'll either get the same random failure or success as if we
> > didn't hold the lock during this calculation...
> 
> I thought we had to hold the dquot lock before accessing its fields.

Only if we care about avoiding races with ongoing modifications or
we want to serialise against new references (e.g. because we are
about to reclaim the dquot).

The inode holds a reference to the dquot at this point (because of
xfs_qm_dqattach()), so we really don't need to hold a lock just
to sample the contents of the attached dquot.

> Or are you really saying that it's silly to take the dquot lock *again*
> having already decided (under dqlock elsewhere) that we were over a
> quota?

No, I'm saying that we really don't have to hold the dqlock to
determine if the dquot is over quota limits. It's either going to
over or under, and holding the dqlock while sampling it really
doesn't change the fact that it the dquot accounting can change
between the initial check under the dqlock and a subsequent check
on the second failure under a different hold of the dqlock.

It's an inherently racy check, and holding the dqlock does nothing
to make it less racy or more accurate.

> In that case, perhaps it makes more sense to have
> xfs_trans_dqresv return an unusual errno for "project quota over limits"
> so that callers can trap that magic value and translate it into ENOSPC?

Sure, that's another option, but it means we have to trap EDQUOT,
ENOSPC and the new special EDQUOT-but-really-means-ENOSPC return
errors. I'm not sure it will improve the code a great deal, but if
there's a clean way to implement such error handling it may make
more sense. Have you prototyped how such error handling would look
in these cases?

Which also makes me wonder if we should actually be returning what
quota limit failed, not EDQUOT. To take the correct flush action, we
really need to know if we failed on data blocks, inode count or rt
extents. e.g. flushing data won't help alleviate an inode count
overrun...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
