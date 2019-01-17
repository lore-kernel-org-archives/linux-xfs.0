Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54138 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfAQO0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:26:36 -0500
Date: Thu, 17 Jan 2019 06:26:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/13] xfs: metadata inode directories
Message-ID: <20190117142636.GH16270@infradead.org>
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630934595.21716.17416691804044507782.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:22:26PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This series delivers a new feature -- metadata inode directories.  This
> is a separate directory tree (rooted in the superblock) that contains
> only inodes that contain filesystem metadata.  Different metadata
> objects can be looked up with regular paths.

If we use path names we should just use regular VFS path lookup for
them.  But why do we even need names?  Can't we just work based on
inode numbers?
