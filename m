Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60560 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S935739AbdAKCJC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 21:09:02 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Generic/389 xfs_io segfault on btrfs and ext4
Message-ID: <ca7ae533-8d7f-9783-1900-bdfb17d6a32c@cn.fujitsu.com>
Date: Wed, 11 Jan 2017 10:08:54 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, agruenba@redhat.com, btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Hi, Andreas and Eryu,

I found test case generic/389 fails on btrfs and ext4, and it fails with 
xfs_io segfault.

So it seems to be a bug in xfsprogs, but I'm already using the latest 
release from Fedora.

Is this a known bug?

Thanks,
Qu


