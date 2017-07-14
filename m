Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751340AbdGNJLu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jul 2017 05:11:50 -0400
Date: Fri, 14 Jul 2017 11:11:46 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfstests failures with current kernel/xfsprogs/xfstests
Message-ID: <20170714091146.pvgc2ctxjcobq7uj@eorzea.usersys.redhat.com>
References: <20170712114433.GA2231@infradead.org>
 <20170712122900.l7ieyfmks5j74esg@eorzea.usersys.redhat.com>
 <20170713071650.GA2433@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713071650.GA2433@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Jul 13, 2017 at 12:16:50AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 12, 2017 at 02:29:00PM +0200, Carlos Maiolino wrote:
> > On Wed, Jul 12, 2017 at 04:44:33AM -0700, Christoph Hellwig wrote:
> > > I see a few failures with a (hopefully) uptodate setup.  I'm pretty
> > > sure some of them have been around for a while, but I'd like to
> > > figure out how to get to a clean slate.
> > > 
> > > This is a 4k fs on x86-64, with reflink enabled for the test and
> > > scratch dev.
> > 
> > Have you by any chance noticed test 81 locking up? Every time I run a complete
> > xfstests, it always get stuck on test 81.
> 
> Which test 81?  generic/081, xfs/081?  How does it lock up?

whoops, missed that, generic/081 specifically it always gets stuck in the lvm
creation process, but, looks like it's an already know problem. I just wonder
why it works for some of us, and don't for another ones. I didn't have time to
dig into it tbh.

cheers
> 
> The generic one had some issues due to lvm doing stupid things in the
> past, but I think we managed to paper over that.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
