Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0486329DF8
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:53:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E6A848F804C
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:52:51 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0lVPaT3x64xhyDyp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:52:40 -0800 (PST)
Message-ID: <52AAF4E9.60408@oracle.com>
Date: Fri, 13 Dec 2013 19:52:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 6/8] xfs: use xfs_icluster_size_fsb in
	xfs_ialloc_inode_init
References: <52A96809.9020702@oracle.com>
	<20131213111437.GA23546@infradead.org>
In-Reply-To: <20131213111437.GA23546@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/13 2013 19:14 PM, Christoph Hellwig wrote:
>> +	 * Loop over the new block(s), filling in the inodes.  For small block
>> +	 * sizes, manipulate the inodes in buffers  which are multiples of the
>> +	 * blocks size.
>>  	 */
>> +	blks_per_cluster = xfs_icluster_size_fsb(mp);
>> +	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
>> +	nbufs = length / blks_per_cluster;
> 
> I don't think there's a point to have the nbufs variable as it's used
> just once as the loop termination condition.
Thanks for the review, and that sounds make sense to me given that compiler
would mostly likely optimize this situation to calculate nbufs only once in
the loop, but I also consider that might affect a bit readabilities in either
case...

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
