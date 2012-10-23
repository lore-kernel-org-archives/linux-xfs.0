Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9N1s5pB194204 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 20:54:06 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qaZ6uaUvT30PsVwK for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 18:55:48 -0700 (PDT)
Date: Tue, 23 Oct 2012 12:55:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 10/10] xfs: add background scanning to clear eofblocks
	inodes
Message-ID: <20121023015546.GN4291@dastard>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-11-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349446636-8611-11-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 05, 2012 at 10:17:16AM -0400, Brian Foster wrote:
> Create a new mount workqueue and delayed_work to enable background
> scanning and freeing of eofblocks inodes. The scanner kicks in once
> speculative preallocation occurs and stops requeueing itself when
> no eofblocks inodes exist.
> 
> The scan interval is based on the new
> 'background_prealloc_discard_period' tunable (default to 5m). The

"discard" - probably a bad idea to use a word that is associated
with similar but different functionality (i.e. mount -o discard).

Something like "speculative_prealloc_lifetime" might be a better way
of describing what it defines. i.e. speculative prealloc won't be
kept longer than this period on clean inodes. That keeps the sysctl
function independent of the underlying implementation, and it also
means we can use it as a catchall for any future speculative
allocation functionality we decide to add....

....
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index 76e81cf..efea30a 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -40,4 +40,5 @@ xfs_param_t xfs_params = {
>  	.rotorstep	= {	1,		1,		255	},
>  	.inherit_nodfrg	= {	0,		1,		1	},
>  	.fstrm_timer	= {	1,		30*100,		3600*100},
> +	.eofb_timer	= {	1,		300,		7200},

2 hours as the maximum might be too short for some people. e.g. once
a day might be all that some people will want this to happen because
they have slowly growing log files - they stay in cache, will most
likely trigger the "keep prealloc" heuristic, but can often go 5
minutes without being modified.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
