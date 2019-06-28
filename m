Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45321 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1WXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:23:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so3651030pfq.12
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 15:23:13 -0700 (PDT)
Date: Fri, 28 Jun 2019 22:23:10 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190628222310.GL19023@42.do-not-panic.com>
References: <20190627143950.19558-1-hch@lst.de>
 <20190628220253.GF30113@42.do-not-panic.com>
 <20190628221914.GD1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628221914.GD1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com

On Fri, Jun 28, 2019 at 03:19:14PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 28, 2019 at 10:02:53PM +0000, Luis Chamberlain wrote:
> > On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> > > Properly allocate the space for the bio_vecs instead of just one byte
> > > per bio_vec.
> > > 
> > > Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
> > 
> > I cannot find 991fc1d2e65e on Linus' tree, nor can I find the subject
> > name patch on Linus' tree. I'm probably missing some context here?
> 
> This patch fixes a bug in for-next. :)

I figured as much but the commit in question is not even on linux-next
for today, so I take it that line would be removed from the commit log?

  Luis
