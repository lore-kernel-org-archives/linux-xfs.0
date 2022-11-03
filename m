Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF3AC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 15:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiKCPRm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 11:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiKCPRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 11:17:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F40D1A3A8
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 08:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667488584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n+IvpnuQ2Y+gN8jtruu+oPuMPAt8E6YxJX9wp1lhk9c=;
        b=PdDPJgpW/NeCYgLSXHB5dGxC53rO/Bc/y1/SQZOQUWn0LiPkTTZmuqYCnSEDRPTOfBKaho
        NDg84gP2AeCVWYqQTeq2r3/ScFVVqTzOqhOQCAoA5FbSYuXn47+JITU2XMnfCxqWrHK4TD
        qdDRG2uL/Dm5IuESD824rG4V3X3UEac=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-c4I2fw8DNTy2Bk3DJoKtTA-1; Thu, 03 Nov 2022 11:16:19 -0400
X-MC-Unique: c4I2fw8DNTy2Bk3DJoKtTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22CEB3C1E722;
        Thu,  3 Nov 2022 15:16:19 +0000 (UTC)
Received: from ovpn-192-135.brq.redhat.com (ovpn-192-135.brq.redhat.com [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F2DC40C6E15;
        Thu,  3 Nov 2022 15:16:17 +0000 (UTC)
Date:   Thu, 3 Nov 2022 16:16:15 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Lukas Herbolt <lukas@herbolt.com>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
Message-ID: <20221103151615.l2u2dgxvnho4pn2p@ovpn-192-135.brq.redhat.com>
References: <l2a3zCkMp4g9yjUsn7MdftktWgI6xqW45ngK9WGU8-OQp_SWHRFpO5xZbUySxT3QRk1C4PyeLgqoVEY3VRRH_w==@protonmail.internalid>
 <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
 <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
 <8b64a70a-0872-b7c3-6507-44b4f95c8028@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b64a70a-0872-b7c3-6507-44b4f95c8028@sandeen.net>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 09:57:20AM -0500, Eric Sandeen wrote:
> On 11/3/22 8:32 AM, Lukas Czerner wrote:
> > On Tue, Nov 01, 2022 at 12:19:06PM -0500, Eric Sandeen wrote:
> >> From: Lukas Herbolt <lukas@herbolt.com>
> >>
> >> As of now only device names are printed out over __xfs_printk().
> >> The device names are not persistent across reboots which in case
> >> of searching for origin of corruption brings another task to properly
> >> identify the devices. This patch add XFS UUID upon every mount/umount
> >> event which will make the identification much easier.
> >>
> >> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> >> [sandeen: rebase onto current upstream kernel]
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Hi,
> > 
> > it is a simple enough, nonintrusive change so it may not really matter as
> > much, but I was wondering if there is a way to map the device name to
> > the fs UUID already and I think there may be.
> > 
> > I know that udev daemon is constantly scanning devices then they are
> > closed in order to be able to read the signatures. It should know
> > exactly what is on the device and I know it is able to track the history
> > of changes. What I am not sure about is whether it is already logged
> > somewhere?
> > 
> > If it's not already, maybe it can be done and then we can cross
> > reference kernel log with udev log when tracking down problems to see
> > exactly what is going on without needing to sprinkle UUIDs in kernel log ?
> > 
> > Any thoughts?
> 
> Hm, I'm not that familiar with udev or what it logs, so I can't really say
> offhand. If you know for sure that this mapping is possible to achieve in
> other ways, that may be useful.
> 
> I guess I'm still of the opinion that having the device::uuid mapping clearly
> stated at mount time in the kernel logs is useful, though; AFAIK there is no
> real "cost" to this, and other subsystems already print UUIDs for various
> reasons so it's not an unusual thing to do.
> 
> (I'd have hesitated to add yet another printk for this purpose, but extending
> an existing printk seems completely harmless...)
> 
> -Eric

I have no strong opinion either way, just trying to explore avenues we
may already have.

When I do mkfs.xfs -f /dev/vdb this is what I get from:

udevadm monitor --environment


monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[187.052212] change   /devices/pci0000:00/0000:00:01.6/0000:07:00.0/virtio5/block/vdb (block)
ACTION=change
DEVPATH=/devices/pci0000:00/0000:00:01.6/0000:07:00.0/virtio5/block/vdb
SUBSYSTEM=block
SYNTH_UUID=0
DEVNAME=/dev/vdb
DEVTYPE=disk
DISKSEQ=2
SEQNUM=3494
MAJOR=252
MINOR=16

UDEV  [187.069279] change   /devices/pci0000:00/0000:00:01.6/0000:07:00.0/virtio5/block/vdb (block)
ACTION=change
DEVPATH=/devices/pci0000:00/0000:00:01.6/0000:07:00.0/virtio5/block/vdb
SUBSYSTEM=block
SYNTH_UUID=0
DEVNAME=/dev/vdb
DEVTYPE=disk
DISKSEQ=2
SEQNUM=3494
USEC_INITIALIZED=4425234
ID_PATH=pci-0000:07:00.0
ID_PATH_TAG=pci-0000_07_00_0
ID_FS_UUID=61c0b0c8-2f9e-4fbf-817d-eda65b0363d5
ID_FS_UUID_ENC=61c0b0c8-2f9e-4fbf-817d-eda65b0363d5
ID_FS_TYPE=xfs
ID_FS_USAGE=filesystem
.ID_FS_TYPE_NEW=xfs
MAJOR=252
MINOR=16
DEVLINKS=/dev/disk/by-path/pci-0000:07:00.0 /dev/disk/by-path/virtio-pci-0000:07:00.0 /dev/disk/by-uuid/61c0b0c8-2f9e-4fbf-817d-eda65b0363d5
TAGS=:systemd:
CURRENT_TAGS=:systemd:



