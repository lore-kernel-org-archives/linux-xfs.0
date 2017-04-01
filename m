Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39306 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbdDANhO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Apr 2017 09:37:14 -0400
Date: Sat, 1 Apr 2017 15:37:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: 4.10-stable updates for XFS
Message-ID: <20170401133712.GA10946@lst.de>
References: <20170401063512.25313-1-hch@lst.de> <20170401074348.GQ22845@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170401074348.GQ22845@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, Apr 01, 2017 at 03:43:48PM +0800, Eryu Guan wrote:
> On Sat, Apr 01, 2017 at 08:34:46AM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > below are backports up to 4.11-rc4 for XFS.  I've selected all clear
> > bugfixes for reported bugs.
> 
> Do you think it's good to have "c771c14 iomap: invalidate page caches
> should be after iomap_dio_complete() in direct write" in 4.10 stable
> kernel too? It's not an XFS bug, but only XFS could hit it with 4.10
> kernel.

Sure, I'll send it separately.
