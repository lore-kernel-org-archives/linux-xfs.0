Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4L4tmwu131630 for <xfs@oss.sgi.com>; Fri, 20 May 2011 23:55:49 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C427CFB5FC
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 21:55:47 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id 9wqvYswf2Wg0IiAJ for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 21:55:47 -0700 (PDT)
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4L4SL10013988
	for <xfs@oss.sgi.com>; Sat, 21 May 2011 00:28:21 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4L4tPZi483490 for <xfs@oss.sgi.com>; Sat, 21 May 2011 00:55:25 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p4L0tDKN019457 for <xfs@oss.sgi.com>; Fri, 20 May 2011 21:55:13 -0300
Message-ID: <4DD745B6.4030302@linux.vnet.ibm.com>
Date: Fri, 20 May 2011 21:55:18 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
	Hole Test Routines
References: <4DD43300.6010908@linux.vnet.ibm.com>
	<20110519013144.GF32466@dastard>
	<4DD560CF.3040706@linux.vnet.ibm.com>
	<20110519235601.GL32466@dastard>
	<4DD5C242.3010708@linux.vnet.ibm.com>
	<4DD70B5B.6090400@linux.vnet.ibm.com>
	<20110521035704.GW32466@dastard>
In-Reply-To: <20110521035704.GW32466@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 5/20/2011 8:57 PM, Dave Chinner wrote:
> On Fri, May 20, 2011 at 05:46:19PM -0700, Allison Henderson wrote:
>> On 5/19/2011 6:22 PM, Allison Henderson wrote:
>>> Also, there was one more test that I meant to be a part of this
>>> collection, but I was not finished with it at the time I submitted the
>>> patch for feedback. Basically it checks to see if a hole can still be
>>> punched out when the disk is full. In ext4 this is allowable because
>>> reserved space is used to allow the operation to proceed where it would
>>> have otherwise failed. I'm not sure if this is also ext4 specific
>>> though. Would this be another candidate for adding to 252? Thx!
>>
>> I just didnt want this question to get washed away in the traffic.
>> I am working on an updated patch set, should I include the extra
>> test case?  Thx!
>
> Yes, though probably not in the _generic_test_punch function. And
> extra case specific to 252 that does something like:
>
> 	umount SCRATCH_DEV
> 	make a small filesystem
> 	scratch_mount
> 	prealloc to ENOSPC
> 	punch
>
>
> Cheers,
>
> Dave.

Thx Dave, I will include include it once I get it working in the 
xfstests frame work.  The code for it though ended up being a little 
more complex than what you have there.  This one might be easier to talk 
about with the code in front of us, but I will trying to sum it up quickly:

Because punching a hole does not always require extra blocks, it has to 
go through a couple rounds of punching holes, and then "topping off" the 
file system to 100% usage before it is forced to grow the tree in order 
to deal with the fragmentation. The growing of the tree is what would 
have triggered the ENOSPC on the next punch if not for the use of 
reserved blocks.  Before this feature was in place, this magic number 
appeared to be about 333 iterations for ext4.  Once we added it though, 
it was able to run through an indefinite cycle of punching out every 
other two blocks and topping off the fs (at least until it ran off the 
edge of the file it is punching away at).  The test case I have calls it 
good after 500, but this may be something we may need to tweek in order 
for it to be effective for other file systems too.

On a side note, I've hit a bit of a snag at the moment, because it 
appears that test 252 hangs when run on ext4.  It looks like the call to 
get the fiemap doesnt come back for some reason, so I will need to 
figure this out first, but when I get it all working, I will get the 
updated set out to you asap.  Thx for all your help, Dave.  I really 
appreciate all the thorough reviews!  :)

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
