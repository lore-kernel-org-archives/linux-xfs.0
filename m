Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5DNpgcb197889 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 18:51:42 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kykqwk873JMPZDhr for <xfs@oss.sgi.com>;
	Wed, 13 Jun 2012 16:51:40 -0700 (PDT)
Date: Thu, 14 Jun 2012 09:51:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613235131.GW22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<20120613013549.GO22848@dastard> <20120613033052.GT22848@dastard>
	<4FD82F89.80106@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD82F89.80106@redhat.com>
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

On Wed, Jun 13, 2012 at 08:13:29AM +0200, Paolo Bonzini wrote:
> Il 13/06/2012 05:30, Dave Chinner ha scritto:
> >> > 
> >> > Also, a minor nit, but you should credit where this code has
> >> > originated from in the commit messages, and describe the use case
> >> > for requiring it. i.e. based on:
> >> > 
> >> > http://permalink.gmane.org/gmane.linux.file-systems/62449
> 
> Interesting, I didn't know this---I wrote the code from scratch.
> 
> I took the description from the man pages ("This operation is a fast
> method of overwriting any from the range specified with zeros without
> removing any blocks or having to write zeros to disk"), so perhaps those
> will have to be patched as well.

The first line of the man page description is the important one:

$ man 3 xfsctl
.....
XFS_IOC_ZERO_RANGE
      This  command is used to convert a range of a file to zeros
      without issuing data IO. ....

The rest of the description is details about the implementation in
XFS, so users have some idea what to expect in terms or behaviour.
The line that you quoted:

	This operation is a fast method of overwriting any from the
	range specified with zeros without removing any blocks or
	having to write zeros to disk.

describes how the implementation is different from hole punching
(i.e XFS_IOC_UNRESVSP).  All the stuff about unwritten extents is
copied directly from the about XFS_IOC_RESVSP preallocation
description to provide consistent information in the man page.

The XFS_IOC_ZERO_RANGE man page is not a requirements specification
- it's user-level documentation. Yes, it describes the
implementation, but does not convey any of the reasons that the
functionality was implemented that way. Hence using that as the
requirements spec for equivalent fallocate functionality will miss
the mark...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
