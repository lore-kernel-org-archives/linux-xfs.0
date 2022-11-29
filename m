Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E9AC4321E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 14:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiK2OUv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 09:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiK2OUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 09:20:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1328A663FB
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 06:18:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95B9A61769
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413FCC433D6;
        Tue, 29 Nov 2022 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669731506;
        bh=T089HX5hZ3nsqDfqnJjTww/jAzqNCxx/3E3BR5Rrw68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QxQ/l73dIx4Hm+GGvfNh3f7jfnniWMFp9q6S6Yp02UaI+9czIUJzbXIzzu+OTvVbp
         1l74CpTfKkqZSkAqasRXtn3kLWNHrfmE5sGdphhDIoLLl/+5mjQCdMRCj+PoRXPqzL
         52FliUUCN0BcsdtLOvKSyI1Bmr/P2MZy5IX8CWmlIJByqRaU6hXAK7IClOLCe7z5RI
         /bJAkPhDlzRVdHkt0DpJ5KChmhkJVbRUYW1JjvA9U2XMjmpOQ6fpkecKAtWX2xgHqf
         BXDox17apHt1UX2SoEmZyxQppMZOIVRn4YU3UbcBbGl+epT/k8ayI3sS2oIpmvsssO
         yoEVG3kHV7BNQ==
Date:   Tue, 29 Nov 2022 15:18:21 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Message-ID: <20221129141821.4goi2odggvztefhq@andromeda>
References: <20221128131434.21496-1-cem@kernel.org>
 <20221128131434.21496-2-cem@kernel.org>
 <0NyqEHx7QX5M7O3PkRWy9sATHt9hJPj8dbnNIMJyNpqeq9aoBrZvkghW9BWkoENYiKkmi-Yg3IBf-l_G4jUy8w==@protonmail.internalid>
 <Y4UxpPgxbmOi/T9/@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4UxpPgxbmOi/T9/@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2022 at 02:09:40PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 28, 2022 at 02:14:33PM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cmaiolino@redhat.com>
> >
> > Add proper exit error paths to avoid checking all pointers at the current path
> >
> > Fixes-coverity-id: 1512651
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > V2:
> > 	- Rename error label from err_agf to err_pag
> > 	- pass error directly to libxfs_btree_del_cursor() without
> > 	  using ternary operator
> >
> >  repair/rmap.c | 22 ++++++++++------------
> >  1 file changed, 10 insertions(+), 12 deletions(-)
> >
> > diff --git a/repair/rmap.c b/repair/rmap.c
> > index 2c809fd4f..e76a8f611 100644
> > --- a/repair/rmap.c
> > +++ b/repair/rmap.c
> > @@ -1379,7 +1379,7 @@ check_refcounts(
> >  	if (error) {
> >  		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
> >  				agno);
> > -		goto err;
> > +		goto err_pag;
> >  	}
> >
> >  	/* Leave the per-ag data "uninitialized" since we rewrite it later */
> > @@ -1388,7 +1388,7 @@ check_refcounts(
> >  	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
> >  	if (!bt_cur) {
> >  		do_warn(_("Not enough memory to check refcount data.\n"));
> > -		goto err;
> > +		goto err_bt_cur;
> >  	}
> >
> >  	rl_rec = pop_slab_cursor(rl_cur);
> > @@ -1401,7 +1401,7 @@ check_refcounts(
> >  			do_warn(
> >  _("Could not read reference count record for (%u/%u).\n"),
> >  					agno, rl_rec->rc_startblock);
> > -			goto err;
> > +			goto err_loop;
> >  		}
> >  		if (!have) {
> >  			do_warn(
> > @@ -1416,7 +1416,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
> >  			do_warn(
> >  _("Could not read reference count record for (%u/%u).\n"),
> >  					agno, rl_rec->rc_startblock);
> > -			goto err;
> > +			goto err_loop;
> >  		}
> >  		if (!i) {
> >  			do_warn(
> > @@ -1446,14 +1446,12 @@ next_loop:
> >  		rl_rec = pop_slab_cursor(rl_cur);
> >  	}
> >
> > -err:
> > -	if (bt_cur)
> > -		libxfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
> > -							XFS_BTREE_NOERROR);
> > -	if (pag)
> > -		libxfs_perag_put(pag);
> > -	if (agbp)
> > -		libxfs_buf_relse(agbp);
> > +err_loop:
> > +	libxfs_btree_del_cursor(bt_cur, error);
> > +err_bt_cur:
> > +	libxfs_buf_relse(agbp);
> > +err_pag:
> > +	libxfs_perag_put(pag);
> 
> So I see that you fixed one of the labels so that err_pag jumps to
> releasing the perag pointer, but it's still the case that err_bt_cur
> frees the AGF buffer, not the btree cursor; and that err_loop actually
> frees the btree cursor.

Totally true. I focused on your comments regarding err_pag, and forgot to review
the remaining labels. I'll fix it and send a V3.

Thanks for the review.

> 
> --D
> 
> >  	free_slab_cursor(&rl_cur);
> >  }
> >
> > --
> > 2.30.2
> >

-- 
Carlos Maiolino
