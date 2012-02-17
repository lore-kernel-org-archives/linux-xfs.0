Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1H2nsHf044630 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 20:49:55 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OZjLAtl2YyrP3shH for <xfs@oss.sgi.com>;
	Thu, 16 Feb 2012 18:49:53 -0800 (PST)
Date: Fri, 17 Feb 2012 13:49:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS memory recomendation?
Message-ID: <20120217024941.GH14132@dastard>
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
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
To: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Feb 16, 2012 at 12:50:57PM +0100, Assarsson, Emil wrote:
> Hi,
> 
> Are there any recommendations about how much memory I need based
> on the size of the file system and/or amount of files?  For
> example: how much memory would be optimal for a 20TB file system
> with 3000000 files? 

/me shrugs

> I guess it depends on the usage pattern?

Totally.

> Is there any way to make sure that the file allocation table stays in the memory?

What's a "file allocation table"? XFS doesn't have one. :)

XFS does have a sophisticated metadata cache and reclaim scheme that
keeps frequently referenced metadata hot in cache, but you as a
user have very little control over that because the cache size is
effectively controlled by memory pressure. i.e. it's size is
completely workload dependent.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
