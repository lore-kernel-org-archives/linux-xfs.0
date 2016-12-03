Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35913 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbcLCTJA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Dec 2016 14:09:00 -0500
Received: by mail-yw0-f170.google.com with SMTP id a10so234449546ywa.3
        for <linux-xfs@vger.kernel.org>; Sat, 03 Dec 2016 11:09:00 -0800 (PST)
Received: from [135.227.130.138] ([66.201.62.254])
        by smtp.gmail.com with ESMTPSA id b140sm3999688ywh.33.2016.12.03.11.08.59
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Dec 2016 11:08:59 -0800 (PST)
From: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: XFS: possible memory allocation deadlock in kmem_alloc on glusterfs
 setup
Message-Id: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
Date: Sat, 3 Dec 2016 11:08:58 -0800
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi xfs community :),

We have a glusterfs setup running under centos7.2. We are using xfs as =
underlying storage for the bricks.
The volume is used to store vm snapshots that=E2=80=99s gets created =
dynamically from the hypervisors through glusterfs mount points.

While this is working fine we have some issues from time to time that =
make the mount points hang.

We have the famous XFS: possible memory allocation deadlock in =
kmem_alloc (mode:0x250) errors appearing from time to time on some of =
our gluster nodes.

Here is a related RH solution link that does not provide a =
=E2=80=9Cdefintivie=E2=80=9D fix.
https://access.redhat.com/solutions/532663

While a drop 3 of caches and a xfs_fsr can fix the issue for a random =
amount of time, it still occurring from time to time.

As a workaround I implemented a drop of the caches when the message is =
appearing + a defrag every 2 days=E2=80=A6 but that=E2=80=99s not really =
convenient and we still have the issue.

I know that doing an extent size hint will fix that for those files but =
I cannot use that as the hypervisors are creating their snapshots using =
glusterfs or nfs protocol. (and it=E2=80=99s not recommended to write on =
the glusterfs bricks either :/)

Do you have any idea on how to fix this deadlock in our setup?

Let me know if you need more information about our systems (like kernel =
version, underlying storage=E2=80=A6)

Thanks a lot for your input :)

=E2=80=94
Regards,
Cyril=
