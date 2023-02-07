Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800F0C636D3
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Feb 2023 17:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjBGRkC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Feb 2023 12:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbjBGRjx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2023 12:39:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F952D79
        for <linux-xfs@vger.kernel.org>; Tue,  7 Feb 2023 09:39:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B2CAB81A64
        for <linux-xfs@vger.kernel.org>; Tue,  7 Feb 2023 17:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8500C433EF;
        Tue,  7 Feb 2023 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675791590;
        bh=OrFy1txPnbnrqDe43sSwLyZB8RZSiHGVP0fFIvXFXkw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qPmo2XmkQ5b5huGA1jHkUu/bTuDyJ8iH9fVgBoQbRR127mIFsyZgeNs8GrLGOYN1m
         3fMZKzuRb0Tjvu5xibHoyVruAOmundiOibe/Y1FTgra3taMUJxQB7QMIidlJZQDpfb
         WWGckymeBPEgyqIvUPN856JeOxbGF0Y6fA2+gLkrt55dxExqDMEsNx3XIL6f5GkkQQ
         1Ojqr4rfhbFepAiGKWnZQ/o9zULH6t9oyJSpQrNe61VsyXlSAQpCqlZTfE4gA+Xdg1
         L22KRhJQViiUAV5KEABy10auEIvSwfKS+MaS8clCuXnfRDE2G7LeJw9mBCWftP/pk0
         nnMnko51kHehg==
Date:   Tue, 7 Feb 2023 09:39:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs_db: make flist_find_ftyp() to check for field
 existance on disk
Message-ID: <Y+KM5b+VOYZAsJkI@magnolia>
References: <20230201172146.1874205-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201172146.1874205-1-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 06:21:47PM +0100, Andrey Albershteyn wrote:
> flist_find_ftyp() searches for the field of the requested type. The
> first found field/path is returned. However, this doesn't work when
> there are multiple fields of the same type. For example, attr3 type
> have a few CRC fields. Leaf block (xfs_attr_leaf_hdr ->
> xfs_da3_blkinfo) and remote value block (xfs_attr3_rmt_hdr) both
> have CRC but goes under attr3 type. This causes 'crc' command to be
> unable to find CRC field when we are at remote attribute block as it
> tries to use leaf block CRC path:
> 
> 	$ dd if=/dev/zero bs=4k count=10 | tr '\000' '1' > test.img
> 	$ touch test.file
> 	$ setfattr -n user.bigattr -v "$(cat test.img)" test.file
> 
> 	$ # CRC of the leaf block
> 	$ xfs_db -r -x /dev/sda5 -c 'inode 132' -c 'ablock 0' -c 'crc'
> 	Verifying CRC:
> 	hdr.info.crc = 0x102b5cbf (correct)
> 
> 	$ # CRC of the remote value block
> 	$ xfs_db -r -x /dev/sda5 -c 'inode 132' -c 'ablock 1' -c 'crc'
> 	field info not found
> 	parsing error
> 
> Solve this by making flist_find_ftyp() to also check that field in
> question have non-zero count (exist at the current block).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  db/crc.c   |  2 +-
>  db/flist.c | 13 ++++++++++---
>  db/flist.h |  3 ++-
>  3 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/db/crc.c b/db/crc.c
> index 7428b916..1c73f980 100644
> --- a/db/crc.c
> +++ b/db/crc.c
> @@ -114,7 +114,7 @@ crc_f(
>  	}
>  
>  	/* Search for a CRC field */
> -	fl = flist_find_ftyp(fields, FLDT_CRC);
> +	fl = flist_find_ftyp(fields, FLDT_CRC, iocur_top->data, 0);
>  	if (!fl) {
>  		dbprintf(_("No CRC field found for type %s\n"), cur_typ->name);
>  		return 0;
> diff --git a/db/flist.c b/db/flist.c
> index 0bb6474c..d275abfe 100644
> --- a/db/flist.c
> +++ b/db/flist.c
> @@ -408,11 +408,14 @@ flist_split(
>   */
>  flist_t *
>  flist_find_ftyp(
> -	const field_t *fields,
> -	fldt_t	type)
> +	const field_t	*fields,
> +	fldt_t		type,
> +	void		*obj,
> +	int		startoff)
>  {
>  	flist_t	*fl;
>  	const field_t	*f;
> +	int		count;
>  	const ftattr_t  *fa;
>  
>  	for (f = fields; f->name; f++) {
> @@ -420,11 +423,15 @@ flist_find_ftyp(
>  		fl->fld = f;
>  		if (f->ftyp == type)
>  			return fl;
> +		count = fcount(f, obj, startoff);
> +		if (!count) {
> +			continue;
> +		}

Minor nit: no need for curly braces here.

With that cleaned up,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		fa = &ftattrtab[f->ftyp];
>  		if (fa->subfld) {
>  			flist_t *nfl;
>  
> -			nfl = flist_find_ftyp(fa->subfld, type);
> +			nfl = flist_find_ftyp(fa->subfld, type, obj, startoff);
>  			if (nfl) {
>  				fl->child = nfl;
>  				return fl;
> diff --git a/db/flist.h b/db/flist.h
> index f0772378..e327a360 100644
> --- a/db/flist.h
> +++ b/db/flist.h
> @@ -38,4 +38,5 @@ extern int	flist_parse(const struct field *fields, flist_t *fl, void *obj,
>  			    int startoff);
>  extern void	flist_print(flist_t *fl);
>  extern flist_t	*flist_scan(char *name);
> -extern flist_t	*flist_find_ftyp(const field_t *fields, fldt_t  type);
> +extern flist_t	*flist_find_ftyp(const field_t *fields, fldt_t  type, void *obj,
> +		int startoff);
> -- 
> 2.31.1
> 
