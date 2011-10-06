Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96LuG8U204044 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 16:56:17 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6C851B3F6C
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 14:56:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	K7ZiFtiOCYf1F9FN for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 14:56:14 -0700 (PDT)
Date: Fri, 7 Oct 2011 08:56:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix unused variable warning
Message-ID: <20111006215612.GT3159@dastard>
References: <1317877059-7024-1-git-send-email-david@fromorbit.com>
	<1317900267.3139.9.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317900267.3139.9.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 06, 2011 at 06:24:27AM -0500, Alex Elder wrote:
> On Thu, 2011-10-06 at 15:57 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Fix this warning:
> > 
> > fs/xfs/xfs_aops.c: In function 'xfs_end_io_direct_write':
> > fs/xfs/xfs_aops.c:1280:17: warning: unused variable 'inode' [-Wunused-variable]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> That line of code is not present in the current XFS
> master branch on oss.sgi.com.

I've got a 3.1-rc9 kernel that I merged the current XFS tree in.
There were a couple of merge conflicts that I fixed, so maybe that's
where it came from. I'll check.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
