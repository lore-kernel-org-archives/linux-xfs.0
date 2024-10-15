Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D2E21E3B4
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 21:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729029066; cv=none; b=n2AmXWqdDWZ6rag3NRm0vUTigxWPqGaIgugJBxmrNqdmOoCiQEhmE6s2vfn5YvWcjDiudiZqQzi5rmixg8OxxqO751pVM+clJoUhSl8RtHiOPue7F/Xzc+T8Nen19Veg13DJBaEdCKArPm20FU1HBy+mU9I5KhdLmStbfctUhIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729029066; c=relaxed/simple;
	bh=hSozEFv8m/TbtSvxb0FHznXq89oiylmQ9bp16lbzkB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nH1KRI19Kov4uhiIcAH8Vtw80bV4FKpYq6DI795TwGR4GyjY2fTkZn6AfzxZfEQuO1Chyq8/Z+ZM/EafPi9iILCElAVDwdCiWMR4mbwjry2MC2Z8am47/fFtnRlVH76bfm56nrZWiV3eNTus8x17p3qgkf+y/0JI/m4YHyecaXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Qcx4UqRC; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Qcx4UqRC"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20caccadbeeso45137595ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 14:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729029063; x=1729633863; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RIbql7FxBLA7l3QYk3auusd9TTm3/LPL/t4lU1Jlbps=;
        b=Qcx4UqRC0/q1yvmF0cq6qb2ln2IOw0V7pz660dh7RGdkrk9rzaZH7urKzToL4PAy2d
         g9KxHAKcx7V8Enq8r+lKjmicN/YYMsGLb8AXTGNIq7ZRZuwOnR3I0/JM+4JvTfD5L9aj
         jZUENy2VWH605SvNfCN29LL5G2RZBSQ6LCwH8gm8P334ZgZPhQlCMmqguCJcXP2hbku7
         YV7O/Tu7gBOAOhiLbKaCu13iRJ6PR+enu0MiaJSgN/fo6pe+24n0sy25aevI2CH1qlPY
         iWjsfwIvdhartKxi2mlbQFSB+Uh5PF1dCUhIizekvx48scQJI6IK8psAQyAIsWhCEg/I
         aFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729029063; x=1729633863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RIbql7FxBLA7l3QYk3auusd9TTm3/LPL/t4lU1Jlbps=;
        b=jCYjAxcmUtRjiARu6uYklMHB+phVZjnuhxtklH8Hdl3akHDuDsr4ABcS2VhDFJHz2E
         jFmqpqYGnRQ2MHCaTQPOigDzQ+H3JI09lNgMIE8y+l19Cra978vicDZS+Kgl38Wxvhj+
         fDPlN5jPGdx0Yi/k1iRVO78AeWiKWbXXDaFVY/hTY1ubxmmEIkaFkC3vE2+qzt2nK2zk
         EUzTIP460q95YQjC01fXczLkXKQ0hu0D2qSfnQgas2Eja9pwWx+KodpWABZ5DRQk8HZv
         qV5SHDrF/yJhlpbWSSsyGsg1IdpMkueGtLFPtAQNpftKyGwYJiFbF6Mp/82io/waWy/h
         Zj0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGrMTIOfpl33nepdp53vbRQk32MuNDNwvZgZJb+zfeCazqrTh6ouoDU3u6gfF7A9MFN3WwH0VO+5E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCH+H5LmSa3dSqiR6JKPoivTHrI5H/4CY0jViZJ3/8abe/7XP/
	UdXhdkkrxd7JXjhkINnqfbXy9zRN+STiD6sDUQqf7AffbLfWCJaoj19mFEJQkm8=
X-Google-Smtp-Source: AGHT+IE/XMxkLQRQ+1ybzN2RlD4aGRDcGf735MJ5FdQ2NG2Jfi6aKsAKSmpvMZQwyvpmVGmFPZWcpA==
X-Received: by 2002:a17:902:d490:b0:20c:f3cf:50eb with SMTP id d9443c01a7336-20cf3cf5379mr85213165ad.44.1729029062976;
        Tue, 15 Oct 2024 14:51:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d17f844b0sm16990155ad.38.2024.10.15.14.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 14:51:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0pRT-001IyZ-02;
	Wed, 16 Oct 2024 08:50:59 +1100
