Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53573 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcLEQWe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 11:22:34 -0500
Date: Mon, 5 Dec 2016 08:21:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: ignore leaf attr ichdr.count in verifier during log
 replay
Message-ID: <20161205162153.GA10124@infradead.org>
References: <596737a3-fbf8-8712-422c-4705ce36deae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <596737a3-fbf8-8712-422c-4705ce36deae@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 30, 2016 at 04:33:15PM -0600, Eric Sandeen wrote:
> When we create a new attribute, we first create a shortform
> attribute, and try to fit the new attribute into it.
> If that fails, we copy the (empty) attribute into a leaf attribute,
> and do the copy again.  Thus there can be a transient state where
> we have an empty leaf attribute.
> 
> If we encounter this during log replay, the verifier will fail.
> So add a test to ignore this part of the leaf attr verification
> during log replay.
> 
> Thanks as usual to dchinner for spotting the problem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
