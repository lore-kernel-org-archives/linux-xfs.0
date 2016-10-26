Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41196 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbcJZTEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 15:04:42 -0400
Date: Wed, 26 Oct 2016 12:04:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/39] libxfs: add configure option to override system
 header fsxattr
Message-ID: <20161026190411.GH23568@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743671705.11035.1549555844450499931.stgit@birch.djwong.org>
 <20161026103242.GK29648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026103242.GK29648@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 03:32:42AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 25, 2016 at 04:05:17PM -0700, Darrick J. Wong wrote:
> > By default, libxfs will use the kernel/system headers to define struct
> > fsxattr.  Unfortunately, this creates a problem for developers who are
> > writing new features but building xfsprogs on a stable system, because
> > the stable kernel's headers don't reflect the new feature.  In this
> > case, we want to be able to use the internal fsxattr definition while
> > the kernel headers catch up, so provide some configure magic to allow
> > developers to force the use of the internal definition.
> 
> We should simply always use our defintion either unconditionally or
> based on checking the system one.  It's defintively not something that
> should require user interaction.

All right.  For this patch I'll remove the configure option, leaving
only the pieces that actually make the override happen.  In patch #17
I'll add a configure check that enables the override if the system
struct fsxattr is present but does not contain the cowextsize field, and
make it so that io/cowextsize.c is always built.

As a side note this will leave intact the ability to detect that the
system headers don't define fsxattr (or its ioctl) at all, and use the
internal definitions in that case.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
