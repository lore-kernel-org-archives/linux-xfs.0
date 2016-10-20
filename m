Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36786 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbcJTWcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2016 18:32:50 -0400
Received: by mail-it0-f44.google.com with SMTP id 139so186696868itm.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2016 15:32:49 -0700 (PDT)
MIME-Version: 1.0
From: "Jared D. Cottrell" <jcottr@gmail.com>
Date: Thu, 20 Oct 2016 15:32:48 -0700
Message-ID: <CACQR=w17PSW8eNPr-ynPb2pB6UJPKCdPtfMYP-OCbaboo9HNzQ@mail.gmail.com>
Subject: Periodic fstrim job vs mounting with discard
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

We've been running our Ubuntu 14.04-based, SSD-backed databases with a
weekly fstrim cron job, but have been finding more and more clusters
that are locking all IO for a couple minutes as a result of the job.
In theory, mounting with discard could be appropriate for our use case
as file deletes are infrequent and handled in background threads.
However, we read some dire warnings about using discard on this list
(http://oss.sgi.com/archives/xfs/2014-08/msg00465.html) that make us
want to avoid it.

Is discard still to be avoided at all costs? Are the corruption and
bricking problems mentioned still something to be expected even with
the protection of Linux's built-in blacklist of broken SSD hardware?
We happen to be using Amazon's in-chassis SSDs. I'm sure they use
multiple vendors but I can't imagine they're taking short-cuts with
cheap hardware.

If discard is still strongly discouraged, perhaps we can approach the
problem from the other side: does the slow fstrim we're seeing sounds
like a known issue? After a bunch of testing and research, we've
determined the following:

Essentially, XFS looks to be iterating over every allocation group and
issuing TRIM s for all free extents every time this ioctl is called.
This, coupled with the facts that Linux=E2=80=99s interface to the TRIM
command is both synchronous and does not support a vectorized list of
ranges (see: https://github.com/torvalds/linux/blob/3fc9d690936fb2e20e18071=
0965ba2cc3a0881f8/block/blk-lib.c#L112),
is leading to a large number of extraneous TRIM commands (each of
which have been observed to be slow, see:
http://oss.sgi.com/archives/xfs/2011-12/msg00311.html) being issued to
the disk for ranges that both the filesystem and the disk know to be
free. In practice, we have seen IO disruptions of up to 2 minutes. I
realize that the duration of these disruptions may be controller
dependent. Unfortunately, when running on a platform like AWS, one
does not have the luxury of choosing specific hardware.

EXT4, on the other hand, tracks blocks that have been deleted since
the previous FITRIM ioctl and targets subsequent TRIM s to the
appropriate block ranges (see:
http://blog.taz.net.au/2012/01/07/fstrim-and-xfs/). In real-world
tests this significantly reduces the impact of fstrim to the point
that it is un-noticeable to the database / application.

For a bit more context, here's a write-up of the same issue we did for
the MongoDB community:

https://groups.google.com/forum/#!topic/mongodb-user/Mj0x6m-02Ms

Regards,


Jared
