Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D664696
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2024 20:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721420491; cv=none; b=k0zgQ8pygvBGs+1m5yShpoTO8oeksQVUXEOBepQS3pajT62etwqNLNA6IyXGFRuGi42WZI5Gf2ZaZw+q7VOmWaABNJrU5ozOW7KsitGlJLnDq5kNUVH16eUmK+ysU4LgXfVRlCUIwSoi19JrJ/Pg04paYb1fEf3O6neRZz/x3QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721420491; c=relaxed/simple;
	bh=2bdZRPhF5gtq5KfiHg0howVDk4CBQylJ5J6dEvTrmyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LtMtAnWFF4QAexLKP3ygdeVg9d1s2b2ROqaHTOtqggZZfr6ZDt4j3pDSfoujkCiBkkjbzUY4odleh+ZuUJHNqzmNDziBwuZ48f7oQN4siZ6VRh8Ul1kjP+/oGiYn2PXgRqvtXz+In93SuvA3GmYhyYVTsq8sRU7E1x7YotD5zjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2TCdCt5O; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2TCdCt5O"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fc5c0c65bcso2266405ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2024 13:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721420488; x=1722025288; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7TdICET9y2kBW1nT7B+XzjYYxpouKddOEs+h65MAYd8=;
        b=2TCdCt5OKCIS7EuMKN79vwojgMKfnqPmPPdiulB4vA2Z/lW0b+20zzTeM9BHoq4JJn
         jfoLXqPZ5fkJbmefze9BhP6r3O7H3NvSnPqNvcn20Oa+kPhfiehj7v7658DY1PO9op5d
         x/EelHr19/xgqDuacjgvej1chxwk4NoU5U3bxYbgNDuSNSzuUE0FkocW91fMAfZGaX61
         SDuEVWy1+QS2gW3L87ss+X8sAh/zIsL6A63OWY05DYiozWle7k04De5K50aGRZ4y58bv
         YtITF1dRFcRZhy5fYsSIMjOQpytLIMC91VAPkQAic89E02MsQ14BynDdS3rkFtxRCYYa
         lAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721420488; x=1722025288;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7TdICET9y2kBW1nT7B+XzjYYxpouKddOEs+h65MAYd8=;
        b=D2Qq7x+x2nBWEB0mK3aPfyl4kXr97h9UF7xIVUqtW/mWEXtLOg3NTdFTokZLwvF7m8
         CIQnxfeVkYQUF8ATHNFIO2PwRU89JMk8zuN2AiFkfQNNdCRl5XbiwCG+ND64VkQrz1vZ
         lggwCISzNU7XCoKQ4DqrVdmXUEN1XisDUJBpNUnI8b9FK72Ea9OeNGH/pYURxeK2V5Ej
         b6HXTZaGigri7yA6JOLfvaIKZ1y0U+q7xnjU6HnlyqJq9IgLZLFMcx1ZSZO+oMVpJGMv
         Qdxi1o82spxUtKk3IgGQVPeQ2evqMR5gFhwILbspeKg36NSA0NeNuXe7K8CWJc/jJ8AO
         BJFA==
X-Forwarded-Encrypted: i=1; AJvYcCVGxm8pblE3ThYYkdlnEWKpARAbRH7nxBy3XZLiQ/WOOti91FBlZpjBo0KqTTjz6eeVTHN/w9wQfYu6JPetklRV9/lXYpw9HfvG
X-Gm-Message-State: AOJu0YwPaotRbVFNJM9+L4/9wRLbnY1thmAslLj77hL6t52PNPhxZixx
	SXziUX26o+FYJvWN4V6u7aHzH07/bXgteP545nSbhwuUX5Eb5hS1aklIu7d2ECs=
X-Google-Smtp-Source: AGHT+IFBmO+K7zL/agidVg2Z92TSxmmwPsuaZhiJ7FdU+invzsnYzP+ED6r48gQMg6agGpkBHJtLpw==
X-Received: by 2002:a05:6a21:6e4b:b0:1c3:b106:d293 with SMTP id adf61e73a8af0-1c42287e800mr783432637.3.1721420488617;
        Fri, 19 Jul 2024 13:21:28 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff552c39sm1565712b3a.136.2024.07.19.13.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 13:21:27 -0700 (PDT)
Message-ID: <173c7d32-2fae-40e4-a1d8-490cee3bba15@kernel.dk>
Date: Fri, 19 Jul 2024 14:21:25 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Slow down of LTP tests aiodio_sparse.c and dio_sparse.c in
 kernel 6.6
To: Petr Vorel <pvorel@suse.cz>
Cc: ltp@lists.linux.it, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org, Jan Kara <jack@suse.cz>,
 David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
 Amir Goldstein <amir73il@gmail.com>, Cyril Hrubis <chrubis@suse.cz>,
 Andrea Cervesato <andrea.cervesato@suse.com>, Avinesh Kumar <akumar@suse.de>
References: <20240719174325.GA775414@pevik>
 <a59b75dd-8e82-4508-a34e-230827557dcb@kernel.dk>
 <20240719201352.GA782769@pevik>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240719201352.GA782769@pevik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/19/24 2:13 PM, Petr Vorel wrote:
> Hi Jens, all,
> 
>> On 7/19/24 11:43 AM, Petr Vorel wrote:
>>> Hi all,
> 
>>> LTP AIO DIO tests aiodio_sparse.c [1] and dio_sparse.c [2] (using [3]) slowed
>>> down on kernel 6.6 on Btrfs and XFS, when run with default parameters. These
>>> tests create 100 MB sparse file and write zeros (using libaio or O_DIRECT) while
>>> 16 other processes reads the buffer and check only zero is there.
> 
>>> Runtime of this particular setup (i.e. 100 MB file) on Btrfs and XFS on the
>>> same system slowed down 9x (6.5: ~1 min 6.6: ~9 min). Ext4 is not affected.
>>> (Non default parameter creates much smaller file, thus the change is not that
>>> obvious).
> 
>>> Because the slowdown has been here for few kernel releases I suppose nobody
>>> complained and the test is somehow artificial (nobody uses this in a real world).
>>> But still it'd be good to double check the problem. I can bisect a particular
>>> commit.
> 
>>> Because 2 filesystems affected, could be "Improve asynchronous iomap DIO
>>> performance" [4] block layer change somehow related?
> 
>> No, because that got disabled before release for unrelated reasons. Why
>> don't you just bisect it, since you have a simple test case?
> 
> Jens, thanks for info. Sure, I'll bisect next week and report.
> 
> The reason I reported before bisecting is because it wouldn't be the
> first time the test was "artificial" and therefore reported problem
> was not fixed. If it's a real problem I would expect it would be also
> caught by other people or even by fstests.

Didn't look at the test cases, so yeah may very well be bogus. But it
also may not... And a bisection may help shine some light on that too,
outside of just highlighting what commit made it slower.

-- 
Jens Axboe

