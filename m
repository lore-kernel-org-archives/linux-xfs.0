Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FF067F50
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 09:23:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E309C304032
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 07:23:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lP0YUGJ24vRJnpI9 for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 07:23:19 -0700 (PDT)
Message-ID: <52444355.50904@sandeen.net>
Date: Thu, 26 Sep 2013 09:23:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Issues and new to the group
References: <0e4201cebaae$24873680$6d95a380$@host2max.com>	<5244234D.1010603@hardwarefreak.com>
	<100f01cebaba$0ae84280$20b8c780$@host2max.com>
	<101601cebabc$8acb99a0$a062cce0$@host2max.com>
In-Reply-To: <101601cebabc$8acb99a0$a062cce0$@host2max.com>
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
To: Ronnie Tartar <rtartar@host2max.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On 9/26/13 8:30 AM, Ronnie Tartar wrote:
> Stan, looks like I have directory fragmentation problem.
> 
> xfs_db> frag -d
> actual 65057, ideal 4680, fragmentation factor 92.81%
> 
> What is the best way to fix this?

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

We should just get rid of that command, TBH.

So your dirs are in an average of 65057/4680 or about 14 fragments each.
Really not that bad, in the scope of things.

I'd imagine that this could be more of your problem:

> The
> folders are image folders that have anywhere between 5 to 10 million images
> in each folder.

at 10 million entries in a dir, you're going to start slowing down on inserts
due to btree management.  But that probably doesn't account for multiple seconds for
a single file.

So really,it's not clear *what* is slow.

> It takes about 2.5 to 3.5 seconds to write a single file.

strace with timing would be a very basic way to get a sense of what is slow;
is it the file open/create?  How big is the file, are you doing buffered or
direct IO?

On a more modern OS you could do some of the tracing suggested in
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

but some sort of profiling (oprofile, perhaps) might tell you where time is being spent in the kernel.

When you say suddenly started, was it after a kernel upgrade or other change?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
