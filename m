Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45023 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934708AbcJZRVN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 13:21:13 -0400
Date: Wed, 26 Oct 2016 10:20:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 25/39] man: document the inode cowextsize flags & fields
Message-ID: <20161026172033.GD26572@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743677455.11035.16363741138480682509.stgit@birch.djwong.org>
 <20161026103944.GS29648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026103944.GS29648@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 03:39:44AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 25, 2016 at 04:06:14PM -0700, Darrick J. Wong wrote:
> > Document the new copy-on-write extent size fields and inode flags
> > available in struct fsxattr.
> 
> Looks fine.  Btw, now that fsxattr is in common code should this
> documentation move to or be duplicated in the man-pages project?

Yeah.  I'll port the manpage over to man-pages and we can
kill the one in xfsprogs later if we want.

> Reviewed-by: Christoph Hellwig <hch@lst.de>
