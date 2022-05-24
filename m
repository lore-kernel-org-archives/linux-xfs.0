Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391B1C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 21:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbiEXVGu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 17:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240614AbiEXVGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 17:06:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4369A13E33
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 14:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3751B81722
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 21:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8E5C34100;
        Tue, 24 May 2022 21:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653426405;
        bh=m6sIQ3xpdh9AK2f+qfvHtsjKB1Ho/LKX7XX6JMuF980=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a3T99ZyaboYCNkHYUSDWkSjdzUgokNrKDm/2wmDBhWWK/HNL/d2b3/uRBBJoFsEKt
         BpXldWSKEItXNpi9H640TJK7UjYO/B315zp/LC4smINCu+QTuoHD+qyuT8N3aANSMI
         kSnalMxpn7G7iFUKaAHHTVGizi3lHnZSFNyj/sUDbWphe3MN/+6Ef2gyYbwWLsO2w7
         aOTxmJ6bU/GhV55ptCn1fl3u9/KVKDfcUpB9oHUJUsQZi/LLMkpWWxL284A1CPYrT2
         Un3ymqMA6PjEmO4KhFAyNtRldWoH2ZnK0MhChgsFVSPktGanYVSZ6kSeQlxfYPh4LB
         RtQc5yz/WIv7w==
Date:   Tue, 24 May 2022 14:06:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Fix memory leak
Message-ID: <Yo1I5N1IMXdHKUcw@magnolia>
References: <20220524204040.954138-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524204040.954138-1-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 10:40:40PM +0200, Pavel Reichl wrote:
> 'value' is allocated by strup() in getstr(). It

Nit: strdup, not strup.

> needs to be freed as we do not keep any permanent
> reference to it.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 01d2e8ca..a37d6848 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1714,6 +1714,7 @@ naming_opts_parser(
>  		} else {
>  			cli->sb_feat.dir_version = getnum(value, opts, subopt);
>  		}
> +		free((char *)value);
>  		break;
>  	case N_FTYPE:
>  		cli->sb_feat.dirftype = getnum(value, opts, subopt);
> -- 
> 2.36.1
> 
