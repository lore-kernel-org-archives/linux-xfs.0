Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4A126C05
	for <linux-xfs@vger.kernel.org>; Sat, 28 Dec 2024 22:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735424249; cv=none; b=tHhP1kBXGixjfNFoVNRwb/e6XCPtra2QbgDmqPMypreUbYvb9uVvgrcOVRf0n4dbxAjwhXPxcrlKB40ngZtazthpPzIRAn9aU1geCwTtli//tD9PZosEBbbbcp3XpT/YhyPCn0hamQlKO5p/6F7LHpFbUu4zpR2MJbnmTnby2+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735424249; c=relaxed/simple;
	bh=lEO+UbC4ocaAVqsDjSaxCDJuHRh1ebUarxKb8n7HoDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxavMW58NmvX6lmS5tSmqLv/aFGUwTRJS4HARaeSTN8F0wkU8K+kKAl+Zj9zq6zi3yd37zL6y3u57kuJf74vbjf2cLjWiZ0CM3qAn97sIeBjaBVnToYZ+VwHt3HswCwmLqY7MHgwF2yD/7b9ZQ9Bc/HqiDE6L1rj/6D3uUNMZ4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=TVF2rZmy; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="TVF2rZmy"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ee50ffcf14so9644702a91.0
        for <linux-xfs@vger.kernel.org>; Sat, 28 Dec 2024 14:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1735424246; x=1736029046; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IZ129VWY3npg/e3sCrjFNNSft+JjjDx3ErRjyMihN80=;
        b=TVF2rZmy6Td6Q5npl3MENPmApGgZS6DX7ByHtIkdMc77zlPFQI4/5SFR45QR6rKVmH
         7fdd+RoV84tvIVg1AVKzlYW1T5HIyXonX5bK/KcqbOZh0k1e7hIUH5t8/ZTrEsPwBQ2d
         NWBMCOzOFbafjLFJTffvsMYQnb8ZQ43uWqqsUtlBzWoWpmZrBlj+yKUCj58VCU1oK5o1
         7n2Yo1XChowvNrw9J+TR83NBdZFcHwMm5nRfaEyzlASnj61qMvt+Qy4zDLKUvW3jDlT5
         Vjp7sgxIFiPUyUxX1j9+pQycmkfUSXEhHnahr6oW6h01B2MN8US1AyTGuoZnQc83T626
         GX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735424246; x=1736029046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZ129VWY3npg/e3sCrjFNNSft+JjjDx3ErRjyMihN80=;
        b=kkm0aveolIPbJlJ5Qlsm6+FEJNeRfrn5ADqXDX7KvyF8f4VbeMkIXyllP1MunfWlGY
         Qfap0AQdhk03Ds7L7z9Yl2+M/ocFgB/jl5C6n4Lxm5YDO1/DUaRq8WZaPCXLXyEDls6p
         QmQheizOKWN9a01OcaJ7cpv46nZmWgve04vQDrNwWP5P745BT7axI9HK+l97rMseTWzA
         5GZpuPlR+wVFTUMEE7LH1NcyPC5LNTei4SXjV2FdM1Z/+7ujUVyuTFmGgdLho5xxoxSD
         24mHQ54iWC9q6Pw7LUZM+x4UpVsdrOAubgqdgnKFkDsLB1YBB8KHeyqTPuf45HEVvYsl
         oJ5A==
X-Forwarded-Encrypted: i=1; AJvYcCWh+jBZr5bgLQubkU/HLxnFyZ3aSmb4RLVMPP1bqwuOfdzgT+KFphYQvEM47Y57wie+SBp1/L+Pj98=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFpSL4toZWptpB+eu5hpXi22BKgX69K9SUMhzWct/bXB8mK5Gr
	h1Q8/2v8HDvEx5jlF3gEtEafiuTwActJAvQYZVC5OhOwC2uHhHuNy3aLmiLGp4o=
X-Gm-Gg: ASbGnct466iVqgSEVhztkv3vM1rDg7Ls/QxlZLrv6SmyTsHwWVBxWO6dlI8mMiM8oB9
	TfcH4cabBXh8cI/bXmPD6weQXJSK4CrcQRD3iiZt82CwMaF6J/hyh5dGAmXXx1+0n43qbhO04Dq
	0T1yr7bFbocOlr6cvWQwg3oMADy+nhGq45KlNEKAct4Bz+HcTIpISQkXlLsTCKkqkvVO/dk9xcu
	ZOI74AqcrAFSQBnzRSQfgpqeZt46GDfnkULs4V5YmOr557o3HYY3GzWgHAPNbFIEzEaDkdfNaBM
	R8LQG5NmMdXC0ULtV8mfBuaMOB7t5yjg
X-Google-Smtp-Source: AGHT+IFJiy4ioeYTsqxF1/sp83aQq1iKCHAIGzl5ylEkwVRvegDsq6+zqy8usgWzMuOH1G/iafoDJw==
X-Received: by 2002:aa7:8b43:0:b0:725:4915:c10 with SMTP id d2e1a72fcca58-72aa9addf8emr47463706b3a.10.1735424246545;
        Sat, 28 Dec 2024 14:17:26 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8daf26sm16598790b3a.117.2024.12.28.14.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2024 14:17:25 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tRf7b-0000000GW1B-0dbg;
	Sun, 29 Dec 2024 09:17:23 +1100
Date: Sun, 29 Dec 2024 09:17:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chi Zhiling <chizhiling@163.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z3B48799B604YiCF@dread.disaster.area>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>

On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
> 
> 
> On 2024/12/27 05:50, Dave Chinner wrote:
> > On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> > > From: Chi Zhiling <chizhiling@kylinos.cn>
> > > 
> > > Using an rwsem to protect file data ensures that we can always obtain a
> > > completed modification. But due to the lock, we need to wait for the
> > > write process to release the rwsem before we can read it, even if we are
> > > reading a different region of the file. This could take a lot of time
> > > when many processes need to write and read this file.
> > > 
> > > On the other hand, The ext4 filesystem and others do not hold the lock
> > > during buffered reading, which make the ext4 have better performance in
> > > that case. Therefore, I think it will be fine if we remove the lock in
> > > xfs, as most applications can handle this situation.
> > 
> > Nope.
> > 
> > This means that XFS loses high level serialisation of incoming IO
> > against operations like truncate, fallocate, pnfs operations, etc.
> > 
> > We've been through this multiple times before; the solution lies in
> > doing the work to make buffered writes use shared locking, not
> > removing shared locking from buffered reads.
> 
> You mean using shared locking for buffered reads and writes, right?
> 
> I think it's a great idea. In theory, write operations can be performed
> simultaneously if they write to different ranges.

Even if they overlap, the folio locks will prevent concurrent writes
to the same range.

Now that we have atomic write support as native functionality (i.e.
RWF_ATOMIC), we really should not have to care that much about
normal buffered IO being atomic. i.e. if the application wants
atomic writes, it can now specify that it wants atomic writes and so
we can relax the constraints we have on existing IO...

> So we should track all the ranges we are reading or writing,
> and check whether the new read or write operations can be performed
> concurrently with the current operations.

That is all discussed in detail in the discussions I linked.

> Do we have any plans to use shared locking for buffered writes?

All we are waiting for is someone to put the resources into making
the changes and testing it properly...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
