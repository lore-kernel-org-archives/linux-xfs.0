Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C081199EBB;
	Mon, 30 Sep 2024 18:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727720493; cv=none; b=n2qsGdf/RBIWlzwGRj80u66R6zdooNq4fu/4ozZrl0TQnzey++kBngSSb1auqgiO1OZ1J5N5bAK+mZ3Dv5SqsppkuUo+NpNzYG71n2Y/nxi6YmZ8aQSu6md6pHXhwNHsPKFVwZXCkJQf281PdMBmgnuE6squGReFlyTESWyswog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727720493; c=relaxed/simple;
	bh=V7cddzF/pQRz4rqcxRBIlpqzQgQoi45u5QXiGwaYqc0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ll68GV6K3u+6Z6jHob4+1/Ezx9fNKx/rv5VdUuknxwZ2iJkS2qr5NXDecnCkUo6XII5ftkvxl7RHSK/Ud+UD9ELNW90xhLPC6HWy/w29g/aFWty6eb8of3wlxGbNxsIVXHUDjUOAKGI1sr5t3lvLds/nwuwZiP/4SgHPflVDXDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHSESOg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHSESOg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D447C4CEC7;
	Mon, 30 Sep 2024 18:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727720493;
	bh=V7cddzF/pQRz4rqcxRBIlpqzQgQoi45u5QXiGwaYqc0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=DHSESOg3fnQFakKPORpVkRH2y9YC7O0xLgGTnoAefxCTqIxXKiyaikWECLxyRMaWr
	 aKHOEIGLGrN7+27eU3dPfcFH0RWF0mI7tX792ACOecdW3U2aibFpo5/5J0LE3lyQrN
	 9oiW6gVdxu/wLerizb5n0W3OhQ01ILlsH/ICCnRTsSaGLR33KRu9QR5yk4hPh3QF1W
	 Ivow0hcN3PgbFV1l6PhZ4/mTiegmsO4BAl+stJo6thFsk075iJE/zaobcHLyIg2LhY
	 VjG6pOGe/okpDnrkJbnQKhzySfgOMT9Y87ODdCyppGC1WqzD7S7+ACAGInSaNgT26g
	 BIxq44fajpctA==
Message-ID: <3ae3693f35018e73cc6f629cb88c0a5e305e3137.camel@kernel.org>
Subject: Re: [linux-next:master] [xfs]  3062a738d7: 
 filebench.sum_operations/s -85.0% regression
From: Jeff Layton <jlayton@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, oe-lkp@lists.linux.dev,
 lkp@intel.com,  Linux Memory Management List <linux-mm@kvack.org>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 "Darrick J. Wong" <djwong@kernel.org>,  linux-xfs@vger.kernel.org,
 ying.huang@intel.com, feng.tang@intel.com,  fengwei.yin@intel.com
Date: Mon, 30 Sep 2024 14:21:30 -0400
In-Reply-To: <202409292200.d8132f52-oliver.sang@intel.com>
References: <202409292200.d8132f52-oliver.sang@intel.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

This is a known problem.

I have a fix that moves the floor handing into the timekeeper, but
Thomas said he had a better way to do this, so I haven't resent them
yet.

The patches in Christian's tree are out of date, so it may be best to
just drop them for now until I have the newer set ready.

Thanks,
Jeff

