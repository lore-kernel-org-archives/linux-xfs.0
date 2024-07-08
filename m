Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41A6BA46
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 22:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720478320; cv=none; b=Msz0PVbrNAQ5ilaXfDlOFgtRalbIbvOlIhAHtiyKfPwMexk+PdS71By1mSjpsKpnpnHobRSIbifzJLqPyBwaENFq7h8A+cegURcXIZArgOseD740MRrrUli2mbxTU/QTP5fq0JqTe2LNqyaiJhlOQkKieVTrrC94e/UDGFrc2iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720478320; c=relaxed/simple;
	bh=/h5xetnvSvdxCRVaDlSxL6PNJ7PWtn/RFVmLv6NDpdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YIYzCaq784lfkkhAk711809Q+p8UkhQTibkajFIhN+Y+of2VjvdN4uw8vDMxlu59tv7oEg4oyvAvUzIkRvZo7ZC9sJg4k24AxNrrA0bkZbfm5wpCe8tkINGDYbgpcDyMSUIhhjT5HEmzA0oodsKg6mfk5Sf//qittUzI71yfacU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uPMDm9Xk; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uPMDm9Xk"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70af48692bcso2751096b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2024 15:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720478318; x=1721083118; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MJM7f+Jo6hJoZKJWYLuy6O2cBhS7ua9fFa68S3H6JXM=;
        b=uPMDm9Xkgeg+4iK2FYJ4uFo+6SCvnoeTYdJfAEOGct/0O2sfBGu8lA6R0eMyKIJ805
         aCrNS3kSgoprfNO+had5lzgAR6V5POE0zg8gDGYm6mWjTy2+xCX764ZXr7YOeo1nCAy/
         gAjys08GQf4lbZalGCv2NcJmX1bZcolW8EasLCu9dAyauXn9KWGBbuAwhxtupO1RcLIT
         kFGtDe/1M0nf8bUhFoJeskDokmkrjng/wUSwg/kp33I29eavbx//rpsqMjl83rxyR4rZ
         Hyd1HpP0i4rDVb9xOHpZwu3yT8kMGa+GQP1FJfY3ig0AqnAUXYrEMP+f3THLkuNHoUj1
         fxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720478318; x=1721083118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJM7f+Jo6hJoZKJWYLuy6O2cBhS7ua9fFa68S3H6JXM=;
        b=rH+LtumKiTbgmSDiOaz+7vBxCxWL3l5dfdiYBhPiGhFNbExIgWZRlRdp5BXtp2e8SF
         QChmMXG5a2X+K74K20onmxke3foCCrmGPbVhtcrC9FyWml8r1mTukM4+w7ACrWLvDBOo
         +BC9xqC/pYM6UNll/H2Fgcjm/ogDkUKqcbPjLCNlSopv+EjYClyiv0I7+VDTI1rhi3Ly
         +qZ3WqKeyOVMJlrx6MkASzv49UxuXPXE4NYFv+YAX5H+E43WX3vPRiVNRl1jykrxCHf4
         pv5LQv7Ohqv7oU70cFYmqGCb+C6PX3IsQ9F/a/XV1ILuIJg6R+2VWWKB/yTzSBPuMPvj
         8gKw==
X-Forwarded-Encrypted: i=1; AJvYcCWZFGxlUcYD70evrv7lR+kiHNbYrd74D2sR0huibufBkP+0ZGphln84Vkb79Eexea3B+It3RzCA/4LGBQJpw8gRKqGjdjBRjRdO
X-Gm-Message-State: AOJu0Yx22nLKwUC+ZXwto5UK7tOtAsI72Oslot5Q9NvJmy+hEb50qNbd
	3arZ4+GwFi21uuJphBzBrsOPc+kIXMl+MsMMrOvKPiqlkgvmdihWs7NXkMQcoQ4=
X-Google-Smtp-Source: AGHT+IFGyZ3UEDh9XdJG0H3OObqiEOVEjm6gvnUyVJW/H5Djwsz+kEeS3sCtPggRn1451giXplBlAQ==
X-Received: by 2002:a05:6a00:1a94:b0:706:6962:4b65 with SMTP id d2e1a72fcca58-70b43565ea5mr1249975b3a.14.1720478317837;
        Mon, 08 Jul 2024 15:38:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b439ab788sm391306b3a.167.2024.07.08.15.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 15:38:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sQx0E-0090yY-2K;
	Tue, 09 Jul 2024 08:38:34 +1000
