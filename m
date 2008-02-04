Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 08:30:00 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m14GTo2P007893
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 08:29:55 -0800
Received: from mx1.emlix.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A009D82B7D
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2008 08:30:12 -0800 (PST)
Received: from mx1.emlix.com (mx1.emlix.com [193.175.82.87]) by cuda.sgi.com with ESMTP id c5McXkNVSUv1M6zp for <xfs@oss.sgi.com>; Mon, 04 Feb 2008 08:30:12 -0800 (PST)
Received: from gate.emlix.com ([193.175.27.217]:50835 helo=mailer.emlix.com)
	by mx1.emlix.com with esmtp (Exim 4.63)
	(envelope-from <tu@emlix.com>)
	id 1JM4QM-0007MD-Ny
	for xfs@oss.sgi.com; Mon, 04 Feb 2008 17:44:02 +0100
Date: Mon, 4 Feb 2008 17:30:09 +0100
From: Tobias Ulmer <tu@emlix.com>
Subject: Another oops in xfs_file_readdir (vanilla linux 2.6.24+)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-Id: <E1JM4Cv-0007hi-OO@mailer.emlix.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

i've got a nice oops from a clean pull of linus tree on saturday
(head is 24e1c13c93cbdd05e4b7ea921c0050b036555adc)

BUG: unable to handle kernel paging request at f8000000
IP: [<c025afb7>] xfs_file_readdir+0x157/0x1e0
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in:

Pid: 30823, comm: rm Not tainted (2.6.24toy #18)
EIP: 0060:[<c025afb7>] EFLAGS: 00010246 CPU: 0
EIP is at xfs_file_readdir+0x157/0x1e0
EAX: 00000000 EBX: 0000046b ECX: 00000028 EDX: 00000000
ESI: 00000000 EDI: f7fffff8 EBP: de28e480 ESP: e04cdf18
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rm (pid: 30823, ti=e04cc000 task=ccf96f60 task.ti=e04cc000)
Stack: 0000046b 00000000 090485aa 00000000 00000000 c016c0e0 e04cdf94 f6da6280
       00000000 00000000 00000000 0000046b 00000000 f7fff000 00001000 00000ff8
       0000046e 00000000 c03974c0 f6da6280 de28d3c0 c016c0e0 c016c321 e04cdf94
Call Trace:
 [<c016c0e0>] filldir64+0x0/0xe0
 [<c016c0e0>] filldir64+0x0/0xe0
 [<c016c321>] vfs_readdir+0x81/0xa0
 [<c016c3b3>] sys_getdents64+0x73/0xd0
 [<c010300e>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 81 e3 ff ff ff 7f 89 1c 24 ff 54 24 14 85 c0 75 51 8b 4f 10 31 d2 83 c1 1f 83 e1 f8 29 4c 24 24 19 24 28 00 <8b> 47 08 8b 57 0c 89 44 24 2c 89 54 24 30 7f 9d 0f 8c 23 ff ff
EIP: [<c025afb7>] xfs_file_readdir+0x157/0x1e0 SS:ESP 0068:e04cdf18
---[ end trace 52962aefa1b8fed3 ]---

Poking around in the sources using objdump shows that it breaks at 0x207
(xfs_file_readdir begins at 0xb0)

200:   01 cf                   add    %ecx,%edi
                }

                size = buf.used;
                de = (struct hack_dirent *)buf.dirent;
                curr_offset = de->offset /* & 0x7fffffff */;
                while (size > 0) {
 202:   83 7c 24 28 00          cmpl   $0x0,0x28(%esp)

                        reclen = ALIGN(sizeof(struct hack_dirent) + de->namlen,
                                       sizeof(u64));
                        size -= reclen;
                        de = (struct hack_dirent *)((char *)de + reclen);
                        curr_offset = de->offset /* & 0x7fffffff */;
 207:   8b 47 08                mov    0x8(%edi),%eax
 20a:   8b 57 0c                mov    0xc(%edi),%edx
 20d:   89 44 24 2c             mov    %eax,0x2c(%esp)
 211:   89 54 24 30             mov    %edx,0x30(%esp)
                }

                size = buf.used;
                de = (struct hack_dirent *)buf.dirent;
                curr_offset = de->offset /* & 0x7fffffff */;


Reproduction:
No idea, the system was used for compiling various software packages.
The process in question did delete a file tree of about ~100MB sources
and binaries, nothing special.

Please keep me in CC, thanks,
Tobias
