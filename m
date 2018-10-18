Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42178 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbeJRMxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 08:53:42 -0400
Date: Thu, 18 Oct 2018 05:54:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 09/29] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181018045429.GF32577@ZenIV.linux.org.uk>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
 <153981631706.5568.6473120432728396978.stgit@magnolia>
 <20181018004826.GB12386@ZenIV.linux.org.uk>
 <20181018044718.GT28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018044718.GT28243@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com

On Wed, Oct 17, 2018 at 09:47:18PM -0700, Darrick J. Wong wrote:

> > > +#define REMAP_FILE_DEDUP		(1 << 0)
> > > +
> > > +/*
> > > + * These flags should be taken care of by the implementation (possibly using
> > > + * vfs helpers) but can be ignored by the implementation.
> > > + */
> > > +#define REMAP_FILE_ADVISORY		(0)
> > 
> > ???
> 
> Sorry if this wasn't clear.  How about this?
> 
> /*
>  * These flags signal that the caller is ok with altering various aspects of
>  * the behavior of the remap operation.  The changes must be made by the
>  * implementation; the vfs remap helper functions can take advantage of them.
>  * Flags in this category exist to preserve the quirky behavior of the hoisted
>  * btrfs clone/dedupe ioctls.
>  */

Something like "currently we have no such flags, but some will appear
in subsequent commits", removed once such flags do appear, perhaps?
