Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:38544 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbeCPR7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Mar 2018 13:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxg=tK7fBCVuh74jzfYs99bp3XOSEUphpC01saCdEooLBA@mail.gmail.com>
References: <CAOQ4uxg=tK7fBCVuh74jzfYs99bp3XOSEUphpC01saCdEooLBA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Mar 2018 19:59:02 +0200
Message-ID: <CAOQ4uxiLDK8Y90KaWjOD2A9gc1Hw37EwfFLiAKqthv2VqBWq6w@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Mar 16, 2018 at 4:05 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Hi guys,
>
> I am trying to get a lower bound for unused inode number MSB on
> a mounted xfs super block, so I can publish it on struct super_block.
>
> This doesn't need to be a tight lower bound, but it needs to be
> a loewr bound that cannot change with growfs nor when
> remounting with different options (i.e. inode64).
>
> This is needed for overlayfs to be able to use the unused upper bits
> for overlayfs inode number namespace (see [1]).
>
> I realize that for a given agcount, a "soft" lower bound of unused
> upper bits is agno_log-agblklog-inopblog, which makes the "hard"

Hmm, I copied that typo from the comment in xfs_format.h.
Unless I am missing something the amount of unused upper bits
is 64 - agno_log - agblklog - inopblog. Hence the "hard" limit below:

> lower bound 32-agblklog-inopblog, so I think I can use this number.
>
> I was staring at this definition and tried to figure out where this
> absolute limit of 56 used bits came from:
>  #define XFS_MAXINUMBER          ((xfs_ino_t)((1ULL << 56) - 1ULL))
>
> Is this number really correct? If yes, then where does the constrain
> on maximum 56 bits come from?
>
> Thanks,
> Amir.
>
> [1] https://marc.info/?l=linux-unionfs&m=151007386419753&w=2
