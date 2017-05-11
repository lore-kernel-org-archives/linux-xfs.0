Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34204 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932514AbdEKO4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 10:56:48 -0400
MIME-Version: 1.0
In-Reply-To: <20170511140223.GA16241@infradead.org>
References: <20170511124932.226016-1-arnd@arndb.de> <20170511140223.GA16241@infradead.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 11 May 2017 16:56:41 +0200
Message-ID: <CAK8P3a31impdu8_i6TNjfnPwj-Pv=dy2P=-LW=4xt6-8Aw+4Ag@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid harmless gcc-7 warnings
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Calvin Owens <calvinowens@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, May 11, 2017 at 4:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, May 11, 2017 at 02:49:21PM +0200, Arnd Bergmann wrote:
>> gcc-7 flags the use of integer math inside of a condition
>> as a potential bug:
>>
>> fs/xfs/xfs_bmap_util.c: In function 'xfs_swap_extents_check_format':
>> fs/xfs/xfs_bmap_util.c:1619:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
>> fs/xfs/xfs_bmap_util.c:1629:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
>>
>> This one is clearly fine, and we can add a comparison to zero
>> to shut up the warning.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  fs/xfs/xfs_bmap_util.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 2b954308a1d6..cbd3ffe42f39 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1613,7 +1613,7 @@ xfs_swap_extents_check_format(
>>        * extent format...
>>        */
>>       if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
>> -             if (XFS_IFORK_BOFF(ip) &&
>> +             if ((XFS_IFORK_BOFF(ip) != 0) &&
>
> Even if we were fine with fixing this odd warning the additional braces
> are simply bogus.

The warning seems generally useful and is enabled by default in gcc-7.
An example of a real bug it found is
https://patchwork.kernel.org/patch/9431813/, so I'd prefer to leave it
enabled and fix the few instances in the kernel.

I found a better way to rework the code to avoid the warning, sending
out v2 now.

    Arnd
