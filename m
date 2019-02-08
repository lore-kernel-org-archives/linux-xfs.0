Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46303 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfBHTse (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 14:48:34 -0500
Date: Fri, 8 Feb 2019 11:48:29 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190208194829.GJ11489@garbanzo.do-not-panic.com>
References: <20190204165427.23607-1-mcgrof@kernel.org>
 <20190205220655.GF14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205220655.GF14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Wed, Feb 06, 2019 at 09:06:55AM +1100, Dave Chinner wrote:
> On Mon, Feb 04, 2019 at 08:54:17AM -0800, Luis Chamberlain wrote:
> > Kernel stable team,
> > 
> > here is a v2 respin of my XFS stable patches for v4.19.y. The only
> > change in this series is adding the upstream commit to the commit log,
> > and I've now also Cc'd stable@vger.kernel.org as well. No other issues
> > were spotted or raised with this series.
> > 
> > Reviews, questions, or rants are greatly appreciated.
> 
> Test results?
> 
> The set of changes look fine themselves, but as always, the proof is
> in the testing...

I've first established a baseline for v4.19.18 with fstests using
a series of different sections to test against. I annotated the
failures on an expunge list and then use that expunge list to confirm
no regressions -- no failures if we skip the failures already known for
v4.19.18.

Each different configuration I test against I use a section for. I only
test x86_64 for now but am starting to create a baseline for ppc64le.

The sections I use:

  * xfs
  * xfs_nocrc
  * xfs_nocrc_512
  * xfs_reflink
  * xfs_reflink_1024
  * xfs_logdev
  * xfs_realtimedev

The sections definitions for these are below:

[xfs]
MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0'
USE_EXTERNAL=no
LOGWRITES_DEV=/dev/loop15
FSTYP=xfs

[xfs_nocrc]
MKFS_OPTIONS='-f -m crc=0,reflink=0,rmapbt=0, -i sparse=0,'
USE_EXTERNAL=no
LOGWRITES_DEV=/dev/loop15
FSTYP=xfs

[xfs_nocrc_512]
MKFS_OPTIONS='-f -m crc=0,reflink=0,rmapbt=0, -i sparse=0, -b size=512,'
USE_EXTERNAL=no
LOGWRITES_DEV=/dev/loop15
FSTYP=xfs

[xfs_reflink]
MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1,'
USE_EXTERNAL=no
LOGWRITES_DEV=/dev/loop15
FSTYP=xfs

[xfs_reflink_1024]
MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=1024,'
USE_EXTERNAL=no
LOGWRITES_DEV=/dev/loop15
FSTYP=xfs

[xfs_logdev]
MKFS_OPTIONS="-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0 -lsize=1g"
SCRATCH_LOGDEV=/dev/loop15
USE_EXTERNAL=yes
FSTYP=xfs

[xfs_realtimedev]
MKFS_OPTIONS="-f -lsize=1g"
SCRATCH_LOGDEV=/dev/loop15
SCRATCH_RTDEV=/dev/loop14
USE_EXTERNAL=yes
FSTYP=xfs

These are listed in my example.config which oscheck copies over to
/var/lib/xfstests/config/$(hostname).config upon install if you don't
have one.

I didn't find any regressions against my tests.

The baseline is reflected on oscheck's expunge list per kernel release,
so in this case expunges/4.19.18. A file exists for each section which
tests are known to fail.

I'll put them below here for completeness, but all of these files are
present on my oscheck repository [0], it is what I use to track baselines
for upstream kernels for fstests failures:

$ cat expunges/4.19.18/xfs/unassigned/xfs.txt
generic/091
generic/263
generic/464 # after ~6 runs
generic/475 # after ~15 runs
generic/484
xfs/191-input-validation
xfs/278
xfs/451
xfs/495
xfs/499

$ cat expunges/4.19.18/xfs/unassigned/xfs_nocrc.txt
generic/091
generic/263
generic/464 # after ~39 runs
generic/475 # after ~5-10 runs
generic/484
xfs/191-input-validation
xfs/273
xfs/278
xfs/451
xfs/495
xfs/499

$ cat expunges/4.19.18/xfs/unassigned/xfs_nocrc_512.txt
generic/091
generic/263
generic/475 # after ~33 runs
generic/482 # after ~16 runs
generic/484
xfs/071
xfs/191-input-validation
xfs/273
xfs/278
xfs/451
xfs/495
xfs/499

$ cat expunges/4.19.18/xfs/unassigned/xfs_reflink.txt
generic/091
generic/263
generic/464 # after ~1 run
generic/475 # after ~5 runs
generic/484
xfs/191-input-validation
xfs/278
xfs/451
xfs/495
xfs/499

$ cat expunges/4.19.18/xfs/unassigned/xfs_reflink_1024.txt
generic/091
generic/263
generic/475 # after ~2 runs
generic/484
xfs/191-input-validation
xfs/278
xfs/451
xfs/495
xfs/499

The xfs_logdev and xfs_realtimedev sections use an external log, and as
I have noted before it seems works is needed to rule out an actual
failure.

But for completely the test which fstests says fail for these sections
are below:

$ cat expunges/4.19.18/xfs/unassigned/xfs_logdev.txt
generic/034
generic/039
generic/040
generic/041
generic/054
generic/055
generic/056
generic/057
generic/059
generic/065
generic/066
generic/073
generic/081
generic/090
generic/091
generic/101
generic/104
generic/106
generic/107
generic/177
generic/204
generic/207
generic/223
generic/260
generic/263
generic/311
generic/321
generic/322
generic/325
generic/335
generic/336
generic/341
generic/342
generic/343
generic/347
generic/348
generic/361
generic/376
generic/455
generic/459
generic/464 # fails after ~2 runs
generic/475 # fails after ~5 runs, crashes sometimes
generic/482
generic/483
generic/484
generic/489
generic/498
generic/500
generic/502
generic/510
generic/512
generic/520
shared/002
shared/298
xfs/030
xfs/033
xfs/045
xfs/070
xfs/137
xfs/138
xfs/191-input-validation
xfs/194
xfs/195
xfs/199
xfs/278
xfs/284
xfs/291
xfs/294
xfs/424
xfs/451
xfs/495
xfs/499

$ cat expunges/4.19.18/xfs/unassigned/xfs_realtimedev.txt
generic/034
generic/039
generic/040
generic/041
generic/054
generic/056
generic/057
generic/059
generic/065
generic/066
generic/073
generic/081
generic/090
generic/091
generic/101
generic/104
generic/106
generic/107
generic/177
generic/204
generic/207
generic/223
generic/260
generic/263
generic/311
generic/321
generic/322
generic/325
generic/335
generic/336
generic/341
generic/342
generic/343
generic/347
generic/348
generic/361
generic/376
generic/455
generic/459
generic/464 # fails after ~40 runs
generic/475 # fails, and sometimes crashes
generic/482
generic/483
generic/484
generic/489
generic/498
generic/500
generic/502
generic/510
generic/512
generic/520
shared/002
shared/298
xfs/002
xfs/030
xfs/033
xfs/068
xfs/070
xfs/137
xfs/138
xfs/191-input-validation
xfs/194
xfs/195
xfs/199
xfs/278
xfs/291
xfs/294
xfs/419
xfs/424
xfs/451
xfs/495
xfs/499

Perhaps worth noting which was curious is that I could not get to
trigger generic/464 on sections xfs_nocrc_512 and xfs_reflink_1024.

Athough I don't have a full baseline for ppc64le I did confirm that
backporting upstream commit 837514f7a4ca fixes the kernel.org bug [1]
report triggerable via generic/070 on ppc64le.

If you have any questions please let me know.

[0] https://gitlab.com/mcgrof/oscheck
[1] https://bugzilla.kernel.org/show_bug.cgi?id=201577

  Luis
