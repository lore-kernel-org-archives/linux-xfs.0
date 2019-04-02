Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37609 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbfDBLox (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Apr 2019 07:44:53 -0400
Date: Tue, 2 Apr 2019 07:44:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [STABLE PATCH 0/2] Fix in-memory metadata corruption at
 xfs_attr3_leaf_write_verify()
Message-ID: <20190402114450.GB2899@bfoster>
References: <1554042273-3307-1-git-send-email-alex@zadara.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554042273-3307-1-git-send-email-alex@zadara.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadara.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de, shyam@zadara.com

On Sun, Mar 31, 2019 at 05:24:33PM +0300, Alex Lyakas wrote:
> This is a partial backport of original Darrick's series "xfs: logging fixes" to kernel 4.14.
> It fixes the in-memory metadata corruption error, which happens
> when a partially initialized attribute buffer is attemped to be written to disk. 
> This issue is reproducible with kernel 4.14, when adding a 1-sec sleep in xfs_attr_set(),
> between the call to  xfs_attr_shortform_to_leaf() and the call to xfs_attr_leaf_addname().
> 

For future reference, you probably want to make sure the patch series is
threaded when it's posted to the list. That aside, this looks like a
reasonable and straightforward backport to me:

Acked-by: Brian Foster <bfoster@redhat.com>

> Darrick J. Wong (2):
>   xfs: add the ability to join a held buffer to a defer_ops
>   xfs: hold xfs_buf locked between shortform->leaf conversion and the
>     addition of an attribute
> 
>  fs/xfs/libxfs/xfs_attr.c      | 20 +++++++++++++++-----
>  fs/xfs/libxfs/xfs_attr_leaf.c |  9 ++++++---
>  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
>  fs/xfs/libxfs/xfs_defer.c     | 39 ++++++++++++++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_defer.h     |  5 ++++-
>  5 files changed, 63 insertions(+), 13 deletions(-)
> 
> -- 
> 1.9.1
> 
