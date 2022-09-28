Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7356EC04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 15:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbiI1PZm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiI1PY6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 11:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951455D11B
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 08:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 332F961EE5
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 15:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C04BC4347C;
        Wed, 28 Sep 2022 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664378656;
        bh=94Dpnmr3WBNYJFDhDAWi+CNFqgLqDnMYpcVIoh3mQyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e2FlgjyuVnSoeihd6ndQltDZtt7HXcsp/jolSlX3BHDqzb6GfFOdULtC0qTCg3rFF
         TN6Ew2y33U5iKwe9huc68q2TyvJszMVask/czSRjhN61XLgdA0gz37NMIEoahW84//
         irWRqSCWeXIwo63Po7yTkP3DfsSeJqA6xpizUvDk64xp0mqGUKCCf5DPsG0au0vxDt
         OE0Gv1wkOwxQ1XxfIiA883+qQbuqFrV9czgv96D3/1e1jorISWdvDkligKv8TDrn1w
         TBsqfqIRTvBFiF5ADQiqLP7YItVol0fOURj/GZuX/lXUBMJ0IuTqhvcJDcFOcX9Q3t
         rXDnJ/LsgMjDQ==
Date:   Wed, 28 Sep 2022 08:24:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfsrestore: untangle inventory unpacking logic
Message-ID: <YzRnIKSjxuDEcG8V@magnolia>
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-4-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928055307.79341-4-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 28, 2022 at 03:53:07PM +1000, Donald Douwsma wrote:
> stobj_unpack_sessinfo returns bool_t, fix logic in pi_addfile so errors
> can be properly reported.
> 
> signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

  ^ Needs correct capitalisation.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  restore/content.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/restore/content.c b/restore/content.c
> index b3999f9..04b6f81 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -5463,17 +5463,14 @@ pi_addfile(Media_t *Mediap,
>  			 * desc.
>  			 */
>  			sessp = 0;
> -			if (!buflen) {
> -				ok = BOOL_FALSE;
> -			} else {
> -			    /* extract the session information from the buffer */
> -			    if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
> -				ok = BOOL_FALSE;
> -			    } else {
> +			ok = BOOL_FALSE;
> +			/* extract the session information from the buffer */
> +			if (buflen &&
> +			    stobj_unpack_sessinfo(bufp, buflen, &sessinfo)) {
>  				stobj_convert_sessinfo(&sessp, &sessinfo);
>  				ok = BOOL_TRUE;
> -			    }
>  			}
> +
>  			if (!ok || !sessp) {
>  				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
>  				      "on-media session "
> -- 
> 2.31.1
> 
