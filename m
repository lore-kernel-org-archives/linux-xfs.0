Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F1E818
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 00:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705625525; cv=none; b=WA/rEsIjdVRzdB58xPd+/J3klRIP77RMmQRNJllZQ1cpVi2qbOBJvcktg5aollBnJqnclCk5cjnoysGkpJy8KoeoE1L4ngvD6YODMKFfPOt4DBiGHp7MzgCSFm9V71eh8SsrF4BLYrtY/e8Bq4MxlD6MWKXpydOjOmRycye4ULI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705625525; c=relaxed/simple;
	bh=s0WyRgHpoBdBQKl3r5uRZj+7S6kwZ1JAsozsyLM9rk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1umID9tYiFqJOfOnxRRUup+H7s5wQ/yH8rnyneAB4m/s/Fb06aNxTR1jBtADS83Psgz44boPe5KB8vTw5tfq4yE4YVhSDzCNXdEuyxKARS2dtqY4jS6BXySDKI/Ul03DHzi5q1IfdLxzLNwQ88/6Sja0TgV0RAprcaqtTf8pLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnSpDZRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnSpDZRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7FFC433F1;
	Fri, 19 Jan 2024 00:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705625525;
	bh=s0WyRgHpoBdBQKl3r5uRZj+7S6kwZ1JAsozsyLM9rk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YnSpDZREkTsvXK6E5OOucXU8xuTYi3P7X9AtwKIHrURuIAewoK2HkZjfHra9jqeRp
	 5Iuc9ZnDKAv/zJlSsnYHWl1nDuf1hYGx5Nx6YiccKM2eokdBDJciWArPY4c0NweaUp
	 OeijRHlsyvZ5LrwwX2bH7KDRVETR3dRVV5ShF2ll3rsSKNDW8+EbrN20OoshmbLDr5
	 ewqzzqyRTsXsttyBrjtC/JyY6W7rypUPQgRfptLi1CfFQsnlk7PciwSUOCrDM4TF6T
	 7Jp1mWaogjBAjqVuHhlIdz6OWpKSFVDhmQgYowGMbu7m5HUGDgZ0o8YBWOA0FC5iJs
	 mLg0+KpxbbMMg==
Date: Thu, 18 Jan 2024 16:52:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: use directio for device access
Message-ID: <20240119005204.GF674522@frogsfrogsfrogs>
References: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
 <169567915609.2320255.8945830759168479067.stgit@frogsfrogsfrogs>
 <Zagcv3rWRQMeTujZ@infradead.org>
 <20240118013250.GC674499@frogsfrogsfrogs>
 <ZainRaV+P0qr1o6g@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZainRaV+P0qr1o6g@infradead.org>

On Wed, Jan 17, 2024 at 08:21:25PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 17, 2024 at 05:32:50PM -0800, Darrick J. Wong wrote:
> > > 
> > > For xfs/002 that is the libxfs_buf_read in __set_cur, when setting the
> > > type to data, but I haven't looked at the other test in detail.
> > 
> > Hmm.  Perhaps the userspace buftarg setup should go find the physical
> > sector size of the device?  That "bb_count = 1" in set_iocur_type looks
> > a bit smelly.
> 
> Yes, that should fix this particular issue.
> 
> > > Should I look into finding all these assumptions in xfs_db, or
> > > just make the direct I/O enablement conditional n a 612 byte sector
> > > size?
> > 
> > Let me go run a lbasize=4k fstests run overnight and see what happens.
> > IIRC zorro told me last year that it wasn't pretty.
> 
> There's a few failures, but I've been slowly trying to fix this.  The
> libxfs/mkfs log sector size detection series in one part of that,
> and this:
> 
> https://lore.kernel.org/linux-block/20240117175901.871796-1-hch@lst.de/T/#u

Hmm well I didn't manage to add your loop device patch before I sent
this out last night, but here's the fstest results:

https://djwong.org/fstests/output/.67c2f90f0a1bb329a1b895c50285b0d23c1bd2bb44b7839f3543f82281665db1/.4a10533d4dd2085d3f996649e0886284f557617c94e604189448672e6009b9e8/

Looks like there were a lot of weird problems.  OFC now the second ice
storm has started and the lights are flickering so that might be all
from me for now.

--D

> is another
> 
