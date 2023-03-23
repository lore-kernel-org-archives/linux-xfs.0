Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59B4C6FD1C
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Mar 2023 10:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjCWKsE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Mar 2023 06:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjCWKrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Mar 2023 06:47:41 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1350D37544
        for <linux-xfs@vger.kernel.org>; Thu, 23 Mar 2023 03:45:31 -0700 (PDT)
Date:   Thu, 23 Mar 2023 10:45:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1679568328; x=1679827528;
        bh=P9Z4n+MQybwJNcEVN1zVCLpNSqklPSwIEb4GHrhcifM=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=GHj6fPzZ9XJwfRU+COW1AsdDNcBeEh6cuhkONDpV/9jNnd3MPHzoEWyrWTiWHgopi
         8PjMd6YlcGMJe3xm/xahJxD09tSk485wzqhhwOdx91vYoG9IjOBI/jCGAYXWoFMTmg
         dX3xpmMoEMyHHv3NGHT0z0/Gjg+CJ+UQ1T4YMC3Xmo0GP+O6qV4D1tr82rpyoDufat
         av0pGEY3eLCIy/8xCpmj0x71t9cxYYlmANICJ3XHlWuCMfxFCAkr2dsu6BVaAcnsU1
         wktvxrdvxQPg8c/sjQDfDNnZARdcHpbm7PAJUMT4PvDT7FM2smTwOr050utAj+dxqW
         unO4Uycex0waw==
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From:   Johnatan Hallman <johnatan-ftm@protonmail.com>
Subject: FS (dm-0): device supports 4096 byte sectors (not 512)
Message-ID: <EgkSUvPep_zPazvY0jpnimG82K4wOeYfiPz0Ly_34-TMN9DZKWNNQDxGFJPyq622ZaKee6RU3aFT34Yy-i00rjdT7hWFzS6HSGRe74z1F5o=@protonmail.com>
Feedback-ID: 44492887:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello List,

I get this error when I try to mount an XFS partition.
Fortunately there is no critical data on it as it is just a backup but I wo=
uld still like to mount it if it's possible.

I have tried with various Linux distros with kernels ranging from 5.6 to 6.=
1 it's the same result.

xfs_info /dev/mapper/test
meta-data=3D/dev/mapper/test =C2=A0 =C2=A0 =C2=A0 isize=3D256 =C2=A0 =C2=
=A0agcount=3D32, agsize=3D30523559 blks
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2, pro=
jid32bit=3D0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crc=3D0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0finobt=3D0, sparse=3D0, rmapbt=3D0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reflink=3D0 =C2=A0 =C2=A0bigtime=
=3D0 inobtcount=3D0 nrext64=3D0
data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D976753869, imaxpct=
=3D5
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=A0swi=
dth=3D0 blks
naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0bsize=3D4096 =C2=A0 ascii-ci=3D0, ftype=3D0
log =C2=A0 =C2=A0 =C2=A0=3Dinternal log =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 bsize=3D4096 =C2=A0 blocks=3D476930, version=3D2
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D0 blk=
s, lazy-count=3D1
realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0

mount -t xfs -o ro /dev/mapper/test =C2=A0/mnt/
mount: /mnt: mount(2) system call failed: Function not implemented.
=C2=A0 =C2=A0 =C2=A0 =C2=A0dmesg(1) may have more information after failed =
mount system call.



