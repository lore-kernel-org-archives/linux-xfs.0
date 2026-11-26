Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795715235;
	b=tCC/thJG76iam29TdpHQu5tMvxNHo8OvIP4en2u02w7GbrX3xSpw0oxBokGL2xhIJ5PF
	 kMGRGNLnVRMJuhzH4tlAA3J5HRX6g8PbNQ8uXVjuLcAwK3dRwSGr36Le0eUwiA9Ka1HTl
	 H6VE/MbSx+ZKwsLzyW5cu9k7P9K8RJOkCobpVTNqGvdwEjySwBQOwwf1PcFmroUja5Eld
	 MBHI3xG8v0lFW/maoc7AxJ5zr9aohbCE5yrUCUdEquu1mpVlORQFDcm4EqimMc5h64ELb
	 yavzW0HVwYF9zfrAAgO3TBHWi/AUshq58yhGaIG+7EzlvHcsAEJocoSYmdDMcP3ObBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795715235;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=P/p4Fos2VdTfqDjhiDwK+qi02GsrZrGfewpFHvSGFqY=;
	b=wtMMvQxdjsJTkjCnaqSpX7tESkLu6+fk0+Nf96aK0CBKQO7u7wOLxjjFKWHXAGiytnfo
	 kUNWNyrVwWgRGvJQSKV1hDdx/bn/2enuVam8ZVo6Vqdp6f55z4g77NxNWXrprtEmdtGTw
	 ffNCY2DPwUR+o9BZr6SrNAYYb3nU0nti9MEGnwg+H2vA0KR+8JiBWhab1Nw+cPjG66trP
	 oDbELSNZl3dTM4A7iJQlb+2THrYKcgXEPbBEQSV0w/uB0L/ubBS0RvdKlF/qJpo/4g+bO
	 Feq5QN5ju8x7j5Iky/Vncl++k5PSnDqUdG7Q4l/PjKMikhAJk7h6rUulRI2/8jf9Ahg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DwuFVv3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E269606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 17:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DwuFVv3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F1C1F000C0;
	Thu, 26 Nov 2026 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795715234;
	bh=P/p4Fos2VdTfqDjhiDwK+qi02GsrZrGfewpFHvSGFqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DwuFVv3YOItRmokYxlrV7bZ5SSzP+Upbz6jFO1Oxvs6p3TzCX1XGmPQAOg/DFTJBb
	 nnxOxzvCadFAsOKca3QsU8YXBDWolLmBKeYrPHleWiHHEZ7ha276iu2Iihp+VVyeMn
	 qHBQQfSkoKaj164VuwDRe1iqAnhPCEaHUDMPavQ+pZM4LuMOs1XcrJG89sX2aXyzj5
	 dXKITQr7csRZ0EznU7ZVrZhUATIB/DXtlWKjFDZRP0zx2RO0BQGhHSOPi9BdDTD3SR
	 z+cqpWuBRZe1kSk4bMCyxZuRJW7ZmrdXELVkWg3fuW19uLFD/rudHK58I44PDCc7li
	 8S32tzjZs79mQ==
Date: Thu, 26 Nov 2026 18:47:09 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>, Jeffin Philip <jeffinphilip14@gmail.com>,
	linux-xfs@vger.kernel.org,
	syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com,
	syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com,
	syzbot+a4fde844548510369112@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: wait for buffer unpinning before shutdown completion
Message-ID: <awhwnU05NYWsRm4A@cronus.toxiclabs.cc>
References: <20261126164604.158012-1-parri.andrea@gmail.com>
 <awhtipqpIxxUgyjj@cronus.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awhtipqpIxxUgyjj@cronus.toxiclabs.cc>

On Thu, Nov 26, 2026 at 06:34:08PM +0100, cem@cronus.toxiclabs.cc wrote:
> On Thu, Nov 26, 2026 at 05:46:02PM +0100, Andrea Parri wrote:
> > Changing an XFS filesystem label while forcing log shutdown can trigger a
> > use-after-free in the CIL push worker, as reported by syzbot:
> 
> I *think* Dave is already working on a proper fix for this on his
> series, so I'll wait for him to look into this as I didn't have time to
> go through his series yet.
> 
> Besides that...
> 
> > OpenAI Codex analyzed the reports, implemented the suggested change,
> > drafted this changelog, and ran the tests described above.  Claude Code
> > reviewed the change and revised this changelog.
> 
> LLMs references should stay away from commit messages. Doesn't matter
> what tool you used, the code is still your responsibility.

woops, sorry the bonker email headers.... Different machine,
misconfigured MUA...

> 
> > 
> > Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
> > Cc: stable@vger.kernel.org
> > Reported-by: syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=c32ff62cf4913d345d0c
> > Reported-by: syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=9d8e687768d0f38c1f09
> > Reported-by: syzbot+a4fde844548510369112@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=a4fde844548510369112
> > Suggested-by: Dave Chinner <dgc@kernel.org>
> > Link: https://lore.kernel.org/aqI6v-_dc2DDSbgB@dread
> > Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> > ---
> > 
> > Jeffin, Cc'ing you because this touches the BLI lifetime that your log
> > item reference counting conversion reworks.  This is the short-term
> > xfs_buf_submit() fix Dave described in the thread linked above.  It is
> > meant to be small enough to backport and does not replace that work.
> > 
> > Processing of emailed #syz test commands is currently disabled (see
> > https://github.com/google/syzkaller/issues/8122), so the functional test
> > results come only from local runs of syzbot's C reproducer.  Three later
> > 10-minute runs of the unpatched kernel did not reproduce the UAF, so the
> > 191-second fixed-kernel run provides only weak evidence that the race is
> > fixed.
> > 
> >  fs/xfs/xfs_buf.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 6c93b4f5629c1..4acd0c3451da9 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1382,6 +1382,9 @@ xfs_buf_submit(
> >  
> >  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
> >  
> > +	if (bp->b_flags & XBF_WRITE)
> > +		xfs_buf_wait_unpin(bp);
> > +
> >  	/*
> >  	 * On log shutdown we stale and complete the buffer immediately. We can
> >  	 * be called to read the superblock before the log has been set up, so
> > @@ -1402,9 +1405,6 @@ xfs_buf_submit(
> >  		goto ioerror;
> >  	}
> >  
> > -	if (bp->b_flags & XBF_WRITE)
> > -		xfs_buf_wait_unpin(bp);
> > -
> >  	/*
> >  	 * Make sure we capture only current IO errors rather than stale errors
> >  	 * left over from previous use of the buffer (e.g. failed readahead).
> > -- 
> > 2.53.0
> > 
