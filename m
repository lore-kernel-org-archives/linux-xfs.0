Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D67C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 10:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbjFFK6d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 06:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236967AbjFFK51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 06:57:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D491F10C0
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 03:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69FA660B82
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 10:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A40C433EF;
        Tue,  6 Jun 2023 10:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686049044;
        bh=IeIuPA/4Q+NO7UKZFKzQ6jSvQt/NTwBPeJuiLkck1Wc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mXhwLuvh6PjGV6fAF2cSdggre09szhbq37159SZPfCCpLOFahgOqUkkXENrsPGkDc
         mYZIZvhhhvqczTvYQxqeBpNVj/wK+piuAkJ8jRKdFvwqMA9eat01zmSVYS7RZiaN7i
         ZAwU4Nf70nckrg2z/7cQBKcXSAyBUSlOnDuteSd4hy2v8huJ45jAZKknAO6NuYa7Bm
         NThC7XXK8mRCc+/tBpDmyDZuQSZIU5iKDc7W3TMeFgSIeR6G+v6SXQ2ytafTBxOoHu
         vu0ngI9JB2lCBo3qGHO0jKPrnZwAQyxiPcXN9L1Jfk9jt6MRmfDYMnJh4T5+bRb8Fw
         vnsua1OjIcQaQ==
Date:   Tue, 6 Jun 2023 12:57:20 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_repair: fix messaging when shortform_dir2_junk
 is called
Message-ID: <20230606105720.3tue7uqjiupokzdn@andromeda>
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
 <sjgLaa1tLsePpDP72TT3pcyEevNxw0MZUQI936mx1MBpKss1r5bPlXGIFEbF6Xg9r36TWeLgYeyIYarAfLhzzA==@protonmail.internalid>
 <168597947041.1226461.4921645137801552482.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597947041.1226461.4921645137801552482.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:37:50AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This function is called when we've decide to junk a shortform directory
> entry.  This is obviously corruption of some kind, so we should always
> say something, particularly if we're in !verbose repair mode.
> Otherwise, if we're in non-verbose repair mode, we print things like:
> 
> entry "FOO" in shortform directory XXX references non-existent inode YYY
> 
> Without telling the sysadmin that we're removing the dirent.
> 
> Fixes: aaca101b1ae ("xfs_repair: add support for validating dirent ftype field")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/phase6.c |   17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 39470185ea4..a457429b3c6 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2441,10 +2441,7 @@ shortform_dir2_junk(
>  	 */
>  	(*index)--;
> 
> -	if (verbose)
> -		do_warn(_("junking entry\n"));
> -	else
> -		do_warn("\n");
> +	do_warn(_("junking entry\n"));
>  	return sfep;
>  }
> 
> @@ -2593,7 +2590,7 @@ shortform_dir2_entry_check(
> 
>  		if (irec == NULL)  {
>  			do_warn(
> -	_("entry \"%s\" in shortform directory %" PRIu64 " references non-existent inode %" PRIu64 "\n"),
> +	_("entry \"%s\" in shortform directory %" PRIu64 " references non-existent inode %" PRIu64 ", "),
>  				fname, ino, lino);
>  			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
>  						&max_size, &i, &bytes_deleted,
> @@ -2610,7 +2607,7 @@ shortform_dir2_entry_check(
>  		 */
>  		if (is_inode_free(irec, ino_offset))  {
>  			do_warn(
> -	_("entry \"%s\" in shortform directory inode %" PRIu64 " points to free inode %" PRIu64 "\n"),
> +	_("entry \"%s\" in shortform directory inode %" PRIu64 " points to free inode %" PRIu64 ", "),
>  				fname, ino, lino);
>  			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
>  						&max_size, &i, &bytes_deleted,
> @@ -2626,7 +2623,7 @@ shortform_dir2_entry_check(
>  			 */
>  			if (!inode_isadir(irec, ino_offset)) {
>  				do_warn(
> -	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
> +	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
>  					ORPHANAGE, lino, ino);
>  				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
>  						lino, &max_size, &i,
> @@ -2648,7 +2645,7 @@ shortform_dir2_entry_check(
>  				lino, sfep->namelen, sfep->name,
>  				libxfs_dir2_sf_get_ftype(mp, sfep))) {
>  			do_warn(
> -_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
> +_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
>  				fname, lino, ino);
>  			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
>  						&max_size, &i, &bytes_deleted,
> @@ -2673,7 +2670,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  			if (is_inode_reached(irec, ino_offset))  {
>  				do_warn(
>  	_("entry \"%s\" in directory inode %" PRIu64
> -	  " references already connected inode %" PRIu64 ".\n"),
> +	  " references already connected inode %" PRIu64 ", "),
>  					fname, ino, lino);
>  				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
>  						lino, &max_size, &i,
> @@ -2697,7 +2694,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  				do_warn(
>  	_("entry \"%s\" in directory inode %" PRIu64
>  	  " not consistent with .. value (%" PRIu64
> -	  ") in inode %" PRIu64 ",\n"),
> +	  ") in inode %" PRIu64 ", "),
>  					fname, ino, parent, lino);
>  				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
>  						lino, &max_size, &i,
> 
