Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAD810A23
	for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2024 01:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708564240; cv=none; b=B5JIw9xuxr2oSUv7TP/uDnp0dPCkx+HUqMcA1kQQrzps/glpAg5s8ivMtUjTdPgoiXwkaia03Cq8vz0we8/rcNFxdNyfWsBLKU8ZgJQZvHcYP73UVGPZ1HpWvL2Ob5VGgcZk/FmNwR3fc08141AFGgLRijikfe1untO4EjiSDV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708564240; c=relaxed/simple;
	bh=mqJ4qBnGRDaz8krsGrEl1dh9o1JLralzPSK1aNysSYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCFjNPybPLiNLSTNGV78lhMWC8q/iBEyHp4lmiuILkTNZnbNnim6lCnCZ57HJTkYhlWcdCcHOSJYsmu2n9ANaGxDdiLpxRn7kFX00T1Cg1OvtaLcUDKIFK6CH9bFZAiZeD8Cq+Yx/jMFBcfvN2dBoHDd4yabgTcm5EPprhlYzts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zF/mCLya; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zF/mCLya"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3c132695f1bso5553332b6e.2
        for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 17:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708564238; x=1709169038; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hVnwz53Zi0Rrh+TGF1mGKpXHgXjNFBWhRGZFBkFrWRg=;
        b=zF/mCLyawN43EWBeYvqt9dMFk7XyrSQV3uwEAtww1l8GGIWdIesVBHW31UTX9p1dO0
         5J548n5dgnEnPCfY5zm8aBJD7MFA81+niWaP560B3ov5BUN6xo3ivPH1hJgqqCRdIYIw
         jW2SnU0lFKK6HB6AzGTlgHZB3bf+1hOTSyyjOqKj5XRswmbDf1jUwcWjmaZk6lc5XMFv
         NAtnTEj9sVrm007j9RdvhzkIqRUwCqk3QiLuh7wwKSZcfUReR1Q4sum0znTesYNfLN99
         wp8Zb72WL59m4NRkRgf5PmE25a6/tbcSsV2q2XPXPyZk1WSAcNHevAHNmrgDQMrgzNdl
         /6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708564238; x=1709169038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hVnwz53Zi0Rrh+TGF1mGKpXHgXjNFBWhRGZFBkFrWRg=;
        b=J4QNwhNKltE456d4o64+3rV9r5d8lVB+p2ZCumDbAaktEauG4hIE6Z38XtXePSQQxE
         i6oCRKxrMqmuUaIuqQ5awYevMyC/+Lsco15G8c47w4vaQTQWQfp5c4N4dMg0OCq7DOEI
         ICkBHz1RSSrRWP+1KvNhOvZt2rAlTD3Z5gy6xZNRi7KuGUzyR0zT4yZTZdkncjaoclcj
         edx9/5Ls2BZ/Oh3rQ4S5ee30bSOZ92/wz2+8Vjywyg32uKwTlqgTKfUdUiCNTwpE41eR
         NYSX7gBCDM4JoAAgwZBF3kquhzBNfNEYVULexdJTQjpct43R/NkwhAHsqX9Qr5criwbE
         4IOA==
X-Gm-Message-State: AOJu0YwB3SBeVgbEwipA0UWrsYPTGTZHEwYqh6wlnx4RxfUwCJww6z/y
	MDr1ipsgxdVlw69yqbQybwzrrOPAjY+RrnMw3OziL50LyizASboSLYdsJr6pR3U=
X-Google-Smtp-Source: AGHT+IErbA3Nm9p7uD0XG4NV71CNmPDcdCiQCEFPe+vX5zw5/QHlsrBqs3720ZRwL5hXeXqOqWfugg==
X-Received: by 2002:a05:6808:1646:b0:3c1:3427:fef3 with SMTP id az6-20020a056808164600b003c13427fef3mr25476421oib.48.1708564237849;
        Wed, 21 Feb 2024 17:10:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id u41-20020a056a0009a900b006e47b5b67d1sm4243290pfg.77.2024.02.21.17.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 17:10:36 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcxbc-009kfu-1i;
	Thu, 22 Feb 2024 12:10:32 +1100
Date: Thu, 22 Feb 2024 12:10:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: don't use current->journal_info
Message-ID: <ZdafCN+mNecltZ1T@dread.disaster.area>
References: <20240221224723.112913-1-david@fromorbit.com>
 <20240221232536.GH616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221232536.GH616564@frogsfrogsfrogs>

On Wed, Feb 21, 2024 at 03:25:36PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 22, 2024 at 09:47:23AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > syzbot reported an ext4 panic during a page fault where found a
> > journal handle when it didn't expect to find one. The structure
> > it tripped over had a value of 'TRAN' in the first entry in the
> > structure, and that indicates it tripped over a struct xfs_trans
> > instead of a jbd2 handle.
> > 
> > The reason for this is that the page fault was taken during a
> > copy-out to a user buffer from an xfs bulkstat operation. XFS uses
> > an "empty" transaction context for bulkstat to do automated metadata
> > buffer cleanup, and so the transaction context is valid across the
> > copyout of the bulkstat info into the user buffer.
> > 
> > We are using empty transaction contexts like this in XFS in more
> > places to reduce the risk of failing to release objects we reference
> > during the operation, especially during error handling. Hence we
> > really need to ensure that we can take page faults from these
> > contexts without leaving landmines for the code processing the page
> > fault to trip over.
> > 
> > We really only use current->journal_info for a single warning check
> > in xfs_vm_writepages() to ensure we aren't doing writeback from a
> > transaction context. Writeback might need to do allocation, so it
> > can need to run transactions itself. Hence it's a debug check to
> > warn us that we've done something silly, and largely it is not all
> > that useful.
> > 
> > So let's just remove all the use of current->journal_info in XFS and
> > get rid of all the potential issues from nested contexts where
> > current->journal_info might get misused by another filesytsem
> > context.
> 
> I wonder if this is too much, though?

We ran XFS for 15+ years without setting current->journal_info, so I
don't see it as a necessary feature...

> Conceptually, I'd rather we set current->journal_info to some random
> number whenever we start a !NO_WRITECOUNT (aka a non-empty) transaction
> and clear it during transaction commit/cancel.  That way, *we* can catch
> the case where some other filesystem starts a transaction and
> accidentally bounces into an updating write fault inside XFS.

I could just leave the ASSERT(current->journal_info == NULL); in
xfs_trans_set_context() and we would catch that case. But, really,
having a page fault from some other filesystem bounce into XFS where
we then have to run a transaction isn't a bug at all.

The problem is purely that we now have two different contexts that
now think they own current->journal_info. IOWs, no filesystem can 
allow page faults while current->journal_info is set by the
filesystem because the page fault processing might use
current->journal_info itself.

If we end up with nested XFS transactions from a page fault whilst
holding an empty transaction, then it isn't an issue as the outer
transaction does not hold a log reservation. The only problem that
might occur is a deadlock if the page fault tries to take the same
locks the upper context holds, but that's not a problem that setting
current->journal_info would solve, anyway...

Hence if XFS doesn't use current->journal_info, then we just don't
care what context we are running the transaction in, above or below
the fault.

> That might be outweighed by the weird semantics of ext4 where the
> zeroness of journal_info changes its behavior in ways I don't want to
> understand.  Thoughts?

That's exactly the problem we're trying to avoid. Either we don't
allow faults in (empty) transaction context, or we don't use
current->journal_info. I prefer the latter as it gives us much more
implementation freedom with empty transaction contexts..

-Dave.
-- 
Dave Chinner
david@fromorbit.com
