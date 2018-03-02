Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:37401 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425322AbeCBJHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 04:07:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfpegtMhcAFpVk0TkAxdoiJzDqYFHFNzykztTGWfii52rPazA@mail.gmail.com>
References: <CAJfpegtMhcAFpVk0TkAxdoiJzDqYFHFNzykztTGWfii52rPazA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 2 Mar 2018 11:07:05 +0200
Message-ID: <CAOQ4uxjfmrJ3OPAOJ_cVQjfmMeHbcJL3gWVdHEATa_FGPWLzCA@mail.gmail.com>
Subject: Re: Weird overlayfs/xfs bug on v4.15
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Mar 2, 2018 at 10:25 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Hi,
>
> I get xfstests failure of overlay/017 on a kvm guest.  The symptom is
> that the chardev turns into a whiteout (i.e. the 1/1 device number
> magically turns to 0/0 after flushing the caches) but then turns back
> into the old chardev on remount or another cache flush.  So the
> underlying xfs is not currupted but the cache is (verified that i_rdev
> was indeed zeroed out on the relevant inode).
>
> Btw. i_rdev on the blkdev also turned zero, but the test doesn't
> respond to that, because it's only checking the inum and not other
> attributes.
>
> The test triggers reliably, but shows signs of a heisenbug (e.g.
> adding printks lessens or eliminates the chance of triggering)
>
> Attaching the full xfs trace, the output of the testcase and guest
> kernel config.
>
> Haven't been able to reproduce without overlayfs, so possibly
> overlayfs is the culprit.
>
> Any ideas?
>

That is supposed to be fixed by
acd1d71598f7 xfs: preserve i_rdev when recycling a reclaimable inode

It fixes a v4.15 regression.

Cheers,
Amir.
