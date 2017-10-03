Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:43662 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdJCSLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 14:11:00 -0400
Received: by mail-qk0-f181.google.com with SMTP id w134so9134608qkb.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2017 11:10:59 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Suggested XFS setup/options for 10TB file system w/ 18-20M files.
From: "R. Jason Adams" <rjasonadams@gmail.com>
In-Reply-To: <20171002231420.GI3666@dastard>
Date: Tue, 3 Oct 2017 14:10:57 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <2F69CA38-6029-4D9B-BA3C-FD793E613693@gmail.com>
References: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
 <20171002231420.GI3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

>=20
> With 4k directory block size and your write heavy workload, you
> could get away with just 10 directories. However, it'd probably be
> better to use a single level 100-directory wide hash to bring to
> down to less than 200k files per directory=E2=80=A6.


Moved over to single level with 100 directories.=20


> Small files should be a single extent, so there's heaps of room for
> a 200 byte xattr in the inode. using 512 byte inodes will half
> memory demand for caching inode buffers=E2=80=A6.

Moved to 512 byte inodes.

> In general, use the defaults and don't add anything extra unless you
> know it solves a specific problem you've witnessed in testing=E2=80=A6

Moved to the defaults.

>=20
> Most likely going to be metadata writeback of inode buffers
> requiring RMW based on experience with gluster and ceph having
> exactly the same problems.  Use blktrace to identify what the reads
> are, and see if those same blocks are written later on. An io marked
> a "M" is a metadata IO. Post the blktrace output of the bits you
> find relevant.

Reformated the drive and it's refilling. With the changes suggested (100 =
dir, 512 nodes, defaults) it already seems better. We=E2=80=99re =
currently at 6% full and the reads are quite a bit less than they were =
before at similar fullness. One thing I=E2=80=99m noticing in Grafana, =
the read request/s seem to keep increasing (up to ~8/s) for around an 15 =
minutes, then they drop down 1/s for 10-15 minutes.. then over the next =
15 minutes they build back up.. etc

> FWIW, how much RAM do you have in the system, and what does 'echo
> 200 > /proc/sys/fs/xfs/xfssyncd_centisecs' do to the behaviour?

System has 24G of ram. I=E2=80=99m guessing a move to 96 or 192G would =
help a lot.. in the end the system will have 36 of these 10TB drives.

I want to thank you and Eric for the time you=E2=80=99ve taken to help. =
Feels good to make some progress on this issue.

-R. Jason Adams

