Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36516 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbeGSUgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:36:04 -0400
Date: Thu, 19 Jul 2018 12:51:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/14] xfs: fix transaction leak on remote attr
 set/remove failure
Message-ID: <20180719195127.GD6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:49:08AM -0400, Brian Foster wrote:
> The xattr remote value set/remove handlers both clear args.trans in
> the error path without having cancelled the transaction. This leaks
> the transaction, causes warnings around returning to userspace with
> locks held and leads to system lockups or other general problems.
> 
> The higher level xfs_attr_[set|remove]() functions already detect
> and cancel args.trans when set in the error path. Drop the NULL
> assignments from the rmtval handlers and allow the callers to clean
> up the transaction correctly.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
