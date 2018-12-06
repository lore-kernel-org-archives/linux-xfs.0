Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45082 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbeLFREo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Dec 2018 12:04:44 -0500
Received: by mail-lf1-f68.google.com with SMTP id b20so875942lfa.12
        for <linux-xfs@vger.kernel.org>; Thu, 06 Dec 2018 09:04:43 -0800 (PST)
MIME-Version: 1.0
References: <20181105213145.7560-1-stefanrin@gmail.com>
In-Reply-To: <20181105213145.7560-1-stefanrin@gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Thu, 6 Dec 2018 18:04:33 +0100
Message-ID: <CAAxjCExC1iysfNx7PE-xd5yRhZiexA3vmoWyHRDb43pFBt8enQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] Try to squash metadump data leaks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Mon, Nov 5, 2018 at 10:32 PM Stefan Ring <stefanrin@gmail.com> wrote:
>
> Another round... I'm starting to feel quite confident about it this time.
>
> Since last time:
>
> - Fixed the attribute corruption in the last patch.
> - Changed the accidental 'a' and 'b' I had left in the code back to zeroes.
> - Brought the flag for crc recalc a tiny bit more in line with the single_fsb code.
> - Fixed the wrong control flow in the interim patch which duplicates a TODO comment in the code only to get rid of it in the next patch.
>
>
> Stefan Ring (5):
>   xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_MAGIC blocks
>   xfs_metadump: Zap multi fsb blocks
>   xfs_metadump: Zap freeindex blocks in directory inodes
>   xfs_metadump: Zap unused space in inode btrees
>   xfs_metadump: Zap dev inodes
>
>  db/metadump.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 113 insertions(+), 15 deletions(-)

Is this an appropriate time interval for pinging?
