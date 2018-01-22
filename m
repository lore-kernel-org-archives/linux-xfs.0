Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:44908 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbeAVU2x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jan 2018 15:28:53 -0500
Received: by mail-yb0-f176.google.com with SMTP id z90so3743750ybh.11
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2018 12:28:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+0CQ228zZwk0XqR2a0fD49tbfZ=NHxsv=W=EScMU4u7Ng6F2w@mail.gmail.com>
References: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
 <20180116075541.GO5602@magnolia> <CA+0CQ21tLBLFfnn_ngY-arVzXAOyZU1XSuDu9RAjAo6VfK2PoA@mail.gmail.com>
 <CAOQ4uxgKonrPQLSaxhL5ok=NEVT9XAatTab4BsQt9tA7gNBJ2g@mail.gmail.com> <CA+0CQ228zZwk0XqR2a0fD49tbfZ=NHxsv=W=EScMU4u7Ng6F2w@mail.gmail.com>
From: Austin Schuh <austin@peloton-tech.com>
Date: Mon, 22 Jan 2018 12:28:32 -0800
Message-ID: <CANGgnMb5JSxsSw725COJD3vcEZOdSt+RmJfKQVAVru4O-x-J9Q@mail.gmail.com>
Subject: Re: Reproducible XFS filesystem artifacts
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Philipp Schrader <philipp@peloton-tech.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Alison Chaiken <alison@peloton-tech.com>, Theodore Tso <tytso@mit.edu>

On Mon, Jan 22, 2018 at 11:45 AM, Philipp Schrader
<philipp@peloton-tech.com> wrote:
> On Tue, Jan 16, 2018 at 8:05 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> So I'm curious. Why xfs and fat and not, say, squashfs?
>> https://reproducible-builds.org/events/athens2015/system-images/
>
> It's a good question. It's largely because of historical reasons
> internally. We started with XFS on the first iteration of our product.
> We fixed a few minor bugs and were overall really happy with
> performance etc. Later down the line came the question of system
> upgrades without breaking what we currently had. Anyway, so XFS is
> where we're at today.
>
> That being said, for the future something like squashfs is definitely
> a better choice. Thanks for the suggestion. I'll do more research on
> that.

Adding to the historical reasons list, we've got a lot of test time
with XFS and CONFIG_PREEMPT_RT, and it's working well for us.  That's
always very hard to quantify when making a decision whether or not to
switch filesystems.

Austin
