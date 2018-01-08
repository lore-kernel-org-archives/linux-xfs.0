Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755907AbeAHIow (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 03:44:52 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDEA8C04B32E
        for <linux-xfs@vger.kernel.org>; Mon,  8 Jan 2018 08:44:51 +0000 (UTC)
Received: from localhost (ovpn-116-184.ams2.redhat.com [10.36.116.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 980E25D724
        for <linux-xfs@vger.kernel.org>; Mon,  8 Jan 2018 08:44:51 +0000 (UTC)
Date: Mon, 8 Jan 2018 08:44:50 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: statfs b_avail & b_free different if the filesystem is mounted
 readonly
Message-ID: <20180108084450.GU2787@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We had a question[1] posed by a libguestfs user who wondered why the
output of ‘virt-df’ and ‘df’ differ for an XFS filesystem.  After
looking into the details it turns out that the statfs(2) system call
gives slightly different answers if the filesystem is mounted
read-write vs read-only.

  ><rescue> mount /dev/sda1 /sysroot
  ><rescue> stat -f /sysroot
    File: "/sysroot"
      ID: 80100000000 Namelen: 255     Type: xfs
  Block size: 4096       Fundamental block size: 4096
  Blocks: Total: 24713      Free: 23347      Available: 23347
  Inodes: Total: 51136      Free: 51133

vs:

  ><rescue> mount -o ro /dev/sda1 /sysroot
  ><rescue> stat -f /sysroot
    File: "/sysroot"
      ID: 80100000000 Namelen: 255     Type: xfs
  Block size: 4096       Fundamental block size: 4096
  Blocks: Total: 24713      Free: 24653      Available: 24653
  Inodes: Total: 51136      Free: 51133

‘virt-df’ uses ‘-o ro’ and in the ‘df’ case the user had the
filesystem mounted read-write, hence different results.

I looked into the kernel code and it's all pretty complicated.  I
couldn't see exactly where this difference could come from.

My questions are: Is there a reason for this difference, and is one of
the answers more correct than the other?

Rich.

[1] https://www.redhat.com/archives/libguestfs/2018-January/msg00002.html

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
