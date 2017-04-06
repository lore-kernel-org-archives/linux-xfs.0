Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753339AbdDFDRo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 23:17:44 -0400
Date: Thu, 6 Apr 2017 11:17:42 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by
 chattr [ver #5]
Message-ID: <20170406031742.GF22845@eguan.usersys.redhat.com>
References: <20170405105226.GA22845@eguan.usersys.redhat.com>
 <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132133562.18980.13032775360715592290.stgit@warthog.procyon.org.uk>
 <5766.1491395157@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5766.1491395157@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Apr 05, 2017 at 01:25:57PM +0100, David Howells wrote:
> Eryu Guan <eguan@redhat.com> wrote:
> 
> > And this test is expected to fail with 4.11-rc5 kernel on all
> > filesystems, right?
> 
> Yes, and probably some thereafter.  Is there a way of requiring the kernel
> version?

No need to require a specific kernel version to let test pass or
_notrun, just let it fail so we know there's an unfixed bug :)

I wanted to make sure the failure was expected and not a test case flaw.

Thanks,
Eryu
