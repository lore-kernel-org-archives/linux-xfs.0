Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 40ABE7CA0
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 13:10:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1B47AC002
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 11:10:15 -0700 (PDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com
	[74.125.82.42]) by cuda.sgi.com with ESMTP id ZOclCF6Tn1H7CjQD
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2016 11:10:13 -0700 (PDT)
Received: by mail-wm0-f42.google.com with SMTP id l6so34342204wml.1
	for <xfs@oss.sgi.com>; Tue, 05 Apr 2016 11:10:12 -0700 (PDT)
Message-ID: <77693FFEB62A474DA7F039FD92CC5304@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <20150629222651.GG7943@dastard>
	<F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
	<20150707000911.GT7943@dastard>
	<20150707090511.GA21863@infradead.org>
	<7792DA2A464640B1BC7220973CED41AE@alyakaslap>
	<20150723230912.GE3902@dastard>
In-Reply-To: <20150723230912.GE3902@dastard>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Date: Tue, 5 Apr 2016 21:10:06 +0300
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

Hello Dave, Brian, Christoph,

We are still encountering cases, in which different IO patterns beat XFS 
preallocation schemes, resuling in highly fragmented files, having 100s of 
thousands and sometimes millions of extents. In these cases XFS tries to 
allocate large arrays of xfs_ext_irec_t structure with kmalloc, and this 
often gets into numerous retries, and sometimes triggers hung task panic 
(due to some other thread wanting to access the same file).

We made a change to call kmem_zalloc_large, which resorts to __vmalloc in 
case kmalloc fails. kmem_free is already handling vmalloc addresses 
correctly. The change is only for the allocation done in 
xfs_iext_realloc_indirect, as this is the only place, in which we have seen 
the issue.

Final code, as usual, will be in 
https://github.com/zadarastorage/zadara-xfs-pushback

Thanks,
Alex.


-----Original Message----- 
From: Dave Chinner
Sent: Friday, July 24, 2015 2:09 AM
To: Alex Lyakas
Cc: Christoph Hellwig ; Danny Shavit ; bfoster@redhat.com ; Yair Hershko ; 
Shyam Kaushik ; xfs@oss.sgi.com
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation 
deadlock"

On Thu, Jul 23, 2015 at 05:39:28PM +0200, Alex Lyakas wrote:
> Hi Dave,
> Just for completeness,  XFS speculative preallocation (that is based
> now upon the size of the last extent) can still grow up to 4Gb-8Gb
> (depending on which patches we are pulling). As a result, xfs_iozero
> can still sometimes trigger 1-2GB writes of zeros in one shot. This
> turns out to be a bit unfriendly to the drives in some
> configurations. So we have applied a custom patch to limit the
> speculative preallocation to 32Mb.

It would be much better to change xfs_zero_eof() to convert extents
beyond EOF to unwritten extents rather than zero them. That way you
still get the benefits of the large speculative prealloc but without
the zeroing overhead that wierd sparse write patterns can trigger.

I just haven't got around to doing this because it hasn't been
reported as a significant problem for anyone until now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
