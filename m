Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DD14405
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 01:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726622418; cv=none; b=hN2S2LU+vvXZ5wpVlomZG1Rb9H1QSPkYU9WpcSgbHMATxM2eU5gbTFIHO+vEx4wwEe734VShauU6BWHPAB2iVp5LBhWwtvRUOKl2WfkE2LFA6XnhlCB/HeyjscmvdFn1MeQQe5pxHt4nti5KeN8I1Mre0JS5x3mzTZI5Uz6hUOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726622418; c=relaxed/simple;
	bh=KFhPYXA9lQgLtfWa/MtVHQdZh7+GCpLUv68ffS2XVgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efRpGlzDY1TKHXzBkq9BgRBXd80ofqUKn3BFhUMfw0vn7L6alU9KONfCA3oYW2DzmeuODZUyBhQvl/mLvP58QkkEXAeNRQqVRFuLjyBfsM2R7snT7x5lDs39xgkRw3cF14JZ8eDlh0BgnwllVEbTI6eJiUrTiEjZd1wlSSDtWGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zEZ0zjgO; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zEZ0zjgO"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2059204f448so57660835ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 18:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726622416; x=1727227216; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qxxW1IuM04esdHxBQxHHr5oO9yZy5/DXPKQpJTg35JQ=;
        b=zEZ0zjgOf8XW1OQ4E0+srS7RquVnw/iPn/gdcc/TQet583qZDHoLDuOgokJLStsST+
         P4oCAR/9HP4cLDPN4y27bM+GLvyu1qu0lWexsN8QZi45Uk5mQwtP0tNtn3nOvaifn8qC
         SPqP8Mel964PbFde600pC+7B1r7fHNjP6wwyF+i3FfTdqQj8/TfBlmc3F9qQeIESKUCZ
         IVAxblXpfQbB+gRKWCAilMcAB10dZM6PY7Hs/nABq9y819WuyunKfShT1MFe1stTr58A
         99z7l+ylLeQ/0yNndU2Q0jJ67MXKpmAKRpJYKXBOI+il5B7xZ+7EeEzS8SmOeSkihUCB
         sk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726622416; x=1727227216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxxW1IuM04esdHxBQxHHr5oO9yZy5/DXPKQpJTg35JQ=;
        b=pSQ+AJv0M0ZenJxCvJl9VzYW1aQ1ZSEt1oLzG5V2yJN1NbbMn36ERXqxpOym05Lme1
         o6M2Vt0FpwfVvqDcwAA40jlEB6HKCYGw/ePxBJ0g+pEraegTADthN2SgKbXXwZ9TqZmQ
         GPWP9tsSJHl8R4yhrvCm70FzoS2vxPghfvUb3aqkK3DqbWx8r94kbrl2ISyEKjzVHnVe
         53i0afhyP9GAcFv5fUiLlaPdWWJ3MXI5Kik8LzknRPjQZJoc/LRbhjvOd/9UlkJeuLEA
         IQGrDr2TLSi6LIbwuFpXeHnaze+4+bXPR1LG0kr60FcYX9KkTv7dEGTaWbjKAEq0+vNw
         17Bw==
X-Gm-Message-State: AOJu0Yy8EbVjRt/pzK4BbLRbnKwYiW+TkXQ9NbS/G5Sx/MASR0mRVAfJ
	6OLhjK0jN519fyXOOeb18ow8PDoCaU3+5pi6eAmnpmhtc119y29BeVv9WA656ek=
X-Google-Smtp-Source: AGHT+IFjQmvaIG7B6dO5jArvP6cNKhjxyHtpJmaEBYazv8+oYjr7hY9BQZ/p08eER/kGRqRXYe9pgw==
X-Received: by 2002:a17:902:e881:b0:203:a0b4:3e28 with SMTP id d9443c01a7336-2076e37b238mr280437385ad.27.1726622415856;
        Tue, 17 Sep 2024 18:20:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207946016cesm55589945ad.97.2024.09.17.18.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2024 18:20:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sqjMa-006b1d-0D;
	Wed, 18 Sep 2024 11:20:12 +1000
Date: Wed, 18 Sep 2024 11:20:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Prevent umount from indefinitely waiting on
 XFS_IFLUSHING flag on stale inodes
Message-ID: <ZuoqzHHHwNbCv+dQ@dread.disaster.area>
References: <20240902075045.1037365-1-chandanbabu@kernel.org>
 <ZtW8cIgjK88RrB77@dread.disaster.area>
 <87v7z0xevx.fsf@debian-BULLSEYE-live-builder-AMD64>
 <87zfo8dly5.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zfo8dly5.fsf@debian-BULLSEYE-live-builder-AMD64>

