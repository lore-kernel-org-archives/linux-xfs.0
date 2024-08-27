Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692FD19E7FB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724751620; cv=none; b=F2ZRU8ibxHSg36M3fBAKQ3eIFXA9DWr3Ruj2SKwg01EwQNHIKR6gpITh6jXuiAwvxKA8GNO5Nbh25kBmvX7ATMxPJiu2J5oQOH3n11YkEnSD1pYLByElPHSP4BNQEWNF1tQf+/4ttrtgsRgn3+vS2B3HDV0hk0oK2jNw6ADrbgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724751620; c=relaxed/simple;
	bh=5RpDWrC/pkF2adYaWnrjtlyhUK4+HuGfyUikbOi6kOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ruTI7yIbmBWZOgFkwSw8TqyE7eBbIVjwtORqboGCU8tfdMM1cInsRBWqE1fHnhofLaa3Ex++pKpMlZEc/bE/3k3FHdX9aZMZiH9CeiuNKf+qvJBqp3vycJrcn+BpNEZQ/ax4ga2ulnVCSgk5vXNvszrmE87g2nelSJm9J+6ETLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2/g9yqqB; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2/g9yqqB"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2d3d7a1e45fso3653302a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 02:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724751617; x=1725356417; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l8eDOuDSob55RuerLRy/OdodY3/iGKe0TTHn0YjTdt4=;
        b=2/g9yqqBII2ks96/FbQhq4mly+EOmORDVZ5p7uzcXV0snfr/Qofeoj4u3Bh4gzNXRt
         SavUmaF66R45ctzlyQePiWEo37I+EKZe6dyEE4S8rbmdIJahkmwcmt3yKPDIsdoEVoQE
         9dc/25WPjKUedMEL2ZVUHPoLx4AwGMcsuQ0jDBRERt2OA7Sc0BnpM/kXj+fcDXdJtc8z
         NsRBqa/lwFI1aeB+c969jhQPMz/sdFJ1CvsJCxiXW3KIFvTrYiGY5A64X/R0MJEvEsBu
         Hm3hRAUYd5KhlxNh0BbYMIO9PLV9LmPDyng90+flShtujMzqMF34PSELgakT4wZX2YA1
         cI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724751617; x=1725356417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l8eDOuDSob55RuerLRy/OdodY3/iGKe0TTHn0YjTdt4=;
        b=Z+73YXvL6+uPQoyhAof868gja/TpN6U4CTDPUH0Al/Q6JfU5+yKNEKxr/B3Clc53zP
         M4Z264ECtXR25jYe1Pdw35FQUkOXtS7EIk9hKHFzz3l1Y2sWwOWx4PmmI6YqCDn4g4U3
         J8esSDxqmO9A3USHL/jvFwlTH2FyZt+JUKhe/C2qAiJM5lbIIyFSxdTijxSkuVt5eYrz
         TusS6XwJVlgEzQ0wJbvKvL5btR5zf151NbWVzm0xVrQgNzJBmiZHfVhyuuDUJcAZITf/
         2ffIu7j8XVbssKhhte0tlmAyOVKLpNLLCEOBo2ZAOUKMOfQyyL87S9ylKp3U4s9H8DkR
         gjyA==
X-Forwarded-Encrypted: i=1; AJvYcCXB9H8a6yCi20xxRjT3LKm/1pjuoQrO7gIElvCzhaUplVMbT0AtK77BiLI17xpsGwV5rnUa4eM99m8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxylSKmazHaneDgK4Mkw8GomG5h9BFy41P2O/hkgNFSuGLL+wHn
	5oK/5NGTgS2tSYr27595OuLNGlMsOxYqFm39UJuo7l+JWURmxxjA1xvoBu8KK0psePsuY2OMk5C
	W
