Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12D34963C9
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 20:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778186105; cv=none; b=htaWMUa/YIM2qlbVv4o3MKmdlvAUFwx+uCcVzmok6/kAj5d4R19BSW4jLg5romUq3KwLmYqneQrn1TAcccdu4IARlbJRzBO1ZUh4SaTcq6H8sfM6NyrDRi0/GTEE6W7343KANIAirNnfQ/EQTdGNOSJk3eGe75hvbMEkRPxpl2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778186105; c=relaxed/simple;
	bh=XTFoINVVSbohUnLxqUzUPtP02lkHiQT1mAAi0FVlOJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJ4zTO2AT+/uwamG+U3x3Id0OXJ7waB7/0XEMNH5U3SEYxitpLzv392sZRdVYpoekWWNLCjG6NRwkpBz0KJGxfTXHVBEJeSoiRkjzMJS2e/D6oR0jEhAc9YAN4liTYypjLryqdXJt1Rz8KS6aRuxGzCnxvq3qZSNHp0HZa+1WmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YsqpJWa9; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YsqpJWa9"
Date: Thu, 7 May 2026 22:34:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778186100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SM4hfnL7lsMNMWafALrBJn3l0GfsDcdVKbpFmyUzn3s=;
	b=YsqpJWa96sarDnes1t7bY70nECAZ6Jv6lWGyIx1PF/prn1kIlB5H1rTaVidaAXXXGB70+I
	Iy0AIDy1Lb3h1quZzIxR6KdeJvGm2l1OfCQMNcbNC7ggC3aokqPHkJmAY+bABJUxrwHSsM
	32F5x/FqBRcLcb+YS0XzxlT3ouQj3aw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Andres Freund <andres@anarazel.de>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, gost.dev@samsung.com, 
	p.raghav@samsung.com
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
Message-ID: <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6>
References: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>
X-Migadu-Flow: FLOW_OUT

On Wed, May 06, 2026 at 09:26:25AM -0400, Andres Freund wrote:
> Hi,
> 
> While looking at performance issues on Samsung client drives due to slow FUA,
> I tried to reproduce older numbers on a recent kernel.  And couldn't, at first
> - but not because the problem went away, but because the fdatasync numbers
> (which shouldn't use FUA) got *much* worse.
> 
> These drives have FUA writes that are slower than full flushes, making
> O_DIRECT|O_DSYNC writes perform poorly and fdatasync() comparatively better.
> 
> 
> What I'm seeing is that with recent kernels the fdatasync() performance is
> roughly as bad as the O_DSYNC, whereas previously it was > 2x as
> fasts. blktrace showed that there are ongoing FUA writes during a workload
> with just overwriting writes and an fdatasync after every write.
> 
> 
> At first I thought it was a regression between 7.0..7.1-rc2, but that turned
> out to be only because the 7.0 machine did not have lazytime enabled. After
> fixing that discrepancy, the regression is also visible in 7.0.  I have
> confirmed it's not visible in 6.18.

I was able to reproduce this issue. The commit causing the issue is
indeed from nonblocking timestamps series as you indicated 
(fs: add support for non-blocking timestamp updates).

In inode_update_cmtime, we have the following changes as a part of the
series:
...
mtime_changed = !timespec64_equal(&now, &mtime);
	if (mtime_changed || !timespec64_equal(&now, &ctime))
		dirty = inode_time_dirty_flag(inode);  // #1

	/*
	 * Pure timestamp updates can be recorded in the inode without blocking
	 * by not dirtying the inode.  But when the file system requires
	 * i_version updates, the update of i_version can still block.
	 * Error out if we'd actually have to update i_version or don't support
	 * lazytime.
	 */
	if (IS_I_VERSION(inode)) {
		if (flags & IOCB_NOWAIT) {
			if (!(inode->i_sb->s_flags & SB_LAZYTIME) ||
			    inode_iversion_need_inc(inode))
				return -EAGAIN;
		} else {
			if (inode_maybe_inc_iversion(inode, !!dirty)) //#2
				dirty |= I_DIRTY_SYNC;
		}
	}

...

In the above snippet, in #1 we set dirty = I_DIRTY_TIME if SB_LAZYTIME
is set and in #2 we do a force increment on iversion for any non-zero
dirty values, including I_DIRTY_TIME alone.

I think the fix is to use "dirty != I_DIRTY_TIME" as the force parameter? This passes
false for pure lazytime updates (allowing the I_VERSION_QUERIED optimization
to work), while still forcing the increment when dirty contains other flags
indicating real changes.

diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28..e9b3b2febb58 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2124,7 +2124,7 @@ static int inode_update_cmtime(struct inode *inode, unsigned int flags)
                          inode_iversion_need_inc(inode))
                              return -EAGAIN;
              } else {
-                     if (inode_maybe_inc_iversion(inode, !!dirty))
+                     if (inode_maybe_inc_iversion(inode, dirty != I_DIRTY_TIME))
                              dirty |= I_DIRTY_SYNC;
              }
      }

This fix seems to reduce the number flush calls and fix the regression.
@carlos and @hch let me know if this is the correct fix or I am just
suppressing the symptom and not fixing the root cause.

-- 
Pankaj
