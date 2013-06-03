Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1519129DF8
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 23:01:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83F0AAC004
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 21:01:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OY3JwgzBqZElVbdy for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 21:01:01 -0700 (PDT)
Date: Mon, 3 Jun 2013 14:00:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.4 Oops running xfstests (WAS Re: 3.9.3: Oops running xfstests)
Message-ID: <20130603040038.GX29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
	<20130527053608.GS29466@dastard>
	<1588848128.8530921.1369885528565.JavaMail.root@redhat.com>
	<20130530052049.GK29466@dastard>
	<1824023060.8558101.1369892432333.JavaMail.root@redhat.com>
	<1462663454.9294499.1369969415681.JavaMail.root@redhat.com>
	<20130531060415.GU29466@dastard>
	<1517224799.10311874.1370228651422.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1517224799.10311874.1370228651422.JavaMail.root@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: CAI Qian <caiqian@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jun 02, 2013 at 11:04:11PM -0400, CAI Qian wrote:
> 
> > There's memory corruption all over the place.  It is most likely
> > that trinity is causing this - it's purpose is to trigger corruption
> > issues, but they aren't always immediately seen.  If you can trigger
> > this xfs trace without trinity having been run and without all the
> > RCU/idle/scheduler/cgroup issues occuring at the same time, then
> > it's likely to be caused by XFS. But right now, I'd say XFS is just
> > an innocent bystander caught in the crossfire. There's nothing I can
> > do from an XFS persepctive to track this down...
> OK, this can be reproduced by just running LTP and then xfstests without
> trinity at all...

Cai, can you be more precise about what is triggering it?  LTP and
xfstests do a large amount of stuff, and stack traces do not do not
help narrow down the cause at all.  Can you provide the follwoing
information and perform the follwoing steps:

	1. What xfstest is tripping over it? 
	2. Can you reproduce it just by running that one specific test
	  on a pristine system (i.e. freshly mkfs'd filesystems,
	  immediately after boot)
	3. if you can't reproduce it like that, does it reproduce on
	  an xfstest run on a pristine system? If so, what command
	  line are you running, and what are the filesystem
	  configurations?
	4. if you cannot reproduce it just with xfstests and you need
	  to run LTP first, then can you just run the xfstest that
	  is failing after running LTP and see if that triggers the
	  problem. If it does, please take a metadump of the
	  filesystems after LTP has run, save them, and if the
	  single test then fails send me the metadumps and your
	  xfstests command line.
	5. If all else fails, bisect the kernel to identify the
	  commit that introduces the problem....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
