Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B02C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 19:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A88FC22B51
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 19:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbhAKTOz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 14:14:55 -0500
Received: from verein.lst.de ([213.95.11.211]:52433 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732725AbhAKTOz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 14:14:55 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BB79567373; Mon, 11 Jan 2021 20:14:12 +0100 (CET)
Date:   Mon, 11 Jan 2021 20:14:12 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>
Subject: Re: [PATCH 3/3] xfs: try to avoid the iolock exclusive for
 non-aligned direct writes
Message-ID: <20210111191412.GA8774@lst.de>
References: <20210111161212.1414034-1-hch@lst.de> <20210111161212.1414034-4-hch@lst.de> <20210111185920.GF1091932@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111185920.GF1091932@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 01:59:20PM -0500, Brian Foster wrote:
> > +	/*
> > +	 * Bmap information not read in yet or no blocks allocated at all?
> > +	 */
> > +	if (!(ifp->if_flags & XFS_IFEXTENTS) || !ip->i_d.di_nblocks)
> > +		return 0;
> > +
> > +	ret = xfs_ilock_iocb(iocb, XFS_ILOCK_SHARED);
> > +	if (ret)
> > +		return ret;
> 
> It looks like this helper is only called with ILOCK_SHARED already held.

xfs_dio_write_exclusive is called with the iolock held shared, but not
the ilock.


> > +	if (iocb->ki_pos > i_size_read(inode)) {
> > +		if (iocb->ki_flags & IOCB_NOWAIT)
> >  			return -EAGAIN;
> 
> Not sure why we need this check here if we'll eventually fall into the
> serialized check. It seems safer to me to just do 'iolock =
> XFS_IOLOCK_EXCL;' here and carry on.

It seems a little pointless to first acquire the lock for that.  But
in the end this is not what the patch is about, so I'm happy to drop it
if that is preferred.

> > -	if (unaligned_io) {
> > +	if (exclusive_io) {
> 
> Hmm.. so if we hold or upgrade to ILOCK_EXCL from the start for whatever
> reason, we'd never actually check whether the I/O is "exclusive" or not.
> Then we fall into here, demote the lock and the iomap layer may very
> well end up doing subblock zeroing. I suspect if we wanted to maintain
> this logic, the exclusive I/O check should occur for any subblock_io
> regardless of how the lock is held.

True.
