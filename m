Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA822CJG085187 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:02:12 -0600
Message-ID: <1320717731.3186.89.camel@doink>
Subject: Re: [PATCH v2 3/8] xfsdump: implement lock abstraction with pthreads
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:02:11 -0600
In-Reply-To: <1320699511-12281-4-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
	<1320699511-12281-4-git-send-email-wkendall@sgi.com>
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
> This patch implements xfsdump's locking abstraction using pthread
> locking primitives. The obsolete IRIX locking code has been removed.
> 
> The POSIX semaphore implementation on Linux does not provide a count
> of threads waiting to decrement the semaphore, so qsemPblocked()
> has been removed. It was called from a few asserts, but the current
> count of the semaphore was also checked in adjacent asserts, so
> it was deemed acceptable to remove the qsemPblocked() asserts.
> 
> A few debug-level log calls had to be changed to use the "no lock"
> flag to prevent locks from being acquired out of order. This is
> used in various debug messages throughout xfsdump.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

I have not done a very thorough review, but this
looks OK to me.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
