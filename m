Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:42880 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753376AbdEWK4f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 06:56:35 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr002msb.fastweb.it (8.5.140.05)
        id 58E21DDC020E2783 for linux-xfs@vger.kernel.org; Tue, 23 May 2017 12:56:33 +0200
Subject: Re: Shutdown filesystem when a thin pool become full
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
Date: Tue, 23 May 2017 12:56:32 +0200
MIME-Version: 1.0
In-Reply-To: <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

On 23/05/2017 01:09, Carlos Maiolino wrote:
> 
> If you want that XFS shut down when it hits an error, you can configure it
> through sysfs in:
> 
> /sys/fs/xfs/<dev>/error/
> 
> directory.
> 
> You can find detailed info in Documentation/filesystems/xfs.txt (from linux
> source).

Very useful documentation, thank you.

> 
> Although, I should say this is a bad idea. A full thin pool will return an
> ENOSPC error to the filesystem, and, the filesystem should act accordingly.
> 
> Would you want the filesystem to shut down because it hit an ENOSPC, or report
> to the user and let him/her to take the appropriate action, like freeing space
> or increasing the dm-thin pool size?

Does a full thin pool *really* report a ENOSPC? On all my tests, I 
simply see "buffer i/o error on dev" on dmesg output (see below). How 
can I see if a ENOSPC was returned?
> The behavior really depends on several configurations, including how dm-thin
> will deal with ENOSPC situations, dm-thin can be configured to queue new
> incoming IOs, fail the IO, etc, but, even in a full disk situation, you can
> still rewrite data, so this behavior doesn't change much from what would happen
> if you fill up a regular block device, XFS will try to allocate a new block, the
> block device returns an ENOSPC and XFS acts accordingly.

I am testing with "errorwhenfull=y" when thin pool fills.

> What exactly do you mean by failed data update? As long as you don't need to
> allocate any new block either for data of metadata, you should be able to rewrite
> data normally if the device is full.

I refer to update for which the metadata write completes successfully 
(ie: they are writen to already-allocated space), but the data writeout 
does *not* (ie: new data require a new allocation, which it fails).

> How dm-thin and XFS will work together, really depends on how you configure both
> of them. XFS has a configuration system that you can use to set how it will
> behave in some error situations according to your preferences, it can be set to
> retry the writes for a specific amount of time, or simply fail immediately and
> shut down the filesystem.

Ok, I need some some testing ;)

> Worth to mention though, there is a bug that might be triggered when you
> overcommit the space (creates a virtual device larger than the real physical
> space), it's not too easy to trigger it though, and the fix is already WIP.

Can you link to the bug?

Thanks a lot.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
