Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A253B9D8C
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 23:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792019444; cv=pass; b=ewrCM5QstgWwWV/id/zOcTgJmAnQR2EXAh48ZsC7uNZILxhR9EV7CxH0+dkKgSw/FjG/vTUpcbA0BEJEkyMqwWhMm6i8s9quSB+fvVxmfQxxMKHEzGD5GpIYQNVWSW+aInDIYM/00Ti1ItO6npNHLr+nMKxBglZvYOzxzYHZBGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792019444; c=relaxed/simple;
	bh=5sBlQyUblg8X5f6D7cEzH1eaWzUmXoq4kLDUuAgeuWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AEkv3vxAuzfVp8/0yP/MMdqPCv4Y4Wbfv9Dg0AE/gDxxP+9hICk1LE6Fosxkvt9RrZgshe5BbNT7QfDwZ4tvXEsCdcqq6I9hp5YAGY9nHllo1FEW3JcD7AfJhagttQT9lMkxwdClbn9OTbk9b6g5RyEnMUeBN3XoTAyd1kkDUGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EEAAYyii; arc=pass smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EEAAYyii"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e60f9af6e6so12278095ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 16:10:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792019442; cv=none;
        d=google.com; s=arc-20260327;
        b=g7dMJu62uD/VyImaFuIHAT4fANT/v90LEIPdg74qEhBHO6YYo7wfzTB+Av1ZGCDOyc
         693399DTWOCeaFGV0cVqYkNav1SeVmTuXslhywzZhbOAeSYmzBmfhlFN3VUZHMaqzhbe
         zTzuQH0Qx05x+shkco/kclB5ouZGVsXfxQf0Pe2qv5ES8LGpn+q0P1g1ySbSG0+Hu4GY
         0tLYYL/7o0SdqwWDTz5YCO7EhqruvbpLqtX2rcu10YcYdk5o23h+7wUefPx5UGhc2iFk
         NQcAApkIkfoIyEGNP5xtNLXzVb9MOrNv6izWo4Lo7BXchr6AC3cNS9qhSPwPainRpGfb
         huZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vsiElFiNwdF835oqh77xnoP/PMUdjlzJFDGjjGhfV7I=;
        fh=Ubq8TFiXC7KjvK4hOzQAhEVmIR5KxnbNmU0i16shvwk=;
        b=lmoVRi8usNW58KY5iuz1orfwbRrSm41GrfNHjBq9o3+SvR3Yb1I5INX6yWL1WbB2VN
         Hd7Y0SkkK1HQkE1UbkRTolt9wypxdyPeHq1qX0dtfRweOpaisJOKA0wlpFYzpi+ZnwCF
         Bzry5PGgiiH2a2Mub0zbZRLkSG+eDHACCho5EDl1pn83ASWowdjFXissm/Uc3yjhWQNq
         xScsNEyZEMdY6YztcmTXQ2V2Uci9Jm683Pfc3oLOyxA12N6KYqEKTU0MvCZbrd79uHJ8
         e81lQFYgU8ykv3NFByj2iQKs9fasZBygv0GbTzjhBLbWYrUVup0/bEuQw4xRraYcpGW4
         VfZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792019442; x=1792624242; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vsiElFiNwdF835oqh77xnoP/PMUdjlzJFDGjjGhfV7I=;
        b=EEAAYyii4Mo5zS88SgvMREwAcoHXSXxT8UoH9d2J2h7uU6jLkBsMjUV22cB0ZhOrIo
         vAjRk6uIlf8k1bOAGFGcdja2kHzBDIwQVLZUyrV4h0lCXaE7UP3gnUCIQdD8Wrqvzl1j
         HfL15T93Nc+ecEpFLpaohGWbR4WyR2y1658nXn3gRYEvjxLyE/4gFQcMBAANr9NPwikv
         soUEwQLBTeAJBR6XnGxlkvoA4UXU/jnRGVWamgPsdg1nYbER7AgKGu/FUio/T7/4DFdv
         6DF3HiA2dmyNYhf3KkZwmVGVAMwUb1OC0lq4qsdHe8zNXvvOk+dhNYtgChnkjnWr6xK5
         0Ukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792019442; x=1792624242;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vsiElFiNwdF835oqh77xnoP/PMUdjlzJFDGjjGhfV7I=;
        b=SbKeQ6+KZviy0mPPA1foTafpjUqTxD3/QI++RegV9pib8Raw9sx1xtDXw3gd6biBD2
         CZdXnJh8gg1ItC+2AtKaTwQmWRPX66mmW0BmYAxT79BUcljhhO4fZxsgp3F08G5oota2
         AY6w5/4PHODOD4S31jMl6QLAes7vquyenhOKHMOOd3uKi1dwDe512sFAfxiJzkniQJfB
         k4xwtXQZf2Bb/kzmrp0C2ANF0zDWCyAp+7ObGsUAfx/UiELhT3j0OB1OAJ8otXQ/xOgL
         bIyzzwKQIyHAFGz93BOCLqIiXsP1WV5u4nOl7qiYv+Zmqk9iyWU08qqw8PVWiyC/idCK
         jKtA==
