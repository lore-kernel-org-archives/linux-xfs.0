Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F68F1E87E
	for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 22:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975528; cv=none; b=cxkbj/LJhkNZWNiJ0NVlCiK3FOClgx5sgYqxr1SG/AZKlyXK6OYwKjfW3GsyCRtNx84r4GBkZv67yY38UnlDymAxQAs2TMZbZCrLORLvUn407Z57DDpHzHZd1UHf/jOCA8uhE04dPKqgdkCEi31Z4YMBVszv0Gw3rfvS8+s7WC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975528; c=relaxed/simple;
	bh=cJcOIKteFplY1Am/4TaGeCUOdb/41tOBybiR6FfLqI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHU+xX+A377jgrV7cIPRpU2IUAmCJBdkMx9lrLkK+VrRx6hrdIDUQUVLd1519p6kAZ5q4Z0Yv3nLG+crHnZhAGl2GIp8/hTnd7b55WOu9ANfMK+DZiA/DCPAbk5daKvkgNZ9Rtp3BnbXoUno+0LUVFesuKG2/f2ojpBKGdyCJpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=09kEDYzP; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="09kEDYzP"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7cf25c1ee7aso13444139f.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 15:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710975525; x=1711580325; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yW1OcmsIwgmTUgHl55Yk27GXRUpvmjdz/ooab1nxctI=;
        b=09kEDYzPteGqxP3bpzD35qmgQ10/GL3CK92g66k87b4BDt0qUiLHC6NDAn+xFtXMYk
         mlwz9XthtcCU78cRsJPJbpkzwwmpFv7m4GyVPEIktwOdBaoWnSeC6dC9lRdT5E0bVBsK
         kjZCdXl12Drx9+ZvMeVSTML8XXdViy49+IjEgD261tWT3ElpH1sUG/c0jDUUj+vGYQjG
         AkvEuX8XCnpTZsrAO089F6eXZLR8B2XMjpY6pkXV7OVvui+US3DoInS0aMy/eBB5Fwdj
         mO4s6p14TLey7H8nXRT7Slggtzi439UUwmiT5hme3YMnFiCJvFMIvShxk9JA9GbizNXo
         6UhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975525; x=1711580325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yW1OcmsIwgmTUgHl55Yk27GXRUpvmjdz/ooab1nxctI=;
        b=glqK6uEPByKZ5Unye1kjBrHKHDaVBhKlUWxVgXT+Jfv84MrAi+Dwq9QK2GxAsekED0
         kKyC4i3u0xIwj1zx940gReXQAcAGMlmbKEODDpAkrNkjts5cTaX2ui5mjxkOOCR7iGAI
         UEpQBRE0AniTzl0djVvhyIYV9uLEPM1Jd28gkwd0ppXeUWsvEcwe8RUJeoUrX3AKAUMx
         y/sAWQPFVDIbYIngzaOphLaMWWBPmn43R4rVBZvXkOyzHyQRGz418NML39l1UAlUOMxX
         ckX7VcR2m58iXkFUNftnxa6PM9iFj3rvQzLGNujDNJmD0UMh8hh80n8nAw1HJIBcLzlC
         gogQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxI+O8JBDi0x4O1IC6NaMGyS5nhG4Xv5c7cSnvJaztT9HBvYor2MTIq2I9i8LtnRcgHzL4OxGaxMJxf8SVBa3z8k+B7VCqNahc
X-Gm-Message-State: AOJu0YxpmRMUltlTgByA0tuqG8a3U2WHdnCbSFTqSzSil/Hd7j3pzYi4
	xJ8XiHNvP6u6rV/8jA6wtARUbM1zzLcgld8rAKvAPLVkyNSLaMBLYTJRV41i+40d0TYts+RsOaN
	x
X-Google-Smtp-Source: AGHT+IHvjpGs2jzf1fdqztBKNKcpeMumqwt7YXlOkluZvM7sKkF4UhyLyh4G7bYFWrCjgRggD4rl7Q==
X-Received: by 2002:a05:6a20:7b20:b0:1a3:4469:769e with SMTP id s32-20020a056a207b2000b001a34469769emr289658pzh.57.1710975103338;
        Wed, 20 Mar 2024 15:51:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id e1-20020aa798c1000000b006e641fee598sm12536359pfm.141.2024.03.20.15.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:51:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rn4ma-004lsY-17;
	Thu, 21 Mar 2024 09:51:40 +1100
