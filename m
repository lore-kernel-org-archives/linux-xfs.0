Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 81E687CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 08:35:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3594730405F
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 06:35:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kItVFsCrpJGcJry9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 06:35:33 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 58C623B754
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 13:35:32 +0000 (UTC)
Subject: Re: [PATCH v2] xfs_quota: print quota id number if the name can't be
	found
References: <1460002331-18278-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <57066221.3080003@redhat.com>
Date: Thu, 7 Apr 2016 08:35:29 -0500
MIME-Version: 1.0
In-Reply-To: <1460002331-18278-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

On 4/6/16 11:12 PM, Zorro Lang wrote:
> When use GETNEXTQUOTA ioctl to report project quota, it always
> report an unexpected quota:
> 
>   (null) 0 0 0 00 [--------]
> 
> The ID 0 store the default quota, even if no one set default quota,
> it still have quota accounting, but not enforced. So GETNEXTQUOTA
> can find and report this undefined quota.
> 
> From this problem, I thought if others' quota name miss, (null) will
> be printed too. e.g.
> 
>   # xfs_quota -xc "limit -u bsoft=300m bhard=400m test" $mnt
>   # xfs_quota -xc "report -u" $mnt
>   User ID          Used       Soft       Hard    Warn/Grace
>   ---------- --------------------------------------------------
>   root                0          0          0     00 [--------]
>   test                0     307200     409600     00 [--------]
>   # userdel -r test
>   # xfs_quota -xc "report -u" $mnt
>   User ID          Used       Soft       Hard    Warn/Grace
>   ---------- --------------------------------------------------
>   root                0          0          0     00 [--------]
>   (null)              0     307200     409600     00 [--------]
> 
> So this problem same with above id 0's problem. For deal with this,
> this patch will print id number if the name can't be found.
> 
> But if use old GETQUOTA ioctl, it won't print project id 0 quota
> information(if it's not defined). That's different with GETNEXTQUOTA.
> For keep consistent, this patch also print project id 0 when use old
> GETQUOTA.

thanks Zorro, tiny little manpage nitpick below.  Rest assured that
your English is still much better than my Chinese.  :)

> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> This V2 patch has below change:
> 1. Add some comments
> 2. Change the xfs_quota man page
> 3. For alignment, change "#%-10u" to "#%-9u" when print ID or name
> mixed.
> 
> For reduce the impact on xfstests, I didn't change the original
> "#%-10u" when use "report -n":
> 
>   if (flags & NO_LOOKUP_FLAG) {
>           fprintf(fp, "#%-10u", d.d_id);
> 			
> And didn't change "%-10s" when print quota name:
> 
>   fprintf(fp, "%-10s", name);
> 
> Thanks,
> Zorro
> 
>  man/man8/xfs_quota.8 |  7 +++++--
>  quota/report.c       | 16 +++++++++++++++-
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 951252b..dc01804 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -357,9 +357,12 @@ option outputs the report to
>  .I file
>  instead of stdout. The
>  .B \-a
> -option reports on all filesystems. The
> +option reports on all filesystems. As default, outputs the name of
> +the user/group/project. But if no name is defined, outputs the
> +numberic ID. The

"numeric" - 

Maybe:

"option reports on all filesystems.  By default, outputs the name of
the user/group/project.  If no name is defined for a given ID, outputs
the numeric ID instead.  The"

>  .B \-n
> -option outputs the numeric ID instead of the name. The
> +option outputs the numeric ID instead of the name, even the name is
> +defined. The

Probably no need for this change; the number always exists, so just
"The option outputs the numeric ID instead of the name." is enough.

Thanks,
-Eric

>  .B \-L
>  and
>  .B \-U
> diff --git a/quota/report.c b/quota/report.c
> index 48a3f29..cc422d1 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -389,7 +389,11 @@ report_mount(
>  					name = p->pr_name;
>  			}
>  		}
> -		fprintf(fp, "%-10s", name);
> +		/* If no name is found, print the id #num instead of (null) */
> +		if (name != NULL)
> +			fprintf(fp, "%-10s", name);
> +		else
> +			fprintf(fp, "#%-9u", d.d_id);
>  	}
>  
>  	if (form & XFS_BLOCK_QUOTA) {
> @@ -571,6 +575,16 @@ report_project_mount(
>  			id = oid + 1;
>  		}
>  	} else {
> +		if (!getprprid(0)) {
> +			/*
> +			 * Print default project quota, even if projid 0
> +			 * isn't defined
> +			 */
> +			report_mount(fp, 0, NULL, NULL, form, XFS_PROJ_QUOTA,
> +			             mount, flags);
> +			flags |= NO_HEADER_FLAG;
> +		}
> +
>  		setprent();
>  		while ((p = getprent()) != NULL) {
>  			if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
