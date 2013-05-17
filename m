Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A99B57F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 07:04:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8779F30405F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:04:23 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id EKEnAje8nELM3iNw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 05:04:22 -0700 (PDT)
Message-ID: <51961CB5.4060101@oracle.com>
Date: Fri, 17 May 2013 20:04:05 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: code sync up for log space reservation
References: <5195F67F.5070101@oracle.com> <20130517105253.GU24635@dastard>
In-Reply-To: <20130517105253.GU24635@dastard>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

On 05/17/2013 06:52 PM, Dave Chinner wrote:
> On Fri, May 17, 2013 at 05:21:03PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> Here is a patch to sync up the kernel code changes regarding log space reservation
>> to the xfsprogs.
>>
>> There have a couple of differences between the kernel and the user space.
>> 1) A few transaction reservation item related to dquot are not synced because they
>>    are not being used in xfsprogs.
>> 2) In xfs_log_rlimit.c, the xfs_log_validate_logspace() is not copied and the xfs_mkfs.c
>>    still use the default validate_log_space() to check the given log size.
> 
> Hi Jeff,
> 
> Just as a heads up, this is going to have conflicts with the CRC
> patchset that I'm planning on posting in a few minutes. How do you
> want to resolve them?
> 
> From my perspective it's easier if we rebase your patch on top of my
> patchset. If we go the other way around, I'll have to rebase 10-20
> patches that your patch has conflicts with....
Sure.  It's ok to me since I only need to rebase one big patch. :)

Thanks,
-Jeff


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
