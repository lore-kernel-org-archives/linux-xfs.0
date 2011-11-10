Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAALaxdG132749 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 15:36:59 -0600
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 244F7236AD1
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 13:36:58 -0800 (PST)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id bu8EAqiuf3rRb4cP for
	<xfs@oss.sgi.com>; Thu, 10 Nov 2011 13:36:58 -0800 (PST)
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 10 Nov 2011 16:36:55 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pAALaidE292302 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 16:36:45 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pAALaiL9032480
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:36:44 -0700
Received: from [9.53.40.164] (chandra-lucid.austin.ibm.com [9.53.40.164])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	pAALahjx032432 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:36:44 -0700
Subject: Occasional memory fault in inode_has_perm() while running xfstest 234
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 10 Nov 2011 15:36:43 -0600
Message-ID: <1320961003.2201.27.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Mailing List <xfs@oss.sgi.com>

Hi All,

While debugging the xfstest case 234, I was occasionally hitting the
following memory fault. Has anybody seen it ?

-----------------
IP: [<ffffffff811e57ff>] inode_has_perm+0x1f/0x40
PGD 0 
Oops: 0000 [#1] SMP 
CPU 0 
Modules linked in: xfs exportfs ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat iptable_mangle bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun kvm_intel kvm cdc_ether usbnet mii microcode serio_raw i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma i7core_edac edac_core ses enclosure sg igb dca ext4 mbcache jbd2 sd_mod crc_t10dif ahci libahci megaraid_sas [last unloaded: scsi_wait_scan]

Pid: 32611, comm: setquota Not tainted 3.1.0-rc9.virgin+ #6 IBM  System x3630 M3 -[7377AC1]-/69Y1101     
RIP: 0010:[<ffffffff811e57ff>]  [<ffffffff811e57ff>] inode_has_perm+0x1f/0x40
RSP: 0018:ffff880642bcdb78  EFLAGS: 00010246
RAX: 0000000000800002 RBX: ffff88064f2205f8 RCX: 0000000000800000
RDX: 0000000000800000 RSI: 0000000000000000 RDI: ffff880649e58480
RBP: ffff880642bcdb78 R08: ffff880642bcdb88 R09: 0000000000000080
R10: ffff880658ffff00 R11: ffff880642bcdb88 R12: 0000000000000081
R13: ffff88064f2205f8 R14: ffff8806592b8100 R15: 0000000000000000
FS:  00007f56dfa3a700(0000) GS:ffff88067f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 0000000642b30000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process setquota (pid: 32611, threadinfo ffff880642bcc000, task ffff8806592b8100)
Stack:
ffff880642bcdc18 ffffffff811e5d79 0000000000000009 0000000000000000
ffff88064f2205f8 0000000000000000 0000000000000000 0000000000000000
0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
[<ffffffff811e5d79>] selinux_inode_permission+0xa9/0x100
[<ffffffff811e323c>] security_inode_permission+0x1c/0x30
[<ffffffff81162509>] inode_permission+0x49/0x100
[<ffffffff81164b57>] link_path_walk+0x87/0x810
[<ffffffff810fedfa>] ? unlock_page+0x2a/0x40
[<ffffffff81165955>] path_lookupat+0x55/0x690
[<ffffffff81125867>] ? handle_pte_fault+0xf7/0xb50
[<ffffffff81165fc1>] do_path_lookup+0x31/0xc0
[<ffffffff81162168>] ? getname_flags+0x1f8/0x280
[<ffffffff81166df9>] user_path_at+0x59/0xa0
[<ffffffff8112641b>] ? handle_mm_fault+0x15b/0x270
[<ffffffff814af8c0>] ? do_page_fault+0x1e0/0x460
[<ffffffff81146a62>] ? kmem_cache_alloc+0x152/0x190
[<ffffffff8115b9c7>] vfs_fstatat+0x47/0x80
[<ffffffff81077571>] ? do_sigaction+0x91/0x1d0
[<ffffffff8115badb>] vfs_stat+0x1b/0x20
[<ffffffff8115bb04>] sys_newstat+0x24/0x50
[<ffffffff810c3c4f>] ? audit_syscall_entry+0x1bf/0x1f0
[<ffffffff814b29c2>] system_call_fastpath+0x16/0x1b
Code: 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 f6 46 0d 02 75 23 48 8b 76 38 48 8b 7f 68 45 89 c1 49 89 c8 89 d1 <0f> b7 46 20 8b 7f 04 8b 76 1c 89 c2 e8 a0 f9 ff ff c9 c3 31 c0 
RIP  [<ffffffff811e57ff>] inode_has_perm+0x1f/0x40
RSP <ffff880642bcdb78>
CR2: 0000000000000020
---[ end trace 5d054c892d311b3f ]---
----------------------------

I made some code changes and found that inode->i_security is the data
structure that is NULL.

I added the following code
------------------
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 266a229..43870ec 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1466,6 +1466,7 @@ static int task_has_system(struct task_struct *tsk,
 			    SECCLASS_SYSTEM, perms, NULL);
 }
 
+u64 isec_yes;
 /* Check whether a task has a particular permission to an inode.
    The 'adp' parameter is optional and allows other audit
    data to be passed (e.g. the dentry). */
@@ -1486,6 +1487,13 @@ static int inode_has_perm(const struct cred *cred,
 	sid = cred_sid(cred);
 	isec = inode->i_security;
 
+	if (isec)
+		isec_yes++;
+	else {
+		printk("isec NULL; isec_yes %llu\n", isec_yes);
+		return -EACCES;
+	}
+		
 	return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
 }
 
--------------------------------

and this is what I see in /var/log/messages
-----------------------------
isec NULL; isec_yes 14345860
isec NULL; isec_yes 102846678
isec NULL; isec_yes 107203361
isec NULL; isec_yes 136859591
isec NULL; isec_yes 140941549
isec NULL; isec_yes 168163633
isec NULL; isec_yes 222030886
isec NULL; isec_yes 238835570
isec NULL; isec_yes 263587444
isec NULL; isec_yes 280912141
------------------------------

Can somebody throw some light on it ?

I am using xfs.sgi.com with commit 9e4c109ac822395e0aae650e4e3c9e4903f6602f
at the top.

Regards,

Chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
