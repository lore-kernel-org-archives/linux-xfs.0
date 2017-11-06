Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout01-q01.e.movistar.es ([86.109.101.141]:42717 "EHLO
        relayout01-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751461AbdKFD33 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2017 22:29:29 -0500
Received: from relayout01-redir.e.movistar.es (unknown [86.109.101.201])
        by relayout01-out.e.movistar.es (Postfix) with ESMTP id 3yVdMp5BmMzjYbD
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2017 04:29:26 +0100 (CET)
Received: from minas-tirith.valinor (40.red-83-32-233.dynamicip.rima-tde.net [83.32.233.40])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout01.e.movistar.es (Postfix) with ESMTPSA id 3yVdMp3j5pzfYrB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2017 04:29:26 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by minas-tirith.valinor (Postfix) with ESMTP id EDB3B187E5E
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2017 04:29:25 +0100 (CET)
Date: Mon, 6 Nov 2017 04:29:25 +0100 (CET)
From: "Carlos E. R." <robin.listas@telefonica.net>
Subject: Re: Supposedly identical file system wastes space
In-Reply-To: <20171007114343.3bd42f98@lubh.lubhome>
Message-ID: <alpine.LSU.2.21.1711060427260.15643@minas-tirith.valinor>
References: <20171007114343.3bd42f98@lubh.lubhome>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463779071-1117347315-1509938965=:15643"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463779071-1117347315-1509938965=:15643
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



El 2017-11-06 a las 01:15 -0200, Luciano ES escribió:

> I have two 1TB disks, one of them on USB. The USB disk is supposed
> to be a backup copy of the internal disk.
>
> I run this command:
>
> rsync -aSHxv --delete-before /xx/ /media/usbxx/
>
> After all the copying, I get this output from df -h:
>
> Filesystem         Size  Used Avail Use% Mounted on
> /dev/mapper/cxx    931G  520G  411G  56% /xx
> /dev/mapper/usbxx  932G  529G  403G  57% /media/usbxx
>
> So the USB disk takes up 9GB more than the internal disk.
>
> Why?

Notice sectsz. ;-)

- -- 
Cheers
        Carlos E. R.

        (from openSUSE 42.2 x86_64 "Malachite" (Minas Tirith))

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAln/1xUACgkQja8UbcUWM1zh6wD/bXhl0xo/yvw43YsFDWofixeD
de7jGffmtaCq2FP5NvEA/jlbPP2dq2OT6AUfq1TS8uoc+pDoU1wQcAS9ui8PZ3bq
=lAY7
-----END PGP SIGNATURE-----
---1463779071-1117347315-1509938965=:15643--
