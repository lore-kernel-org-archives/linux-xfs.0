Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D424DC76195
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Mar 2023 16:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCXQHA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Mar 2023 12:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCXQG6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2023 12:06:58 -0400
X-Greylist: delayed 105689 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Mar 2023 09:06:58 PDT
Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EB520D2B
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2023 09:06:58 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:06:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1679674015; x=1679933215;
        bh=WgcIBXzVZrlWohQPGoH8Bkj+s6xg2lNG/JACMJJ6TxM=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=Qii42gkKomVW0DWALeeSKza45vfZJQRtRvQPA1KD5VFVoK+WXFAaJfs1AztRtgYaj
         4egKrf4ohqUJN/O/02Rb/zIjHhbTwEYFgw+/dEWIiEbYWua+tB3ciGdJrw7PGKICph
         0o7OVfyIAGuzrLjmHVO6Fk3bqBUcaQ8A393jbLW1XzWSgLaCDk2Np+ssY7uASki1K5
         HDVXoXl2hC1G8+wDJLAMOxrO2fGOTf5vpzclQ0OYkdjgxaCgBkkWTXmhnPxH0RVmC3
         3Vaan4mkrctrpjtEoMtMEpN8RIzWYa9h1CwrSiaImWP+HueuqX/SYXC0mxoekBohcT
         7zBJZmTdEgJBQ==
To:     Dave Chinner <david@fromorbit.com>
From:   Johnatan Hallman <johnatan-ftm@protonmail.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: FS (dm-0): device supports 4096 byte sectors (not 512)
Message-ID: <qpHHCfY6lZ6RRX1NVidA7VXOpJXelA2cNoO7y7RbPZMyDkiFp5B3GmFFm9RpIOqS8C4kJTxdUpK2CekGTDysq44dJltxFPYzCvyGqmCykVY=@protonmail.com>
In-Reply-To: <ZBzeRR+OjZYku7vu@destitution>
References: <EgkSUvPep_zPazvY0jpnimG82K4wOeYfiPz0Ly_34-TMN9DZKWNNQDxGFJPyq622ZaKee6RU3aFT34Yy-i00rjdT7hWFzS6HSGRe74z1F5o=@protonmail.com> <ZBzeRR+OjZYku7vu@destitution>
Feedback-ID: 44492887:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

Thanks a lot, that was it. I never thought of it. The usb docking station w=
as changed now I tried with another one works fine :)



------- Original Message -------
On Friday, March 24th, 2023 at 12:18 AM, Dave Chinner <david@fromorbit.com>=
 wrote:


> On Thu, Mar 23, 2023 at 10:45:18AM +0000, Johnatan Hallman wrote:
>=20
> > Hello List,
> >=20
> > I get this error when I try to mount an XFS partition.
> > Fortunately there is no critical data on it as it is just a backup but =
I would still like to mount it if it's possible.
> >=20
> > I have tried with various Linux distros with kernels ranging from 5.6 t=
o 6.1 it's the same result.
> >=20
> > xfs_info /dev/mapper/test
> > meta-data=3D/dev/mapper/test isize=3D256 agcount=3D32, agsize=3D3052355=
9 blks
>=20
>=20
> Where did this filesystem come from? It's a v4 filesystem, so
> unless you specifically made it that way it must be a pretty old
> filesystem.
>=20
> What is the drive hardware and how is it connected to the machine?
> e.g. perhaps it is an an external drive connected through a USB-SATA
> bridge and the bridge hardware might be advertising the drive as a
> 4kB sector drive incorrectly?
>=20
> Cheers,
>=20
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
