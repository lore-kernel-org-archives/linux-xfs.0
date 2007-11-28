Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Nov 2007 15:57:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lASNvR6h029975
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2007 15:57:32 -0800
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA27149 for <xfs@oss.sgi.com>; Thu, 29 Nov 2007 10:57:36 +1100
Message-ID: <474E003A.7020000@sgi.com>
Date: Thu, 29 Nov 2007 10:56:42 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: 2.6.24-rc3 oopses while mounting fs
References: <20071128134523.GF7793@luba>
In-Reply-To: <20071128134523.GF7793@luba>
Content-Type: multipart/mixed;
 boundary="------------040500030409020304090304"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------040500030409020304090304
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Peter,

This looks like a problem we've just fixed, try this patch.
We'll get this to mainline soon.

Lachlan

KELEMEN Peter wrote:
> Box is x86_64 with RHEL4 userspace.  I have the log image saved
> and I can play with the filesystem if needed.
> 
> Peter
> 
> SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> SGI XFS Quota Management subsystem
> XFS mounting filesystem sdc
> Starting XFS recovery on filesystem: sdc (logdev: internal)
> Unable to handle kernel paging request at ffffc20001c9b000 RIP: 
>  [<ffffffff881c6175>] :xfs:xlog_recover_add_to_trans+0x64/0xef
> PGD 15781d067 PUD 15781c067 PMD 130fda067 PTE 0
> Oops: 0000 [1] SMP 
> CPU 0 
> Modules linked in: xfs sd_mod 3w_9xxx scsi_mod ohci_hcd uhci_hcd ehci_hcd ipv6 bnx2 sky2 r8169 ns83820 dl2k acenic e100 tg3 e1000 mii
> Pid: 2434, comm: mount Not tainted 2.6.24-rc3 #1
> RIP: 0010:[<ffffffff881c6175>]  [<ffffffff881c6175>] :xfs:xlog_recover_add_to_trans+0x64/0xef
> RSP: 0018:ffff81013240f728  EFLAGS: 00010286
> RAX: ffffc20001c9c000 RBX: 000000000020bd78 RCX: 00000000001cc280
> RDX: 0000000000000000 RSI: ffffc20001c9b000 RDI: ffffc20001cdbaf8
> RBP: ffff81013240f758 R08: ffff8101578011a2 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000002 R12: ffff8101318e4220
> R13: ffffc20001c5b508 R14: ffff8101318e4770 R15: ffffc20001c5b4fc
> FS:  00002b0dc2141b00(0000) GS:ffffffff805ef000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffffc20001c9b000 CR3: 000000013243d000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount (pid: 2434, threadinfo ffff81013240e000, task ffff8101320a4000)
> Stack:  0020bd785769c5e8 000000005769c5e8 000000000000000a ffffc20001c5b508
>  000000000000011e ffffc20001c5b4fc ffff81013240f7b8 ffffffff881c79db
>  ffffc20001c6a000 00000001881da0bc ffff81013246c000 ffff81013240f828
> Call Trace:
>  [<ffffffff881c79db>] :xfs:xlog_recover_process_data+0x184/0x1d9
>  [<ffffffff881c89cb>] :xfs:xlog_do_recovery_pass+0x74b/0x795
>  [<ffffffff881c8a52>] :xfs:xlog_do_log_recovery+0x3d/0x82
>  [<ffffffff881c8aa9>] :xfs:xlog_do_recover+0x12/0x11c
>  [<ffffffff881c8c37>] :xfs:xlog_recover+0x84/0x92
>  [<ffffffff881c3125>] :xfs:xfs_log_mount+0x8c/0xe4
>  [<ffffffff881cad92>] :xfs:xfs_mountfs+0x67d/0x97b
>  [<ffffffff881cbcb7>] :xfs:xfs_mru_cache_create+0x170/0x1d5
>  [<ffffffff881b2f04>] :xfs:xfs_fstrm_free_func+0x0/0x81
>  [<ffffffff881be67c>] :xfs:xfs_ioinit+0xb/0xd
>  [<ffffffff881d0cfa>] :xfs:xfs_mount+0x2bb/0x36b
>  [<ffffffff881e1355>] :xfs:xfs_fs_fill_super+0xd2/0x245
>  [<ffffffff802b7b9f>] get_filesystem+0x17/0x39
>  [<ffffffff802a4659>] sget+0x3fb/0x418
>  [<ffffffff802a4661>] sget+0x403/0x418
>  [<ffffffff802a4d79>] set_bdev_super+0x0/0x14
>  [<ffffffff802a4ec2>] get_sb_bdev+0x123/0x16f
>  [<ffffffff881e1283>] :xfs:xfs_fs_fill_super+0x0/0x245
>  [<ffffffff881e14db>] :xfs:xfs_fs_get_sb+0x13/0x18
>  [<ffffffff802a5107>] vfs_kern_mount+0x8f/0x11c
>  [<ffffffff802a51d8>] do_kern_mount+0x44/0xf4
>  [<ffffffff802ba0d3>] do_mount+0x6d8/0x71e
>  [<ffffffff80335682>] __up_read+0x93/0x9b
>  [<ffffffff80252261>] up_read+0x23/0x27
>  [<ffffffff8047a679>] do_page_fault+0x42e/0x7c7
>  [<ffffffff80284d61>] zone_statistics+0x64/0x69
>  [<ffffffff8027e4e0>] __alloc_pages+0x6b/0x311
>  [<ffffffff802ba3c8>] sys_mount+0x8a/0xcc
>  [<ffffffff8020bf8e>] system_call+0x7e/0x83
> 
> 
> Code: f3 a4 49 89 c7 49 8b 54 24 08 8b 42 18 85 c0 74 0e 3b 42 14 
> 

