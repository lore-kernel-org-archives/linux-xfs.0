Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CC82DEA9D;
	Thu,  7 May 2026 03:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778125311; cv=none; b=ogcXCQnwcgpZca4maSToa/ITVwqvsLwzLggTANl3fJqm20eCE1mpnyIoqio6NnX8Qtpx/IocyT7sOhXsvS9SnhddkTYVspBUVnxfC4fOjUv/2nhCzO/XHsbNzCH4L3JDgkGSqvK/+f/IdcBwjLlUkUvMujAgZt+TMk/8gZ40S90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778125311; c=relaxed/simple;
	bh=niI1mHPQMkow15navbXpGEmZHA4rbW1FOl8ZQKL6Uoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VY9/bXJF6LUg2s1cGhmeBRLB+jnH7Y7mXN3fg0PGWHpSr+CSVlY04hMPLuco2nCpRXNrBGFcgSO7aFdbR6iMhNijbvwtY/Y9ulDocHTLef9IwRqwoV86kSxCc8JuhFNv/Hw+cotGIngZAZhXBi1+q7oInMHdwh24CRGrNb7ReTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rAU4bYSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rAU4bYSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC17C2BCB8;
	Thu,  7 May 2026 03:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778125310;
	bh=niI1mHPQMkow15navbXpGEmZHA4rbW1FOl8ZQKL6Uoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rAU4bYSQNC0jEuthP8oZ6486im5pQx53dsgd0QGgVP/oHf3MnrSIFNF1NxHEwbBEs
	 pRNNiuoCSOaL37e7cuL4KgTKkvrGiMwuJokb6dR6kRRWBnNF3uZ2IhTs9/rbU+IGth
	 knTAPu7yumByUZ79DMQWOnzYmT+yriy/XESD+lyL9kDv5hhGYqW8uPDNUrmPJeZydt
	 gVd4kbHYM/sEtxO5ZTRKQRkoIJHkVk3L+drLw51LFK/H+VezmdZF9G51jrim3NTWSW
	 pxjVscOTqMZdk30zjDXVT8QLjIx3UN9JYzbleehzvslD8DKwUx2VsUsNJiKWt/Mj0D
	 iEh0d3aKTxZbA==
Date: Thu, 7 May 2026 13:41:45 +1000
From: Dave Chinner <dgc@kernel.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com
Subject: Re: [PATCH] xfs: snapshot current CIL sequence under xc_push_lock
Message-ID: <afwJ-eNE-NbSjRU6@dread>
References: <20260506015811.3420895-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506015811.3420895-1-zzzccc427@gmail.com>

On Wed, May 06, 2026 at 09:58:11AM +0800, Cen Zhang wrote:
> xlog_cil_force() and xlog_cil_flush() both use the current CIL
> checkpoint sequence to request an immediate push.  They currently read
> xc_current_sequence before xlog_cil_push_now() takes xc_push_lock.
> 
> The CIL push worker advances xc_current_sequence under xc_push_lock while
> switching to a new checkpoint context.  If a current-checkpoint force reads
> an old sequence and then publishes it as xc_push_seq after the worker has
> moved to the next context, xlog_cil_push_work() can treat the request as a
> previously pushed sequence and skip it via the push_seq < ctx->sequence
> check.  That can leave the current dirty checkpoint unqueued by a
> force/flush request.

Which does not matter at all.

Integrity in XFS is defined by completion-to-submission semantics.
IOWs, the only thing that a CIL -force- guarantees is that it will
ensure the current CIL context containing fully completed
transactions when it is called.

See, for example, __xfs_trans_commit() -> xfs_log_force() for
XFS_TRANS_SYNC transactions.

So if xlog_cil_force() races with a push switching to a new sequence
number, it means that all the transactions that were completed at
the time xfs_log_force() was called are -already being pushed-.
Hence all we need to do is wait for the CIL context at that sequence
to be committed. The new sequence number, by definition, contains
modifications that completed -after- the log force was started, and
so are outside the scope of the current force operation.

IOWs, we can safely skip the new sequence number in teh case of a
push/force race, and the force will still correctly wait on the old
sequence number being forced to disk. The race is benign, and not a
bug.

As for xlog_cil_flush(), it is a latency reduction mechanism and not
a integrity mechanism. We just don't care about racing, because the
caller will call it again if sufficient progress wasn't made by the
previous call.

Hence I don't think there is a bug that needs fixing here. Yes, the
fact that deducing it is ok requires understanding
competion-to-submission integrity semantics, but that's kinda
assumed knowledge because it's exactly the same semantics as we
relyon for data/metadata ordering and integrity w/ O_SYNC/O_DSYNC
operations...

> Make xlog_cil_push_now() resolve push_seq == 0 to the current sequence
> while holding xc_push_lock, and return the resolved sequence for tracing
> and waiting.  Route xlog_cil_force() and xlog_cil_flush() through that path
> so the current-sequence snapshot and xc_push_seq publication are serialized
> with the context switch.

So the change is likely correct, but somewhat nasty in places.
Regardless, I'm inclined to reject it based on "if it isn't broken,
don't fix it" principles.

In future, when reporting problems and fixes like this, it is very
important that you say how the issue was found, whether it can be
reproduced, hardware configs, etc. Presenting multiple fixes in a
short period for a wide variety of different conditions in extremely
complex code without any context of how/when they occur or what
impact they have on systems smells like AI slop more than
anything....

So, please document what tools/AI are you using to find these
problems and how they can be reproduced. I haven't commented on the
other two "fixes" you've just posted because I haven't got hours to
dig into them right now. You also posted a fix a month ago for a
race condition that wasn't a race condition in buf log item
handling, so something is clearly directing you at them....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
