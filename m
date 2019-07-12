Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfGLRnY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 13:43:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 849E430860A4
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:43:24 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D78C5DE80
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:43:24 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: move & sync up xfs_trans_inode with userspace
Message-ID: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
Date: Fri, 12 Jul 2019 12:43:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

userspace moved xfs_trans_inode.c to libxfs after doing enough mangling
to share it, so do the same in the kernel now.

Add the CRTIME handling as well, since userspace has that, even though the
kernel doesn't use it for now.

-Eric
