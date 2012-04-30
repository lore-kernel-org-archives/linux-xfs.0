Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UAX4ba239703 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 05:33:05 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	COvx4mDikD4ZBYaI for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 03:33:02 -0700 (PDT)
Date: Mon, 30 Apr 2012 20:32:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel 3.0.30 hang in xfs_submit_ioend_bio
Message-ID: <20120430103259.GK7015@dastard>
References: <4F9E4874.8050505@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F9E4874.8050505@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, gregkh@linuxfoundation.org, stable@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Apr 30, 2012 at 10:08:20AM +0200, Stefan Priebe wrote:
> Hi,
> 
> while running several systems with 3.0.30 i'm seeing this call trace
> pretty often. Is this problem known?
> 
> [925680.203973] Call Trace:
> [925680.204170]  [<c0610ce0>] schedule+0x30/0x50
> [925680.204221]  [<c0610d71>] io_schedule+0x71/0xb0
> [925680.204273]  [<c0362420>] get_request_wait+0xa0/0x150
> [925680.204376]  [<c03625c6>] __make_request+0xf6/0x280
> [925680.204427]  [<c036143d>] generic_make_request+0x3fd/0x610
> [925680.204741]  [<c03616ba>] submit_bio+0x6a/0x100
> [925680.204894]  [<c03366a7>] xfs_submit_ioend_bio+0x47/0x70
> [925680.204946]  [<c03367a4>] xfs_submit_ioend+0xd4/0xe0
> [925680.204998]  [<c0337ba3>] xfs_vm_writepage+0x253/0x580
> [925680.205109]  [<c01ae8ca>] shrink_page_list+0x55a/0x750
> [925680.205162]  [<c01aed60>] shrink_inactive_list+0x1a0/0x350
> [925680.205214]  [<c01af321>] shrink_zone+0x411/0x570
> [925680.205265]  [<c01af9fe>] kswapd+0x57e/0x9c0

kswapd is blocking submitting IO - the request queue is full. I'd
say you've got memory pressure, lots of dirty pages and an IO
subsystem that can't keep up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
