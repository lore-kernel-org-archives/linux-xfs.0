Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88727220F27;
	Thu, 19 Jun 2025 10:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750327523; cv=none; b=JfDdd0018aTTXtAj2+8sfa/ybrPMMZhe+Tk7oy2E4OAYBgrsjV18TkTzl9oMTD+TPcgj2dsinEUUVnO6qy7KH6AV9KALS/ikhjUzOm+xcGS3+pNnzBGeTXQEigZCp/3sExo53vZYvFPCP8ftxjGczHLc/Trh1tKnt+jEQnXp+lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750327523; c=relaxed/simple;
	bh=XpsFOqhbSXBJcN0+b8Kb6VUCTkjT6ZQFUIxB23zC8wo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=A9MA5HDj/c2tXbSgu09bSREgFCCnht55QsqsbSWDcXR4Mdelt4MuJ/D+KJ4BMWyak5z4S0l45ocspndt3qD1anJ51WtUhWBg8dGJrntI8xonCdRL0WPLHH2HRggAuCD4xQf6DdGOD9uGzYgoypTOeqjrtrVPjnc/bBmsgkXPt/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=KwVByJXE; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="KwVByJXE"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1750327516;
	bh=XpsFOqhbSXBJcN0+b8Kb6VUCTkjT6ZQFUIxB23zC8wo=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=KwVByJXEj1CtcruNaA0r1463bh6OuGJhglQdt6AjZ9VOUbQCpi8qJb+qQYPUKrNv0
	 7Ly7/UJV1hMUm/ygzSOC6PEPuHZsV9NgZ2GjSePExkc7/qVbcXrVnssvKZo5R52DbF
	 10Ssi4wtUDwPXbsNJpvcLBOd753Fh4L37IWfFTSs=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <aFM1rGs1zW52M8ov@dread.disaster.area>
Date: Thu, 19 Jun 2025 12:05:06 +0200
Cc: Carlos Maiolino <cem@kernel.org>,
 stable@vger.kernel.org,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 regressions@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <D2237B2F-0FA8-44EB-A5B3-E7BA4512A872@flyingcircus.io>
References: <M1JxD6k5Sdxnq-pztTdv_FZwURA8AaT9qWNFUYGCmhiTRQFESfH7xqdOqQjz-oKQiin8pQckoNhfNyCHu-cxEQ==@protonmail.internalid>
 <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
 <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
 <Z9Ih4yZoepxhmmH5Jrd1bCz35l6iPh5g2J61q2NR7loEdQb_aRquKdD1xLaE_5SPMlkBM8zLdVfdPvvKuNBrGQ==@protonmail.internalid>
 <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
 <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
 <01751810-C689-4270-8797-FC0D632B6AB6@flyingcircus.io>
 <aFHsJmPhK6hBfEPC@dread.disaster.area>
 <E4F29FAF-D17F-48BC-9F13-05F04C0C2AF5@flyingcircus.io>
 <aFM1rGs1zW52M8ov@dread.disaster.area>
To: Dave Chinner <david@fromorbit.com>

Ouch, thanks for that explanation. I now get why and how this really is =
either
a log-related or even general dirty/writeback flushing issue. We =
definitely
have some quite sub-optimal settings here - so I=E2=80=99m revisiting =
our dirty/writeback=20
settings and XFS journal sizes. My understanding is that (in our
situation) those should be sized based on the backing storage =
performance -
so typically we=E2=80=99ll end up with fixed sizes independent of the =
available
RAM or volume size that will guarantee an upper bound for worst case
of flushing/processing.

However, I=E2=80=99m still a bit puzzled why this has escalated to =
user-visible
incidents in the last weeks - we=E2=80=99ve been running with those =
sub-optimal
settings for a very long time and haven=E2=80=99t had these issues =
before.

I took some time to educate myself further around the writeback =
behaviour
and noticed the special relationship with that keeps getting mentioned
between writeback and cgroups and those are in play with our setup, so
maybe it=E2=80=99s worth another look.=20

Whenever this issue hits us, the system is running one of two system
management tasks where one performs garbage collection on the nix store
(which typically contains multiple generations of all packages on the
system) and the other builds out a new system config. Those jobs are run =
in
separate cgroups and throttled at 31 RW IOPS (12.5% of 250) and 188 RW =
IOPS
(75% of 250). Those jobs aren=E2=80=99t time critical at all, so we want =
to leave
sufficient IOPS to not starve the actual workload.

Those jobs run relatively often without causing issues, but then =
they=E2=80=99re
also lazy. Still, even when they do work they do not always cause those
issues. If they do, then i can see a sudden spike in our telemetry for
dirty pages (around 300-400 MiB typically) followed by a jump in =
writeback
pages (which is typically a bit higher: around 200 MiB more than dirty =
pages).

So far so good - that=E2=80=99s expected behaviour: one of the jobs =
might be deleting
a lot of files - so that=E2=80=99s lots of metadata operations in the =
journal,
and the other typically extracts archives, so many new files with =
different sizes.

Here=E2=80=99s why I think there might be a bug lurking (or I=E2=80=99m =
still missing something):

When the journal in a volume is relatively small (10 MiB) but the amount =
of
data in writeback is around 450 MiB this indicates regular file content
being flushed. I only see 3 mib/s at around 100 iops (indicating average =
32k writes).

