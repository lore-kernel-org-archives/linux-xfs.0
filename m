Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 09:46:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m74GkdFB016120
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 09:46:40 -0700
Received: from smtp.stepping-stone.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58DCAEFF711
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 09:47:52 -0700 (PDT)
Received: from smtp.stepping-stone.ch (smtp.stepping-stone.ch [193.58.255.135]) by cuda.sgi.com with ESMTP id P6PndgRMBADI6l0i for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 09:47:52 -0700 (PDT)
Received: from localhost (mail-scanner-01.int.stepping-stone.ch [10.59.255.136])
	by smtp.stepping-stone.ch (Postfix) with ESMTP id 3497688F26C
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:47:50 +0200 (CEST)
Received: from smtp.stepping-stone.ch ([10.59.255.135])
 by localhost (mail-scanner-01.int.stepping-stone.ch [10.59.255.136]) (amavisd-new, port 10024)
 with LMTP id 29903-02-23 for <xfs@oss.sgi.com>;
 Mon,  4 Aug 2008 18:47:47 +0200 (CEST)
Received: from [192.168.1.201] (unknown [212.103.65.198])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by smtp.stepping-stone.ch (Postfix) with ESMTP id 78F3889076D
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:47:47 +0200 (CEST)
Message-ID: <489732B2.7000201@stepping-stone.ch>
Date: Mon, 04 Aug 2008 18:47:46 +0200
From: Christian Affolter <c.affolter@stepping-stone.ch>
MIME-Version: 1.0
Subject: Re: Corruption of in-memory data detected - on heavy  hard linking
References: <48876D03.8010804@stepping-stone.ch> <20080725052051.GA26367@infradead.org>
In-Reply-To: <20080725052051.GA26367@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi

> On Wed, Jul 23, 2008 at 07:40:19PM +0200, Christian Affolter wrote:
>> Kernel-Error:
>> Filesystem "sdc1": XFS internal error xfs_trans_cancel at line 1163 of  
>> file fs/xfs/xfs_trans.c.  Caller 0xffffffff803a4fcf
>> Pid: 22816, comm: cp Not tainted 2.6.24-gentoo-r8 #1
> 
> 2.6.24 is pretty old.  Did you try with a recent kernel?  We had some
> fixes for in-core memory corruption although I don't remember one in
> this area.

I finally found the time to update the kernel to a recent 2.6.26 version.

Unfortunately the problem still exists:
Filesystem "dm-3": XFS internal error xfs_trans_cancel at line 1163 of 
file fs/xfs/xfs_trans.c.  Caller 0xffffffff803a6672
Pid: 12584, comm: cp Not tainted 2.6.26-gentoo #1

Call Trace:
  [<ffffffff803a6672>] xfs_create+0x1c2/0x4c0
  [<ffffffff8039fd16>] xfs_trans_cancel+0x126/0x150
  [<ffffffff803a6672>] xfs_create+0x1c2/0x4c0
  [<ffffffff803b186d>] xfs_vn_mknod+0x16d/0x2c0
  [<ffffffff80291b7c>] vfs_create+0xcc/0x130
  [<ffffffff8029539f>] do_filp_open+0x77f/0x860
  [<ffffffff80286d1a>] do_sys_open+0x5a/0xf0
  [<ffffffff8020b49b>] system_call_after_swapgs+0x7b/0x80

xfs_force_shutdown(dm-3,0x8) called from line 1164 of file 
fs/xfs/xfs_trans.c.  Return address = 0xffffffff8039fd2f
Filesystem "dm-3": Corruption of in-memory data detected.  Shutting down 
filesystem: dm-3
Please umount the filesystem, and rectify the problem(s)
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-3,0x1) called from line 420 of file 
fs/xfs/xfs_rw.c.  Return address = 0xffffffff803a9529
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-3,0x1) called from line 420 of file 
fs/xfs/xfs_rw.c.  Return address = 0xffffffff803a9529
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.
Filesystem "dm-3": xfs_log_force: error 5 returned.


Before the shutdown happens the copy command receives a
"No space left on device" error:
cp: cannot create regular file `[file name snipped': No space left on device
cp: cannot create regular file `[file name snipped]': Input/output error

Although the device has more than 50% free space as well as free inodes.

The affected device was initialized with old xfsprogs (2.8.11):
meta-data=/dev/evms/vol1 isize=256    agcount=3207, agsize=4096 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=13132799, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=1024, version=1
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0


Creating a new device with xfsprogs (2.9.7) leads to the following layout:
meta-data=/dev/sdc1              isize=256    agcount=5, agsize=3662818 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=17750000, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=7153, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


On the newly created device, the problem is much harder to reproduce, 
however it happens nonetheless after around a day of heavy copying and 
deleting.


Any further hints?


Many thanks
Chris
