Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9B827E05C
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283698; cv=none; b=eYYnF5aNtiWLLPK+9HrUTAZDOUH0Fnze/65xLohIDeR2wwSJEbkByIXmmYHyQPT3upVh+erv/U4+N1GLA37fAge9y23VRPmBxP9NBlfCgsyf4aHHU8j12T2RkA0L1oTkES7VIUmoGXcMwlyUzCxjKb8HKlU2puL3d4+t0RSkBlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283698; c=relaxed/simple;
	bh=t39FVWDmcaJhaf+zVkBbiZy0L4P2c/pGkD2Q7QN6nlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4VOqI8ZSEQU9K1l56LAD8thOolMCtdpNVcjObrL9GE6a3oCdR7PCvGraQoe9Me3SAfv2RTzPyDxDZAe5dRiOOXjLuNYrzFB6GZRxUWLgZqaggkN/UCpzFB/qNo7iXgNeF4aUuRuPS3JwPobfkkf/G4ZNVaNSJ9xpdL+DX7DA+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SAhy6xA6; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SAhy6xA6"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-236192f8770so1011965ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750283696; x=1750888496; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ibZ9nQ6oICIpsadgHEQD284rA292hgtTlZ/xFlP3Si0=;
        b=SAhy6xA6YrDiTXL9CqyVeZ2tyaX9S/WI6UWA5ffS8p6zR6BFno8m+Ez9qn4YizGnHh
         NeSxzMlK39NU8BWPujuicpePjzqwKe2e9Ek29yOghQLcDKGNoAl0GV/9aJW/b7g1/puA
         M8liHplScA5yFQdbN15BBGGn9YRPXwlHNPjFY8PW9ZuA3VPLzw5k8aJsYo2bX93eIg1G
         8jeewyX3r/Orn3jPqT6f4IHIM6OcI9I1Jsexb7DSBF3gjgmgFdyTZ1H+EzwCOZY97GY1
         I5Sgo0vdZhyKUy8LH3jcnotGBfTbxBXN9SjhrYMzAwqS+GjHkNQd3psBuEl6I3wutRYI
         opdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750283696; x=1750888496;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibZ9nQ6oICIpsadgHEQD284rA292hgtTlZ/xFlP3Si0=;
        b=FaPQblZxvsOsmLuVNQi3uOWWgNiCKUrGfuU9BSNyOJVm4NBUyBAiuzg8uEOdQJlx4K
         4S7yufTAT31XoroqjfePTdjYSLZAhaluSjltRhRwkdCCUrvAYP+3teTqiywjT9OTn/YT
         /XCiO21KKVvKGazcWmezHGgRnbz4dxUUqXYBep+IPw2jMRogRLFh+rHEFkVtF4gdKp2w
         WaQlr5weGWnNUE1g/8kc2HgcDgOvsBeJ2nrw3R5YpAnez+Wyd/gvpor/PkIprCjfSdqf
         u+oOXPxQhG8GJ1s2X4XRzxk4iCaaxSHi9qEs8IGrSFcnmnMn9UYxHNBLvvciISrep+DU
         LxYg==
X-Forwarded-Encrypted: i=1; AJvYcCVNEDeDbxWsV9pkGFAs0zP69AVzHx/AgOj5cJ1r7q5PYfYjN6Nfu+bz8+N7wLSw9Lc91etT8nNyXsY=@vger.kernel.org
X-Gm-Message-State: AOJu0YypLLkwnXkaWcpDEN1faK1j1qe6ilqHBQzMAclezGKB+F6LJgkk
	saaj9EfMJ306U+f3TETv8GRFRMuHtI3e4Ttkv4DZTFYETfAdTT3zikyWMGPDq+gnTjg=
X-Gm-Gg: ASbGncuBs8MeZ4tkPljo1oK5xKbCXbfxJapKjalDGww4uB5XEWdPzuICh7A4X8qhDdE
	X8k0ZSWKfMvCCRnprrgM3pc37BagusUjHS7hTiA24PNxxKDDYPZFgJcdQx4Tol+43+6eSc4IYq5
	GWPE9gjU2ar10c8qW3rFmGomC5Rl5SAqzb9wS03T8qyELigRmTOYtOSguoU5vFzLfHTItx8VJu3
	HtBjVdcYcl4J6DNRE0bjtXa/065STAtr+GU+ppLPpNGWFKE7CjwsIN1fKz88ZVrrLth20FAvUnt
	vxKJpBZHan8Bl24pijCfGnneVBSczjtI0EoeTtbgf8rXLkNvBCdN3kd96Pes7dPkJjXTSHil41+
	3/t3VrxiRm6yYTJBACyfaGjIsLgS9gGDw8EYZiw==
