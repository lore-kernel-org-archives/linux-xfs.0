Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D1a2Qq060688 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 20:36:02 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XGkhB05XQ9oQpXl4 for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 18:36:00 -0700 (PDT)
Date: Wed, 13 Jun 2012 11:35:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613013549.GO22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
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
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Tue, Jun 12, 2012 at 05:36:02PM +0200, Paolo Bonzini wrote:
> This patch adds the FALLOC_FL_ZERO_RANGE operation mode to fallocate,
> resembling the similar XFS ioctl.  The new mode can be used with
> or without FALLOC_FL_KEEP_SIZE, but of course not together with
> FALLOC_FL_PUNCH_HOLE.

!FALLOC_FL_KEEP_SIZE makes no sense for this operation. It is for
zeroing an existing section of a file while retaining the allocated
space, not for extending or truncating the file. It's the same
reason that FALLOC_FL_PUNCH_HOLE must have FALLOC_FL_KEEP_SIZE set.

Also, a minor nit, but you should credit where this code has
originated from in the commit messages, and describe the use case
for requiring it. i.e. based on:

http://permalink.gmane.org/gmane.linux.file-systems/62449

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
