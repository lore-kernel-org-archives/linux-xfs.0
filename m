Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:32825 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751988AbdFSWRB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2017 18:17:01 -0400
Received: by mail-ua0-f178.google.com with SMTP id 70so2271189uau.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2017 15:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170617235751.GH17542@dastard>
References: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
 <1497624680-16685-7-git-send-email-agruenba@redhat.com> <20170617235751.GH17542@dastard>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 20 Jun 2017 00:16:59 +0200
Message-ID: <CAHc6FU78gW2UYC3VbZVBRHXy_geV0emL=mpd=KQsXTfqhLj0mg@mail.gmail.com>
Subject: Re: [PATCH 6/7] xfs: Switch to iomap for lseek SEEK_HOLE / SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Bob Peterson <rpeterso@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel <cluster-devel@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sun, Jun 18, 2017 at 1:57 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jun 16, 2017 at 04:51:19PM +0200, Andreas Gruenbacher wrote:
>> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>> ---
>>  fs/xfs/xfs_file.c | 17 ++---------------
>>  1 file changed, 2 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 5fb5a09..b36dcd7 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1283,28 +1283,15 @@ xfs_seek_hole_data(
>>       struct xfs_inode        *ip = XFS_I(inode);
>>       struct xfs_mount        *mp = ip->i_mount;
>>       uint                    lock;
>> -     loff_t                  offset, end;
>> -     int                     error = 0;
>> +     loff_t                  offset;
>>
>>       if (XFS_FORCED_SHUTDOWN(mp))
>>               return -EIO;
>>
>>       lock = xfs_ilock_data_map_shared(ip);
>> -
>> -     end = i_size_read(inode);
>> -     offset = __xfs_seek_hole_data(inode, start, end, whence);
>> -     if (offset < 0) {
>> -             error = offset;
>> -             goto out_unlock;
>> -     }
>> -
>> -     offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
>> -
>> -out_unlock:
>> +     offset = iomap_seek_hole_data(file, start, whence, &xfs_iomap_ops);
>>       xfs_iunlock(ip, lock);
>>
>> -     if (error)
>> -             return error;
>>       return offset;
>>  }
>
> Doesn't this change the way data in unwritten extents is reported?
> i.e. we current report unwritten extents as holes if there is no
> data pending writeback over the range in the page cache, and as
> data if there is data in the page cache.
>
> I don't see this page cache lookup for unwritten extents implemented
> in iomap_seek_hole_data() - it only reports extents mapped as holes
> as holes. Hence this will now always report unwritten extents as
> data . This strikes me as a regression as we currently report them
> as a hole:
>
> $ xfs_io -f -c "truncate 1m" -c "falloc 0 1m" -c "seek -a -r 0" foo
> Whence  Result
> HOLE    0
> $

Indeed, thanks for pointing this out.

> I'm pretty sure that ext4 has the same behaviour when it comes to
> dirty page cache pages over unwritten extents.

That's correct as well.

The code in xfs and ext4 looks similar enough that we can implement
this generically in the iomap_seek_hole_data helper, I believe.

Thanks,
Andreas