X-Google-Smtp-Source: AGHT+IEUIy1Ug7xua5mBZHByJ8Q4rsgKYtbliFIQ+Erm4QHJ1W80k3Lj161qO+rZEbPN8r2IUO9i9g==
X-Received: by 2002:a17:902:ec90:b0:234:9ef7:a189 with SMTP id d9443c01a7336-237cbf317b1mr18466695ad.13.1750283696116;
        Wed, 18 Jun 2025 14:54:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365de78169sm105813205ad.123.2025.06.18.14.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 14:54:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uS0k8-00000000MLP-1QYT;
	Thu, 19 Jun 2025 07:54:52 +1000
Date: Thu, 19 Jun 2025 07:54:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Theune <ct@flyingcircus.io>
Cc: Carlos Maiolino <cem@kernel.org>, stable@vger.kernel.org,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	regressions@lists.linux.dev
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
Message-ID: <aFM1rGs1zW52M8ov@dread.disaster.area>
References: <M1JxD6k5Sdxnq-pztTdv_FZwURA8AaT9qWNFUYGCmhiTRQFESfH7xqdOqQjz-oKQiin8pQckoNhfNyCHu-cxEQ==@protonmail.internalid>
 <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
 <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
 <Z9Ih4yZoepxhmmH5Jrd1bCz35l6iPh5g2J61q2NR7loEdQb_aRquKdD1xLaE_5SPMlkBM8zLdVfdPvvKuNBrGQ==@protonmail.internalid>
 <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
 <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
 <01751810-C689-4270-8797-FC0D632B6AB6@flyingcircus.io>
 <aFHsJmPhK6hBfEPC@dread.disaster.area>
 <E4F29FAF-D17F-48BC-9F13-05F04C0C2AF5@flyingcircus.io>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E4F29FAF-D17F-48BC-9F13-05F04C0C2AF5@flyingcircus.io>

On Wed, Jun 18, 2025 at 03:01:26PM +0200, Christian Theune wrote:
> 
> 
> > On 18. Jun 2025, at 00:28, Dave Chinner <david@fromorbit.com>
> > wrote:
> > 
> > On Mon, Jun 16, 2025 at 12:09:21PM +0200, Christian Theune
> > wrote:
> >>> Can you share the xfs_info of one of these filesystems? I'm
> >>> curious about the FS geometry.
> >> 
> >> Sure:
> >> 
> >> # xfs_info / meta-data=/dev/disk/by-label/root isize=512
> >> agcount=21, agsize=655040 blks =
> >> sectsz=512   attr=2, projid32bit=1 =
> >> crc=1        finobt=1, sparse=1, rmapbt=0 =
> >> reflink=1    bigtime=1 inobtcount=1 nrext64=0 =
> >> exchange=0 data     =                       bsize=4096
> >> blocks=13106171, imaxpct=25 =                       sunit=0
> >> swidth=0 blks naming   =version 2              bsize=4096
> >> ascii-ci=0, ftype=1, parent=0 log      =internal log
> >> bsize=4096   blocks=16384, version=2 =
> >> sectsz=512   sunit=0 blks, lazy-count=1 realtime =none
> >> extsz=4096   blocks=0, rtextents=0
> > 
> > From the logs, it was /dev/vda1 that was getting hung up, so I'm
> > going to assume the workload is hitting the root partition,
> > not:
> > 
> >> # xfs_info /tmp/ meta-data=/dev/vdb1              isize=512
> >> agcount=8, agsize=229376 blks
> > 
> > ... this one that has a small log.
> > 
> > IOWs, I don't think the log size is a contributing factor
> > here.
> > 
> > The indication from the logs is that the system is hung up
> > waiting on slow journal writes. e.g. there are processes hung
> > waiting for transaction reservations (i.e. no journal space
> > available). Journal space is backed up on metadata writeback
> > trying to force the journal to stable storage (which is blocked
> > waiting for journal IO completion so it can issue more journal
> > IO) and getting blocked so it can't make progress, either.
> > 
> > I think part of the issue is that journal writes issue device
> > cache flushes and FUA writes, both of which require written data
> > to be on stable storage before returning.
> > 
> > All this points to whatever storage is backing these VMs is
> > extremely slow at guaranteeing persistence of data and
> > eventually it can't keep up with the application making changes
> > to the filesystem.  When the journal IO latency gets high enough
> > you start to see things backing up and stall warnings
> > appearing.
> > 
> > IOWs, this does not look like a filesystem issue from the
> > information presented, just storage that can't keep up with the
> > rate at which the filesystem can make modifications in memory.
> > When the fs finally starts to throttle on the slow storage,
> > that's when you notice just how slow the storage actually
> > is...
> > 
> > [ Historical note: this is exactly the sort of thing we have
> > seen for years with hardware RAID5/6 adapters with large amounts
> > of NVRAM and random write workloads. They run as fast as NVRAM
> > can sink the 4kB random writes, then when the NVRAM fills, they
> > have to wait for hundreds of MB of cached 4kB random writes to
> > be written to the RAID5/6 luns at 50-100 IOPS. This causes the
> > exact same "filesystem is hung" symptoms as you are describing
> > in this thread. ]
> 
> Yeah, I’m very wary of reporting these tracebacks as potential
> bugs because of them easily being just a hint on slow storage. My
> problem here is that I can’t point to anything that says the
> storage would have been slow.
> 
> I’ve gone through all metrics and logs on the KVM servers as well
> as the Ceph servers and they’ve been performing completely at
> baseline level regarding errors, queues, iops, latency.
> 
> I’ve done a measurement to try to emulate those accesses by
> running
> 
> $ fio --rw=randrw --name=synctest --bs=4k --direct=1 --numjobs=1
> --ioengine=libaio --iodepth=1 --runtime=600 --write_barrier=1
> --size=60m
> 
> I hope this is sufficiently comparable behaviour (maybe with a
> different read/write ratio instead of 0.5?) to what XFS log
> flushing does. This resulted in [1]. 

