Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51F11B1D65
	for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2024 12:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730722554; cv=none; b=RT3CIv+qhn9C6QdxAq444k8SDDyva+VeW1A1G44KXZLcf7kxMqpOmSGDeBcHrTl8UMxTwA/LWJmzkXl6AAMmiqyz+N4piEVl9GlUHIkWHQMeMEAL8Yi/xKRsUtgQIwOOxcKhpWKDSZrNGGUVabK9RJ3qux/BdIuMnMFUVgPjtsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730722554; c=relaxed/simple;
	bh=w2x6ovKDK+RaRKbTdn4vmFFYuzNswsz+kI0ClUZaYDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCbUvf/MLiNYiJhyFQJSy4uuAobDHMBNMHL+DtaZLI+5z01qpoM1mdChaF7KXaZbsbDCtJulQhB5qcKIDfjW87vk4RNIUs726oowEakFqoH5GpRPl3EIFU/fHCjSE883wMjNn7zabUlqXnBeSKbBOpwE1D5RNYuEDTmB867XyaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HQUCRxCE; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HQUCRxCE"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20c805a0753so35933365ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2024 04:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730722552; x=1731327352; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W7AQtQwh5XwBf5DE/8aulvDQwybobvqaigExgcMas5c=;
        b=HQUCRxCED8YEzLspTSpjUxF6IhwtwFU/vKnl67ZiDw4VPpKj3yaPpb6L+WmqokvPTv
         66iTk5NU5qd8RXtXtCFUSgtEBNeFWI1MiNUThGrGD+PSAInPPj+Mruk0JIuPUD6i/nBp
         4BY8DTbeviOszluXY0Oi8BB4oWi9ISot74OMyHsxEse/C6LCe8sQj7JT9BPEYo9Y6gqg
         cIMj/+t8oXVLtzCgk5EHEoPQZzWvhLpDrB7XakHqKWve7mw4rh5BRqZE9EKiOOoqZn4h
         q2gnPnC+aHigOPnhv/SOwjCyAz3+bAp7v/Yc2MZ3OsE1x+S5f4QNx4rJBVmPGqXjCFy3
         hEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730722552; x=1731327352;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W7AQtQwh5XwBf5DE/8aulvDQwybobvqaigExgcMas5c=;
        b=eQK0DVDThU8Agn46QgqHwPzDx/yfHv3NuS0XesXyzKqJJEs/C/q1jXa/JQ+gz88zLS
         3QIXSeQ72KBiQDBqQCAA7yB1bcEWIfLLYHGE1C0ieT+rbibpo5U7DtoR/Ugky51K6MxD
         a/9t1Ke8z91Tu7yFK4H3Uwk4GKuGvR1kaYV6bJ3rImUTsbY9pHI4fBS4ychoawXyAWBd
         9T00Yj0nZvX+02sQOPCAepHG38eS+Rexd5U5D1AAPO4oj/oIuvyFuawJeBuIarmkhh8P
         azRwelAG99TfPVnvWoVRPJALM8WW8ylogWcXIb2oY3I+Q/3mGGXwiATLnTcLaoKWvDcH
         d7Yg==
X-Forwarded-Encrypted: i=1; AJvYcCVw1g+Ht+b6NzW/iJN11EuObmalTYXsB48xnmbN/n+UH964/vB4DOom48yRzKURPWCjVZ86/7qyxC4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf0+kRPepSPRFGRHD23a6IpLA09ySkjxu/34gLfj31ETx4Pk72
	HyXWOz0YKvc0qOd+f4O4FQZBVvlXV3l3VUl6wDYOAvAJOQdHZSOcAw8+WurnWpg=
X-Google-Smtp-Source: AGHT+IFx7/6RECjaK46hKWx2etOjpv6VJ7ml11BpX8/5iacM2hZgso5bznO8FcClEIKx+2J9+6i6AQ==
X-Received: by 2002:a17:902:f546:b0:20b:9f8c:e9de with SMTP id d9443c01a7336-210c68995ccmr434877625ad.13.1730722551874;
        Mon, 04 Nov 2024 04:15:51 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057a2b2esm60061345ad.172.2024.11.04.04.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 04:15:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t7vzn-00A2SF-37;
	Mon, 04 Nov 2024 23:15:47 +1100
Date: Mon, 4 Nov 2024 23:15:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com,
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
Message-ID: <Zyi683yYTcnKz+Y7@dread.disaster.area>
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
 <ZyhAOEkrjZzOQ4kJ@dread.disaster.area>
 <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>

On Mon, Nov 04, 2024 at 05:25:38PM +0800, Stephen Zhang wrote:
> Dave Chinner <david@fromorbit.com> 于2024年11月4日周一 11:32写道：
> >
> > On Mon, Nov 04, 2024 at 09:44:34AM +0800, zhangshida wrote:
> > > From: Shida Zhang <zhangshida@kylinos.cn>
> > >
> > > Hi all,
> > >
> > > Recently, we've been encounter xfs problems from our two
> > > major users continuously.
> > > They are all manifested as the same phonomenon: a xfs
> > > filesystem can't touch new file when there are nearly
> > > half of the available space even with sparse inode enabled.
> >
> > What application is causing this, and does using extent size hints
> > make the problem go away?
> >
> 
> Both are database-like applications, like mysql. Their source code
> isn't available to us. And I doubt if they have the ability to modify the
> database source code...

