Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B053B295
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 09:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716801776; cv=none; b=tBITyGICmQCi0jz/vQ/GburiaeE24JKm3sFPXx53FssD3kIfk43W7G7/un82CXIEWIjhrxPuSNcAqpUglB+s3SWVWxFg3hBR6uuF1PMtWFp8lMGsD3zCrVfs/xjzjDHwhLTAhhu2u0rmOMSNLG2LNVrGgE4jka1WtV+8hVXSGxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716801776; c=relaxed/simple;
	bh=Irw72qnjzCiDrkn8xJNVAndXCKXYUfjW4pvDmgE9Q/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ga8UfFzjy4hyQH0xa0ME7KZ4zfXl/ahAqLD4aYtuKkdDVUBVoj5nyhNCeJhPUVWvU2GhLMnS/RraGtbx5j3NIWeqOuuNBXqeOawNj4HEtVYyTeQzeLw3i53ft+sM/6wvaBaPay/iLdAPzaCp+CqZu0zR5swsRqH1RfT4dn/V+aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wouzl9vK; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wouzl9vK"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2bde636ddc2so3082025a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 02:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1716801774; x=1717406574; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gZoZWr1Vh12blhESF5X1LZQugFHlNJncqtcHdAI5v7g=;
        b=wouzl9vKIqLWp+FaisisawMgc2DAxSLVI/KVslIlPjW47GO81Bvl9WewhYg9Dp7AVv
         46SUY4GQhQByOwmy+XneYeHp9acJ19ATbERR/Rzo1f5nWFPtXwEMiU7o2bHg6UJ80AFe
         GvU0nrTMv4j6n1hlKEErP3qfhEctK1ToLhFHelscLcJhftYOUP4Qt8j5+NWiG0yCvaEd
         2MBcn+5bTmnOsBZf0dqBsDEk51TI1O6xueKV2lfx8JP/JzDrDbV5gFOrS68NaD7RjPp9
         eWq7czOQ0qmuFpJIPzn5a2w9zNiofWuaClrJz1fQ1c6vD48P1tpSdvRJYwlZpZa6GfU8
         Xy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716801774; x=1717406574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gZoZWr1Vh12blhESF5X1LZQugFHlNJncqtcHdAI5v7g=;
        b=bUPMRX9ti8S1dsjXDq2QiunxNbqcFkGvzZr5uYLN3Qfs17bLXYJi9RvYPEmZ/AGPG3
         3ud73wEkXTPxF3rKwZnAbJIcRl6fearE7ou8ywQYCKHT33c0pRCHJ4hqHwIO7FiYLWaP
         mDD1wlFVzwwe3W0P8Mnekpq2XW2mIwEdyE39oI5lnBjSrR8pchhdGOQeBGVnyikO2DMK
         Q+ICFERdql5eFceGprtpg2m1SiYgxcOdJJXcxxA3YDu2RfClWkpLfrh9cigdtCpvtRbo
         HJ2aPKYgAnoykI1wvsaZzi06dQFlg/uJ/NX/4+6pjUvbDmVVSuUNg3SEBehMWR3ycsyo
         0vDQ==
X-Gm-Message-State: AOJu0YzVdvLpulxH3Gn166QStnYSbdHfx6IkLE/z24S1JYAsb3xIzAzN
	Y4MiL+B4lc2e/qi1G7cda76aOJoOfAt9p/itwoIOf+g6pk2B8rYjOH9DFG4vHeG41mN7RgXVgTV
	8
X-Google-Smtp-Source: AGHT+IEIqBh2zqLXCPkNIKJYAJWl3jrtI9OWJOk7lB39bWNq025EcdFNiwYaLFjpmAw3ZVh4cpAT6g==
X-Received: by 2002:a17:90b:33d2:b0:2bf:ebf5:c9d4 with SMTP id 98e67ed59e1d1-2bfebf5cb71mr594734a91.42.1716801773684;
        Mon, 27 May 2024 02:22:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf72ac197bsm4870094a91.23.2024.05.27.02.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 02:22:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sBWZ7-00C9K0-3B;
	Mon, 27 May 2024 19:22:50 +1000
Date: Mon, 27 May 2024 19:22:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	djwong@kernel.org, lei lu <llfamsec@gmail.com>
Subject: Re: Fwd: [PATCH] xfs: don't walk off the end of a directory data
 block
Message-ID: <ZlRQ6W8BlfZ+3rWs@dread.disaster.area>
References: <20240524164119.5943-1-llfamsec@gmail.com>
 <87ikyz7tvj.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ikyz7tvj.fsf@debian-BULLSEYE-live-builder-AMD64>

On Mon, May 27, 2024 at 10:05:17AM +0530, Chandan Babu R wrote:
> 
> [CC-ing linux-xfs mailing list]
> 
> On Sat, May 25, 2024 at 12:41:19 AM +0800, lei lu wrote:
> > Add a check to make sure xfs_dir2_data_unused and xfs_dir2_data_entry
> > don't stray beyond valid memory region.

How was this found? What symptoms did it have? i.e. How do we know
if we've tripped over the same problem on an older LTS/distro kernel
and need to backport it?

> > Tested-by: lei lu <llfamsec@gmail.com>
> > Signed-off-by: lei lu <llfamsec@gmail.com>
> 
> Also adding the missing RVB from Darrick,
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

That's not really normal process - adding third party tags like this
are kinda frowned upon because there's no actual public record of
Darrick saying this.

i.e. patches send privately should really be reposted to the public
list by the submitter and everyone then adds their rvb/acks, etc on
list themselves.

> 
> > ---
> >  fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> > index dbcf58979a59..08c18e0c1baa 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_data.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> > @@ -178,6 +178,9 @@ __xfs_dir3_data_check(
> >  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
> >  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
> >  
> > +		if (offset + sizeof(*dup) > end)
> > +			return __this_address;
> > +
> >  		/*
> >  		 * If it's unused, look for the space in the bestfree table.
> >  		 * If we find it, account for that, else make sure it
> > @@ -210,6 +213,10 @@ __xfs_dir3_data_check(
> >  			lastfree = 1;
> >  			continue;
> >  		}
> > +
> > +		if (offset + sizeof(*dep) > end)
> > +			return __this_address;
> > +
> >  		/*
> >  		 * It's a real entry.  Validate the fields.
> >  		 * If this is a block directory then make sure it's

Nothing wrong with the code change, though.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
