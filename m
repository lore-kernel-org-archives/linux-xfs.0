Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4ODSxnv047567 for <xfs@oss.sgi.com>; Sun, 24 May 2009 08:28:59 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D37312FB97F
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 06:34:49 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id XGjJ9I9cpycbcV9d for
	<xfs@oss.sgi.com>; Sun, 24 May 2009 06:34:49 -0700 (PDT)
Message-ID: <4A194BA5.1010308@sandeen.net>
Date: Sun, 24 May 2009 08:29:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: about XFS_IOC_RESVSP
References: <7fe205990905220716v7d06b9bch40fe6136af17e345@mail.gmail.com>	<4A16C97A.2020909@sandeen.net>
	<7fe205990905221036h71823b2bwf88123a38a406324@mail.gmail.com>
In-Reply-To: <7fe205990905221036h71823b2bwf88123a38a406324@mail.gmail.com>
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
To: Joe Hsu <nagual.hsu@gmail.com>
Cc: xfs@oss.sgi.com

Joe Hsu wrote:
> Well, I have multiple processes running concurrently, and each writes
>  on its own files( the sort of files I mentioned), while at the same 
> time, I have other programs doing normal but light I/O to other files
> on the same xfs partition.
> 
> Once I thought maybe I can pre-allocate these special files within a 
> directory, which has fixed allocation groups(I guess that means fixed
> sets of blocks), and then I can try to make 'truncate to 0 and 
> pre-allocate' requests sequential for the running processes. But, XFS
> seems to have this feature, I cannot find how to do that.

There is no interface to re-mark existing blocks as unwritten, I'm
afraid.  It sounds like an interesting interface, but it's not there
today AFAIK.

You said:

> Why am I doing this? Why not just over-write it? When doing partial 
> over-writing, some blocks may be read for partial update before they
>  are written out. This hurts some IO performance

I guess it's not possible for you to do whole-block IO instead?  Or even
pad out the writes to block boundaries if needed?

and:

> After days of testing(I only ftruncate to 0 and re-preallocate files 
> if needed), fragmentation become much more serious, sigh

It's interesting that it's so bad, I'd have hoped that if you free a
contiguous chunk of blocks and then immediately reallocate them on the
same inode, that they'd get preallocated nicely.... How bad is it?

-Eric

> 2009/5/22 Eric Sandeen <sandeen@sandeen.net>:
>> Joe Hsu wrote: Do you really need the exact same blocks?  What if 
>> you just truncate to 0 & re-allocate?
>> 
>> -Eric
>> 
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
