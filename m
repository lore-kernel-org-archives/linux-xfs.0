Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0237738CFE8;
	Sun, 13 Sep 2026 23:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789343381; cv=none; b=u1W1C21ByNos2Mc0M0GkfV6ogFodlIZJt92Qf+CaTwPyXMHP2jGIyTsJxmKXAyKzva6giFkRvc8c25eBdjUMY1+s4sfuTIeR5QAl7Wmyv1yDyZnKxO8JGPrESUiGFZ7Nv5rZFb861egZZsJ/fJhZsMB/IRyOiPgmOEPW3CDGAKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789343381; c=relaxed/simple;
	bh=2gIVsqYlD3RbA81DQENcb6ETDNa+QTUtPsbIxQbZXR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMyZVqE3jFbzdL+hJtn4hYL7A+ihiOrTXkiFbBffj0MunmDOQWOTiQgQr1oAbNhT93xusPzj23pbaESqfZSCOUCOgAfU9DohZmVMoOH+GFKtPNnSiw2g0N6iJTOqI6Isok1Kmi2zH2s8zrMyArN0octOV0gQE2Rmv422xwQh5hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0kBSPGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0kBSPGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5941F000FF;
	Sun, 13 Sep 2026 23:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789343379;
	bh=x8fOrj6wzOOxNgJeLcwyT2n7DSBIHsT0BqcGuuPnDPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P0kBSPGQLxPc2XuVV6q4lG2oCxbQ8i+MhWGDvThKo1mM3DEOYlErrQGAmrr6/E0EY
	 wT3Oym+t9/WE3SEqkmZ4rle4JAjst/l1yNoiOFxNIk+0B3E4BzwL+Mr8p4Wke2tOy6
	 X48n3GMqTYCaCVNP0ZCq3VLV1Pxkv98gT2Z/qpoLpjCXN/ein5fcnSMBp0Z+PIQWB8
	 5QTXs0R1JorESYUu4ZKut/tBSYdswvyqorcZAsC9wvjwtvfWY4DWL8Pt4RcWMNCWL9
	 Iyk+gNBn0qviS3C2M6EfUXuuEmGfFEzCBtcFFEEDIxCU1RdNUPCSFlZ6M6Ck5LjtGs
	 Kl8k5RyRxRTBg==
Date: Mon, 14 Sep 2026 09:49:30 +1000
From: Dave Chinner <dgc@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chandan Babu R <chandanrlinux@gmail.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Xiang Mei <xmei5@asu.edu>, co+af981e62f5c7171a@bugs.sh,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: validate buffer log item before reordering
Message-ID: <aqc2igMKBhpiEeSp@dread>
References: <20260913114528.842015-3-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913114528.842015-3-bestswngs@gmail.com>

On Sun, Sep 13, 2026 at 07:45:30PM +0800, Weiming Shi wrote:
> Log recovery reorders transaction items before buffer item pass1 validates
> the format of region 0.  A corrupt log can therefore supply a four-byte
> region containing only blf_type and blf_size.  xlog_recover_buf_reorder()
> then reads blf_flags immediately past the allocation:
> 
>   BUG: KASAN: slab-out-of-bounds in xlog_recover_buf_reorder
>   Read of size 2 at addr ffff88800e40e364 by task poc/133
>   Call Trace:
>    kasan_report mm/kasan/report.c:595
>    xlog_recover_buf_reorder fs/xfs/xfs_buf_item_recover.c:164
>    xlog_recover_reorder_trans fs/xfs/xfs_log_recover.c:1929
>    xlog_recover_commit_trans fs/xfs/xfs_log_recover.c:2053
>    xlog_recovery_process_trans fs/xfs/xfs_log_recover.c:2319
>    xlog_recover_process_data fs/xfs/xfs_log_recover.c:2510
>    xlog_do_recovery_pass fs/xfs/xfs_log_recover.c:3253
>    xlog_do_log_recovery fs/xfs/xfs_log_recover.c:3340
>    xlog_do_recover fs/xfs/xfs_log_recover.c:3377
>    xlog_recover fs/xfs/xfs_log_recover.c:3502
>    xfs_log_mount fs/xfs/xfs_log.c:617
>    xfs_mountfs fs/xfs/xfs_mount.c:1031
>   The buggy address is located 0 bytes to the right of
>   allocated 4-byte region [ffff88800e40e360, ffff88800e40e364)
> 
> Validate region 0 before inspecting the flags.  Keep a malformed item on
> the regular item list so that xlog_recover_buf_commit_pass1() reports the
> corrupt log through the existing error path.
> 
> Fixes: 86ffa471d9ce ("xfs: refactor log recovery item sorting into a generic dispatch structure")
> Reported-by: co+af981e62f5c7171a@bugs.sh
> Closes: https://lore.kernel.org/all/aqZALi7GdVprcNOh@cronus.toxiclabs.cc/
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>

That's pretty poor form - taking a bug reported by someone else and
then reposting their proposed fix as if it was your own before
they've even had a chance to respond to the maintainer's comments.

And that's even before I take into account that the proposed fix is
an extremely poor one. It basically punts the broken log item down
the road where some future processing operation happens to catch it
and abort journal recovery with EFSCORRUPTED before bad things
happen.

i.e. you didn't review it, nor did your directions to the LLM that
"helped" you direct it to determine if this was the right way to fix
this issue.

To compound this all, I've previously asked you directly to stop
sending patches that add random verification checks to random parts
of log recovery and instead spend time on actually addressing the
root cause of these issues.  i.e. that we lack robust on-disk format
verification of the journal contents.

Last week, when someone else posted a random 'log vector is broken'
hack, I said the same thing (yet again!) and posted the design doc I
wrote a while back to provide robust, generic log item validation
for the entire journal:

https://lore.kernel.org/linux-xfs/ap8ucHIw-pKLhh9c@dread/

I posted a link to the git repo where I've started this work further
down that discussion:

| Ok, I just posted my current WIP to the log-verification-1 branch
| in my kernel.org repo
| (https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git)

That's the work we need to do to get rid of -all- the journal
corruption issues in one go; once we have that in place then almost
all corruptions will be caught long before any of the recovery
parsing code can trip over it....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
