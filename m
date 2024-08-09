Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2742232A
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 22:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723244107; cv=none; b=uKC6aq0WY2cQ5HkaOANu3JKq4E66fZn92JxVp596qUuqsW3JtIJFC9v0bc7b1g7T9QYzJN6hdOnIb3jJxGRJkKM1xAeu29kRRM0SXsiJSy79LCR+MA1mWPisUvbZknjJWX1dSkJS+6OmV5gewyQVxWtAcX3ZgdNe+zV9LnXXCns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723244107; c=relaxed/simple;
	bh=tNe2LFr/FcocX0SNv8D3Bp6H8lTM7t+jbCnnc23mn40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgCwUWS/6r6ZloOUjWc4JiqxIWYbwsS0Tu6FNz2WKfHlbSnU6dfiGdiK6nCC+1DX2wODt7I6dJp7x/m76ux1NKdpjq+g5hdu+qSPxWSZaeXhpbNQPu1mhMyu2vkoOSIZ0D302fiCvBotkJ5PR3p93itdL37FVhVjDT9KIqTgv94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=F+ensDy0; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="F+ensDy0"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-710d1de6e79so1498462b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 15:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723244105; x=1723848905; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M3U4FJtdTJjwTjN2hjPa6fLm6h455o/oHaTN6sg8QaE=;
        b=F+ensDy0X4c/jjMBEpdAHQi6iAz7rV0xoP2IxcDEXqdbFaLLQsYMsAgAsBT/xTaryM
         gdJW5yW5NTRfJeKdtFRLMTxZz4eASAQKtfrE9TUFg5W38p77WDjFxpZP0nbPtt4u/U9H
         RhPzcL/98XIOcmFm2lxFTa1L8jbVoWAORpBT62kyvB6fXknHCR9mUCpahIfiAcbsgFad
         CIzLFdVeiJ85W4uOd1Y3ctELbY1luUxkp2krLIFHqld4y/rY8pLCudV6xCK01crQ+HhD
         bfTFSdtpHLyAjjHNauAUn8h5cW7QH29PHE7mVgSnXGDLNsi/QMgQNIfGQ6LutfBprdSn
         KPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723244105; x=1723848905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3U4FJtdTJjwTjN2hjPa6fLm6h455o/oHaTN6sg8QaE=;
        b=nD6p247PeLgzOnMOC8STkNThMxsPCTGQkCd4uuxgEAQ2Jq6OJUxWE0wufNYcdKZHQ+
         Scl5lMtpmwhYKMjRnTmcBXMMLun2mQRDflGcIaf37HFfIUTGabQjrywxQhZ3NuRN9jxd
         gZ9KAjx1DYwHsp20ODJ7ZLFAxPTq2dn+Wnl1A9l06mpXoiUyGUZW3KH7nd8uS0PgNdWB
         sRvbHpWJv5oqDuZB5KIOpBHS5RaJeFixFy3yR7opZk5NIlb2GhITl1MScXTiIqOQRZsZ
         WlRX3TpjWQBcGBRqCu7aEu2aHLj26RWaaFGk6YFOIpKGejWDAKDzg27ZQ/HFRc0feU5j
         RL/A==
X-Gm-Message-State: AOJu0Yz+ZObAsg0IjBpc60T0RzRctMMFccf42Wc8rSXULBoeQIWr6X+6
	fujEhZpOU+ghVCZJM/Gc+hsc03militkxWNZVSRauiNLvYI6jv3IGPG9KO3GvF8=
X-Google-Smtp-Source: AGHT+IGho8K4vEAF3AslwLv4ESQL8Sw02109Qz2/iziyqFknPsWj2z3zBpe9Ptc5YgDmlGGLNoHuaQ==
X-Received: by 2002:a05:6a00:1389:b0:706:65f6:3ab9 with SMTP id d2e1a72fcca58-710dcaeffb7mr3701018b3a.20.1723244105055;
        Fri, 09 Aug 2024 15:55:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58ca6a3sm268190b3a.90.2024.08.09.15.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 15:55:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scYVh-00BPfA-29;
	Sat, 10 Aug 2024 08:55:01 +1000
Date: Sat, 10 Aug 2024 08:55:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anders Blomdell <anders.blomdell@gmail.com>
Cc: linux-xfs@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: XFS mount timeout in linux-6.9.11
Message-ID: <ZraeRdPmGXpbRM7V@dread.disaster.area>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>

On Fri, Aug 09, 2024 at 07:08:41PM +0200, Anders Blomdell wrote:
> With a filesystem that contains a very large amount of hardlinks
> the time to mount the filesystem skyrockets to around 15 minutes
> on 6.9.11-200.fc40.x86_64 as compared to around 1 second on
> 6.8.10-300.fc40.x86_64,

That sounds like the filesystem is not being cleanly unmounted on
6.9.11-200.fc40.x86_64 and so is having to run log recovery on the
next mount and so is recovering lots of hardlink operations that
weren't written back at unmount.

Hence this smells like an unmount or OS shutdown process issue, not
a mount issue. e.g. if something in the shutdown scripts hangs,
systemd may time out the shutdown and power off/reboot the machine
wihtout completing the full shutdown process. The result of this is
the filesystem has to perform recovery on the next mount and so you
see a long mount time because of some other unrelated issue.

What is the dmesg output for the mount operations? That will tell us
if journal recovery is the difference for certain.  Have you also
checked to see what is happening in the shutdown/unmount process
before the long mount times occur?

> this of course makes booting drop
> into emergency mode if the filesystem is in /etc/fstab. A git bisect
> nails the offending commit as 14dd46cf31f4aaffcf26b00de9af39d01ec8d547.

Commit 14dd46cf31f4 ("xfs: split xfs_inobt_init_cursor") doesn't
seem like a candidate for any sort of change of behaviour. It's just
a refactoring patch that doesn't change any behaviour at all. Are
you sure the reproducer you used for the bisect is reliable?

> The filesystem is a collection of daily snapshots of a live filesystem
> collected over a number of years, organized as a storage of unique files,
> that are reflinked to inodes that contain the actual {owner,group,permission,
> mtime}, and these inodes are hardlinked into the daily snapshot trees.

So it's reflinks and hardlinks. Recovering a reflink takes a lot
more CPU time and journal traffic than recovering a hardlink, so
that will also be a contributing factor.

> The numbers for the filesystem are:
> 
>   Total file size:           3.6e+12 bytes

3.6TB, not a large data set by any measurement.

>   Unique files:             12.4e+06

12M files, not a lot.

>   Reflink inodes:           18.6e+06

18M inodes with shared extents, not a huge number, either.

>   Hardlinks:                15.7e+09

Ok, 15.7 billion hardlinks is a *lot*.

And by a lot, I mean that's the largest number of hardlinks in an
XFS filesystem I've personally ever heard about in 20 years.

As a warning: hope like hell you never have a disaster with that
storage and need to run xfs_repair on that filesystem. It you don't
have many, many TBs of RAM, just checking the hardlinks resolve
correctly could take billions of IOs...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
