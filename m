Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNKocpE003767 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 14:50:38 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 4/6] XFS: convert remaining direct references to m_perag
Date: Wed, 23 Dec 2009 14:49:54 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A68D0@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1260857477-2368-5-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> Convert the remaining direct lookups of the per ag structures
> to use get/put accesses. Ensure that the loops across AGs and
> prior users of the interface balance gets and puts correctly.

Generally looks good, but I have a question below.

Also, it looks to me like you missed adding a matching
xfs_perag_put() call in xfs_alloc_get_freelist().  I
have otherwise satisfied myself that all the get/put
calls are all matched up.  Furthermore, the only real
references to the m_perag field in the mount structure
is via xfs_perag_get().

					-Alex

> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_bmap.c   |    8 +++++++-
>  fs/xfs/xfs_ialloc.c |   35 +++++++++++++++++++++++++----------
>  fs/xfs/xfs_inode.c  |    5 ++++-
>  fs/xfs/xfs_mount.c  |    9 ++++++---
>  4 files changed, 42 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 98251cd..a9b95d9 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
. . .
> @@ -2667,6 +2668,7 @@ xfs_bmap_btalloc(
>  						break;
> 
>  					error = xfs_filestream_new_ag(ap, &ag);
> +					xfs_perag_put(pag);

Is there a reason you do the put operation *after* the call to
xfs_filestream_new_ag()?  I only ask because I had a similar
question (below) where xfs_ialloc_read_agi() was called, without
passing pag, but before calling xfs_perag_put() and I wondered
whether there was an implied requirement there.  If there is,
I'd like to see that made more explicit.  If not, I prefer to
see the put call done as early as possible.

>  					if (error) {
>  						up_read(&mp->m_peraglock);
>  						return error;
. . .
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index cb907ba..884ee13 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
. . .
> @@ -772,11 +778,14 @@ nextag:
>  			return noroom ? ENOSPC : 0;
>  		}
>  		down_read(&mp->m_peraglock);
> -		if (mp->m_perag[tagno].pagi_inodeok == 0) {
> +		pag = xfs_perag_get(mp, tagno);
> +		if (pag->pagi_inodeok == 0) {
> +			xfs_perag_put(pag);
>  			up_read(&mp->m_peraglock);
>  			goto nextag;
>  		}
>  		error = xfs_ialloc_read_agi(mp, tp, tagno, &agbp);
> +		xfs_perag_put(pag);

Here is the spot I wondered about--whether the pag needed to
be held across the call to xfs_ialloc_read_agi().  If so,
it isn't obvious from looking directly at this spot in the
code so it should maybe be spelled out more clearly in a
comment.

>  		up_read(&mp->m_peraglock);
>  		if (error)
>  			goto nextag;
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
