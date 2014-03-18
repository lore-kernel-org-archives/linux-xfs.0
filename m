Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DDDDC7F83
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 12:06:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE3C5304051
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 10:06:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yFqVVIQpuhvJCrqj for
	<xfs@oss.sgi.com>; Tue, 18 Mar 2014 10:06:43 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2IH6d20013681
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 13:06:40 -0400
Message-ID: <53287D1E.2010409@redhat.com>
Date: Tue, 18 Mar 2014 12:06:38 -0500
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: avoid segfault when report -h on non-existent
	path
References: <1395160746-26654-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1395160746-26654-1-git-send-email-eguan@redhat.com>
Reply-To: sandeen@redhat.com
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
To: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

On 3/18/14, 11:39 AM, Eryu Guan wrote:
> Command xfs_quota -xc "report -h" /nosuchdir would get segfault, fix
> that by checking fs_path first before dereferencing it.
> 
> Cc: Eric Sandeen <esandeen@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  quota/report.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index 70894a2..d486524 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -624,7 +624,7 @@ report_f(
>  		if (flags & ALL_MOUNTS_FLAG)
>  			report_any_type(fp, form, type, NULL,
>  					lower, upper, flags);
> -		else if (fs_path->fs_flags & FS_MOUNT_POINT)
> +		else if (fs_path && fs_path->fs_flags & FS_MOUNT_POINT)
>  			report_any_type(fp, form, type, fs_path->fs_dir,
>  					lower, upper, flags);
>  	} else while (argc > optind) {
> 

I think this is ok; state_f does the same thing.

but others don't; enable_f, disable_f, off_f etc.

Also this seems to be a slight regression since v3.1.8 or so, let me double
check that and see if we need to fix something more general.

Thanks!
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
