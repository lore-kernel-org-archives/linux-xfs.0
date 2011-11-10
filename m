Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAGOv1K104589 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 10:24:57 -0600
Date: Thu, 10 Nov 2011 10:25:11 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfsprogs: add .ltdep to .gitignore
Message-ID: <20111110162511.GA29840@sgi.com>
References: <1320865438-27014-1-git-send-email-bpm@sgi.com>
	<20111109223735.GR5534@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111109223735.GR5534@dastard>
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
Cc: xfs@oss.sgi.com, arenaud@sgi.com, aelder@sgi.com

Hi Dave,

On Thu, Nov 10, 2011 at 09:37:35AM +1100, Dave Chinner wrote:
> On Wed, Nov 09, 2011 at 01:03:58PM -0600, Ben Myers wrote:
> > Make git ignore all .ltdep files which are created as part of the build
> > process.
> > 
> > ~/xfsprogs # find | grep ltdep
> > ./libxcmd/.ltdep
> > ./libxfs/.ltdep
> > ./libhandle/.ltdep
> > ./libdisk/.ltdep
> > ./libxlog/.ltdep
> > 
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> The same changes are needed for the xfstests and xfsdump packages,
> right? Regardless, this change is good.

Yep, it looks like there are a few things we can add to .gitignore in
xfstests.  Bill Kendall may have already resolved them in xfsdump.
I'll take a peek.

THanks,
	Ben

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
