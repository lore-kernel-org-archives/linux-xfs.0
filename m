Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E8E8629E14
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 21:33:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C01F18F8033
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 19:33:55 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 0gNXMEsHEyP54kp8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 19:33:54 -0700 (PDT)
Message-ID: <53684A06.3020202@oracle.com>
Date: Tue, 06 May 2014 10:33:42 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/6] xfsprogs: sync kernel inode cluster size refactor code
References: <536784B2.7090002@oracle.com> <20140505212759.GA26353@dastard>
In-Reply-To: <20140505212759.GA26353@dastard>
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


On 05/06 2014 05:27 AM, Dave Chinner wrote:
> On Mon, May 05, 2014 at 08:31:46PM +0800, Jeff Liu wrote:
>> Hi Folks,
>>
>> This patch series sync up the code differences between kernel and user space
>> for xfs_icluster_size_fsb() relevant changes, i.e,
>> http://oss.sgi.com/archives/xfs/2013-12/msg00499.html
>>
>> Most patches are similar to the kernel part except we have xfs_bulkstat() and
>> xfs_ifree_cluster() at kernel space but they are not presented at user space.   
> 
> Given that we need to do a wholesale resync of libxfs to the kernel
> code, I'm not sure it makes sense to do little bits out of order.
> it just makes syncing all the other prior changes harder because it
> causes patch conflicts...
> 
> I'm planning that this is the first thing that we need to do
> after the 3.2.0 release before anything else....

Ok, so let's complete it at that point.

Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
