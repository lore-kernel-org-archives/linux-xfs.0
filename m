Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32773 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936136AbeFORa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 13:30:29 -0400
Received: by mail-lf0-f66.google.com with SMTP id y20-v6so15751738lfy.0
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 10:30:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180614233551.GN10363@dastard>
References: <20180614221646.20017-1-mbenatto@redhat.com> <1ddae533-b040-fdba-4350-01b59d5ddcba@sandeen.net>
 <20180614233551.GN10363@dastard>
From: Marco Benatto <mbenatto@redhat.com>
Date: Fri, 15 Jun 2018 14:30:27 -0300
Message-ID: <CAOGQQ28c_qfp6Mjt13v0jK7tYVuvL-1j+dbya6iRwUhqmfii8A@mail.gmail.com>
Subject: Re: [PATCH] xfs_repair: Fix root inode's parent when it's bogus for
 sf directory
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Thu, Jun 14, 2018 at 8:35 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 14, 2018 at 05:20:56PM -0500, Eric Sandeen wrote:
>> On 6/14/18 5:16 PM, Marco Benatto wrote:
>> > Currently when root inode is in short-form and its parent ino
>> > has an invalid value, process_sf_dir2() ends up not fixing it,
>> > because if verify_inum() fails we never get to the next case which
>> > would fix the root inode's parent pointer.
>> >
>> > This behavior triggers the following assert on process_dir2():
>> >
>> >    ASSERT((ino != mp->m_sb.sb_rootino && ino != *parent) ||
>> >         (ino == mp->m_sb.sb_rootino &&
>> >         (ino == *parent || need_root_dotdot == 1)));
>> >
>> > This patch fixes this behavior by making sure we always properly
>> > handle rootino parent pointer in process_sf_dir2()
>> >
>> > Signed-off-by: Marco Benatto <mbenatto@redhat.com>
>>
>> This looks correct to me, thanks.
>>
>> FWIW the problem can be demonstrated by setting the root inode's
>> parent to 0 on a freshly made fs:
>>
>> # mkfs.xfs -f -dfile,name=fsfile,size=1g
>> # xfs_db -x -c "sb 0" -c "addr rootino" -c "write u3.sfdir3.hdr.parent.i4 0" fsfile
>> # xfs_repair fsfile
>
> xfstest please (also to check that xfs_scrub detects it)?

Sure, working on this. I'll send you once it's done.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



Cheers,

-- 
Marco Benatto
