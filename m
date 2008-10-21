Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 11:10:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LIA8LW012528
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 11:10:10 -0700
Received: from ey-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B427114535C2
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 11:11:51 -0700 (PDT)
Received: from ey-out-1920.google.com (ey-out-1920.google.com [74.125.78.145]) by cuda.sgi.com with ESMTP id Avp2CCEaFNWGPb6c for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 11:11:51 -0700 (PDT)
Received: by ey-out-1920.google.com with SMTP id 21so795141eyc.32
        for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 11:11:51 -0700 (PDT)
Message-ID: <934a72850810211111g20accf8ey74f0bfb8ecf38532@mail.gmail.com>
Date: Tue, 21 Oct 2008 20:11:50 +0200
From: "Johan Stenehall" <stenehall@gmail.com>
Subject: Partition seems to have been zero:ed. For no reason.
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

After a kernal upgrade My UUIDs in /etc/fstab stoped working so I changed
them to /dev/sd* When rebooting again /dev/sdb2 didn't want to mount. I
tried to manualy mount it without success and tried to run a xfs_repair on
it. Got the following: http://pastebin.com/m44d3aa47
After that the partition still didn't want to mount. Had to overwrite the
inprogress flag "xfs_db> write inprogress 0", That aloud me to mount the
partition but it looked entirly empty.

A very nice person, <sandeen_> (thank you), on xfs@freenode tried to help
me. However it seems like the entire disk, or part of it, have been zero:ed.

Does anyone know if it's possible to recover from this? And if so how?

Running Linux Ubuntu, 8.04 32-bit
uname -r
2.6.24-21-generic
xfs_repair -V
xfs_repair version 2.9.4

Hope this information is sufficent. Thanks in advance for any answers

// Johan (please forgive my english)


[[HTML alternate version deleted]]
