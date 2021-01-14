Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85723C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 10:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F59023A40
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 10:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbhANKWC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 05:22:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728485AbhANKV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 05:21:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610619633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=Xv0iGNcbAqwrBum9W5kB4ZEX957gfd2OM7KGFcV/loY=;
        b=PlEK1mjQ4JYUWNs+90Q/wlMy+Qqa41fSfcle3PDCt8NXg3a9BGavqQNRMvgnWSbl6ffo+1
        sMhSGicwfMpnRpexycFrC2FNYg07M8Xxs0EA5srDUt5vIAglJCe9fZl+Z+OyT9p2AJIX3r
        J33Qh6cPexPQLZhR0Y8NrQVMQ3uhUzk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-waB7_JG8PuWZzqa6Por3Vg-1; Thu, 14 Jan 2021 05:20:31 -0500
X-MC-Unique: waB7_JG8PuWZzqa6Por3Vg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C090802B42
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:20:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3472B62951
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:20:30 +0000 (UTC)
Received: from zmail26.collab.prod.int.phx2.redhat.com (zmail26.collab.prod.int.phx2.redhat.com [10.5.83.33])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2DACE18095C7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:20:30 +0000 (UTC)
Date:   Thu, 14 Jan 2021 05:20:29 -0500 (EST)
From:   Yumei Huang <yuhuang@redhat.com>
To:     linux-xfs@vger.kernel.org
Message-ID: <487974076.64709077.1610619629992.JavaMail.zimbra@redhat.com>
In-Reply-To: <1599642077.64707510.1610619249861.JavaMail.zimbra@redhat.com>
Subject: XFS: Assertion failed
MIME-Version: 1.0
Content-Type: multipart/mixed; 
        boundary="----=_Part_64709075_138468903.1610619629990"
X-Originating-IP: [10.72.13.105, 10.4.195.8]
Thread-Topic: Assertion failed
Thread-Index: mCcQXNHmJGcdeZbOB9Q4EWcDgRkdfw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

------=_Part_64709075_138468903.1610619629990
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hit the issue when doing syzkaller test with kernel 5.11.0-rc3(65f0d241). The C reproducer is attached.

Steps to Reproduce:
1. # gcc -pthread -o reproducer reproducer.c 
2. # ./reproducer 


