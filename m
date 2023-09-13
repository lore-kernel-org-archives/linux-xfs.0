Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622C0EDEC50
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 13:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjIMNCu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 09:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjIMNCu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 09:02:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9FB19AF
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 06:02:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0EAC433C8;
        Wed, 13 Sep 2023 13:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694610165;
        bh=PeOUWkZEwD11NGKrxpyc7xpkDNjtsUAFRRV/xaooLc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WjOkGqk60VshQILi/GSOid7myW6Ozs+lAjkI2UA7TYqMvkFkUpnnl3Yxtflsoor/q
         GeUx2ebiHcfG+h1y8p+zLjdQaGJuO6zbVW+sHKTMmH4zDu0j6zIy6WrCHZFrgz/TGW
         raKR9W6Y9ljQsLGMV4P7wPOnb1f65XAKY4zJHsY3mCJnsZ67P2LYthnOgbRXA4Uy8n
         7y8Ex/tr9znYipw2PH37jJUo7+Yuw+ndkzpDl99+rJRx/Gpd2Ud6BTcwD6b6cXAD3E
         dk/gKqIcMDq1+ho3GodF52vDoYpXU5YHOXp7KOPC65ONnCEDKrYCtjg3+oLIcUv7Dd
         ZS7TONggbgG1Q==
Date:   Wed, 13 Sep 2023 15:02:42 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs_repair: set aformat and anextents correctly when
 clearing the attr fork
Message-ID: <20230913130242.ysq5b6hvqe5dehfb@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <w3T3skdhB6ig90SVQ8Q4MioBjk9lUH2K6uvsYLKKEgAf89O2SctP_G3ECpSBT-EI2W4cKWp3xmv-Mo-AaD3IyA==@protonmail.internalid>
 <169454760445.3539425.1849980383287926875.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454760445.3539425.1849980383287926875.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:40:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ever since commit b42db0860e130 ("xfs: enhance dinode verifier"), we've
> required that inodes with zero di_forkoff must also have di_aformat ==
> EXTENTS and di_naextents == 0.  clear_dinode_attr actually does this,
> but then both callers inexplicably set di_format = LOCAL.  That in turn
> causes a verifier failure the next time the xattrs of that file are
> read by the kernel.  Get rid of the bogus field write.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/dinode.c |    2 --
>  1 file changed, 2 deletions(-)
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index e534a01b500..c10dd1fa322 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2078,7 +2078,6 @@ process_inode_attr_fork(
>  		if (!no_modify)  {
>  			do_warn(_(", clearing attr fork\n"));
>  			*dirty += clear_dinode_attr(mp, dino, lino);
> -			dino->di_aformat = XFS_DINODE_FMT_LOCAL;
>  			ASSERT(*dirty > 0);
>  		} else  {
>  			do_warn(_(", would clear attr fork\n"));
> @@ -2135,7 +2134,6 @@ process_inode_attr_fork(
>  			/* clear attributes if not done already */
>  			if (!no_modify)  {
>  				*dirty += clear_dinode_attr(mp, dino, lino);
> -				dino->di_aformat = XFS_DINODE_FMT_LOCAL;
>  			} else  {
>  				do_warn(_("would clear attr fork\n"));
>  			}
> 
