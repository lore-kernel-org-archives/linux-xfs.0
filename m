Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0741A7F72
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 05:54:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A9F7AC003
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 03:54:15 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	m7welpIrABH0fB4d for <xfs@oss.sgi.com>;
	Thu, 28 Feb 2013 03:54:13 -0800 (PST)
Date: Thu, 28 Feb 2013 22:54:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible fsync02() xfs slowness regression on power7
Message-ID: <20130228115410.GN5551@dastard>
References: <130819766.6999797.1362043338279.JavaMail.root@redhat.com>
	<2103242337.7001373.1362043715738.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2103242337.7001373.1362043715738.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: Steve Best <sbest@redhat.com>, xfs@oss.sgi.com

On Thu, Feb 28, 2013 at 04:28:35AM -0500, CAI Qian wrote:
> This LTP test starting to fail using the latest upstream kernel on one of the power7
> systems here, http://tinyurl.com/bngwouj
> 
> # ./fsync02
> fsync02     1  TFAIL  :  fsync took too long: 252.000000 seconds; max_block: 214
> 
> When it is working, the test is almost returned immediately. The bisecting so far
> indicated that one or a few of the following could be culprits.
> 
> # git log --pretty=oneline 498f7f505dc79934c878c7667840c50c64f232fc..b199c8a4ba11879df87daad496ceee41fdc6aa82

They are all patches committed more than 2 years ago, and none of
them are platform specific. This sounds more like a machine specific
issue than a platform specific problem (i.e. lots of RAM, slow,
slow disk).

In future when reporting a bug, please tell use hardware you are
using as per:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Given that this is a sparse file test that repeatedly extends the
file, this is the likely culprit:

> 055388a3188f56676c21e92962fc366ac8b5cb72 xfs: dynamic speculative EOF preallocation

And this commit in 3.9-rc1:

a1e16c2 xfs: limit speculative prealloc size on sparse files

should fix the problem. Please confirm these commits are the cause
and the fix respectively....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
