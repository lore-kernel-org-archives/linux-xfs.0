Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145540.bc6ty2uqdmmlamcs@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mout.gmx.net ([212.227.17.20]:52566 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdBYKas (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 25 Feb 2017 05:30:48 -0500
Received: from [192.168.0.2] ([86.56.65.5]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MFz0E-1cW2VP0Mn0-00ExYU for
 <linux-xfs@vger.kernel.org>; Sat, 25 Feb 2017 11:30:45 +0100
From: Marcel Partap <mpartap@gmx.net>
Subject: Why does fsck.xfs not do what xfs_repair -n does?
Message-ID: <bfb182d9-a005-2d9f-355e-0d785c87c116@gmx.net>
Date: Fri, 24 Feb 2017 21:49:17 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Dear XFS dev crew,
> fsck.xfs(8)
>         fsck.xfs - do nothing, successfully
>         If you wish to check the consistency of an XFS filesystem, or repair a damaged or corrupt XFS filesystem, see xfs_repair(8).

So there's a FS check command that does not work as with all the other filesystems. Instead of checking the FS, it tells you to use xfs_repair both for - XFS repair.. and XFS check. Whereas in the man page of
> xfs_repair - repair an XFS filesystem
it doesn't tell you right at the top that xfs_repair can check XFS. Instead
> *       -n     No modify mode. Specifies that xfs_repair should […]  *scan  the  filesystem*

Is this imperative? It does not make any sense to me apart from the quirk.

#Best Regards!MPartap
