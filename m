Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4L3vCIn128293 for <xfs@oss.sgi.com>; Fri, 20 May 2011 22:57:12 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9574BCFB4A0
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 20:57:10 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mgPKKegB7KodkPAa for <xfs@oss.sgi.com>;
	Fri, 20 May 2011 20:57:10 -0700 (PDT)
Date: Sat, 21 May 2011 13:57:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
	Hole Test Routines
Message-ID: <20110521035704.GW32466@dastard>
References: <4DD43300.6010908@linux.vnet.ibm.com>
	<20110519013144.GF32466@dastard>
	<4DD560CF.3040706@linux.vnet.ibm.com>
	<20110519235601.GL32466@dastard>
	<4DD5C242.3010708@linux.vnet.ibm.com>
	<4DD70B5B.6090400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DD70B5B.6090400@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 20, 2011 at 05:46:19PM -0700, Allison Henderson wrote:
> On 5/19/2011 6:22 PM, Allison Henderson wrote:
> >Also, there was one more test that I meant to be a part of this
> >collection, but I was not finished with it at the time I submitted the
> >patch for feedback. Basically it checks to see if a hole can still be
> >punched out when the disk is full. In ext4 this is allowable because
> >reserved space is used to allow the operation to proceed where it would
> >have otherwise failed. I'm not sure if this is also ext4 specific
> >though. Would this be another candidate for adding to 252? Thx!
> 
> I just didnt want this question to get washed away in the traffic.
> I am working on an updated patch set, should I include the extra
> test case?  Thx!

Yes, though probably not in the _generic_test_punch function. And
extra case specific to 252 that does something like:

	umount SCRATCH_DEV
	make a small filesystem
	scratch_mount
	prealloc to ENOSPC
	punch


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
