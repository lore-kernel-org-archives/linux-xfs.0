Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBCCC433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E84B861990
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhCVMVw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 08:21:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhCVMV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 08:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616415684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Eb69+Xs4k1tzOPgLEmotQKt8pl7GwTquTkty0YicWw=;
        b=KnQBMdVMozgLLZpQlB+H5Yto/zhGp4HDNzefjKlHFkDgoq+6cF7qFYpCUl7jwx3FsgpeoS
        N+B0bF5PsgMB3YZamd+xkSIdv/SBi4GsP9Ivm6PM39+OLS1tHy+cxExkI+K6d/EEFInGZR
        8bNSJipuxAZa/6Cj49Onmf9jvygQ5Ow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-15Q3WLwyN_GKe0GzdyoG4Q-1; Mon, 22 Mar 2021 08:21:10 -0400
X-MC-Unique: 15Q3WLwyN_GKe0GzdyoG4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 306B381433D;
        Mon, 22 Mar 2021 12:21:08 +0000 (UTC)
Received: from bfoster (ovpn-112-29.rdu2.redhat.com [10.10.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B0DC5B6A8;
        Mon, 22 Mar 2021 12:21:04 +0000 (UTC)
Date:   Mon, 22 Mar 2021 08:21:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v8 2/5] xfs: hoist out xfs_resizefs_init_new_ags()
Message-ID: <YFiLrrNwjxMNHtGl@bfoster>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-3-hsiangkao@redhat.com>
 <YFh/R/XMvCXnA3Q9@bfoster>
 <20210322115349.GA2000812@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322115349.GA2000812@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 07:53:49PM +0800, Gao Xiang wrote:
> On Mon, Mar 22, 2021 at 07:28:07AM -0400, Brian Foster wrote:
> > On Fri, Mar 05, 2021 at 10:57:00AM +0800, Gao Xiang wrote:
> > > Move out related logic for initializing new added AGs to a new helper
> > > in preparation for shrinking. No logic changes.
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  fs/xfs/xfs_fsops.c | 107 +++++++++++++++++++++++++++------------------
> > >  1 file changed, 64 insertions(+), 43 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > index 9f9ba8bd0213..fc9e799b2ae3 100644
> > > --- a/fs/xfs/xfs_fsops.c
> > > +++ b/fs/xfs/xfs_fsops.c
...
> > > @@ -123,9 +145,8 @@ xfs_growfs_data_private(
> > >  	 */
> > >  	if (nagcount > oagcount)
> > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > > -	if (nb > mp->m_sb.sb_dblocks)
> > > -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> > > -				 nb - mp->m_sb.sb_dblocks);
> > > +	if (delta > 0)
> > > +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
> > 
> > Hm.. isn't delta still unsigned as of this patch?
> 
> Not sure if some difference exists, I could update it as "if (delta)",
> therefore it seems [PATCH v8 4/5] won't modify this anymore.
> 

Yeah, not sure it's a problem, it just stands out a bit with it being in
a separate patch from the change to the variable type.

Brian

> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> > 
> > >  	if (id.nfree)
> > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > >  
> > > @@ -152,7 +173,7 @@ xfs_growfs_data_private(
> > >  	 * If we expanded the last AG, free the per-AG reservation
> > >  	 * so we can reinitialize it with the new size.
> > >  	 */
> > > -	if (delta) {
> > > +	if (lastag_resetagres) {
> > >  		struct xfs_perag	*pag;
> > >  
> > >  		pag = xfs_perag_get(mp, id.agno);
> > > -- 
> > > 2.27.0
> > > 
> > 
> 

