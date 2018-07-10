Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f43.google.com ([209.85.160.43]:36550 "EHLO
        mail-pl0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933248AbeGJNny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jul 2018 09:43:54 -0400
Received: by mail-pl0-f43.google.com with SMTP id a7-v6so7647614plp.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jul 2018 06:43:54 -0700 (PDT)
MIME-Version: 1.0
From: Filippo Giunchedi <fgiunchedi@wikimedia.org>
Date: Tue, 10 Jul 2018 15:43:42 +0200
Message-ID: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
Subject: Recently-formatted XFS filesystems reporting negative used space
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,
a little background: at Wikimedia Foundation we are running a 30-hosts
Openstack Swift cluster to host user media uploads, each host has 12
spinning disks formatted individually with xfs.

Some of the recently-formatted filesystems have started reporting
negative usage upon hitting around 70% usage, though some filesystems
on the same host kept reporting as expected:

/dev/sdn1       3.7T  -14T   17T    - /srv/swift-storage/sdn1
/dev/sdh1       3.7T  -13T   17T    - /srv/swift-storage/sdh1
/dev/sdc1       3.7T  3.0T  670G  83% /srv/swift-storage/sdc1
/dev/sdk1       3.7T  3.1T  643G  83% /srv/swift-storage/sdk1

We have experienced this bug only on the last four machines to be put
in service and formatted with xfsprogs 4.9.0+nmu1 from Debian Stretch.
The remaining hosts were formatted in the past with xfsprogs 3.2.1 or
older.
We have also a standby cluster in another datacenter with similar
configuration and hosts that received write traffic only but not read
traffic; the standby cluster hasn't experienced the bug and all
filesystems report the correct usage.
As far as I can tell the difference in xfsprogs version used for
formatting means defaults have changed, (e.g. crc is enabled on the
affected filesystems). Have you seen this issue before and do you know
how to fix it?

I would love to help debugging this issue, we've been detailing the
work done so far at https://phabricator.wikimedia.org/T199198

thanks in advance!
Filippo
