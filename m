Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D6A977F81
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 20:18:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B16F830404E
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 18:18:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BOshEQKw3MyQaIMS for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 18:18:22 -0700 (PDT)
Date: Tue, 5 Aug 2014 11:18:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs hang in 3.14.15
Message-ID: <20140805011800.GC20518@dastard>
References: <53E02495.4080208@sbcglobal.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53E02495.4080208@sbcglobal.net>
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
To: Bill <billstuff2001@sbcglobal.net>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2014 at 07:25:57PM -0500, Bill wrote:
> Hi,
> 
> I've been running a stress test on 3.14.15 and eventually my xfs
> filesystem hangs. Both 3.10.50 and 3.16 seem to work ok.

log space hang.

110dc24 xfs: log vector rounding leaks log space

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
