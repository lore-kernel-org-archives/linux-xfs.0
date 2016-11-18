Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46934 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbcKRITq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Nov 2016 03:19:46 -0500
Date: Fri, 18 Nov 2016 09:19:44 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/14] xfs: remove prev argument to
        xfs_bmapi_reserve_delalloc
Message-ID: <20161118081944.GB28286@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de> <1479143565-30615-7-git-send-email-hch@lst.de> <20161117182707.GH49658@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161117182707.GH49658@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Nov 17, 2016 at 01:27:07PM -0500, Brian Foster wrote:
> It just hit me that extnum_t is signed and xfs_iext_get_extent() checks
> for < 0, so that covers here and my similar previous few comments. I
> still think we should probably check it in context rather than bury the
> check in the caller (I'd prefer an assert). Just my .02.

There are several callers that rely on xfs_iext_get_extent handling
negative extents with a NULL return - in fact one reason for the
exact prototype of the function is to cover out of bound indices
that happen during normal operation based on how we iterate over
the extent list.
