Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr50126.outbound.protection.outlook.com ([40.107.5.126]:6170
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726521AbeK3XIb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Nov 2018 18:08:31 -0500
From: Albert Duato <albert@kumori.systems>
Subject: How to avoid xfs_do_force_shutdown on xlog_iodone error
Date: Fri, 30 Nov 2018 11:59:25 +0000
Message-ID: <VI1P192MB028894DF21C722001901A488A9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
References: <VI1P192MB0288B67B92CE171B34ABBB1AA9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
In-Reply-To: <VI1P192MB0288B67B92CE171B34ABBB1AA9D30@VI1P192MB0288.EURP192.PROD.OUTLOOK.COM>
Content-Language: es-ES
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Hi,

This is my first message here, so please bear with me.

I'm looking for a way of avoiding  xfs_do_force_shutdown when there is a te=
mporary disconnection of the underlying block device.=A0max_retries and ret=
ry_timeout_seconds are set to -1, but xlog_iodone operations seem to ignore=
 that. Other operations like=A0xfs_trans_read_buf_map are correctly retried=
.

My intention is to be transparent (i.e. freezing disk operations temporaril=
y) to network disconnections to NBD server, but it should be equivalent to =
pulling the plug of a USB block device, reconnect and that everything conti=
nues to work as expected, without the physical corruption issues.

Is there a way of achieving that?

Thank you,

Albert

[92740.572442] XFS (nbd0): metadata I/O error: block 0x2806100 ("xlog_iodon=
e") error 5 numblks 256
[92740.572450] XFS (nbd0): xfs_do_force_shutdown(0x2) called from line 1233=
 of file fs/xfs/xfs_log.c.=A0 Return address =3D 0xffffffffc0567a48
[92740.572502] XFS (nbd0): Log I/O Error Detected.=A0 Shutting down filesys=
tem
[92740.572504] XFS (nbd0): Please umount the filesystem and rectify the pro=
blem(s)


     =
