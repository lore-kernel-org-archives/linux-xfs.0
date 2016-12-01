Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47894 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753103AbcLAJ7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2016 04:59:32 -0500
Date: Thu, 1 Dec 2016 01:59:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: deprecate barrier/nobarrier mount option
Message-ID: <20161201095930.GA3471@infradead.org>
References: <20161130225444.15869-1-david@fromorbit.com>
 <20161130225444.15869-3-david@fromorbit.com>
 <20161201095439.GB16028@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201095439.GB16028@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Dec 01, 2016 at 10:54:39AM +0100, Jan Kara wrote:
> On Thu 01-12-16 09:54:44, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We always perform integrity operations now, so these mount options
> > don't do anything. Deprecate them and mark them for removal in
> > in a year.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> 
> We use 'nobarrier' mount option to simulate disks with battery-backed
> caches in some of our IO performance testing. I don't say we cannot live
> with this mount option but it was convenient...

FYI, for scsi (and thus ATA as well) you can override the cache type
using the cache_type sysfs file, which is a much better interface for
this than anything file system related.
