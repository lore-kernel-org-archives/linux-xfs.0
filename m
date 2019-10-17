Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAED2FA372B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 06:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7592820872
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 06:56:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="DRwhWfeY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407856AbfJQG4Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 02:56:24 -0400
Received: from mout.gmx.net ([212.227.17.22]:37619 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407840AbfJQG4X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Oct 2019 02:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571295382;
        bh=gOLIKHz7V8+LGbpUpHzXWGzWvJ5jnBKGf8pSm4XzBJY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=DRwhWfeYQvpErpXp7C5amtYuqOIAon2zBEwzlQdqQq48k8Cr69OjnWwU04R6TLPiT
         sGmPJa8YTFamwFQB0o7woa2Pplqjg74Rv/Z7rUbWlLLnHzvxPb7sI9gvBcoQwhpQm/
         1nflcpogIBamwy+t5QDT9JQMzDeaplDt8sYEFOHo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [2.50.152.200] ([2.50.152.200]) by web-mail.gmx.net
 (3c-app-gmx-bs26.server.lan [172.19.170.78]) (via HTTP); Thu, 17 Oct 2019
 08:56:21 +0200
MIME-Version: 1.0
Message-ID: <trinity-0da2b218-4863-4722-86f8-702d39a9f882-1571295381809@3c-app-gmx-bs26>
From:   =?UTF-8?Q?=22Marc_Sch=C3=B6nefeld=22?= <marc.schoenefeld@gmx.org>
To:     "Dave Chinner" <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Aw: Re: Sanity check for m_ialloc_blks in libxfs_mount()
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 17 Oct 2019 08:56:21 +0200
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
X-Provags-ID: V03:K1:LjWjKiI9s3t4VLo4q8D2+oaqJmUKLTJ1SxTVRf2Aij8FuZK7jfJTe3areXRy6/s71Mew3
 YUEXhyLWgpA09HH4svsf2XtsgwTJHlgjRkDsm7QRzSvl/U8jNor/V8l8XXXf8oZ1n6wtV0SrqfDR
 H9riGKz3zifpsQJu6lwwiStO6Bdv63HradlgrI0cO0abYRrNAz7q+ZlPuqhjHTBqOJ/Wpesck+fP
 RhOwUaOx8eHNE5675VoN+2fTmjasNyV3f0BJDvlWykrb2WJ1Hiu0WGNQMMXV/nR7/gd5MZm5CV39
 UI=
X-UI-Out-Filterresults: notjunk:1;V03:K0:vihja72A2NM=:gwKrjZnSlpiK7yefcTZ8+S
 ZdmTie/pERdgaqbv4wtY5MQcaaPbCWmeWkOqfAV4qGmJpq0S5da4JHYI+PGdQ/+mQhDzZSAun
 YrPPVtnALilnIGEOSmN0k++wm+keNFUaVewliLkCrkmW6H0NMbR5sMOO21G7dzhlnAzqQzk2l
 IWkMOXaw42KcGPBPecD+wLlxoX4koCVtls9iQkiIMrvi/s+wdoTTg3Pelen5ak33JaKANS0hJ
 5dOT6g805tIIq1Ez26hretLj8HxAORdZ88V8SZvFnvVU1XiHqIFSeKGLrO+OHuGDpjsjCp84R
 gh6rZPrnhimQGK5k7lPef2RwJVdWjdZFaZT0NkmseT2nDPw2GQTjRKezOoZHfJ7iR1b+uL66p
 QtATC0naA6M4me8V5da/+1DuweEnOkSlJSA0WQfAvpynTmfdLIV6diMTjvgEWmzlstLz+mGYj
 oxh6l8Exp3GhTF1AOMkilMtqygUUeffn4n8N63Ur1U9/KCF7OqVttC4S9qjwUUFSW2O6Fsee5
 8yDcaSXPa3d/m1HIkSwwiC9RHoufLtO3l0fYuZe+Pdy11Ll3k4q/tO5HEPMGrEPQVwcKiR7yM
 0K5IizH1XE4Tis9NwtEKmY7Eg5esL9uZK25MM1dvqZnoapa33KI99uEzGCmGs2AJ8Bk/vFHE/
 GM/cCts4OWCEhqRMe1HD0G+VuisgMOEjtf6MX7ewufZ9r23crHKAhLE150iFDdAhbePM=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,=C2=A0[resent due to smtp error]=20
=C2=A0
thanks for the help, now using=C2=A0the for-next branch, there is still an=
=C2=A0Arithmetic exception, however somewhere else:
=C2=A0
Program received signal SIGFPE, Arithmetic exception=2E
xfs_ialloc_setup_geometry (mp=3Dmp@entry=3D0x6a5e60 <xmount>) at xfs_iallo=
c=2Ec:2792
2792 do_div(icount, igeo->ialloc_blks);

Thanks
Marc=C2=A0

=C2=A0

Gesendet:=C2=A0Donnerstag, 17=2E Oktober 2019 um 00:28 Uhr
Von:=C2=A0"Dave Chinner" <david@fromorbit=2Ecom>
An:=C2=A0"Marc Sch=C3=B6nefeld" <marc=2Eschoenefeld@gmx=2Eorg>
Cc:=C2=A0linux-xfs@vger=2Ekernel=2Eorg
Betreff:=C2=A0Re: Sanity check for m_ialloc_blks in libxfs_mount()
On Wed, Oct 16, 2019 at 09:08:51PM +0200, "Marc Sch=C3=B6nefeld" wrote:
> Hi all,=C2=A0
>
> it looks like there is a sanity check missing for the divisor
> (m_ialloc_blks) in line 664 of xfsprogs-5=2E2=2E1/libxfs/init=2Ec:=C2=A0
> Program received signal SIGFPE, Arithmetic exception=2E
>
> 0x0000000000427ddf in libxfs_mount (mp=3Dmp@entry=3D0x6a2de0 <xmount>, s=
b=3Dsb@entry=3D0x6a2de0 <xmount>, dev=3D18446744073709551615,=C2=A0
> =C2=A0 =C2=A0 logdev=3D<optimized out>, rtdev=3D<optimized out>, flags=
=3Dflags@entry=3D1) at init=2Ec:663
>
> which is=C2=A0
>
> =C2=A0 =C2=A0 663 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 mp->m_maxicount =3D XFS_FSB_TO_INO(mp,
> =C2=A0 =C2=A0 664 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (mp->m_maxicoun=
t / mp->m_ialloc_blks) *
> =C2=A0 =C2=A0 665=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp->m_iallo=
c_blks);

That's code is gone now=2E The current calculation in the dev tree is
quite different thanks to:

commit 3a05ab227ebd5982f910f752692c87005c7b3ad3
Author: Darrick J=2E Wong <darrick=2Ewong@oracle=2Ecom>
Date: Wed Aug 28 12:08:08 2019 -0400

xfs: refactor inode geometry setup routines

Source kernel commit: 494dba7b276e12bc3f6ff2b9b584b6e9f693af45

Migrate all of the inode geometry setup code from xfs_mount=2Ec into a
single libxfs function that we can share with xfsprogs=2E

Signed-off-by: Darrick J=2E Wong <darrick=2Ewong@oracle=2Ecom>
Reviewed-by: Dave Chinner <dchinner@redhat=2Ecom>
Signed-off-by: Eric Sandeen <sandeen@sandeen=2Enet>

And so it doesn't have a divide-by-zero vector in it anymore=2E

So it's probably best that you update your source tree to the latest
for-next and retest=2E It's almost always a good idea to test against
the latest dev tree, that way you aren't finding bugs we've already
found and fixed=2E=2E=2E

> In case it would be required I=C2=A0have a reproducer file for this,
> which I can share via pm=2E The bug is reachable from user input via
> the "xfs_db -c _cmd_=C2=A0_xfsfile_" command=2E=C2=A0=C2=A0=C2=A0

I'm guessing that you are fuzzing filesystem images and the issue is
that the inode geometry values in the superblock have been fuzzed to
be incorrect? What fuzzer are you using to generate the image, and
what's the mkfs=2Exfs output that was used to create the base image
that was then fuzzed?

Cheers,

Dave=2E
--
Dave Chinner
david@fromorbit=2Ecom