X-Gm-Message-State: AFq9FYKtp559YsQNXW7hJMwel5dT4ef0LmeyfWnjPGWw7PPhctOAsOKr
	F6wwv9K0Ch0k5Q5uJDXWHfOlyAJiHm4YNg15bWFcqKulrqC9JpSUDNMg/sBLFhB6lW2+/vspY8y
	EiSyQ+lYGqcqv2iNFOxc/m52oLeDIuRo=
X-Gm-Gg: AYBFou1YVRupBvFCuAyqPaPDsGHqJwqSJM2qtpol3OC/MJQLpkJkT1RbuxNuqcYMlNx
	vXCAjuccpjMEqixY4haAhWNviSrQza3vuR5MsyzGNjmVMmfpc7zd/HnSvJOfK9busR1DMVy9rnh
	weJHvQAGqI63s3HaowpVBiDjRhJ5tydi+PBA4Xn9NCGlQ+JmVd8K2hsqPY9e2p/IVkSe4ooCo0t
	++18PW+dfGLHP0ZYMWLTARys8i4LfFiQRFC3T99Fn3tIPvUHy4m7pRWumx/UN9k8LE4RlGej+1y
	eVExOlr0cWv8NydbcHiwIDxPmj/mZpOwdAkKDty5RyegWDepDrdrsuWaEMkJIIxFJAroBzueQMJ
	eNRm93AgTa4em
X-Received: by 2002:a17:902:ef46:b0:2e6:24da:a4b8 with SMTP id
 d9443c01a7336-2e842e135c5mr136978685ad.38.1792019441937; Wed, 14 Oct 2026
 16:10:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <as1HVVUXdMlpXQGT@dread> <CAF8PYMiMZ5uFGsLnms4pNtMHc=TKgzcKvoLtydGXEFS7KM_r5g@mail.gmail.com>
 <as7wb-bdykxSKenP@dread>
In-Reply-To: <as7wb-bdykxSKenP@dread>
From: Vitali Lovich <vlovich@gmail.com>
Date: Wed, 14 Oct 2026 16:10:30 -0700
X-Gm-Features: AclHuK8CHnnbNn1YoMQP4R3nSGJch3Oq3jQEWsIZP9CeMX4HMUQlkyeLfEhI6Xc
Message-ID: <CAF8PYMhk202oMMNAdT0yPDD=J8rG5kgKVRSRnf5ix+x6_SJmYQ@mail.gmail.com>
Subject: Re: Really bad I/O lock contention between non-overlapping reader and writer
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ok. I have a patch series I'm happy to share. It has no meaningful
performance degradation / scaling problems and largely fixes the
head-of-line blocking problem without the challenges of range
tracking. Before I post it, some stylistic questions for you:

* Do you prefer it as a new RFC e-mail chain or continue here
* Are there specific benchmarks / workloads you'd like me to gather numbers=
?
* Is a VM with RAM XFS filesystem sufficient or is raw metal w/ an
NVMe drive required?

Cheers,
Vitali

On Tue, Oct 13, 2026 at 8:01=E2=80=AFPM Dave Chinner <dgc@kernel.org> wrote=
:
>
> On Tue, Oct 13, 2026 at 04:49:53PM -0700, Vitali Lovich wrote:
> > On Mon, Oct 12, 2026 at 1:47=E2=80=AFPM Dave Chinner <dgc@kernel.org> w=
rote:
> > >
> > > On Mon, Oct 12, 2026 at 10:47:56AM -0700, Vitali Lovich wrote:
> > > > I think I encountered suboptimal locking behavior with concurrent
> > > > readers and writers on a file, which resulted in huge latency spike=
s
> > > > for the reader even though the writers and readers are touching
> > > > unrelated ranges within the file. The writer/hole puncher hold an
> > > > exclusive lock on the inode while forcing a flush of outstanding
> > > > writes to disk which creates huge latency spikes for reads.
> > > >
> > > > I've observed read's taking >> 500ms even though none of the writes
> > > > could be overlapping and traces seem to indicate it's the shared in=
ode
> > > > lock contending with the exclusive inode lock that writes / hole
> > > > punching is holding. In my real-world test case traces indicated th=
at
> > > > the cause might be inode_dio_wait while holding the exclusive inode
> > > > lock.
> > > >
> > > > I've observed this behavior on XFS, EXT4 and BTRFS so it seems like=
 a