Date: Thu, 21 Mar 2024 09:51:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <ZftofP8nbKzUdqMZ@dread.disaster.area>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-5-david@fromorbit.com>
 <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>
 <20240320145328.GX1927156@frogsfrogsfrogs>
 <ZfsVzV52CG9ukVn-@tuebingen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfsVzV52CG9ukVn-@tuebingen.mpg.de>

On Wed, Mar 20, 2024 at 05:58:53PM +0100, Andre Noll wrote:
> On Wed, Mar 20, 07:53, Darrick J. Wong wrote
> > On Wed, Mar 20, 2024 at 09:39:57AM +0100, Andre Noll wrote:
> > > On Tue, Mar 19, 11:16, Dave Chinner wrote
> > > > +		/*
> > > > +		 * Well, that sucks. Put the inode back on the inactive queue.
> > > > +		 * Do this while still under the ILOCK so that we can set the
> > > > +		 * NEED_INACTIVE flag and clear the INACTIVATING flag an not
> > > > +		 * have another lookup race with us before we've finished
> > > > +		 * putting the inode back on the inodegc queue.
> > > > +		 */
> > > > +		spin_unlock(&ip->i_flags_lock);
> > > > +		ip->i_flags |= XFS_NEED_INACTIVE;
> > > > +		ip->i_flags &= ~XFS_INACTIVATING;
> > > > +		spin_unlock(&ip->i_flags_lock);
> > > 
> > > This doesn't look right. Shouldn't the first spin_unlock() be spin_lock()?
> > 
> > Yes.  So much for my hand inspection of code. :(
> 
> Given enough hand inspections, all bugs are shallow :)

Sparse should have found that, if I ran it. :/

Ah, but sparse gets confused by the fact that the return from the
function may or may not have unlocked stuff:

fs/xfs/xfs_icache.c:355:9: warning: context imbalance in 'xfs_iget_recycle' - unexpected unlock
fs/xfs/xfs_icache.c:414:28: warning: context imbalance in 'xfs_iget_reactivate' - unexpected unlock
fs/xfs/xfs_icache.c:656:28: warning: context imbalance in 'xfs_iget_cache_hit' - different lock contexts for basic block

So if I fix that (that'll be patch 5 for this series), i get:

  CC      fs/xfs/xfs_icache.o
  CHECK   fs/xfs/xfs_icache.c
fs/xfs/xfs_icache.c:459:28: warning: context imbalance in 'xfs_iget_reactivate' - unexpected unlock

Yup, sparse now catches the unbalanced locking.

I just haven't thought to run sparse on XFS recently - running
sparse on a full kernel build is just .... awful. I think I'll
change my build script so that when I do an '--xfs-only' built it
also enables sparse as it's only rebuilding fs/xfs at that point....

> > (Doesn't simple lock debugging catch these sorts of things?)
> 
> Maybe this error path doesn't get exercised because xfs_reinit_inode()
> never fails. AFAICT, it can only fail if security_inode_alloc()
> can't allocate the composite inode blob.

Which syzkaller triggers every so often. I also do all my testing
with selinux enabled, so security_inode_alloc() is actually being
exercised and definitely has the potential to fail on my small
memory configs...

> > ((It sure would be nice if locking returned a droppable "object" to do
> > the unlock ala Rust and then spin_lock could be __must_check.))
> 
> There's the *LOCK_GUARD* macros which employ gcc's cleanup attribute
> to automatically call e.g. spin_unlock() when a variable goes out of
> scope (see 54da6a0924311).

IMO, the LOCK_GUARD stuff is an awful anti-pattern. It means some
error paths -look broken- because they lack unlocks, and we have to
explicitly change code to return from functions with the guarded
locks held. This is a diametrically opposed locking pattern to the
existing non-guarded lockign patterns - correct behaviour in one
pattern is broken behaviour in the other, and vice versa.

That's just -insane- from a code maintenance point of view.

And they are completely useless for anythign complex like these
XFS icache functions because the lock scope is not balanced across
functions.

The lock can also be taken by functions called within the guard
scope, and so using guarded lock scoping would result in deadlocks.
i.e. xfs_inodegc_queue() needs to take the i_flags_lock, so it must
be dropped before we call that.

So, yeah, lock guards seem to me to be largely just a "look ma, no
need for rust because we can mightily abuse the C preprocessor!"
anti-pattern looking for a problem to solve.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
