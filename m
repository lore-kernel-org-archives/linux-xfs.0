Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA822I8M085215 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:02:18 -0600
Message-ID: <1320717736.3186.90.camel@doink>
Subject: Re: [PATCH v2 4/8] xfsdump: simplify qlock ordinal bitmap
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:02:16 -0600
In-Reply-To: <1320699511-12281-5-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
	<1320699511-12281-5-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-11-07 at 14:58 -0600, Bill Kendall wrote:
> The qlock abstraction manages an array of ordinal bitmaps, one bitmap
> for each thread. The bitmap indicates which locks a thread is holding
> and is used to verify that the locks are obtained in the correct order.
> 
> There is no need to use an array to store the bitmaps, and in fact
> adding entries to the array is broken because qlock_thrdcnt is not
> protected by a lock. A simpler approach is to create a per-thread bitmap
> using thread local storage.
> 
> With this change, there is no need for each new thread to register with
> the qlock abstraction, so qlock_thrdinit() goes away. Remove
> qlock_init() since it can be statically initialized, and that means
> there's no need for a flag (qlock_inited) indicating that the module has
> been initialized.  Also there's no longer a need to track or limit the
> number of threads that the qlock abstraction can handle.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Wow, nice cleanup.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
