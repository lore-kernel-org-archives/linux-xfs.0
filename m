Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBOD5prH076496 for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 07:05:53 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8CAC12EB124
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 05:06:32 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id vO7xAqYvVUzoA431
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 05:06:32 -0800 (PST)
MIME-Version: 1.0
Message-ID: <19251.26403.762180.228181@tree.ty.sabi.co.uk>
Date: Thu, 24 Dec 2009 13:05:39 +0000
Subject: Re: [Jfs-discussion] benchmark results
In-Reply-To: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
From: pg_jf2@jf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org

> I've had the chance to use a testsystem here and couldn't
> resist

Unfortunately there seems to be an overproduction of rather
meaningless file system "benchmarks"...

> running a few benchmark programs on them: bonnie++, tiobench,
> dbench and a few generic ones (cp/rm/tar/etc...) on ext{234},
> btrfs, jfs, ufs, xfs, zfs. All with standard mkfs/mount options
> and +noatime for all of them.

> Here are the results, no graphs - sorry: [ ... ]

After having a glance, I suspect that your tests could be
enormously improved, and doing so would reduce the pointlessness of
the results.

A couple of hints:

* In the "generic" test the 'tar' test bandwidth is exactly the
  same ("276.68 MB/s") for nearly all filesystems.

* There are read transfer rates higher than the one reported by
  'hdparm' which is "66.23 MB/sec" (comically enough *all* the
  read transfer rates your "benchmarks" report are higher).

BTW the use of Bonnie++ is also usually a symptom of a poor
misunderstanding of file system benchmarking.

On the plus side, test setup context is provided in the "env"
directory, which is rare enough to be commendable.

> Short summary, AFAICT:
>     - btrfs, ext4 are the overall winners
>     - xfs to, but creating/deleting many files was *very* slow

Maybe, and these conclusions are sort of plausible (but I prefer
JFS and XFS for different reasons); however they are not supported
by your results as they seem to me to lack much meaning, as what is
being measured is far from clear, and in particular it does not
seem to be the file system performance, or anyhow an aspect of
filesystem performance that might relate to common usage.

I think that it is rather better to run a few simple operations
(like the "generic" test) properly (unlike the "generic" test), to
give a feel for how well implemented are the basic operations of
the file system design.

Profiling a file system performance with a meaningful full scale
benchmark is a rather difficult task requiring great intellectual
fortitude and lots of time.

>     - if you need only fast but no cool features or
>       journaling, ext2 is still a good choice :)

That is however a generally valid conclusion, but with a very,
very important qualification: for freshly loaded filesystems.
Also with several other important qualifications, but "freshly
loaded" is a pet peeve of mine :-).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
