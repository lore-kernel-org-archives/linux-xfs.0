Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52096 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcLEMpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 07:45:24 -0500
Date: Mon, 5 Dec 2016 04:45:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161205124520.GA30956@infradead.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161205092112.GS29149@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 05, 2016 at 05:21:12PM +0800, Eryu Guan wrote:
> Hi,
> 
> I hit an xfs/109 crash today while testing reflink XFS with 2k block
> size on x86_64 hosts (both baremetal and kvm guest).
> 
> It can be reproduced by running xfs/109 many times, I tried 50-times
> loop twice and it crashed at the 21st and 46th runs. And I can reproduce
> it with both linus tree (4.9-rc4) and linux-xfs tree for-next branch
> (updated on 2016-11-30). I haven't been able to reproduce it with 4k
> block size XFS.
> 
> Detailed host info and crash log are appended at the end of this mail.

FYI, I've got a bug report for a very similar OOPS on a 4k file system,
but the reproducer is not xfstests but a complex customer workload.

The actual out of range block number is a little different, but it's
the same odd pattern with something set in the highest byte of the block
number.

I'll start looking into it today, and this reproducer might be really
useful.
