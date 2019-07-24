Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout02-q01.e.movistar.es ([86.109.101.151]:31229 "EHLO
        relayout02-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfGXMzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 08:55:17 -0400
Received: from relayout02-redir.e.movistar.es (unknown [86.109.101.202])
        by relayout02-out.e.movistar.es (Postfix) with ESMTP id 45twL93VCszhYVy
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 14:55:13 +0200 (CEST)
Received: from Telcontar.valinor (70.red-88-9-30.dynamicip.rima-tde.net [88.9.30.70])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout02.e.movistar.es (Postfix) with ESMTPSA id 45twL90W1GzdbVy
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 14:55:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 8A359320B3E
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 14:55:12 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id pqDlZLn6pPt5 for <linux-xfs@vger.kernel.org>;
        Wed, 24 Jul 2019 14:55:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 8BA1C3206C6
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 14:55:11 +0200 (CEST)
Date: Wed, 24 Jul 2019 14:55:05 +0200 (CEST)
From: "Carlos E. R." <robin.listas@telefonica.net>
Subject: Sanity check - need a second pair of eyes ;-)
Message-ID: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Hi,

I'm trying to create an XFS image to be written on a Blue Ray disk, 
encrypted. I'm told that DVDs have a sector size of 2 KiB, thus it is 
beter to tell the formatting utility of that, because when creating the 
image file it is on a hard disk where sector size is 512B.

Basic procedure:

truncate -s 50050629632 image_1_50.img
losetup -f image_1_50.img
cryptsetup luksFormat --type luks2 --label blueray50img /dev/loop0
cryptsetup luksOpen /dev/loop0 cr_nombre


So now I have the image file loop mounted on /dev/mapper/cr_nombre, and I 
do (this is the step I ask about):

Telcontar:/home_aux/BLUERAY_OPS # mkfs.xfs -L ANameUnseen -b size=2048 
/dev/mapper/cr_nombre
meta-data=/dev/mapper/cr_nombre  isize=512    agcount=4, agsize=6109184 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=0, rmapbt=0
          =                       reflink=0
data     =                       bsize=2048   blocks=24436736, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=2048   blocks=11932, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Telcontar:/home_aux/BLUERAY_OPS #


Is that the correct command line to achieve written sectors of 2 KiB?

I ask because I see isize=512 and sectsz=512 and I wonder.


- -- 
Cheers,
        Carlos E. R.
        (from openSUSE 15.0 x86_64 at Telcontar)
-----BEGIN PGP SIGNATURE-----

iHoEARECADoWIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXThVKRwccm9iaW4ubGlz
dGFzQHRlbGVmb25pY2EubmV0AAoJELUzGBxtjUfVwjkAn2q9VguiYTMF82FiN73c
p2HXDpo7AJ0ahR27m9vhfI0NYVePM6h91CtH8w==
=uH+3
-----END PGP SIGNATURE-----
