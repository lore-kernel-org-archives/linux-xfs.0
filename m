Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D91E21373
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 22:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727736820; cv=none; b=aayQ/VrNDsZY34k4hgIubdOvutnliaGIQjeZx7PO4kyaU69M8m9hmnvpeKthHqrCBTBnsqScQsvFtNvi1IviSoB4tLu5ubA8OfyAnomnOTmawpUE4WWwsoXxIsKusRgj13ZKkgt46AUYU6JDRfI9NY8/y0SDQD0WM+/OfEvRWEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727736820; c=relaxed/simple;
	bh=J3rvnH3FdvtJ5wDpJKLxH3H4+FhnCYXfdxLwv3Q6jQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENrBFCuZME8kaS6aRxdbw6sp3Yp94rChCf2IQWxQP6f7HJ1gTewIhbBLYfadASw0AoMv2RDbdQ4gAO1R47LptECTQMNkTyUQY1Qp0dB5b4bqeR8ooWeA5tEKer177ZmWBP49V/0tpkYbl4Lt+FUiajcJlOo6X5s9XBpJPLbgrbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ov85AWO/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ov85AWO/"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20ba733b6faso5267135ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 15:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727736818; x=1728341618; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pgp5JKh5leY7tqoP1ESqMVgnos2B4G5hEQe2yB61B94=;
        b=ov85AWO/ihqNiIwSzjZxOlijQDUg/6oIlOnas87mlLb7T1WMdbUBuUTCYiR4oll1dS
         mdjyJ5s4hpveQtL4dhKmHrtAn+sCeO7rh6eX6+E3OAtKDWiAoMaJKTHUgOu85FCAaZTO
         zz/W8eAwduNB+5dWn9lDeiT3SNYT+BMQ2fC9XicFxklglqy2L3G+VuSMavnRU7tm5kjU
         GZVo95hAYCJ1SFZ0tIxi/PtFepzCbKDMmsmRf4yRD6JrrHzirGuRKtXoW6YilaV9QRVX
         FQJgq0HdhBzEjirMNPtwFz+5jcpZIHACLSxELeNu3pNpyDvLHx22fhUzjBSXjvMBKNvz
         xRpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727736818; x=1728341618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pgp5JKh5leY7tqoP1ESqMVgnos2B4G5hEQe2yB61B94=;
        b=RGXGL56qCPfo7Y/VDOcHU4IWzXRKZWVWOcyWZb6xZg+dOXvL3fi9OeQncRYPN98Am+
         mDYiYmWlm/QSsFDbJc7KMBtZK4SBs3106KRFzZsTgQ4z7iWX/f+9po/s9e3RTP4zKvAe
         wHx2WzB0i5bOpF0QQDmcmYxV/4OZjUYMqmgyUKf0SI+3vkXPOE8mNjNPmypuIoDFG5ak
         kDOKYvfU58JzvNsv5aOTIu8YVAOJTB0wDy+yEoNqC4/C4vaGN9Vg6tajqSGm5J4gxXzB
         91pyyJ95aftcZau+VMYBOEYJBS7kesAqZM3FPG5cS+pTt05Pj7ffnD8bOVOkECGsXj1F
         q4mQ==
X-Forwarded-Encrypted: i=1; AJvYcCWz1irsm2oderTT63kdLlqi90lhm6jUOY4zxBA67IiUcbZmXPZCN5TOXGtyLDRCokehztZTkKbOP1g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTCo1vqKkEdLIi80xOfMNws1uxV3tstGvWTH2hVpNj8/zEqeXK
	RLH9kvwnrbmjiXwIZFCJln5q42drCDUnmOU7Ca9FcqFOfshZXn0iyQmHPtxh4ihLd8/nhhq+RCb
	8
X-Google-Smtp-Source: AGHT+IEF8BEkk0IN+81hYa2ZOkh8wLYdy6mi8kdrGn30rQ6f6oZX06lZ9QaDRhKWfAXT2N9xyRUEdA==
X-Received: by 2002:a17:902:ecd0:b0:20b:51f0:c82e with SMTP id d9443c01a7336-20b51f0ccd2mr150153965ad.51.1727736818492;
        Mon, 30 Sep 2024 15:53:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e4e54dsm59215095ad.249.2024.09.30.15.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 15:53:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1svPGp-00CFN1-1y;
	Tue, 01 Oct 2024 08:53:35 +1000
Date: Tue, 1 Oct 2024 08:53:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix circular locking during xfs inode reclamation
Message-ID: <Zvsr76vifZeNDArE@dread.disaster.area>
References: <20240930034406.7600-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930034406.7600-1-laoar.shao@gmail.com>

On Mon, Sep 30, 2024 at 11:44:06AM +0800, Yafang Shao wrote:
> I encountered the following error messages on our test servers:
> 
> [ 2553.303035] ======================================================
> [ 2553.303692] WARNING: possible circular locking dependency detected
> [ 2553.304363] 6.11.0+ #27 Not tainted
> [ 2553.304732] ------------------------------------------------------
> [ 2553.305398] python/129251 is trying to acquire lock:
> [ 2553.305940] ffff89b18582e318 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock+0x70/0x190 [xfs]
> [ 2553.307066]
> but task is already holding lock:
> [ 2553.307682] ffffffffb4324de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x368/0xb10
> [ 2553.308670]
> which lock already depends on the new lock.

.....

> [ 2553.342664]  Possible unsafe locking scenario:
> 
> [ 2553.343621]        CPU0                    CPU1
> [ 2553.344300]        ----                    ----
> [ 2553.344957]   lock(fs_reclaim);
> [ 2553.345510]                                lock(&xfs_nondir_ilock_class);
> [ 2553.346326]                                lock(fs_reclaim);
> [ 2553.347015]   rlock(&xfs_nondir_ilock_class);
> [ 2553.347639]
>  *** DEADLOCK ***
> 
> The deadlock is as follows,
> 
>     CPU0                                  CPU1
>    ------                                ------
> 
>   alloc_anon_folio()
>     vma_alloc_folio(__GFP_FS)
>      fs_reclaim_acquire(__GFP_FS);
>        __fs_reclaim_acquire();
> 
>                                     xfs_attr_list()
>                                       xfs_ilock()
>                                       kmalloc(__GFP_FS);
>                                         __fs_reclaim_acquire();
> 
>        xfs_ilock

Yet another lockdep false positive. listxattr() is not in a
transaction context on a referenced inode, so GFP_KERNEL is correct.
The problem is lockdep has no clue that fs_reclaim context can only
lock unreferenced inodes, so we can actualy run GFP_KERNEL context
memory allocation with a locked, referenced inode safely.

We typically use __GFP_NOLOCKDEP on these sorts of allocations, but
the long term fix is to address the lockdep annotations to take
reclaim context into account. We can't do that until the realtime
inode subclasses are removed which will give use the spare lockdep
subclasses to add a reclaim context subclass. That is buried in the
middle of a much large rework:

https://lore.kernel.org/linux-xfs/172437087542.59588.13853236455832390956.stgit@frogsfrogsfrogs/

-Dave.


-- 
Dave Chinner
david@fromorbit.com
