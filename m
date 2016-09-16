Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7923A7CA0
	for <xfs@oss.sgi.com>; Fri, 16 Sep 2016 08:31:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B982304066
	for <xfs@oss.sgi.com>; Fri, 16 Sep 2016 06:31:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Kyd5fqM6zMTQeHXM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Sep 2016 06:31:22 -0700 (PDT)
Date: Fri, 16 Sep 2016 08:31:19 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs_quota: un-flag non-foreign-capable commands
Message-ID: <20160916133119.GB12342@redhat.com>
References: <294717b5-f997-ca39-2095-cc144a71de47@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <294717b5-f997-ca39-2095-cc144a71de47@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Thu, Sep 15, 2016 at 05:58:26PM -0500, Eric Sandeen wrote:
> The off command calls XFS_QUOTAOFF / Q_XQUOTAOFF, which calls
> quota_disable in the kernel, which returns ENOSYS if the
> ->quota_enable quota op doesn't exist - and it does not exist
> on any non-xfs filesystems.
> 
> We could get clever if we wanted it, and send Q_QUOTAOFF
> instead for foreign filesystems, but for now it's broken
> so just remove the flag.
> 
> The free command relies on XFS_IOC_FSGEOMETRY_V1, so unflag it
> as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> diff --git a/quota/state.c b/quota/state.c
> index 05e4ec5..09dfa70 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -584,7 +584,6 @@ state_init(void)
>  	off_cmd.args = _("[-gpu] [-v]");
>  	off_cmd.oneline = _("permanently switch quota off for a path");
>  	off_cmd.help = off_help;
> -	off_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	state_cmd.name = "state";
>  	state_cmd.cfunc = state_f;
> diff --git a/quota/free.c b/quota/free.c
> index b9be954..3c8a5ce 100644
> --- a/quota/free.c
> +++ b/quota/free.c
> @@ -372,7 +372,6 @@ free_init(void)
>  	free_cmd.args = _("[-bir] [-hn] [-f file]");
>  	free_cmd.oneline = _("show free and used counts for blocks and inodes");
>  	free_cmd.help = free_help;
> -	free_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	add_command(&free_cmd);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
