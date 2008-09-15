Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 19:03:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F22f8i031203
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 19:02:41 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FB6844028E
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 19:04:12 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.240]) by cuda.sgi.com with ESMTP id c7krtPuF6x98Wi3M for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 19:04:12 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so1868806rvb.32
        for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 19:04:11 -0700 (PDT)
Message-ID: <e03b90ae0809141904r47de6883k185174bb13df34b4@mail.gmail.com>
Date: Sun, 14 Sep 2008 19:04:11 -0700
From: "Jeff Breidenbach" <jeff@jab.org>
Subject: read only remount not so happy
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

# mount -o remount,ro /dev/md0

After a few hours mount is still churning away with 100% CPU. Known problem?

$ ps aux | grep mount
root     18600 97.1  0.0  11688   908 ?        R    15:14 217:01 mount
-o remount,ro /dev/md0

$ cat /proc/version
Linux version 2.6.24-8-server (buildd@yellow) (gcc version 4.2.3
(Ubuntu 4.2.3-1ubuntu2)) #1 SMP Thu Feb 14 20:42:20 UTC 2008

$ dpkg -l | grep xfsprogs
ii  xfsprogs                              2.9.5-1
  Utilities for managing the XFS filesystem

# mount | grep md0
/dev/md0 on /data1 type xfs (rw,noatime,logbufs=8,logbsize=256k)
