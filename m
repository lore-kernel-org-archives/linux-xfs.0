Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6QAHal5113683 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 05:17:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3910B4713BF
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 03:20:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	nLgccTaphxTdXX1k for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 03:20:39 -0700 (PDT)
Date: Mon, 26 Jul 2010 20:20:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100726102036.GH7362@dastard>
References: <20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100724023922.GP32635@dastard>
	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
	<20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
	<20100726060604.GF7362@dastard>
	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

On Sun, Jul 25, 2010 at 11:46:29PM -0700, Eli Morris wrote:
> On Jul 25, 2010, at 11:06 PM, Dave Chinner wrote:
> > On Sun, Jul 25, 2010 at 09:04:03PM -0700, Eli Morris wrote:
> >> On Jul 25, 2010, at 8:45 PM, Dave Chinner wrote:
> > I've just confirmed that the problem does not exist at top-of-tree.
> > The following commands gives the right output, and the repair at the
> > end does not truncate the filesystem:
> > 
> > xfs_io -f -c "truncate $((13427728384 * 4096))" fsfile
> > mkfs.xfs -f -l size=128m,lazy-count=0 -d size=13427728384b,agcount=126,file,name=fsfile
> > xfs_io -f -c "truncate $((16601554944 * 4096))" fsfile
> > mount -o loop fsfile /mnt/scratch
> > xfs_growfs /mnt/scratch
> > xfs_info /mnt/scratch
> > umount /mnt/scratch
> > xfs_db -c "sb 0" -c "p agcount" -c "p dblocks" -f fsfile
> > xfs_db -c "sb 1" -c "p agcount" -c "p dblocks" -f fsfile
> > xfs_db -c "sb 127" -c "p agcount" -c "p dblocks" -f fsfile
> > xfs_repair -f fsfile
> > 
> > So rather than try to triage this any further, can you upgrade your
> > kernel/system to something more recent?
> 
> I can update this to Centos 5 Update 4, but I can't install
> updates forward of it's release date of Dec 15, 2009. The reason
> is that this is the head node of a cluster and it uses the Rocks
> cluster distribution. The newest of Rocks is based on Centos 5
> Update 4, but Rocks systems do not support updates (via yum, for
> example). 
> 
> Updating the OS takes me a day or two for the whole cluster and
> all the user programs. If you're pretty sure that will fix the
> problem, I'll go for it tomorrow. I'd appreciate it very much if
> you could let me know if Centos 5.4 is recent enough that it will
> fix the problem..

The only way I can find out is to load CentOS 5.4 onto a
system and run the above test. You can probably do that just as
easily as I can...

> I will note that I've grown the filesystem several times, and
> while I recall having to unmount and remount the filesystem each
> time for it to report its new size, I've never seen it fall back
> to its old size when running xfs_repair. In fact, the original
> filesystem is about 12 TB, so xfs_repair only reverses the last
> grow and not the previous ones.

Hmmm - I can't recall any bug where unmount was required before
the new size would show up. I know we had problems with arithmetic
overflows in both the xfs_growfs binary and the kernel code, but
they did not manifest in this manner. Hence I can't really say why
you are seeing that behaviour or why this time it is different.

The suggestion of using a recent live CD to do the grow is a good
one - it might be your best option, rather than upgrading everything....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
