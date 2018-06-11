Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr720099.outbound.protection.outlook.com ([40.107.72.99]:57043
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933159AbeFKTgv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jun 2018 15:36:51 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Bug report: kernel hangs when mounting a crafted xfs image
Date: Mon, 11 Jun 2018 19:36:48 +0000
Message-ID: <5B6AC96A-7049-48D7-82A1-4AB42322D38B@gatech.edu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5235CC1051D2D49B8E64C60131E0915@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

When mounting a crafted xfs v4 image, the kernel hangs and never returns for mount operation. Suspect potential deadlock in log recovery exists. Not sure it is considered as a bug or not.

- Reproduce (on 4.17 upstream kernel)
# mkdir mnt
# mount -t xfs 0.img mnt

The image file (0.img.zip) is available here: https://bugzilla.kernel.org/attachment.cgi?id=276475

Thanks,
Wen