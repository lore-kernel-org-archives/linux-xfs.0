Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0723E7F51
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 22:40:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E42B28F804C
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 20:39:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7YNfIWKZ27g3Wnvk for <xfs@oss.sgi.com>;
	Thu, 17 Oct 2013 20:39:58 -0700 (PDT)
Message-ID: <5260AD8D.5080800@sandeen.net>
Date: Thu, 17 Oct 2013 22:39:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] xfstests: add a multithreaded mode to bstat
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
	<1370610398-14630-7-git-send-email-david@fromorbit.com>
	<526056AC.4000307@sandeen.net> <20131018030039.GS4446@dastard>
In-Reply-To: <20131018030039.GS4446@dastard>
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
Cc: xfs@oss.sgi.com

On 10/17/13 10:00 PM, Dave Chinner wrote:
> On Thu, Oct 17, 2013 at 04:29:16PM -0500, Eric Sandeen wrote:
>> On 6/7/13 8:06 AM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> For benchmarking of bulkstat, add a multithreaded mode that spawns a
>>> thread per AG and runs bulkstat on every AG in parallel. There is a
>>> small amount of overlap between each AG because of the way the
>>> interface works only on inode numbers, so some inodes are reported
>>> twice. A real implementation of this sort of parallelism would be
>>> greatly helped by adding an AG parameter to the bulkstat interface.
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>
>> At least w/ older xfsprogs[[qa]-devel] packages, I get:
>>
>> bstat.c:41: error: redefinition of 'fls'
>> /usr/include/xfs/bitops.h:8: note: previous definition of 'fls' was here
>> bstat.c:70: error: redefinition of 'xfs_highbit32'
>> /usr/include/xfs/xfs_bit.h:50: note: previous definition of 'xfs_highbit32' was here
>>
>> w/ the new functions you've added here...
> 
> Ok, so I need autoconf magic here to detect this?

seems that way.  TBH I don't *cough* have a box w/ latests xfsprogs headers installed
currently, so didn't see exactly what changed...

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
