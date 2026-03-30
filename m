Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AA740DFB3;
	Mon, 30 Mar 2026 00:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774831927; cv=none; b=LVa1/lB0DRxAab3IIixZEWr+5dvSVkgRRK6dVb00fBOaipRC3SmU+s9ha2cYKYGKf50EpoDFQk2Ymtua/lpzbWu7hB0b9jpWLbQT5RMEFAqiclA+/cEEegTsHdVTY34H51wZEFBKIqVoixPm/OX4XCv7SiIFjN4Zv4KRPvWSf+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774831927; c=relaxed/simple;
	bh=uKNz51piWVofToZhM+NFOqxREDaEtXG2Nv5b2OLoq9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVWL4eshM8sXlqBjMs9JvWKbtTl8fj+uUSuNk7VAwk0yNvsmOaF2UqAoR71v/+R9AgMkOFFbEFWhxA3TZ6YKD9vc+JXSy7PAqWMjIaUMY9t2SuUmjwlSo3duXBN+2VaGQ18ipZfsZLn16bGsS26TtaHbw/sEoSAJsa5qN84CqAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9M6QDaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9M6QDaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A12C116C6;
	Mon, 30 Mar 2026 00:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774831927;
	bh=uKNz51piWVofToZhM+NFOqxREDaEtXG2Nv5b2OLoq9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A9M6QDaVSp92RYm4lYeuWF+ypXxDtO+kGHCnVuQlUInt5OeUYs8gJw1PBA79chNNg
	 pCKLHwO+Lbx1OwbeSN8m/kf4CL9T8VTXOf9F3d/2KJ8jD7sgeNW6kFVdN0czfONHBl
	 7M43o/+OIkgKz+3Xc2EcB78//zMzQQaBnqL5jLBzE1GVNx6lw5yRAlg5erqEe5dWvx
	 MmKUbs31pdSZixXmSmV1BJKh4/C2G7UFckRptbU5OkF5ufhQdC/FL/aoocWkp7EXfz
	 3r6V+xFR5/gIQ6yuDcGkFzF4EAyqphPn/fXGJavyiqn28/2aLOmnPNtrPTELIYpXdj
	 zxMB7rqL1bvqg==
Date: Mon, 30 Mar 2026 11:52:02 +1100
From: Dave Chinner <dgc@kernel.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: annotate lockless b_flags read in xfs_buf_lock
Message-ID: <acnJMhFpp42bdW93@dread>
References: <20260327131152.155617-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327131152.155617-1-zzzccc427@gmail.com>

On Fri, Mar 27, 2026 at 09:11:52PM +0800, Cen Zhang wrote:
> xfs_buf_lock() reads bp->b_flags before acquiring the buffer semaphore
> to check whether a stale, pinned buffer needs a log force:
> 
>     if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
> 
> This races with xfs_trans_dirty_buf(), which modifies b_flags while
> the buffer is locked by a transaction on another CPU.
> 
> The pre-semaphore check is a performance hint: if a stale pinned
> buffer is detected, forcing the log avoids a long wait on the
> semaphore.  Either outcome of the race is benign -- a false positive
> triggers a harmless log force, and a false negative simply means the
> caller blocks on the semaphore and the log force happens later.
> 
> Annotate the lockless read with READ_ONCE().

No. READ_ONCE should not be used to annotate a benign data access
race. data_race() should be used because all it does is turn off
KASAN for that access, and unlike READ_ONCE(), there is no code
change when KASAN is not enabled.

But, in reality, the race condition here is more than just the
b_flags access.  There is a big comment above the function explaining what
the check does, and that the buffer pinned check that precedes the
b_flags check can race with journal completion, too. SO, if we lose
the race and trigger the log force, then nothing bad happens, and
latency is no worse than if we won the race and triggered a log
force.

IOWs, adding READ_ONCE() to these check doesn't actually "annotate"
anything useful or informative - it's not paired with WRITE_ONCE()
anywhere (nor would we want to be doing that), and so it's just a
random, uncommented macro in the code that makes things harder to
read.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