On Sun, 2024-09-29 at 22:36 +0800, kernel test robot wrote:
> hi, Jeff Layton,
>=20
> we reported
> "[jlayton:mgtime] [xfs]  4edee232ed:  fio.write_iops -34.9% regression"
> in
> https://lore.kernel.org/all/202406141453.7a44f956-oliver.sang@intel.com/
>=20
> you asked us to supply further information at that time.
>=20
> now we noticed this commit is in linux-next/master, and we observed the
> regression for a different test - filebench. FYI.
>=20
>=20
>=20
> Hello,
>=20
> kernel test robot noticed a -85.0% regression of filebench.sum_operations=
/s on:
>=20
>=20
> commit: 3062a738d73c866bf50df13bc47a2223b7b47d87 ("xfs: switch to multigr=
ain timestamps")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>=20
> testcase: filebench
> test machine: 96 threads 2 sockets Intel(R) Xeon(R) Platinum 8260L CPU @ =
2.40GHz (Cascade Lake) with 128G memory
> parameters:
>=20
> 	disk: 1HDD
> 	fs: xfs
> 	fs2: nfsv4
> 	test: filemicro_rwritefsync.f
> 	cpufreq_governor: performance
>=20
>=20
>=20
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202409292200.d8132f52-oliver.san=
g@intel.com
>=20
>=20
> Details are as below:
> -------------------------------------------------------------------------=
------------------------->
>=20
>=20
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20240929/202409292200.d8132f52-ol=
iver.sang@intel.com
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> compiler/cpufreq_governor/disk/fs2/fs/kconfig/rootfs/tbox_group/test/test=
case:
>   gcc-12/performance/1HDD/nfsv4/xfs/x86_64-rhel-8.3/debian-12-x86_64-2024=
0206.cgz/lkp-csl-2sp3/filemicro_rwritefsync.f/filebench
>=20
> commit:=20
>   42ba4ae657 ("Documentation: add a new file documenting multigrain times=
tamps")
>   3062a738d7 ("xfs: switch to multigrain timestamps")
>=20
> 42ba4ae65752b8cb 3062a738d73c866bf50df13bc47=20
> ---------------- ---------------------------=20
>          %stddev     %change         %stddev
>              \          |                \ =20
>       1.48           -13.5%       1.28 =C2=B1  5%  iostat.cpu.iowait
>  4.302e+10 =C2=B1  2%     -21.9%  3.361e+10 =C2=B1  2%  cpuidle..time
>    2316977           -10.5%    2072537        cpuidle..usage
>     763659 =C2=B1 17%     -33.4%     508644 =C2=B1 15%  numa-numastat.nod=
e1.local_node
>     817625 =C2=B1 14%     -30.4%     568838 =C2=B1 11%  numa-numastat.nod=
e1.numa_hit
>       0.32 =C2=B1 12%      -0.0        0.27 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp.idle_cpu
>       0.31 =C2=B1 12%      -0.0        0.26 =C2=B1  6%  perf-profile.self=
.cycles-pp.idle_cpu
>       0.03 =C2=B1 88%    +128.5%       0.08 =C2=B1  6%  perf-sched.sch_de=
lay.avg.ms.schedule_timeout.transaction_kthread.kthread.ret_from_fork
>       0.03 =C2=B1 88%    +128.5%       0.08 =C2=B1  6%  perf-sched.sch_de=
lay.max.ms.schedule_timeout.transaction_kthread.kthread.ret_from_fork
>     523.13           -18.9%     424.32 =C2=B1  2%  uptime.boot
>      48962           -18.9%      39691 =C2=B1  2%  uptime.idle
>     208.10 =C2=B1  7%     -67.4%      67.75 =C2=B1 52%  numa-vmstat.node0=
.nr_mlock
>     816180 =C2=B1 14%     -30.4%     567697 =C2=B1 11%  numa-vmstat.node1=
.numa_hit
>     762194 =C2=B1 17%     -33.4%     507502 =C2=B1 15%  numa-vmstat.node1=
.numa_local
>    4823448           +10.8%    5344826        meminfo.Cached
>     244108 =C2=B1  6%     -41.9%     141806 =C2=B1 29%  meminfo.Dirty
>    2242446           +23.2%    2763206        meminfo.Inactive
>    1552268           +34.0%    2080318        meminfo.Inactive(file)
>       1.49            -0.2        1.29 =C2=B1  5%  mpstat.cpu.all.iowait%
>       0.10 =C2=B1  2%      +0.0        0.12 =C2=B1  4%  mpstat.cpu.all.ir=
q%
>       0.01 =C2=B1  4%      +0.0        0.02 =C2=B1  2%  mpstat.cpu.all.so=
ft%
>       0.03 =C2=B1  2%      +0.0        0.04 =C2=B1  2%  mpstat.cpu.all.us=
r%
>       2603 =C2=B1  2%     +16.6%       3036 =C2=B1  2%  vmstat.io.bo
>       1.43           -13.6%       1.23 =C2=B1  7%  vmstat.procs.b
>       2058           -14.7%       1756        vmstat.system.cs
>       5528           +21.9%       6738 =C2=B1  2%  vmstat.system.in
>       2.10           -84.9%       0.32 =C2=B1 21%  filebench.sum_bytes_mb=
/s
>      16385           -85.0%       2456 =C2=B1 13%  filebench.sum_operatio=
ns
>     273.04           -85.0%      40.94 =C2=B1 13%  filebench.sum_operatio=
ns/s
>       0.00 =C2=B1 14%  +7.2e+05%      24.14 =C2=B1 13%  filebench.sum_tim=
e_ms/op
>     273.00           -85.0%      41.00 =C2=B1 13%  filebench.sum_writes/s
>     447.44 =C2=B1  2%     -21.9%     349.26 =C2=B1  2%  filebench.time.el=
apsed_time
>     447.44 =C2=B1  2%     -21.9%     349.26 =C2=B1  2%  filebench.time.el=
apsed_time.max
>    2343344          +207.9%    7214762 =C2=B1  9%  filebench.time.file_sy=
stem_outputs
>       8762 =C2=B1  2%     -80.1%       1747 =C2=B1  6%  filebench.time.vo=
luntary_context_switches
>     269483 =C2=B1  6%     -17.0%     223745 =C2=B1  8%  sched_debug.cpu.c=
lock.avg
>     269496 =C2=B1  6%     -17.0%     223755 =C2=B1  8%  sched_debug.cpu.c=
lock.max
>     269474 =C2=B1  6%     -17.0%     223735 =C2=B1  8%  sched_debug.cpu.c=
lock.min
>     268974 =C2=B1  6%     -17.0%     223268 =C2=B1  8%  sched_debug.cpu.c=
lock_task.avg
>     269263 =C2=B1  6%     -17.0%     223549 =C2=B1  8%  sched_debug.cpu.c=
lock_task.max
>     261595 =C2=B1  6%     -17.5%     215932 =C2=B1  8%  sched_debug.cpu.c=
lock_task.min
>       8873 =C2=B1  4%     -12.9%       7731 =C2=B1  5%  sched_debug.cpu.c=
urr->pid.max
>       1033 =C2=B1  3%      -9.4%     936.02 =C2=B1  5%  sched_debug.cpu.c=
urr->pid.stddev
>       6038 =C2=B1  5%     -27.7%       4366 =C2=B1  7%  sched_debug.cpu.n=
r_switches.avg
>     977.53 =C2=B1  7%     -17.2%     809.02 =C2=B1  8%  sched_debug.cpu.n=
r_switches.min
>     269486 =C2=B1  6%     -17.0%     223746 =C2=B1  8%  sched_debug.cpu_c=
lk
>     268914 =C2=B1  6%     -17.0%     223174 =C2=B1  8%  sched_debug.ktime
>     270076 =C2=B1  6%     -16.9%     224334 =C2=B1  8%  sched_debug.sched=
_clk
>      15708            -6.1%      14746 =C2=B1  2%  proc-vmstat.nr_active_=
anon
>     817011          +120.3%    1799485 =C2=B1  9%  proc-vmstat.nr_dirtied
>      61152 =C2=B1  6%     -42.0%      35491 =C2=B1 30%  proc-vmstat.nr_di=
rty
>    1206117           +10.8%    1335949        proc-vmstat.nr_file_pages
>     388315           +33.9%     519818        proc-vmstat.nr_inactive_fil=
e
>      18531            +1.0%      18721        proc-vmstat.nr_kernel_stack
>      16540            -3.8%      15909        proc-vmstat.nr_mapped
>     213.82 =C2=B1  4%     -53.7%      99.00 =C2=B1 14%  proc-vmstat.nr_ml=
ock
>      25295            -6.6%      23625        proc-vmstat.nr_shmem
>      24447            -1.6%      24066        proc-vmstat.nr_slab_reclaim=
able
>     817011          +120.3%    1799485 =C2=B1  9%  proc-vmstat.nr_written
>      15708            -6.1%      14746 =C2=B1  2%  proc-vmstat.nr_zone_ac=
tive_anon
>     388315           +33.9%     519818        proc-vmstat.nr_zone_inactiv=
e_file
>     139175           -19.7%     111713 =C2=B1  7%  proc-vmstat.nr_zone_wr=
ite_pending
>    1299984           -13.1%    1129235        proc-vmstat.numa_hit
>    1200290           -14.2%    1029746        proc-vmstat.numa_local
>    2273118 =C2=B1  2%     -10.2%    2042156        proc-vmstat.pgalloc_no=
rmal
>    1203036           -18.6%     979402 =C2=B1  2%  proc-vmstat.pgfault
>    1743917 =C2=B1  2%     -13.4%    1509546        proc-vmstat.pgfree
>    1171848            -8.8%    1069087        proc-vmstat.pgpgout
>      56737           -18.4%      46304 =C2=B1  2%  proc-vmstat.pgreuse
>       2.40 =C2=B1  2%      +7.8%       2.59 =C2=B1  3%  perf-stat.i.MPKI
>   49439015           +14.9%   56804851 =C2=B1  2%  perf-stat.i.branch-ins=
tructions
>       4.34            +0.1        4.47        perf-stat.i.branch-miss-rat=
e%
>    2634429           +20.4%    3171479 =C2=B1  2%  perf-stat.i.branch-mis=
ses
>       5.07 =C2=B1  2%      +0.4        5.46 =C2=B1  3%  perf-stat.i.cache=
-miss-rate%
>     545304 =C2=B1  4%     +22.0%     665397 =C2=B1  5%  perf-stat.i.cache=
-misses
>    7567339           +11.9%    8468261        perf-stat.i.cache-reference=
s
>       2021           -15.8%       1702        perf-stat.i.context-switche=
s
>       2.24            +3.8%       2.33        perf-stat.i.cpi
>  4.391e+08           +14.4%  5.022e+08 =C2=B1  2%  perf-stat.i.cpu-cycles
>     102.06            +1.4%     103.52        perf-stat.i.cpu-migrations
>  2.401e+08           +15.0%  2.761e+08 =C2=B1  2%  perf-stat.i.instructio=
ns
>       0.01 =C2=B1  6%    -100.0%       0.00        perf-stat.i.metric.K/s=
ec
>       5.33            +0.3        5.58        perf-stat.overall.branch-mi=
ss-rate%
>       7.21 =C2=B1  4%      +0.7        7.86 =C2=B1  5%  perf-stat.overall=
.cache-miss-rate%
>   49259568           +14.8%   56567448 =C2=B1  2%  perf-stat.ps.branch-in=
structions
>    2625073           +20.3%    3158787 =C2=B1  2%  perf-stat.ps.branch-mi=
sses
>     543464 =C2=B1  4%     +22.0%     662949 =C2=B1  5%  perf-stat.ps.cach=
e-misses
>    7540908           +11.8%    8433223        perf-stat.ps.cache-referenc=
es
>       2017           -15.8%       1697        perf-stat.ps.context-switch=
es
>  4.373e+08           +14.3%  4.999e+08 =C2=B1  2%  perf-stat.ps.cpu-cycle=
s
>     101.82            +1.4%     103.21        perf-stat.ps.cpu-migrations
>  2.392e+08           +14.9%   2.75e+08 =C2=B1  2%  perf-stat.ps.instructi=
ons
>  1.072e+11           -10.2%  9.632e+10        perf-stat.total.instruction=
s
>=20
>=20
>=20
>=20
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are prov=
ided
> for informational purposes only. Any difference in system hardware or sof=
tware
> design or configuration may affect actual performance.
>=20
>=20

--=20
Jeff Layton <jlayton@kernel.org>
