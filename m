Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38768 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945625AbcJaT3k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2016 15:29:40 -0400
Received: by mail-wm0-f41.google.com with SMTP id n67so248323965wme.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2016 12:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8bd7b65f-d85d-2958-dd7d-ba97c91ac9ea@telefonica.net>
References: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
 <8bd7b65f-d85d-2958-dd7d-ba97c91ac9ea@telefonica.net>
From: "Steffen D." <sdumke@gmail.com>
Date: Mon, 31 Oct 2016 20:29:37 +0100
Message-ID: <CAPvv1vx-Juge8e=36bq4AFvGxs8Kf7-V_v0j+a9LGWYdDo5h+w@mail.gmail.com>
Subject: Fwd: mounting a xfs file system gives the message: "failure code
 -3003" and "structure needs cleaning"
Content-Type: multipart/mixed; boundary=001a11418c708a399b05402e3a72
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

--001a11418c708a399b05402e3a72
Content-Type: text/plain; charset=UTF-8

Hello again
thanks to Carlos for the hint about the language.
Here are the messages in english:
----------
linux-ibbi:/home/steffen # LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
xfs_repair /dev/sda4
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
linux-ibbi:/home/steffen #
----------

and

----------
linux-ibbi:/home/steffen # LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
xfs_repair -n /dev/sda4
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
Metadata corruption detected at block 0x1a1d6001/0x200
flfirst 118 in agf 2 too large (max = 118)
agf 118 freelist blocks bad, skipping freelist scan
Metadata corruption detected at block 0x272c1001/0x200
flfirst 118 in agf 3 too large (max = 118)
agf 118 freelist blocks bad, skipping freelist scan
agi unlinked bucket 51 is 61133235 in ag 2 (inode=598004147)
sb_icount 349952, counted 357504
sb_ifree 9426, counted 7433
sb_fdblocks 9895143, counted 9426793
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 0
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 598004147, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 598004147 nlinks from 0 to 1
No modify flag set, skipping filesystem flush and exiting.
linux-ibbi:/home/steffen #
----------

Any idea what to do? Or do have to use xfs_repair -L

Thanks a lot

Steffen


---------- Forwarded message ----------
From: Carlos E. R. <robin.listas@telefonica.net>
Date: 2016-10-30 21:45 GMT+01:00
Subject: Re: mounting a xfs file system gives the message: "failure
code -3003" and "structure needs cleaning"
To: linux-xfs@vger.kernel.org


On 2016-10-30 21:36, Steffen D. wrote:
> Hello list!
>
> I'll try to explain my problem:
>

> "inux-ibbi:/home/steffen # xfs_repair /dev/sda4
> Phase 1 - Superblock finden und =C3=BCberpr=C3=BCfen...
> Phase 2 - ein internes Protokoll benutzen

I don't know if it is too late, but to make things easier for the
experts here, it is better to run the command in English. Like this:




-- 
Signatur ausser Betrieb.

--001a11418c708a399b05402e3a72
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"
Content-Transfer-Encoding: base64
X-Attachment-Id: 4ec31664eeba04d1_0.1

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYyLjAuMjIgKEdO
VS9MaW51eCkNCg0KaUVZRUFSRUNBQVlGQWxnV1c5c0FDZ2tRdFRNWUhHMk5SOVVWVUFDZEVNcmdF
eldpQnU0TU9KbDZEVXhUa1haZA0KaUEwQW9JeVVWR3RnR04wcldmV0xjMlBuVFNiem9wVWgNCj0v
T2pTDQotLS0tLUVORCBQR1AgU0lHTkFUVVJFLS0tLS0NCg==
--001a11418c708a399b05402e3a72--
