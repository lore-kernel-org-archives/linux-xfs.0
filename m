Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3901AED5C
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 20:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742244231; cv=none; b=MmgaXltJDHiiwRmLcbpzs0aNlZRx3+V/qspu2pYsJw1pMJ5nf7ksSPgvuqso0UkVFs9P3BGTzACsV55jsgADIm86BMNDslwykdsvhbFMkQsv5FUGMkG//sKPZJ2kZQW1sOnHxb+igmnfRN0J1EcflQwEyQIlg3Md0dAt4Dryu+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742244231; c=relaxed/simple;
	bh=8AUltKcin28VsFt6sJNwICCxUyt1gFwAnOr1SRh6GQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YwzrD7NVYkvhrYLkhPxfR+zNaXF9dXnSZaukji/A3hMC/JNtfO2ksu8dNX4CDfIpiY+5Nx65MAzbcX6RB0S/rjNA3arc9BMtQ7iuzGHnQMOSWIsHfHcMWR3pdlbcRkrrPA/RhxSsXevi/lXNS1o3RlKZzmdqAtDdh/TPdJBV0V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=As3M/uK9; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="As3M/uK9"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-225a28a511eso81279635ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 13:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1742244228; x=1742849028; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ICGiZBC/D3ETV9tIUOC65OvLmmQ8G9998JUJgGnYOtc=;
        b=As3M/uK97QpgHQw57W34zo3nvfzI8FThYzEIkgrKwtLFQeYxUMCHb6HOYMijS2k8Wg
         1Bmq//K4qG1NtjAjmgbOKLq+h0gJ4/jCKU6ON4GHmNct0gEdLSQWcYHlqddjZHNhIBF/
         ADB6b+AsUHkFGSgl666/rJUQNId83MLxtx0bN7iO0bMjBTYTxXYimKBGqpouD3spuD8y
         agwja7glTqeatDvCgfzMxRZaNvyvrWwuMgro39z4rY6oI5rTFDd6houknWhIhDUzqw0i
         /HUR7XwdfAund+Zny48hH/wG45ZbZ1AfPEp7XJ45RloYSdO8ZHlXdEenTtqZ6kYNx4u4
         zhFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742244228; x=1742849028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICGiZBC/D3ETV9tIUOC65OvLmmQ8G9998JUJgGnYOtc=;
        b=LNB+7pVUUWyMm1geE62nj/W0NHf8qTMJ3zcCVL8iqWdlJ2sd+mQ/0AhEd3C1A7xIV0
         5g0X+sB2Tikr6ub0Y/ZXQgTPmLpHlHHZL4V3qCN2BaigmdVZJy7NWVxaI/VIuhbJ6Bah
         d46cKuY5w45PWaNXGeSV1QJfLXfW8LVvlsAiOzxOqTgHurIuNmqU/PxlVKRZyT+qg5IA
         pWXGCWpjj1kYCouluZcddEA6Rv5NyW8rl+3lxHnCAyPTktWjVa0Wrbu/l1XvACKVVsVF
         qsmjZ0XMitNqWqCjZyB7TTpA7yXBhA+6iY/BO7D0t2+njhf2jBHJYRr0JMmSmWpYUpoG
         WUxQ==
X-Gm-Message-State: AOJu0Yz+O+yw4lHD0Loiwv0kYc1sgYzM/kRPj2wrKZt7WLMbxTbTId+B
	IJpYuGCE/co4EX5Q01pMmfDp+Eyj8Vaw2D8rB+1wO49kvjaN629D6+HDOg1VxYw=
X-Gm-Gg: ASbGncvX9yuk7UMkH5NlsXWZHxzY7LYoMZOQxxmpsH9yxmCNg9FVy4dOAZLS4kHbKYt
	7ojUyEVOk7Zv5joojSSoRCMcplEfl+pLhF4kRssOY9OqB8a8O8BslhKMALiZjiOCrj4sgxwbFXo
	1t4Amfkf2mpIdOi6oZDhlJpNtgTKT6nTfWZkcEKwRSZM3h5aeVQbB1ncYOS728KJrhKO3qjRFdv
	u8kzHSggfN2WjLR9j7eK3A/lmYhTRBSHtYdjecP0hvLv3SOvDRwRdh+syCjSMSaxEuXz8r6iJee
	de5pJnXthnDS8aSkU3hp7U/ZHDKtqWH6eHGJXjQAAYi3H2jJkUagM65C01YtSnw6b1WHwDOAJpK
	9xSp3KNJyHtZyVd/kjUxD
