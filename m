Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC81E30F7E9
	for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 21:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757539185; cv=none; b=r4USmMhRbCGBuCSathM5ue7ZKjl2vx6Kun6aQfYpqH+hGq1fXe9tG5qnsYbWp6a4j/Mf2nW9o2QW7mzCthHpetArH8v75VnU7ydmdAymWNMePGuNVQmxjUOtHHplBrt7v891Mlycqic32PitW/2BSOWXc7iksfkIDMK6WxMSzrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757539185; c=relaxed/simple;
	bh=LZ6N28lJoqpdb+Wn8DdRBooagZvVyHpQGBAMKqBiRHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIYK5PIHSb2Egf6zQThsiEjBVFubUVzFRFVNcLUPfRdsuO81Jk5Ce6NVG6Y5quAMrZ0PTm8HRe4/KGyT9juZwf+C95WMjBu1QQZnxaGLZeRifWUj+H5c+A2SeFHwm1t85WPydoRMhjSHzHRyy/J0iuZkUjeaQot5fNadWUwUkf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=bd/Avetp; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="bd/Avetp"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2518a38e7e4so14196365ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 14:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1757539183; x=1758143983; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OvEuUZLzmW4C5aJ2WQ6JY0uejkTJQilGmiZJ65xM0KY=;
        b=bd/Avetpop1ncpDopJZthxrKL3ljbSjDyLgeWvzPKmuwT6jNvyFH8Fh54HlddgE+ZS
         EAOy37KJowLEDUiW5FBBAEWnZN+E6+o8UBSZTBj0o6oTR94FXN/4tsdt1Lhme/LZUeQC
         qYAw+JelA2GnA1PIFJK2R/GTKudYRlv/v6oyMwqm9PDv8kFkGXK0bMGlRAd09oWHwx2e
         PwfIwzXyZNtEMpxZsWLDjYWtY1GZXzBhzehBK8Ns0FrQUMwUfdSVK+IE8na4rgOjNr+G
         q655dmuclLilWHW8VpdAQjCMPT1kiLLHJCRqFbuHNHzbsHVLNaz92c8MWCXmbncncHCN
         w6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757539183; x=1758143983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvEuUZLzmW4C5aJ2WQ6JY0uejkTJQilGmiZJ65xM0KY=;
        b=luFoR+x3gOIC/EQ/mohe0SLQdlp1HcGLvIQEmOHik1lzVxwh+FsrdXr8pn1TnhgCIb
         v1/4k5J/5Bqfw3ZYO97uk5HOigPiEcz8kkCb4hdMOYxnelDwTvhuH+jcMb4XXINbFWTr
         91jSbLJf705uB0V1ZxqvOwVwivJUFv7HX5nkv/ll5rA+hKKhhEz1+fVaMVBs377whUkw
         4z/Oqii8PQxOebvolPbtiMyds2FpcJe0zYJQIDJL87WRwvpOXM7xlZQnGnIXsFsC4di/
         PMEM57WYm5rn5ltixV0g1ow1P74sQe4JrIMZRRo0O3unMMoodkBRoaw7MHMiWANRVNIa
         7mQg==
X-Gm-Message-State: AOJu0YwddrgsdQLi/WZEeKLocIqKQlVVFQV2xrTFd6IufnmccCD4eyuX
	EI6RSr7/5ncCfDSLiZj3yZXke/PATzGQcJbMc++q4ftQ8eUG2bYDeLhhMhU8r6zvLmzPQPDBrQY
	5cITa
X-Gm-Gg: ASbGncu3BJjLP6Z/nLkakHaPT2s7+YHagtreAXyAGeuB+ADQr/UUVa/nILikXxWZ+u5
	Nm2AXH0sgI9xnh5Kzyv2/ev+Qow3TRQc45BpQSq4B213gx+wbyCjL1HL8ffEfX10Rya/MUPehJm
	rz5KgUzLQm/Gqd1CGRHZgW3X2/V/7adA6G0Gilh0vMAtp+khRwGJyENQcC8kzUOgJfehpeMFq+6
	e0KQnn1UAwE9zS95+o5qA+Yoj/vsqJW7hpYYRsnJu/CQj8rAF49fbV+MoHoDUfExlH4LhzNW9hP
	/MBYxdEgSj2tRnVk0lGaQk1yeTeekRGXv6Bi76gR3ZRKLVXsSatPA5n7g6HFoCi1nkhp0yfgDNl
	dMKyYZZ0o5jyIEJHzy5ZVMtsJ+cT48vWTc6rvuJKrpegWD39gErHGSlM62bBnrBTxXYcVSmfRVw
	==
X-Google-Smtp-Source: AGHT+IEfqCipG+kiM5S2Vd11YJuG9qk/B/bqW/MdTaH+qrUljL9IiBgp6H8ah3LkDYk5frNNOgAxDQ==
X-Received: by 2002:a17:903:2bce:b0:248:ac4d:239a with SMTP id d9443c01a7336-25bad27fa51mr12031685ad.18.1757539183168;
        Wed, 10 Sep 2025 14:19:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422e30sm37082015ad.23.2025.09.10.14.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:19:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uwSE7-00000000Grb-3vKF;
	Thu, 11 Sep 2025 07:19:39 +1000
Date: Thu, 11 Sep 2025 07:19:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: clearing of I_LINKABLE in xfs_rename without ->I_lock held
Message-ID: <aMHra0oELOSN3AxP@dread.disaster.area>
References: <CAGudoHEi05JGkTQ9PbM20D98S9fv0hTqpWRd5fWjEwkExSiVSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHEi05JGkTQ9PbM20D98S9fv0hTqpWRd5fWjEwkExSiVSw@mail.gmail.com>

On Wed, Sep 10, 2025 at 11:40:59AM +0200, Mateusz Guzik wrote:
> Normally all changes to ->i_state requires the ->i_lock spinlock held.
> 
> The flag initially shows up in xfs_rename_alloc_whiteout, where I
> presume the inode is not visible to anyone else yet.
> 
> It gets removed later in xfs_rename.
> 
> I can't tell whether there is anyone else at that point who can mess
> with ->i_state.

No-one else can find it because the directory the whiteout was added
to is still locked. Hence any readdir or lookup operation that might
expose the new whiteout inode to users will block on the directory
lock until after the rename transaction commits.

We really don't care if the inode->i_lock is needed or not. We can
add it if necessary, but it's pure overhead for no actual gain.

> The context is that I'm writing a patchset which hides all ->i_state
> accesses behind helpers. Part of the functionality is to assert that
> the lock is held for changes of the sort.

Yup, the version I looked at yesterday was .... too ugly to
consider. If I've got time, I'll comment there...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
