Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E845C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 19:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 628E222C7E
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 19:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389481AbhAKTuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 14:50:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389440AbhAKTuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 14:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610394549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jDQQg/eShQgy9j91O02V5TQzHkBNr/dTicgGKKWKYaE=;
        b=Ie9PYF5y3oLjWyNUNpp9e/JPAkTQTZvKyXv6aIwCIP7Zq/yCsJFHPfE2ncLvXMwFkP+7GR
        ypIEmo9CZFtnyHIpl4KriWZfUnPcrHM6g/9t9FLsoIdmB75Ka4dawtZ+uiR10Y5paJREQN
        35+ZcolzgQ/j7jKDa/G7u8tibhLufbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-fPisaCQaMWGCu1UMpyc5mA-1; Mon, 11 Jan 2021 14:49:05 -0500
X-MC-Unique: fPisaCQaMWGCu1UMpyc5mA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AACEF801AC0;
        Mon, 11 Jan 2021 19:49:04 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 452B35D9DB;
        Mon, 11 Jan 2021 19:49:04 +0000 (UTC)
Date:   Mon, 11 Jan 2021 14:49:02 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Subject: Re: [PATCH 3/3] xfs: try to avoid the iolock exclusive for
 non-aligned direct writes
Message-ID: <20210111194902.GG1091932@bfoster>
References: <20210111161212.1414034-1-hch@lst.de>
 <20210111161212.1414034-4-hch@lst.de>
 <20210111185920.GF1091932@bfoster>
 <20210111191412.GA8774@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111191412.GA8774@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 08:14:12PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 11, 2021 at 01:59:20PM -0500, Brian Foster wrote:
> > > +	/*
> > > +	 * Bmap information not read in yet or no blocks allocated at all?
> > > +	 */
> > > +	if (!(ifp->if_flags & XFS_IFEXTENTS) || !ip->i_d.di_nblocks)
> > > +		return 0;
> > > +
> > > +	ret = xfs_ilock_iocb(iocb, XFS_ILOCK_SHARED);
> > > +	if (ret)
> > > +		return ret;
> > 
> > It looks like this helper is only called with ILOCK_SHARED already held.
> 
> xfs_dio_write_exclusive is called with the iolock held shared, but not
> the ilock.
> 

Oops, thinko.

> 
> > > +	if (iocb->ki_pos > i_size_read(inode)) {
> > > +		if (iocb->ki_flags & IOCB_NOWAIT)
> > >  			return -EAGAIN;
> > 
> > Not sure why we need this check here if we'll eventually fall into the
> > serialized check. It seems safer to me to just do 'iolock =
> > XFS_IOLOCK_EXCL;' here and carry on.
> 
> It seems a little pointless to first acquire the lock for that.  But
> in the end this is not what the patch is about, so I'm happy to drop it
> if that is preferred.
> 

It may be fine, but I think the codepath is easier to grok without
creating duplicate/racy branches for logic that potentially impacts
behavior (whereas the lock upgrade only impacts performance).
Particularly in this case where if NOWAIT is set, we'll already bail at
the first appropriate point anyways.

Brian

> > > -	if (unaligned_io) {
> > > +	if (exclusive_io) {
> > 
> > Hmm.. so if we hold or upgrade to ILOCK_EXCL from the start for whatever
> > reason, we'd never actually check whether the I/O is "exclusive" or not.
> > Then we fall into here, demote the lock and the iomap layer may very
> > well end up doing subblock zeroing. I suspect if we wanted to maintain
> > this logic, the exclusive I/O check should occur for any subblock_io
> > regardless of how the lock is held.
> 
> True.
> 

