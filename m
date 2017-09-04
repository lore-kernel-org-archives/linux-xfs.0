Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43587 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753789AbdIDPoy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Sep 2017 11:44:54 -0400
Date: Mon, 4 Sep 2017 17:44:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: test the per-inode DAX flag
Message-ID: <20170904154453.GA6771@lst.de>
References: <20170903093325.GA16272@lst.de> <20170904072431.GW27835@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904072431.GW27835@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 04, 2017 at 03:24:31PM +0800, Eryu Guan wrote:
> On Sun, Sep 03, 2017 at 11:33:25AM +0200, Christoph Hellwig wrote:
> > This tests checks that the per-inode DAX flag is either reject
> > or sticks around, and that rapidly setting/clearing it will not
> > crash the kernel.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Does this test make sense when filesystem was mounted without dax
> option? I saw these failures when testing on normal block device without
> dax mount option.

I think the first part that tries to set it makes sense everywhere,
but we should also _notrun for this case and not just for EINVAL.

That being said: right now I don't understand at all where the
EIO when setting the flag comes from, let me figure out where it is.

And thinking about it - why would we not allow setting the flag,
especially given that right now it doesn't have a meaning either
with or without DAX..
