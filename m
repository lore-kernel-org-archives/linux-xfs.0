Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOGwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:52:17 -0400
Date: Tue, 14 May 2019 23:52:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] libxfs: de-libxfsify core(-ish) functions.
Message-ID: <20190515065215.GE29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-6-git-send-email-sandeen@redhat.com>
 <b78a858b-8be1-ced1-0f16-f4a916a2e2ca@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b78a858b-8be1-ced1-0f16-f4a916a2e2ca@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 04:41:03PM -0500, Eric Sandeen wrote:
> On 5/10/19 3:18 PM, Eric Sandeen wrote:
> > There are a ton of "libxfs_" prefixed functions in libxfs/trans.c which
> > are only called internally by code in libxfs/ - As I understand it,
> > these should probably be just "xfs_" functions, and indeed many
> > of them have counterparts in the kernel libxfs/ code.  This is one
> > small step towards better sync-up of some of the misc libxfs/*
> > transaction code with kernel code.
> 
> I should have changed internal callers too, will resend after other
> review.

I have to admit I never got this whole libxfs renaming.  Why can't
we just use the xfs_* namespace for libxfs as well to start with?
