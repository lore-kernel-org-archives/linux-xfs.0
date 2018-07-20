Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57036 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733198AbeGTQ4L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 12:56:11 -0400
Date: Fri, 20 Jul 2018 09:07:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/14] xfs: reset dfops to initial state after finish
Message-ID: <20180720160714.GE12054@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-7-bfoster@redhat.com>
 <20180719195441.GG6558@infradead.org>
 <20180719203338.GH29404@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719203338.GH29404@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 04:33:38PM -0400, Brian Foster wrote:
> Not sure, I suppose we could just check dop_bufs[0] and memset() if !=
> NULL..? I can do that as well if we don't otherwise lose these pointers.

I don't understand why we even want a conditional here.  In general
copying one or two additional pointers should always be cheaper than
having a conditional.
