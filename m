Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D1DC54E8D
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 15:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F66206CC
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 15:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2s+Nb9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgELPbj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 11:31:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46982 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726492AbgELPbj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 11:31:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589297497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iv92650PcFUg9wuC488ZqpmyzDCglTfIIY+l+kirypc=;
        b=X2s+Nb9QdF9r5GSO5n0VnlfZK4iga1C1ajiLmW0fPkpw9gY6LDc/03ny2OvJzxpHaw97tK
        DMZXQoCql6D3k0y5BLROalRgHrI4DMOEX0gKiABrPxvmiFYIO7QYAvgQJX7huDZsJeNm95
        yWZdzDkY4He9UUbnRjIjPKhwE8q+zFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-_eigI6OxNgWGXJP-QhzT4Q-1; Tue, 12 May 2020 11:31:35 -0400
X-MC-Unique: _eigI6OxNgWGXJP-QhzT4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEF04800688;
        Tue, 12 May 2020 15:31:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 275125C1B5;
        Tue, 12 May 2020 15:31:34 +0000 (UTC)
Date:   Tue, 12 May 2020 11:31:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: use XFS_IFORK_BOFF xchk_bmap_check_rmaps
Message-ID: <20200512153132.GE37029@bfoster>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-2-hch@lst.de>
 <2615851.ejxhajbSum@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2615851.ejxhajbSum@garuda>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 11, 2020 at 05:10:04PM +0530, Chandan Babu R wrote:
> On Sunday 10 May 2020 12:53:59 PM IST Christoph Hellwig wrote:
> > XFS_IFORK_Q is to be used in boolean context, not for a size.  This
> > doesn't make a difference in practice as size is only checked for
> > 0, but this keeps the logic sane.
> >
> 
> Wouldn't XFS_IFORK_ASIZE() be a better fit since it gives the space used by the
> attr fork inside an inode's literal area?
> 

I had the same thought. It's not clear to me what size is really
supposed to be between the file size for a data fork and fork offset for
the attr fork. I was also wondering if this should use
XFS_IFORK_DSIZE(), but that won't be conditional based on population of
the fork. At the same time, I don't think i_size != 0 necessarily
correlates with the existence of blocks. The file could be completely
sparse or could have any number of post-eof preallocated extents.

Brian

> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/scrub/bmap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index add8598eacd5d..283424d6d2bb6 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> > @@ -591,7 +591,7 @@ xchk_bmap_check_rmaps(
> >  		size = i_size_read(VFS_I(sc->ip));
> >  		break;
> >  	case XFS_ATTR_FORK:
> > -		size = XFS_IFORK_Q(sc->ip);
> > +		size = XFS_IFORK_BOFF(sc->ip);
> >  		break;
> >  	default:
> >  		size = 0;
> > 
> 
> 
> -- 
> chandan
> 
> 
> 

