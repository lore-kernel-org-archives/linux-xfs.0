Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p37LEXMt130904 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 16:14:34 -0500
Subject: Re: [PATCH 9/9] xfs: convert log tail checking to a warning
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302141445-27457-10-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-10-git-send-email-david@fromorbit.com>
Date: Thu, 07 Apr 2011 16:16:54 -0500
Message-ID: <1302211014.2576.609.camel@doink>
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

On Thu, 2011-04-07 at 11:57 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On the Power platform, the log tail debug checks fire excessively
> causing the system to panic early in testing. The debug checks are
> known to be racy, though on x86_64 there is no evidence that they
> trigger at all.
> 
> We want to keep the checks active on debug systems to alert us to
> problems with log space accounting, but we need to reduce the impact
> of a racy check on testing on the Power platform.
> 
> As a result, convert the ASSERT conditions to warnings, and
> allow them to fire only once per filesystem mount. This will prevent
> false positives from interfering with testing, whilst still
> providing us with the indication that they may be a problem with log
> space accounting should that occur.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
