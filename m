Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F528EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 08:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjFWIaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 04:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjFWIaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 04:30:10 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA4B2105
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 01:30:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-25edd424306so164386a91.1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 01:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687509007; x=1690101007;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hn0zfldQfegiutsOWnC6DiYOTUjHi4DbT1yTVMIyFWw=;
        b=p9ZB09LTSJmXmvcBP4SLGbgUoOM6C6K3GMw+Gg81P9/M8I9xOCoFBe0VXJw72KxuWx
         /w71bGmzfLnMpmf3xEFo8eDc6cNKsNiVmVCVU9P2UIqDUGV2nRSTWUTUtPSTZ2kjPVlo
         0j9Ncmj3tiF6Sv2qffS3ASedqkdgF3apVH77x1xP19olOjFFfzImapgEVvvj1nA9R8uV
         qpSAqiwWXYqG3Y5jRPKIiZsjfNGiJKTG83Enyp82FFz5oIjUHQLEo7ZXf4oWsvUDIJaZ
         DxvrpOYA+FAfnS5xTU3vlFYPliSCKBz+q3OCnZ3KUaOqFd0Bqqavy2hOlmgk88CAUKL4
         Vm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687509007; x=1690101007;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hn0zfldQfegiutsOWnC6DiYOTUjHi4DbT1yTVMIyFWw=;
        b=QArajP/PVKVXrhRML8/pG+/AcN92LUDeCDaSdtApfaucHCMtcZ9zy4tJM4KIUyuyGd
         MziX4tR+olQ9IvV6kYt7609RbGxYDcWSLhuRaQxVN9r4bv/A4rbKUSi7ECqofqEcCN/0
         UC6emeS6K7RJ/EP+RFDVnPj1XCzXdAzM5RUa0lsH6ObE/2Zi/6ZNv6f+RPrRBf25xCAN
         WbrporqVZBvOYgcJylK8JzjHl9lP+nZ+oJ8b/AeBd7eOUW5S+Xwfy8xFuhPjONlFUTVq
         aLUiF4iIEAz4B8hL9qc1eHY8YXR910AmAgXBcP/7thXSOEA2+8uq9OnaNVx5SaZc3GCs
         6SyA==
X-Gm-Message-State: AC+VfDyoOZX+ayaNKZchbhIaD0uj0ZkXXl3LAODigf8oqAPpqKCUhJna
        MxrhE8IIHEM29dRKde5VAG5pyDWYYOQ=
X-Google-Smtp-Source: ACHHUZ4d0Ybyk0lViNzgqSWUBOeRJ774JNydRC09LIlSqFEBd7u0UqdZAVkttbJ+LU6lHgHBANGnZg==
X-Received: by 2002:a17:90a:eb0c:b0:253:727e:4b41 with SMTP id j12-20020a17090aeb0c00b00253727e4b41mr10224995pjz.34.1687509006589;
        Fri, 23 Jun 2023 01:30:06 -0700 (PDT)
Received: from dw-tp ([49.207.220.159])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a800100b002599ef80ab9sm953306pjn.3.2023.06.23.01.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 01:30:05 -0700 (PDT)
Date:   Fri, 23 Jun 2023 13:59:58 +0530
Message-Id: <874jmy4m49.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     Dave Chinner <david@fromorbit.com>,
        Masahiko Sawada <sawada.mshk@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
In-Reply-To: <ZJTrrwirZqykiVxn@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Thu, Jun 22, 2023 at 02:34:18PM +0900, Masahiko Sawada wrote:
>> Hi all,
>> 
>> When testing PostgreSQL, I found a performance degradation. After some
>> investigation, it ultimately reached the attached simple C program and
>> turned out that the performance degradation happens on only the xfs
>> filesystem (doesn't happen on neither ext3 nor ext4). In short, the
>> program alternately does two things to extend a file (1) call
>> posix_fallocate() to extend by 8192 bytes
>
> This is a well known anti-pattern - it always causes problems. Do
> not do this.
>
>> and (2) call pwrite() to
>> extend by 8192 bytes. If I do only either (1) or (2), the program is
>> completed in 2 sec, but if I do (1) and (2) alternatively, it is
>> completed in 90 sec.
>
> Well, yes. Using fallocate to extend the file has very different
> constraints to using pwrite to extend the file.
>
>> $ gcc -o test test.c
>> $ time ./test test.1 1
>> total   200000
>> fallocate       200000
>> filewrite       0
>
> No data is written here, so this is just a series of 8kB allocations
> and file size extension operations. There are no constraints here
> because it is a pure metadata operation.
>
>> real    0m1.305s
>> user    0m0.050s
>> sys     0m1.255s
>> 
>> $ time ./test test.2 2
>> total   200000
>> fallocate       100000
>> filewrite       100000
>>
>> real    1m29.222s
>> user    0m0.139s
>> sys     0m3.139s
>
> Now we have fallocate extending the file and doing unwritten extent
> allocation, followed by writing into that unwritten extent which
> then does unwritten extent conversion.
>
> This introduces data vs metadata update ordering constraints to the
> workload.
>
> The problem here in that the "truncate up" operation that
> fallocate is doing to move the file size. The "truncate up" is going
> to move the on-disk file size to the end of the fallocated range via
> a journal transaction, and so it will expose the range of the
> previous write as containing valid data.
>
> However, the previous data write is still only in memory and not on
> disk. The result of journalling the file size change is that if we
> crash after the size change is made but the data is not on disk,
> we end up with lost data - the file contains zeros (or NULLs) where
> the in memory data previously existed.
>
> Go google for "NULL file data exposure" and you'll see this is a
> problem we fixed in ~2006, caused by extending the file size on disk
> without first having written all the in-memory data into the file.

I guess here is the <patch> you are speaking of. So this prevents from
exposing nulls within a file in case of a crash.

I guess the behavior is not the same with ext4. ext4 does not seem to be
doing filemap_write_and_wait_range() if the new i_disksize is more than
oldsize. So then I think ext4 must be ok if in case of a crash the
file has nulls in between. That's why I think the observation of slow
performance is not seen in ext4.

Few queres-
- If the user doesn't issue a flush and if the system crashes, then
  anyways it is not expected that the file will have all the data right?

- Also is that "data/inode size update order" which you are mentioning in
  this patch. Is this something that all filesystems should follow?

- I was wondering what exactly it breaks which the applications depend
  upon? Because not all filesystems tend to follow this practice right?


Thanks for the detailed explaination! I got interested in this thread
after looking at your explaination and since the thread mention this
happens with postgres.

-ritesh

<patch>
[XFS] Fix inode size update before data write in xfs_setattr

When changing the file size by a truncate() call, we log the change in the
inode size. However, we do not flush any outstanding data that might not
have been written to disk, thereby violating the data/inode size update
order. This can leave files full of NULLs on crash.

Hence if we are truncating the file, flush any unwritten data that may lie
between the curret on disk inode size and the new inode size that is being
logged to ensure that ordering is preserved.



