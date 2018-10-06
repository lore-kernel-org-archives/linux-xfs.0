Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeJFROt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:14:49 -0400
Date: Sat, 6 Oct 2018 03:12:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/15] libxfs: avoid redefinitions of macros in mount.h
Message-ID: <20181006101208.GG28114@infradead.org>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-8-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538712196-13625-8-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 11:03:08PM -0500, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> MS_* (MS_NOSUID ... etc) get redefined.  Fix this by
> simply removing the inclusion of mount.h, which isn't needed.
> 
> Fixes sparse warnings about this.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
