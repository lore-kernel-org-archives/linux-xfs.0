Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57151 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944348AbcJaPqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2016 11:46:43 -0400
Date: Mon, 31 Oct 2016 08:46:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't BUG() on mixed direct and mapped I/O
Message-ID: <20161031154642.GA28355@infradead.org>
References: <1477923268-59559-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477923268-59559-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 31, 2016 at 10:14:28AM -0400, Brian Foster wrote:
> We've had reports of generic/095 causing XFS to BUG() in
> __xfs_get_blocks() due to the existence of delalloc blocks on a direct
> I/O read. generic/095 issues a mix of various types of I/O, including
> direct and memory mapped I/O to a single file.

Can you explain the scenario in which case this happens in a little
more detail?  The patch looks fine to me, but I'd really like to
understand how this happens.
