Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T0ULSG008374 for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 19:30:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8745FAFFA8
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 17:31:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	rnFsloMDGKQyTR2R for <xfs@oss.sgi.com>;
	Tue, 28 Sep 2010 17:31:18 -0700 (PDT)
Date: Wed, 29 Sep 2010 10:31:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: allocsize mount option
Message-ID: <20100929003110.GH5665@dastard>
References: <C8C787CA.44AA%ivan.novick@emc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C8C787CA.44AA%ivan.novick@emc.com>
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
To: Ivan.Novick@emc.com
Cc: Timothy.Heath@emc.com, xfs@oss.sgi.com

On Tue, Sep 28, 2010 at 02:53:46PM -0400, Ivan.Novick@emc.com wrote:
> Hi all,
> 
> According to the documentation the allocsize mount option: "Sets the
> buffered I/O end-of-file preallocation size when doing delayed allocation
> writeout"
> 
> Will this value limit "extent" sizes to be be no smaller than the allocsize?

No - it's specualtive preallocation.

> I have set the following mount options:
> (rw,noatime,nodiratime,logbufs=8,allocsize=512m)

/me wishes he could run a sed script across the internet.

noatime implies nodiratime, and logbufs=8 is the default, so you
only need "noatime,allocsize=512m"

> And yet, depending on the workload, the extent sizes are often 1 or 2 orders
> of magnitude lower than 512 MB ...

It's speculative and there's no guarantee that it can find a big
enough extent to complete the full allocsize allocation. Also, when
you close the file the speculative allocation beyond EOF is
truncated away. This is a particular problem with NFS servers.

> If I wanted to do further reading on the subject, can someone point me to an
> approximate location in the code where the size of a newly created extent is
> determined?

Start here:

fs/xfs/xfs_iomap.c::xfs_iomap_write_delay()

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
