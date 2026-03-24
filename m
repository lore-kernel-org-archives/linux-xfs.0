Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009C91A6827;
	Tue, 24 Mar 2026 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774371989; cv=none; b=DK+NGSSBstO2TlPV6NRoOd2c1zfMxurL+HmnOsIJGGvHCQNQc7GCKDOFK986pdh3L91w5FleCXdqDK/4Ib3HqWJr7yERq9TPyx0QmvXGBRMq5TapFEx4m8lzYk93wKgnL13rZXqNBfTeYoiHW/Fph2jUmC3FsnEo1VfQuG78M70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774371989; c=relaxed/simple;
	bh=3do5ookdd0VXSf3OwjE/LYpsosNLUXlPOPQeT3MWgkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ej3M8JX73kAkca6Zcbu6TxHfh/SypTkxAvZ25IhqWPxltFuyCd0MI5WuAEFOs/ts9H8MQk0MGbunIY56mqHqEiWFo2c/bA0Wz4HPnl59sA4g2W98rwIAfRKi6mpriFzOp2xh0OVgRr9Sx/ONTL+VrKEibhZb3h2bZIgGnlAFUDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O14t2Tbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O14t2Tbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A587C19424;
	Tue, 24 Mar 2026 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774371988;
	bh=3do5ookdd0VXSf3OwjE/LYpsosNLUXlPOPQeT3MWgkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O14t2TboVb6WHnoQTD5GV+63wQR81LdwqDeGEPG5/3yEUFRpc1w2mzOWvZ4dvmCsS
	 G2P+CBZhvywHJxxZIYw0i5ix843VOgtMsPeICayr+wOj/UyFxjKOONim7IzNXjzm2V
	 rVr22NcInyyscEYm17Y+ktWFcuOWsBAOADwlbA6OcjVE7Q6ae8roDEX6LI3D1vJ2uL
	 FkNkZkrVXGPWtcSDDmKKKLEGt2Xf4f8Xf7Jum5m91WOtE6vXzSHqoDh+UnKeYNZEcJ
	 9j3jS/d1tPg9okVPAkrRl58f60B5211wR6EcUCI98LK6P4wIYUq8Qomyl3e0zcu94z
	 192O8lQR9j58w==
Date: Tue, 24 Mar 2026 10:06:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] iomap: fix lockdep complaint when reads fail
Message-ID: <20260324170627.GP6223@frogsfrogsfrogs>
References: <20260323210017.GL6223@frogsfrogsfrogs>
 <20260324-zurechnen-sturheit-10ba083e2f06@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324-zurechnen-sturheit-10ba083e2f06@brauner>

On Tue, Mar 24, 2026 at 09:15:10AM +0100, Christian Brauner wrote:
> On Mon, 23 Mar 2026 14:00:17 -0700, Darrick J. Wong wrote:
> > Zorro Lang reported the following lockdep splat:
> > 
> > "While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954),
> > a lockdep warning was triggered indicating an inconsistent lock state
> > for sb->s_type->i_lock_key.
> > 
> > "The deadlock might occur because iomap_read_end_io (called from a
> > hardware interrupt completion path) invokes fserror_report, which then
> > calls igrab.  igrab attempts to acquire the i_lock spinlock. However,
> > the i_lock is frequently acquired in process context with interrupts
> > enabled. If an interrupt occurs while a process holds the i_lock, and
> > that interrupt handler calls fserror_report, the system deadlocks.
> > 
> > [...]
> 
> Applied to the vfs.fixes branch of the vfs/vfs.git tree.
> Patches in the vfs.fixes branch should appear in linux-next soon.
> 
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
> 
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
> 
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs.fixes
> 
> [1/1] iomap: fix lockdep complaint when reads fail

Hey Christian,

Is it not too late to rename this patch to:

"iomap: fix potential deadlock when buffered reads fail"

--D

>       https://git.kernel.org/vfs/vfs/c/f621324dfb3d
