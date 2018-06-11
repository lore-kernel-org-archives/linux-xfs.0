Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39951 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932516AbeFKNLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 09:11:38 -0400
Received: by mail-pf0-f194.google.com with SMTP id z24-v6so10213208pfe.7
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 06:11:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACdnJutbRW4wV7QAwS9s-=p1dd7mYkHqEX1NBkEXiD+oBV3-xw@mail.gmail.com>
References: <000000000000457b2d056cbb0044@google.com> <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard> <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia> <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net> <20180523234114.GA3434@thunk.org>
 <20180524004931.GB23861@dastard> <CACdnJutbRW4wV7QAwS9s-=p1dd7mYkHqEX1NBkEXiD+oBV3-xw@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 11 Jun 2018 15:11:17 +0200
Message-ID: <CACT4Y+bnOt5pCv5BvQ_AQHdvLSNKZSrw+w4Aa5YJRFNy4o0jww@mail.gmail.com>
Subject: Re: Bugs involving maliciously crafted file system
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Garrett <mjg59@google.com>
Cc: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

On Wed, May 30, 2018 at 10:51 PM, 'Matthew Garrett' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
> On Wed, May 30, 2018 at 1:42 PM Dave Chinner <david@fromorbit.com> wrote:
>> We've learnt this lesson the hard way over and over again: don't
>> parse untrusted input in privileged contexts. How many times do we
>> have to make the same mistakes before people start to learn from
>> them?
>
> You're not wrong, but we haven't considered root to be fundamentally
> trustworthy for years - there are multiple kernel features that can be
> configured such that root is no longer able to do certain things (the
> one-way trap for requiring module signatures is the most obvious, but
> IMA in appraisal mode will also restrict root), and as a result it's
> not reasonable to be worried only about users - it's also necessary to
> prevent root form being able to deliberately mount a filesystem that
> results in arbitrary code execution in the kernel.

FWIW, Android also does not consider root as trusted entity. It's
limited by SELinux and maybe something else. Kernel becomes the main
attack target on Android. Even if attackers get root, they still go
for kernel execution or kernel data corruption to do anything harmful.
And kernel is exploited with use-after-frees, out-of-bounds,
double-frees, etc.
