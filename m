Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG446Pu002308
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 22:04:06 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3F2A23C46
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 20:04:05 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id TpDgj8PXfrNSodlZ for <linux-xfs@oss.sgi.com>;
	Mon, 15 Dec 2008 20:04:05 -0800 (PST)
Message-ID: <49472895.2050601@sandeen.net>
Date: Mon, 15 Dec 2008 22:03:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] xfs_quota: Fix range for -U.
References: <1229369386-66312-1-git-send-email-arekm@maven.pl>	<1229369386-66312-2-git-send-email-arekm@maven.pl>	<1229369386-66312-3-git-send-email-arekm@maven.pl>	<1229369386-66312-4-git-send-email-arekm@maven.pl>	<1229369386-66312-5-git-send-email-arekm@maven.pl>
	<1229369386-66312-6-git-send-email-arekm@maven.pl>
In-Reply-To: <1229369386-66312-6-git-send-email-arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-xfs@oss.sgi.com, Nathan Scott <nscott@aconex.com>

Arkadiusz Miskiewicz wrote:
> xfs_quota report "-L" option specifies lower range of requested IDs.
> "-U" specifies upper range but "-L" is closed range while "-U" is open
> range.
> 
> Make "-U" closed range, too which is something more expected.

This seems like a good idea, although it changes behavior, and any
scripts that depended on this behavior will now get a different result.

Nathan, any thoughts?  I think you put this in originally :)

-Eric

> ---
>  xfsprogs/quota/report.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/xfsprogs/quota/report.c b/xfsprogs/quota/report.c
> index 21b4edb..2184158 100644
> --- a/xfsprogs/quota/report.c
> +++ b/xfsprogs/quota/report.c
> @@ -124,7 +124,7 @@ dump_limits_any_type(
>  	}
>  
>  	if (upper) {
> -		for (id = lower; id < upper; id++)
> +		for (id = lower; id <= upper; id++)
>  			dump_file(fp, id, type, mount->fs_name);
>  		return;
>  	}
> @@ -398,7 +398,7 @@ report_user_mount(
>  	uint		id;
>  
>  	if (upper) {	/* identifier range specified */
> -		for (id = lower; id < upper; id++) {
> +		for (id = lower; id <= upper; id++) {
>  			snprintf(n, sizeof(n)-1, "#%u", id);
>  			if (report_mount(fp, id, n,
>  					form, XFS_USER_QUOTA, mount, flags))
> @@ -436,7 +436,7 @@ report_group_mount(
>  	uint		id;
>  
>  	if (upper) {	/* identifier range specified */
> -		for (id = lower; id < upper; id++) {
> +		for (id = lower; id <= upper; id++) {
>  			snprintf(n, sizeof(n)-1, "#%u", id);
>  			if (report_mount(fp, id, n,
>  					form, XFS_GROUP_QUOTA, mount, flags))
> @@ -473,7 +473,7 @@ report_project_mount(
>  	uint		id;
>  
>  	if (upper) {	/* identifier range specified */
> -		for (id = lower; id < upper; id++) {
> +		for (id = lower; id <= upper; id++) {
>  			snprintf(n, sizeof(n)-1, "#%u", id);
>  			if (report_mount(fp, id, n,
>  					form, XFS_PROJ_QUOTA, mount, flags))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
