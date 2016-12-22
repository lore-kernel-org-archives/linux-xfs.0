Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933452AbcLVIpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 03:45:50 -0500
Date: Thu, 22 Dec 2016 00:45:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20161222084549.GA8833@infradead.org>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Dec 21, 2016 at 12:03:17PM -0500, Jeff Layton wrote:
> Only btrfs, ext4, and xfs implement it for data changes. Because of
> this, these filesystems must log the inode to disk whenever the
> i_version counter changes. That has a non-zero performance impact,
> especially on write-heavy workloads, because we end up dirtying the
> inode metadata on every write, not just when the times change. [1]

Do you have numbers to justify these changes?
