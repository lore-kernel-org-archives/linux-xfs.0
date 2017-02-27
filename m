Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150254.uvfqyp5oz5afij2h@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35406 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdB0CNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2017 21:13:19 -0500
Received: by mail-pf0-f178.google.com with SMTP id j5so3354068pfb.2
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2017 18:11:49 -0800 (PST)
From: "Halsey Pian" <halsey.pian@gmail.com>
References: 
In-Reply-To: 
Subject: With respect to XFS Bitmap flush to disk
Date: Mon, 27 Feb 2017 10:11:44 +0800
Message-ID: <004e01d2909e$d9ce1580$8d6a4080$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: zh-cn
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: halsey.pian@gmail.com

Dear All,

Recently, I try to read analyze the bitmap of XFS file system, it seems =
that I cannot read the latest bitmap from hard disk involving the XFS, =
and cannot read the accurate info even after a long time. For example, i =
cannot get the relevant bitmap info after I add/delete a big file =
to/from XFS file system.

I tried several solution, and find it out that I must execute xfs_freeze =
for the XFS partition in CentOS7, and it seems that xfs_freeze =
doesn=E2=80=99t work for XFS version included in Redhat6.5, I must =
umount/mount the xfs, then I can get the latest bitmap info related to =
the latest data located in disk.

What  strategy does XFS use to cache/flush bitmap to hard disk?  How can =
I get the accurate bitmap info especially for Redhat6 series Operating =
System? Could you please give help on it?

Thanks in advance! =E2=98=BA




Halsey Pian=20


