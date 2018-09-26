Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:54204 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726265AbeIZHCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 03:02:08 -0400
Received: from mr3.cc.vt.edu (mr3.cc.vt.edu [IPv6:2607:b400:92:8500:0:7f:b804:6b0a])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id w8Q0pvFB016619
        for <linux-xfs@vger.kernel.org>; Tue, 25 Sep 2018 20:51:57 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        by mr3.cc.vt.edu (8.14.7/8.14.7) with ESMTP id w8Q0ppm4021398
        for <linux-xfs@vger.kernel.org>; Tue, 25 Sep 2018 20:51:57 -0400
Received: by mail-qt1-f197.google.com with SMTP id h26-v6so8865423qtp.18
        for <linux-xfs@vger.kernel.org>; Tue, 25 Sep 2018 17:51:57 -0700 (PDT)
From: TongZhang <ztong@vt.edu>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-Id: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
Date: Tue, 25 Sep 2018 20:51:50 -0400
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

Hi,

I'm bringing up this issue again to let of LSM developers know the situation, and would like to know your thoughts.
Several weeks ago I sent an email to the security list to discuss the issue where
XFS's ioctl interface can do things like vfs_readlink without asking LSM's
permission, which we think is kind of weird and this kind of operation should be
audited by LSM.

see the original post below:

>We noticed a use of vfs_readlink() in xfs_file_ioctl(), which should have been checked by 
>security_inode_readlink().
>The callgraph is:
>	xfs_file_ioctl()->xfs_readlink_by_handle()->vfs_readlink()
>
>This path allows user to do things similar to SyS_readlinkat(), and the parameters
>are user controllable.

security_inode_readlink() is not used inside vfs_readlink()

- Tong
