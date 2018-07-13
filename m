Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f54.google.com ([209.85.160.54]:35268 "EHLO
        mail-pl0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731871AbeGMVPy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 17:15:54 -0400
Date: Fri, 13 Jul 2018 13:59:31 -0700
From: "Luis R. Chamberlain" <mcgrof@kernel.org>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Message-ID: <20180713205931.GC3620@garbanzo.do-not-panic.com>
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <20180713205154.GA8782@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713205154.GA8782@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Luis R. Chamberlain" <mcgrof@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Fri, Jul 13, 2018 at 01:51:54PM -0700, Matthew Wilcox wrote:
> On Thu, Jul 12, 2018 at 07:43:08PM -0700, Luis R. Chamberlain wrote:
> > Note that while I used this for XFS, it should be easy to add support
> > for other filesystems, should folks wish to do something similar for
> > their filesystems. The current XFS sections being tested are as
> > follows, please let me know if we should consider extending this
> > further:
> 
> I think we need an xfs_dax section too.

Indeed! Thanks for reminding me about that.

> It's still ridiculously hard
> to set up a DAX test environment though. 

I was under the impression we actually need real hardware for that,
if you git grep for XXX you will see a section to add DAX is there
but I skipped those tests as I thought we needed real hardware
for it.

> The best I've been able to
> do is now merged into Kent's ktest -- but you're not based on that,
> so I'll try and get your ostest set up to work with DAX.  Or maybe Ross
> can do it since he's actually been able to get 2MB pages working and I
> still haven't :-(

Patches and new sections to cover more ground indeed are appreciated!

  Luis
