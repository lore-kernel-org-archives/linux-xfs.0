Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D0DB7F50
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:16:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 33D6F8F804B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 19:16:46 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3UruJ8RJz5wvUqvv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 19:16:45 -0800 (PST)
Message-ID: <52A92A95.5020607@oracle.com>
Date: Thu, 12 Dec 2013 11:16:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: use xfs_ialloc_blks_per_cluster in xfs_imap
References: <52A86D33.2020102@oracle.com> <20131211233938.GR10988@dastard>
In-Reply-To: <20131211233938.GR10988@dastard>
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

On 12/12 2013 07:39 AM, Dave Chinner wrote:
> On Wed, Dec 11, 2013 at 09:48:35PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Use xfs_ialloc_blks_per_cluster() in xfs_imap().  Please note that we
>> previously calculate the number of blocks per cluster without taking
>> the situation of that the inode cluster size might be equal to or less
>> than the SB blocksize into account.  Maybe there is a chance to cause
>> potential issues after handling an untrusted inode number lookup and
>> proceed to check if the inode number maps to a block is outsides the
>> file system bounds or not.
> 
> I don't think there's any issues here - after all the inode lookups
> and mapping is done, the code in xfs_imap checks that the cluster
> that the inode is mapped to lies wholly within the filesystem
> boundaries. Hence I think you can remove that from the patch
> descritpion.
Ah, you're right because the current logic can handle it well if
blks_per_cluster > 1, or there is no influence to calculate the
cluster_agbno if blks_per_cluster == 1. :)

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