Test results:
[  131.726790] XFS: Assertion failed: (iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 849
[  131.743687] ------------[ cut here ]------------
[  131.748350] WARNING: CPU: 18 PID: 1786 at fs/xfs/xfs_message.c:97 asswarn+0x1a/0x1d [xfs]
[  131.756764] Modules linked in: intel_rapl_msr intel_rapl_common edac_mce_amd kvm_amd rfkill kvm irqbypass mgag200 crct10dif_pclmul i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32_pclmul ccp sp5100_tco drm ipmi_ssif ses ghash_clmulni_intel pcspkr hpilo acpi_ipmi enclosure hpwdt i2c_piix4 k10temp rapl ipmi_si ipmi_devintf ipmi_msghandler acpi_tad acpi_cpufreq ip_tables xfs libcrc32c sd_mod t10_pi sg uas crc32c_intel serio_raw usb_storage smartpqi scsi_transport_sas tg3 wmi dm_mirror dm_region_hash dm_log dm_mod
[  131.805054] CPU: 18 PID: 1786 Comm: reproducer Tainted: G    B             5.11.0-rc3upstream65f0d241+ #2
[  131.814702] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 10/14/2017
[  131.823299] RIP: 0010:asswarn+0x1a/0x1d [xfs]
[  131.827868] Code: c4 d0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 40 d6 ad c0 e8 08 fa ff ff <0f> 0b c3 0f 1f 44 00 00 53 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 40
[  131.846777] RSP: 0018:ffff88812128f828 EFLAGS: 00010282
[  131.852059] RAX: 0000000000000000 RBX: 1ffff11024251f0b RCX: 0000000000000000
[  131.859256] RDX: dffffc0000000000 RSI: 000000000000000a RDI: ffffed1024251ef7
[  131.866458] RBP: ffff88812128f920 R08: ffffed110dcfe24d R09: ffffed110dcfe24d
[  131.873663] R10: ffff88886e7f1267 R11: ffffed110dcfe24c R12: ffff88812128fa68
[  131.880862] R13: ffff88819bf08280 R14: ffff88819bf08280 R15: ffff88819bf08000
[  131.888062] FS:  00007f18cb349700(0000) GS:ffff88886e600000(0000) knlGS:0000000000000000
[  131.896222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  131.902026] CR2: 0000000020000100 CR3: 0000000112820000 CR4: 00000000003506e0
[  131.909223] Call Trace:
[  131.911703]  xfs_setattr_size+0x742/0xd00 [xfs]
[  131.916427]  ? __vfs_removexattr+0xd1/0x130
[  131.920673]  ? xfs_setattr_nonsize+0xef0/0xef0 [xfs]
[  131.925836]  ? cap_inode_killpriv+0x11/0x20
[  131.930071]  ? security_inode_killpriv+0x3f/0x70
[  131.934740]  xfs_vn_setattr+0xea/0x3a0 [xfs]
[  131.939211]  ? xfs_vn_setattr_size+0x2a0/0x2a0 [xfs]
[  131.944375]  notify_change+0x744/0xda0
[  131.948173]  ? do_truncate+0xe2/0x180
[  131.951880]  do_truncate+0xe2/0x180
[  131.955412]  ? __x64_sys_openat2+0x1c0/0x1c0
[  131.959731]  ? ima_file_check+0xd9/0x120
[  131.963701]  ? security_inode_permission+0x79/0xc0
[  131.968545]  path_openat+0x11df/0x21f0
[  131.972340]  ? path_lookupat.isra.48+0x440/0x440
[  131.977012]  ? quarantine_put+0xe2/0x170
[  131.980979]  ? trace_hardirqs_on+0x1c/0x150
[  131.985211]  do_filp_open+0x176/0x250
[  131.988915]  ? lock_release+0x56e/0xcc0
[  131.992797]  ? may_open_dev+0xc0/0xc0
[  131.996503]  ? do_raw_spin_unlock+0x54/0x230
[  132.000827]  do_sys_openat2+0x2ee/0x5c0
[  132.004710]  ? rcu_read_unlock+0x50/0x50
[  132.008676]  ? file_open_root+0x210/0x210
[  132.012732]  ? ktime_get_coarse_real_ts64+0x122/0x150
[  132.017840]  do_sys_open+0x8a/0xd0
[  132.021284]  ? filp_open+0x50/0x50
[  132.024730]  ? syscall_trace_enter.isra.16+0x18e/0x250
[  132.029923]  do_syscall_64+0x33/0x40
[  132.033543]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  132.038647] RIP: 0033:0x7f18cac3c51d
[  132.042266] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3b 79 2c 00 f7 d8 64 89 01 48
[  132.061173] RSP: 002b:00007f18cb348e98 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
[  132.068817] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f18cac3c51d
[  132.076013] RDX: 0030656c69662f2e RSI: 0000000000000008 RDI: 0000000020000100
[  132.083209] RBP: 00007f18cb348ec0 R08: 0000000000000000 R09: 0000000000000000
[  132.090407] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff50ae2e4e
[  132.097607] R13: 00007fff50ae2e4f R14: 00007fff50ae2ee0 R15: 00007f18cb348fc0
[  132.104812] irq event stamp: 0
[  132.107902] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  132.114228] hardirqs last disabled at (0): [<ffffffff9c1ce85b>] copy_process+0x1a7b/0x6590
[  132.122570] softirqs last  enabled at (0): [<ffffffff9c1ce89f>] copy_process+0x1abf/0x6590
[  132.130905] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  132.137235] ---[ end trace d05db93236ee9da5 ]---


Syzkaller reproducer:
# {Threaded:true Collide:true Repeat:false RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: Fault:false FaultCall:-1 FaultNth:0 Leak:false NetInjection:false NetDevices:false NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false VhciInjection:false Wifi:false Sysctl:false UseTmpDir:false HandleSegv:false Repro:false Trace:false}
r0 = creat(&(0x7f0000000100)='./file0\x00', 0x8)
fsetxattr$security_capability(r0, &(0x7f0000000280)='security.capability\x00', &(0x7f00000002c0)=@v3={0x3000000, [{0x1762, 0x8}, {0x2, 0xffffffff}], 0xee00}, 0x18, 0x0)



Best Regards,

Yumei Huang


------=_Part_64709075_138468903.1610619629990
Content-Type: text/x-c++src; name=reproducer.c
Content-Disposition: attachment; filename=reproducer.c
Content-Transfer-Encoding: base64

