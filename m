Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 10:39:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NHdEaZ030741
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 10:39:14 -0700
Received: from smtp.stepping-stone.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4615D31B1AD
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 10:40:23 -0700 (PDT)
Received: from smtp.stepping-stone.ch (smtp.stepping-stone.ch [193.58.255.135]) by cuda.sgi.com with ESMTP id KWK0FjKBPCWoj1A5 for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 10:40:23 -0700 (PDT)
Received: from localhost (mail-scanner-01.int.stepping-stone.ch [10.59.255.136])
	by smtp.stepping-stone.ch (Postfix) with ESMTP id D107B863449
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 19:40:22 +0200 (CEST)
Received: from smtp.stepping-stone.ch ([10.59.255.135])
 by localhost (mail-scanner-01.int.stepping-stone.ch [10.59.255.136]) (amavisd-new, port 10024)
 with LMTP id 21448-01-96 for <xfs@oss.sgi.com>;
 Wed, 23 Jul 2008 19:40:20 +0200 (CEST)
Received: from [192.168.1.201] (unknown [212.103.65.198])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by smtp.stepping-stone.ch (Postfix) with ESMTP id 2A3D3863446
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 19:40:20 +0200 (CEST)
Message-ID: <48876D03.8010804@stepping-stone.ch>
Date: Wed, 23 Jul 2008 19:40:19 +0200
From: Christian Affolter <christian.affolter@stepping-stone.ch>
MIME-Version: 1.0
Subject: Corruption of in-memory data detected - on heavy  hard linking
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dear XFS users

While using rsnapshot [1] on an XFS filesystem I encountered the 
following error, which I can reproduce using the bash command below:

i=0; while (( $i <20 )); do
     rm -rf link-dir;
     cp -al orig-dir link-dir

     echo "Round $i over"; let i++;
done

The problem mostly happens between the 6th and 10th run.

"orig-dir" contains around 12 GB of data and around 40'000 files (the 
filesystem is 50 GB whereas 27 GB are free, mount options: 
rw,noatime,usrquota).

The problem doesn't occur with a reiserfs filesystem (on the same device).

Kernel-Error:
Filesystem "sdc1": XFS internal error xfs_trans_cancel at line 1163 of 
file fs/xfs/xfs_trans.c.  Caller 0xffffffff803a4fcf
Pid: 22816, comm: cp Not tainted 2.6.24-gentoo-r8 #1

Call Trace:
  [<ffffffff803a4fcf>] xfs_link+0x26f/0x390
  [<ffffffff8039c656>] xfs_trans_cancel+0x126/0x150
  [<ffffffff803a4fcf>] xfs_link+0x26f/0x390
  [<ffffffff8039cf4b>] xfs_trans_unlocked_item+0x3b/0x60
  [<ffffffff803aff8c>] xfs_vn_link+0x3c/0xb0
  [<ffffffff802952b3>] vfs_link+0x123/0x180
  [<ffffffff802984b1>] sys_linkat+0x151/0x180
  [<ffffffff802901b7>] cp_new_stat+0xe7/0x100
  [<ffffffff80290276>] sys_newlstat+0x36/0x50
  [<ffffffff8020bbce>] system_call+0x7e/0x83

xfs_force_shutdown(sdc1,0x8) called from line 1164 of file 
fs/xfs/xfs_trans.c.  Return address = 0xffffffff8039c66f
Filesystem "sdc1": Corruption of in-memory data detected.  Shutting down 
filesystem: sdc1
Please umount the filesystem, and rectify the problem(s)
xfs_force_shutdown(sdc1,0x1) called from line 420 of file 
fs/xfs/xfs_rw.c.  Return address = 0xffffffff803a7fe9
xfs_force_shutdown(sdc1,0x1) called from line 420 of file 
fs/xfs/xfs_rw.c.  Return address = 0xffffffff803a7fe9

After remounting, everything seems to be fine, even xfs_repair (xfsprogs 
2.8.11) doesn't find any problems on the filesystem.

The above error happens on a 2.6.24-gentoo-r8 SMP 64bit kernel with 4 GB 
of memory (~3G free), Intel 5000V chipset (ASUS DSBV-D), on top of a 
Areca ARC-1160 (V1.42) RAID controller.

According to memcheck the memory seems to be OK, anyway I replaced the 
DIMMs with no success.

Google leads to a lot of results, for the above error message, however I 
only found one forum entry [2] which seems to look similar.


Any help would be highly appreciated

Many thanks!
Chris


[1]http://www.rsnapshot.org/
[2]http://ubuntuforums.org/showthread.php?t=741425

-- 
stepping stone GmbH
Pappelweg 41
CH-3013 Bern

Telefon: +41 31 332 53 63
www.stepping-stone.ch
christian.affolter@stepping-stone.ch
