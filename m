Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 575AD7FA3
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 18:05:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D89F5AC001
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 16:05:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uE2sMclAAI3LE0St for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 16:05:50 -0700 (PDT)
Message-ID: <55D7AECE.8010201@sandeen.net>
Date: Fri, 21 Aug 2015 18:05:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: document dax in xfs.5 and other minor fixes
References: <55D799B9.8040002@redhat.com> <20150821225248.GQ3902@dastard>
In-Reply-To: <20150821225248.GQ3902@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/21/15 5:52 PM, Dave Chinner wrote:
> On Fri, Aug 21, 2015 at 04:35:53PM -0500, Eric Sandeen wrote:
>> Document the dax option, fix whitespace around logdev/rtdev,
>> and add missing qnoenforce.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> No, I don't want the DAX mount option documented. As the code says:
> 
> #define XFS_MOUNT_DAX           (1ULL << 62)    /* TEST ONLY! */
> 
> The mount option needs to go away and be replaced by on-disk
> inheritable per-inode flags. I have the kernel patch to do this, but
> I have not written the xfs_io patch to get/set/clear the flags yet.
> 
> Cheers,
> 
> Dave.
> 

Ok.  I'll resend the other minor fixups on their own.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