--------------040500030409020304090304
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch"

LS0tIGEvZnMveGZzL2xpbnV4LTIuNi94ZnNfYnVmLmMJMjAwNy0xMS0yOSAx
MDo1MzowMS4wMDAwMDAwMDAgKzExMDAKKysrIGIvZnMveGZzL2xpbnV4LTIu
Ni94ZnNfYnVmLmMJMjAwNy0xMS0yOSAxMDo1MzowMS4wMDAwMDAwMDAgKzEx
MDAKQEAgLTcyNSwxNSArNzI1LDE1IEBACiB7CiAJaW50CQkJcnZhbDsKIAlp
bnQJCQlpID0gMDsKLQlzaXplX3QJCQlwdHI7Ci0Jc2l6ZV90CQkJZW5kLCBl
bmRfY3VyOwotCW9mZl90CQkJb2Zmc2V0OworCXVuc2lnbmVkIGxvbmcJCXBh
Z2VhZGRyOworCXVuc2lnbmVkIGxvbmcJCW9mZnNldDsKKwlzaXplX3QJCQli
dWZsZW47CiAJaW50CQkJcGFnZV9jb3VudDsKIAotCXBhZ2VfY291bnQgPSBQ
QUdFX0NBQ0hFX0FMSUdOKGxlbikgPj4gUEFHRV9DQUNIRV9TSElGVDsKLQlv
ZmZzZXQgPSAob2ZmX3QpIG1lbSAtICgob2ZmX3QpbWVtICYgUEFHRV9DQUNI
RV9NQVNLKTsKLQlpZiAob2Zmc2V0ICYmIChsZW4gPiBQQUdFX0NBQ0hFX1NJ
WkUpKQotCQlwYWdlX2NvdW50Kys7CisJcGFnZWFkZHIgPSAodW5zaWduZWQg
bG9uZyltZW0gJiBQQUdFX0NBQ0hFX01BU0s7CisJb2Zmc2V0ID0gKHVuc2ln
bmVkIGxvbmcpbWVtIC0gcGFnZWFkZHI7CisJYnVmbGVuID0gUEFHRV9DQUNI
RV9BTElHTihsZW4gKyBvZmZzZXQpOworCXBhZ2VfY291bnQgPSBidWZsZW4g
Pj4gUEFHRV9DQUNIRV9TSElGVDsKIAogCS8qIEZyZWUgYW55IHByZXZpb3Vz
IHNldCBvZiBwYWdlIHBvaW50ZXJzICovCiAJaWYgKGJwLT5iX3BhZ2VzKQpA
QCAtNzQ3LDIyICs3NDcsMTUgQEAKIAkJcmV0dXJuIHJ2YWw7CiAKIAlicC0+
Yl9vZmZzZXQgPSBvZmZzZXQ7Ci0JcHRyID0gKHNpemVfdCkgbWVtICYgUEFH
RV9DQUNIRV9NQVNLOwotCWVuZCA9IFBBR0VfQ0FDSEVfQUxJR04oKHNpemVf
dCkgbWVtICsgbGVuKTsKLQllbmRfY3VyID0gZW5kOwotCS8qIHNldCB1cCBm
aXJzdCBwYWdlICovCi0JYnAtPmJfcGFnZXNbMF0gPSBtZW1fdG9fcGFnZSht
ZW0pOwotCi0JcHRyICs9IFBBR0VfQ0FDSEVfU0laRTsKLQlicC0+Yl9wYWdl
X2NvdW50ID0gKytpOwotCXdoaWxlIChwdHIgPCBlbmQpIHsKLQkJYnAtPmJf
cGFnZXNbaV0gPSBtZW1fdG9fcGFnZSgodm9pZCAqKXB0cik7Ci0JCWJwLT5i
X3BhZ2VfY291bnQgPSArK2k7Ci0JCXB0ciArPSBQQUdFX0NBQ0hFX1NJWkU7
CisKKwlmb3IgKGkgPSAwOyBpIDwgYnAtPmJfcGFnZV9jb3VudDsgaSsrKSB7
CisJCWJwLT5iX3BhZ2VzW2ldID0gbWVtX3RvX3BhZ2UoKHZvaWQgKilwYWdl
YWRkcik7CisJCXBhZ2VhZGRyICs9IFBBR0VfQ0FDSEVfU0laRTsKIAl9CiAJ
YnAtPmJfbG9ja2VkID0gMDsKIAotCWJwLT5iX2NvdW50X2Rlc2lyZWQgPSBi
cC0+Yl9idWZmZXJfbGVuZ3RoID0gbGVuOworCWJwLT5iX2NvdW50X2Rlc2ly
ZWQgPSBsZW47CisJYnAtPmJfYnVmZmVyX2xlbmd0aCA9IGJ1ZmxlbjsKIAli
cC0+Yl9mbGFncyB8PSBYQkZfTUFQUEVEOwogCiAJcmV0dXJuIDA7Cg==

--------------040500030409020304090304--
