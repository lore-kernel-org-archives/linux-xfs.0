Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4EB13D24D
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 12:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719837313; cv=none; b=QqyxjhCbYyxE3qHM65fLa0BPHo8f6aDRLn6dyVcfXXdaOEQpTMGpQBiXyxQkexyOph4Cx36oQE9pwKp1kZ5oT0pb6NfgjxHkx5vzgnddEEWNiYkImXTHt/RKLweKR6v8NrAlx5cuqwhpOtWBpRmEIB/rlOxAl+cryl+TaebrYSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719837313; c=relaxed/simple;
	bh=mZeO1f7tTznVKqOD4SvW+UN628jwmIqb6IO7RYHEuNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2ZSP1B6mrmAGKqCIHA5Hhgb3tn72MboaJyu7+1GejW9WcSVqoaycRULFWJFw5fJnnI15h1JrKWZf4YGNLV80k6goForfhqQBz1ms0z00M0xyt+gPTwsFDVnsKWce/32XqK4jDBeTYIyFZR7UvE5z3rww63Ah703DpLxN/P8Nk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pAfHIgjF; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pAfHIgjF"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f9de13d6baso15809785ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2024 05:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719837311; x=1720442111; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Srvua/8GiZk2f1lRDes3KQDNlajTOwOOiszOgYhtkE=;
        b=pAfHIgjFp9YUT8lsILQhKGdJNkOLEeH4L8svf4d7mBWVb59VOY3lbu9C/Z1NNsk2us
         jvlz9Goy9AqnLoTwfqdsFBOUpoL48O0ve9S9guulN7+IwahnQLJRRdHbTwAklM5knKmb
         jTRPBEv9DUtSETpgv1AVNa74gsPS2TR0+AGrrCjxn/XBceocNim3OrAIWAedMk6jZSfP
         1sqaDRQYZ2LtmFjo+OE1LZxHtgz/e4kFrNGjZyNGQfwvs08n30ZwUosJfGYD9N6emHmk
         UJkzRuJLYvs1ZFpPQ558CgrO03/VplZ9uVgHRZDMAg59xSH23RYkhcOgvYRoZbQPkbH6
         tnxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719837311; x=1720442111;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Srvua/8GiZk2f1lRDes3KQDNlajTOwOOiszOgYhtkE=;
        b=CbBIJeg3Xxz8JteaDnZzqGIl9byhmoa5THCA5sAW/jRE1ZER4ETKefQ/kaGMqiH2Sm
         wGCqn23uVFTF06Lfe09oDmsKHYp4Hx8utSkTvNQnYoSNuVO+zY6JUsqW6qUltHCsClCb
         iNAum7TPRAgQKQp+6UvZV/s8/EQSNCFpaSE9ztH29J8n/pLrZBNuuKOW7/juSu782FSp
         hUvvWt7IzooDuccz4uuW/cwWHC8g7l7vyWt3pzAgLXiRZ+uzrGw5S96d1VW9GsSaBLzE
         0SEb9FYWbO/4UyPNMUJ2bSF2594YgDZQUu0ofE8LaDar3WHh6OgRiE+HDjxvmPaDEGtl
         91dg==
X-Gm-Message-State: AOJu0YyhY/Ml5m5uLx0PBgJ54S0vjZIoCB/wtQ/JwwcgXbMYz9t/kRrM
	k9GwazLzpQ5r2lW+1OIM37C8RhP8pv/U1hpZcZJ9SniSR1Fhi2Qj/HKXjbVnuzQ=
X-Google-Smtp-Source: AGHT+IEDTYyht4xal4sRk0Ri79tyKeyIeWLDUvtqY7rzls4XH1cjLoNZcE3nJnryOV0CB94f4AEujg==
X-Received: by 2002:a17:902:cec5:b0:1fa:95d6:1584 with SMTP id d9443c01a7336-1fadbca398dmr31822695ad.37.1719837310840;
        Mon, 01 Jul 2024 05:35:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac11d8cbbsm63560625ad.106.2024.07.01.05.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 05:35:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sOGFP-000KA4-33;
	Mon, 01 Jul 2024 22:35:07 +1000
Date: Mon, 1 Jul 2024 22:35:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
	brauner@kernel.org, chandanbabu@kernel.org,
	John Garry <john.g.garry@oracle.com>, jack@suse.cz,
	yi.zhang@huawei.com, chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH -next v6 1/2] xfs: reserve blocks for truncating large
 realtime inode
Message-ID: <ZoKie9aZV0sHIbA8@dread.disaster.area>
References: <20240618142112.1315279-1-yi.zhang@huaweicloud.com>
 <20240618142112.1315279-2-yi.zhang@huaweicloud.com>
 <ZoIDVHaS8xjha1mA@dread.disaster.area>
 <b27977d3-3764-886d-7067-483cea203fbe@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b27977d3-3764-886d-7067-483cea203fbe@huaweicloud.com>

On Mon, Jul 01, 2024 at 10:26:18AM +0800, Zhang Yi wrote:
> On 2024/7/1 9:16, Dave Chinner wrote:
> > On Tue, Jun 18, 2024 at 10:21:11PM +0800, Zhang Yi wrote:
> >> @@ -917,7 +920,17 @@ xfs_setattr_size(
> >>  			return error;
> >>  	}
> >>  
> >> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> >> +	/*
> >> +	 * For realtime inode with more than one block rtextsize, we need the
> >> +	 * block reservation for bmap btree block allocations/splits that can
> >> +	 * happen since it could split the tail written extent and convert the
> >> +	 * right beyond EOF one to unwritten.
> >> +	 */
> >> +	if (xfs_inode_has_bigrtalloc(ip))
> >> +		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> > 
> > .... should this be doing this generic check instead:
> > 
> > 	if (xfs_inode_alloc_unitsize(ip) > 1)
> 
>         if (xfs_inode_alloc_unitsize(ip) > i_blocksize(inode)) ?
> 
> > 		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> > 
> 
> Yeah, it makes sense to me, but Christoph suggested to think about force
> aligned allocations later, so I only dealt with the big RT inode case here.
> I can revise it if John and Christoph don't object.

Sorry, but I don't really care what either John or Christoph say on
this matter: xfs_inode_has_bigrtalloc() is recently introduced
technical debt that should not be propagated further.

xfs_inode_has_bigrtalloc() needs to be replaced completely with
xfs_inode_alloc_unitsize() and any conditional behaviour needed can
be based on the return value from xfs_inode_alloc_unitsize(). That
works for everything that has an allocation block size larger than
one filesystem block, not just one specific RT case.

Don't force John to have fix all these same RT bugs that are being
fixed with xfs_inode_has_bigrtalloc() just because forced alignment
stuff is not yet merged. Don't make John's life harder than it needs
to be to get that stuff merged, and don't waste my time arguing
about it: just fix the problem the right way the first time.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
