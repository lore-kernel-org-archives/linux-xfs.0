Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 04:31:19 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m15CV9Fm025857
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 04:31:14 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BFB3D90E0C
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 04:31:32 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id jdFu52qNiXCan4c4 for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 04:31:32 -0800 (PST)
Message-ID: <47A85721.2090807@tlinx.org>
Date: Tue, 05 Feb 2008 04:31:29 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net> <47A72FBC.9090701@pobox.com> <47A7411F.2040702@sandeen.net> <47A749C9.6010503@msgid.tls.msk.ru>
In-Reply-To: <47A749C9.6010503@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org



Michael Tokarev wrote:
> note that with some workloads, write caching in
> the drive actually makes write speed worse, not better - namely,
> in case of massive writes.
----
	With write barriers enabled, I did a quick test of
a large copy from one backup filesystem to another.
	I'm not what you refer to when you say large, but
this disk has 387G used with 975 files, averaging about 406MB/file.

I was copying from /hde (ATA100-750G) to
/sdb (SATA-300-750G) (both, basically underlying model)

Of course your 'mileage may vary', and these were averages over
12 runs each (w/ + w/out wcaching);

(write cache on)         write    read
dev ave           TPS     MB/s    MB/s
hde ave          64.67   30.94     0.0
sdb ave         249.51    0.24    30.93

(write cache off)        write    read
dev ave          TPS      MB/s    MB/s
hde ave          45.63   21.81     0.0
xx: ave         177.76   0.24     21.96

write w/cache =         (30.94-21.86)/21.86     => 45% faster
w/o write cache =       100-(100*21.81/30.94)   => 30% slower

These disks have barrier support, so I'd guess the differences would
have been greater if you didn't worry about losing w-cache contents.

If  barrier support doesn't work and one has to disable write-caching,
that is a noticeable performance penalty.

All writes with noatime, nodiratime, logbufs=8.


FWIW...slightly OT, the rates under Win for their write-through (FAT32-perf)
vs. write-back caching (NTFS-perf) were FAT about 60% faster over NTFS or
NTFS ~ 40% slower than FAT32 (with ops for no-last-access and no 3.1
filename creation)
