Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A4DC77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 11:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjFFLCO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 07:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbjFFLBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 07:01:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B6E10FC
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 03:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1728A60B82
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 10:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B031C433D2;
        Tue,  6 Jun 2023 10:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686049148;
        bh=GiJ/ETYgooxRIcqjs1tTC8sPbiizPw2T2hQzQBPvWtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FWJEbLAnKMkCrwZHMSe2oXTnUz9Z9dc+SejuAp8bjO0z3keU46HA/FOHmliR8ebHj
         tg5cZJqd0UYHifISJfvjIpOc3EFiGvhK1qcJ9mLN0danLmzfHLYWYKslIt5j84Jmjf
         TnCRQxpphoidWZGv/ySuv2OV8n/DAFhHBfb3JSJ0rA6whPxUpZ/kBHT9j1zL+W/FsA
         4fdliAmilsmqFZSnRH/Vk/kQcrycFSiMDBEsEXM4WJKl24lAx+s1I/5wC3q1Gde/14
         Flc148xe+0IFFUOxuJ8L6HPHDKWh3RG/4zv2lGQyi62nnxOXutL2Vqo4aGcZ5zJhcz
         FLGlGVsPT/dzw==
Date:   Tue, 6 Jun 2023 12:59:04 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_repair: fix messaging in
 longform_dir2_entry_check_data
Message-ID: <20230606105904.6ca5wm6p75q3endb@andromeda>
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
 <qgrc4Chg_YGTiGIGXMeZt0KFK7JtOEB5kpR7njmDTEIZuBUgmRKnpSPYOUmcOq9-YegX00QWatpJfUSEPaZqTg==@protonmail.internalid>
 <168597947599.1226461.6500396961278469460.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597947599.1226461.6500396961278469460.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:37:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always log when we're junking a dirent from a non-shortform directory,
> because we're fixing corruptions.  Even if we're in !verbose repair
> mode.  Otherwise, we print things like:
> 
> entry "FOO" in dir inode XXX inconsistent with .. value (YYY) in ino ZZZ
> 
> Without telling the user that we're clearing the entry.
> 
> Fixes: 6c39a3cbda3 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/phase6.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index a457429b3c6..3870c5c933a 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1883,8 +1883,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
>  				dir_hash_junkit(hashtab, addr);
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
> -				if (verbose)
> -					do_warn(
> +				do_warn(
>  					_("\twill clear entry \"%s\"\n"),
>  						fname);
>  			} else  {
> 
