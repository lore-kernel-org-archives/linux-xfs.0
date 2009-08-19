Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7J2HvmB180953 for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 21:18:07 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C30C93DE9DA
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 19:18:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id 1kolfaO4jhz4vc7B for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2009 19:18:16 -0700 (PDT)
Date: Tue, 18 Aug 2009 22:18:12 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <606994882.2142291250648292843.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <990461759.2142271250648177725.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: XFS corruption with failover
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: John Quigley <jquigley@jquigley.com>
Cc: XFS Development <xfs@oss.sgi.com>

----- "John Quigley" <jquigley@jquigley.com> wrote:

> Lachlan McIlroy wrote:
> > If that fails too can you run xfs_logprint on /dev/sde and
> > post any errors it reports?
> 
> My apologies for the delayed response; output of logprint can be
> downloaded as a ~4MB bzip:
> 
> http://www.jquigley.com/files/tmp/xfs-failover-logprint.bz2

xfs_logprint doesn't find any problems with this log but that doesn't mean
the kernel doesn't - they use different implementations to read the log.  I
noticed that the active part of the log wraps around the physical end/start
of the log which reminds of this fix:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d1afb678ce77b930334a8a640a05b8e68178a377

I remember that without this fix we were seeing ASSERTs in the log recovery
code - unfortunately I don't remember exactly where but it could be from
the same location you are getting the "bad clientid" error.  When a log
record wraps the end/start of the physical log we need to do two I/Os to
read the log record in.  This bug caused the second read to go to an
incorrect location in the buffer which overwrote part of the first I/O and
corrupted the log record.  I think the fix made it into 2.6.24.

> 
> Thanks very much for your consideration.
> 
> - John Quigley
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
