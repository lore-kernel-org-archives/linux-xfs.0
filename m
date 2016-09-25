Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49587 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034180AbcIYOeb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Sep 2016 10:34:31 -0400
Date: Sun, 25 Sep 2016 07:34:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: allow chattr & chproj on foreign filesystems
Message-ID: <20160925143429.GE29268@infradead.org>
References: <e1471cdf-9f83-91d1-9e93-f3877baeccb5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1471cdf-9f83-91d1-9e93-f3877baeccb5@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

On Fri, Sep 16, 2016 at 08:00:39PM -0500, Eric Sandeen wrote:
> Now that FS_IOC_FSSETXATTR is a generic vfs call, these
> functions can be used on non-xfs filesystems, and this is
> needed for generic project quota testing.
> 
> (not all flags are valid on all filesystems.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
