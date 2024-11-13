Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EA1187FEC
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 22:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731536640; cv=none; b=Fm8ubmQCAQihnwBYqfYIb+6Nd+XUfx2IUalMAmXU0pF6O7dT/uypfzub8/kYqrveGVrV/NUHWE/nFcmOVt/s+01VppXBvQYf/Bup8oMHxHUBSv+oxtrvG3dFO/WKLOSuyPWbsZXJbpbzTsRzN2rS5zMKNOyqRXADs8QhF3Z4QIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731536640; c=relaxed/simple;
	bh=TgLSM3kw/IESz6YfA/6CcM0kRm8NHR70/vlEMxjDpdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcMpGSZyk64UauDlC3WVqsohIrx5NySceCmVmGSSzC7oQ5au2Eqs5QQjhFGMgGPeTaCsKwJNl3Yakc6OAq5ZasLpx/wGNv8RHBED9IQqJWAk1DKZKRkXOAwSw139NMNaIKdXeLZE4FHsA/ArABfyX2Q5k8ZOfPsiwgeqCR1t23s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QBjvm2BV; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QBjvm2BV"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7ee020ec76dso5537009a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 14:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731536637; x=1732141437; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XhU1DTFWsUZULhpNS1f0hFA10SN7OegQFOrkLjd72jU=;
        b=QBjvm2BVQ3a+mq5FYbcfSBvesRgnlh5smymbDA4YWvSZXW2869GBssZrpDlEzJFv/Q
         5FY6Ii7+kqEvJp5IMTEOadDoHWwDjmGijvU7XbGmuULfIL1HBY6UrBzEZQlHtspAoVZX
         E8impMf1ikl6/VN4e09SEA91gSn4xG/DMbadkA2zhvz5f7dKzFMNZcWbBJRzO1QmgTwB
         wWAhkF0uWT7IGjWbIMyyQY19WVfH+EgOvE62UjQcOA1d8HxkMU55ladkeHcXqxrGzw2p
         LJ5IhVC8jtWfZHejGuIyuqXtlbg3QaWRJzHZ10QGegwT8ylV+VP8FDSswszIloVmqrMp
         quMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731536637; x=1732141437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XhU1DTFWsUZULhpNS1f0hFA10SN7OegQFOrkLjd72jU=;
        b=IU5KQesQ0dCXzjj0TAgTpZ86kwPHdyfR3D1zAAoxeHrX7/e5d73vchgQPjWZ1bGOb3
         3gQfmTpps1SoXHTcijJhQPNQ3FPWymK7XIPXsrGEP7PpfOZ6Ozxsv54L1tR8b5SxdjD9
         Mcd3fJygMruXI9QfZ75zNgsMM29QkkxY0ToIO6A5nFZ2TonIiTRFEAQiLEwHlRgPsps4
         IxF0CNf1t2kSv2LJFavCfEr1SnDeCQzTaflsdLfZLSNrO1vdkvb2RtSXqrXokc9jCRao
         DNVDnUVjTApj3oxYZq0XtvxDwvSaNALfEy0FJTLhi4Ald+/D7qUgyPw6nObuuSYpEl10
         F8nA==
X-Forwarded-Encrypted: i=1; AJvYcCUdQIsAob4n1PrC+YUN4vR+xPVL5MzKL6+y00/eZCqOLwun3iJJF43MuXBOnJfrgh1Mi6LfasYG93w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlBMbMR6mFb72xga1JxK9mKGkd7ZWtP3Vq7Tm99OrCdRpocwvE
	Rihwr8oN4YAddHzOBjTePg1PPk/HXcAM24mhi7QZEyU+ADef0IrUaa3NNgw0JuE=
X-Google-Smtp-Source: AGHT+IFp+u01htZ7+R4q0w8zY+0n6pwR7q3KOwbId/6FUz/GheGxoVBPUTfGzcZ0P6rKeXYjD5vOXg==
X-Received: by 2002:a05:6a20:748b:b0:1d9:c78f:4207 with SMTP id adf61e73a8af0-1dc2292c2a4mr30095003637.11.1731536630122;
        Wed, 13 Nov 2024 14:23:50 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f7127f3b01sm2017218a12.84.2024.11.13.14.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 14:23:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1tBLm6-00EGof-0x;
	Thu, 14 Nov 2024 09:23:46 +1100
