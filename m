Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbeCNQCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 12:02:07 -0400
Date: Wed, 14 Mar 2018 09:01:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable
 inode
Message-ID: <20180314160152.GE4875@magnolia>
References: <CAOQ4uxjn8UN2-Hzr8u404ydKf8s41yVpMA93-n7r6Dr2VBz3dA@mail.gmail.com>
 <CAOQ4uxhdkhZup=ndukKCRtU13YVs8jQxT0zgOT_XN3_-tB8TfQ@mail.gmail.com>
 <CAOQ4uxhCjBA99X_C-GpEBf=jC4S_wSrxMwS6Ovj7BtWLK1GmUA@mail.gmail.com>
 <20180313131109.GB6260@lst.de>
 <CAOQ4uxiDHSC19-fRdZmXM5BJB3-p9_LdPgSmxpjGrdCzhV2W2Q@mail.gmail.com>
 <20180313215028.GE18129@dastard>
 <CAOQ4uxgsMwtQRCkpJTJoVO-mbU1yRz7F0pMOAVcJphEEKq8SHA@mail.gmail.com>
 <20180314123314.GG18129@dastard>
 <20180314124913.GA936@lst.de>
 <CAOQ4uxi0j=S+6zZo8YSzJQ4aSjdK02U2zxuOue7W3NtCrcKmSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi0j=S+6zZo8YSzJQ4aSjdK02U2zxuOue7W3NtCrcKmSQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>

On Wed, Mar 14, 2018 at 05:45:40PM +0200, Amir Goldstein wrote:
> On Wed, Mar 14, 2018 at 2:49 PM, Christoph Hellwig <hch@lst.de> wrote:
> > On Wed, Mar 14, 2018 at 11:33:14PM +1100, Dave Chinner wrote:
> >> IOWs, if all you're doing is relying on "fixes" tags to determine
> >> what /might/ be needed in a stable kernel.org update, then your
> >> stable backport process is fundamentally broken. You're going to
> >> break things and make stable kernels worse for your users, not
> >> better.
> >
> > Agreed.  As someone who has done a fair share of -stable backports
> > for a customer:  The backport to the last stable release is fairly
> > easy, as it means picking everything that is not clearly a feature
> > or cleanup, and you're generally still familiar with the code.  It
> > still needs quite a lot of QA time.  Backports to older long-term
> > stable bases can become much more hairy very quickly.
> >
> > In either case Fixes: tags don't help at all.  What helps is having
> > one person doing the backports continiously so that they are in the
> > loop.  So when I had a paying customer for the backports it was
> > fairly easy for me as I knew where I left off, need to pick up again
> > and remember the pitfalls of the old stable code.  Randomly Ccing
> > stable or someone working from Fixes tags has none of those benefits.
> > And espesically the CC stable is dangerous as there is no QA or
> > detailed review performed.
> 
> Got it.
> 
> I also read between the lines that the responsibility of herding the stable
> patches has shifted from you to Darrick in the last development cycle.

"..from [Christoph] to /dev/null..." would be more accurate. :(

At this point I must give up the fiction that between prepping/reviewing
patches for the next kernel and fixing problems in the current rc I have
any time for stable kernel stuff at all.

So, it's open season for anyone who /does/ have the time to pick out
fixes and their dependencies, massage them into the appropriate stable
kernels, and do at least the minimum xfstests QA (testing a v4, a v5 +
everything, and a v5 + everything + 1k block size would be a good
start).

> Eventually, I got my answer to how I should make sure my patch finds
> its way to stable, so I'm good with that.
> 
> Only wondering out loud if there should not be a process to expedite
> last cycle regression fixes, such as my patch, to the stable tree.
> After all, we are at 4.15.9 and I reported the regression even before
> v4.15 was released.

Aaaanyway, this i_rdev preservation fix is ok for 4.15, since (as Amir
has pointed out) it originated in 4.15-rc1.

--D

> Thanks,
> Amir.