Date: Tue, 9 Jul 2024 08:38:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Long Li <leo.lilong@huawei.com>,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: eliminate lockdep false positives in
 xfs_attr_shortform_list
Message-ID: <ZoxqanGtyNsYh0XC@dread.disaster.area>
References: <20240622082631.2661148-1-leo.lilong@huawei.com>
 <20240624160342.GP3058325@frogsfrogsfrogs>
 <5ce25a1a-51d7-4cf3-a118-91eeeefe29a4@sandeen.net>
 <20240708190005.GQ612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708190005.GQ612460@frogsfrogsfrogs>

On Mon, Jul 08, 2024 at 12:00:05PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 08, 2024 at 10:40:37AM -0500, Eric Sandeen wrote:
> > On 6/24/24 11:03 AM, Darrick J. Wong wrote:
> > > On Sat, Jun 22, 2024 at 04:26:31PM +0800, Long Li wrote:
> > >> xfs_attr_shortform_list() only called from a non-transactional context, it
> > >> hold ilock before alloc memory and maybe trapped in memory reclaim. Since
> > >> commit 204fae32d5f7("xfs: clean up remaining GFP_NOFS users") removed
> > >> GFP_NOFS flag, lockdep warning will be report as [1]. Eliminate lockdep
> > >> false positives by use __GFP_NOLOCKDEP to alloc memory
> > >> in xfs_attr_shortform_list().
> > >>
> > >> [1] https://lore.kernel.org/linux-xfs/000000000000e33add0616358204@google.com/
> > >> Reported-by: syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com
> > >> Signed-off-by: Long Li <leo.lilong@huawei.com>
> > >> ---
> > >>  fs/xfs/xfs_attr_list.c | 3 ++-
> > >>  1 file changed, 2 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > >> index 5c947e5ce8b8..8cd6088e6190 100644
> > >> --- a/fs/xfs/xfs_attr_list.c
> > >> +++ b/fs/xfs/xfs_attr_list.c
> > >> @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
> > >>  	 * It didn't all fit, so we have to sort everything on hashval.
> > >>  	 */
> > >>  	sbsize = sf->count * sizeof(*sbuf);
> > >> -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
> > >> +	sbp = sbuf = kmalloc(sbsize,
> > >> +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> > > 
> > > Why wouldn't we memalloc_nofs_save any time we take an ILOCK when we're
> > > not in transaction context?  Surely you'd want to NOFS /any/ allocation
> > > when the ILOCK is held, right?
> > 
> > I'm not sure I understand this. AFAICT, this is indeed a false positive, and can
> > be fixed by applying exactly the same pattern used elsewhere in
> > 94a69db2367e ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
> > 
> > Using memalloc_nofs_save implies that this really /would/ deadlock without
> > GFP_NOFS, right? Is that the case?
> > 
> > I was under the impression that this was simply a missed callsite in 94a69db2367e
> > and as Long Li points out, other allocations under xfs_attr_list_ilocked()
> > use the exact same (GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL) pattern
> > proposed in this change.
> 
> Oh, now I see that the alleged deadlock is between the ILOCK of a
> directory that we're accessing, and a different inode that we're trying
> to reclaim.  Lockdep doesn't know that these two contexts are mutually
> exclusive since reclaim cannot target an inode with an active ref.  NOFS
> is a big hammer, which is why the proposal is to turn off lockdep for
> the allocation?  Why not fix lockdep's tracking?
> 
> <sees another thread>
> https://lore.kernel.org/linux-xfs/Zou8FCgPKqqWXKyS@dread.disaster.area/
> 
> We can't use an ILOCK subclass for the reclaim code because we've run
> out of lockdep subclasses.  I guess you could abuse lockdep_set_class to
> change the lockdep class of an ILOCK when the inode enters reclaim (and
> change it back if the inode gets recycled) but that's a bit gross.
> 
> What if we got rid of XFS_ILOCK_RT{BITMAP,SUMMARY} to free up subclass
> bits?
> 
> https://lore.kernel.org/linux-xfs/?q=xfs%3A+remove+XFS_ILOCK_RT

Yes, that would probably work - all we need is a single subclass for
the ilock to say reclaim locking is a different context. There
should only be one lock site that we need that annotation for
(the final xfs_ilock() in xfs_reclaim_inode() after the inode has
been removed from the radix tree), and we don't need nesting because
we are only locking a single inode at a time.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
