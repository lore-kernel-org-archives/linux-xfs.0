Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q835ZgMh148104 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 00:35:42 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HMob6u7Cge2s05cG for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 22:36:37 -0700 (PDT)
Date: Mon, 3 Sep 2012 15:36:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfstests: Use libtool to install applications
Message-ID: <20120903053636.GV15292@dastard>
References: <20120828172605.607853317@sgi.com>
	<20120828172928.999971219@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120828172928.999971219@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 28, 2012 at 12:26:07PM -0500, Rich Johnston wrote:
> This patch replaces the INSTALL macro with LTINSTALL so that libtool is used
> to install the applications.  Libtool will install the binary from the proper
> location and display a warning if any shared library dependancies are not
> properly installed.  This ensures that a libtool wrapper shell script is not
> installed in place of application when libtool wrappers are being used.
> 
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>

Looks OK - do any of the dmapi/ makefiles need this treatment?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
