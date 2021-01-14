Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A804EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 17:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7012E23B31
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 17:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbhANRbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 12:31:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbhANRbC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 12:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610645373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RhEkd7cpK0KNRiUqo9tpsFQukaBE2ZuDJoQcvGHc1qk=;
        b=SKv4qVSvPn4INXJ8zdMa4oMm6XL7IBAQ9O111qgUqCyoQhdUYU4KHzhxQsMEqbgonIkvSN
        3lSm+EHYWBAebzNUnfT1p1+CHr/9+XRwe9lNK3VWF1TpL8bxEmYwTr9SmkRSNrUs1DR8j5
        7XzOSw4mjiCsFA4YTC4vunEZLv/dB6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-UR4p2cKOOlmnp-MqYy8bTQ-1; Thu, 14 Jan 2021 12:29:31 -0500
X-MC-Unique: UR4p2cKOOlmnp-MqYy8bTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33EC7806662
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 17:29:30 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE1C4100AE42;
        Thu, 14 Jan 2021 17:29:29 +0000 (UTC)
Date:   Thu, 14 Jan 2021 12:29:28 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Yumei Huang <yuhuang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS: Assertion failed
Message-ID: <20210114172928.GA1351833@bfoster>
References: <1599642077.64707510.1610619249861.JavaMail.zimbra@redhat.com>
 <487974076.64709077.1610619629992.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487974076.64709077.1610619629992.JavaMail.zimbra@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 05:20:29AM -0500, Yumei Huang wrote:
