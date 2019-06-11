Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39764 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390856AbfFKD3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 23:29:43 -0400
Date: Mon, 10 Jun 2019 20:29:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: allow copy_file_range from a swapfile
Message-ID: <20190611032926.GA1872778@magnolia>
References: <20190610172606.4119-1-amir73il@gmail.com>
 <20190611011612.GQ1871505@magnolia>
 <20190611025108.GB2774@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611025108.GB2774@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Jun 10, 2019 at 10:51:08PM -0400, Theodore Ts'o wrote:
> On Mon, Jun 10, 2019 at 06:16:12PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 10, 2019 at 08:26:06PM +0300, Amir Goldstein wrote:
> > > read(2) is allowed from a swapfile, so copy_file_range(2) should
> > > be allowed as well.
> > > 
> > > Reported-by: Theodore Ts'o <tytso@mit.edu>
> > > Fixes: 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > > 
> > > Darrick,
> > > 
> > > This fixes the generic/554 issue reported by Ted.
> > 
> > Frankly I think we should go the other way -- non-root doesn't get to
> > copy from or read from swap files.
> 
> The issue is that without this patch, *root* doesn't get to copy from
> swap files.  Non-root shouldn't have access via Unix permissions.  We

I'm not sure even root should have that privilege - it's a swap file,
and until you swapoff, it's owned by the kernel and we shouldn't let
backup programs copy your swapped out credit card numbers onto tape.

> could add a special case if we don't trust system administrators to be
> able to set the Unix permissions correctly, I suppose, but we don't do
> that for block devices when they are mounted....

...and administrators often mkfs over mounted filesystems because we let
them read and write block devices.  Granted I tried to fix that once and
LVM totally stopped working...

--D

> 
> 					- Ted
