Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96CHpaW182577 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 07:17:51 -0500
Subject: Re: [PATCH 1/2] repair: handle repair of image files on large
	sector size filesystems
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1317862891-3033-2-git-send-email-david@fromorbit.com>
References: <1317862891-3033-1-git-send-email-david@fromorbit.com>
	<1317862891-3033-2-git-send-email-david@fromorbit.com>
Date: Thu, 6 Oct 2011 07:17:45 -0500
Message-ID: <1317903465.3139.29.camel@doink>
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

On Thu, 2011-10-06 at 12:01 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because repair uses direct IO, it cannot do IO smaller than a sector
> on the underlying device. When repairing a filesystem image, the
> filesystem hosting the image may have a sector size larger than the
> sector size of the image, and so single image sector reads and
> writes will fail.
> 
> To avoid this, when checking a file and there is a sector size
> mismatch like this, turn off direct IO. While there, fix a compile
> bug in the IO_DEBUG option for libxfs which was found during triage.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I had a few suggestions for you to consider when I
reviewed this before.  The second patch in this series
needs an update so you have a chance to address those
suggestions if you so choose.

    http://patchwork.xfs.org/patch/2336/

Either way, I'll mark this as I did before.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
