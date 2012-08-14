Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7ELda4A011566 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 16:39:36 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	E4LZ6RCgxsTDGzfs for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 14:39:34 -0700 (PDT)
Date: Wed, 15 Aug 2012 07:39:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: Use upstream version of fstrim instead of
	the local one
Message-ID: <20120814213911.GM2877@dastard>
References: <1344937201-17389-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1344937201-17389-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Tue, Aug 14, 2012 at 11:40:01AM +0200, Tomas Racek wrote:
> Local version of fstrim was dropped so that we depend on upstream
> version now. _require_fstrim was added to check if fstrim is available
> in the system and _test_batched_discard to check if we can run fstrim
> on certain mountpoint.
> 
> Also tests 251 and 260 were modified to reflect this change.

Looks OK, but the only thing I'd suggest is using a $FSTRIM_PROG
variable rather than fsttrim directly. see how $XFS_IO_PROG is set
up in common.rc and copy that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
