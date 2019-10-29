Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE44CA9EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 00:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB7121835
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 00:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="Wk+i2TFk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Nt1P5RmM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfJ2A3p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 20:29:45 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52875 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726777AbfJ2A3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 20:29:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 474FA21F9F;
        Mon, 28 Oct 2019 20:29:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Oct 2019 20:29:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        q3UyBP3pEHF7xYZzQWWdWPuiu0YmLxv8FKR75yGNFck=; b=Wk+i2TFkwmDj+Mnn
        Kcg3uxKXyJFhp4w9c2rI2xeIaZIKVJdqFSMDGq08+C/GPyR9Dy1ezyKLXR61DPu1
        3WrtXGblHWNFvo8KUZyEOcTaMsUcHp+1MHx/9WtmwWOWiBLTrMa/hubL6VKw8PW1
        hqfkchouPPh7tyrOGeUWrUf8U6pLJTxhF4fR3MXCA8g9GxcXNHGRR0GZeRpMrmFw
        sGpWBHqrRnAcwUUlJDwztV/AGjniNfRaYiI2gry9zYS3VolAr0pKzKu+Tb5UO5PF
        S0UaUaxbY/6dN9wugSVqxq5KsOYe31JIwgbUzg0OcE9UF2owkz67mv6EG2GGWtJi
        m/j9/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=q3UyBP3pEHF7xYZzQWWdWPuiu0YmLxv8FKR75yGNF
        ck=; b=Nt1P5RmMHAmRChjQxyuLpVYlCvhMcehTCcffHjP3HT0SLguXQEFICHeft
        7CsXGXAhxjur4czrIfd2e8jhnmu17SUURrWoJ8D3bds24CT+NlF1jvhoWVZ62txm
        NLQUE6ibZFedecM0MjiCa0notG0Sjxv+GJ4UMeBG8Qd4pgKLdPNkCZahol6WYaG/
        EayD5nbRqe1OmA/pN90mUDN5ea0y6KYocphKBbOckeW9qzhQATavP9Un0VSMI8Wp
        2w0ope4xWNZZ+1jCbzr2ZNVs0gjS09Ut9a7AqtwUt8YLO/uxTVVtI7NMFf1uTLOd
        w8MEquZzaRAeU8UT7//YP9/UwqW4g==
X-ME-Sender: <xms:94e3XXvmgqQD4Hl8wProSYUJIyEVUmeCVsJnG0bAsD4zGoYAs_7-oA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddttddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucffohhmrghinhepkhgvrh
    hnvghlrdhorhhgnecukfhppeduudekrddvtdekrddukeejrdefvdenucfrrghrrghmpehm
    rghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:94e3XcuZV2uRcrdC8w0BRv7z8MKdxPCXo-lO6ftih-YdvufeRqkSPw>
    <xmx:94e3XVzKR_u2V3ELxhomGuTbWJsqsvYyhNgOqQWcmyn3bwGDVIWHYg>
    <xmx:94e3XajaLuGPUdut_55QthIvoBkAlDbSHy3V-JFs1kfU0jeUDJ3MAg>
    <xmx:-Ie3Xa44chiJ0rVxhl0l9qrt4kRp_Lht0NLueexurZipTZPh0Be43A>
Received: from mickey.themaw.net (unknown [118.208.187.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 439E7D60065;
        Mon, 28 Oct 2019 20:29:41 -0400 (EDT)
Message-ID: <b6a64fa89ab24912b840c0772c2ffa615c0c6118.camel@themaw.net>
Subject: Re: About xfstests generic/361
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 08:29:38 +0800
In-Reply-To: <20191028233448.GB15221@magnolia>
References: <1d94634d5c990dc0d21673ff2596bd276b728ab1.camel@themaw.net>
         <20191028233448.GB15221@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-10-28 at 16:34 -0700, Darrick J. Wong wrote:
> On Mon, Oct 28, 2019 at 05:17:05PM +0800, Ian Kent wrote:
> > Hi Darrick,
> > 
> > Unfortunately I'm having a bit of trouble with my USB keyboard
> > and random key repeats, I lost several important messages this
> > morning due to it.
> > 
> > Your report of the xfstests generic/361 problem was one of them
> > (as was Christoph's mail about the mount code location, I'll post
> > on that a bit later). So I'm going to have to refer to the posts
> > and hope that I can supply enough context to avoid confusion.
> > 
> > Sorry about this.
> > 
> > Anyway, you posted:
> > 
> > "Dunno what's up with this particular patch, but I see regressions
> > on
> > generic/361 (and similar asserts on a few others).  The patches
> > leading
> > up to this patch do not generate this error."
> > 
> > I've reverted back to a point more or less before moving the mount
> > and super block handling code around and tried to reproduce the
> > problem
> > on my test VM and I din't see the problem.
> > 
> > Is there anything I need to do when running the test, other have
> > SCRATCH_MNT and SCRATCH_DEV defined in the local config, and the
> > mount point, and the device existing?
> 
> Um... here's the kernel branch that I used:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=mount-api-crash

Ok, I'll see what I can do with that.

> 
> Along with:
> 
> MKFS_OPTIONS -- -m crc=0

Right.

> MOUNT_OPTIONS -- -o usrquota,grpquota

It looked like generic/361 used only the SCRATCH_DEV so I thought
that meant making a file system and mounting it within the test.

> 
> and both TEST_DEV and SCRATCH_DEV pointed at boring scsi disks.

My VM disks are VirtIO (file based) virtual disks, so that sounds
a bit different.

Unfortunately I can't use raw disks on the NAS I use for VMs and
I've migrated away from having a desktop machine with a couple of
disks to help with testing.

I have other options if I really need to but it's a little bit
harder to setup and use company lab machines remotely, compared to
local hardware (requesting additional disks is hard to do), and
I'm not sure (probably not) if they can/will use raw disks (or
partitions) either.

> 
> > This could have been a problem with the series I posted because
> > I did have some difficulty resolving some conflicts along the
> > way and may have made mistakes, hence reverting to earlier patches
> > (but also keeping the recent small pre-patch changes).
> 
> Yeah, I had the same problem too; you might spot check the commits in
> there just in case /I/ screwed them up.

I will, yes.

> 
> (I would say 'or rebase on for-next' but (a) I don't know how
> Christoph's mount cleanups intermix with that and (b) let's see if
> this afternoon's for-next is less broken on s390 than this morning's
> was
> <frown>)

I neglected to mention that my series is now based on the for-next
branch as I noticed the get_tree_bdev() fix is present so I can drop
the first patch.

It seemed to me that the for-next branch is the right place to base
the series. I expect there will be the odd bump in the road of course
...

Ian