Date: Wed, 16 Oct 2024 08:50:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, ying.huang@intel.com,
	feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [linus:master] [iomap]  c5c810b94c:
 stress-ng.metamix.ops_per_sec -98.4% regression
Message-ID: <Zw7jwnvBaMwloHXG@dread.disaster.area>
References: <202410141536.1167190b-oliver.sang@intel.com>
 <Zw1IHVLclhiBjDkP@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw1IHVLclhiBjDkP@bfoster>

On Mon, Oct 14, 2024 at 12:34:37PM -0400, Brian Foster wrote:
> On Mon, Oct 14, 2024 at 03:55:24PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a -98.4% regression of stress-ng.metamix.ops_per_sec on:
> > 
> > 
> > commit: c5c810b94cfd818fc2f58c96feee58a9e5ead96d ("iomap: fix handling of dirty folios over unwritten extents")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > testcase: stress-ng
> > config: x86_64-rhel-8.3
> > compiler: gcc-12
> > test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
> > parameters:
> > 
> > 	nr_threads: 100%
> > 	disk: 1HDD
> > 	testtime: 60s
> > 	fs: xfs
> > 	test: metamix
> > 	cpufreq_governor: performance
> > 
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202410141536.1167190b-oliver.sang@intel.com
> > 
> > 
> > Details are as below:
> > -------------------------------------------------------------------------------------------------->
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20241014/202410141536.1167190b-oliver.sang@intel.com
> > 
> 
> So I basically just run this on a >64xcpu guest and reproduce the delta:
> 
>   stress-ng --timeout 60 --times --verify --metrics --no-rand-seed --metamix 64
> 
> The short of it is that with tracing enabled, I see a very large number
> of extending writes across unwritten mappings, which basically means XFS
> eof zeroing is calling zero range and hitting the newly introduced
> flush. This is all pretty much expected given the patch.

Ouch.

The conditions required to cause this regression are that we either
first use fallocate() to preallocate beyond EOF, or buffered writes
trigger specualtive delalloc beyond EOF and they get converted to
unwritten beyond EOF through background writeback or fsync
operations. Both of these lead to unwritten extents beyond EOF that
extending writes will fall into.

All we need now is the extending writes to be slightly
non-sequential and those non-sequential extending writes will not
land at EOF but at some distance beyond it. At this point, we
trigger the new flush code. Unfortunately, this is actually a fairly
common workload pattern.

For example, experience tells me that NFS server processing of async
sequential write requests from a client will -always- end up with
slightly out of order extending writes because the incoming async
write requests are processed concurrently. Hence they always race to
extend the file and slightly out of order file extension happens
quite frequently.

Further, the NFS client will also periodically be sending a write
commit request (i.e. server side fsync), the
NFS server writeback will convert the speculative delalloc that
extends beyond EOF into unwritten extents beyond EOF whilst the
incoming extending write requests are still incoming from the
client.

Hence I think that there are common workloads (e.g. large sequential
writes on a NFS client) that set up the exact conditions and IO
patterns necessary to trigger this performance regression in
production systems...

> I ran a quick experiment to skip the flush on sub-4k ranges in favor of
> doing explicit folio zeroing. The idea with that is that the range is
> likely restricted to single folio and since it's dirty, we can assume
> unwritten conversion is imminent and just explicitly zero the range. I
> still see a decent number of flushes from larger ranges in that
> experiment, but that still seems to get things pretty close to my
> baseline test (on a 6.10 distro kernel).

What filesystems other than XFS actually need this iomap bandaid
right now?  If there are none (which I think is the case), then we
should just revert this change it until a more performant fix is
available for XFS.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
