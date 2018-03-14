Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35759 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbeCNMtP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Mar 2018 08:49:15 -0400
Date: Wed, 14 Mar 2018 13:49:13 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable
        inode
Message-ID: <20180314124913.GA936@lst.de>
References: <20180311162442.GB2013@kroah.com> <20180312162744.GB4865@magnolia> <CAOQ4uxjn8UN2-Hzr8u404ydKf8s41yVpMA93-n7r6Dr2VBz3dA@mail.gmail.com> <CAOQ4uxhdkhZup=ndukKCRtU13YVs8jQxT0zgOT_XN3_-tB8TfQ@mail.gmail.com> <CAOQ4uxhCjBA99X_C-GpEBf=jC4S_wSrxMwS6Ovj7BtWLK1GmUA@mail.gmail.com> <20180313131109.GB6260@lst.de> <CAOQ4uxiDHSC19-fRdZmXM5BJB3-p9_LdPgSmxpjGrdCzhV2W2Q@mail.gmail.com> <20180313215028.GE18129@dastard> <CAOQ4uxgsMwtQRCkpJTJoVO-mbU1yRz7F0pMOAVcJphEEKq8SHA@mail.gmail.com> <20180314123314.GG18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180314123314.GG18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>

On Wed, Mar 14, 2018 at 11:33:14PM +1100, Dave Chinner wrote:
> IOWs, if all you're doing is relying on "fixes" tags to determine
> what /might/ be needed in a stable kernel.org update, then your
> stable backport process is fundamentally broken. You're going to
> break things and make stable kernels worse for your users, not
> better.

Agreed.  As someone who has done a fair share of -stable backports
for a customer:  The backport to the last stable release is fairly
easy, as it means picking everything that is not clearly a feature
or cleanup, and you're generally still familiar with the code.  It
still needs quite a lot of QA time.  Backports to older long-term
stable bases can become much more hairy very quickly.

In either case Fixes: tags don't help at all.  What helps is having
one person doing the backports continiously so that they are in the
loop.  So when I had a paying customer for the backports it was
fairly easy for me as I knew where I left off, need to pick up again
and remember the pitfalls of the old stable code.  Randomly Ccing
stable or someone working from Fixes tags has none of those benefits.
And espesically the CC stable is dangerous as there is no QA or
detailed review performed.
