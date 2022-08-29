Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A31BECAAD2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 14:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiH2Oji (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 10:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiH2Ojh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 10:39:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5977996779
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 07:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB55A60FC1
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 14:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47546C433D6;
        Mon, 29 Aug 2022 14:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661783976;
        bh=SoueINanblTBnvYsLRDi9MiL6xc2uub8tqilNGU0D8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qjr6X2Yq3mVrn3q3k3R0KkAFnVPDEMO+3AWvvVYT7j1tjLG0U/U7tCMS+IPfWSVTQ
         Py+fl9GdjXhbu1FBeKdMfXVY8seaC5puhW226IF7uhmougALMarE3tt2Nj4SmkBN2c
         g9HoW6W+x0BWwGr4cKgXNMVpEjWsBg0Jh/YfZqENDPyPlrhEDk6ya1oPyz5vqVaEHW
         yfZnJIA8s/A8bHQtYfqay//NJyCIz9N/dGVfs8JR4jsfkWNyTHgdefGB9jqqBeaO7U
         r1zMVJ9FacBKVCz5def6qfD5RE0sishosGyP+Xu52AQrOVU7sJ53Jo5VqbNAu/JFGH
         wPFdxPXk3Am5A==
Date:   Mon, 29 Aug 2022 07:39:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Xiaole He <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, Xiaole He <hexiaole@kylinos.cn>
Subject: Re: [PATCH v1] xfs_db: use preferable macro to seek offset for local
 dir3 entry fields
Message-ID: <YwzPpxI4Uta0KreZ@magnolia>
References: <20220829095025.10287-1-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829095025.10287-1-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 29, 2022 at 05:50:25PM +0800, Xiaole He wrote:
> In 'xfsprogs-dev' source:
> 
> /* db/dir2sf.c begin */
>  #define        EOFF(f) bitize(offsetof(xfs_dir2_sf_entry_t, f))
> const field_t   dir2_sf_entry_flds[] = {
>         { "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
> ...
>  #define        E3OFF(f)        bitize(offsetof(xfs_dir2_sf_entry_t, f))
> const field_t   dir3_sf_entry_flds[] = {
>         { "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
> ...
> /* db/dir2sf.c end */
> 
> The macro definitions of 'EOFF' and 'E3OFF' are same, so no matter to
> use either to seek field offset in 'dir3_sf_entry_flds'.
> But it seems the intent of defining 'E3OFF' macro is to be used in
> 'dir3_sf_entry_flds', and 'E3OFF' macro has not been used at any place
> of the 'xfsprogs-dev' source:
> 
> /* command begin */
> $ grep -r E3OFF /path/to/xfsprogs-dev/git/repository/
> ./db/dir2sf.c:#define   E3OFF(f)        bitize(offsetof(xfs_dir2_sf_entry_t, f))
> $
> /* command end */
> 
> Above command shows the 'E3OFF' is only been defined but nerver been
> used, that is weird, so there has reason to suspect using 'EOFF'
> rather than 'E3OFF' in 'dir3_sf_entry_flds' is a typo, this patch fix
> it, there has no logical change in this commit at all.
> 
> Signed-off-by: Xiaole He <hexiaole@kylinos.cn>

Makes sense to me, though it took me a minute to learn to ignore the
other #define EOFFs :/

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/dir2sf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/db/dir2sf.c b/db/dir2sf.c
> index 8165b79b..9f1880dc 100644
> --- a/db/dir2sf.c
> +++ b/db/dir2sf.c
> @@ -246,9 +246,9 @@ const field_t	dir3sf_flds[] = {
>  
>  #define	E3OFF(f)	bitize(offsetof(xfs_dir2_sf_entry_t, f))
>  const field_t	dir3_sf_entry_flds[] = {
> -	{ "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
> -	{ "offset", FLDT_DIR2_SF_OFF, OI(EOFF(offset)), C1, 0, TYP_NONE },
> -	{ "name", FLDT_CHARNS, OI(EOFF(name)), dir2_sf_entry_name_count,
> +	{ "namelen", FLDT_UINT8D, OI(E3OFF(namelen)), C1, 0, TYP_NONE },
> +	{ "offset", FLDT_DIR2_SF_OFF, OI(E3OFF(offset)), C1, 0, TYP_NONE },
> +	{ "name", FLDT_CHARNS, OI(E3OFF(name)), dir2_sf_entry_name_count,
>  	  FLD_COUNT, TYP_NONE },
>  	{ "inumber", FLDT_DIR2_INOU, dir3_sf_entry_inumber_offset, C1,
>  	  FLD_OFFSET, TYP_NONE },
> -- 
> 2.27.0
> 
