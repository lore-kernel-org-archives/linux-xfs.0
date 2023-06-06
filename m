Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4EAC7EE31
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 10:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjFFK5r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 06:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjFFK5K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 06:57:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD6CE5B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 03:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F31462C20
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 10:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13382C433EF;
        Tue,  6 Jun 2023 10:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686048982;
        bh=ndYFhBlqihAraltA48gMGN1j0mWybN6OwGD6JVqMO8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SILvuwdF9tImKF5R4CsKBFXt8EO+q4Ch5C1JJDQXoIaDm0jZYGEi2+ueevqHTy7eG
         Dgw7mwmlELmG5UcjtbKf3Sbe5RfbaFtm8TZ5J4Zknw7Why2Yd4PGuPTjyFtwzA2fWa
         0hBAqIkamsv17PuE3w0zO7aAITE3H5ljarOTkzWZTxqHpx3gyNzsRLO2fMxjJ6TcEQ
         wM+LqR6NU7faoPtPc6eqj6R8HaFMJQK2bD3gSVyuji3lwZawLbNOsy/CKZ1O+KiS41
         ME7/y0R8xLrohuQdRYMJfztbez0yoTCPjprJ0aEpoyW1fFM/4zF0resQhjG7/FE6sv
         va5L50vzBHNGQ==
Date:   Tue, 6 Jun 2023 12:56:18 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_repair: don't log inode problems without
 printing resolution
Message-ID: <20230606105618.pvc4w6ozdwutcxiz@andromeda>
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
 <twgLVMvT7uwhRz-TG8L8fM7FzrDxtWHbk4e2Rym_xEW6s1ftuL3ksizfvWi5PQtrUwLTCC6SRJBRGtAskZ6-Pg==@protonmail.internalid>
 <168597946479.1226461.5013927667528240327.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597946479.1226461.5013927667528240327.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:37:44AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we're running in repair mode without the verbose flag, I see a bunch
> of stuff like this:
> 
> entry "FOO" in directory inode XXX points to non-existent inode YYY
> 
> This output is less than helpful, since it doesn't tell us that repair
> is actually fixing the problem.  We're fixing a corruption, so we should
> always say that we're going to fix it.
> 
> Fixes: 6c39a3cbda3 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/phase6.c |   23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 37573b4301b..39470185ea4 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1176,13 +1176,10 @@ entry_junked(
>  	xfs_ino_t	ino2)
>  {
>  	do_warn(msg, iname, ino1, ino2);
> -	if (!no_modify) {
> -		if (verbose)
> -			do_warn(_(", marking entry to be junked\n"));
> -		else
> -			do_warn("\n");
> -	} else
> -		do_warn(_(", would junk entry\n"));
> +	if (!no_modify)
> +		do_warn(_("junking entry\n"));
> +	else
> +		do_warn(_("would junk entry\n"));
>  	return !no_modify;
>  }
> 
> @@ -1682,7 +1679,7 @@ longform_dir2_entry_check_data(
>  		if (irec == NULL)  {
>  			nbad++;
>  			if (entry_junked(
> -	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ""),
> +	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ", "),
>  					fname, ip->i_ino, inum)) {
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
> @@ -1699,7 +1696,7 @@ longform_dir2_entry_check_data(
>  		if (is_inode_free(irec, ino_offset))  {
>  			nbad++;
>  			if (entry_junked(
> -	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64),
> +	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64 ", "),
>  					fname, ip->i_ino, inum)) {
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
> @@ -1717,7 +1714,7 @@ longform_dir2_entry_check_data(
>  			if (!inode_isadir(irec, ino_offset)) {
>  				nbad++;
>  				if (entry_junked(
> -	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
> +	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
>  						ORPHANAGE, inum, ip->i_ino)) {
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
> @@ -1739,7 +1736,7 @@ longform_dir2_entry_check_data(
>  				dep->name, libxfs_dir2_data_get_ftype(mp, dep))) {
>  			nbad++;
>  			if (entry_junked(
> -	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
> +	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
>  					fname, inum, ip->i_ino)) {
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
> @@ -1770,7 +1767,7 @@ longform_dir2_entry_check_data(
>  				/* ".." should be in the first block */
>  				nbad++;
>  				if (entry_junked(
> -	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
> +	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block, "), fname,
>  						inum, ip->i_ino)) {
>  					dir_hash_junkit(hashtab, addr);
>  					dep->name[0] = '/';
> @@ -1803,7 +1800,7 @@ longform_dir2_entry_check_data(
>  				/* "." should be the first entry */
>  				nbad++;
>  				if (entry_junked(
> -	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
> +	_("entry \"%s\" in dir %" PRIu64 " is not the first entry, "),
>  						fname, inum, ip->i_ino)) {
>  					dir_hash_junkit(hashtab, addr);
>  					dep->name[0] = '/';
> 