Not really comparable. "write-barrier" is not the option for data
integrity - fdatasync=8 would be closer, but even that doesn't
replicate the cache flush/fua write pattern of journal IOs.

Also, journals are write only and sequential, not random. The
iodepth is typically 8 when fully busy, and the IO size ranges from
single sector to logbsize (from /proc/mounts) depending on the
workload.

Metadata writeback to clear the journal, OTOH, is larger random
4kB writes with no data integrity implied (the journal cache flush
mechanism I mention above handles that).


> My interpretation of this measurement (and the VM showed no illnes
> while this was running over 10 minutes): the VM is throttled at
> 250 IOPs and is reporting back after 10 minutes of 4k random
> writes with average IOPS of exactly 250. The latencies are a bit
> varied, this could be due to Qemu throttling. The max latency was
> 133ms, the average 2ms. This is on a 10g storage network with Ceph
> that requires another network roundtrip for replication before
> ACKing a write.

Oh. Ceph.

Slow random write performance on ceph rbd devices seem to be a
recurring problem - the filesystem is way faster than the storage,
and by the time the filesystem throttles on journal space (even with
small logs), the backlog of IO cannot be drained very quickly and so
everything stalls.

IOWs, a hard cap of 250 random 4kB write IOPS is extremely slow and
a likely cause of your random stall problems. When you have lots of
dirty metadata in memory, then it can take minutes of IO for
writeback to free journal space to allow progress to be made again.

For example, modify an inode (e.g. chmod), and that only takes ~250
bytes of journal space to record. So a 10MB journal can hold ~40,000
dirty inodes. If we assume that there maximum locality in these
inodes (i.e. best case writeback IO patterns) we have ~1300 x 16kB
writes to perform to empty the journal.

Hence there's up to 10-15s of writeback IO to "unstall" a small
journal. Worst case, it's one 16kB write per inode, and that means
potential for multiple minutes of writeback to unstall a 10MB
journal. Now consider a 64MB journal, and the potential stalls
waiting on metadata writeback are much, much worse...

These stalls will come and go with workload peaks. The filesystem
can soak up some of the peak into memory and the journal, then it
throttles to storage speed and that's where the hung task warnings
fire. Once the storage catches up, everything goes back to "normal"
latencies.

> I’m out of ideas for now, I’ll keep thinking about this. If anyone
> has any pointer for further tests in any direction, I’m open to
> anything. ;)

Don't use hard throttling on IOPS rates. Measure IO rates over a
longer period of time (e.g. rolling average over a minute) so that
the storage can rapidly sink the short term IO peaks that occur when
the workload runs the journal out of space and the fs throttles it
whilst metadata writeback makes progress.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
