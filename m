Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E13C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 14:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347241AbiF1Os2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 10:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346126AbiF1Os1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 10:48:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC8E2AC6E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 07:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE2FAB81EA4
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 14:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA2CC3411D;
        Tue, 28 Jun 2022 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656427704;
        bh=vpAI+nFou+P3/HX6mfqyQ/Lk4p03lrzCbUxF4S3pxU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJmT371ZP/L1sWXtpyxEBoNsEok89RPdhtx9UpWsIKJ7a+Lx8rrWl2kne0PN84a/u
         9kiT59CaM2orX8L0FKCrBBfmV/2TN9y6hGIgZ7/XilXskkQS/mmTvTV6nAhBeSmPR2
         XcNBmrO96x/Nd4dagFTGG7nNME/h8bFyqCJqm987eSe6B6Gnx3fegwhWHXosgBYAiH
         nFVo0K1WUZQx/jkKeR8psbIJgHU7N1SebhjVLumEfdyjnG5b3pgTKUj5Joz6UzZTXw
         XukH+9LwigZPw9309TrCqm2AFWqxtj14d2q51SGpjJB6YRRQBb8b381qA05K8+4vp/
         Qp1TIj6JvHxiA==
Date:   Tue, 28 Jun 2022 07:48:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     hexiaole <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, hexiaole <hexiaole@kylinos.cn>
Subject: Re: [PATCH v1] xfs: correct nlink printf specifier from hd to PRIu32
Message-ID: <YrsUt6Ap4fam1d+8@magnolia>
References: <20220628144542.33704-1-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628144542.33704-1-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 10:45:42PM +0800, hexiaole wrote:
> From: hexiaole <hexiaole@kylinos.cn>
> 
> 1. Description
> libxfs/xfs_log_format.h declare 'di_nlink' as unsigned 32-bit integer:
> 
> typedef struct xfs_icdinode {
>         ...
>         __uint32_t      di_nlink;       /* number of links to file */
>         ...
> } xfs_icdinode_t;
> 
> But logprint/log_misc.c use '%hd' to print 'di_nlink':
> 
> void
> xlog_print_trans_inode_core(xfs_icdinode_t *ip)
> {
>     ...
>     printf(_("nlink %hd uid %d gid %d\n"),
>            ip->di_nlink, ip->di_uid, ip->di_gid);
>     ...
> }
> 
> '%hd' can be 16-bit on many architectures, on these architectures, the 'printf' only print the low 16-bit of 'di_nlink'.
> 
> 2. Reproducer
> 2.1. Commands
> [root@localhost ~]# cd
> [root@localhost ~]# xfs_mkfile 128m 128m.xfs
> [root@localhost ~]# mkfs.xfs 128m.xfs
> [root@localhost ~]# mount 128m.xfs /mnt/
> [root@localhost ~]# cd /mnt/
> [root@localhost mnt]# seq 1 65534|xargs mkdir -p
> [root@localhost mnt]# cd
> [root@localhost ~]# umount /mnt/
> [root@localhost ~]# xfs_logprint 128m.xfs|grep nlink|tail -1
> 
> 2.2. Expect result
> nlink 65536
> 
> 2.3. Actual result
> nlink 0
> ---
>  logprint/log_misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 35e926a3..6add28ed 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -444,7 +444,7 @@ xlog_print_trans_inode_core(
>      printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
>  	   ip->di_magic, ip->di_mode, (int)ip->di_version,
>  	   (int)ip->di_format);
> -    printf(_("nlink %hd uid %d gid %d\n"),
> +    printf(_("nlink %" PRIu32 " uid %d gid %d\n"),

*Half* decimal?  LOL, I'd forgotten that even exists.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	   ip->di_nlink, ip->di_uid, ip->di_gid);
>      printf(_("atime 0x%llx mtime 0x%llx ctime 0x%llx\n"),
>  		xlog_extract_dinode_ts(ip->di_atime),
> -- 
> 2.27.0
> 