X-Google-Smtp-Source: AGHT+IHnmxSvLVauoC7NEp2f6+Zh27dTBrcjdstNC5AA+xWtC2wCOq4iKwyjhcbTVvsZNVMEgzw8zw==
X-Received: by 2002:a17:902:ea07:b0:223:53fb:e1dd with SMTP id d9443c01a7336-225e0a19b81mr161686435ad.9.1742244228451;
        Mon, 17 Mar 2025 13:43:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-36-239.pa.vic.optusnet.com.au. [49.186.36.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbfe22sm80084525ad.206.2025.03.17.13.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 13:43:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tuHJJ-0000000EQX1-0JGv;
	Tue, 18 Mar 2025 07:43:45 +1100
Date: Tue, 18 Mar 2025 07:43:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>
Subject: Re: [report] Unixbench shell1 performance regression
Message-ID: <Z9iJgWf_RL0vlolN@dread.disaster.area>
References: <0849fc77-1a6e-46f8-a18d-15699f99158e@linux.alibaba.com>
 <Z9dB4nT2a2k0d5vH@dread.disaster.area>
 <fddda0be-3679-46ae-836c-26580a8d55f4@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fddda0be-3679-46ae-836c-26580a8d55f4@linux.alibaba.com>

On Mon, Mar 17, 2025 at 08:25:16AM +0800, Gao Xiang wrote:
> Hi Dave,
> 
> On 2025/3/17 05:25, Dave Chinner wrote:
> > On Sat, Mar 15, 2025 at 01:19:31AM +0800, Gao Xiang wrote:
> > > Hi folks,
> > > 
> > > Days ago, I received a XFS Unixbench[1] shell1 (high-concurrency)
> > > performance regression during a benchmark comparison between XFS and
> > > EXT4:  The XFS result was lower than EXT4 by 15% on Linux 6.6.y with
> > > 144-core aarch64 (64K page size).  Since Unixbench is somewhat important
> > > to indicate overall system performance for many end users, it's not
> > > a good result.
> > 
> > Unixbench isn't really that indicative of typical worklaods on large
> > core-count machines these days. It's an ancient benchmark, and it's
> > exceedingly rare that a modern machine is fully loaded with shell
> > scripts such as the shell1 test is running because it's highly
> > inefficient to do large scale concurrent processing of data in this
> > way....
> > 
> > Indeed, look at the file copy "benchmarks" it runs - the use buffer
> > sizes of 256, 1024 and 4096 bytes to tell you how well the
> > filesystem performs. Using sub-page size buffers might have been
> > common for 1983-era CPUs to get the highest possible file copy
> > throughput, but these days these are slow paths that we largely
> > don't optimise for highest throughput. Measuring modern system
> > scalability via how such operations perform is largely meaningless
> > because applications don't behave this way anymore....
> 
> Thanks for your reply!
> 
> Sigh.  Many customers really care, and they select the whole software
> stack based on this benchmark.

People using benchmarks that have no relevance to their
software/application stack behaviour as the basis of their purchase
decisions has been happening for decades.

> If they think the results are not good, they might ask us to move away
> of XFS filesystem.  It's not what I could do anything, you know.

If they think there is a filesystem better suited to their
requirements than XFS, then they are free to make that decision
themselves. We can point out that their selection metrics are
irrelevant to their actual workload, but in my experience this just
makes the people running the selection trial more convinced they are
right and they still make a poor decision....

> > > shell1 test[2] basically runs in a loop that it executes commands
> > > to generate files (sort.$$, od.$$, grep.$$, wc.$$) and then remove
> > > them.  The testcase lasts for one minute and then show the total number
> > > of iterations.
> > > 
> > > While no difference was observed in single-threaded results, it showed
> > > a noticeable difference above if  `./Run shell1 -c 144 -i 1`  is used.
> > 
> > I'm betting that the XFS filesystem is small and only has 4 AGs,
> > and so has very limited concurrency in allocation.
> > 
> > i.e. you're trying to run a massively concurrent workload on a
> > filesystem that only has - at best - the ability to do 4 allocations
> > or frees at a time. Of course it is going to contend on the
> > allocation group locks....
> 
> I've adjusted this, from 4 AG to 20 AG.  No real impact.

Yup, still very limited concurrency considering that you are running
144 instances of that workload (which, AFAICT, are all doing
independent work).  This implies that a couple of hundred AGs would
be needed to provide sufficient allocation concurrency for this sort
of workload.

> > > I tried to do some hack to disable defer inode inactivation as below,
> > > the shell1 benchmark then recovered: XFS (35649.6 -> 37810.9):
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 7b6c026d01a1..d9fb2ef3686a 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -2059,6 +2059,7 @@ void
> > >   xfs_inodegc_start(
> > >   	struct xfs_mount	*mp)
> > >   {
> > > +	return;
> > >   	if (xfs_set_inodegc_enabled(mp))
> > >   		return;
> > > 
> > > @@ -2180,6 +2181,12 @@ xfs_inodegc_queue(
> > >   	ip->i_flags |= XFS_NEED_INACTIVE;
> > >   	spin_unlock(&ip->i_flags_lock);
> > > 
> > > +	if (1) {
> > > +		xfs_iflags_set(ip, XFS_INACTIVATING);
> > > +		xfs_inodegc_inactivate(ip);
> > > +		return;
> > > +	}
> > 
> > That reintroduces potential deadlock vectors by running blocking
> > transactions directly from iput() and/or memory reclaim. That's one
> > of the main reasons we moved inactivation to a background thread -
> > it gets rid of an entire class of potential deadlock problems....
> 
> Yeah, I noticed that too, mainly
> commit 68b957f64fca ("xfs: load uncached unlinked inodes into memory
> on demand").

That is not related to the class of deadlocks and issues I'm
referring to. Running a transaction in memory reclaim context (i.e.
shrinker evicts the inode from memory) means that memory reclaim now
blocks on journal space, IO, buffer locks, etc.

The sort of deadlock that this can cause is a non-transactional
operation above memory reclaim holding a buffer lock (e.g. bulkstat
reading the AGI btree), then requiring memory allocation (e.g.
pulling a AGI btree block into memory) which triggers direct memory
reclaim, which then tries to inactivate an inode, which then
(for whatever reason) requires taking a AGI btree block lock....

That is the class of potential deadlock that background inode
inactivation avoids completely. It also avoids excessive inode
eviction latency (important as shrinkers run from direct reclaim
are supposed to be non-blocking) and other sub-optimal inode
eviction behaviours from occurring...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
