Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61A4B7CA0
	for <xfs@oss.sgi.com>; Fri, 16 Sep 2016 08:30:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DBB62AC004
	for <xfs@oss.sgi.com>; Fri, 16 Sep 2016 06:30:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mZ67tHBxayvwDpyv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Sep 2016 06:30:31 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9E08DC05E171
	for <xfs@oss.sgi.com>; Fri, 16 Sep 2016 13:30:30 +0000 (UTC)
Date: Fri, 16 Sep 2016 08:30:27 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs_quota: Enable 3 more foreign commands
Message-ID: <20160916133027.GA12342@redhat.com>
References: <5fe315ee-1198-ca43-16a0-13562ced179e@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5fe315ee-1198-ca43-16a0-13562ced179e@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Sep 15, 2016 at 04:53:51PM -0500, Eric Sandeen wrote:
> Enable restore, limit, and timer.
> 
> Unsupported commands remain, for lack of kernel support, generally:
> warn, quot,, enable, disable, and remove.
> 
> xfs_quota> report
> User quota on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
>                                Blocks                     
> User ID          Used       Soft       Hard    Warn/Grace     
> ---------- -------------------------------------------------- 
> root               13          0          0     00 [--------]
> 
> xfs_quota> restore -f quotadump
> xfs_quota> report
> User quota on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
>                                Blocks                     
> User ID          Used       Soft       Hard    Warn/Grace     
> ---------- -------------------------------------------------- 
> root               13          0          0     00 [--------]
> testuser            0      16384      32768     00 [--------]
> fsgqa               0     102400     112640     00 [--------]
> 
> xfs_quota> limit bsoft=200m fsgqa
> 
> xfs_quota> report 
> User quota on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
>                                Blocks                     
> User ID          Used       Soft       Hard    Warn/Grace     
> ---------- -------------------------------------------------- 
> root               13          0          0     00 [--------]
> testuser            0      16384      32768     00 [--------]
> fsgqa               0     204800     112640     00 [--------]
> 
> xfs_quota> state -u
> User quota state on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
>   Accounting: ON
>   Enforcement: ON
>   Inode: #12 (16 blocks, 1 extents)
> Blocks grace time: [7 days]
> Inodes grace time: [7 days]
> 
> xfs_quota> timer -b 3days
> xfs_quota> state -u
> User quota state on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
>   Accounting: ON
>   Enforcement: ON
>   Inode: #12 (16 blocks, 1 extents)
> Blocks grace time: [3 days]
> Inodes grace time: [7 days]
> Realtime Blocks grace time: [--------]
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> diff --git a/quota/edit.c b/quota/edit.c
> index e5ddc8c..36b327a 100644
> --- a/quota/edit.c
> +++ b/quota/edit.c
> @@ -709,6 +709,7 @@ edit_init(void)
>  	_("[-g|-p|-u] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name");
>  	limit_cmd.oneline = _("modify quota limits");
>  	limit_cmd.help = limit_help;
> +	limit_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	restore_cmd.name = "restore";
>  	restore_cmd.cfunc = restore_f;
> @@ -716,6 +717,7 @@ edit_init(void)
>  	restore_cmd.argmax = -1;
>  	restore_cmd.args = _("[-g|-p|-u] [-f file]");
>  	restore_cmd.oneline = _("restore quota limits from a backup file");
> +	restore_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	timer_cmd.name = "timer";
>  	timer_cmd.cfunc = timer_f;
> @@ -724,6 +726,7 @@ edit_init(void)
>  	timer_cmd.args = _("[-bir] [-g|-p|-u] value");
>  	timer_cmd.oneline = _("set quota enforcement timeouts");
>  	timer_cmd.help = timer_help;
> +	timer_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	warn_cmd.name = "warn";
>  	warn_cmd.cfunc = warn_f;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
