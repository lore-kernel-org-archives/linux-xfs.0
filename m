Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41022 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbeLDLBj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 06:01:39 -0500
Date: Tue, 4 Dec 2018 06:01:34 -0500
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Message-ID: <20181204110134.GA3269@kmo-pixel>
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
Cc: "Luis R. Chamberlain" <mcgrof@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Sat, Jul 14, 2018 at 03:21:15PM -0700, Matthew Wilcox wrote:
> On Fri, Jul 13, 2018 at 01:59:31PM -0700, Luis R. Chamberlain wrote:
> > > It's still ridiculously hard
> > > to set up a DAX test environment though. 
> > 
> > I was under the impression we actually need real hardware for that,
> > if you git grep for XXX you will see a section to add DAX is there
> > but I skipped those tests as I thought we needed real hardware
> > for it.
> 
> qemu has the ability to emulate having real hardware ;-)  Here's
> the patch that sets that up in ktest:
> 
> https://github.com/koverstreet/ktest/commit/16aa8b2cb68ad152ddebd66e40d633fc675d9796
> 
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
> I don't think it's possible to set up DAX testing in the current oscheck
> framework ... but I think it might be possible to turn oscheck into a
> set of ktest tests.

Matthew, do you have any thoughts on what merging ktest with xfstests would look
like?

I'd be willing to spend some time on it, it would make my life easier since I
use both heavily, but there are some impedence mismatches to sort through.

Mainly, ktest needs some configuration, and right now it gets most of that from
the test itself - e.g. how many scratch devices to create and how big. Tests
also declare what kernel config options they require, which is really useful
feature for reducing friction when running tests and making automation easier.

If we can come up with a solution for that, merging ktest and build-test-kernel
into xfstests shouldn't be too hard.
