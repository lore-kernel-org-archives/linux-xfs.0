Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52Jlp3d125756 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 14:47:51 -0500
Message-ID: <4A2581F6.8070705@sandeen.net>
Date: Tue, 02 Jun 2009 14:48:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Update xfstests' README to document method/necessity
References: <1243970604-13732-1-git-send-email-rherndon@attica.americas.sgi.com>
In-Reply-To: <1243970604-13732-1-git-send-email-rherndon@attica.americas.sgi.com>
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
To: robert herndon <rherndon@sgi.com>
Cc: robert herndon <rherndon@elm.eagan>, xfs@oss.sgi.com

robert herndon wrote:
> From: robert herndon <rherndon@elm.eagan>
> 
> ---
>  README |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/README b/README
> index 375e07c..f9725b4 100644
> --- a/README
> +++ b/README
> @@ -18,6 +18,17 @@ Preparing system for tests (IRIX and Linux):
>  
>      - compile XFS into your kernel or load XFS modules
>      - install user tools including mkfs.xfs, xfs_db & xfs_bmap
> +    - install header files required to build xfstests' programs:
> +
> +           # cd <...>/xfsprogs
> +           # make install-qa

With any luck, this will be going away soon, actually.

It's only required for loggen, and we're looking for ways around that.
See for example [PATCH, RFC] xfsprogs: add xfs_loggen and/or [PATCH 1/9
V2] Use xfs.h rather than libxfs.h on the list.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
