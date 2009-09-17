Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8HJ1cbf233466 for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 14:01:38 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F3024614C8
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 12:02:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id k8IfS5m5wA64xXxn for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2009 12:02:52 -0700 (PDT)
Message-ID: <4AB287C8.1030405@sandeen.net>
Date: Thu, 17 Sep 2009 14:02:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] libxfs: increase hash chain depth when we run out of slots
References: <4AB25E78.8050001@redhat.com>
	<20090917180931.GA21848@infradead.org>
In-Reply-To: <20090917180931.GA21848@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Tomek Kruszona <bloodyscarion@gmail.com>, Eric Sandeen <sandeen@redhat.com>, Riku Paananen <riku.paananen@helsinki.fi>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Sep 17, 2009 at 11:06:16AM -0500, Eric Sandeen wrote:
>> A couple people reported xfs_repair hangs after
>> "Traversing filesystem ..." in xfs_repair.  This happens
>> when all slots in the cache are full and referenced, and the
>> loop in cache_node_get() which tries to shake unused entries
>> fails to find any - it just keeps upping the priority and goes
>> forever.
>>
>> This can be worked around by restarting xfs_repair with
>> -P and/or "-o bhash=<largersize>" for older xfs_repair.
>>
>> I started down the path of increasing the number of hash buckets
>> on the fly, but Barry suggested simply increasing the max allowed
>> depth which is much simpler (thanks!)
>>
>> Resizing the hash lengths does mean that cache_report ends up with
>> most things in the "greater-than" category:
>>
>> ...
>> Hash buckets with  23 entries      3 (  3%)
>> Hash buckets with  24 entries      3 (  3%)
>> Hash buckets with >24 entries     50 ( 85%)
>>
>> but I think I'll save that fix for another patch unless there's
>> real concern right now.
>>
>> I tested this on the metadump image provided by Tomek.
> 
> How large is that image?  I really think we need to start collecting
> these images for regression testing.

zipped metadump is 170M; unzipped 1.1G.

Crafting a special test fs somehow might be better; maybe with an
artificially low bhashsize or something ....  yeah, I know.  I'm not
sure how to manage the regression testing.  Working backwards to a
minimal testcase on these would be extremely time-consuming and/or
impossible I'm afraid.

> The patch looks good to me,

thanks for the review

-Eric

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
