Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEOIKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 04:10:17 -0400
Date: Wed, 15 May 2019 01:10:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: refactor by-size extent allocation mode
Message-ID: <20190515081016.GJ29211@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-6-bfoster@redhat.com>
 <20190510173413.GD18992@infradead.org>
 <20190513154610.GF61135@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513154610.GF61135@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

> WRT to merging the functions, I'm a little concerned about the result
> being too large. What do you think about folding in _vextent_type() but
> at the same time factoring out the rmap/counter/resv post alloc bits
> into an xfs_alloc_ag_vextent_accounting() helper or some such?

Sounds good to me.  I've looked at the function and another nice thing
to do would be to not pass the ret bno to xfs_alloc_ag_vextent_agfl,
but let that function fill out the args structure return value itself.

Also for the trace piints that still say near in them - maybe we should
change that near to ag?
