Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B59CA9EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 02:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E84E5217D6
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 02:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="H0z79vs0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PDEF2O4F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbfJ2CDC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 22:03:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48707 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728242AbfJ2CDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 22:03:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 373B321F30;
        Mon, 28 Oct 2019 22:02:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Oct 2019 22:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        lVWj1NUb53xp90Q/66HojEsNeBXjg+dBK1XsxuMp+x8=; b=H0z79vs0WlrtQ86B
        ra/D4lqktpTljUforxtwwEZG1DJYfg9Gqxb7l7/6EJsxOySNYixiCNPp4Yvl83Sd
        TMRz8OWunuhMjkJXeklp0ETQiYGmR45+qNTTr3mRazEwhLs98URXblH3lECmg7O8
        iT8nE/tETpu2Chw1foWTfoW4v0aJmslM0Bo9moa6OjvTkvwX3bAkmQrYqJa57gIy
        YEQiNrPRIAV8iJGnbVaQOTf/v2JsRKWyBKxb0Q6hTshuT9H9ZCp6XU4WWs1JQuh2
        yz2XOFFPuk9Zg/KybFb68mz/rvFF6aZdC7r85WuQakIt050C98GspaQlEAmgoseq
        yeNiiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=lVWj1NUb53xp90Q/66HojEsNeBXjg+dBK1XsxuMp+
        x8=; b=PDEF2O4FmTg7nqdccye6r9+WiB1Bbz8l3ki9mv6jRKWqdwkPtoHZa7h/d
        KUWMadfKC+rYF5QUce4YQLZs46rV/dxz20zd0TmnuykohtuQ0Jy971dz7FnDRjZ8
        rmF5kCeTyYLizaYf3tuzFSvLjonP+hTAdNYy+h7UMVDYXhVrYtygq3RP1OYW+Lnj
        EbvsXbVKNBjVs9I9mUKo1ktW0IbyBe2g8TTgejEmapVgZqEmupe8dNvXxvz4Befa
        /DZy7UR03GeoDYKAhJUbhf5suEuHDXUzsTuSOXxNt/Ouas/f/4drE1l3rFXFvf8W
        s7t/R53tVsGiTZaAJiOZgc174fDxA==
X-ME-Sender: <xms:0Z23XeG3SueUi_odPYWjWCBQCJ6l21Fv4yw-oPs8mu7-AYAIXKzcEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddttddggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucffohhmrghinhepkhgvrh
    hnvghlrdhorhhgnecukfhppeduudekrddvtdekrddukeejrdefvdenucfrrghrrghmpehm
    rghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:0Z23XW_ByzemVwliZ_f0q-3SiWT6RAARTyS_PsPPl-ovmidnTu9UiA>
    <xmx:0Z23XfgkOrZ1R254S3VXgsSnzYzBf2o9MrwxgrJ7H0KQ0Rjev5UjJw>
    <xmx:0Z23XSl7v4gnnQ2hhsEZP4AfwavRVJYoje96EfWBtZI3GdGjJYfBog>
    <xmx:0p23XXgktL85NYQH0HwofzU3RASCl8Gi0K0xU_8CgMWL778Oz7R3Tw>
