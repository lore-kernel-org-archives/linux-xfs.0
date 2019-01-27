Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42528 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfA0IAk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Jan 2019 03:00:40 -0500
MIME-Version: 1.0
References: <20190124083310.25928-1-amir73il@gmail.com> <20190124083310.25928-2-amir73il@gmail.com>
 <20190127050217.GL2713@desktop>
In-Reply-To: <20190127050217.GL2713@desktop>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 27 Jan 2019 10:00:28 +0200
Message-ID: <CAOQ4uxiup2OxAnHrLRTzNQgoDCXDv26xhz3+Pev4TMVDJ8Vy9g@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs/068: Add fsstress generated file count to golden output
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jan 27, 2019 at 7:02 AM Eryu Guan <guaneryu@gmail.com> wrote:
>
> [I'm sorry that I've been absent from the discussion entirely.. I was
> busy with other tasks recently.]
>
> On Thu, Jan 24, 2019 at 10:33:10AM +0200, Amir Goldstein wrote:
> > This test has the number of files/dirs created by fsstress hardcoded
> > in golden output.
>
> This leads me to wonder if we could remove the hardcoded dir/entries
> number from the golden output and verify the counts on the fly? i.e. we
> count the dir/entries numbers that fsstress created and compare them
> with the numbers xfsrestore reports. So we don't have to worry about new
> ops in fsstress and xfs configurations.
>

posted v2 with a slightly different approach:
count the dir/entries numbers that fsstress created and compare them
with the *actual* numbers xfsrestore created instead of the numbers that
xfsrestore reports.

Sure, this removes test coverage for the accuracy of the report, but
that was really never the intention of the test and the report is really
wrong! (off by one dir from actual restored).

If someone really cares about validating the accuracy of xfsrestore report
in that test, that by all means, let someone read into xfsrestore and figure
out what the one directory stands for and either fix xfsrestore or work that
quirk into the test. As can be inferred, that someone is not going to be me.

Thanks,
Amir.
