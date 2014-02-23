Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D9BA7F57
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 15:06:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CC968F8033
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 13:06:26 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HXMxrtznji1c4b31 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 13:06:24 -0800 (PST)
Date: Mon, 24 Feb 2014 08:06:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: add support for flink
Message-ID: <20140223210617.GC4317@dastard>
References: <20140220220000.GA17541@infradead.org>
	<20140221004933.GA9445@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140221004933.GA9445@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 04:49:33PM -0800, Christoph Hellwig wrote:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> +static cmdinfo_t flink_cmd;
> +
> +static void
> +flink_help(void)
> +{
> +	printf(_(
> +"\n"
> +"link the open file descriptor into the filesystem\n"
> +"\n"
> +"\n"));
> +}

"link the open file descriptor to the supplied filename\n"

?

> +void
> +flink_init(void)
> +{
> +	flink_cmd.name = "flink";
> +	flink_cmd.cfunc = flink_f;
> +	flink_cmd.argmin = 1;
> +	flink_cmd.argmax = 1;
> +	flink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	flink_cmd.args = _("filename");
> +	flink_cmd.oneline =
> +		_("link the open file descriptor into the filesystem");
> +	flink_cmd.help = flink_help;
> +
> +	add_command(&flink_cmd);
> +}
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 7a92ff6..7d0c792 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -638,6 +638,9 @@ Only available in expert mode and requires privileges.
>  Undo the effects of a filesystem freeze operation.
>  Only available in expert mode and requires privileges.
>  .TP
> +.B flink		
> +Link the currently open file descriptor into the filesystem namespace.
> +.TP

And that needs to indicate that a filename needs to be provided,
too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