> > > > general VFS challenge. Generally, Btrfs seems to have less read
> > > > latencies created than Ext4 (~2.5x more at the 0-1ms read than EXT4=
),
> > > > which in turn has smaller and fewer tail latencies than XFS  (~2x m=
ore
> > > > at 0-1ms and extreme is smaller) although all filesystems exhibit t=
he
> > > > issue. Starting with the XFS list in case I'm way off base that thi=
s
> > > > is a problem.
> > > >
> > > > Attaching a simplified reproduction of what I'm doing with one writ=
er
> > > > appending data to the file,
> > >
> > > The repro is using DIO writes. Speaking for XFS, these need needs
> > > exclusive locking to serialise extending the file without causing
> > > data corruption or stale data exposure. Once extended, the locking
> > > demotes to shared, so the IO itself runs concurrently with reads.
> > >
> > > Appending DIO writes are basically a fast combined 'truncate up,
> > > write' operation, and so has the same initial serialisation
> > > constraints as 'truncate up' (i.e. exclusive locking).
> > I think that's true if the write continues at the last byte of the
> > previous one. If the write leaves a gap for whatever reason (e.g.
> > writes are 4kib aligned but we only had 3.5kib of data before the file
> > end) the fast-path isn't taken and you do have to wait for a full
> > flush because XFS doesn't realize there's nothing overlapping. This
> > scenario isn't present in the test case I published but I think it
> > acts very similarly to hole punching.
>
> What happens when there are blocked beyond EOF that the file
> extension exposes?
>
> > > > a separate writer punching holes in
> > > > unrelated ranges,
> > >
> > > fallocate() is like truncate - it also needs exclusive locking and
> > > no IO in flight to avoid a UAF of the data extent being punched out.
> > It needs exclusive locking and draining around the range in flight,
> > not necessarily the entire i_node.
>
> You don't need to explain how range locking works to me. If you
> think that you need to explain basic stuff like this to me, then you
> likely haven't understood what I've said.
>
> > > > and an O_DIRECT reader that's reading data.
> > >
> > > Shared locking only.
> > If I wasn't clear, the problem is that the shared lock has a head of
> > line blocking behind the exclusive lock that's draining the I/O even
> > though userspace knows it's never touching that range.
>
> As I said above: competing shared vs exclusive locking implies head
> of line blocking that causes latency issues. You don't need to
> explain basic stuff to me.
>
> > > > Reads
> > > > are doing random 4kib I/O in [0, 64MiB), hole punching is punching
> > > > 4kib holes in [64MiB, 576Mib] and writing is always appending after
> > > > 577MiB of the file.
> > >
> > > Educate me: what application workload has this IO pattern? Is this a
> > > real world problem. i.e. why should we care about this contrived
> > > scenario?
> > I'm trying to implement an LSM database that stores everything in one
> > file instead of taking the RocksDB approach of 1 file per SST. One
> > file per SST has scaling problems of its own in other ways, but for
> > concurrent reads and writes they acquire locks on different inodes
> > (file and directory, respectively), which is why RocksDB doesn't have
> > the problem highlighted in this test-case - it always reads and writes
> > to separate i_nodes with the downside being that it ends up having to
> > open an insane amount of files on startup and juggle them if there's
> > more than the kernel limit allows.
>
> XFS can handle access to millions of files iat a time efficiently.
> It's designed to work with massive data sets and lots of files.
> You're having problems because you're trying to optimise everything
> into a single file, hence hitting largely unfixable single file
> scalability issues.
>
> > > Also, have you tried to implement highly concurrent range locks that
> > > don't have far worse contention on the range lock tracking
> > > structures themselves than a simple rwsem? Some of us here have
> > > actually tried to do this, and the fact that we still use rwsems
> > > should tell you a lot...
> >
> > I'm not pretending it's an easy problem to solve. I've come up with a
> > few approaches and would love your feedback on what's the best path:
> >
> > 1. DIO tracking so that the inode keeps track of all outstanding
> > DIO's. Rather than the barrier, we scan the list to find if there's
> > any conflicts.
>
> Yup, that's a range lock.
>
> > I've prototyped this and it clearly solves the false
> > synchronization barrier from this in my database (unrelated writes
> > prolonging reads). This has a negative impact on normal workloads so I
> > imagine this would be hidden behind an explicit ioctl if acceptable.
>
> No, "optional" locking models are a non-starter. It either works for
> everything or it is a non-starter.
>
> > 2. Introduce generational barriers where hole punching / writing past
> > the end of the file still waits for DIOs but outside the exclusive
> > lock.
>
> The exclusive lock forms an IO submission barrier allowing in-flight
> DIOs to drain and hence the extending write/fallocate operation to
> start.
>
> Without that submission barrier, how do you prevent incoming DIOs
> (read and write within EOF) from preventing the in flight counter
> from ever reaching zero?
>
> i.e. a submission barrier is needed to avoid moving unbound
> latencies to the extending write/fallocate operations...
>
> > Inside the exclusive lock all it does is register that the range
> > that it's doing the operation on and the wait happens outside the
> > exclusive lock. Operations that overlap will either wait for all
>
> Now we're back to range tracking....
>
> > outstanding DIO or perhaps satisfy if they can (e.g. a read of an
> > fallocate technically could just supply the 0s without waiting for
> > DIO).
>
> No, we can't return zeros to userspace until after the fallocate
> operation completes successfully. If the operation has not started,
> we have to return the data as it currently exists on disk - that is
> a fundamental data integrity requirement.
>
> > Is either or both of these a non-starter idea in terms of acceptance
> > (assuming I can actually make it safe)?
>
> If you come up with something that works in the general case, and it
> scales out to millions of concurrent random 4kB DIO read/write IOPS
> on a single file across dozens of processes submitting IO, then I'll
> take what you are proposing seriously.
>
> But until I see code that is provably correct with benchmarks that
> show IO similar performance to rwsem shared locking, I'll remain
> skeptical that this can be done.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> dgc@kernel.org