Date: Thu, 14 Nov 2024 09:23:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alex Shi <seakeel@gmail.com>, linux-xfs@vger.kernel.org,
	Linux-MM <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xfs deadlock on mm-unstable kernel?
Message-ID: <ZzUm8jiGmyDVyEwX@dread.disaster.area>
References: <e5814465-b39a-44d8-aa3d-427773c9ae16@gmail.com>
 <Zou8FCgPKqqWXKyS@dread.disaster.area>
 <20241112171428.UqPpObPV@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112171428.UqPpObPV@linutronix.de>

On Tue, Nov 12, 2024 at 06:14:28PM +0100, Sebastian Andrzej Siewior wrote:
> On 2024-07-08 20:14:44 [+1000], Dave Chinner wrote:
> > On Mon, Jul 08, 2024 at 04:36:08PM +0800, Alex Shi wrote:
> > >   372.297234][ T3001] ============================================
> > > [  372.297530][ T3001] WARNING: possible recursive locking detected
> > > [  372.297827][ T3001] 6.10.0-rc6-00453-g2be3de2b70e6 #64 Not tainted
> > > [  372.298137][ T3001] --------------------------------------------
> > > [  372.298436][ T3001] cc1/3001 is trying to acquire lock:
> > > [  372.298701][ T3001] ffff88802cb910d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_reclaim_inode+0x59e/0x710
> > > [  372.299242][ T3001] 
> > > [  372.299242][ T3001] but task is already holding lock:
> > > [  372.299679][ T3001] ffff88800e145e58 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4d/0x60
> > > [  372.300258][ T3001] 
> > > [  372.300258][ T3001] other info that might help us debug this:
> > > [  372.300650][ T3001]  Possible unsafe locking scenario:
> > > [  372.300650][ T3001] 
> > > [  372.301031][ T3001]        CPU0
> > > [  372.301231][ T3001]        ----
> > > [  372.301386][ T3001]   lock(&xfs_dir_ilock_class);
> > > [  372.301623][ T3001]   lock(&xfs_dir_ilock_class);
> > > [  372.301860][ T3001] 
> > > [  372.301860][ T3001]  *** DEADLOCK ***
> > > [  372.301860][ T3001] 
> > > [  372.302325][ T3001]  May be due to missing lock nesting notation
> > > [  372.302325][ T3001] 
> > > [  372.302723][ T3001] 3 locks held by cc1/3001:
> > > [  372.302944][ T3001]  #0: ffff88800e146078 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: walk_component+0x2a5/0x500
> > > [  372.303554][ T3001]  #1: ffff88800e145e58 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4d/0x60
> > > [  372.304183][ T3001]  #2: ffff8880040190e0 (&type->s_umount_key#48){++++}-{3:3}, at: super_cache_scan+0x82/0x4e0
> > 
> > False positive. Inodes above allocation must be actively referenced,
> > and inodes accees by xfs_reclaim_inode() must have no references and
> > been evicted and destroyed by the VFS. So there is no way that an
> > unreferenced inode being locked for reclaim in xfs_reclaim_inode()
> > can deadlock against the refrenced inode locked by the inode lookup
> > code.
> > 
> > Unfortunately, we don't have enough lockdep subclasses available to
> > annotate this correctly - we're already using all
> > MAX_LOCKDEP_SUBCLASSES to tell lockdep about all the ways we can
> > nest inode locks. That leaves us no space to add a "reclaim"
> > annotation for locking done from super_cache_scan() paths that would
> > avoid these false positives....
> 
> So the former inode (the one triggering the reclaim) is created and can
> not be the same as the one in reclaim list. Couldn't we assign it a
> different lock-class?

We've done that in the past. The problem with that is we lose lock
ordering verification across reclaim. i.e. inode lock ordering must
be the same both above and below reclaim, and changing the lock
class loses the ability to verify this.

This is important to us as some code (e.g. extent removal) can be
called from both above and below reclaim, and they require the same
transaction and inode lock contexts to be held regardless of where
they are called from...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
