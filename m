Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68J4HGu262067 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 14:04:17 -0500
Subject: Re: [PATCH 4/4] xfstests: add mapped write fsx operations to 091
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1310086426-30605-5-git-send-email-david@fromorbit.com>
References: <1310086426-30605-1-git-send-email-david@fromorbit.com>
	<1310086426-30605-5-git-send-email-david@fromorbit.com>
Date: Fri, 8 Jul 2011 14:04:12 -0500
Message-ID: <1310151852.3024.39.camel@doink>
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

On Fri, 2011-07-08 at 10:53 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent busted fsx updates caused fsx to execute fsx with direct
> IO and mmapped reads and writes on an XFS filesystem. The result
> uncovered a direct-IO write vs mmap read bug to do with EOF
> sub-block zeroing on the direct IO write.
> 
> Hence whiel we do not recommend that pepole mix DIO with mmap on the
> same file, we should at least have tests that exercise it as they
> often show up other problems like this.
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Good idea.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
