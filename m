Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7222C7F37
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 21:08:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07825AC001
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 19:08:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xiHBbXARxGevNFDi for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 19:08:27 -0700 (PDT)
Date: Thu, 9 Jul 2015 12:07:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_io bmap confused
Message-ID: <20150709020751.GH3902@dastard>
References: <1436338913.13729.11.camel@hasee>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1436338913.13729.11.camel@hasee>
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
To: Ming Lin <mlin@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 08, 2015 at 12:01:53AM -0700, Ming Lin wrote:
> Hi list,
> 
> I am testing some direct-io patches.
> xfs_tests/xfs/080 failed.
> 
> It's strange.
> There is no hole in "rwtest.file",
> but when read it at some offset it returns zero because of hole.
> 
> root@block:~# xfs_io -c bmap /mnt/test/rwtest.file
> /mnt/test/rwtest.file:
>              0: [0..125671]: 160..125831
> 
> Then I read at file offset 659456,
> root@block:~# dd if=/mnt/test/rwtest.file of=tmp.file bs=512 skip=1288 count=1
> 
> The code actually goes to below if statements.
> 
> Any idea what's wrong?

XFS maps unwritten extents as holes on read so that they are
correctly zeroed by the generic code. See this patch:

http://oss.sgi.com/archives/xfs/2007-07/msg00742.html

And the followup for why it should be done:

http://oss.sgi.com/archives/xfs/2007-07/msg00744.html

Sadly I was unable to convince anyone to take the patch, and so that
wart in XFS mapping behaviour still exists because the generic
readpage code still doesn't understand unwritten extents natively.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
