Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdIVIif (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Sep 2017 04:38:35 -0400
Date: Fri, 22 Sep 2017 10:38:31 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: pathconf syscall for linux
Message-ID: <20170922083831.katd3adr2hdkk6wr@rh_laptop>
References: <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
 <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
 <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
 <20170919155528.GA8907@infradead.org>
 <563513ad-afb5-4c76-9f38-4b2e79e7af8a@redhat.com>
 <20170919203719.GD731@infradead.org>
 <20170919231716.tmdiz3vnzretwrks@thunk.org>
 <20170921131746.ewi7fwiegufa77mn@rh_laptop>
 <ad44458e-acbe-1bf2-05b5-5a76d55833db@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad44458e-acbe-1bf2-05b5-5a76d55833db@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Florian Weimer <fweimer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 03:49:48PM +0200, Florian Weimer wrote:
> On 09/21/2017 03:17 PM, Lukas Czerner wrote:
> 
> > _PC_NAME_MAX		linux limits
> 
> Note that _PC_NAME_MAX is basically a lie.  There are file systems which
> support longer names than 255 bytes.  It's quite common for file systems
> which store names in UCS-2 or UTF-16 and have code point limit of 255, which
> translates to something larger after UTF-8 conversion in the kernel.  This
> value is available today through statfs/f_namemax, but historically, the
> reported value was not correct.

Right, we can do this correctly from kernel though.

> 
> But due to file bind mounts, any value the kernel can return is useless for
> application use anyway.
> 
> The only real user of this constant was readdir_r, and I've been trying to
> kill it (it's still in POSIX, but will be removed in a future edition).

Good to know, but we still need to implement this, at least for now.

> 
> > _PC_REC_INCR_XFER_SIZE 	?
> > _PC_REC_MAX_XFER_SIZE	?
> > _PC_REC_MIN_XFER_SIZE	? block size ?
> > _PC_REC_XFER_ALIGN	per fs (block size)
> 
> NFS (and perhaps other network file systems) treats f_bsize to signal
> something similar.  We had to remove f_bsize-based tuning from glibc as a
> result because the value is quite misleading for many workloads.
> 
> > _PC_ALLOC_SIZE_MIN	per fs (block size)
> 
> Like the other size limits quoted above, the semantics are quite unclear.
> POSIX documents them mostly in the context of the RT extensions, so the
> acceptable values likely depend whether the application uses kernel-assisted
> aio, or aio based on userspace threads.


Thanks!
-Lukas
