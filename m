Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Oct 2006 03:09:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9RA98aG012117
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 03:09:10 -0700
Received: from smtp2.ac-dijon.fr (smtp.ac-dijon.fr [194.167.18.200])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ABDF4DA292
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 01:58:17 -0700 (PDT)
Received: from ac-dijon.fr (localhost.localdomain [127.0.0.1])
	by smtp2.ac-dijon.fr (Postfix) with ESMTP id 6123B12B6B5
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 10:52:54 +0200 (CEST)
Message-ID: <4541CA71.5040909@ac-dijon.fr>
Date: Fri, 27 Oct 2006 10:59:29 +0200
From: =?ISO-8859-1?Q?Jo=EBl_Cuissinat?= <joel.cuissinat@ac-dijon.fr>
MIME-Version: 1.0
Subject: Kernel Oops
Content-Type: multipart/mixed;
 boundary="------------050705080401040501010106"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------050705080401040501010106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I'm working for the french national education.
We work on a server for students since 3 years.
The solution is based on a Mandrake 9.1 but with a large number of updates.
Our kernel is : 2.4.32 and the xfstools are updated :
- xfsdump-2.2.42
- xfsprogs-2.8.11
- libxfs1-2.8.11
We made a tool  to create students and about 1 time over 10 we have a 
kernel Oops.
With the same data we can reproduce the crash and it always append at 
the same place (the same student).
It was the same 2 years ago with older kernel and xfs releases but we 
hadn't enough student databases to test.  Now, the project is growing 
and the number of crashes in schools too !

The user creation process is composed with :
mkdir, setfacl, chown, setquota for a pam-ldap authentification.

The Oops usually happends on the chown instruction but if we remove it, 
it happends on the setquota instruction which is one line behind.

Cheers,

Joël Cuissinat

-- 
Joël Cuissinat
Equipe EOLE
CETIAD Dijon, France
http://eole.orion.education.fr 
--


--------------050705080401040501010106
Content-Type: text/plain;
 name="ksymoops.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ksymoops.txt"

Oct 25 18:17:52 jscribe kernel: Unable to handle kernel NULL pointer dereference at virtual address 00000006                                               Oct 25 18:17:52 jscribe kernel:  printing eip:
Oct 25 18:17:52 jscribe kernel: c021de83                                                                                                                   Oct 25 18:17:52 jscribe kernel: *pgd = 0000000000000000
Oct 25 18:17:52 jscribe kernel: CPU:    0                                                                                                                  Oct 25 18:17:52 jscribe kernel: EIP:    0010:[xfs_trans_brelse+51/240]    Not tainted
Oct 25 18:17:52 jscribe kernel: EIP:    0010:[<c021de83>]    Not tainted                                                                                   Oct 25 18:17:52 jscribe kernel: EFLAGS: 00010246
Using defaults from ksymoops -t elf32-i386 -a i386
Oct 25 18:17:52 jscribe kernel: eax: 00000000   ebx: c59ed790   ecx: c59ed790   edx: 00000000                                                              Oct 25 18:17:52 jscribe kernel: esi: c5352e98   edi: ce520d80   ebp: ce520d80   esp: c6b97d2c
Warning (Oops_set_regs): garbage 'Oct 25 18:17:52 jscribe kernel: esi: c5352e98   edi: ce520d80   ebp: ce520d80   esp: c6b97d2c' at end of register line ignored
Oct 25 18:17:52 jscribe kernel: ds: 0018   es: 0018   ss: 0018                                                                                             Oct 25 18:17:52 jscribe kernel: Process chown (pid: 15389, stackpage=c6b97000)
Oct 25 18:17:52 jscribe kernel: Stack: 00000000 00000000 c5352e98 c0235f2c c5352e98 ce520d80 00000000 c5d7f198                                             Oct 25 18:17:52 jscribe kernel:        ce520d80 00000000 c5352e98 cff310a0 00000004 c0235fbf c5352e98 0000302d
Oct 25 18:17:52 jscribe kernel:        cff310a0 00000402 cf8b0980 cf8b0984 0000302d cf8b0c00 c023621a cf8b0c00                                             Oct 25 18:17:52 jscribe kernel: Call Trace:    [xfs_qm_dqread+188/208] [xfs_qm_idtodq+127/224] [xfs_qm_dqget+218/848] [xfs_qm_vop_dqalloc+245/624] [xfs_set
Oct 25 18:17:52 jscribe kernel:   [<c01d6d28>] [<c022d7f7>] [<c017f678>] [<c0165a11>] [<c0165a9e>] [<c012bf13>]                                            Oct 25 18:17:52 jscribe kernel:
Oct 25 18:17:52 jscribe kernel: Code: 8a 42 06 83 e0 01 84 c0 75 f2 f6 43 30 04 75 ec 52 56 e8 a6

                                                                                                                                                           >>EIP; c021de83 <xfs_trans_brelse+33/f0>   <=====

>>ebx; c59ed790 <_end+556a7ec/103890bc>                                                                                                                    >>ecx; c59ed790 <_end+556a7ec/103890bc>
                                                                                                                                                           Code;  c021de83 <xfs_trans_brelse+33/f0>
00000000 <_EIP>:                                                                                                                                           Code;  c021de83 <xfs_trans_brelse+33/f0>   <=====
   0:   8a 42 06                  mov    0x6(%edx),%al   <=====                                                                                            Code;  c021de86 <xfs_trans_brelse+36/f0>
   3:   83 e0 01                  and    $0x1,%eax                                                                                                         Code;  c021de89 <xfs_trans_brelse+39/f0>
   6:   84 c0                     test   %al,%al
Code;  c021de8b <xfs_trans_brelse+3b/f0>
   8:   75 f2                     jne    fffffffc <_EIP+0xfffffffc>
Code;  c021de8d <xfs_trans_brelse+3d/f0>
   a:   f6 43 30 04               testb  $0x4,0x30(%ebx)
Code;  c021de91 <xfs_trans_brelse+41/f0>
   e:   75 ec                     jne    fffffffc <_EIP+0xfffffffc>
Code;  c021de93 <xfs_trans_brelse+43/f0>
  10:   52                        push   %edx
Code;  c021de94 <xfs_trans_brelse+44/f0>
  11:   56                        push   %esi
Code;  c021de95 <xfs_trans_brelse+45/f0>
  12:   e8 a6 00 00 00            call   bd <_EIP+0xbd>


2 warnings and 1 error issued.  Results may not be reliable.


--------------050705080401040501010106--