The 100 IOPS is a weird number here. Especially as at this time customer =
traffic
is impacted and apparently completely stalled. My impression from =
reading about
the writeback mechanisms and your description of journal flushes was =
that=20
none of the flushing operations should cause a full stall until the =
caches or
journal is empty, but allow traffic to trickle, roughly at the backing =
storage
speed. Of course, if the system adds more traffic then is being written =
out
then it would still starve.

(I=E2=80=99m guessing that the journal flush doesn=E2=80=99t go through =
the writeback cache.
So maybe the journal isn=E2=80=99t really involved here at all.)

So, could it be that there is some (faulty) relationship with the cgroup
throttling interacting with the writeback and/or journal flush that =
causes=20
a) the available IOPS from the backing storage not being properly used =
and
b) other traffic being stalled that shouldn=E2=80=99t be?

How would I go about proving that?

I tried again to replicate the worst case traffic patterns and ran=20

fio --rw=3Drandwrite --name=3Dsynctest --bs=3D512 --direct=3D1 =
--numjobs=3D1 --ioengine=3Dlibaio --iodepth=3D8 --runtime=3D600 =
--fdatasync=3D8 --size=3D10m

which gave me consistent ~250 IOPS and finished in around 80 seconds.=20

I=E2=80=99m going to try to find a machine that exhibits the issues most =
often
and will a) apply lower bounds for the writeback cache, b) remove the
cgroup limits and c) both.

Thanks again,
Christian

> On 18. Jun 2025, at 23:54, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Wed, Jun 18, 2025 at 03:01:26PM +0200, Christian Theune wrote:
>> [=E2=80=A6]
>> Yeah, I=E2=80=99m very wary of reporting these tracebacks as =
potential
>> bugs because of them easily being just a hint on slow storage. My
>> problem here is that I can=E2=80=99t point to anything that says the
>> storage would have been slow.
>>=20
>> I=E2=80=99ve gone through all metrics and logs on the KVM servers as =
well
>> as the Ceph servers and they=E2=80=99ve been performing completely at
>> baseline level regarding errors, queues, iops, latency.
>>=20
>> I=E2=80=99ve done a measurement to try to emulate those accesses by
>> running
>>=20
>> $ fio --rw=3Drandrw --name=3Dsynctest --bs=3D4k --direct=3D1 =
--numjobs=3D1
>> --ioengine=3Dlibaio --iodepth=3D1 --runtime=3D600 --write_barrier=3D1
>> --size=3D60m
>>=20
>> I hope this is sufficiently comparable behaviour (maybe with a
>> different read/write ratio instead of 0.5?) to what XFS log
>> flushing does. This resulted in [1].
>=20
> Not really comparable. "write-barrier" is not the option for data
> integrity - fdatasync=3D8 would be closer, but even that doesn't
> replicate the cache flush/fua write pattern of journal IOs.
>=20
> Also, journals are write only and sequential, not random. The
> iodepth is typically 8 when fully busy, and the IO size ranges from
> single sector to logbsize (from /proc/mounts) depending on the
> workload.
>=20
> Metadata writeback to clear the journal, OTOH, is larger random
> 4kB writes with no data integrity implied (the journal cache flush
> mechanism I mention above handles that).
>=20
>=20
>> My interpretation of this measurement (and the VM showed no illnes
>> while this was running over 10 minutes): the VM is throttled at
>> 250 IOPs and is reporting back after 10 minutes of 4k random
>> writes with average IOPS of exactly 250. The latencies are a bit
>> varied, this could be due to Qemu throttling. The max latency was
>> 133ms, the average 2ms. This is on a 10g storage network with Ceph
>> that requires another network roundtrip for replication before
>> ACKing a write.
>=20
> Oh. Ceph.
>=20
> Slow random write performance on ceph rbd devices seem to be a
> recurring problem - the filesystem is way faster than the storage,
> and by the time the filesystem throttles on journal space (even with
> small logs), the backlog of IO cannot be drained very quickly and so
> everything stalls.
>=20
> IOWs, a hard cap of 250 random 4kB write IOPS is extremely slow and
> a likely cause of your random stall problems. When you have lots of
> dirty metadata in memory, then it can take minutes of IO for
> writeback to free journal space to allow progress to be made again.
>=20
> For example, modify an inode (e.g. chmod), and that only takes ~250
> bytes of journal space to record. So a 10MB journal can hold ~40,000
> dirty inodes. If we assume that there maximum locality in these
> inodes (i.e. best case writeback IO patterns) we have ~1300 x 16kB
> writes to perform to empty the journal.
>=20
> Hence there's up to 10-15s of writeback IO to "unstall" a small
> journal. Worst case, it's one 16kB write per inode, and that means
> potential for multiple minutes of writeback to unstall a 10MB
> journal. Now consider a 64MB journal, and the potential stalls
> waiting on metadata writeback are much, much worse...
>=20
> These stalls will come and go with workload peaks. The filesystem
> can soak up some of the peak into memory and the journal, then it
> throttles to storage speed and that's where the hung task warnings
> fire. Once the storage catches up, everything goes back to "normal"
> latencies.
>=20
>> I=E2=80=99m out of ideas for now, I=E2=80=99ll keep thinking about =
this. If anyone
>> has any pointer for further tests in any direction, I=E2=80=99m open =
to
>> anything. ;)
>=20
> Don't use hard throttling on IOPS rates. Measure IO rates over a
> longer period of time (e.g. rolling average over a minute) so that
> the storage can rapidly sink the short term IO peaks that occur when
> the workload runs the journal out of space and the fs throttles it
> whilst metadata writeback makes progress.
>=20
> -Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

