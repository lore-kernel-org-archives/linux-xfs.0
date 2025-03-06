Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E061F4289
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 10:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741255251; cv=none; b=u6tHNYcpNMgof16rHq0cu0sEMJ2CKYrOy9CGTGOYvIwLP3iaQ/45Hxm9F1hv8u1hqBehOTe252e5n+GHkdWaIOrJiafxd9NVD4AQfQniXyOavSMBQBMnkq5NhOP2UHNRO/9DvxpJvyr8U3+BWLZSgjIegpvTwq5ve61sYF0uvv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741255251; c=relaxed/simple;
	bh=lUuQjeXjWmZpGyuqNPgsz6Lay/iyG7YdV0kB3zxTCVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PA1y/vuiAe09knqOKgmumC42A/mPeX9j6DQWT3f3eBu99qZECmZT2zMkfIJMVA+JppaWOn1uY0bZFU7GBR+nFZzjCzzGHyWH7FU2PWluIj1kSZhFK1jUXGbtmrqM0cwncYmQ6rEcdesd8Ti1HZqFUgZ7aJXYI9/jJ17riQxbixk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qSK340Gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qSK340Gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB743C4CEE0;
	Thu,  6 Mar 2025 10:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741255250;
	bh=lUuQjeXjWmZpGyuqNPgsz6Lay/iyG7YdV0kB3zxTCVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qSK340GjKI7EWKpOQ0TAc3juUIJbTO0Fh7yG1+OlyVr3P3L2Swegy9qVqO+K+zo6h
	 iifsikCCVe9ZzCBW2HqX3Ao6DdxOB0GOvD0ttD7xtRDp1CxUUT7V9bBRl0n7dhwIjD
	 WicJY5t/oSNswDaXF/RHnmcOPe6/8zDFaZn2InVscTqXrCheHXZTwQQI/NOzAxVA+6
	 jBS0y7IJRb5ur4zE79xc6ViuxGXfy7nZQdsm0WOhQ2kp776N+SrwtD3MXDi8luob6Z
	 nTxPfTIAdCtoHZ60FE/P+OtusJIqtSwQ2ow81hIGkCvOZ6b6wTTNLcyEWf8bmhVNoZ
	 HD5iM6QV5JV6g==
Date: Thu, 6 Mar 2025 11:00:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
Cc: linux-xfs@vger.kernel.org
Subject: Re: nouuid hint in kernel message?
Message-ID: <pgirewjvggop2v2s6qrovyqr72kxfajuk2sbqlqll3facikiuu@sriorffcy3x4>
References: <Nro5gceoG1ar5vFFGSWGNwo-KlGPVYooeufy2thIqL3A5VKjZKQ0yp0kKyAxSVRiAvTm1CkpW4ITHawDjpez0A==@protonmail.internalid>
 <cbf4f4c23efba09467ca7c08e516fe8561a1f130.camel@ifi.uio.no>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbf4f4c23efba09467ca7c08e516fe8561a1f130.camel@ifi.uio.no>

On Thu, Mar 06, 2025 at 12:46:23AM +0100, Kjetil Torgrim Homme wrote:
> hey people, thank you for XFS!
> 
> tl;dr: consider changing the kernel message "Filesystem has duplicate
> UUID - can't mount" to include a hint about the existence of the nouuid
> mount option.  perhaps append " (use -o nouuid?)" to message?

This looks good at first, but adding a message like this has a big down
side IMHO. This leads users to simply attempt to do that even in cases when they
shouldn't.

As an example, in a common multipath environment with dm-multipath, an user
might accidentally attempt to mount both individual paths to the same device,
and this uuid duplicate check protects against such cases, which might end in
disaster.

On a mid term here, I think we could improve xfs(5) to include a bit more
information about duplicated uuids.

Carlos

> 
> sad backstory:
> 
> today I tried to use LVM snapshots to make consistent backups of XFS,
> but I was stumped by:
> 
>    mount: /mnt/snap: wrong fs type, bad option, bad superblock on /dev/mapper/vg0-test--snap, missing codepage or helper program, or other error.
>           dmesg(1) may have more information after failed mount system call.
> 
> and dmesg said:
> 
>    XFS (dm-7): Filesystem has duplicate UUID d806fb70-8d81-4e57-a7e3-c2ed0a14af59 - can't mount
> 
> so - I thought the solution was to change the UUID of my snapshot using
> `xfs_admin -U generate`.  this is the response (when the snapshot is of
> an active filesystem):
> 
>    ERROR: The filesystem has valuable metadata changes in a log which needs to
>    be replayed.  Mount the filesystem to replay the log, and unmount it before
>    re-running xfs_admin.  If you are unable to mount the filesystem, then use
>    the xfs_repair -L option to destroy the log and attempt a repair.
>    Note that destroying the log may cause corruption -- please attempt a mount
>    of the filesystem before doing this.
> 
> so since I was unable to mount the filesystem, I tried xfs_repair -L --
> which took a very long time and in the end gave me a corrupt filesystem.
> 
> ... and then I found out about -o nouuid, so there was a happy ending :)
> but I think it's a reasonably simple fix to give a hint to the user in
> the kernel error message.
> 
> thank you!
> --
> venleg helsing,
> Kjetil T.
> 
