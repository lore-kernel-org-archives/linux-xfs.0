Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbcI3HHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:07:18 -0400
Date: Fri, 30 Sep 2016 00:07:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs/130: don't modify files after failed mount
Message-ID: <20160930070716.GB18305@infradead.org>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
 <147520219573.26891.13193477741708431386.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520219573.26891.13193477741708431386.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Thu, Sep 29, 2016 at 07:23:15PM -0700, Darrick J. Wong wrote:
> In xfs/130, we try to mount a filesystem with the expectation that it
> will fail.  Therefore, it is inappropriate to try to write to the
> mountpoint, since it could otherwise be writable.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Christoph Hellwig <hch@lst.de>
