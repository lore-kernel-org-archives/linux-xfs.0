Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DAZcQM166156 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 05:35:38 -0500
Subject: Re: [PATCH 1/2] xfstests: make 225 use SCRATCH_DEV
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1318212855-20212-2-git-send-email-david@fromorbit.com>
References: <1318212855-20212-1-git-send-email-david@fromorbit.com>
	<1318212855-20212-2-git-send-email-david@fromorbit.com>
Date: Thu, 13 Oct 2011 05:35:33 -0500
Message-ID: <1318502133.3172.18.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-10-10 at 13:14 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Use the scratch device for test 225 so that both custom mkfs and
> mount options impact the test (e.g. filesystem block size). This
> exposes test failures when using 512 byte block sizes, which
> currently not tested unless the test device is specifically created
> with a 512 byte block size.
> 
> Also clean up the file names to include the test number, and don't
> remove the test files after the test has finished so that it leaves
> behind a corpse that can be dissected when the test fails.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
