Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60950 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbeJFRSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:18:24 -0400
Date: Sat, 6 Oct 2018 03:15:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/15] libxfs: export unused nonstatic functions to quiet
 static checkers
Message-ID: <20181006101542.GM28114@infradead.org>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-14-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538712196-13625-14-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 11:03:14PM -0500, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> libxfs functions which aren't used or exported get flagged as
> "should be static" but we stay in sync with kernelspace, which has other
> headers which export them.  Export the lot of them in libxfs_priv.h to
> shut up sparse.

Seems a bit of a hack, but I guess better than other options:

Reviewed-by: Christoph Hellwig <hch@lst.de>
