Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:57287 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdITBIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 21:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <20170920004012.GN10621@dastard>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxi4Zf8WJQ6zotVF_K6BxuQJ9EsfGL4uY1TaBLMiLP-JHw@mail.gmail.com>
 <20170918171144.GD6540@magnolia> <CAOQ4uxjiB9PHxzdz5rHv8h+b-pC0BjPKf+zvLeETU7BPKeoNww@mail.gmail.com>
 <20170918212453.GI10621@dastard> <CAOQ4uxhUTZtsX9pW1hdZ4VLzhaVKH3iA8ScG=KVXcYS1Wr4e9Q@mail.gmail.com>
 <20170920004012.GN10621@dastard>
From: Vijay Chidambaram <vvijay03@gmail.com>
Date: Tue, 19 Sep 2017 20:08:01 -0500
Message-ID: <CAPaz=E+7=rDnSbi3E-vfUwKecrHSPREDkff-JJdTbWfvtpucpg@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Greg KH <greg@kroah.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

>> Are those tests in xfstests or any other public repository?
>
> crash/xfscrash is, and now dm-log-write, but nothing else is.
>

There's also CrashMonkey (tool under active development from my
research group at UT Austin) at:
https://github.com/utsaslab/crashmonkey.

>> My first reaction to the corruption was "no way, I need to check the test"
>> Second reaction after checking the test was "this must very very hard to hit"
>> But from closer inspection, it looks like it doesn't take more than running
>> a couple of fsync in parallel to get to the "at risk" state, which may persist
>> for seconds.
>
> That may be the case, but the reality is we don't have a body of
> evidence to suggest this is a problem anyone is actually hitting. In
> fact, we don't have any evidence it's been seen in the wild at all.

Even if people did hit this bug in the wild, as Amir suggested before,
the chances of them connecting it to a crash-consistency bug in the
file system and reporting as such are extremely low. We do have many
reports of data loss in newer file systems like btrfs, but I don't
think those are connected back to crash-consistency bugs (my suspicion
is there would be many such bugs, simply due to inadequate crash
consistency testing).

When working on CrashMonkey, we find it hard to understand what a
crash consistency bug is, even when we are the ones producing the bug!
I think there is a need for good debugging/investigative tools in this
area (something we are also working on).

Thanks,
Vijay
http://www.cs.utexas.edu/~vijay/
