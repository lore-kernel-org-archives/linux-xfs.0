Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1070F61FCE;
	Wed,  5 Aug 2026 01:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785894297; cv=none; b=QIrJu395i1YNjezHjSS4Q8qxQ/A1Y/Ei9qCGkFkl7/RI/R4J/1VGubtyd7bd775sQKZddlvJjgqp9mb4Amv5wtZduZRvKr5HuELfCVg0G51mYYYs8Sdtx1Zl0iBO/Q2VPE/GG5Cx4u+5cH5623CuB84TatXyYfzyFc11gD41fk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785894297; c=relaxed/simple;
	bh=WvDd/w2UvdTtO1WTEshn5N9hYZQnwdmZ29yPG0sWUkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WrKjQMgoxH5wiIEG0jyxT9psQFaljuyk/qhO5qOxYapjnTCNrYYeDecV/iKOtijH9ORar6yNAu8tSkpBDK/XP2gV+udq6j9JUpWBLZ/o38GmNZX1NM5Xetvlx3aRJp7JbEcjL5m7bJqpHFovmyZUtmVgaut0WqRLmM0m/ab9io8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYrE2D0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYrE2D0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177941F000E9;
	Wed,  5 Aug 2026 01:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785894295;
	bh=qsAqHIwO7ce8+U1oKpXmq/u+9CG5d4YaaVjIOWHPKqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZYrE2D0Er1uBJ5VgnpWlvdVINGGWcINCsgwbGu2AVjKPbipUwips2bKym8BzfKwvw
	 5igbU2nGA7M4G5SYJSum0D/2hQXNrWjauWky+ruS+4LlWm67uNKjoeGNBZywhaAPbE
	 NSFyc5wjK2TcUXKeYr2xrISjBj9leepKwg5sQWGbRPLRTWjVcB8CtZperM5txeuGUj
	 stANbDPXa3UgpVr29l+ASMxnRM2gVNaoeroO1nuxsY9O4SpoQP/NChdJWBBPEuVjg/
	 U7FIYIgV9YkmRGma0wQvLI5PoXstyCS0pqM3Bse2e5iKCb05gt8eT64TjrllC6/3gZ
	 CE6zgyeXJSauQ==
Date: Wed, 5 Aug 2026 11:44:46 +1000
From: Dave Chinner <dgc@kernel.org>
To: Marcelo Mendes Spessoto Junior <marcelomspessoto@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: add guard before freeing buffer log item
Message-ID: <anKVjuBlmywjF37P@dread>
References: <20260731061448.192010-1-marcelomspessoto@gmail.com>
 <am0r_JImI8qE_TDZ@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <am0r_JImI8qE_TDZ@dread>

On Sat, Aug 01, 2026 at 09:13:00AM +1000, Dave Chinner wrote:
> On Fri, Jul 31, 2026 at 03:14:48AM -0300, Marcelo Mendes Spessoto Junior wrote:
> > A buffer's write completion can race with the CIL walking the same
> > checkpoint's item list during a forced shutdown's simulated commit
> > callbacks. Whichever side reaches the item last should be the one to
> > free it; right now completion frees it unconditionally, so the CIL
> > walk can end up touching memory that's already gone.
> > 
> > Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
> > Reported-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=4e6ee73c0ae4b6e8753f
> > Tested-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
> > Signed-off-by: Marcelo Mendes Spessoto Junior <marcelomspessoto@gmail.com>
> > ---
> >  fs/xfs/xfs_buf_item.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index f4c5be67826e..c86c4387f52b 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -1072,6 +1072,9 @@ void
> >  xfs_buf_item_done(
> >  	struct xfs_buf		*bp)
> >  {
> > +	if (atomic_read(&bp->b_log_item->bli_refcount) != 0)
> > +		return;
> 
> No.
> 
> My conclusion to the original syzbot report was:
> 
> | As such, I think that the issue we need to understand here is why a
> | write IO completion is being run from read IO context. That's the
> | root cause of the UAF, not the commit the bisect landed on....
> 
> And if you look at what I posted yesterday about a different hack to
> this same code:
> 
> https://lore.kernel.org/linux-xfs/amvI_rVUlifIXoZA@dread/
> 
> which "fixes" a UAF in the CIL code reported by KASAN under syzbot
> conditions. Whilst the syzbot report quoted was different:
> 
> https://syzkaller.appspot.com/bug?extid=598a791b31c498b63c6b
> 
> The syzbot report indicates exactly the same UAF situation - a write
> IO completion being run from a read IO context causing the BLI to be
> freed incorrectly and then the CIL access to the BLI triggering a
> UAF.  My conclusion to that one is:
> 
> | Given that syzbot has only reported this 5 times in 12 hours only on
> | a 7.1-rc3 kernel, never before and never since, an external memory
> | corruption bug that has since been fixed seems like the most like
> | cause here.
> 
> All the recent reports of this issue (the cluster in mid May) are
> also only from v7.1-rc3 kernels....
> 
> So, yeah, people really need to stop trying to hack "fixes" into
> xfs_buf_item_done(). The UAF indicates that there has been an
> -incorrect free of the item- during IO completion. That's the issue
> that needs to be understood and fixed. Fundamentally breaking the
> refcounting model of the BLI to silence the downstream UAF that
> results from the incorrect free is not an acceptible solution.

I could of followup thoughts. If the problem is that XBF_READ is not
set when we expect it, we should probably try to catch a buffer that
has neither XBF_READ or XBF_WRITE set at completion time. That would
be a clear sign of external memory corruption, and so we could log
an error, dump the state of the xfs_buf around the b_flags field to
discover if it's just a b_flags issue or a larger corruption. We can
then error out the IO without assuming that it is a WRITE IO, and
let the caller handle it appropriately.

In this situation, if neither READ nor WRITE is set, we'll get the
above debug. If we a completion where WRITE is set instead of READ,
we'll get this same UAF report again.

We probably should check for any flag fields that should not be seen
in IO completion are set (either unknown bits or bits that should
never be seen at completion like XBF_TRYLOCK), that way we'd also
capture corruptions that don't change READ/WRITE completions that
trigger the UAF.

That will tell us more about what is going wrong here and hopefully
help us isolate a potential cause...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
