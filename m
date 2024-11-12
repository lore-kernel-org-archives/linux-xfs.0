Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D672076DA;
	Tue, 12 Nov 2024 17:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731431673; cv=none; b=nt5NQVKzYTOvES4ddbjKC9pEX45ozMAhdbIgx2sbMJdl708A0z/RIJwVrNTyM230ZT9X9NIHPtOkn7nz25W3BE9D+dzTP8LqZNwEyPjCx2M3o1XwvzO3YOHvHLL8vPBf7M4PcEZuavl+Zz5SYpgug0HD2RCbiD1GZ1Wz1zmSzTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731431673; c=relaxed/simple;
	bh=OVDxMNjz/kRsn0mlLewto2R8wq9d+xl95pyKd2dQH/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPe25LqONyLSryh2qps2m5g7C0+LcFbPPAVyrl9CixtbMWeeOUULNB6RWdiXYIYnLrPqpmGTQ4lPyZB8OSLePt/YTG8KuxPSn6fdJtrQRucI4aQSsRVNwAA8lJCzzlg/XWSpHc6W+bL3C74HuCGzL7u9dOV5IIspqkT0XVEoS3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zWRGxxwv; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=XbBCMGA2; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zWRGxxwv";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="XbBCMGA2"
Date: Tue, 12 Nov 2024 18:14:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1731431669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fLSGSsbdaiZ6JUBSPFVjQaHTBzfxSyRl8vuArkyUJAs=;
	b=zWRGxxwvUomZz2ou/p/A3prEpsitfkJlzoi55RFCGH6L6nF+VtL6L6auxDo7Oe/u74hBnQ
	9/o/xErl3Dt8Zjuz6010t84GKYAL41pLMljW/E+0pCfNBk0yZ7BMdhDakRAcFi9XEcFNPa
	QGzGuGbkpIUQkzY/dlZewnYNVFNHsrgKWMlunaC8ghudyCLyxHkPRteduYUchfgkW4vawu
	yCTJrZr3KMbyb55pRgwba13gvVI9W2Y4I4MwGzBxE8CfvMi0EU/6opviX54Y/u8lLBidKh
	0zJIFza1ApvBf4Fgy9Yqmej9iFtuAx1LtNO59NNUs8cAJl1i3Cp/F2mzcSpjlQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1731431669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fLSGSsbdaiZ6JUBSPFVjQaHTBzfxSyRl8vuArkyUJAs=;
	b=XbBCMGA2XMMqf1ILPCkgK8507FyvT6FWiYczNcIbxgasO5RneCbS/dxLprzBzaCeiF/R8j
	HoEG7mwJB8xSUlAg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Shi <seakeel@gmail.com>, linux-xfs@vger.kernel.org,
	Linux-MM <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xfs deadlock on mm-unstable kernel?
Message-ID: <20241112171428.UqPpObPV@linutronix.de>
References: <e5814465-b39a-44d8-aa3d-427773c9ae16@gmail.com>
 <Zou8FCgPKqqWXKyS@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zou8FCgPKqqWXKyS@dread.disaster.area>

On 2024-07-08 20:14:44 [+1000], Dave Chinner wrote:
> On Mon, Jul 08, 2024 at 04:36:08PM +0800, Alex Shi wrote:
> >   372.297234][ T3001] ============================================
> > [  372.297530][ T3001] WARNING: possible recursive locking detected
> > [  372.297827][ T3001] 6.10.0-rc6-00453-g2be3de2b70e6 #64 Not tainted
> > [  372.298137][ T3001] --------------------------------------------
> > [  372.298436][ T3001] cc1/3001 is trying to acquire lock:
> > [  372.298701][ T3001] ffff88802cb910d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_reclaim_inode+0x59e/0x710
> > [  372.299242][ T3001] 
> > [  372.299242][ T3001] but task is already holding lock:
> > [  372.299679][ T3001] ffff88800e145e58 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4d/0x60
> > [  372.300258][ T3001] 
> > [  372.300258][ T3001] other info that might help us debug this:
> > [  372.300650][ T3001]  Possible unsafe locking scenario:
> > [  372.300650][ T3001] 
> > [  372.301031][ T3001]        CPU0
> > [  372.301231][ T3001]        ----
> > [  372.301386][ T3001]   lock(&xfs_dir_ilock_class);
> > [  372.301623][ T3001]   lock(&xfs_dir_ilock_class);
> > [  372.301860][ T3001] 
> > [  372.301860][ T3001]  *** DEADLOCK ***
> > [  372.301860][ T3001] 
> > [  372.302325][ T3001]  May be due to missing lock nesting notation
> > [  372.302325][ T3001] 
> > [  372.302723][ T3001] 3 locks held by cc1/3001:
> > [  372.302944][ T3001]  #0: ffff88800e146078 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: walk_component+0x2a5/0x500
> > [  372.303554][ T3001]  #1: ffff88800e145e58 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4d/0x60
> > [  372.304183][ T3001]  #2: ffff8880040190e0 (&type->s_umount_key#48){++++}-{3:3}, at: super_cache_scan+0x82/0x4e0
> 
> False positive. Inodes above allocation must be actively referenced,
> and inodes accees by xfs_reclaim_inode() must have no references and
> been evicted and destroyed by the VFS. So there is no way that an
> unreferenced inode being locked for reclaim in xfs_reclaim_inode()
> can deadlock against the refrenced inode locked by the inode lookup
> code.
> 
> Unfortunately, we don't have enough lockdep subclasses available to
> annotate this correctly - we're already using all
> MAX_LOCKDEP_SUBCLASSES to tell lockdep about all the ways we can
> nest inode locks. That leaves us no space to add a "reclaim"
> annotation for locking done from super_cache_scan() paths that would
> avoid these false positives....

So the former inode (the one triggering the reclaim) is created and can
not be the same as the one in reclaim list. Couldn't we assign it a
different lock-class?
My guess would be that you drop the lockdep_set_class() in
xfs_setup_inode() and then do it in xfs_iget_cache_miss() before adding
it to the tree. So you would have one class initially and then change it
once it enters the tree. I guess once the inode is removed from the
tree, it goes to kfree().

> -Dave.

Sebastian