> Hit the issue when doing syzkaller test with kernel 5.11.0-rc3(65f0d241). The C reproducer is attached.
> 
> Steps to Reproduce:
> 1. # gcc -pthread -o reproducer reproducer.c 
> 2. # ./reproducer 
> 
> 
> Test results:
> [  131.726790] XFS: Assertion failed: (iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 849
> [  131.743687] ------------[ cut here ]------------

Some quick initial analysis from a run of the reproducer... It looks
like it calls into xfs_setattr_size() with ATTR_KILL_PRIV set in
->ia_valid. This appears to originate in the VFS via handle_truncate()
-> do_truncate() -> dentry_needs_remove_privs().

An strace of the reproducer shows the following calls:

...
[pid  1524] creat("./file0", 010)       = 3
...
[pid  1524] fsetxattr(3, "security.capability", "\0\0\0\3b\27\0\0\10\0\0\0\2\0\0\0\377\377\377\377\0\356\0", 24, 0 <unfinished ...>
...
[pid  1524] creat("./file0", 010 <unfinished ...>
...

So I'm guessing there's an attempt to open this file with O_TRUNC with
this particular xattr set (unexpectedly?). Indeed, after the reproducer
leaves file01 around with the xattr, a subsequent xfs_io -c "open -t
..." attempt triggers the assert again, and then the xattr disappears.
I'd have to dig more into the associated vfs code to grok the expected
behavior and whether there's a problem here..

Brian

> [  131.748350] WARNING: CPU: 18 PID: 1786 at fs/xfs/xfs_message.c:97 asswarn+0x1a/0x1d [xfs]
> [  131.756764] Modules linked in: intel_rapl_msr intel_rapl_common edac_mce_amd kvm_amd rfkill kvm irqbypass mgag200 crct10dif_pclmul i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32_pclmul ccp sp5100_tco drm ipmi_ssif ses ghash_clmulni_intel pcspkr hpilo acpi_ipmi enclosure hpwdt i2c_piix4 k10temp rapl ipmi_si ipmi_devintf ipmi_msghandler acpi_tad acpi_cpufreq ip_tables xfs libcrc32c sd_mod t10_pi sg uas crc32c_intel serio_raw usb_storage smartpqi scsi_transport_sas tg3 wmi dm_mirror dm_region_hash dm_log dm_mod
> [  131.805054] CPU: 18 PID: 1786 Comm: reproducer Tainted: G    B             5.11.0-rc3upstream65f0d241+ #2
> [  131.814702] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 10/14/2017
> [  131.823299] RIP: 0010:asswarn+0x1a/0x1d [xfs]
> [  131.827868] Code: c4 d0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 40 d6 ad c0 e8 08 fa ff ff <0f> 0b c3 0f 1f 44 00 00 53 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 40
> [  131.846777] RSP: 0018:ffff88812128f828 EFLAGS: 00010282
> [  131.852059] RAX: 0000000000000000 RBX: 1ffff11024251f0b RCX: 0000000000000000
> [  131.859256] RDX: dffffc0000000000 RSI: 000000000000000a RDI: ffffed1024251ef7
> [  131.866458] RBP: ffff88812128f920 R08: ffffed110dcfe24d R09: ffffed110dcfe24d
> [  131.873663] R10: ffff88886e7f1267 R11: ffffed110dcfe24c R12: ffff88812128fa68
> [  131.880862] R13: ffff88819bf08280 R14: ffff88819bf08280 R15: ffff88819bf08000
> [  131.888062] FS:  00007f18cb349700(0000) GS:ffff88886e600000(0000) knlGS:0000000000000000
> [  131.896222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  131.902026] CR2: 0000000020000100 CR3: 0000000112820000 CR4: 00000000003506e0
> [  131.909223] Call Trace:
> [  131.911703]  xfs_setattr_size+0x742/0xd00 [xfs]
> [  131.916427]  ? __vfs_removexattr+0xd1/0x130
> [  131.920673]  ? xfs_setattr_nonsize+0xef0/0xef0 [xfs]
> [  131.925836]  ? cap_inode_killpriv+0x11/0x20
> [  131.930071]  ? security_inode_killpriv+0x3f/0x70
> [  131.934740]  xfs_vn_setattr+0xea/0x3a0 [xfs]
> [  131.939211]  ? xfs_vn_setattr_size+0x2a0/0x2a0 [xfs]
> [  131.944375]  notify_change+0x744/0xda0
> [  131.948173]  ? do_truncate+0xe2/0x180
> [  131.951880]  do_truncate+0xe2/0x180
> [  131.955412]  ? __x64_sys_openat2+0x1c0/0x1c0
> [  131.959731]  ? ima_file_check+0xd9/0x120
> [  131.963701]  ? security_inode_permission+0x79/0xc0
> [  131.968545]  path_openat+0x11df/0x21f0
> [  131.972340]  ? path_lookupat.isra.48+0x440/0x440
> [  131.977012]  ? quarantine_put+0xe2/0x170
> [  131.980979]  ? trace_hardirqs_on+0x1c/0x150
> [  131.985211]  do_filp_open+0x176/0x250
> [  131.988915]  ? lock_release+0x56e/0xcc0
> [  131.992797]  ? may_open_dev+0xc0/0xc0
> [  131.996503]  ? do_raw_spin_unlock+0x54/0x230
> [  132.000827]  do_sys_openat2+0x2ee/0x5c0
> [  132.004710]  ? rcu_read_unlock+0x50/0x50
> [  132.008676]  ? file_open_root+0x210/0x210
> [  132.012732]  ? ktime_get_coarse_real_ts64+0x122/0x150
> [  132.017840]  do_sys_open+0x8a/0xd0
> [  132.021284]  ? filp_open+0x50/0x50
> [  132.024730]  ? syscall_trace_enter.isra.16+0x18e/0x250
> [  132.029923]  do_syscall_64+0x33/0x40
> [  132.033543]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  132.038647] RIP: 0033:0x7f18cac3c51d
> [  132.042266] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3b 79 2c 00 f7 d8 64 89 01 48
> [  132.061173] RSP: 002b:00007f18cb348e98 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
> [  132.068817] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f18cac3c51d
> [  132.076013] RDX: 0030656c69662f2e RSI: 0000000000000008 RDI: 0000000020000100
> [  132.083209] RBP: 00007f18cb348ec0 R08: 0000000000000000 R09: 0000000000000000
> [  132.090407] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff50ae2e4e
> [  132.097607] R13: 00007fff50ae2e4f R14: 00007fff50ae2ee0 R15: 00007f18cb348fc0
> [  132.104812] irq event stamp: 0
> [  132.107902] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [  132.114228] hardirqs last disabled at (0): [<ffffffff9c1ce85b>] copy_process+0x1a7b/0x6590
> [  132.122570] softirqs last  enabled at (0): [<ffffffff9c1ce89f>] copy_process+0x1abf/0x6590
> [  132.130905] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [  132.137235] ---[ end trace d05db93236ee9da5 ]---
> 
> 
> Syzkaller reproducer:
> # {Threaded:true Collide:true Repeat:false RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: Fault:false FaultCall:-1 FaultNth:0 Leak:false NetInjection:false NetDevices:false NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false VhciInjection:false Wifi:false Sysctl:false UseTmpDir:false HandleSegv:false Repro:false Trace:false}
> r0 = creat(&(0x7f0000000100)='./file0\x00', 0x8)
> fsetxattr$security_capability(r0, &(0x7f0000000280)='security.capability\x00', &(0x7f00000002c0)=@v3={0x3000000, [{0x1762, 0x8}, {0x2, 0xffffffff}], 0xee00}, 0x18, 0x0)
> 
> 
> 
> Best Regards,
> 
> Yumei Huang
> 

> // autogenerated by syzkaller (https://github.com/google/syzkaller)
> 
> #define _GNU_SOURCE 
> 
> #include <endian.h>
> #include <errno.h>
> #include <pthread.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <time.h>
> #include <unistd.h>
> 
> #include <linux/futex.h>
> 
> static void sleep_ms(uint64_t ms)
> {
> 	usleep(ms * 1000);
> }
> 
> static uint64_t current_time_ms(void)
> {
> 	struct timespec ts;
> 	if (clock_gettime(CLOCK_MONOTONIC, &ts))
> 	exit(1);
> 	return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
> }
> 
> static void thread_start(void* (*fn)(void*), void* arg)
> {
> 	pthread_t th;
> 	pthread_attr_t attr;
> 	pthread_attr_init(&attr);
> 	pthread_attr_setstacksize(&attr, 128 << 10);
> 	int i = 0;
> 	for (; i < 100; i++) {
> 		if (pthread_create(&th, &attr, fn, arg) == 0) {
> 			pthread_attr_destroy(&attr);
> 			return;
> 		}
> 		if (errno == EAGAIN) {
> 			usleep(50);
> 			continue;
> 		}
> 		break;
> 	}
> 	exit(1);
> }
> 
> typedef struct {
> 	int state;
> } event_t;
> 
> static void event_init(event_t* ev)
> {
> 	ev->state = 0;
> }
> 
> static void event_reset(event_t* ev)
> {
> 	ev->state = 0;
> }
> 
> static void event_set(event_t* ev)
> {
> 	if (ev->state)
> 	exit(1);
> 	__atomic_store_n(&ev->state, 1, __ATOMIC_RELEASE);
> 	syscall(SYS_futex, &ev->state, FUTEX_WAKE | FUTEX_PRIVATE_FLAG, 1000000);
> }
> 
> static void event_wait(event_t* ev)
> {
> 	while (!__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
> 		syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, 0);
> }
> 
> static int event_isset(event_t* ev)
> {
> 	return __atomic_load_n(&ev->state, __ATOMIC_ACQUIRE);
> }
> 
> static int event_timedwait(event_t* ev, uint64_t timeout)
> {
> 	uint64_t start = current_time_ms();
> 	uint64_t now = start;
> 	for (;;) {
> 		uint64_t remain = timeout - (now - start);
> 		struct timespec ts;
> 		ts.tv_sec = remain / 1000;
> 		ts.tv_nsec = (remain % 1000) * 1000 * 1000;
> 		syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, &ts);
> 		if (__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
> 			return 1;
> 		now = current_time_ms();
> 		if (now - start > timeout)
> 			return 0;
> 	}
> }
> 
> struct thread_t {
> 	int created, call;
> 	event_t ready, done;
> };
> 
> static struct thread_t threads[16];
> static void execute_call(int call);
> static int running;
> 
> static void* thr(void* arg)
> {
> 	struct thread_t* th = (struct thread_t*)arg;
> 	for (;;) {
> 		event_wait(&th->ready);
> 		event_reset(&th->ready);
> 		execute_call(th->call);
> 		__atomic_fetch_sub(&running, 1, __ATOMIC_RELAXED);
> 		event_set(&th->done);
> 	}
> 	return 0;
> }
> 
> static void loop(void)
> {
> 	int i, call, thread;
> 	int collide = 0;
> again:
> 	for (call = 0; call < 2; call++) {
> 		for (thread = 0; thread < (int)(sizeof(threads) / sizeof(threads[0])); thread++) {
> 			struct thread_t* th = &threads[thread];
> 			if (!th->created) {
> 				th->created = 1;
> 				event_init(&th->ready);
> 				event_init(&th->done);
> 				event_set(&th->done);
> 				thread_start(thr, th);
> 			}
> 			if (!event_isset(&th->done))
> 				continue;
> 			event_reset(&th->done);
> 			th->call = call;
> 			__atomic_fetch_add(&running, 1, __ATOMIC_RELAXED);
> 			event_set(&th->ready);
> 			if (collide && (call % 2) == 0)
> 				break;
> 			event_timedwait(&th->done, 50);
> 			break;
> 		}
> 	}
> 	for (i = 0; i < 100 && __atomic_load_n(&running, __ATOMIC_RELAXED); i++)
> 		sleep_ms(1);
> 	if (!collide) {
> 		collide = 1;
> 		goto again;
> 	}
> }
> 
> uint64_t r[1] = {0xffffffffffffffff};
> 
> void execute_call(int call)
> {
> 		intptr_t res = 0;
> 	switch (call) {
> 	case 0:
> memcpy((void*)0x20000100, "./file0\000", 8);
> 		res = syscall(__NR_creat, 0x20000100ul, 8ul);
> 		if (res != -1)
> 				r[0] = res;
> 		break;
> 	case 1:
> memcpy((void*)0x20000280, "security.capability\000", 20);
> *(uint32_t*)0x200002c0 = 0x3000000;
> *(uint32_t*)0x200002c4 = 0x1762;
> *(uint32_t*)0x200002c8 = 8;
> *(uint32_t*)0x200002cc = 2;
> *(uint32_t*)0x200002d0 = -1;
> *(uint32_t*)0x200002d4 = 0xee00;
> 		syscall(__NR_fsetxattr, r[0], 0x20000280ul, 0x200002c0ul, 0x18ul, 0ul);
> 		break;
> 	}
> 
> }
> int main(void)
> {
> 		syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> 	syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
> 	syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> 			loop();
> 	return 0;
> }

