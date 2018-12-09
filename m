Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36604 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726131AbeLIMwb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Dec 2018 07:52:31 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 503042A6B7
        for <linux-xfs@vger.kernel.org>; Sun,  9 Dec 2018 12:52:30 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201939] New: There is no 'no space' message when using xfs with
 nfs.
Date: Sun, 09 Dec 2018 12:52:29 +0000
Message-ID: <bug-201939-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201939

            Bug ID: 201939
           Summary: There is no 'no space' message when using xfs with
                    nfs.
           Product: File System
           Version: 2.5
    Kernel Version: 3.4.113
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: gbkwon@gmail.com
        Regression: No

hi all


I use xfs filesystem over nfs


I am using the xfs file system via NFS on two Linux servers.

Even though xfs is full, you will not get a 'no space' message through nfs.

The server's load average goes up and the kworker consumes the CPU.

The server's nfs service is not responding.

When ext3 is full in the same environment, I get a 'no space' message.

Which part of nfs and xfs should be checked?


Below is the environment I am using.


kernel : nfs server 3.4.113 vanilla, nfs client 2.6.32-573.el6.x86_64

nfs : nfs v3 with tcp


==================================================================
nfs server
================================================================== 
/dev/mapper/lv2  500G  500G   20K 100% /lv2

/lv2   
0.0.0.0/0.0.0.0(rw,async,wdelay,nohide,nocrossmnt,insecure,no_root_squash,no_all_squash,no_subtree_check,insecure_locks,no_acl,fsid=1543743056,anonuid=65534,anongid=65534)


================================================================== 
nfs client
================================================================== 
10.0.0.20:/lv2   500G  500G   32K 100% /mnt/2 

nfsstat  -m
/mnt/2 from 10.0.0.20:/lv2
 Flags:
rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=udp,timeo=11,retrans=3,sec=sys,mountaddr=10.0.0.20,mountvers=3,mountport=2047,mountproto=udp,local_lock=none,addr=10.0.0.20

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