Ok, so I did a bit of research. It's the MySQL transparent page
compression algorithm that is the problem here. Essentially what
this does is this:

Write : Page -> Transform -> Write transformed page to disk -> Punch hole

Read  : Page from disk -> Transform -> Original Page

Essentially, every page is still indexed at the expected offset,
but the data is compressed and the space that is saved by the
compression is then punched out of the filesystem. Basically it
makes every database page region on disk sparse, and it does it via
brute force.

This is -awful- for most filesystems. We use a similar technique in
fstests to generate worst case file and free space fragmentation
('punch_alternating') for exercising this sort of behaviour, and it
really does screw up performance and functionality on all the major
Linux filesysetms. XFS is the canary because of the way it
dynamically allocates inodes.

It's also awful for performance. There can be no concurrency in
database IO when it is doing hole punching like this. Hole punching
completely serialises all operations on that file, so it cannot be
doing read(), write() or even IO whilst the hole punch is being
done. 

IOWs, page compression allows the database to store more data in the
filesystem, but it does so at a cost. The cost is that it degrades
the filesystem free space badly over time. Hence as the FS fills up,
stuff really starts to slow down and, in some cases, stop working...

As the old saying goes: TANSTAAFL.

(There Ain't No Such Thing As A Free Lunch)

If you can't turn off page compression via a database configuration
flag, you could always shim the fallocate() syscall to always return
-EOPNOTSUPP to fallocate(FALLOC_FL_PUNCH_HOLE)....

> > Also, xfs_info and xfs_spaceman free space histograms would be
> > useful information.
> >
> 
> There are two such cases.
> In one case:
> $ xfs_info disk.img
> meta-data=disk.img               isize=512    agcount=344, agsize=1638400 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=563085312, imaxpct=25
>          =                       sunit=64     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

This filesystem has 344 6GB AGs. That is .... not good. This will
make the free space fragmentation problems worse than having
4-16AGs (default for a fs of that size) because the free space is
already fragmented into lots of small disjoint regions even when the
filesytem is empty.

> $ xfs_db -c freesp disk.img
>    from      to extents  blocks    pct
>       1       1 43375262 43375262  22.32
>       2       3 64068226 150899026  77.66
>       4       7       1       5   0.00
>      32      63       3     133   0.00
>     256     511       1     315   0.00
>    1024    2047       1    1917   0.00
>    8192   16383       2   20477   0.01

Yeah, 100 million free space extents, 600GB of space indexed in
them, and there's *nothing* the filesystem can do about it because
that's what exactly happens when you have a 16kB database page size
and every 16kB page write involves a 1-3 block hole punch in the
16kB region of the file.

> > > It turns out that the filesystem is too fragmented to have
> > > enough continuous free space to create a new file.
> >
> > > Life still has to goes on.
> > > But from our users' perspective, worse than the situation
> > > that xfs is hard to use is that xfs is non-able to use,
> > > since even one single file can't be created now.
> > >
> > > So we try to introduce a new space allocation algorithm to
> > > solve this.
> > >
> > > To achieve that, we try to propose a new concept:
> > >    Allocation Fields, where its name is borrowed from the
> > > mathmatical concepts(Groups,Rings,Fields), will be
> >
> > I have no idea what this means. We don't have rings or fields,
> > and an allocation group is simply a linear address space range.
> > Please explain this concept (pointers to definitions and algorithms
> > appreciated!)
> >
> >
> > > abbrivated as AF in the rest of the article.
> > >
> > > what is a AF?
> > > An one-pic-to-say-it-all version of explaination:
> > >
> > > |<--------+ af 0 +-------->|<--+ af 1 +-->| af 2|
> > > |------------------------------------------------+
> > > | ag 0 | ag 1 | ag 2 | ag 3| ag 4 | ag 5 | ag 6 |
> > > +------------------------------------------------+
> > >
> > > A text-based definition of AF:
> > > 1.An AF is a incore-only concept comparing with the on-disk
> > >   AG concept.
> > > 2.An AF is consisted of a continuous series of AGs.
> > > 3.Lower AFs will NEVER go to higher AFs for allocation if
> > >   it can complete it in the current AF.
> > >
> > > Rule 3 can serve as a barrier between the AF to slow down
> > > the over-speed extending of fragmented pieces.
> >
> > To a point, yes. But it's not really a reliable solution, because
> > directories are rotored across all AGs. Hence if the workload is
> > running across multiple AGs, then all of the AFs can be being
> > fragmented at the same time.
> >
> 
> You mean the inode of the directory is expected to be distributed
> evenly over the entire system, and the file extent of that directory will be
> distributed in the same way?

The directory -structure- is distributed across all AGs. Each newly
created directly is placed in a different AG to it's parent inode.
Each file created in a directory is located in the same AG as the
parent directory inode. Inodes then try to alllocate data as close
to the inode as possible (i.e. allocation targets the same AG). This
keeps related data and metadata close together (i.e. preserved
locality of reference) and allows for delayed allocation
optimisations like multi-file write clustering....

This means that when you have something like a kernel source tree,
it will be distributed across every AG in the filesystem because
it's a complex directory tree with many files in it.

Of course, this all changes when you mount with "inode32". Inodes
are all located in the <1TB region, and the initial data allocation
target for each inode is distributed across AGs in the >1TG region.
There is no locality between the inode and it's data, and the
behaviour of the filesystem from an IO perspective is completely
different.

> The ideal layout of af to be constructed is to limit the higher af
> in the small part of the entire [0, agcount). Like:
> 
> |<-----+ af 0 +----->|<af 1>|
> |----------------------------
> | ag 0 | ag 1 | ag 2 | ag 3 |
> +----------------------------
> 
> So for much of the ags(0, 1, 2) in af 0, that will not be a problem.
> And for the ag in the small part, like ag 3.
> if there is inode in ag3, and there comes the space allocation of the
> inode, it will not find space in ag 3 first. It will still search from the
> af0 to af1, whose logic is reflected in the patch:

That was not clear from your description. I'm not about to try to
reverse engineer your proposed allocation algorithm from the code
you have presented. Looking at the implementation doesn't inform me
about the design and intent of the allocation policy.

> [PATCH 4/5] xfs: add infrastructure to support AF allocation algorithm
> 
> it says:
> 
> + /* if start_agno is not in current AF range, make it be. */
> + if ((start_agno < start_af) || (start_agno > end_af))
> +       start_agno = start_af;
> which means, the start_agno will not be used to comply with locality
> principle.

Which is basically the inode32 algorithm done backwards.

> > > 3.Lower AFs will NEVER go to higher AFs for allocation if
> > >   it can complete it in the current AF.
> 
> From that rule, we can infer that,
>      For any specific af, if len1 > len2, then,
>      P(len1) <= P(len2)
> 
> where P(len) represents the probability of the success allocation for an
> exact *len* length of extent.
>
> To prove that, Imagine we have to allocate two extent at len 1 and 4 in af 0,
> if we can allocate len 4 in af 0, then we can allocate len 1 in af 0.
> but,
> if we can allocate len 1 in af 1, we may not allocate len 4 in af 0.
>
> So, P(len1) <= P(len2).
> 
> That means it will naturally form a layer of different len. like:
> 
>        +------------------------+
>        |            8           |
> af 2   |    1   8     8  1      |
>        |       1   1            |
>        +------------------------+
>        |                        |
>        |    4                   |
>        |          4             |
> af 1   |        4     1         |
>        |    1       4           |
>        |                  4     |
>        +------------------------+
>        |                        |
>        |  1     1     1         |
>        |                        |
>        |           1            |
>        |  1  1 4       1        |
> af 0   |           1            |
>        |      1                 |
>        |                  1     |
>        |          1             |
>        |                        |
>        +------------------------+
> 
> So there is no need so provide extra preference control info for
> an allocation. It will naturally find where it should go.

This appears to be a "first fit from index zero" selection routine.
It optimises for discontiguous, small IO hole filling over
locality preserving large contiguous allocation, concurrency and IO
load distribution. XFS optimises for the latter, not the former.

First fit allocation generally results in performance hotspots in
large storage arrays. e.g. with a linear concat of two luns, a
first-fit from zero algorithm will not direct any IO to the second
lun until the first lun is almost entirely full. IOWs, half the
performance of the storage hardware is not being used with such an
algorithm. The larger the storage array gets, the worse this
under-utilisation becomes, and hence we have never needed to
optimise for such an inefficient IO pattern as the innodb page
compression algorithm uses.

FWIW, as this appears to be a first-fit algorithm, why is there
a need for special "AF"s to control behaviour? I may be missing
something else, but if we treat each AG as an AF, then we
effectively get the same result, right?

The only issue would be AG contention would result in allocations in
higher AGs before the lower AGs are completely full, but the
filesystem would still always fill from one end to the other as this
AF construct is attempting to do. That leaves space for inodes to be
allocated right up until the last AG in the fs becomes too
fragmented to allocate inodes.

AFAICT, this "reserve AG space for inodes" behaviour that you are
trying to acheive is effectively what the inode32 allocator already
implements. By forcing inode allocation into the AGs below 1TB and
preventing data from being allocated in those AGs until allocation
in all the AGs above start failing, it effectively provides the same
functionality but without the constraints of a global first fit
allocation policy.

We can do this with any AG by setting it up to prefer metadata,
but given we already have the inode32 allocator we can run some
tests to see if setting the metadata-preferred flag makes the
existing allocation policies do what is needed.

That is, mkfs a new 2TB filesystem with the same 344AG geometry as
above, mount it with -o inode32 and run the workload that fragments
all the free space. What we should see is that AGs in the upper TB
of the filesystem should fill almost to full before any significant
amount of allocation occurs in the AGs in the first TB of space.

If that's the observed behaviour, then I think this problem can be
solved by adding a mechanism to control which AGs in the filesystem
are metadata preferred...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
