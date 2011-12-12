Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC9WFnx086813 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 03:32:15 -0600
Received: from fgwmail5.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8473156D53A
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 01:32:14 -0800 (PST)
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id IUerN2HK5ZHVPjxb for
	<xfs@oss.sgi.com>; Mon, 12 Dec 2011 01:32:14 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 3BF8B3EE0AE
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:32:12 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2346645DEEB
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:32:12 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0C8BC45DEDA
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:32:12 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id F39671DB803B
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:32:11 +0900 (JST)
Received: from m004.s.css.fujitsu.com (m004.s.css.fujitsu.com [10.23.4.34])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id B19101DB8038
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:32:11 +0900 (JST)
Date: Mon, 12 Dec 2011 18:31:55 +0900
From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH] xfstests: 277 new test to check freeze/unfreeze works
	well or not under heavy load.
In-Reply-To: <20111209071700.GD14273@dastard>
References: <20111209145231.5A5F.61FB500B@jp.fujitsu.com>
	<20111209071700.GD14273@dastard>
Message-Id: <20111212183153.DF3F.61FB500B@jp.fujitsu.com>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com


(2011/12/09 16:17), Dave Chinner wrote:

> On Fri, Dec 09, 2011 at 02:52:31PM +0900, Masayoshi MIZUMA wrote:
> > Hi,
> > 
> > unfreeze function, thaw_super(), sometimes hangs up if flush kernel
> > thread does writeback to the same filesystem concurrently.
> > (the problem is reported at
> >  http://marc.info/?l=linux-ext4&m=132339590004560&w=2)
> > 
> > This test runs freeze/unfreeze under heavy load. If the problem is
> > reproduced, this test will hang up...
> 
> This is effectively a duplicate of test 068, which is currently
> described as an XFS only test. It is actually generic now that
> xfs_freeze works on other filesytsems, so please update 068
> appropriately rather that introducing a new test.

OK, I will try to update 068 to reproduce the problem, thanks!

Masayoshi Mizuma

> 
> Cheers,
> 
> Dave
> 
> -- 
> Dave Chinner
> david@fromorbit.com



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
