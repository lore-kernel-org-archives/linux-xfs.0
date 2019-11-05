Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7DBCA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7257B20717
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbfKEBif (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:38:35 -0500
Received: from verein.lst.de ([213.95.11.211]:42478 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729623AbfKEBif (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 20:38:35 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0730768BE1; Tue,  5 Nov 2019 02:38:33 +0100 (CET)
Date:   Tue, 5 Nov 2019 02:38:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/34] xfs: add a btree entries pointer to struct
 xfs_da3_icnode_hdr
Message-ID: <20191105013832.GB32531@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-6-hch@lst.de> <20191104195233.GF4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104195233.GF4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 11:52:33AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 01, 2019 at 03:06:50PM -0700, Christoph Hellwig wrote:
> > All but two callers of the ->node_tree_p dir operation already have a
> > xfs_da3_icnode_hdr from a previous call to xfs_da3_node_hdr_from_disk at
> > hand.  Add a pointer to the btree entries to struct xfs_da3_icnode_hdr
> > to clean up this pattern.  The two remaining callers now expand the
> > whole header as well, but that isn't very expensive and not in a super
> > hot path anyway.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c |  6 ++--
> >  fs/xfs/libxfs/xfs_da_btree.c  | 68 ++++++++++++++++-------------------
> >  fs/xfs/libxfs/xfs_da_btree.h  |  1 +
> >  fs/xfs/libxfs/xfs_da_format.c | 21 -----------
> >  fs/xfs/libxfs/xfs_dir2.h      |  2 --
> >  fs/xfs/scrub/dabtree.c        |  6 ++--
> >  fs/xfs/xfs_attr_inactive.c    | 34 +++++++++---------
> >  fs/xfs/xfs_attr_list.c        |  2 +-
> >  8 files changed, 55 insertions(+), 85 deletions(-)
> > 
> 
> <snip>
> 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> > index 69ebf6a50d85..63ed45057fa5 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.h
> > +++ b/fs/xfs/libxfs/xfs_da_btree.h
> > @@ -135,6 +135,7 @@ struct xfs_da3_icnode_hdr {
> >  	uint16_t		magic;
> >  	uint16_t		count;
> >  	uint16_t		level;
> > +	struct xfs_da_node_entry *btree;
> 
> This adds to the incore node header structure a pointer to raw disk
> structures, right?  Can we make this a little more explicit by naming
> the field "raw_entries" or something?

Hmm, is that really so much of an issue?  Even something that a comment
wouldn't help?  I'd kinda hate making identifiers extremely long, but
if that's what is needed I can change it.  Same for the other patches
doing something similar.
