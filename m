Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3B1A7F47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 22:41:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52E09AC001
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 20:41:21 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id hVa1cjByipNSxQXu for <xfs@oss.sgi.com>;
	Fri, 15 Jan 2016 20:41:16 -0800 (PST)
Subject: Re: [PATCH] xfs_quota: allow operation on foreign filesystem types
References: <1452729788-5396-1-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5699C9EB.10307@sandeen.net>
Date: Fri, 15 Jan 2016 22:41:15 -0600
MIME-Version: 1.0
In-Reply-To: <1452729788-5396-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On 1/13/16 6:03 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This allows xfs_quota to be used on ext4 for project quota testing
> in xfstests.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

...


> diff --git a/quota/report.c b/quota/report.c
> index c77b24f..eaf3a67 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -658,6 +658,7 @@ report_init(void)
>  	dump_cmd.args = _("[-gpu] [-f file]");
>  	dump_cmd.oneline = _("dump quota information for backup utilities");
>  	dump_cmd.help = dump_help;
> +	dump_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	report_cmd.name = "report";
>  	report_cmd.altname = "repquota";
> @@ -668,6 +669,7 @@ report_init(void)
>  	report_cmd.args = _("[-bir] [-gpu] [-ahnt] [-f file]");
>  	report_cmd.oneline = _("report filesystem quota information");
>  	report_cmd.help = report_help;
> +	report_cmd.flags = CMD_FLAG_FOREIGN_OK;

There's another

	report_cmd.flags = CMD_FLAG_GLOBAL;

above this which gets overwritten here; this command needs to be:

	report_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;

or else

	xfs_quota -x -c "report -a"

goes bonkers, iterating in nested loops and printing filesystems multiple times.

It also seems that "report -a" should not be changing defaults this way such
that non-xfs filesystems will get printed; this will be an unexpected change
to default behavior.

Perhaps a top-level "-f" option to explicitly enable foreign filesystem detection
would be best?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
