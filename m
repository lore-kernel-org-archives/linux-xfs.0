Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56135 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932119AbcJZKcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:32:43 -0400
Date: Wed, 26 Oct 2016 03:32:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/39] libxfs: add configure option to override system
 header fsxattr
Message-ID: <20161026103242.GK29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743671705.11035.1549555844450499931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743671705.11035.1549555844450499931.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:05:17PM -0700, Darrick J. Wong wrote:
> By default, libxfs will use the kernel/system headers to define struct
> fsxattr.  Unfortunately, this creates a problem for developers who are
> writing new features but building xfsprogs on a stable system, because
> the stable kernel's headers don't reflect the new feature.  In this
> case, we want to be able to use the internal fsxattr definition while
> the kernel headers catch up, so provide some configure magic to allow
> developers to force the use of the internal definition.

We should simply always use our defintion either unconditionally or
based on checking the system one.  It's defintively not something that
should require user interaction.
