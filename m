Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B6DA7F9C
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 18:52:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A6E830405F
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 16:52:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	e9fZo1c6y9wyfC8C for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 16:51:58 -0700 (PDT)
Date: Sat, 4 Jul 2015 09:51:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failing XFS filesystem underlying Ceph OSDs
Message-ID: <20150703235141.GQ7943@dastard>
References: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
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
To: Alex Gorbachev <ag@iss-integration.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 03, 2015 at 05:07:29AM -0400, Alex Gorbachev wrote:
> Hello, we are seeing this and similar errors on multiple Supermicro nodes
> running Ceph.  OS is Ubuntu 14.04.2 with kernel 4.1
> 
> Thank you for any info and troubleshooting advice.

Nothing to suggest that this is an XFS problem. Memory reclaim
triggered by network stack memory pressure is causing inode
eviction. While removing the page cache it's falling over in
the generic truncate code doing a radix tree lookup. That's all
generic code - XFS never touches the page cache radix tree directly.

I haven't seen this before - is this a new problem since you
upgraded your kernel to 4.1? Is it repeatable? if yes to both, then
a bisect may be in order to isolate the problematic commit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
