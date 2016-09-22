Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44677 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933098AbcIVCZV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2016 22:25:21 -0400
Date: Wed, 21 Sep 2016 19:25:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 2/4] ovl: use vfs_clone_file_range() for copy up if
 possible
Message-ID: <20160922022510.GI10172@birch.djwong.org>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-3-git-send-email-amir73il@gmail.com>
 <CAJfpegvtCf7mPanvmhU8vmoyQTUsVo-O0bpNxwnt4abkJ5ZD6Q@mail.gmail.com>
 <CAOQ4uxjEUghU=-RDBOn5zg6hrM1pn1FseEspO8hCLcSnH4WNGA@mail.gmail.com>
 <20160921214814.GC10454@dastard>
 <20160921215724.GV2356@ZenIV.linux.org.uk>
 <20160921223331.GE10454@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160921223331.GE10454@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Sep 22, 2016 at 08:33:31AM +1000, Dave Chinner wrote:
> On Wed, Sep 21, 2016 at 10:57:24PM +0100, Al Viro wrote:
> > On Thu, Sep 22, 2016 at 07:48:15AM +1000, Dave Chinner wrote:
> > 
> > > If you get any error other than -EXDEV or -EOPNOTSUPP from a clone
> > > operation, there's somethign seriously wrong with the metadata of
> > > the inode or the underlying storage.
> > 
> > Such as -ENOSPC?
> 
> Yup, that's a fatal error, too.  i.e. if a clone returns ENOSPC
> because there isn't space for the extra metadata, then the fallback
> data copy is almost certainly going to fail with ENOSPC when trying
> to reserve/allocate space for both the extra data copy and the extra
> metadata....

XFS will return ENOSPC during reflink if one of the relevant AGs is
running low on space for the refcount/rmap trees; however there might be
enough blocks in another AG to make a regular old copy.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
