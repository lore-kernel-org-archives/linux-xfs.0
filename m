Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77234C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 16:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiK3Qai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 11:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiK3QaU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 11:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4245B8DFD3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 08:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9BD6B81BB5
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 16:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9AAC433C1;
        Wed, 30 Nov 2022 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669825812;
        bh=4kN14CO3cLZFeLXF4PN4UDDYvju5tiri7+y4hC+Ub90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nRz6JsRYAnEch2O5l8gjmF/IzsnK89GxXVZP7qbOIc//+B4xkQP7a6/HOpQsPOSZ2
         s0JxM766bAGhBhQ/tjvJJZXy65XwlGt1s6E1xcfa+iWKEsMCZLf+9AUCcWW2XL6CQ8
         SFBT41f7K9ojjGlWGwXQJGt9PIA2wAjFCwzTQsPlg/o0fC1VSIfUJ6f1XTQhZ/ga8m
         yLml6MlUm2Hk0A3poCOobPCbBwVFTqUu6ovNtyN0JwExSsz38WvermlNVyQiQgp+Rl
         knB8KXw+hXFIpSl5/cxfa3pcTPuCRZ1g+hyuuFxlw93hcLnUpZaz4CsSgHEq0mnsXA
         rUQUfYmf9sbqQ==
Date:   Wed, 30 Nov 2022 08:30:12 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Message-ID: <Y4eFFEe1dBBjnX1n@magnolia>
References: <20221128131434.21496-1-cem@kernel.org>
 <20221128131434.21496-2-cem@kernel.org>
 <0NyqEHx7QX5M7O3PkRWy9sATHt9hJPj8dbnNIMJyNpqeq9aoBrZvkghW9BWkoENYiKkmi-Yg3IBf-l_G4jUy8w==@protonmail.internalid>
 <Y4UxpPgxbmOi/T9/@magnolia>
 <KPMLSPXiDKono7p55z3gbfWueVu9cMSWxiXEtLwYLP8iiFwccJfklgds0T-ARwMz5Ca6x-5l9GYTgsgalM7W6Q==@protonmail.internalid>
 <20221129141821.4goi2odggvztefhq@andromeda>
 <20221130142228.s3taflpvaj5bfia3@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130142228.s3taflpvaj5bfia3@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2022 at 03:22:28PM +0100, Carlos Maiolino wrote:
> > > > +err_loop:
> > > > +	libxfs_btree_del_cursor(bt_cur, error);
> > > > +err_bt_cur:
> > > > +	libxfs_buf_relse(agbp);
> > > > +err_pag:
> > > > +	libxfs_perag_put(pag);
> > >
> > > So I see that you fixed one of the labels so that err_pag jumps to
> > > releasing the perag pointer, but it's still the case that err_bt_cur
> > > frees the AGF buffer, not the btree cursor; and that err_loop actually
> > > frees the btree cursor.
> > 
> > Totally true. I focused on your comments regarding err_pag, and forgot to review
> > the remaining labels. I'll fix it and send a V3.
> 
> Just to avoid unnecessary new versions :)
> Are the fallowing names ok?
> 
> err_cur
> err_agf
> err_pag

Yes, those are fine.  The label names reflect whatever gets cleaned up
immediately after the label.

> Could be err_agbp too, but I'd rather be explicit this buffer belongs to the
> agf.

Agreed.

--D

> 
> > 
> > Thanks for the review.
> > 
> 
> -- 
> Carlos Maiolino
