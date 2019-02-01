Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39602 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfBAIDo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 03:03:44 -0500
Date: Fri, 1 Feb 2019 00:03:43 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190201080343.GD22295@infradead.org>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897672012.26065.1375987197453969157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897672012.26065.1375987197453969157.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 03:18:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use a rhashtable to cache the unlinked list incore.  This should speed
> up unlinked processing considerably when there are a lot of inodes on
> the unlinked list because iunlink_remove no longer has to traverse an
> entire bucket list to find which inode points to the one being removed.

This sounds pretty reasonable and a real review will follow.  But can
you quantify the considerably speedups for real life workloads?
