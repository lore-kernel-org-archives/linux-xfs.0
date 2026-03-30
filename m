Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EF434AB19;
	Mon, 30 Mar 2026 20:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774903542; cv=none; b=MxZ7CuU9qF9JMBZVrafMYxoeFx8Bt1V77TFw8bDBaWURnos90tvCX6QBdJIKZEw7jmS88Ypxqlp1Gvpvo8JwRDml3vsz9dx4/f7Fi8k+1+GkFcq/GkZZ3hHlQBCIQrJwf31W6joc1s+E9M6OESD31TNg3aHYE8Iuh8b91XD4UpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774903542; c=relaxed/simple;
	bh=HMgpde4EH45cuHT2qmv4PBoDBp5xozGkRli4Usm7r4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gfo8eNA/OU8xzN1iFgA26LWjdZ4pcC0L5xntaA1jK1eb/WNh7BMoffEpuGTMpKvZVO3rKy7jluUwedWIqG9p5JOqutlTNBLPr7FMcxDjOZhaMRKT98Wa/oXZbR1tOe8pzrua3g7Ev623ZKcNbzHwNX7erNeAcSvynydlVYUk74M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6pkB5A3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6pkB5A3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ADDC4CEF7;
	Mon, 30 Mar 2026 20:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774903542;
	bh=HMgpde4EH45cuHT2qmv4PBoDBp5xozGkRli4Usm7r4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j6pkB5A3nH6FFWViMv8wW+sJW4LQnAAjTsQLR1WizO9Y1SQvTt4ETpezXTX6xyM8D
	 6q7kR3hMNZFT9ZtExdxy/FEihKjaJuIBi0XCSzUP0RfE+0dulkYrKxS2fzoZ2zHT/h
	 WKiWHUdm7CqbYMHLDTJF/6KzAi5OxXlyfMAfghIJQgsftFAq/R+YhN5FHu8vqFLJHl
	 iQy7lEE4qe11ZG8pTaySetfxjGk2t9Ysxwh93flsbGTORz3K8bKqkDgl0EQVSPBmX9
	 PfEmGJ+FcjH7W1Y6A5vsDwMHlQZ/E4SkmKstlOXY38Ex+nM8bMhwk4ribuVX+mlq0A
	 jhRjnu4+OYPnw==
Date: Tue, 31 Mar 2026 07:45:31 +1100
From: Dave Chinner <dgc@kernel.org>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: cem@kernel.org, dchinner@redhat.com, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] xfs: avoid inodegc worker flush deadlock
Message-ID: <acrg64yzAbgb8jte@dread>
References: <20260328071252.3936506-1-gality369@gmail.com>
 <acnUybgMAsBA9IEc@dread>
 <CAOmEq9Vx_sJf1PbD_SFdRyKb+u+kRR8_BPJ_+Ms4tdD895-cVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOmEq9Vx_sJf1PbD_SFdRyKb+u+kRR8_BPJ_+Ms4tdD895-cVg@mail.gmail.com>

On Mon, Mar 30, 2026 at 10:40:13AM +0800, ZhengYuan Huang wrote:
> On Mon, Mar 30, 2026 at 9:41 AM Dave Chinner <dgc@kernel.org> wrote:
> > How did the filesystem get to ENOSPC when freeing an inode?
> > That should not happen, so can you please describe what the system
> > was doing to trip over this issue?
> >
> > i.e. the problem that needs to be understood and fixed here is
> > "freeing an inode should never see ENOSPC", not "inodegc should not
> > recurse"...
> 
> Thanks for the reply.
> 
> This issue was found by our fuzzing tool, and we are still working on
> a reliable reproducer.

Is this some new custom fuzzer tool, or just another private syzbot
instance?

More importantly: this is not a failure that anyone is likely to see
in production systems, right?

> From the logs we have so far, it appears that the filesystem may
> already be falling back to m_finobt_nores during mount, before the
> later inodegc/ifree path is reached.

Which means ifree would have dipped into the reserve block pool
because when mp->m_finobt_nores is set, we use XFS_TRANS_RESERVE for
the ifree transaction reservation.

> In particular, we observe
> repeated per-AG reservation failures during mount, followed by:
> 
> ENOSPC reserving per-AG metadata pool, log recovery may fail.

This error doesn't occur in isolation - what other errors were
reported?

Please post the entire log output from the start of the mount to the
actual reported failure. That way we know the same things as you do,
and can make more informed comments about the error rather than
having to rely on what you think is relevant.

> Based on the current code, my understanding is that when
> xfs_fs_reserve_ag_blocks fails, XFS can continue mounting in the
> degraded m_finobt_nores mode. In this state, xfs_inactive_ifree may
> later take the explicit reservation path, which seems like a plausible
> way for ifree to encounter ENOSPC.

The nores path sets XFS_TRANS_RESERVE, allowing it to dip into the
global reserve blocks pool to avoid ENOSPC in most situations.
However, if it gets ENOSPC, that means the reserve block pool is
empty, and whatever corruption the fuzzer introduced has produced
a filesystem that has zero space available to run transactions that
log recovery needs to run.

IOWs, if the fs is at ENOSPC, and the reserve pool is also empty,
then we can't run unlinked inode recovery or replay intents because
the transaction reservations will ENOSPC.  If that's the case, then
we should be detecting the ENOSPC situation and aborting log
recovery rather than trying to recover and hitting random ENOSPC
failures part way through.

i.e. I'm trying to understand the cause of the ENOSPC issue, because
that will determine how we need to detect whatever on-disk
corruption the fuzzer created to trigger this issue.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