X-Google-Smtp-Source: AGHT+IEE8KxryI9OXz+urhauailbdjtkynlFsnRlPb9QlGayjTGRt4XR9F3LTePKK69xengGWPa/oA==
X-Received: by 2002:a17:90a:1c08:b0:2d3:cc7e:c418 with SMTP id 98e67ed59e1d1-2d646bc9dfdmr10877197a91.15.1724751617430;
        Tue, 27 Aug 2024 02:40:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d613b1f0d5sm11546306a91.55.2024.08.27.02.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 02:40:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sisgQ-00EP8Y-1z;
	Tue, 27 Aug 2024 19:40:14 +1000
Date: Tue, 27 Aug 2024 19:40:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH 2/5] xfs: ensuere deleting item from AIL after shutdown
 in dquot flush
Message-ID: <Zs2e/kFGwEAXqfIq@dread.disaster.area>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-3-leo.lilong@huawei.com>
 <20240823170006.GF865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823170006.GF865349@frogsfrogsfrogs>

On Fri, Aug 23, 2024 at 10:00:06AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 23, 2024 at 07:04:36PM +0800, Long Li wrote:
> > Deleting items from the AIL before the log is shut down can result in the
> > log tail moving forward in the journal on disk because log writes can still
> > be taking place. As a result, items that have been deleted from the AIL
> > might not be recovered during the next mount, even though they should be,
> > as they were never written back to disk.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_dquot.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index c1b211c260a9..4cbe3db6fc32 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1332,9 +1332,15 @@ xfs_qm_dqflush(
> >  	return 0;
> >  
> >  out_abort:
> > +	/*
> > +	 * Shutdown first to stop the log before deleting items from the AIL.
> > +	 * Deleting items from the AIL before the log is shut down can result
> > +	 * in the log tail moving forward in the journal on disk because log
> > +	 * writes can still be taking place.
> > +	 */
> > +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> >  	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
> >  	xfs_trans_ail_delete(lip, 0);
> > -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> 
> I see the logic in shutting down the log before letting go of the dquot
> log item that triggered the shutdown, but I wonder, why do we delete the
> item from the AIL?  AFAICT the inode items don't do that on iflush
> failure, but OTOH I couldn't figure out how the log items in the AIL get
> deleted from the AIL after a shutdown. 

Intents are removed from the AIL when the transaction containing
the deferred intent chain is cancelled instead of committed due the
log being shut down.

For everything else in the AIL, the ->iop_push method is supposed to
do any cleanup that is necessary by failing the item push and
running the item failure method itself.

For buffers, this is running IO completion as if an IO error
occurred. Error handling sees the shutdown and removes the item from
the AIL.

For inodes, xfs_iflush_cluster() fails the inode buffer as if an IO
error occurred, that then runs the individual inode abort code that
removes the inode items from the AIL.

For dquots, it has the ancient cleanup method that inodes used to
have. i.e. if the dquot has been flushed to the buffer, it is attached to
the buffer and then the buffer submission will fail and run IO
completion with an error. If the dquot hasn't been flushed to the
buffer because either it or the underlying dquot buffer is corrupt
it will remove the dquot from the AIL and then shut down the
filesystem.

It's the latter case that could be an issue. It's not the same as
the inode item case, because the tail pinning that the INODE_ALLOC
inode item type flag causes does not happen with dquots. There is
still a potential window where the dquot could be at the tail of the
log, and remocing it moves the tail forward at exactly the same time
the log tail is being sampled during a log write, and the shutdown
doesn't happen fast enough to prevent the log write going out to
disk.

To make timing of such a race even more unlikely, it would have to
race with a log write that contains a commit record, otherwise the
log tail lsn in the iclog will be ignored because it wasn't
contained within a complete checkpoint in the journal.  It's very
unlikely that a filesystem will read a corrupt dquot from disk at
exactly the same point in time these other journal pre-conditions
are met, but it could happen...

> Or maybe during a shutdown we just stop xfsaild and let the higher
> level objects free the log items during reclaim?

The AIL contains objects that have no references elsewhere in the
filesystem. It must be pushed until empty during unmount after a
shutdown to ensure that all the items in it have been pushed,
failed, removed from the AIL and freed...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
