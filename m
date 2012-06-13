Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D3Uv9f070764 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 22:30:57 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	U5oIcpBiRb4jMcLM for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 20:30:55 -0700 (PDT)
Date: Wed, 13 Jun 2012 13:30:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613033052.GT22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<20120613013549.GO22848@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120613013549.GO22848@dastard>
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

On Wed, Jun 13, 2012 at 11:35:49AM +1000, Dave Chinner wrote:
> On Tue, Jun 12, 2012 at 05:36:02PM +0200, Paolo Bonzini wrote:
> > This patch adds the FALLOC_FL_ZERO_RANGE operation mode to fallocate,
> > resembling the similar XFS ioctl.  The new mode can be used with
> > or without FALLOC_FL_KEEP_SIZE, but of course not together with
> > FALLOC_FL_PUNCH_HOLE.
> 
> !FALLOC_FL_KEEP_SIZE makes no sense for this operation. It is for
> zeroing an existing section of a file while retaining the allocated
> space, not for extending or truncating the file. It's the same
> reason that FALLOC_FL_PUNCH_HOLE must have FALLOC_FL_KEEP_SIZE set.
> 
> Also, a minor nit, but you should credit where this code has
> originated from in the commit messages, and describe the use case
> for requiring it. i.e. based on:
> 
> http://permalink.gmane.org/gmane.linux.file-systems/62449

Oh, and you'll need to provide a new xfstests test based on 242 that
uses the new fallocate interface, and to do that you'll also need to
add support for the new fallocate function in xfs_io.

Adding generic filesystem functionality is not as simple as writing a
kernel patch anymore... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
