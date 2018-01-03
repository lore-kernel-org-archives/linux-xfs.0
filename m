Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from walrus.jabberwocky.com ([173.9.29.57]:49506 "EHLO
        mail.jabberwocky.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbeACFIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 00:08:20 -0500
Received: from grover.home.jabberwocky.com (grover.home.jabberwocky.com [172.24.84.28])
        by mail.jabberwocky.com (Postfix) with ESMTPSA id 0D9DA2077407
        for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2018 00:02:14 -0500 (EST)
From: David Shaw <dshaw@jabberwocky.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Quota performance hit?
Message-Id: <3DED9052-77EA-4405-BE33-89807AEE23EC@jabberwocky.com>
Date: Wed, 3 Jan 2018 00:02:13 -0500
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

I wonder if anyone could point me towards any numbers on how much of a performance penalty project quotas incur on a write-heavy filesystem.  The idea being discussed here is putting a project quota on the /var/log directory (so pretty write-heavy) to prevent it from overflowing /var, and thus causing problems for /var/lib, /var/tmp, and other things in /var that need some headroom.  The alternative is to simply use two different filesystems for /var and /var/lib.

Any information or pointers would be welcome.

Thanks,

David

