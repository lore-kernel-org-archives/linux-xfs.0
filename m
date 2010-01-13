Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DMVKLt195929 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:31:20 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: xfs_swap_extents needs to handle dynamic fork offsets
Date: Wed, 13 Jan 2010 16:32:12 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6965@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100112130922.GA30985@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
>> +	TP_printk("dev %d:%d %s inode 0x%llx, %s format, num_extents %d, "
>> +		  "Max in-fork extents %d, broot size %d, fork offset %d",
> 
> It would be nice to keep the
> 
> 	"dev %d:%d ino 0x%llx"
> 
> prefix as a convention so that all trace records are similar at their
> beginning.

Perhaps:
    +	TP_printk("dev %d:%d inode 0x%llx (%s), %s format, num_extents %d, " 
                                          ^
                                          +--- symbolic entry->which

>>  #undef TRACE_INCLUDE_PATH
>> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
>> @@ -53,7 +53,7 @@ xfs_swapext(
>>  	xfs_swapext_t	*sxp)
>>  {
>>  	xfs_inode_t     *ip, *tip;
>> -	struct file	*file, *target_file;
>> +	struct file	*file, *tmp_file;
> 
> I think these xfs_swapext belong into a separate patch.  While they
> make the code quite a bit more redable they're purely cleanups and
> can wait for 2.6.34.  And while you're at it you might also want to
> merge xfs_swap_extents into xfs_swapext - there's no need for that
> split at all.

I agree.  The change here is good (it was confusing and wrong before).
But Dave can you please re-submit this with only the critical changes
so I can get them to Linus in this release cycle?  I think the trace
addition is probably fine, just get rid of the gratuitous variable
name change in xfs_swapext() and put that in a separate patch.

The rest looks all good.  Thanks.
	
					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
