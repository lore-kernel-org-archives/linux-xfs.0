Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA848270578;
	Mon, 16 Jun 2025 09:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750067235; cv=none; b=vBxd6YjKs3/duutH4G0eglOUH2Z8MvuwKgAYzQ2NdJUeWlAqBeYXM1dX1Is48rIJslJVA5WutL8BV7JoG6jfI9Fgd7KcnRBXOMSDYMuLT4Q3HFX7EK27KtInURN06yJSzV0cqATmKxkjkl3XtbgYxos4xlr/i1ElWscoZNZ1cnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750067235; c=relaxed/simple;
	bh=6xftlkboyoW+eazFcj10A9ntxCDyIkYjx/4Xxk3yE/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gS/Xji67i6PKbDSuP97DE1br6N4mR66uL7xgsD/mUajM86CPWnPHgc0JHT2wO0y3mY2rvmZnIzQTRGlnhbP8Zvp1GFPM9O2nv4hgmihyDqTECx9uU7T9m0/G9rkc64nRAG+uyJNiolV8gCIazR1SiegxoLidkKsXGoeJ3TtqizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDMgELmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDMgELmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1467EC4CEEA;
	Mon, 16 Jun 2025 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750067234;
	bh=6xftlkboyoW+eazFcj10A9ntxCDyIkYjx/4Xxk3yE/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EDMgELmxrXpAn2X7Ezql1YW5au4fDrHctsEZiD+Maick38sIs8jMqOu/si0YuRQsL
	 R4sjdaWFV9Xkl10dyrbqnn3TgolhcJegepYJ2+6o5TWg9xtQPOePtoIhIOcG85yo6N
	 5oyE8pqBAwPiwnI9HJsg8hUAzt3c0XsackTTwJM4yg294DgV8WQlv59sD2js2Yc5RJ
	 b+j+VZhEJy0HhCP1MS/qT921EHKZpZBLVTA52dJ+g8ig754MXkgxIONL1+Rhid61K3
	 KclRg4de9A6agyTdijFsKW3dKwdgF++XVDhs5XWarOlAVTRL8nPtQn8wW6ku/jXX9G
	 sNhzKnV7CPehg==
Date: Mon, 16 Jun 2025 11:47:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christian Theune <ct@flyingcircus.io>
Cc: stable@vger.kernel.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, regressions@lists.linux.dev
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
Message-ID: <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
References: <M1JxD6k5Sdxnq-pztTdv_FZwURA8AaT9qWNFUYGCmhiTRQFESfH7xqdOqQjz-oKQiin8pQckoNhfNyCHu-cxEQ==@protonmail.internalid>
 <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
 <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
 <Z9Ih4yZoepxhmmH5Jrd1bCz35l6iPh5g2J61q2NR7loEdQb_aRquKdD1xLaE_5SPMlkBM8zLdVfdPvvKuNBrGQ==@protonmail.internalid>
 <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>

On Mon, Jun 16, 2025 at 10:59:34AM +0200, Christian Theune wrote:
> 
> 
> > On 16. Jun 2025, at 10:50, Carlos Maiolino <cem@kernel.org> wrote:
> >
> > On Thu, Jun 12, 2025 at 03:37:10PM +0200, Christian Theune wrote:
> >> Hi,
> >>
> >> in the last week, after updating to 6.6.92, we’ve encountered a number of VMs reporting temporarily hung tasks blocking the whole system for a few minutes. They unblock by themselves and have similar tracebacks.
> >>
> >> The IO PSIs show 100% pressure for that time, but the underlying devices are still processing read and write IO (well within their capacity). I’ve eliminated the underlying storage (Ceph) as the source of problems as I couldn’t find any latency outliers or significant queuing during that time.
> >>
> >> I’ve seen somewhat similar reports on 6.6.88 and 6.6.77, but those might have been different outliers.
> >>
> >> I’m attaching 3 logs - my intuition and the data so far leads me to consider this might be a kernel bug. I haven’t found a way to reproduce this, yet.
> >
> > From a first glance, these machines are struggling because IO contention as you
> > mentioned, more often than not they seem to be stalling waiting for log space to
> > be freed, so any operation in the FS gets throttled while the journal isn't
> > written back. If you have a small enough journal it will need to issue IO often
> > enough to cause IO contention. So, I'd point it to a slow storage or small
> > enough log area (or both).
> 
> Yeah, my current analysis didn’t show any storage performance issues. I’ll revisit this once more to make sure I’m not missing anything. We’ve previously had issues in this area that turned out to be kernel bugs. We didn’t change anything regarding journal sizes and only a recent kernel upgrade seemed to be relevant.

You mentioned you saw PSI showing a huge pressure ration, during the time, which
might be generated by the journal writeback and giving it's a SYNC write, IOs
will stall if your storage can't write it fast enough. IIRC, most of the threads
from the logs you shared were waiting for log space to be able to continue,
which causes the log to flush things to disk and of course increase IO usage.
If your storage can't handle these IO bursts, then you'll get the stalls you're
seeing.
I am not discarding a possibility you are hitting a bug here, but it so far
seems your storage is not being able to service IOs fast enough to avoid such IO
stalls, or something else throttling IOs, XFS seems just the victim.

Can you share the xfs_info of one of these filesystems? I'm curious about the FS
geometry.

> 
> > There has been a few improvements though during Linux 6.9 on the log performance,
> > but I can't tell if you have any of those improvements around.
> > I'd suggest you trying to run a newer upstream kernel, otherwise you'll get very
> > limited support from the upstream community. If you can't, I'd suggest you
> > reporting this issue to your vendor, so they can track what you are/are not
> > using in your current kernel.
> 
> Yeah, we’ve started upgrading selected/affected projects to 6.12, to see whether this improves things.

Good enough.

> 
> > FWIW, I'm not sure if NixOS uses linux-stable kernels or not. If that's the
> > case, running a newer kernel suggestion is still valid.
> 
> We’re running the NixOS mainline versions which are very vanilla. There are very very 4 small patches that only fix up things around building and binary paths for helpers to call to adapt them to the nix environment.

I see. There were some improvements in the newer versions, so if you can rule
out any possibly fixed bug is worth it.


> 
> Christian
> 
> 
> --
> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> Flying Circus Internet Operations GmbH · https://flyingcircus.io
> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
> 
> 
