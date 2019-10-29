Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB863CA9EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 01:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A85F121721
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 01:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="EyaGyjxH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JM7tSrra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfJ2BMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 21:12:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35089 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbfJ2BMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 21:12:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id ED95721C82;
        Mon, 28 Oct 2019 21:12:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Oct 2019 21:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        lqWYK6Ra4kuyKToYNYaK4vRLc+WOyCFPTdatAvCKnTc=; b=EyaGyjxHGFV8S2Th
        BEqSlG+hBtBzJ1OfO0EcBQIL1sydsrO1tP1Yn+Z4WOgqJ8ZAtRTfsIFbC3nwt8ue
        vh6TeF2C6q6pqgxkjF69brI3xUk8GpTjVNu3PEI7L7JRD7jQ6k+YQMPKs0ACQmeP
        Do9iIJo2UCZoj8o9FR/cTcwWFMeDfAh6op2UMTcz1cHjdYjmKJU6L5yG2njs0KM3
        Ht/mwfp669HtsJMhG0nZd1CUeioM3whEjf7KlHyTeUsi/lL4fy+amBEz+BvCrQdt
        VJUvGqJYoqBLunGVT/dpLXQcojOPfdjQCVcq2ywWCl0u5EJOMgBjy3Wkm3w7askB
        mlGUXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=lqWYK6Ra4kuyKToYNYaK4vRLc+WOyCFPTdatAvCKn
        Tc=; b=JM7tSrraNHiFi+wtQc2gzSJiJL9cGB/EHBSFLXunT9SQnQtP0mJgV10dP
        xmiAWbpbn7hAe/VXR6JhQLZSJmQhe4vkUitwJgEBdLfLLUsIEKgenhfxuPN+/5JX
        J5qmN+18NcKhKuLq7JO2uF//PHkgM4ybZAwqA0xMfEYqCLYm2sboIEd0I4tZFW6N
        sL4KbO/i4dwpvbhK8iHeALjG9meXzwd7/rYQC8UhDevH8uIj4W/5D//Uvs2TfZnG
        2fDs/FsQdV1fcUuEF81CH+cMo5xTAkKM24P1qlTLFK0CwE4wL9AO3T99/2oTrP+W
        RThxrK6CByXvvvKBoF2NOtrsaT0eQ==
X-ME-Sender: <xms:4pG3XT9JK5OmQRUXXsWbETutZhYHdNzAjTOVrqD99bXubNrPqfpPSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddttddgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucffohhmrghinhepkhgvrh
    hnvghlrdhorhhgnecukfhppeduudekrddvtdekrddukeejrdefvdenucfrrghrrghmpehm
    rghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:4pG3XT-_dVb19kO7O_ldck-Puj8DjryuCxHSsE8plpZH9Sej0UhEYg>
    <xmx:4pG3XcD0s0tE_aZG1P78Tvz4jlIxiqmUopLtKyVsabTeiGk0iJft8Q>
    <xmx:4pG3XTy_ghlnZKOlulHzN7JHxPg42ZwRUVYb_rqWuVi7RfmxyYfr1Q>
    <xmx:45G3XfKv0nNvC3X0hq1hRCZmJoATCghyWFNil6cRHsZfauC0NtX1KA>
