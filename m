Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37731 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbeLCXlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 18:41:18 -0500
Date: Mon, 3 Dec 2018 15:41:12 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Message-ID: <20181203234112.GP28501@garbanzo.do-not-panic.com>
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <20180713205154.GA8782@bombadil.infradead.org>
 <20180713205931.GC3620@garbanzo.do-not-panic.com>
 <20180714222115.GA13230@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180714222115.GA13230@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Kent Overstreet <kent.overstreet@gmail.com>, Brendan Higgins <brendanhiggins@google.com>

On Sat, Jul 14, 2018 at 03:21:15PM -0700, Matthew Wilcox wrote:
> On Fri, Jul 13, 2018 at 01:59:31PM -0700, Luis R. Chamberlain wrote:
> > > The best I've been able to
> > > do is now merged into Kent's ktest -- but you're not based on that,
> > > so I'll try and get your ostest set up to work with DAX.  Or maybe Ross
> > > can do it since he's actually been able to get 2MB pages working and I
> > > still haven't :-(
> > 
> > Patches and new sections to cover more ground indeed are appreciated!
> 
> I feel like we need to merge ktest and oscheck.  oscheck assumes that you
> know how to set up qemu, and ktest takes care of setting up qemu for you.
> I think it might be possible to turn oscheck into a set of ktest
> tests.

Everyone uses their own qemu based solution, it just so happens that I was
also not satisfied with what I saw and wrote my own solution, kvm-boot [0].

I'm sure others use other things too.

But... a qemu-less solution for a lot of tests would be great as well,
and for this I believe kunit [1] seems to be like a great possibility worth
exploring in the future.

[0] https://gitlab.com/mcgrof/kvm-boot
[1] https://patchwork.kernel.org/patch/10704147/

  Luis
