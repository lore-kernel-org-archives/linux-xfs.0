Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94070C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 00:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhLKA07 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 19:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345370AbhLKA06 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 19:26:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C33C061714
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 16:23:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E36FB810CC
        for <linux-xfs@vger.kernel.org>; Sat, 11 Dec 2021 00:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27934C341C8;
        Sat, 11 Dec 2021 00:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639182200;
        bh=6m4oRGqaC0Nj0UZYyfDzm4FZaabubq7hAxyqvbj2saQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SKEnivOnGs+nZOaUvBgO2jrR9pxUtlYQYtgc42HJ/MoW+/RYB7o+3d0tqp8NwUI9r
         DwAn3uDASR02/pIWnePGSHb3jkXPTzfcs85ZQQoQmo5TONcxWwmfIj+6X1dNt1ZKhJ
         p35qX6j2+a2NQYaJFWAW5yOzQeBuHDGcVoBPCEOMmfPgSKTrOV92ntqdD6aGHbzmZo
         WgFTLISC6LaP+SIKMm06R2UciBIP0YwWWfrczAGsdM8gbC2HSZkL15WnYqnV65lwIE
         WxHYFwi3PFIzWv6jKeugOC8JMPcfjST5kfjaTZQLzUriNTAQMhJYGE9jQyiXy7BYNo
         IaZpMYGFxgdlA==
Date:   Fri, 10 Dec 2021 16:23:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: don't guess about failure reason in
 phase6
Message-ID: <20211211002319.GD1218082@magnolia>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
 <1639167697-15392-5-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639167697-15392-5-git-send-email-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 02:21:37PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> There are many error messages in phase 6 which say
> "filesystem may be out of space," when in reality the failure could
> have been corruption or some other issue.  Rather than guessing, and
> emitting a confusing and possibly-wrong message, use the existing
> res_failed() for any xfs_trans_alloc failures, and simply print the
> error number in the other cases.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  repair/phase6.c | 30 +++++++++---------------------
>  1 file changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 696a642..df22daa 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1067,9 +1067,7 @@ mv_orphanage(
>  			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
>  						  nres, 0, 0, &tp);
>  			if (err)
> -				do_error(
> -	_("space reservation failed (%d), filesystem may be out of space\n"),
> -					err);
> +				res_failed(err);
>  
>  			libxfs_trans_ijoin(tp, orphanage_ip, 0);
>  			libxfs_trans_ijoin(tp, ino_p, 0);
> @@ -1078,8 +1076,7 @@ mv_orphanage(
>  						ino, nres);
>  			if (err)
>  				do_error(
> -	_("name create failed in %s (%d), filesystem may be out of space\n"),
> -					ORPHANAGE, err);
> +	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
>  
>  			if (irec)
>  				add_inode_ref(irec, ino_offset);
> @@ -1091,8 +1088,7 @@ mv_orphanage(
>  					orphanage_ino, nres);
>  			if (err)
>  				do_error(
> -	_("creation of .. entry failed (%d), filesystem may be out of space\n"),
> -					err);
> +	_("creation of .. entry failed (%d)\n"), err);
>  
>  			inc_nlink(VFS_I(ino_p));
>  			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
> @@ -1104,9 +1100,7 @@ mv_orphanage(
>  			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
>  						  nres, 0, 0, &tp);
>  			if (err)
> -				do_error(
> -	_("space reservation failed (%d), filesystem may be out of space\n"),
> -					err);
> +				res_failed(err);
>  
>  			libxfs_trans_ijoin(tp, orphanage_ip, 0);
>  			libxfs_trans_ijoin(tp, ino_p, 0);
> @@ -1116,8 +1110,7 @@ mv_orphanage(
>  						ino, nres);
>  			if (err)
>  				do_error(
> -	_("name create failed in %s (%d), filesystem may be out of space\n"),
> -					ORPHANAGE, err);
> +	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
>  
>  			if (irec)
>  				add_inode_ref(irec, ino_offset);
> @@ -1135,8 +1128,7 @@ mv_orphanage(
>  						nres);
>  				if (err)
>  					do_error(
> -	_("name replace op failed (%d), filesystem may be out of space\n"),
> -						err);
> +	_("name replace op failed (%d)\n"), err);
>  			}
>  
>  			err = -libxfs_trans_commit(tp);
> @@ -1156,9 +1148,7 @@ mv_orphanage(
>  		err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
>  					  nres, 0, 0, &tp);
>  		if (err)
> -			do_error(
> -	_("space reservation failed (%d), filesystem may be out of space\n"),
> -				err);
> +			res_failed(err);
>  
>  		libxfs_trans_ijoin(tp, orphanage_ip, 0);
>  		libxfs_trans_ijoin(tp, ino_p, 0);
> @@ -1167,8 +1157,7 @@ mv_orphanage(
>  						nres);
>  		if (err)
>  			do_error(
> -	_("name create failed in %s (%d), filesystem may be out of space\n"),
> -				ORPHANAGE, err);
> +	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
>  		ASSERT(err == 0);
>  
>  		set_nlink(VFS_I(ino_p), 1);
> @@ -1351,8 +1340,7 @@ longform_dir2_rebuild(
>  						nres);
>  		if (error) {
>  			do_warn(
> -_("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
> -				ino, error);
> +_("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
>  			goto out_bmap_cancel;
>  		}
>  
> -- 
> 1.8.3.1
> 
