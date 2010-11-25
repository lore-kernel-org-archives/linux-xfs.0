Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP9uGVw251427 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 03:56:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D535F13EBB8E
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 01:57:54 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	3jnIH2HDZICmtEp5 for <xfs@oss.sgi.com>;
	Thu, 25 Nov 2010 01:57:54 -0800 (PST)
Date: Thu, 25 Nov 2010 20:57:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Direct IO, unaligned block zeroing at 128K boundery
Message-ID: <20101125095751.GC12187@dastard>
References: <AANLkTi=3BNqaUJGLuCOipQX_eP07QXa6dCBB-nUqmqG0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=3BNqaUJGLuCOipQX_eP07QXa6dCBB-nUqmqG0@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Nov 25, 2010 at 12:23:11PM +0530, Ajeet Yadav wrote:
> Dear all
> I made a simple script that creates a 2MB file using directio write
> operation,
> The objective was to test with different buffer sizes from 4K-5K-6K..8K, the
> buffer was filled with 5,
> Than take hexdump of file to check data integrity.

what kernel? Can you reproduce it on a mainline kernel? If so,
can you apply the three patches in this thread:

http://marc.info/?l=linux-fsdevel&m=128920213904443&w=2

and see if that fixes the problem?

Also, if you are writing new test scripts that demonstrate problems,
it's handy to attach them to your bug reports, or better yet, send
patches to add them to the xfstests suite....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
