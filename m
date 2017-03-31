Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933106AbdCaQ2T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 12:28:19 -0400
Date: Fri, 31 Mar 2017 09:28:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: move the inline directory verifiers
Message-ID: <20170331162817.GA8971@infradead.org>
References: <20170327230315.GB4864@birch.djwong.org>
 <20170328125104.GA4100@bfoster.bfoster>
 <20170328150047.GB4874@birch.djwong.org>
 <20170328151105.GC4100@bfoster.bfoster>
 <20170328172444.GE4100@bfoster.bfoster>
 <20170329182156.GC4864@birch.djwong.org>
 <20170329224110.GL17542@dastard>
 <20170331160743.GB3255@infradead.org>
 <20170331162431.GF4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170331162431.GF4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 31, 2017 at 09:24:31AM -0700, Darrick J. Wong wrote:
> I think xfs/348 causes -rc4 to fall over if CONFIG_XFS_DEBUG=y due to
> the XFS_WANT_CORRUPTED_RETURNs that shouldn't be there.

Yes, that's the one.  How are we going to fix that for -rc5?