Received: from mickey.themaw.net (unknown [118.208.187.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3276FD6005A;
        Mon, 28 Oct 2019 22:02:55 -0400 (EDT)
Message-ID: <49459a0a89a891d98c7345f43958e87bc0fefa99.camel@themaw.net>
Subject: Re: About xfstests generic/361
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 10:02:52 +0800
In-Reply-To: <ec905b80dc327ab4b95195cfe4f2e55321799ef6.camel@themaw.net>
References: <1d94634d5c990dc0d21673ff2596bd276b728ab1.camel@themaw.net>
         <20191028233448.GB15221@magnolia>
         <b6a64fa89ab24912b840c0772c2ffa615c0c6118.camel@themaw.net>
         <20191029005208.GD15221@magnolia>
         <ec905b80dc327ab4b95195cfe4f2e55321799ef6.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-10-29 at 09:11 +0800, Ian Kent wrote:
> On Mon, 2019-10-28 at 17:52 -0700, Darrick J. Wong wrote:
> > On Tue, Oct 29, 2019 at 08:29:38AM +0800, Ian Kent wrote:
> > > On Mon, 2019-10-28 at 16:34 -0700, Darrick J. Wong wrote:
> > > > On Mon, Oct 28, 2019 at 05:17:05PM +0800, Ian Kent wrote:
> > > > > Hi Darrick,
> > > > > 
> > > > > Unfortunately I'm having a bit of trouble with my USB
> > > > > keyboard
> > > > > and random key repeats, I lost several important messages
> > > > > this
> > > > > morning due to it.
> > > > > 
> > > > > Your report of the xfstests generic/361 problem was one of
> > > > > them
> > > > > (as was Christoph's mail about the mount code location, I'll
> > > > > post
> > > > > on that a bit later). So I'm going to have to refer to the
> > > > > posts
> > > > > and hope that I can supply enough context to avoid confusion.
> > > > > 
> > > > > Sorry about this.
> > > > > 
> > > > > Anyway, you posted:
> > > > > 
> > > > > "Dunno what's up with this particular patch, but I see
> > > > > regressions
> > > > > on
> > > > > generic/361 (and similar asserts on a few others).  The
> > > > > patches
> > > > > leading
> > > > > up to this patch do not generate this error."
> > > > > 
> > > > > I've reverted back to a point more or less before moving the
> > > > > mount
> > > > > and super block handling code around and tried to reproduce
> > > > > the
> > > > > problem
> > > > > on my test VM and I din't see the problem.
> > > > > 
> > > > > Is there anything I need to do when running the test, other
> > > > > have
> > > > > SCRATCH_MNT and SCRATCH_DEV defined in the local config, and
> > > > > the
> > > > > mount point, and the device existing?
> > > > 
> > > > Um... here's the kernel branch that I used:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=mount-api-crash
> > > 
> > > Ok, I'll see what I can do with that.
> > > 
> > > > Along with:
> > > > 
> > > > MKFS_OPTIONS -- -m crc=0
> > > 
> > > Right.
> > > 
> > > > MOUNT_OPTIONS -- -o usrquota,grpquota
> > > 
> > > It looked like generic/361 used only the SCRATCH_DEV so I thought
> > > that meant making a file system and mounting it within the test.
> > 
> > Yes.  MOUNT_OPTIONS are used to mount the scratch device (and in my
> > case
> > the test device too).
> > 
> > > > and both TEST_DEV and SCRATCH_DEV pointed at boring scsi disks.
> > > 
> > > My VM disks are VirtIO (file based) virtual disks, so that sounds
> > > a bit different.
> > > 
> > > Unfortunately I can't use raw disks on the NAS I use for VMs and
> > > I've migrated away from having a desktop machine with a couple of
> > > disks to help with testing.
> > > 
> > > I have other options if I really need to but it's a little bit
> > > harder to setup and use company lab machines remotely, compared
> > > to
> > > local hardware (requesting additional disks is hard to do), and
> > > I'm not sure (probably not) if they can/will use raw disks (or
> > > partitions) either.
> > 
> > Sorry, I meant 'boring SCSI disks' in a VM.
> > 
> > Er let's see what the libvirt config is...
> > 
> >     <disk type='file' device='disk'>
> >       <driver name='qemu' type='raw' cache='unsafe'
> > discard='unmap'/>
> >       <source file='/run/mtrdisk/a.img'/>
> >       <target dev='sda' bus='scsi'/>
> >       <address type='drive' controller='0' bus='0' target='0'
> > unit='0'/>
> >     </disk>
> > 
> > Which currently translates to virtio-scsi disks.
> 
> I could use the scsi driver for the disk I guess but IO is already
> a bottleneck for me.
> 
> For my VM disks I have:
> 
>     <disk type='file' device='disk'>
>       <driver name='qemu' type='qcow2' cache='writeback'/>
>       <source file='/share/VS-VM/images/F30 test/F30
> test_2.1565610215' startupPolicy='optional'/>
>       <target dev='vdc' bus='virtio'/>
>       <address type='pci' domain='0x0000' bus='0x00' slot='0x08'
> function='0x0'/>
>     </disk>
> 
> I'm pretty much restricted to cow type VM disks if I don't do
> some questionable manual customization to the xml, ;)
> 
> In any case the back trace you saw looks like it's in the mount/VFS
> code
> so it probably isn't disk driver related.
> 
> I'll try and reproduce it with a checkout of you branch above.

I guess this is where things get difficult.

I can't reproduce it, I tried creating an additional VM disk that
uses a SCSI controller as well but no joy.

I used this config:
[xfs]
FSTYPE=xfs
MKFS_OPTIONS="-m crc=0"
MOUNT_OPTIONS="-o usrquota,grpquota"
TEST_DIR=/mnt/test
TEST_DEV=/dev/vdb
TEST_LOGDEV=/dev/vdd
SCRATCH_MNT=/mnt/scratch
SCRATCH_DEV=/dev/sda
SCRATCH_LOGDEV=/dev/vde

and used:
./check -s xfs generic/361

Perhaps some of the earlier tests played a part in the problem,
I'll try running all the tests next ...

Perhaps I'll need to try a different platform ... mmm.

Ian

