Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FA3CA90AF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B3C72065D
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgEMNVv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 09:21:51 -0400
Received: from verein.lst.de ([213.95.11.211]:46476 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbgEMNVv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 May 2020 09:21:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7B09F68BEB; Wed, 13 May 2020 15:21:48 +0200 (CEST)
Date:   Wed, 13 May 2020 15:21:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: use XFS_IFORK_BOFF xchk_bmap_check_rmaps
Message-ID: <20200513132148.GA11038@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-2-hch@lst.de> <2615851.ejxhajbSum@garuda> <20200512153132.GE37029@bfoster> <20200512153854.GC6714@magnolia> <20200512161410.GI37029@bfoster> <20200512191615.GK6714@magnolia> <20200513131950.GD44225@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513131950.GD44225@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 09:19:50AM -0400, Brian Foster wrote:
> > We scan all the rmaps for files that have nonzero size but zero extents,
> > because the (forthcoming) inode fork repair will reset damaged forks
> > back to extents format with zero extents, and this is how we will
> > trigger the bmap repair to get the extents mapped back into the file.
> > 
> 
> Not sure I follow. Does this mean we're basically looking at sparse
> files as "suspect" because we'd expect them to have extents? Why are we
> looking at i_size here instead of fork size like for the attr fork, for
> example? Either way it sounds like we're getting into some twisty repair
> logic so perhaps this is beyond the scope of Christoph's patches..

The patch can be easily dropped from the series.  I just noticed
something fishy while looking over the code and though the fix would
be easy enough..