On Mon, Sep 16, 2024 at 11:14:32AM +0530, Chandan Babu R wrote:
> On Thu, Sep 05, 2024 at 06:12:29 PM +0530, Chandan Babu R wrote:
> >>> To overcome this bug, this commit removes the check for log shutdown during
> >>> high level transaction commit operation. The log items in the high level
> >>> transaction will now be committed to the CIL despite the log being
> >>> shutdown. This will allow the CIL processing logic (i.e. xlog_cil_push_work())
> >>> to invoke xlog_cil_committed() as part of error handling. This will cause
> >>> xfs_buf log item to to be unpinned and the corresponding inodes to be aborted
> >>> and have their XFS_IFLUSHING flag cleared.
> >>
> >> I don't know exactly how the problem arose, but I can say for
> >> certain that the proposed fix is not valid.  Removing that specific
> >> log shutdown check re-opens a race condition which can causes on
> >> disk corruption. The shutdown was specifically placed to close that
> >> race - See commit 3c4cb76bce43 ("xfs: xfs_trans_commit() path must
> >> check for log shutdown") for details.
> >>
> >> I have no idea what the right way to fix this is yet, but removing
> >> the shutdown check isn't it...
> >>
> 
> Commit 3c4cb76bce43 describes the following scenario,
> 
> 1. Filesystem is shutdown but the log remains operational.
> 2. High-level transaction commit (i.e. xfs_trans_commit()) notices the fs
>    shutdown. Hence it aborts the dirty log items. One of the log items being
>    aborted is an inode log item.
> 3. An inode cluster writeback is executed. Here, we come across the previously
>    aborted inode log item. The inode log item is currently unpinned and
>    dirty. Hence, the inode is included in the cluster buffer writeback.
> 4. Cluster buffer IO completion tries to remove the inode log item from the
>    AIL and hence trips over an assert statement since the log item was never
>    on the AIL. This indicates that the inode was never written to the journal.
> 
> Hence the commit 3c4cb76bce43 will abort the transaction commit only when the
> log has been shutdown.
> 
> With the log shutdown check removed, we can end up with the following cases
> during high-level transaction commit operation,
> 1. The filesystem is shutdown while the log remains operational.
>    In this case, the log items are committed to the CIL where they are pinned
>    before unlocking them.
>    This should prevent the inode cluster writeback code
>    from including such an inode for writeback since the corresponding log item
>    is pinned. From here onwards, the normal flow of log items from the CIL to
>    the AIL occurs after the contents of the log items are written to the
>    journal and then later unpinned.
>    The above logic holds true even without applying the "RFC patch" presented
>    in the mail.
>  
> 2. The log is shutdown.
>    As in the previous case, the log items are moved to the CIL where they are
>    pinned before unlocking them. The pinning of the log items prevents
>    the inode cluster writeback code from including the pinned inode in its
>    writeback operation. These log items are then processed by
>    xlog_cil_committed() which gets invoked as part of error handling by
>    xlog_cil_push_work().

It's more complex than that.

3. We get an error returned from xfs_defer_finish_noroll() or
xfs_trans_run_precommits().

In these cases we skip the insertion into the CIL altogether and
cancel the dirty transaction with dirty log items exactly as we
currently do right now.

This is why, in that series of commits, I changed all the shutdown
checks for metadata operations to use xlog_is_shutdown() as opposed
to xfs_is_shutdown() - to ensure that shutdown checks are consistent
with what __xfs_trans_commit() required. Hence these paths would all
behave the same way when dirty transactions are canceled, and that
leads to the next point:

4. Random high level code that does this:

	if (xlog_is_shutdown(log))
		xfs_trans_cancel(tp);

has the same problem - we abort dirty items and release them when
the log has been shut down. In these cases, we have no possible
mechanism to insert them into the CIL to avoid the same shutdown
race condition.

IOWs, removing the shutdown check from __xfs_trans_commit() doesn't
resolve the problem entirely as there are other paths that lead to
the same situation where we cancel transactions due to the log being
shut down.

5.  An the architectural issue with the fix: inserting the items
into the CIL instead of aborting them requires something or someone
to push the CIL to error out the items and release them.

Who is responsible for invoking that push?

It's not xlog_cil_commit(). That only pushes on the CIL if the
amount of queued work is over the push threshold, otherwise it will
not queue xlog_cil_push_work() to run again.

Hence every call to xfs_trans_commit() is now absolutely reliant on
some future code pushing the CIL to free the items that were
committed to the CIL after the log is shut down.

I think that is eventually caught by the xfs_log_unmount() path
doing a log force. i.e.

xfs_log_unmount
  xfs_log_clean
    xfs_log_quiesce
      xfs_log_force
        xlog_cil_force
	  xlog_cil_force_seq
	    xlog_cil_push_now

However, this is reliant on there being no shutdown checks in this
path, and xlog_cil_push_work() avoiding any shutdown checks until
it's done all the work needed to be able to cancle the pending log
items, right?

IOWs, there's lots of things that have to be done just right for
this "future cleanup" mechanism to work, and we have to be very
careful not to place a shutdown check in just the wrong spot
otherwise we can break the shutdown processing.

We know how problematic this can be - this "cleanup is somebody
else's future problem" model is how we used to handle shutdown and
it was an -utter mess-.  Christoph and I spent a lot of time years
ago fixing the shutdown mess by moving to a model where the current
holder of an item is responsible for releasing that item when a
shutdown is detected. That included xfs_trans_commit().

This change of shutdown processing model was one of the reasons that
tests like generic/388 (and other fstress+shutdown tests) are
largely reliable now - they don't crash, hang, leak or trigger UAF
errors all the time like they used to. Shutdown reliability used to
be -horrible-.

Hence I really don't want to see us moving back towards a "cleanup is
somebody else's future problem" model, regardless of whether it
works in this case or not, because it's proven to be a broken model.

It's probably obvious by now that racing shutdowns with cancelling
dirty transaction safely isn't a simple problem.  That's why I said
"I have no idea what the right way to fix this is yet" - I didn't
have time to write a long, long email explaining all this.

I -think- that the ->iop_shutdown() mechanism I described to
Christoph recently can be applied here, too. That provided a
mechanism for the AIL push to be able to process items safely once a
shutdown had been detected, and I think it applies equally here.
i.e. we know the log has been shut down, and so we need to error out
the dirty log items via IO error mechanisms rather than simply
aborting the log items and hoping everyone notices that it's been
aborted....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
