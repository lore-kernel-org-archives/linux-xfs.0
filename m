Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA42FEB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 04:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjFTE1e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 00:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjFTE1d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 00:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA3510C7
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 21:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6CAF60F8F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 04:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EA9C433C0;
        Tue, 20 Jun 2023 04:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687235251;
        bh=lBkm8Ce0oPDwwDPfhHRM6wT/CW4CUKVEtCFkdzzeOJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nFJOoCjL2ic/TN/utu93kUArhoK9sT+nvFz8mEohA6FlSAFbR1seoLq17zMEh1mMO
         dIxj2IlRHd7VwLioDFSoYAgd5nwgR1Otvf6RltuEXeIj38QCgOqBgKrqtgcGmmeEkd
         TMh0A/rRk4iqQZJUOhJfSpAo64mYhDwpQM3pKnHa31ObW1c4UIjjUyMPovsfp9j4vE
         U7IC7tMKToKI7vLD7sbjV6m1HQV+HL2z4YTinTi+9/zxpJxaRs4DGxDMHEudLSe+uE
         MmiTaAl7CK6uuL5i4HWcpwY0u49m0n7k6AB+0q1i0x51UOOaOk3LPDiLAvVnVV3kbj
         HFk2yR3Ta+gZw==
Date:   Mon, 19 Jun 2023 21:27:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: use deferred frees to reap old btree blocks
Message-ID: <20230620042731.GD11467@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055689.3728180.5922242663769047903.stgit@frogsfrogsfrogs>
 <ZJEYQYaYKjO/GP9h@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJEYQYaYKjO/GP9h@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 01:08:49PM +1000, Dave Chinner wrote:
> On Thu, May 25, 2023 at 05:44:17PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Use deferred frees (EFIs) to reap the blocks of a btree that we just
> > replaced.  This helps us to shrink the window in which those old blocks
> > could be lost due to a system crash, though we try to flush the EFIs
> > every few hundred blocks so that we don't also overflow the transaction
> > reservations during and after we commit the new btree.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/reap.c |   27 +++++++++++++++++++++++----
> >  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> .....
> > @@ -207,13 +212,22 @@ xrep_reap_block(
> >  		xrep_block_reap_binval(sc, fsbno);
> >  		error = xrep_put_freelist(sc, agbno);
> >  	} else {
> > +		/*
> > +		 * Use deferred frees to get rid of the old btree blocks to try
> > +		 * to minimize the window in which we could crash and lose the
> > +		 * old blocks.  However, we still need to roll the transaction
> > +		 * every 100 or so EFIs so that we don't exceed the log
> > +		 * reservation.
> > +		 */
> >  		xrep_block_reap_binval(sc, fsbno);
> > -		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, rs->oinfo,
> > -				rs->resv);
> > +		__xfs_free_extent_later(sc->tp, fsbno, 1, rs->oinfo, true);
> 
> Need to capture the returned error here.

Yep, that'll be part of v26.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
