Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A11C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 04:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A52C7208B3
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 04:40:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+gKlCTh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgHNEkt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 00:40:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgHNEks (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 00:40:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597380047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KQRJuPlsHvNlpRjz9RKW6SWwct26B4ITHNgalZv+MVE=;
        b=K+gKlCThqQeNJN5BOq/UZfCm4M7QIgfqlL59LBFBEY4LDCVrSHYNtwAG2Vj3aPVx1uxqVY
        DTgCsneJjC3JxnIgCQkKkqdOKMouEj6v/fpTr/j+6D98xhvpLaH94mHxudcJEXnnYcGoCI
        +twlf6oSyrgLindtXNg1d6J0l5zwNTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-9VLiZV6_P_OFnwNlLvWVow-1; Fri, 14 Aug 2020 00:40:44 -0400
X-MC-Unique: 9VLiZV6_P_OFnwNlLvWVow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A460100CF64;
        Fri, 14 Aug 2020 04:40:43 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6B4A1992D;
        Fri, 14 Aug 2020 04:40:42 +0000 (UTC)
Date:   Fri, 14 Aug 2020 12:53:35 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_db: use correct inode to set inode type
Message-ID: <20200814045335.GR2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs@vger.kernel.org
References: <20200813173050.26203-1-zlang@redhat.com>
 <647f04d7-1a71-2dd0-fc8b-98e3f65afd9f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <647f04d7-1a71-2dd0-fc8b-98e3f65afd9f@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 03:49:42PM -0500, Eric Sandeen wrote:
> On 8/13/20 10:30 AM, Zorro Lang wrote:
> > A test fails as:
> >   # xfs_db -c "inode 133" -c "addr" -c "p core.size" -c "type inode" -c "addr" -c "p core.size" /dev/sdb1
> >   current
> >           byte offset 68096, length 512
> >           buffer block 128 (fsbno 16), 32 bbs
> >           inode 133, dir inode -1, type inode
> >   core.size = 123142
> >   current
> >           byte offset 65536, length 512
> >           buffer block 128 (fsbno 16), 32 bbs
> >           inode 128, dir inode 128, type inode
> >   core.size = 42
> > 
> > The "type inode" command accidentally moves the io cursor because it
> > forgets to include the io cursor's buffer offset when it computes the
> > inode number from the io cursor's location.
> > 
> > Fixes: 533d1d229a88 ("xfs_db: properly set inode type")
> > 
> > Reported-by: Jianhong Yin <jiyin@redhat.com>
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> 
> This looks good to me, I'll test it.  And I think I have a cleanup
> to the whole function, after this fix...

Sure, the buffer verification code is added by:

  9ba69ce2 ("db: verify buffer on type change")

But later we turn to use set_cur() in set_iocur_type(), which looks do
buffer verification too.

Thanks,
Zorro

> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> > 
> > V2 did below changes:
> > 0) git commit log is changed.
> > 1) Separate out several clear steps to calculate inode.
> > 2) Remove improper comment which describe inode calculation.
> > 
> > Thanks,
> > Zorro
> > 
> >  db/io.c | 18 ++++++++++--------
> >  1 file changed, 10 insertions(+), 8 deletions(-)
> > 
> > diff --git a/db/io.c b/db/io.c
> > index 6628d061..884da599 100644
> > --- a/db/io.c
> > +++ b/db/io.c
> > @@ -588,18 +588,20 @@ set_iocur_type(
> >  {
> >  	struct xfs_buf	*bp = iocur_top->bp;
> >  
> > -	/* Inodes are special; verifier checks all inodes in the chunk */
> > +	/*
> > +	 * Inodes are special; verifier checks all inodes in the chunk, the
> > +	 * set_cur_inode() will help that
> > +	 */
> >  	if (type->typnm == TYP_INODE) {
> >  		xfs_daddr_t	b = iocur_top->bb;
> > +		xfs_agblock_t	agbno;
> > +		xfs_agino_t	agino;
> >  		xfs_ino_t	ino;
> >  
> > -		/*
> > -		 * Note that this will back up to the beginning of the inode
> > - 		 * which contains the current disk location; daddr may change.
> > - 		 */
> > -		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
> > -			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
> > -			XFS_AGB_TO_AGINO(mp, mp->m_sb.sb_agblocks));
> > +		agbno = xfs_daddr_to_agbno(mp, b);
> > +		agino = XFS_OFFBNO_TO_AGINO(mp, agbno,
> > +				iocur_top->boff / mp->m_sb.sb_inodesize);
> > +		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b), agino);
> >  		set_cur_inode(ino);
> >  		return;
> >  	}
> > 
> 

