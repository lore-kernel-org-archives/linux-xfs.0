Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 09:25:26 -0700 (PDT)
Received: from mail.mdlink.de (hydra.mdlink.de [213.211.192.38])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6SGPDDW009517
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 09:25:13 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.mdlink.de (Postfix) with ESMTP id BCB0E80E5E6D
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 16:21:22 +0200 (CEST)
Received: from [213.211.192.21] (premium.mdlink.de [213.211.192.21])
	by mail.mdlink.de (Postfix) with ESMTP id 877BF80E37FA
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 16:21:22 +0200 (CEST)
Message-ID: <44CA1D89.3080104@mdlink.de>
Date: Fri, 28 Jul 2006 16:22:01 +0200
From: Frank Patzig <fp@mdlink.de>
MIME-Version: 1.0
Subject: [xfs] quota project problem
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hallo,

i have a problem with project quota. Can i help you.

combolix:~ # uname -a
Linux combolix 2.6.18_rc1-jen27-default #1 Thu Jul 13 01:34:23 CEST 2006 
i686
i686 i386 GNU/Linux

combolix:~ # cat /etc/mtab
/dev/hdc2 / xfs rw,uquota,gquota,pquota 0 0
proc /proc proc rw 0 0
sysfs /sys sysfs rw 0 0
tmpfs /dev/shm tmpfs rw 0 0
devpts /dev/pts devpts rw,mode=0620,gid=5 0 0
usbfs /proc/bus/usb usbfs rw 0 0

combolix:~ # echo 42:/var/log >> /etc/projects
combolix:~ # echo logfiles:42 >> /etc/projid

combolix:~ # xfs_quota -x -c 'project -c logfiles' /
Checking project logfiles (path /var/log)...
Processed 1 /etc/projects paths for project logfiles

combolix:~ # xfs_quota -x -c 'limit -p bhard=1g logfiles' /
xfs_quota: cannot set limits: No such process

xfs_quota -x -c 'state -p' /
Project quota state on / (/dev/hdc2)
   Accounting: OFF
   Enforcement: OFF
   Inode: #18446744073709551615 (0 blocks, 0 extents)
Blocks grace time: [7 days]
Inodes grace time: [7 days]
Realtime Blocks grace time: [7 days]

combolix:~ # xfs_quota -x -c 'report -p' /
not answer

combolix:~ # xfs_quota -x -c 'quota -p logfile' /
xfs_quota: cannot find project logfile
combolix:~ # xfs_quota -x -c 'quota -p 42' /
not answer

combolix:~ # xfs_quota -x -c 'print'
Filesystem          Pathname
/                   /dev/hdc2 (uquota)
/var/log            /dev/hdc2 (project 42, logfiles)

combolix:~ # xfs_quota -x -c 'quot -p'
/dev/hdc2 (/) Project:
    16080    logfiles

combolix:~ # xfs_quota -x -c 'free'
Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/hdc2             76006520    4666116   71340404    7% /
XFS_GETQUOTA: No such process

combolix:~ # xfs_quota -x -c 'path'
       Filesystem          Pathname
[000] /                   /dev/hdc2 (uquota)
  001  /var/log            /dev/hdc2 (project 42, logfiles)

I have not a idee for this problem.

Thanks
-- 
Frank Patzig	

MDlink online service center GmbH       mail: fp@mdlink.de
Universitätsplatz 12                    phone:  +49 391 25568 0
Magdeburg                               fax:    +49 391 25568 99
39104                                   http://www.mdlink.de
Germany	
