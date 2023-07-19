Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B825C001DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 20:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjGSUbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 16:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjGSUbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 16:31:09 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436701FD6
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 13:30:40 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8F2243200368;
        Wed, 19 Jul 2023 16:29:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 19 Jul 2023 16:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1689798559; x=1689884959; bh=u2
        YVSGAGtpFTna622Jhr7hM3YqFVfXqe8o57wA0bWZA=; b=muZ8QcA1Th2PVS1ljK
        iGBU98eHsl0dCrPpLfVu5Cme3yl4UZg2uhu6VWCAIY96b/4RI4ThnNmZiGp7oFR/
        dsnq0y/S/E5ng54+L5ffyaFi3h9DZ+nVwyP+nCqxdi3ZHWPb6UbwG5Am3KuJKj9w
        6s5MN+St+4P/jhD7CPdiQAzLexvkkYczwW2OgxXGoTrmIqslHDpt7ZuNA2whaTwr
        eE2u6Y3jZvV7o4eHUF8ZM5b7Sjx8TS2M+HWWhKUr9PhS8ExRMDIW9Jlp0C+Vw3Bh
        11VScaVz8BmHsR6ncXeBugWsjcV4rOTXJ715LrzkcZ0PIjOi2jOgtJ2ESYP2YsbB
        zCKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1689798559; x=1689884959; bh=u2YVSGAGtpFTn
        a622Jhr7hM3YqFVfXqe8o57wA0bWZA=; b=XyL3JGKCP681EkpEYtxERy5nomXzS
        ZhnqKlBVn9CjqS97bA/kyk5fCXiKgO+c8HQE5luz5UWTxCsjX7NbJH6oAqu/IxCE
        R8Jg4VIOL67tJFvbhU5TWn8/2zGiJrs/hIoAOKRK6qhEToz8mllSCPIuRjri3ps2
        pRjFAL1QOBtCPe52kAXP09UZgDAGlvmRAmt/W/Md5VEUyrtCjxzAxdBtw/rIPqSg
        7m4MWlYioc1csQXj4Ah1rT/SVDz8KY1X4xXmMV5kp/iHVJKJ5bkyqbxwL0gi+VB4
        jtvPOpDLJ8qRtXpaQo8l2w30rFIBWouD1VAcBWwFtoU+KxAe5IxB+6lBA==
X-ME-Sender: <xms:nke4ZOMs68v3GIPrcHj1rf75bCu3GRjCjkRFRFznPDdshhIVs779bg>
    <xme:nke4ZM8qsKBDo6Hk573JZM_X10FRyQe4kz_nKmEZgCMXz1A1a2cC_Vp7gKva65_Kk
    XzqNpgvYyxQMmMEzA>
X-ME-Received: <xmr:nke4ZFSMrKH4R7GMW5_oehe4cZ0bgdsC55YQ0oxJI34t-0d7cC7-QeyJFGCT4Z9FzqaWm8L91Re-vXYK7HdGlGJC3XAfpWgvGBGPr0wn9EDXExgBJL2YYRN_xFEs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrgeekgddufeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepvdfffeevhfetveffgeeiteefhfdtvdffjeevhfeuteegleduheetvedu
    ieettddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:nke4ZOuj3laf_fG-YpaNckvI4Gc6cWGtJamUOENoHx4u-mzh7ixnuw>
    <xmx:nke4ZGex-CZPPHjwHkVEkgSem-nskpQRx452fYR__RIhZntk1l3pnw>
    <xmx:nke4ZC2vIGVbbhtO-ZIBXzyAJfiojgfqGRCoP-SWBj2lpz2img7ujA>
    <xmx:n0e4ZHrk69U1nsqJn_c_wG2UfNNgH7YMdTBry84KX55IgZuBWtq4Hw>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Jul 2023 16:29:18 -0400 (EDT)
Date:   Wed, 19 Jul 2023 13:29:17 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Masahiko Sawada <sawada.mshk@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
Message-ID: <20230719202917.qkgtvk43scl4rt2m@awork3.anarazel.de>
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
 <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
 <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
 <20230711224911.yd3ns6qcrlepbptq@awork3.anarazel.de>
 <ZLeP8VwYuXGKYC/Z@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLeP8VwYuXGKYC/Z@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On 2023-07-19 17:25:37 +1000, Dave Chinner wrote:
> On Tue, Jul 11, 2023 at 03:49:11PM -0700, Andres Freund wrote:
> > The goal is to avoid ENOSPC at a later time. We do this before filling our own
> > in-memory buffer pool with pages containing new contents. If we have dirty
> > pages in our buffer that we can't write out due to ENOSPC, we're in trouble,
> > because we can't checkpoint. Which typically will make the ENOSPC situation
> > worse, because we also can't remove WAL / journal files without the checkpoint
> > having succeeded.  Of course a successful fallocate() / pwrite() doesn't
> > guarantee that much on a COW filesystem, but there's not much we can do about
> > that, to my knowledge.
> 
> Yup, which means you're screwed on XFS, ZFS and btrfs right now, and
> also bcachefs when people start using it.

I'd be happy to hear of a better alternative... fallocate() should avoid
ENOSPC on XFS unless snapshots trigger COW on a write, correct?


> > Using fallocate() for small extensions is problematic because it a) causes
> > We're also working on using DIO FWIW, where using fallocate() is just about
> > mandatory...
> 
> No, no it isn't. fallocate() is even more important to avoid with
> DIO than buffered IO because fallocate() completely serialises *all*
> IO to the file. That's the last thing you want with DIO given the
> only reason for using DIO is to maximising IO concurrency and
> minimise IO latency to individual files.

