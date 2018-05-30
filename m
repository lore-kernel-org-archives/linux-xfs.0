Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932111AbeE3Ptn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 11:49:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4CE4310DD6
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 15:49:43 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D5B960BA7
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 15:49:43 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs_repair: rework inode clearing and free inode
 validation
Message-ID: <4f70c5e0-8093-38b3-256d-ee16460aa4ad@redhat.com>
Date: Wed, 30 May 2018 10:49:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Separate out the inode validation from the clearing function, and
ultimately warn the user if any free inodes were cleared due to
corruption.
