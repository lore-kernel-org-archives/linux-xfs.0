Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbcJGMaY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 08:30:24 -0400
Date: Fri, 7 Oct 2016 20:29:49 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] fstests: fix failures caused by striped device
Message-ID: <20161007122949.GK27776@eguan.usersys.redhat.com>
References: <1475336934-19105-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475336934-19105-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, Oct 01, 2016 at 11:48:54PM +0800, Zorro Lang wrote:
> There're some failures if scratch_dev is a  striped device:
>   1. generic/094 and generic/225 fiemap_tester fails.
>   2. generic/347 need -f to force usage of a misaligned device
>   3. xfs/010, xfs/013, xfs/042 and xfs/109 print "Warning: AG size
>      is a multiple of stripe width", break the golden image
>   4. xfs/029 print more "extended-header"
> 
> Only XFS can reproduce these failures, so this patch:
>   1. use "-d sunit=0,swidth=0,noalign" options for generic/094,
>      generic/225 and xfs/029.

I'm not sure about this, is it possible to update fiemap_tester.c to
deal with stripes or just _notrun in such cases? I'm waiting for great
ideas too :)

>   2. print the error output of mkfs.xfs to /dev/null forr xfs/010,
>      xfs/013, xfs/042 and xfs/109

This looks good to me.

>   3. add -f option for generic/347

And this breaks test on ext4, not all mkfs.<fstype> support -f option.

Thanks,
Eryu
