Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68J2ujh262009 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 14:02:56 -0500
Subject: Re: [PATCH 3/4] xfstests: fix brain-o in fallocate log dump
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1310086426-30605-4-git-send-email-david@fromorbit.com>
References: <1310086426-30605-1-git-send-email-david@fromorbit.com>
	<1310086426-30605-4-git-send-email-david@fromorbit.com>
Date: Fri, 8 Jul 2011 14:02:52 -0500
Message-ID: <1310151772.3024.38.camel@doink>
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
> fsx segvs when dumping fallocate log entries. Fix magic string
> array index parameters to be zero based rather than one based.
> 
> While touching log string related stuff, make the format consistent
> with read and write operations so the log dump is easier to look at
> with the human eye.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