Not using any form of preallocation (potentially via extent size hints as you
mention below), when multiple files are being appended to simultaneously with
DIO, does lead to terrifying levels of fragmentation on xfs.

On a newly initialized xfs (mkfs.xfs version 6.3.0, 6.5.0-rc2):

rm -f fragtest-* && fio --minimal --name fragtest-1 --buffered=0 --filesize=128MB --fallocate=none --rw write --bs=$((4096*4)) --nrfiles=10

filefrag fragtest-1.0.*

fragtest-1.0.1: 8192 extents found
fragtest-1.0.2: 8192 extents found
fragtest-1.0.3: 8192 extents found
fragtest-1.0.4: 8192 extents found
fragtest-1.0.5: 8192 extents found
fragtest-1.0.6: 8192 extents found
fragtest-1.0.7: 8192 extents found
fragtest-1.0.8: 8192 extents found
fragtest-1.0.9: 8192 extents found

On a more "aged" filesystem, it's not quite as regular, but still above 7k
extents for all files.  Similarly, if I use io_uring for more concurrent IOs,
there's a bit less fragmentation, presumbly because sometimes two IOs for the
same file happen in subsequently.


Of course just writing four blocks at a time is a bit extreme, I wanted to
showcase the issue here, but even with a bit bigger writes, the problem is
still severe.  Writing multiple files at the same time is extremely common for
us (think of table and its indexes, or multiple partitions of a table being
filled concurrently).

It looks to me that with a single file being written, each write only
allocates a small extent, but the extent can be extended in subsequent
writes. But when 2+ files are being written, that rarely is possible, because
the space was already used for the other file(s).



> If you want to minimise fragmentation with DIO workloads, then you
> should be using extent size hints of an appropriate size. That will
> align and size extents to the hint regardless of fallocate/write
> ranges, hence this controls worst case fragmentation effectively.

That might be an option, but I'm not sure how realistic it is. Lookes like one
can't adjust the extsize for a file with existing contents, if I see this
correctly. We don't know what data will be how large ahead of time, so we
can't just configure a large extsize and be done with that.

Given the above fragmentation behaviour, and the fact that extsizes can't be
adjusted, I don't really see how we can get away from using fallocate() to
avoid fragmentation.

Then there's also the issue of extsize being xfs specific, without
corresponding fetures in other filesystems...


> If you want enospc guarantees for future writes, then large,
> infrequent fallocate(FALLOC_FL_KEEP_SIZE) calls should be used. Do
> not use this mechanism as an anti-fragmentation mechanism, that's
> what extent size hints are for.

Is there documentation about extent size hints anywhere beyond the paragraphs
in the ioctl_xfs_fsgetxattr(2)? I didn't find much...


> Use fallocate() as *little as possible*.
> 
> In my experience, fine grained management of file space by userspace
> applications via fallocate() is nothing but a recipe for awful
> performance, highly variable IO latency, bad file fragmentation, and
> poor filesystem aging characteristics. Just don't do it.

I'd like to avoid it, but so far experience has shown that that causes plenty
issues as well.


Somewhat tangential: I still would like a fallocate() option that actually
zeroes out new extents (via "write zeroes", if supported), rather than just
setting them up as unwritten extents. Nor for "data" files, but for
WAL/journal files.

Unwrittent extent "conversion", or actually extending the file, makes durable
journal writes via O_DSYNC or fdatasync() unusably slow. So one has to
overwrite the file with zeroes "manually" - even though "write zeroes" would
often be more efficient.

rm -f durable-*;fio --buffered=0 --filesize=32MB --fallocate=1 --rw write --bs=$((8192)) --nrfiles=1 --ioengine io_uring --iodepth 16 --sync dsync --name durable-overwrite --overwrite 1 --name durable-nooverwrite --overwrite 0 --stonewall --name durable-nofallocate --overwrite 0 --fallocate 0 --stonewall

slow-ish nvme:

Run status group 0 (all jobs):
  WRITE: bw=45.1MiB/s (47.3MB/s), 45.1MiB/s-45.1MiB/s (47.3MB/s-47.3MB/s), io=32.0MiB (33.6MB), run=710-710msec

Run status group 1 (all jobs):
  WRITE: bw=3224KiB/s (3302kB/s), 3224KiB/s-3224KiB/s (3302kB/s-3302kB/s), io=32.0MiB (33.6MB), run=10163-10163msec

Run status group 2 (all jobs):
  WRITE: bw=2660KiB/s (2724kB/s), 2660KiB/s-2660KiB/s (2724kB/s-2724kB/s), io=32.0MiB (33.6MB), run=12320-12320msec


fast nvme:

Run status group 0 (all jobs):
  WRITE: bw=1600MiB/s (1678MB/s), 1600MiB/s-1600MiB/s (1678MB/s-1678MB/s), io=32.0MiB (33.6MB), run=20-20msec

Run status group 1 (all jobs):
  WRITE: bw=356MiB/s (373MB/s), 356MiB/s-356MiB/s (373MB/s-373MB/s), io=32.0MiB (33.6MB), run=90-90msec

Run status group 2 (all jobs):
  WRITE: bw=260MiB/s (273MB/s), 260MiB/s-260MiB/s (273MB/s-273MB/s), io=32.0MiB (33.6MB), run=123-123msec


Greetings,

Andres Freund
