Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44509 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbeL2Hti (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Dec 2018 02:49:38 -0500
Date: Sat, 29 Dec 2018 15:49:30 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfstests: test swapext log replay
Message-ID: <20181229074930.GF21777@desktop>
References: <20181223141721.5318-1-zlang@redhat.com>
 <20181229052739.GD21777@desktop>
 <20181229073829.GR30999@dhcp-12-149.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181229073829.GR30999@dhcp-12-149.nay.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Sat, Dec 29, 2018 at 03:38:29PM +0800, Zorro Lang wrote:
> On Sat, Dec 29, 2018 at 01:27:39PM +0800, Eryu Guan wrote:
> > On Sun, Dec 23, 2018 at 10:17:21PM +0800, Zorro Lang wrote:
> > > If an inode had been in btree format and had a data fork owner change
> > > logged (XFS_ILOG_DOWNER), after changing the format to non-btree, will
> > > hit an ASSERT in xfs_recover_inode_owner_change() which enforces that
> > > if XFS_ILOG_[AD]OWNER is set.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>

[snip]

> > > +999 auto quick
> > 
> > Added 'shutdown log' groups.
> 
> Thanks your revewing. But I still have some problems as I described at
> beginning, so I hope we can merge this patch after we have an reply
> about that.

Ok, thanks for the heads-up!

Eryu
