Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2454C7F58
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 03:37:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8DA3304062
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 01:37:11 -0800 (PST)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id wOTJrX0u6MFcGzUG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 01:37:09 -0800 (PST)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id 5116A3143A8
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 10:37:03 +0100 (CET)
MIME-Version: 1.0
Date: Sun, 23 Feb 2014 10:37:03 +0100
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: gentoo linux, kernel 3.10.31 mount options =?UTF-8?Q?bug=3F?=
Message-ID: <9963a76fbd006355c9ffd79f341c9971@zbfmail.de>
Reply-To: weber@zbfmail.de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Xfs <xfs@oss.sgi.com>



hello list,

i have a question about mount options.

at first my fstab:

/dev/md0                /boot           xfs             noauto,noatime  
1 2
/dev/md2                /               xfs             
noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep      
0 1
/dev/md1                /tmp            xfs             
noexec,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep 
       0 1
/dev/VolGroup01/var-www /var/www        xfs             
noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep      
0 1
/dev/VolGroup01/var-log /var/log        xfs             
noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep      
0 1
/dev/VolGroup01/var-lib-mysql   /var/lib/mysql  xfs             
noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep      
0 1
/dev/sda5               none            swap            sw,pri=1         
        0 0
/dev/sdb5               none            swap            sw,pri=2         
        0 0

(YES!, normally i use Label or UUID..... but this is only a test 
machine.....)


AFTER reboot "mount" shows this:

rootfs on / type rootfs (rw)
/dev/root on / type xfs 
(rw,noatime,nodiratime,attr2,nobarrier,inode64,noquota)
/dev/md1 on /tmp type xfs 
(rw,noexec,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)
/dev/mapper/VolGroup01-var--www on /var/www type xfs 
(rw,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)
/dev/mapper/VolGroup01-var--log on /var/log type xfs 
(rw,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)
/dev/mapper/VolGroup01-var--lib--mysql on /var/lib/mysql type xfs 
(rw,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)


on /dev/root "discrad" and some other are not shown


when i do a "mount -o remount /"

"mount" shows this:


rootfs on / type rootfs (rw)
/dev/root on / type xfs 
(rw,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)
/dev/md1 on /tmp type xfs 
(rw,noexec,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)
/dev/mapper/VolGroup01-var--www on /var/www type xfs 
(rw,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)
/dev/mapper/VolGroup01-var--log on /var/log type xfs 
(rw,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)
/dev/mapper/VolGroup01-var--lib--mysql on /var/lib/mysql type xfs 
(rw,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)

now,all options from /etc/fstab are listed.
Is this XFS related?

Kernel 3.10.31
Grub2

in the /etc/grub.d/40_custom i have set:


menuentry "gentoo linux 3.10.31" {
insmod xfs
insmod mdraid09
insmod mdraid1x
insmod lvm
set root=(hd0,2)
linux /bzImage-3.10.31 root=/dev/md2 elevator=cfq clocksource=hpet 
cgroup_disable=memory
}


If you need any more info, let me know.

thnaks for any tipps or answers

marko

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