Received: from mickey.themaw.net (unknown [118.208.187.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 117F6D60067;
        Mon, 28 Oct 2019 21:12:00 -0400 (EDT)
Message-ID: <ec905b80dc327ab4b95195cfe4f2e55321799ef6.camel@themaw.net>
Subject: Re: About xfstests generic/361
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 09:11:56 +0800
In-Reply-To: <20191029005208.GD15221@magnolia>
References: <1d94634d5c990dc0d21673ff2596bd276b728ab1.camel@themaw.net>
         <20191028233448.GB15221@magnolia>
         <b6a64fa89ab24912b840c0772c2ffa615c0c6118.camel@themaw.net>
         <20191029005208.GD15221@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-10-28 at 17:52 -0700, Darrick J. Wong wrote:
> On Tue, Oct 29, 2019 at 08:29:38AM +0800, Ian Kent wrote:
> > On Mon, 2019-10-28 at 16:34 -0700, Darrick J. Wong wrote:
> > > On Mon, Oct 28, 2019 at 05:17:05PM +0800, Ian Kent wrote:
> > > > Hi Darrick,
> > > > 
> > > > Unfortunately I'm having a bit of trouble with my USB keyboard
> > > > and random key repeats, I lost several important messages this
> > > > morning due to it.
> > > > 
> > > > Your report of the xfstests generic/361 problem was one of them
> > > > (as was Christoph's mail about the mount code location, I'll
> > > > post
> > > > on that a bit later). So I'm going to have to refer to the
> > > > posts
> > > > and hope that I can supply enough context to avoid confusion.
> > > > 
> > > > Sorry about this.
> > > > 
> > > > Anyway, you posted:
> > > > 
> > > > "Dunno what's up with this particular patch, but I see
> > > > regressions
> > > > on
> > > > generic/361 (and similar asserts on a few others).  The patches
> > > > leading
> > > > up to this patch do not generate this error."
> > > > 
> > > > I've reverted back to a point more or less before moving the
> > > > mount
> > > > and super block handling code around and tried to reproduce the
> > > > problem
> > > > on my test VM and I din't see the problem.
> > > > 
> > > > Is there anything I need to do when running the test, other
> > > > have
> > > > SCRATCH_MNT and SCRATCH_DEV defined in the local config, and
> > > > the
> > > > mount point, and the device existing?
> > > 
> > > Um... here's the kernel branch that I used:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=mount-api-crash
> > 
> > Ok, I'll see what I can do with that.
> > 
> > > Along with:
> > > 
> > > MKFS_OPTIONS -- -m crc=0
> > 
> > Right.
> > 
> > > MOUNT_OPTIONS -- -o usrquota,grpquota
> > 
> > It looked like generic/361 used only the SCRATCH_DEV so I thought
> > that meant making a file system and mounting it within the test.
> 
> Yes.  MOUNT_OPTIONS are used to mount the scratch device (and in my
> case
> the test device too).
> 
> > > and both TEST_DEV and SCRATCH_DEV pointed at boring scsi disks.
> > 
> > My VM disks are VirtIO (file based) virtual disks, so that sounds
> > a bit different.
> > 
> > Unfortunately I can't use raw disks on the NAS I use for VMs and
> > I've migrated away from having a desktop machine with a couple of
> > disks to help with testing.
> > 
> > I have other options if I really need to but it's a little bit
> > harder to setup and use company lab machines remotely, compared to
> > local hardware (requesting additional disks is hard to do), and
> > I'm not sure (probably not) if they can/will use raw disks (or
> > partitions) either.
> 
> Sorry, I meant 'boring SCSI disks' in a VM.
> 
> Er let's see what the libvirt config is...
> 
>     <disk type='file' device='disk'>
>       <driver name='qemu' type='raw' cache='unsafe' discard='unmap'/>
>       <source file='/run/mtrdisk/a.img'/>
>       <target dev='sda' bus='scsi'/>
>       <address type='drive' controller='0' bus='0' target='0'
> unit='0'/>
>     </disk>
> 
> Which currently translates to virtio-scsi disks.

I could use the scsi driver for the disk I guess but IO is already
a bottleneck for me.

For my VM disks I have:

    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='writeback'/>
      <source file='/share/VS-VM/images/F30 test/F30 test_2.1565610215' startupPolicy='optional'/>
      <target dev='vdc' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x0'/>
    </disk>

I'm pretty much restricted to cow type VM disks if I don't do
some questionable manual customization to the xml, ;)

In any case the back trace you saw looks like it's in the mount/VFS code
so it probably isn't disk driver related.

I'll try and reproduce it with a checkout of you branch above.

> 
> > > > This could have been a problem with the series I posted because
> > > > I did have some difficulty resolving some conflicts along the
> > > > way and may have made mistakes, hence reverting to earlier
> > > > patches
> > > > (but also keeping the recent small pre-patch changes).
> > > 
> > > Yeah, I had the same problem too; you might spot check the
> > > commits in
> > > there just in case /I/ screwed them up.
> > 
> > I will, yes.
> > 
> > > (I would say 'or rebase on for-next' but (a) I don't know how
> > > Christoph's mount cleanups intermix with that and (b) let's see
> > > if
> > > this afternoon's for-next is less broken on s390 than this
> > > morning's
> > > was
> > > <frown>)
> > 
> > I neglected to mention that my series is now based on the for-next
> > branch as I noticed the get_tree_bdev() fix is present so I can
> > drop
> > the first patch.
> > 
> > It seemed to me that the for-next branch is the right place to base
> > the series. I expect there will be the odd bump in the road of
> > course
> > ...
> 
> Heh. Yes. :)
> 
> --D
> 
> > Ian
> > 

