Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KGZYBA100024 for <xfs@oss.sgi.com>; Fri, 20 May 2011 11:35:35 -0500
Received: from e34.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13829CF6831
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 09:35:23 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id aRSD9goIKbYbb4EY for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 09:35:23 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4KGMltC021321
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 10:22:47 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4KGaPSn136996 for <xfs@oss.sgi.com>; Fri, 20 May 2011 10:36:26 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p4KAZ4iw020805
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 04:35:05 -0600
Subject: Re: Failure of xfstest 229
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110520025840.GP32466@dastard>
References: <1305852937.7661.369.camel@chandra-lucid.beaverton.ibm.com>
	<20110520025840.GP32466@dastard>
Date: Fri, 20 May 2011 09:35:03 -0700
Message-ID: <1305909303.7661.373.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>


Can it run successfully by fluke sometimes ? I did have a successful run
on the 20G filesystem yesterday once, but not able to reproduce it again
---------------
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 test201 2.6.39
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdd2
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdd2
/mnt/xfsScratchMntPt

229 70s ... 118s
Ran: 229
Passed all 1 tests
-----------------

chandra
On Fri, 2011-05-20 at 12:58 +1000, Dave Chinner wrote:
> On Thu, May 19, 2011 at 05:55:37PM -0700, Chandra Seetharaman wrote:
> > Hi all,
> > 
> > I remember running this test successfully sometime back. 
> 
> No. it's never passed. It's a placeholder to remind us how to
> reproduce a known problem that is difficult to fix.
> 
> Cheers,
> 
> Dave.
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
