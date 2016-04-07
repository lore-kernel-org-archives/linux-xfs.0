Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEA867CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 09:51:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F637AC007
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 07:51:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LFrKrbxPEH3cNRR9 for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 07:51:36 -0700 (PDT)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 94B2116C152
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 09:51:35 -0500 (CDT)
Subject: Re: [PATCH v3] xfs_quota: print quota id number if the name can't be
	found
References: <1460040514-23834-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <570673F7.3040107@sandeen.net>
Date: Thu, 7 Apr 2016 09:51:35 -0500
MIME-Version: 1.0
In-Reply-To: <1460040514-23834-1-git-send-email-zlang@redhat.com>
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

On 4/7/16 9:48 AM, Zorro Lang wrote:
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
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Looks good to me, thanks Zorro!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> 
> Hi,
> 
> This V3 patch fix some man page problems. Thanks for Eric specified my
> English syntax problems.
> 
> Thanks,
> Zorro
> 
>  man/man8/xfs_quota.8 |  4 +++-
>  quota/report.c       | 16 +++++++++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 951252b..a14568b 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -357,7 +357,9 @@ option outputs the report to
>  .I file
>  instead of stdout. The
>  .B \-a
> -option reports on all filesystems. The
> +option reports on all filesystems. By default, outputs the name of
> +the user/group/project. If no name is defined for a given ID, outputs
> +the numeric ID instead. The
>  .B \-n
>  option outputs the numeric ID instead of the name. The
>  .B \-L
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
