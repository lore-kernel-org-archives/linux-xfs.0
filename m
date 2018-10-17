Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51390 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbeJQQlz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 12:41:55 -0400
Date: Wed, 17 Oct 2018 01:47:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181017084716.GL16896@infradead.org>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 17, 2018 at 10:52:48AM +0300, Avi Kivity wrote:
> I have a user running a 1.7TB filesystem with ~10% usage (as shown by df),
> getting sporadic ENOSPC errors. The disk is mounted with inode64 and has a
> relatively small number of large files. The disk is a single-member RAID0
> array, with 1MB chunk size. There are 32 AGs. Running Linux 4.9.17.

4.9.17 is rather old and you'll have a hard time finding someone
familiar with it..

> Is this a known issue? Would upgrading the kernel help?

Two things that come to mind:

 - are you sure there is no open fd to the unlinked files?  That would
   keep the space allocated until the last link is dropped.
 - even once we drop the inode the space only becomes available once
   the transaction has committed.  We do force the log if we found
   a busy extent, but there might be some issues.  Try seeing if you
   hit the xfs_extent_busy_force trace point with your workload.
 - if you have online discard (-o discard) enabled there might be
   more issues like the above, especially on old kernels.
