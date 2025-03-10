Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEDFA930;
	Mon, 10 Mar 2025 13:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612663; cv=none; b=ffqpFd4f12fRmOvnOZZyyDxhRYBT782uhY8dM5r/sl6FoPeLBCtWMyZNfBwsDZz81KdrDP2trMl825jDpCZEihcvNhVjrbb48iNTqhYS2ROoyJM3IF97wmVy0tihiG+gHnMY1I9w+3yn8h+IBVZU3q3Eps1QyOFTahqoGnn6jBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612663; c=relaxed/simple;
	bh=D4ThZR3jOk0y/K5Wa32G2qe5CNpAq9YoiQUxj3GtUtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2yuDUuyU3JdYQ8fAexnoU0SdcHItTYXnsxHzbnuX5ahYGbox23JNdF5ZNeAWHS25idb7g+/K9FkhPhVG5TowzeanAibK5k3zMWv2VrfAFTXV4YLOVzfbc3lR2KVtbN+ZRk66DRE/Tv7A+GdG3mGb9+GtGqKPzQ2nIK/XnnlDyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FuN1v38g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuN1v38g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A097BC4CEE5;
	Mon, 10 Mar 2025 13:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741612662;
	bh=D4ThZR3jOk0y/K5Wa32G2qe5CNpAq9YoiQUxj3GtUtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FuN1v38gbxiyLJTAddq+jPOChcbi2gv3rO59J3QhrQg2EgEOGCzL/jrvZqdkFgCjP
	 sG4bhuXx7F1C1pMbq1BsHdOK3jKtcEDEipxrIIulAzriYpMt6iBOCk+0WWSR9J23X0
	 Bk1NsuQEHTQ7j8hLYgK1GD6WtFuJ7DYTFBrVN/GnX//E/XQoG4nuaM3qCb4he5Ylzj
	 m2nmDAD1s2hRatjxaX/BrFqgUiGzQ5KGEBpibUps/hTqhbLC4iT690cAgwT/UuCMan
	 gxKG/AiLowxzcyzfF943lnFtQI2F07NktFXDgEbtcohvFjdoE3JWkPeAk4joj3jjAQ
	 bpp35+pVSzcsA==
Date: Mon, 10 Mar 2025 14:17:37 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: david@fromorbit.com, alexjlzheng@tencent.com, dchinner@redhat.com, 
	djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't allow log recover IO to be throttled
Message-ID: <67tqyedixro6clydwtp5y2ro6wnlr7fp4sfnpz33l4pf6oy4ir@6yr23tubzsjx>
References: <Z8YU-BYfB2SCwtW6@dread.disaster.area>
 <_ZfLT1KGyZTATXmYjqB5UWMekyyMj9vA74kup6rJl_QFrfD1mrV6h5qbes1b-pHbq95yM6dtQKek3uIce95VPg==@protonmail.internalid>
 <20250309124133.1453369-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250309124133.1453369-1-alexjlzheng@tencent.com>

On Sun, Mar 09, 2025 at 08:41:33PM +0800, Jinliang Zheng wrote:
> On Tue, 4 Mar 2025 07:45:44 +1100, Dave Chinner wrote:
> > On Mon, Mar 03, 2025 at 07:23:01PM +0800, Jinliang Zheng wrote:
> > > When recovering a large filesystem, avoid log recover IO being
> > > throttled by rq_qos_throttle().
> >
> > Why?
> >
> > The only writes to the journal during recovery are to clear stale
> > blocks - it's only a very small part of the IO that journal recovery
> > typically does. What problem happens when these writes are
> > throttled?
> 
> Sorry for the late reply, I was struggling with my work. :-(
> 
> Recently, we encountered the problem of xfs log IO being throttled in
> the Linux distribution version maintained by ourselves. To be more
> precise, it was indirectly throttled by the IO issued by the LVM layer.
> For details, see [1] please.

Ok, so you properly fixed the problem on the DM layer.

> 
> After this problem was solved, we naturally checked other related log
> IO paths, hoping that they would not be throttled by wbt_wait(), that
> is, we hoped that they would be marked with REQ_SYNC | REQ_IDLE.
> 
> For log recover IO, in the LVM scenario, we are not sure whether it
> will be affected by IO on other LVs on the same PV. In addition, we
> did not find any obvious side effects of this patch. An ounce of
> prevention is worth a pound of cure, and we think it is more
> appropriate to add REQ_IDLE here.

If you notice any problem with this that you're trying to fix, or if
this change improves anything, please specify that in the commit message
 - also addressing comments by Christoph, i.e. xfs_rw_bdev shouldn't be
messing with request ops - Just because it has no side-effects is not
a good reason. Regular Log IO being throttled by the DM layer is indeed
a problem, but considering the very small amount of data written here
during log recovery doesn't seem a good use of REQ_IDLE.

So, for now, NAK.

Carlos


> 
> Of course, if there is really a reason not to consider being throttled,
> please forgive me for disturbing you.
> 
> [1] https://lore.kernel.org/linux-xfs/20250220112014.3209940-1-alexjlzheng@tencent.com/
> 
> Thank you very much. :)
> Jinliang Zheng
> 
> >
> > -Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
