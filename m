Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:47057 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbfFYKf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:35:57 -0400
MIME-Version: 1.0
References: <20190611153916.13360-1-amir73il@gmail.com> <20190611153916.13360-2-amir73il@gmail.com>
 <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
 <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
 <20190618150242.GA4576@mit.edu> <20190618151144.GB5387@magnolia> <5D11F781.4040906@cn.fujitsu.com>
In-Reply-To: <5D11F781.4040906@cn.fujitsu.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 25 Jun 2019 13:35:45 +0300
Message-ID: <CAOQ4uxgYApyiiSCWiCUJRgRoYYztMuON2d_mhLso-=DkqwNcbA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc: Theodore Ts'o <tytso@mit.edu>, darrick <darrick.wong@oracle.com>, Murphy Zhou <jencce.kernel@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 25, 2019 at 1:29 PM Yang Xu <xuyang2018.jy@cn.fujitsu.com> wrote:
>
> on 2019/06/18 23:11, Darrick J. Wong  wrote:
>
> > On Tue, Jun 18, 2019 at 11:02:42AM -0400, Theodore Ts'o wrote:
> >> On Tue, Jun 18, 2019 at 12:16:45PM +0300, Amir Goldstein wrote:
> >>> On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou<jencce.kernel@gmail.com>  wrote:
> >>>> Would you mind updating sha1 after it get merged to Linus tree?
> >>>>
> >>>> That would be helpful for people tracking this issue.
> >>>>
> >>> This is the commit id in linux-next and expected to stay the same
> >>> when the fix is merged to Linus tree for 5.3.
> >> When I talked to Darrick last week, that was *not* the sense I got
> >> from him.  It's not necessarily guaranteed to be stable just yet...
> > Darrick hasn't gotten any complaints about the copy-file-range-fixes
> > branch (which has been in for-next for a week now), so he thinks that
> > commit id (a31713517dac) should be stable from here on out.
> >
> > (Note that doesn't guarantee that Linus will pull said branch...)
> >
> > --D
> Hi Amir
>
> The kernel fix commit message is right?  :-)  Because when I backport this patch into 5.2.0-rc6+ kernel,
> generic/554(553) also fails, it should be commit a5544984af4 (vfs: add missing checks to copy_file_range).
> By the way, a31713517dac ("vfs: introduce generic_file_rw_checks()") doesn't check for immutable and swap file.
>
> I think we can change this message after the fix is merged to Linus tree for 5.3.  What do you think about it?

You are right. Documented commit is wrong.
The correct commit in linux-next is:
96e6e8f4a68d ("vfs: add missing checks to copy_file_range")

(Not sure where you got a5544984af4 from?)
Let's fix that after the commit is upstream.

Obviously, you would need to backport the entire series and not just this
one commit to stable kernel.

Thanks,
Amir.
