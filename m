Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A11F17F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 16:31:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2CB54AC008
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 14:31:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	huYlQwqnArdhkd1w for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 14:31:47 -0700 (PDT)
Date: Thu, 27 Aug 2015 07:31:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsrestore: fix fs uuid order check for incremental
	restores
Message-ID: <20150826213133.GB3902@dastard>
References: <55D5DB95.1280108@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55D5DB95.1280108@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 26, 2015 at 11:27:12AM -0500, Rich Johnston wrote:
> Restoring an incremental level 1 dump will fail with the following error
> if the fs uuid of the most recent level 0 dump in the inventory does not
> match level 1 dump we are restoring.
> 
>   xfsrestore: ERROR: selected dump not based on previously applied dump
> 
> This can happen when you have multiple filesystems and you are restoring
> a level 1 or greater dump of filesystem FS1 but the most recent level 0
> dump in the inventory was filesystem FS2
> 
> The fix is to ensure the fs uuid of the inventory entry and the dump to
> be restored match.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> ---
>  dump/content.c        |    8 ++-
>  inventory/inv_api.c   |  108 ++++++++++++++++++++++++++++++--------------------
>  inventory/inv_mgr.c   |   32 ++++++++++----
>  inventory/inv_priv.h  |    7 +--
>  inventory/inventory.h |    5 ++
>  restore/content.c     |   17 +++++--
>  6 files changed, 113 insertions(+), 64 deletions(-)
> 
> Index: b/dump/content.c
> ===================================================================
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -872,7 +872,7 @@ content_init( intgen_t argc,
>          sameinterruptedpr = BOOL_FALSE;
>          interruptedpr = BOOL_FALSE;
>  -        ok = inv_get_session_byuuid( &baseuuid, &sessp );
> +        ok = inv_get_session_byuuid( &fsid, &baseuuid, &sessp );
>          if ( ! ok ) {
>              mlog( MLOG_NORMAL | MLOG_ERROR, _(
>                    "could not find specified base dump (%s) "

This patch has whitespace problems all through it (bad indenting,
all tabs converted to spaces, etc) and so it won't apply. Please fix
and resend.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
