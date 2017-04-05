Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753477AbdDEKxq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 06:53:46 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170405103809.GY22845@eguan.usersys.redhat.com>
References: <20170405103809.GY22845@eguan.usersys.redhat.com> <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk> <149132131706.18980.7074156386090748482.stgit@warthog.procyon.org.uk>
Subject: Does btrfs get nlink on directories wrong? -- was Re: [PATCH 2/4] xfstests: Add first statx test [ver #5]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2599.1491389621.1@warthog.procyon.org.uk>
Date: Wed, 05 Apr 2017 11:53:41 +0100
Message-ID: <2600.1491389621@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-btrfs@vger.kernel.org
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eryu Guan <eguan@redhat.com>

I've added a test to xfstests that exercises the new statx syscall.  However,
it fails on btrfs:

     Test statx on a directory
    +[!] stx_nlink differs, 1 != 2
    +Failed
    +stat_test failed

because a new directory it creates has an nlink of 1, not 2.  Is this a case
of my making an incorrect assumption or is it an fs bug?

David
