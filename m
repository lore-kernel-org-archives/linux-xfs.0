Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A5BDA7CA0
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 18:28:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6707F304039
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 16:28:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	A1kXLYSTPoqev1rl for <xfs@oss.sgi.com>;
	Sat, 04 Jun 2016 16:28:03 -0700 (PDT)
Date: Sun, 5 Jun 2016 09:28:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hole punch races
Message-ID: <20160604232800.GW26977@dastard>
References: <20160322155740.GB28772@quack.suse.cz>
	<1465060270.2847.149.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1465060270.2847.149.camel@decadent.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org, xfs@oss.sgi.com

On Sat, Jun 04, 2016 at 06:11:10PM +0100, Ben Hutchings wrote:
> On Tue, 2016-03-22 at 16:57 +0100, Jan Kara wrote:
> =

> Hi,
> =

> similarly to ext4 also XFS had races between hole punching and page faults
> which could result in data corruption. The fixes were merged in 4.1-rc1 b=
ut
> it might make sense to backport them to older stable releases given the
> nature of the issue.
> =

> Relevant fixes are:
> =

> de0e8c20ba3a65b0f15040aabbefdc1999876e6b
> 075a924d45cc69c75a35f20b4912b85aa98b180a
> e8e9ad42c1f1e1bfbe0e8c32c8cac02e9ebfb7ef
> 0f9160b444e4de33b65dfcd3b901358a3129461a
> 723cac48473358939759885a18e8df113ea96138
> ec56b1f1fdc69599963574ce94cc5693d535dd64
> =

> =

> You missed the first in that sequence:
> =

> 653c60b633a9 xfs: introduce mmap/truncate lock
> =

> For 3.16, I've queued up all=A0those fixes with one further=A0prerequisit=
e:
> =

> 812176832169 xfs: fix swapext ilock deadlock
> =

> For 3.2, I've queued up all but 723cac484733, with these additional
> prerequisites:
> =

> f38996f57687 xfs: reduce ilock hold times in xfs_setattr_size
> bc4010ecb8f4 xfs: use iolock on XFS_IOC_ALLOCSP calls
> 76ca4c238cf5 xfs: always take the iolock around xfs_setattr_size
> 5f8aca8b43f4 xfs: always hold the iolock when calling xfs_change_file_spa=
ce
> I realise I'll need to check for regressions with xfstests.

Hi Ben,

You do realise that this sort of backport effectively makes the
stable kernels unsupportable by the upstream XFS developers? You're
taking random changes from the upstream kernel until the kernel
compiles, and then mostly hoping that it works.

It's trivially easy to break truncate by screwing up the locking and
IO barriers that it depends on, and this set of patches make quite a
lot of different changes that have an unknown set of dependencies
for correct behaviour. xfstests won't find all those problems; at
best it will tell us that there won't be obvious problems.

Stable kernels are supposed to be stable, and backports like this
are riskier than the original changes in the upstream kernels. if a
user is hitting a mmap/hole-punch race on an XFS filesytem (I can't
remember any reports to the upstream list for any kernel) on a 3.2
kernel, then correct answer is "upgrade to a newer upstream kernel",
not "do a risky backport that exposes the entire user base to the
potential of new data corruption bugs"....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
