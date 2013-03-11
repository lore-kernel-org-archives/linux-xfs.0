Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38E1E7F3F
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 20:40:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 248518F8049
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 18:40:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EZ5oC2IGehjJPK8t for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 18:40:31 -0700 (PDT)
Message-ID: <513D360F.4060309@sandeen.net>
Date: Sun, 10 Mar 2013 20:40:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 301: sparse copy between different
	filesystems/mountpoints on btrfs
References: <50F9C331.9000501@oracle.com> <513BD2CF.5020204@sandeen.net>
	<20130310230325.GM23616@dastard>
In-Reply-To: <20130310230325.GM23616@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Koen De Wit <koen.de.wit@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 3/10/13 6:03 PM, Dave Chinner wrote:
> On Sat, Mar 09, 2013 at 06:24:47PM -0600, Eric Sandeen wrote:
>> On 1/18/13 3:48 PM, Koen De Wit wrote:
>>> +}
>>> +
>>> +_scratch_mount
>>> +_create_reflinks_to $TESTDIR2
>>> +_scratch_unmount
>>> +
>>> +mount $TEST_DEV $SCRATCH_MNT
>>> +_create_reflinks_to $TESTDIR3
>>> +umount $SCRATCH_MNT
>>
>> TBH this confuses me, not that it's necessarily wrong (?)
>> You mount TEST_DEV on $SCRATCH_MNT which makes my brain hurt a little.
>> Then _create_reflinks_to $TESTDIR3 and at that point, um, what's going on,
>> what's linking what to where?
> 
> Mounting the TEST_DEV on SCRATCH_MNT is almost always a bad thing to
> do. The test harness expects TEST_DEV to be mounted on TEST_DIR, not
> anywhere else.
> 
> If you need multiple scratch filesystems to test cross-device
> linkage errors, use loopback devices or make use of the btrfs
> scratch device pool...

Actually, looking at it again - does this wind up with TEST_DEV mounted
on both TEST_DIR and SCRATCH_MNT?  Maybe what the test wants is more
mountpoints, not more devices?

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
