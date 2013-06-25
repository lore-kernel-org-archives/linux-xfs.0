Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C34B7F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 01:55:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15950304053
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 23:55:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VJ23byevOmFFHias for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 23:55:50 -0700 (PDT)
Date: Tue, 25 Jun 2013 16:55:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.10-rc7: general protection fault at
	xlog_state_do_callback+0x88/0x2c0 [xfs]
Message-ID: <20130625065548.GX29376@dastard>
References: <510496923.4466531.1372130994988.JavaMail.root@redhat.com>
	<115167995.4467705.1372131291931.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <115167995.4467705.1372131291931.JavaMail.root@redhat.com>
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
Cc: xfs@oss.sgi.com

On Mon, Jun 24, 2013 at 11:34:51PM -0400, CAI Qian wrote:
> This looks like triggered by xfstests test #13
> 001	 17s
> 002	 1s
> 003	 1s
> 004	 2s
> 005	 0s
> 006	 28s
> 007	 51s
> 008	 3s
> 009	 2s
> 010	 [not run] dbtest was not built for this platform
> 011	 15s
> 012	 3s
> 013	
> 
> [32728.415359] general protection fault: 0000 [#1] SMP  

The system has been running for close on ten hours before xfstests
was run. I'm assuming that it's been running 10 hours of other tests
like for previous bug reports. Can you reproduce this directly after
a clean boot?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
