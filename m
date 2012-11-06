Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6Mfhwd095753 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 16:41:44 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GzLwTUJBxAflHNgy for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 14:43:39 -0800 (PST)
Date: Wed, 7 Nov 2012 09:43:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs_spaceman: updated preallocation support
	(eofblocks v6)
Message-ID: <20121106224337.GL24575@dastard>
References: <1352213704-59959-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352213704-59959-1-git-send-email-bfoster@redhat.com>
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
Cc: dchinner@redhat.com, xfs@oss.sgi.com

On Tue, Nov 06, 2012 at 09:55:04AM -0500, Brian Foster wrote:
> This is an update to Dave's patch to xfs_spaceman to support
> preallocation trimming. The original patch is here:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00418.html
> 
> The code is updated as follows:
> 
> - Update to latest struct xfs_eofblocks (supports v6 of the
>   speculative preallocation inode tracking set).
> - Support multiple id scan.
> - Fix the minimum argument count (no args means a trylock scan).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Dave,
> 
> I can also squash this into the original and post a new version if that is
> preferred. 

I'll probably do that myself - the current code I have is a little
different so the patch probably won't apply, anyway.  I'll need to
munge it to suit the eventual struct xfs_eofblocks format, anyway.

....

> @@ -136,7 +142,7 @@ prealloc_help(void)
>  "\n"
>  "Control speculative preallocation\n"
>  "\n"
> -"Options: [-s] [-ugp id] [-m minlen]\n"
> +"Options: [-s] [-u id] [-g id] [-p id] [-m minlen]\n"
>  "\n"
>  " -s -- synchronous flush - wait for flush to complete\n"
>  " -u id -- remove prealloc on files matching user quota id <id>\n"
> @@ -153,11 +159,11 @@ prealloc_init(void)
>  	prealloc_cmd.name = "prealloc";
>  	prealloc_cmd.altname = "prealloc";
>  	prealloc_cmd.cfunc = prealloc_f;
> -	prealloc_cmd.argmin = 1;
> +	prealloc_cmd.argmin = 0;

While technically correct, it's not the desired behaviour.  I wanted
it to issue the usage if you just type the comment. I think I need
to add a "-a" flag for "flush all" here.

> -	prealloc_cmd.oneline = _("Control specualtive preallocation");
> +	prealloc_cmd.oneline = _("Control speculative preallocation");

Good catch, Brain! :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
