Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F077BC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 16:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiKIQLB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 11:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiKIQKr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 11:10:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C100BFD7
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 08:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E4B7B81F22
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 16:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E1DC433C1;
        Wed,  9 Nov 2022 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668010220;
        bh=eNb7rifIub0/ow+ZWsQn0nEFgg10DX8PqwMvhMvDsuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d/HE5HyRIm6o4cH+0sHEbKZafpixcHfgx+zI8FehJzlp/5WMNXIuksDPk3VXaVSCQ
         8VReV6fcPbCHnNel8fe8xdgWH9NcngQKanT2V67TS7Uyrbq6pEmn1g10ZdcYPYi9F7
         1ojJTzVfl75RKVICTCSOHk25pINRCcoGQ4bODjAAN52ckTFQaSddVGWGu23PiXQimd
         KwqqPU37SUiifYg/+sbQMXcJe2FZvt4dh1XP0bIT/ZqXGMLAyRu4qskLofRLA07RFD
         JKAcKPJ8tOtSo/nIslEKF2oQY5Y6qLmM3CJx8qM+y3Fyn0GSFINw37dBIGebaUrjk9
         0ZGDUTrDsFaRw==
Date:   Wed, 9 Nov 2022 08:10:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Message-ID: <Y2vQ60TRnjEcStXk@magnolia>
References: <166212614879.31305.11337231919093625864.stgit@andromeda>
 <166212621918.31305.17388002689404843538.stgit@andromeda>
 <tVoGmfcAatKg-ouPdfZ7AXjfQoZE56EAH9d7-THujiFxvfw4TrOZ_hgBZFB1NGqDxvyDL6u_oMyBEkSHEi6OWw==@protonmail.internalid>
 <YxJsFQb+MdmeRmak@magnolia>
 <20220905070524.ew6bqxlpn2x4extw@andromeda>
 <20221109112809.d4erwrydzfuh3l22@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109112809.d4erwrydzfuh3l22@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 12:28:09PM +0100, Carlos Maiolino wrote:
> On Mon, Sep 05, 2022 at 09:05:28AM +0200, Carlos Maiolino wrote:
> > On Fri, Sep 02, 2022 at 01:48:21PM -0700, Darrick J. Wong wrote:
> > > On Fri, Sep 02, 2022 at 03:43:39PM +0200, Carlos Maiolino wrote:
> > > > From: Carlos Maiolino <cmaiolino@redhat.com>
> > > >
> > > > Add proper exit error paths to avoid checking all pointers at the current path
> > > >
> > > > Fixes-coverity-id: 1512651
> > > >
> > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > > ---
> > > >  repair/rmap.c |   23 +++++++++++------------
> > > >  1 file changed, 11 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/repair/rmap.c b/repair/rmap.c
> > > > index a7c4b25b1..0253c0c36 100644
> > > > --- a/repair/rmap.c
> > > > +++ b/repair/rmap.c
> > > > @@ -1377,7 +1377,7 @@ check_refcounts(
> > > >  	if (error) {
> > > >  		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
> > > >  				agno);
> > > > -		goto err;
> > > > +		goto err_agf;
> > > 
> > > Shouldn't this       ^^^^^^^ be err_pag, since we're erroring out and
> > > releasing the perag group reference?
> > 
> > At first I named it err_pag, but pag is used here only to read the agf, and when
> > reading agf fail is why we end up reaching this error path, so I thought it
> > would be more specific to name it err_agf.

The kernel error-out label naming convention (AFAICT) is that the label
says what is being cleaned up.  For example, xfs_create():

 out_trans_cancel:
	xfs_trans_cancel(tp);
 out_release_inode:
	/*
	 * Wait until after the current transaction is aborted to finish
	 * the
	 * setup of the inode and release the inode.  This prevents
	 * recursive
	 * transactions and deadlocks from xfs_inactive.
	 */
	if (ip) {
		xfs_finish_inode_setup(ip);
		xfs_irele(ip);
	}
 out_release_dquots:
	xfs_qm_dqrele(udqp);
	xfs_qm_dqrele(gdqp);
	xfs_qm_dqrele(pdqp);

	if (unlock_dp_on_error)
		xfs_iunlock(dp, XFS_ILOCK_EXCL);
	return error;
}

> > > Also ... don't the "if (XXX) free(XXX)" bits take care of all this?
> > > 
> > 
> > Yeah, it does. But that's exactly what coverity is complaining about. We check
> > for a NULL pointer 'after' we dereference it earlier, to be more specific:
> > 
> > ---
> > Type: Dereference before NULL check
> > Null-checking pag suggests that it may be null, but it has already been
> > dereferenced on all paths leading to the check
> > ---
> > 
> > Both patches fix the same issue type.

Eh, I suppose it does get the coding style closer to how things are done
most other places, so it's a good idea.

Also, while you're at it, the btree cursor deletion function has long
accepted negative (and positive) errno as the second argument, so you
can turn it into:

	libxfs_btree_del_cursor(bt_cur, error);

No need for XFS_BTREE_{NO,}ERROR.

> > > (I can't access Coverity any more, so I don't know what's in the
> > > report.)
> > > 
> > > --D
> > > 
> > > >  	}
> 
> Hi Darrick. Do you have any other opinion at this? Or should I consider it a
> no-no and discard those patches?

Sorry, I guess I forgot to reply to you. :(

--D

> Cheers.
> 
> -- 
> Carlos Maiolino
