Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vs1-f68.google.com ([209.85.217.68]:42411 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbeLDXen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 18:34:43 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-10-david@fromorbit.com>
 <20181204154347.GA6925@infradead.org> <20181204221847.GQ6311@dastard>
In-Reply-To: <20181204221847.GQ6311@dastard>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Tue, 4 Dec 2018 18:33:42 -0500
Message-ID: <CAN-5tyG7avm_qiZxzmHYjRL_OYN1meLv-SPmDYUX6vAdGBkc-Q@mail.gmail.com>
Subject: Re: [PATCH 09/11] vfs: push copy_file_ranges -EXDEV checks down
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Tue, Dec 4, 2018 at 5:18 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Dec 04, 2018 at 07:43:47AM -0800, Christoph Hellwig wrote:
> > Well, this isn't bugfixes anymore, but adding new features..
>
> I made that perfectly clear in the cover description. I called it
> twice, one of them explicitly stating that this series made these
> infrastructure changes because we have pending functionality that
> dependents on cross-device copies being supported in a sane manner.
>
> I'll drop it if you want, but then I'll just have to come back after
> all the NFS code is merged and do yet more cleanup work.

This doesn't needs to be fixed in this patch series. I think Anna was
pointing out to me for something to take a look at.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
