Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50164 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbeJ0EFL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 00:05:11 -0400
Date: Fri, 26 Oct 2018 12:26:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: check all defer ops types
Message-ID: <20181026192651.GA16071@infradead.org>
References: <20181026161905.GH28243@magnolia>
 <0dc53e1c-2ad6-b04f-2747-451b6760e1d5@sandeen.net>
 <d13db2aa-3e73-7dd6-8677-7e19f9b7ffcd@sandeen.net>
 <20181026191851.GI28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026191851.GI28243@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 12:18:51PM -0700, Darrick J. Wong wrote:
> The downside of this is that now we have to declare all those functions
> somewhere so that the fs/xfs/ and libxfs/defer_item.c can match the
> prototypes.

I don't think that is worth the pain vs the version I posted.  I don't
think removing a single indirection really buys us so much as to expose
all the internals.
