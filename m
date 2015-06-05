Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07B4F7F82
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2015 17:23:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BD19AC001
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2015 15:23:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZhCLGCZWa8mXN8uU for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2015 15:23:00 -0700 (PDT)
Date: Sat, 6 Jun 2015 08:22:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix in the setting of logbsize
Message-ID: <20150605222257.GY24666@dastard>
References: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ales Novak <alnovak@suse.cz>
Cc: xfs@oss.sgi.com

[dropped lkml from the cc list, XFS specific noise is not needed
there.]

On Fri, Jun 05, 2015 at 03:28:45PM +0200, Ales Novak wrote:
> Logbsize should be integer multiple of log stripe unit size. If it's
> not, various operations will lead to crashes, due to invalid buffer
> sizes, i.e. we've seen crashes in the callpath xlog_sync->xlog_pack_data.

Can you give more information about the crashes? From this
description, I do not know whether this is a work around or a fix
because I don't know  what code is actually causing the problem or
the circumstances in which the crash occurs. Hence I cannot
determine if your change is the right change to make or whether the
documetnation is simply wrong and we have a real bug we shoul dbe
fixing.

> However, this rule is only mentioned in the documentation, while it
> could be checked during the mount.

Where in the documentation is that mentioned?

> Signed-off-by: Ales Novak <alnovak@suse.cz>
> ---
>  fs/xfs/xfs_super.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8fcc4cc..1a3766d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1352,6 +1352,11 @@ xfs_finish_flags(
>  			xfs_warn(mp,
>  		"logbuf size must be greater than or equal to log stripe size");
>  			return -EINVAL;
> +		} else if (mp->m_logbsize > 0 && mp->m_sb.sb_logsunit > 0 &&
> +			   mp->m_logbsize % mp->m_sb.sb_logsunit) {
> +			xfs_warn(mp,
> +		"logbuf size must be integer multiple of log stripe size");
> +			return -EINVAL;
>  		}
>  	} else {
>  		/* Fail a mount if the logbuf is larger than 32K */

If the logbsize was not specified as a mount option, we simply use
what is on disk. If it was specified as a mount option, we know that
we've already constrained m_logbsize to 32k, 64k, 128k or 256k (in
xfs_parse_args()). Which then means the above code will refuse to
mount a filesystem where the logsunit is not a power of two. e.g.
logsunit of 96k and logbsize=192k will not be allowed to mount...

So, at minimum, we need to refine more than just check for integer
multiples here, and so we need to look at whether arbitrary stripe
unit alignments in mkfs are valid given the power-of-2 restriction
on the log buffer size which may be overly restrictive...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
