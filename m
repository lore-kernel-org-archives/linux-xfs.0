Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A8D27A462;
	Wed, 14 May 2025 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230761; cv=none; b=Zx924kMxeJ7uy8nRLhEn03szXYo2hGv3t2d6LKnRqo4d0N+GwP1GvTdOgmuZlSwI7DOMPPEu4HPgiEkpOHVU7KuQOdj08RcvsXwXHkgsDElmd4UBVuzuSXxLIHhxgtHP1uDRDwybVmYngADitgeVaZ5n0r0NnaDleQvgpmfySaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230761; c=relaxed/simple;
	bh=i9CPPFntHSyJK7JzZxKlTQWXBgPLTpN73TXH/zhoQcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNTGkVlNUjobAyAH+EFTGZNH7AveeWmFnK8sB+M3GJE90bYHlYOSpAbSSLbrSgmHBqlwRZH1fMU0PoYDT2RVD4liLeOG+YLEMH0fwCYOT0YjZee7UtJXvcItbB0ATwEvL59IAkK7R6KmOu6Lmwd8JqLnfJ0VlyXCPfAesciKlno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qOjFALn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qOjFALn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C66CC4CEE9;
	Wed, 14 May 2025 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747230759;
	bh=i9CPPFntHSyJK7JzZxKlTQWXBgPLTpN73TXH/zhoQcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qOjFALn2uCJ2VF7yjPyA8IBwrRSWJuOpAX8k23c9XpgVPAYV5AsHUozc8bCt70/+9
	 JJyDedSfJf5JJ4gVsbaYoPB2YYOwbxr1TJ7LcK5XR3sowZBrJrFOT7mLDiziaYiEny
	 Hj2X+HgRDJRlSlmqE8pw8MUYj7/80dTEDr8oNA4LLr19hcZ0S+Ysxl3886Nb9y5Zp+
	 yYbQjhjoN4hAhdM9+DXxenHO62NKDkWWrui15VtKP0Nwud8WyNhQwnZvIpQDNpSg4f
	 U4SGul5SiDgKVnAfGwi80TJ0dRVD5/UuDIU65VQ7wZ02pjkllmrubTwPXynoHzKnQe
	 YIqWK3Fv4ToTw==
Date: Wed, 14 May 2025 15:52:35 +0200
From: Carlos Maiolino <cem@kernel.org>
To: hch <hch@lst.de>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add mru cache for inode to zone allocation mapping
Message-ID: <5obdar2zqtbfr3cfpnsnyos6p276dw7rubx3ucuo42u352m6fv@o3wtcdo2ffv6>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
 <crz1SUPoyTcs_C4T6KXOlfQz6_QBJf7FI8uzRE_ItAzp5Z89le5VY4LXGEG4TkFkSxntO97kOVPJ8a-8ctZdlg==@protonmail.internalid>
 <20250514130014.GA20738@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514130014.GA20738@lst.de>

On Wed, May 14, 2025 at 03:00:14PM +0200, hch wrote:
> On Wed, May 14, 2025 at 10:50:36AM +0000, Hans Holmberg wrote:
> > While I was initially concerned by adding overhead to the allocation
> > path, the cache actually reduces it as as we avoid going through the
> > zone allocation algorithm for every random write.
> >
> > When I run a fio workload with 16 writers to different files in
> > parallel, bs=8k, iodepth=4, size=1G, I get these throughputs:
> >
> > baseline	with_cache
> > 774 MB/s	858 MB/s (+11%)
> >
> > (averaged over three runs ech on a nullblk device)
> >
> > I see similar, figures when benchmarking on a zns nvme drive (+17%).
> 
> Very nice!
> 
> These should probably go into the commit message for patch 2 so they
> are recorded.  Carlos, is that something you can do when applying?
> 

Nvm, I just noticed you as the author. I'll review it
