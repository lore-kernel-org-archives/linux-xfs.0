Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o86M3WQ1202847 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 17:03:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72FA215E0DFD
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 15:15:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	nALmqB85FjJyBTCA for <xfs@oss.sgi.com>;
	Mon, 06 Sep 2010 15:15:18 -0700 (PDT)
Date: Tue, 7 Sep 2010 08:04:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Message-ID: <20100906220410.GD7362@dastard>
References: <201008191312.49346@zmi.at>
	<20100906154254.5542426c@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100906154254.5542426c@harpe.intellique.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 06, 2010 at 03:42:54PM +0200, Emmanuel Florac wrote:
> Le Thu, 19 Aug 2010 13:12:45 +0200
> Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:
> =

> > The subject is a bit harsh, but overall the article says:
> > XFS is slowest on creating and deleting a billion files
> > XFS fsck needs 30GB RAM to fsck that 100TB filesystem.
> =

> Just to go on this subject : a colleague (following my suggestion :)
> tried to create 1 billion files in the same XFS directory.
> Unfortunately the directories themselves don't scale well that far :
> after 1 million files in the first 30 minutes, file creation slows down
> gradually, so after 100 hours we had about 230 million files. The
> directory size at that point was 5,3 GB.

Oh, that's larger than I've every run before ;)

Try using:

# mkfs.xfs -d size=3D64k

Will speed up large directory operations by at least an order of
magnitude.

> Now we're starting afresh with 1000 directories with 1 million files
> each :)

Which is exactly the test that was used to generate the numbers that
were published.

> (Kernel version used : vanilla 2.6.32.11 x86_64 smp)

Not much point in testing that kernel - delayed logging is where the
future is for this sort of workload, which is what I'm testing.

FWIW, I'm able to create 50 million inodes in under 14 minutes with
delayed logging and 8 threads using directories of 100k entries.

The run to 1 billion inodes that I started late last night (10 hours
in) has just passed 700M inodes on a 16TB filesystem.  It's running
at about 25,000 creates/s, but it is limited by bad shrinker
behaviour causing the dentry cache to be completely trashed causing
~3000 read iops to reload dentries that are still necessary for
operation. It should be running about 3-4x faster than that.

FYI, The reason I'm taking a while to get numbers is that parallel
create workloads of this scale are showing significant problems (VM
livelocks, shrinker misbehaviour, lock contention in IO completion
processing, buffer cache hash scaling issues, etc) and I'm trying to
fix them as I go - these metadata workloads are completely
unexplored territory....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
