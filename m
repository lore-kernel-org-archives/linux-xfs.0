Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45492 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751084AbdIMPRb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Sep 2017 11:17:31 -0400
Subject: Re: backport request/question
References: <CAGbvivJv=qSRA6Vm2ggjpYcg59gXA0YroYcUHmsJXUfqodtzjQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a83ed475-2822-c502-9ecc-12fcf97d5a17@sandeen.net>
Date: Wed, 13 Sep 2017 10:17:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAGbvivJv=qSRA6Vm2ggjpYcg59gXA0YroYcUHmsJXUfqodtzjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>, linux-xfs@vger.kernel.org

On 9/13/17 9:48 AM, Wyllys Ingersoll wrote:
> Are the recent XFS fixes in the 4.13 kernel planned for backport to
> 4.12 or 4.9 kernels?
> 
> Im specifically interested in "xfs: don't crash on unexpected holes in
> dir/attr btrees" as it fixed critical problems triggered by ceph OSD
> processes running on XFS disks.
> 
> 
> -Wyllys Ingersoll
>  Keeper Technology

The commit itself does not cc: stable, so it won't be automatic.  It will
likely be up to an interested party to submit it to the stable kernel.

Upstream developers are generally just that, and don't have the bandwidth
to curate patches for older -stable kernels.

If you'd like to send it to stable yourself, the process is outlined in
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/stable-kernel-rules.rst

-Eric

-Eric
