Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A537B332EA0;
	Tue, 14 Jul 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051963; cv=none; b=egZpB0nUCKaDj8b3UexgOEr9P90tFFuydedInZ6AdxipI90MMJc27HZg2Y/H8W8mmI5VOFjqdtzhT8hnmtxz2kePZnmZz5GptyhoU5ycAJpfVXITfVS6ubxojdYWtjiw0Xx+WabRj/iKH6y+c4SLpksHikCS0Lske0zrjEOk+30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051963; c=relaxed/simple;
	bh=BLfNpfdtCmxzXogfwSD9VmTvDvyO4KMFwb0wuAXW30s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3zvwKx4F9C/wqZvQzUzCWjIF6lY4eH+/WeMAqO3dVrAM9E1Pwf0KYOU6GZDfxHPvO55BzouDlOnK4yRPL5UZERbA29Vo4PmEKCzlFN4QGiDo4s65J+HFX/zBZ/LG6izQ3zw3Xlddycz6k7A9rB5v9hXHLKyC8slOreVsjZFQBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GU9oJP1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GU9oJP1t"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D6921F000E9;
	Tue, 14 Jul 2026 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784051959;
	bh=+PkUQcxYECCIJIN3R/68faEp9nB+pC6Y1qKgNVRhuj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GU9oJP1t7+WMfeNTTgeb3Odh6vodEL/u2kmq2EGpSVicj85dAmzDLQOlPmrqNIc8F
	 gxsfLm97vDw8wmNkEvlfMNk3d9DfJ5vAreUK1F7BxnuusfwcwAj6VL1eEpMAN8SEG4
	 3hAE5cy9hrH3KFTN4ChygYAc76lsS8x5nlDlnL/Dx0kg3vqdhPx06q57pH66HTpYv7
	 q0RCluZ6fwLhpJh8ULYqJSf/fmOddxrFKD+7YxnWWM92bcQK+rqfJI/MsnwpGqKyiW
	 hXx3M9rr9hLW3u9rIEHr+e80xaGyIQ5eDyp4ELqhlncdd64Bnb/z4hgTfxIwMndPoQ
	 vMxKU/JMlHjdg==
Date: Tue, 14 Jul 2026 10:59:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: write the rg superblock when fixing it
Message-ID: <20260714175919.GG7398@frogsfrogsfrogs>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
 <178346726193.1271589.8429966417697809477.stgit@frogsfrogsfrogs>
 <20260713064105.GA29416@lst.de>
 <20260713215857.GG7195@frogsfrogsfrogs>
 <20260714052011.GA31796@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714052011.GA31796@lst.de>

On Tue, Jul 14, 2026 at 07:20:11AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 13, 2026 at 02:58:57PM -0700, Darrick J. Wong wrote:
> > Hrmm.  Right now both superblock scrubbers don't do much for group 0,
> > because both buffers are pinned to the xfs_mount, so they assume that
> > there's no need to check anything.  However, the ondisk super could have
> > gotten corrupted (or blown away by fdisk), in which case an immediate
> > crash could render the filesystem unmountable.
> > 
> > So, I could (a) teach the super scrubbers to read the primary / rt
> > super; and (b) teach them both to log the superblock and bwrite it
> > immediately to shorten the window in which this could happen.
> > 
> > What do you think?
> 
> I guess the only sensible time to scrub the sb would be early during
> mount? 

mount already does that, and rejects the filesystem.

The fresh reread here would only save your filesystem if you happened to
do something dumb while mounted like "ls > /dev/sdb1" and overwrote the
ondisk supers without whacking too much of the existing filesystem.

> > Also, this patch should be calling xfs_log_sb *after* xfs_trans_getsb,
> > so I'll fix that for the repost.
> 
> Oops.

Oh good, for-next got the updated version.

--D
