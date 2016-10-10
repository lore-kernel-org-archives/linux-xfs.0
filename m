Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35594 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbcJJKvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 06:51:39 -0400
Date: Mon, 10 Oct 2016 03:22:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] xfs: fix label inaccuracies
Message-ID: <20161010102253.GE18359@infradead.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588167051.12127.12421314963194053634.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588167051.12127.12421314963194053634.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Oct 07, 2016 at 04:07:50PM -0700, Darrick J. Wong wrote:
> Since we don't unlock anything on the way out, change the label.

But we should.. The xfs_file_wait_for_io calls should be under the
I/O lock to be race free.  My idea was to simply merge
xfs_file_share_range into xfs_reflink_remap_range while also cleaning
the bool dedup vs flags mess.  I just haven't gotten to it yet..

