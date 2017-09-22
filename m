Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdIVIkn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Sep 2017 04:40:43 -0400
Date: Fri, 22 Sep 2017 10:40:39 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Message-ID: <20170922084039.b4szu6mvqlyejd5g@rh_laptop>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
 <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
 <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
 <20170919155528.GA8907@infradead.org>
 <563513ad-afb5-4c76-9f38-4b2e79e7af8a@redhat.com>
 <20170919203719.GD731@infradead.org>
 <20170919231716.tmdiz3vnzretwrks@thunk.org>
 <9b2ffed5-6bef-977e-14d5-13e078c4734f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2ffed5-6bef-977e-14d5-13e078c4734f@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Florian Weimer <fweimer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 03:54:01PM +0200, Florian Weimer wrote:
> On 09/20/2017 01:17 AM, Theodore Ts'o wrote:
> > There might be some tricky bits will be if glibc feels it needs to
> > override the values returned by the kernel (if it believes it may
> > impose some limitations due to its implementation).  Also, not all
> > file systems will implement some or all pathconf parameters initially
> > (or perhaps ever).  So should the VFS be responsible for returning
> > some intelligent defaults, or glibc?
> 
> I'd prefer if we could export pathconfat directly on the glibc side, without
> any emulation, and have the application deal with ENOSYS.
> 
> We would use it to implement parts of pathconf/fpathconf if available, but I
> don't think we should copy the existing emulation for pathconfat because
> every time we add such emulation, it comes back to haunt us.

Fair enough, I'll get back with some kernel code.

Thanks!
-Lukas
