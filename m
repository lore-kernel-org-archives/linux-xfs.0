Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0FE1EB5F8;
	Thu, 29 Jan 2026 23:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769728794; cv=none; b=HPnFl8ZbSvwGtnl+I4oZvG8e6Slv1x2nsIKCBxO8QVZe+4R+SJdfiDPwDkM2K4Y2IevnbHvFKRiNr9a8vPqfxWRHUN2wnrxjF0aCRP7iSDu1JRSkXPF1VRW+gvCXfkmLVpO7GIQEi5C7OB9D7wrR5qFxBsna20EW+OlqfwgbpPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769728794; c=relaxed/simple;
	bh=DtI+0fZJQ3y1FUzJFQxqLNbmAchuIrXCAiEqbuVJmLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKGMghZgYfc3GoA1PtFQkkYrtJA8UbWvsGgDO90PwH80YNIkQZ67jGLdTDivy03BfO7HXnoKsw+/pC3rGXbPInas9YOthPi4v28DLe8NcOQ66ewVoIw8GqvHwNAy4DpFxIq4o1lIPnOqAm/LGQtOFDq4fDnAE4UllJC+bPmyQps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIcvhCXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIcvhCXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C714DC4CEF7;
	Thu, 29 Jan 2026 23:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769728793;
	bh=DtI+0fZJQ3y1FUzJFQxqLNbmAchuIrXCAiEqbuVJmLo=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=FIcvhCXSACEtnOLnOZhl6juiDomgioyt/676sBKnptLcB5Uq4b1vhqMGGIL2rsAfS
	 4yoP8S7C6yY3audYUsguYjAB0haYZ2UICzifP8BRxvjXTUvrO1KSsZRj6wLlvuNdku
	 KF3eq6S/o5khuUyMHWM6lsR+wv9mtze/jRfmicUhlLofXX2T+jLe6e7panopI8Ho/9
	 35T+3Ypmb25uG7g4zIxebwtjPvourqo5WxdWTrEehWXayT8hmcZjr5+wRQ6zGd9vko
	 O5tKiGeRJUBzBKxsHuLpwelEdZJ/BVq2gIIka97k/XcVvW1I3b5pjpwL7WjWPBctSM
	 J7Nql2yZBZbMA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 3C0BFCE38E8; Thu, 29 Jan 2026 15:19:53 -0800 (PST)
Date: Thu, 29 Jan 2026 15:19:53 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Kunwu Chan <kunwu.chan@hotmail.com>,
	"rcu@vger.kernel.org" <rcu@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: rcu stalls during fstests runs for xfs
Message-ID: <c33c3d3e-a59c-4f5a-a562-13e2cabc2faf@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
 <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
 <aXrl46PxeHQSpYbX@shinmob>
 <13b25e07-d7b8-4b4e-a249-b6826b2eea39@paulmck-laptop>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13b25e07-d7b8-4b4e-a249-b6826b2eea39@paulmck-laptop>

On Thu, Jan 29, 2026 at 09:46:12AM -0800, Paul E. McKenney wrote:
> On Thu, Jan 29, 2026 at 05:27:04AM +0000, Shinichiro Kawasaki wrote:
> > On Jan 28, 2026 / 08:42, Paul E. McKenney wrote:
> > > On Wed, Jan 28, 2026 at 05:55:01PM +0800, Kunwu Chan wrote:
> > > > On 1/26/26 19:30, Shinichiro Kawasaki wrote:
> > > > >  kernel: xfs/for-next, 51aba4ca399, v6.19-rc5+
> > > > >      block device: dm-linear on HDD (non-zoned)
> > > > >      xfs: zoned
> > > > 
> > > > I had a quick look at the attached logs. Across the different runs, the
> > > > stall traces consistently show CPUs spending extended time in
> > > > |mm_get_cid()|along the mm/sched context switch path.
> > > > 
> > > > This doesn’t seem to indicate an immediate RCU issue by itself, but it
> > > > raises the question of whether context switch completion can be delayed
> > > > for unusually long periods under these test configurations.
> > > 
> > > Thank you all!
> > > 
> > > Us RCU guys looked at this and it also looks to us that at least one
> > > part of this issue is that mm_get_cid() is spinning.  This is being
> > > investigated over here:
> > > 
> > > https://lore.kernel.org/all/877bt29cgv.ffs@tglx/
> > > https://lore.kernel.org/all/bdfea828-4585-40e8-8835-247c6a8a76b0@linux.ibm.com/
> > > https://lore.kernel.org/all/87y0lh96xo.ffs@tglx/
> > 
> > Knuwu, Paul and RCU experts, thank you very much. It's good to know that the
> > similar issue is already under investigation. I hope that a fix gets available
> > in timely manner.
> > 
> > > I have seen the static-key pattern called out by Dave Chinner when running
> > > KASAN on large systems.  We worked around this by disabling KASAN's use
> > > of static keys.  In case you were running KASAN in these tests.
> > 
> > As to KASAN, yes, I enable it in my test runs. I find three static-keys under
> > mm/kasan/*. I will think if they can be disabled in my test runs. Thanks.
> 
> There is a set of Kconfig options that disables static branches.  If you
> cannot find them quickly, please let me know and I can look them up.

And Thomas Gleixner posted an alleged fix to the CID issue here:

https://lore.kernel.org/lkml/20260129210219.452851594@kernel.org/

Please let him know whether or not it helps.

							Thanx, Paul