Ly8gYXV0b2dlbmVyYXRlZCBieSBzeXprYWxsZXIgKGh0dHBzOi8vZ2l0aHViLmNvbS9nb29nbGUv
c3l6a2FsbGVyKQoKI2RlZmluZSBfR05VX1NPVVJDRSAKCiNpbmNsdWRlIDxlbmRpYW4uaD4KI2lu
Y2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRlIDxzdGRpbnQuaD4K
I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0cmluZy5o
PgojaW5jbHVkZSA8c3lzL3N5c2NhbGwuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVk
ZSA8dGltZS5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgojaW5jbHVkZSA8bGludXgvZnV0ZXguaD4K
CnN0YXRpYyB2b2lkIHNsZWVwX21zKHVpbnQ2NF90IG1zKQp7Cgl1c2xlZXAobXMgKiAxMDAwKTsK
fQoKc3RhdGljIHVpbnQ2NF90IGN1cnJlbnRfdGltZV9tcyh2b2lkKQp7CglzdHJ1Y3QgdGltZXNw
ZWMgdHM7CglpZiAoY2xvY2tfZ2V0dGltZShDTE9DS19NT05PVE9OSUMsICZ0cykpCglleGl0KDEp
OwoJcmV0dXJuICh1aW50NjRfdCl0cy50dl9zZWMgKiAxMDAwICsgKHVpbnQ2NF90KXRzLnR2X25z
ZWMgLyAxMDAwMDAwOwp9CgpzdGF0aWMgdm9pZCB0aHJlYWRfc3RhcnQodm9pZCogKCpmbikodm9p
ZCopLCB2b2lkKiBhcmcpCnsKCXB0aHJlYWRfdCB0aDsKCXB0aHJlYWRfYXR0cl90IGF0dHI7Cglw
dGhyZWFkX2F0dHJfaW5pdCgmYXR0cik7CglwdGhyZWFkX2F0dHJfc2V0c3RhY2tzaXplKCZhdHRy
LCAxMjggPDwgMTApOwoJaW50IGkgPSAwOwoJZm9yICg7IGkgPCAxMDA7IGkrKykgewoJCWlmIChw
dGhyZWFkX2NyZWF0ZSgmdGgsICZhdHRyLCBmbiwgYXJnKSA9PSAwKSB7CgkJCXB0aHJlYWRfYXR0
cl9kZXN0cm95KCZhdHRyKTsKCQkJcmV0dXJuOwoJCX0KCQlpZiAoZXJybm8gPT0gRUFHQUlOKSB7
CgkJCXVzbGVlcCg1MCk7CgkJCWNvbnRpbnVlOwoJCX0KCQlicmVhazsKCX0KCWV4aXQoMSk7Cn0K
CnR5cGVkZWYgc3RydWN0IHsKCWludCBzdGF0ZTsKfSBldmVudF90OwoKc3RhdGljIHZvaWQgZXZl
bnRfaW5pdChldmVudF90KiBldikKewoJZXYtPnN0YXRlID0gMDsKfQoKc3RhdGljIHZvaWQgZXZl
bnRfcmVzZXQoZXZlbnRfdCogZXYpCnsKCWV2LT5zdGF0ZSA9IDA7Cn0KCnN0YXRpYyB2b2lkIGV2
ZW50X3NldChldmVudF90KiBldikKewoJaWYgKGV2LT5zdGF0ZSkKCWV4aXQoMSk7CglfX2F0b21p
Y19zdG9yZV9uKCZldi0+c3RhdGUsIDEsIF9fQVRPTUlDX1JFTEVBU0UpOwoJc3lzY2FsbChTWVNf
ZnV0ZXgsICZldi0+c3RhdGUsIEZVVEVYX1dBS0UgfCBGVVRFWF9QUklWQVRFX0ZMQUcsIDEwMDAw
MDApOwp9CgpzdGF0aWMgdm9pZCBldmVudF93YWl0KGV2ZW50X3QqIGV2KQp7Cgl3aGlsZSAoIV9f
YXRvbWljX2xvYWRfbigmZXYtPnN0YXRlLCBfX0FUT01JQ19BQ1FVSVJFKSkKCQlzeXNjYWxsKFNZ
U19mdXRleCwgJmV2LT5zdGF0ZSwgRlVURVhfV0FJVCB8IEZVVEVYX1BSSVZBVEVfRkxBRywgMCwg
MCk7Cn0KCnN0YXRpYyBpbnQgZXZlbnRfaXNzZXQoZXZlbnRfdCogZXYpCnsKCXJldHVybiBfX2F0
b21pY19sb2FkX24oJmV2LT5zdGF0ZSwgX19BVE9NSUNfQUNRVUlSRSk7Cn0KCnN0YXRpYyBpbnQg
ZXZlbnRfdGltZWR3YWl0KGV2ZW50X3QqIGV2LCB1aW50NjRfdCB0aW1lb3V0KQp7Cgl1aW50NjRf
dCBzdGFydCA9IGN1cnJlbnRfdGltZV9tcygpOwoJdWludDY0X3Qgbm93ID0gc3RhcnQ7Cglmb3Ig
KDs7KSB7CgkJdWludDY0X3QgcmVtYWluID0gdGltZW91dCAtIChub3cgLSBzdGFydCk7CgkJc3Ry
dWN0IHRpbWVzcGVjIHRzOwoJCXRzLnR2X3NlYyA9IHJlbWFpbiAvIDEwMDA7CgkJdHMudHZfbnNl
YyA9IChyZW1haW4gJSAxMDAwKSAqIDEwMDAgKiAxMDAwOwoJCXN5c2NhbGwoU1lTX2Z1dGV4LCAm
ZXYtPnN0YXRlLCBGVVRFWF9XQUlUIHwgRlVURVhfUFJJVkFURV9GTEFHLCAwLCAmdHMpOwoJCWlm
IChfX2F0b21pY19sb2FkX24oJmV2LT5zdGF0ZSwgX19BVE9NSUNfQUNRVUlSRSkpCgkJCXJldHVy
biAxOwoJCW5vdyA9IGN1cnJlbnRfdGltZV9tcygpOwoJCWlmIChub3cgLSBzdGFydCA+IHRpbWVv
dXQpCgkJCXJldHVybiAwOwoJfQp9CgpzdHJ1Y3QgdGhyZWFkX3QgewoJaW50IGNyZWF0ZWQsIGNh
bGw7CglldmVudF90IHJlYWR5LCBkb25lOwp9OwoKc3RhdGljIHN0cnVjdCB0aHJlYWRfdCB0aHJl
YWRzWzE2XTsKc3RhdGljIHZvaWQgZXhlY3V0ZV9jYWxsKGludCBjYWxsKTsKc3RhdGljIGludCBy
dW5uaW5nOwoKc3RhdGljIHZvaWQqIHRocih2b2lkKiBhcmcpCnsKCXN0cnVjdCB0aHJlYWRfdCog
dGggPSAoc3RydWN0IHRocmVhZF90Kilhcmc7Cglmb3IgKDs7KSB7CgkJZXZlbnRfd2FpdCgmdGgt
PnJlYWR5KTsKCQlldmVudF9yZXNldCgmdGgtPnJlYWR5KTsKCQlleGVjdXRlX2NhbGwodGgtPmNh
bGwpOwoJCV9fYXRvbWljX2ZldGNoX3N1YigmcnVubmluZywgMSwgX19BVE9NSUNfUkVMQVhFRCk7
CgkJZXZlbnRfc2V0KCZ0aC0+ZG9uZSk7Cgl9CglyZXR1cm4gMDsKfQoKc3RhdGljIHZvaWQgbG9v
cCh2b2lkKQp7CglpbnQgaSwgY2FsbCwgdGhyZWFkOwoJaW50IGNvbGxpZGUgPSAwOwphZ2FpbjoK
CWZvciAoY2FsbCA9IDA7IGNhbGwgPCAyOyBjYWxsKyspIHsKCQlmb3IgKHRocmVhZCA9IDA7IHRo
cmVhZCA8IChpbnQpKHNpemVvZih0aHJlYWRzKSAvIHNpemVvZih0aHJlYWRzWzBdKSk7IHRocmVh
ZCsrKSB7CgkJCXN0cnVjdCB0aHJlYWRfdCogdGggPSAmdGhyZWFkc1t0aHJlYWRdOwoJCQlpZiAo
IXRoLT5jcmVhdGVkKSB7CgkJCQl0aC0+Y3JlYXRlZCA9IDE7CgkJCQlldmVudF9pbml0KCZ0aC0+
cmVhZHkpOwoJCQkJZXZlbnRfaW5pdCgmdGgtPmRvbmUpOwoJCQkJZXZlbnRfc2V0KCZ0aC0+ZG9u
ZSk7CgkJCQl0aHJlYWRfc3RhcnQodGhyLCB0aCk7CgkJCX0KCQkJaWYgKCFldmVudF9pc3NldCgm
dGgtPmRvbmUpKQoJCQkJY29udGludWU7CgkJCWV2ZW50X3Jlc2V0KCZ0aC0+ZG9uZSk7CgkJCXRo
LT5jYWxsID0gY2FsbDsKCQkJX19hdG9taWNfZmV0Y2hfYWRkKCZydW5uaW5nLCAxLCBfX0FUT01J
Q19SRUxBWEVEKTsKCQkJZXZlbnRfc2V0KCZ0aC0+cmVhZHkpOwoJCQlpZiAoY29sbGlkZSAmJiAo
Y2FsbCAlIDIpID09IDApCgkJCQlicmVhazsKCQkJZXZlbnRfdGltZWR3YWl0KCZ0aC0+ZG9uZSwg
NTApOwoJCQlicmVhazsKCQl9Cgl9Cglmb3IgKGkgPSAwOyBpIDwgMTAwICYmIF9fYXRvbWljX2xv
YWRfbigmcnVubmluZywgX19BVE9NSUNfUkVMQVhFRCk7IGkrKykKCQlzbGVlcF9tcygxKTsKCWlm
ICghY29sbGlkZSkgewoJCWNvbGxpZGUgPSAxOwoJCWdvdG8gYWdhaW47Cgl9Cn0KCnVpbnQ2NF90
IHJbMV0gPSB7MHhmZmZmZmZmZmZmZmZmZmZmfTsKCnZvaWQgZXhlY3V0ZV9jYWxsKGludCBjYWxs
KQp7CgkJaW50cHRyX3QgcmVzID0gMDsKCXN3aXRjaCAoY2FsbCkgewoJY2FzZSAwOgptZW1jcHko
KHZvaWQqKTB4MjAwMDAxMDAsICIuL2ZpbGUwXDAwMCIsIDgpOwoJCXJlcyA9IHN5c2NhbGwoX19O
Ul9jcmVhdCwgMHgyMDAwMDEwMHVsLCA4dWwpOwoJCWlmIChyZXMgIT0gLTEpCgkJCQlyWzBdID0g
cmVzOwoJCWJyZWFrOwoJY2FzZSAxOgptZW1jcHkoKHZvaWQqKTB4MjAwMDAyODAsICJzZWN1cml0
eS5jYXBhYmlsaXR5XDAwMCIsIDIwKTsKKih1aW50MzJfdCopMHgyMDAwMDJjMCA9IDB4MzAwMDAw
MDsKKih1aW50MzJfdCopMHgyMDAwMDJjNCA9IDB4MTc2MjsKKih1aW50MzJfdCopMHgyMDAwMDJj
OCA9IDg7CioodWludDMyX3QqKTB4MjAwMDAyY2MgPSAyOwoqKHVpbnQzMl90KikweDIwMDAwMmQw
ID0gLTE7CioodWludDMyX3QqKTB4MjAwMDAyZDQgPSAweGVlMDA7CgkJc3lzY2FsbChfX05SX2Zz
ZXR4YXR0ciwgclswXSwgMHgyMDAwMDI4MHVsLCAweDIwMDAwMmMwdWwsIDB4MTh1bCwgMHVsKTsK
CQlicmVhazsKCX0KCn0KaW50IG1haW4odm9pZCkKewoJCXN5c2NhbGwoX19OUl9tbWFwLCAweDFm
ZmZmMDAwdWwsIDB4MTAwMHVsLCAwdWwsIDB4MzJ1bCwgLTEsIDB1bCk7CglzeXNjYWxsKF9fTlJf
bW1hcCwgMHgyMDAwMDAwMHVsLCAweDEwMDAwMDB1bCwgN3VsLCAweDMydWwsIC0xLCAwdWwpOwoJ
c3lzY2FsbChfX05SX21tYXAsIDB4MjEwMDAwMDB1bCwgMHgxMDAwdWwsIDB1bCwgMHgzMnVsLCAt
MSwgMHVsKTsKCQkJbG9vcCgpOwoJcmV0dXJuIDA7Cn0K
------=_Part_64709075_138468903.1610619629990--

