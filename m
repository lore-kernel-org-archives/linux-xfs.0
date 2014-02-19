Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 044447FED
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 18:13:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3DC0304081
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 16:13:17 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GDdl6GOP9Rl6d3r8 for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 16:13:12 -0800 (PST)
Date: Wed, 19 Feb 2014 11:13:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Add a warning about non-ASCII filenames in ASCII-CI mode
Message-ID: <20140219001307.GI13647@dastard>
References: <1389806582-26815-1-git-send-email-zach@kotlarek.com>
	<1389806582-26815-2-git-send-email-zach@kotlarek.com>
	<8D3FA7645C1CFC4E9E783D22B4C708644AA855@P-EXMB2-DC21.corp.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8D3FA7645C1CFC4E9E783D22B4C708644AA855@P-EXMB2-DC21.corp.sgi.com>
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
To: Shaun Gosse <sgosse@sgi.com>
Cc: Zachary Kotlarek <zach@kotlarek.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jan 15, 2014 at 05:31:34PM +0000, Shaun Gosse wrote:
> Looks good.
> 
> Reviewed-by: Shaun Gosse <sgosse@sgi.com>
> 
> Thanks again,
> -Shaun
> 
> -----Original Message-----
> From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Zachary Kotlarek
> Sent: Wednesday, January 15, 2014 11:23 AM
> To: xfs@oss.sgi.com
> Cc: Zachary Kotlarek
> Subject: [PATCH] Add a warning about non-ASCII filenames in ASCII-CI mode
> 
> ---
>  man/man8/mkfs.xfs.8 |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8 index 8184e10..e1c5cf7 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -513,9 +513,11 @@ any power of 2 size from the filesystem block size up to 65536.
>  .IP
>  The
>  .B version=ci
> -option enables ASCII only case-insensitive filename lookup and version
> +option enables ASCII-only case-insensitive filename lookup and version
>  2 directories. Filenames are case-preserving, that is, the names -are stored in directories using the case they were created with.
> +are stored in directories using the case they were created with. In 
> +this mode non-ASCII file and directory names are not supported and are 
> +likely to become inaccessible if used.
>  .IP
>  Note: Version 1 directories are not supported.
>  .TP
> --

I missed this when it was posted and only just caught it. Sorry
about that.

I can't commit it without a Signed-off-by. Zachary, can you resned
this with a commit message indicating why the documentation change
is necessary and with a proper SOB on it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
