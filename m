Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49626 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755104AbeCHIJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 03:09:55 -0500
Date: Thu, 8 Mar 2018 00:09:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] libxfs: Replace XFS_BUF_SET_PTR with
 xfs_buf_associate_memory
Message-ID: <20180308080953.GC15163@infradead.org>
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
 <bc3750b9-7aec-aad3-f7f8-e5a1ef39e6b8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc3750b9-7aec-aad3-f7f8-e5a1ef39e6b8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 06, 2018 at 03:54:08PM -0600, Eric Sandeen wrote:
> We test the return value of this macro, but it returns
> a side-effect which looks like failure.  Write a
> userspace-libxfs-specific version of xfs_buf_associate_memory
> to make this code a tad more like the kernel, with a proper
> return value to boot.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But aren't we supposed to just share xfs_log_recover.c (or the
relevant parts of it) with the kernel anyway?
