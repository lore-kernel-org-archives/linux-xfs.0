Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 07:36:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BEZhPb031813
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 07:35:48 -0700
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3C4FF6310C
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 07:36:14 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.171]) by cuda.sgi.com with ESMTP id U9fNLVIYiNGSjs5I for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 07:36:14 -0700 (PDT)
Message-ID: <47D6982D.7030305@t-online.de>
Date: Tue, 11 Mar 2008 15:33:17 +0100
From: =?ISO-8859-15?Q?J=FCrgen_Fischer?= <jfi.pcs@t-online.de>
MIME-Version: 1.0
Subject: Problem with xfs devices
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I have some problems with xfs devices which I can't mount and hope you 
can help me.

I have the devices md1, md5, md6, md7, md8 on a Root-Server by a german 
provider with SuSE linux 10.2. I've made yesterday evening an online 
update which updates the kernel and wants a reboot after that. Since 
that no rebbot is possible, no help available from provider.
The devices md1, md5 and md8 I can mount without problems. But if i try 
to mount md6 or md7 I got the following messages on the screen:

rescue:~# mount /dev/md6 /mnt
Killed
rescue:~#
Message from syslogd@rescue at Tue Mar 11 00:48:37 2008 ...
rescue kernel: Oops: 0000 [2] SMP

Message from syslogd@rescue at Tue Mar 11 00:48:37 2008 ...
rescue kernel: CR2: 0000000000000008

No xfs_check or xfs_repair is possible. I got this messages:

rescue:~# xfs_check -v /dev/md6
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
rescue:~#

I can start after that the xfs_repair -L command but nothing is happend. 
I wait 30 minutes or so an tra to kill the process - impossible. I must 
restart my rescue system.

I would be great if you can help me.

Regards

Juergen
