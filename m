Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BMKeqH194691 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 16:20:41 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FER5htDJgwMun3re for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 14:20:38 -0800 (PST)
Date: Thu, 12 Jan 2012 09:20:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdump: allow system() to obtain exit status
Message-ID: <20120111222036.GK24410@dastard>
References: <CAGdb-8fyseE+ARMUWaQYcx1VCnmph=xL7XeTBUXg2wSSdF_7hw@mail.gmail.com>
	<1326316073-15033-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326316073-15033-1-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 11, 2012 at 03:07:53PM -0600, Bill Kendall wrote:
> xfsdump explicitly ignores SIGCHLD in order to prevent librmt rsh
> processes from becoming zombies. However, doing so interferes with the
> ability for system() to determine a command's exit status.
> 
> Setting up a handler for SIGCHLD will not work either, since xfsdump is
> now multi-threaded and the main thread (which handles signals) might
> handle a child exit before the thread running system() can.
> 
> I also attempted to use waitpid() when tearing down a librmt session,
> but this has the potential to block indefinitely if there is a problem
> on the remote side. (And using WNOHANG tended to never catch the exit.)
> 
> In the end, I settled on just not touching SIGCHLD at all. There may be
> a zombie rsh when librmt is used, but typically it will be alive until
> the end of the backup and in any case will be cleaned up when
> xfsdump/restore exits.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
