Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K3hi1t259000 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 22:43:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 488F612D29DE
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 20:45:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	f8eAle7u2HEsBabF for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 20:45:42 -0700 (PDT)
Date: Tue, 20 Apr 2010 13:45:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: mkfs: make strict check on -ialign option
Message-ID: <20100420034533.GB15130@dastard>
References: <201004190942.o3J7aqh5003810@rcsinet13.oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004190942.o3J7aqh5003810@rcsinet13.oracle.com>
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
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, xfs@oss.sgi.com

On Mon, Apr 19, 2010 at 05:41:36PM +0800, Wengang Wang wrote:
> Though it's clearly said in mkfs.xfs man page that for -ialign option only 1 or
> 0 are valid values, I would like to make a strict check on it in code.
> 
> If a user specified -ialign=y(but he meant -ialign=1 actually), mkfs treats "y"
> as "0"(simply by atoi()) thus acts wrongly without complaint. I think we'd better
> prevent that from happening, so I made the patch. The patch fails the operation
> on values for -ialign option, like "yes", "no", "y", "n".
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  mkfs/xfs_mkfs.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2d09e36..d7e9eb3 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1180,14 +1180,17 @@ main(
>  			p = optarg;
>  			while (*p != '\0') {
>  				char	*value;
> +				int len;
>  
>  				switch (getsubopt(&p, (constpp)iopts, &value)) {
>  				case I_ALIGN:
>  					if (!value)
>  						value = "1";
> -					iaflag = atoi(value);
> -					if (iaflag < 0 || iaflag > 1)
> +					len = strlen(value);
> +					if (len != 1 || value[0] < '0' ||
> +					    value[0] > '1')
>  						illegal(value, "i align");
> +					iaflag = value[0] - '0';

Wouldn't this be better changing atoi() to strtol() and then checking
errno along with the bounds?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
