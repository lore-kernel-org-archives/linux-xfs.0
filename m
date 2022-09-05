Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F8FECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Sep 2022 07:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiIEHFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 03:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbiIEHF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Sep 2022 03:05:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F33D31225
        for <linux-xfs@vger.kernel.org>; Mon,  5 Sep 2022 00:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9C2461113
        for <linux-xfs@vger.kernel.org>; Mon,  5 Sep 2022 07:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77629C433D6;
        Mon,  5 Sep 2022 07:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662361528;
        bh=mJSV8Aln/wfly6x4clNvioI3is0kevVumMzp4Wcrhgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wx1r9AT1BPAC1ALAAXizAaD3qF7QJC5+Di2Wur2wzVuWXH9LS0a/PVNKjCmXckinQ
         w8X6eL5qc6nsar+/h5bkmAt4cwLWkGPHLeRM7AYrzutEjSanV2d6pBsPbp8D1vpXzm
         neuOfHb1S+Mfxgdd6aqxByUmbjYvlq1WWZ2rRJvzMk1ojAEU2VLhmNYveoAqgWPHIK
         1lLqwDYCuQtZPMBmoGqSx/onl+ohb6AQ4UcxRGO74OmQcRnUoFoGSZGEprbulYvvq+
         C/0ky+NfDAgYPriSqRJtwJ6GJiL+4ctTjJ41K8f3dGdbhMLyOoOVYr9bLStaYwn2T7
         Br9gklcSzLOQw==
Date:   Mon, 5 Sep 2022 09:05:24 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Message-ID: <20220905070524.ew6bqxlpn2x4extw@andromeda>
References: <166212614879.31305.11337231919093625864.stgit@andromeda>
 <166212621918.31305.17388002689404843538.stgit@andromeda>
 <tVoGmfcAatKg-ouPdfZ7AXjfQoZE56EAH9d7-THujiFxvfw4TrOZ_hgBZFB1NGqDxvyDL6u_oMyBEkSHEi6OWw==@protonmail.internalid>
 <YxJsFQb+MdmeRmak@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxJsFQb+MdmeRmak@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 02, 2022 at 01:48:21PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 02, 2022 at 03:43:39PM +0200, Carlos Maiolino wrote:
> > From: Carlos Maiolino <cmaiolino@redhat.com>
> >
> > Add proper exit error paths to avoid checking all pointers at the current path
> >
> > Fixes-coverity-id: 1512651
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  repair/rmap.c |   23 +++++++++++------------
> >  1 file changed, 11 insertions(+), 12 deletions(-)
> >
> > diff --git a/repair/rmap.c b/repair/rmap.c
> > index a7c4b25b1..0253c0c36 100644
> > --- a/repair/rmap.c
> > +++ b/repair/rmap.c
> > @@ -1377,7 +1377,7 @@ check_refcounts(
> >  	if (error) {
> >  		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
> >  				agno);
> > -		goto err;
> > +		goto err_agf;
> 
> Shouldn't this       ^^^^^^^ be err_pag, since we're erroring out and
> releasing the perag group reference?

At first I named it err_pag, but pag is used here only to read the agf, and when
reading agf fail is why we end up reaching this error path, so I thought it
would be more specific to name it err_agf.
> 
> Also ... don't the "if (XXX) free(XXX)" bits take care of all this?
> 

Yeah, it does. But that's exactly what coverity is complaining about. We check
for a NULL pointer 'after' we dereference it earlier, to be more specific:

---
Type: Dereference before NULL check
Null-checking pag suggests that it may be null, but it has already been
dereferenced on all paths leading to the check
---

Both patches fix the same issue type.

> (I can't access Coverity any more, so I don't know what's in the
> report.)
> 
> --D
> 
> >  	}
> >
> >  	/* Leave the per-ag data "uninitialized" since we rewrite it later */
> > @@ -1386,7 +1386,7 @@ check_refcounts(
> >  	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
> >  	if (!bt_cur) {
> >  		do_warn(_("Not enough memory to check refcount data.\n"));
> > -		goto err;
> > +		goto err_bt_cur;
> >  	}
> >
> >  	rl_rec = pop_slab_cursor(rl_cur);
> > @@ -1398,7 +1398,7 @@ check_refcounts(
> >  			do_warn(
> >  _("Could not read reference count record for (%u/%u).\n"),
> >  					agno, rl_rec->rc_startblock);
> > -			goto err;
> > +			goto err_loop;
> >  		}
> >  		if (!have) {
> >  			do_warn(
> > @@ -1413,7 +1413,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
> >  			do_warn(
> >  _("Could not read reference count record for (%u/%u).\n"),
> >  					agno, rl_rec->rc_startblock);
> > -			goto err;
> > +			goto err_loop;
> >  		}
> >  		if (!i) {
> >  			do_warn(
> > @@ -1436,14 +1436,13 @@ next_loop:
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
> > +	libxfs_btree_del_cursor(bt_cur, error ?
> > +				XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> > +err_bt_cur:
> > +	libxfs_buf_relse(agbp);
> > +err_agf:
> > +	libxfs_perag_put(pag);
> >  	free_slab_cursor(&rl_cur);
> >  }
> >
> >

-- 
Carlos Maiolino
