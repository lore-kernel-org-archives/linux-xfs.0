Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:46350 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbeEBJyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 05:54:46 -0400
Received: by mail-wr0-f180.google.com with SMTP id o2-v6so10413639wrj.13
        for <linux-xfs@vger.kernel.org>; Wed, 02 May 2018 02:54:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net>
References: <f403043cbe8414177d0568e81405@google.com> <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <20180405213844.GE23861@dastard> <20180406161053.GF7500@magnolia>
 <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com>
 <95c1400b-94f2-1af4-2d5d-c61c274c28ff@sandeen.net> <CACT4Y+aiwgRg5pk+N7bq9HYpgumTFyqG6-y3EZ8pWkq9-uB1aA@mail.gmail.com>
 <9f8d657c-7f42-7bd9-4477-6c3addf16dee@sandeen.net> <CACT4Y+bUx4jw83Ux7w9URL9bCy1ERLaVGTTwvA9Fe_UtLFeqCw@mail.gmail.com>
 <d7c8e0eb-61ed-1aad-6faa-82a0ef8c25b8@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 2 May 2018 11:54:24 +0200
Message-ID: <CACj3i70Dw5=B-k5hKEXpHg5DOhG2Hi-Xb4ZVpZWL+EYdX=jCeQ@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dmitry Vyukov <dvyukov@google.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Mon, Apr 30, 2018 at 5:14 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/30/18 9:02 AM, Dmitry Vyukov wrote:
>> Suggestions are welcome. Currently it says "syzbot hit the following
>> crash on upstream commit SHA1", which was supposed to mean just the
>> state of the source tree when the crash happened. But I am not a
>> native speaker, so perhaps I am saying not what I intend to say.
>>
>> There are also suggestions on report format improvement from +Ted
>> currently in works:
>> https://github.com/google/syzkaller/issues/565#issuecomment-380792942
>> Not sure if they make this distinction 100% clear, though.
>
> Maybe I was the only one who misunderstood, but something like
>

snip

You are not the only one, I (mis)understand it the same as you.

Jan
