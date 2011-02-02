Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p121RbOT257003 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 19:27:37 -0600
Subject: Re: [PATCH 3/4] xfstests: make 016 work with delaylog
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295927937-20634-4-git-send-email-david@fromorbit.com>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-4-git-send-email-david@fromorbit.com>
Date: Tue, 01 Feb 2011 19:30:02 -0600
Message-ID: <1296610202.2350.160.camel@doink>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-01-25 at 14:58 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Test 016 fails with delaylog because it measures log traffic to disk
> and delaylog writes almost nothing to the log for the given test. TO
> make it work, add sync calls to the work loop to cause the log to be
> flushed reliably for both delaylog and nodelaylog and hence contain
> the same nuumber of log records.
> 
> As a result, the log space consumed by the test is not changed by
> the delaylog option and the test passes. The test is not
> significantly slowed down by the addition of the sync calls (takes
> 15s to run on a single SATA drive).
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
