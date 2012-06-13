Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5DNqxPC198018 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 18:52:59 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pGl2hOWWVcZ2maYr for <xfs@oss.sgi.com>;
	Wed, 13 Jun 2012 16:52:58 -0700 (PDT)
Date: Thu, 14 Jun 2012 09:52:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613235256.GX22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<1339515364-17374-3-git-send-email-pbonzini@redhat.com>
	<20120613021610.GQ22848@dastard> <4FD8320C.1060308@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD8320C.1060308@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Jun 13, 2012 at 08:24:12AM +0200, Paolo Bonzini wrote:
> Il 13/06/2012 04:16, Dave Chinner ha scritto:
> >> > +	BUG_ON((mode & FALLOC_FL_PUNCH_HOLE) && (mode & FALLOC_FL_ZERO_RANGE));
> > Never put BUG_ON() or BUG() in XFS code that can return an error.
> > Return EINVAL if we chose not to support it, and if it's really
> > something we consider bad, emit a warning to syslog (i.e.
> > xfs_warn()) and potentially add a ASSERT() case so that debug
> > kernels will trip over it. Nobody should be panicing a production
> > system just because a user supplied a set of incorrect syscall
> > paramters....
> 
> I know, the BUG_ON() is because it is ruled out in VFS code.  Of course
> if I remove that code, this will not be a BUG_ON() anymore.

If we put a BUG_ON() for every condition the VFS checked in every
filesystem, we'd have so many BUG_ON checks we wouldn't be able to
find the code. If it's banned at the VFS, there's no need to assert
that inthe filesystem code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
