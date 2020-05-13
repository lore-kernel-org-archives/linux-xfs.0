Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96449C2D0FA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E0FF20675
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:20:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NuYM+ZFT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgEMNT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 09:19:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27153 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726001AbgEMNT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 09:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589375996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WiRXgJJ8oj0bjAbqGgFhRwMt2PFUHGK3hlH8HHUyROo=;
        b=NuYM+ZFT3dHwDcsEgVj+rU48r8D2qaSMbtsH9gPyxtihz4JBK6NH6P0hA08+H/aZfe79ox
        YTo88RSyyZqPMRPfaJyP9GyCWq2NYUNOYmJ6Exd7nrzxpX3Abz26J36WaBVx52uiZVCFX3
        WNZN8M79IXTS79v0eDh7hNZNUzqE95Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-Y4cfXPwTOu6RcKN5r1NVjQ-1; Wed, 13 May 2020 09:19:54 -0400
X-MC-Unique: Y4cfXPwTOu6RcKN5r1NVjQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEA07EC1A0;
        Wed, 13 May 2020 13:19:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88D5D5D9C5;
        Wed, 13 May 2020 13:19:52 +0000 (UTC)
Date:   Wed, 13 May 2020 09:19:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: use XFS_IFORK_BOFF xchk_bmap_check_rmaps
Message-ID: <20200513131950.GD44225@bfoster>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-2-hch@lst.de>
 <2615851.ejxhajbSum@garuda>
 <20200512153132.GE37029@bfoster>
 <20200512153854.GC6714@magnolia>
 <20200512161410.GI37029@bfoster>
 <20200512191615.GK6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512191615.GK6714@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 12:16:15PM -0700, Darrick J. Wong wrote:
> On Tue, May 12, 2020 at 12:14:10PM -0400, Brian Foster wrote:
> > On Tue, May 12, 2020 at 08:38:54AM -0700, Darrick J. Wong wrote:
> > > On Tue, May 12, 2020 at 11:31:32AM -0400, Brian Foster wrote:
> > > > On Mon, May 11, 2020 at 05:10:04PM +0530, Chandan Babu R wrote:
> > > > > On Sunday 10 May 2020 12:53:59 PM IST Christoph Hellwig wrote:
> > > > > > XFS_IFORK_Q is to be used in boolean context, not for a size.  This
> > > > > > doesn't make a difference in practice as size is only checked for
> > > > > > 0, but this keeps the logic sane.
> > > > > >
> > > > > 
> > > > > Wouldn't XFS_IFORK_ASIZE() be a better fit since it gives the space used by the
> > > > > attr fork inside an inode's literal area?
> > > > > 
> > > > 
> > > > I had the same thought. It's not clear to me what size is really
> > > > supposed to be between the file size for a data fork and fork offset for
> > > > the attr fork. I was also wondering if this should use
> > > > XFS_IFORK_DSIZE(), but that won't be conditional based on population of
> > > > the fork. At the same time, I don't think i_size != 0 necessarily
> > > > correlates with the existence of blocks. The file could be completely
> > > > sparse or could have any number of post-eof preallocated extents.
> > > 
> > > TBH I should have made that variable "bool empty" or something.
> > > 
> > > case XFS_DATA_FORK:
> > > 	empty = i_size_read() == 0;
> > > 
> > 
> > Even that is somewhat unclear because it's tied to i_size. What about
> > size == 0 && <post-eof extents>?
> 
> /me stumbles around trying to remember under what circumstances do we
> actually scan all the rmaps to make sure there's a corresponding bmap.
> I think we're trying to avoid doing it for every file in the filesystem
> because it's very slow...
> 
> Oh right -- we do that for btree format forks because there are a lot of
> extent records and therefore a high(er) chance of something getting
> lost; or
> 
> We scan all the rmaps for files that have nonzero size but zero extents,
> because the (forthcoming) inode fork repair will reset damaged forks
> back to extents format with zero extents, and this is how we will
> trigger the bmap repair to get the extents mapped back into the file.
> 

Not sure I follow. Does this mean we're basically looking at sparse
files as "suspect" because we'd expect them to have extents? Why are we
looking at i_size here instead of fork size like for the attr fork, for
example? Either way it sounds like we're getting into some twisty repair
logic so perhaps this is beyond the scope of Christoph's patches..

Brian

> --D
> 
> > 
> > Brian
> > 
> > > case XFS_ATTR_FORK:
> > > 	empty = !XFS_IFORK_Q();
> > > 
> > > default:
> > > 	empty = true;
> > > 
> > > if ((is not btree) && (empty || nextents > 0))
> > > 	return 0;
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > > > ---
> > > > > >  fs/xfs/scrub/bmap.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > > > > index add8598eacd5d..283424d6d2bb6 100644
> > > > > > --- a/fs/xfs/scrub/bmap.c
> > > > > > +++ b/fs/xfs/scrub/bmap.c
> > > > > > @@ -591,7 +591,7 @@ xchk_bmap_check_rmaps(
> > > > > >  		size = i_size_read(VFS_I(sc->ip));
> > > > > >  		break;
> > > > > >  	case XFS_ATTR_FORK:
> > > > > > -		size = XFS_IFORK_Q(sc->ip);
> > > > > > +		size = XFS_IFORK_BOFF(sc->ip);
> > > > > >  		break;
> > > > > >  	default:
> > > > > >  		size = 0;
> > > > > > 
> > > > > 
> > > > > 
> > > > > -- 
> > > > > chandan
> > > > > 
> > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 

