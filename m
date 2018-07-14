Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731182AbeGNWls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jul 2018 18:41:48 -0400
Date: Sat, 14 Jul 2018 15:21:15 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Message-ID: <20180714222115.GA13230@bombadil.infradead.org>
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <20180713205154.GA8782@bombadil.infradead.org>
 <20180713205931.GC3620@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713205931.GC3620@garbanzo.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Chamberlain" <mcgrof@kernel.org>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Kent Overstreet <kent.overstreet@gmail.com>

On Fri, Jul 13, 2018 at 01:59:31PM -0700, Luis R. Chamberlain wrote:
> > It's still ridiculously hard
> > to set up a DAX test environment though. 
> 
> I was under the impression we actually need real hardware for that,
> if you git grep for XXX you will see a section to add DAX is there
> but I skipped those tests as I thought we needed real hardware
> for it.

qemu has the ability to emulate having real hardware ;-)  Here's
the patch that sets that up in ktest:

https://github.com/koverstreet/ktest/commit/16aa8b2cb68ad152ddebd66e40d633fc675d9796

> > The best I've been able to
> > do is now merged into Kent's ktest -- but you're not based on that,
> > so I'll try and get your ostest set up to work with DAX.  Or maybe Ross
> > can do it since he's actually been able to get 2MB pages working and I
> > still haven't :-(
> 
> Patches and new sections to cover more ground indeed are appreciated!

I feel like we need to merge ktest and oscheck.  oscheck assumes that you
know how to set up qemu, and ktest takes care of setting up qemu for you.
I don't think it's possible to set up DAX testing in the current oscheck
framework ... but I think it might be possible to turn oscheck into a
set of ktest tests.
