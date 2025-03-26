Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5F61E51E4;
	Wed, 26 Mar 2025 16:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004936; cv=none; b=uCHn9JiACa4mmY0v7nw2yPHGW14dRxcya31JpC6y+10qbC8l0WUKjWBQbvOUDRc5CwybQcW9sin/Jngp52MN5Oe8LMNVFwvcP7GCwiPhs83h1sCQVjO0FNYXDSBkcmMFP2M7PkCUiwyXgCbdZzIM5nEzsHwjqU1vj0+Rj3UKnxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004936; c=relaxed/simple;
	bh=gBmhT5DUNuC3CnkYLiO3czxrLbFEkOgoHUlGHxSvn80=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=IyVaXZtW0ldmB+X/C7CHTDEF+A5bk65eCLmOrsbCE7Xy8aqZwntlqb3V0yJ6lLa+7qxOv2amu+h+qUoFQAoaov11qUG8T8ShWm77zJ3/LQgsnGoehtV7xmSv7jEaFRtB1G3i765T2auQxb+HfBfCelw93Xx2YWTosokkPTibMZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pRukugsv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pRukugsv"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QF2xRX003134;
	Wed, 26 Mar 2025 16:02:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=M/KHprYdoTcVfg1L9ylV3hM7NWI3
	+qPpGpAX8uKfing=; b=pRukugsvHzEqpfTvN4mMJhPqdbcAV3mwNxrVfjHMJT4U
	I6yoBiggxgNq/TzO9Q1i9cQJ7BCKtY3cl4IPHa/wyLsB/qKdooJKCkj7JmDgOxPh
	cTyY1LFx9l/TG+ctsuBIeRXnfCVcunyY0Qpk4fPUCThT8Ro/06RH+VeZJ1GPYxnu
	ITVXB54sDe07hmB+QIJp5qZoHeFXY0ztOIa3Wf6AmHF24KKLAxTBAxZyL82ZVZ/N
	n9Pz2Gy3N5JCgepLRy2l5BfUwny5T4tIVSKnn4E1hP9n+ETHYuZqTcOb6+H3ZAOz
	DvMr8ZNT3Zg/c9Himv/kt5NBxdIgpgV/o834UM8zzQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45m9ya3h81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Mar 2025 16:02:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52QDkpaX025463;
	Wed, 26 Mar 2025 16:02:11 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45j7x097fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Mar 2025 16:02:11 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52QG2AkO29623028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 16:02:10 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FE865805D;
	Wed, 26 Mar 2025 16:02:10 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56E1358055;
	Wed, 26 Mar 2025 16:02:09 +0000 (GMT)
Received: from [9.61.254.184] (unknown [9.61.254.184])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Mar 2025 16:02:09 +0000 (GMT)
Message-ID: <6564c3d6-9372-4352-9847-1eb3aea07ca4@linux.ibm.com>
Date: Wed, 26 Mar 2025 21:32:07 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: LKML <linux-kernel@vger.kernel.org>, riteshh@linux.ibm.com,
        linux-xfs@vger.kernel.org
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [linux-next-20250324]Kernel OOPs while running xfs/206 Test
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Rs898YCiHH9HC0kxeGOnWLJvyeWOppCJ
X-Proofpoint-ORIG-GUID: Rs898YCiHH9HC0kxeGOnWLJvyeWOppCJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_07,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=942 mlxscore=0 clxscore=1011 lowpriorityscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503260097

Greetings!!!

I observed kernel oops, while running xfs/206 test case on 
6.14.0-rc7-next-20250324 only once. I am not able to reporduce this. But 
posting it here anyway, if anyone gets any clue.

Please ignore, if it dosent help.


---- Steps to Reproduce ----
1. git clone git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
2. cd xfstests-dev/
3. mkdir /mnt/loop-device /mnt/test /mnt/scratch
4. for i in $(seq 0 1); do fallocate -o 0 -l 9GiB 
/mnt/loop-device/file-$i.img; done
5. for i in $(seq 0 1); do losetup /dev/loop$i 
/mnt/loop-device/file-$i.img; done
6. mkfs.xfs -f /dev/loop0; mkfs.xfs -f /dev/loop1
7. vim local.config
8. make
9. ./check xfs/206

local.config >>>
[xfs_4k]
export RECREATE_TEST_DEV=true
export TEST_DEV=/dev/loop0
export TEST_DIR=/mnt/test
export SCRATCH_DEV=/dev/loop1
export SCRATCH_MNT=/mnt/scratch
export MKFS_OPTIONS="-b size=4096"
export FSTYP=xfs
export MOUNT_OPTIONS=""-


Traces:

[ 2272.236489] ------------[ cut here ]------------
[ 2272.236502] WARNING: CPU: 3 PID: 1 at kernel/cgroup/rstat.c:231 
cgroup_rstat_updated_list+0x228/0x330
[ 2272.236512] Modules linked in: overlay dm_zero dm_thin_pool 
dm_persistent_data dm_bio_prison dm_snapshot dm_bufio dm_flakey xfs loop 
dm_mod nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet 
nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct bonding nft_chain_nat 
nf_nat tls nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill sunrpc 
ip_set nf_tables nfnetlink pseries_rng vmx_crypto fuse ext4 mbcache jbd2 
sd_mod sg ibmvscsi ibmveth scsi_transport_srp [last unloaded: scsi_debug]
[ 2272.236556] CPU: 3 UID: 0 PID: 1 Comm: systemd Kdump: loaded Not 
tainted 6.14.0-rc7-next-20250324 #1 VOLUNTARY
[ 2272.236564] Hardware name: IBM,9080-HEX
[ 2272.236572] NIP:  c0000000002d3af0 LR: c0000000002d3948 CTR: 
c0000000005f3728
[ 2272.236578] REGS: c000000004b276f0 TRAP: 0700   Not tainted 
(6.14.0-rc7-next-20250324)
[ 2272.236584] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 
28228442  XER: 2004006c
[ 2272.236599] CFAR: c0000000002d399c IRQMASK: 1
[ 2272.236599] GPR00: c0000000002d3948 c000000004b27990 c0000000016b8100 
0000000000000001
[ 2272.236599] GPR04: 0000000000000003 0000000000000003 0000000000000000 
0000000ef9220000
[ 2272.236599] GPR08: c000000091b66000 c009fffff4ca0140 c000000091b66000 
0000000000008000
[ 2272.236599] GPR12: c0000000005f3728 c000000effffb300 0000000000000000 
0000000000000000
[ 2272.236599] GPR16: 0000000000000000 0000000000000000 0000000000000000 
c0000000ac5043e0
[ 2272.236599] GPR20: 0000000000000001 0000000000000000 c0000000015d11d8 
c0000000ac504000
[ 2272.236599] GPR24: c009fffff4ca9000 c0000000ac504000 0000000000000000 
c000000efb49c4bc
[ 2272.236599] GPR28: c000000002d0a668 0000000000000018 0000000000000003 
c000000091b66000
[ 2272.236645] NIP [c0000000002d3af0] cgroup_rstat_updated_list+0x228/0x330
[ 2272.236650] LR [c0000000002d3948] cgroup_rstat_updated_list+0x80/0x330
[ 2272.236656] Call Trace:
[ 2272.236658] [c000000004b27990] [c0000000015d11d8] 
__cpu_possible_mask+0x0/0x400 (unreliable)
[ 2272.236665] [c000000004b279f0] [c0000000002d3f50] 
cgroup_rstat_flush+0xc8/0x5d0
[ 2272.236672] [c000000004b27a90] [c0000000002d47d0] 
cgroup_base_stat_cputime_show+0x5c/0x2fc
[ 2272.236678] [c000000004b27b40] [c0000000002c7fb0] 
cpu_stat_show+0x2c/0x1a4
[ 2272.236683] [c000000004b27b80] [c0000000002c60e0] 
cgroup_seqfile_show+0x74/0x158
[ 2272.236688] [c000000004b27bf0] [c000000000735974] 
kernfs_seq_show+0x44/0x58
[ 2272.236693] [c000000004b27c10] [c000000000676440] 
seq_read_iter+0x264/0x6a8
[ 2272.236700] [c000000004b27cf0] [c0000000007364c0] 
kernfs_fop_read_iter+0x4c/0x60
[ 2272.236704] [c000000004b27d10] [c000000000628a9c] vfs_read+0x2cc/0x3a0
[ 2272.236710] [c000000004b27dc0] [c000000000629904] ksys_read+0x84/0x144
[ 2272.236715] [c000000004b27e10] [c000000000033498] 
system_call_exception+0x138/0x330
[ 2272.236721] [c000000004b27e50] [c00000000000d05c] 
system_call_vectored_common+0x15c/0x2ec
[ 2272.236728] --- interrupt: 3000 at 0x7fffa5f33d94
[ 2272.236732] NIP:  00007fffa5f33d94 LR: 00007fffa5f33d94 CTR: 
0000000000000000
[ 2272.236736] REGS: c000000004b27e80 TRAP: 3000   Not tainted 
(6.14.0-rc7-next-20250324)
[ 2272.236740] MSR:  800000000280f033 
<SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 48222442  XER: 00000000
[ 2272.236751] IRQMASK: 0
[ 2272.236751] GPR00: 0000000000000003 00007fffebb75a30 00007fffa6667400 
0000000000000029
[ 2272.236751] GPR04: 000000014998e9e0 0000000000002000 0000000000000001 
00007fffa6bb53a0
[ 2272.236751] GPR08: 00007fffa6badc68 0000000000000000 0000000000000000 
0000000000000000
[ 2272.236751] GPR12: 0000000000000000 00007fffa6bb53a0 0000000000000000 
0000000000000807
[ 2272.236751] GPR16: 0000000000000000 0000000000000000 0000000003ffffff 
0000000004000000
[ 2272.236751] GPR20: 0000000003fffffe 0000000000000000 0000000000000000 
00007fffebb75e18
[ 2272.236751] GPR24: 0000000000000000 00007fffa602ce18 00007fffa602d9e8 
00007fffa602ce18
[ 2272.236751] GPR28: 00007fffa602d748 000000014998e9e0 0000000000000000 
0000000000002000
[ 2272.236793] NIP [00007fffa5f33d94] 0x7fffa5f33d94
[ 2272.236796] LR [00007fffa5f33d94] 0x7fffa5f33d94
[ 2272.236799] --- interrupt: 3000
[ 2272.236801] Code: eb01ffc0 eb21ffc8 eb41ffd0 eb61ffd8 eb81ffe0 
eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 4e800020 60000000 60000000 
<0fe00000> 4bfffeac 60000000 60000000
[ 2272.236815] ---[ end trace 0000000000000000 ]---
[ 2272.236819] Kernel attempted to read user page (3d8) - exploit 
attempt? (uid: 0)
[ 2272.236824] BUG: Kernel NULL pointer dereference on read at 0x000003d8
[ 2272.236828] Faulting instruction address: 0xc0000000002d3994
[ 2272.236832] Oops: Kernel access of bad area, sig: 11 [#1]
[ 2272.236835] LE PAGE_SIZE=64K MMU=Radix  SMP NR_CPUS=8192 NUMA pSeries
[ 2272.236839] Modules linked in: overlay dm_zero dm_thin_pool 
dm_persistent_data dm_bio_prison dm_snapshot dm_bufio dm_flakey xfs loop 
dm_mod nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet 
nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct bonding nft_chain_nat 
nf_nat tls nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill sunrpc 
ip_set nf_tables nfnetlink pseries_rng vmx_crypto fuse ext4 mbcache jbd2 
sd_mod sg ibmvscsi ibmveth scsi_transport_srp [last unloaded: scsi_debug]
[ 2272.236875] CPU: 3 UID: 0 PID: 1 Comm: systemd Kdump: loaded Tainted: 
G        W           6.14.0-rc7-next-20250324 #1 VOLUNTARY
[ 2272.236881] Tainted: [W]=WARN
[ 2272.236883] Hardware name: IBM,9080-HEX
[ 2272.236888] NIP:  c0000000002d3994 LR: c0000000002d3948 CTR: 
c0000000005f3728
[ 2272.236892] REGS: c000000004b276f0 TRAP: 0300   Tainted: G        
W            (6.14.0-rc7-next-20250324)
[ 2272.236897] MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 
48228442  XER: 2004006c
[ 2272.236905] CFAR: c0000000002d39a8 DAR: 00000000000003d8 DSISR: 
40000000 IRQMASK: 1
[ 2272.236905] GPR00: c0000000002d3948 c000000004b27990 c0000000016b8100 
0000000000000001
[ 2272.236905] GPR04: 0000000000000003 0000000000000003 0000000000000000 
0000000ef9220000
[ 2272.236905] GPR08: c000000091b66000 c009fffff4ca0140 0000000000000000 
0000000000008000
[ 2272.236905] GPR12: c0000000005f3728 c000000effffb300 0000000000000000 
0000000000000000
[ 2272.236905] GPR16: 0000000000000000 0000000000000000 0000000000000000 
c0000000ac5043e0
[ 2272.236905] GPR20: 0000000000000001 0000000000000000 c0000000015d11d8 
c0000000ac504000
[ 2272.236905] GPR24: c009fffff4ca9000 c0000000ac504000 0000000000000000 
c000000efb49c4bc
[ 2272.236905] GPR28: c000000002d0a668 0000000000000018 0000000000000003 
c000000091b66000
[ 2272.236975] NIP [c0000000002d3994] cgroup_rstat_updated_list+0xcc/0x330
[ 2272.236981] LR [c0000000002d3948] cgroup_rstat_updated_list+0x80/0x330
[ 2272.236986] Call Trace:
[ 2272.236988] [c000000004b27990] [c0000000015d11d8] 
__cpu_possible_mask+0x0/0x400 (unreliable)
[ 2272.236995] [c000000004b279f0] [c0000000002d3f50] 
cgroup_rstat_flush+0xc8/0x5d0
[ 2272.237001] [c000000004b27a90] [c0000000002d47d0] 
cgroup_base_stat_cputime_show+0x5c/0x2fc
[ 2272.237008] [c000000004b27b40] [c0000000002c7fb0] 
cpu_stat_show+0x2c/0x1a4
[ 2272.237013] [c000000004b27b80] [c0000000002c60e0] 
cgroup_seqfile_show+0x74/0x158
[ 2272.237018] [c000000004b27bf0] [c000000000735974] 
kernfs_seq_show+0x44/0x58
[ 2272.237022] [c000000004b27c10] [c000000000676440] 
seq_read_iter+0x264/0x6a8
[ 2272.237028] [c000000004b27cf0] [c0000000007364c0] 
kernfs_fop_read_iter+0x4c/0x60
[ 2272.237033] [c000000004b27d10] [c000000000628a9c] vfs_read+0x2cc/0x3a0
[ 2272.237037] [c000000004b27dc0] [c000000000629904] ksys_read+0x84/0x144
[ 2272.237042] [c000000004b27e10] [c000000000033498] 
system_call_exception+0x138/0x330
[ 2272.237048] [c000000004b27e50] [c00000000000d05c] 
system_call_vectored_common+0x15c/0x2ec
[ 2272.237054] --- interrupt: 3000 at 0x7fffa5f33d94
[ 2272.237057] NIP:  00007fffa5f33d94 LR: 00007fffa5f33d94 CTR: 
0000000000000000
[ 2272.237061] REGS: c000000004b27e80 TRAP: 3000   Tainted: G        
W            (6.14.0-rc7-next-20250324)
[ 2272.237066] MSR:  800000000280f033 
<SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 48222442  XER: 00000000
[ 2272.237076] IRQMASK: 0
[ 2272.237076] GPR00: 0000000000000003 00007fffebb75a30 00007fffa6667400 
0000000000000029
[ 2272.237076] GPR04: 000000014998e9e0 0000000000002000 0000000000000001 
00007fffa6bb53a0
[ 2272.237076] GPR08: 00007fffa6badc68 0000000000000000 0000000000000000 
0000000000000000
[ 2272.237076] GPR12: 0000000000000000 00007fffa6bb53a0 0000000000000000 
0000000000000807
[ 2272.237076] GPR16: 0000000000000000 0000000000000000 0000000003ffffff 
0000000004000000
[ 2272.237076] GPR20: 0000000003fffffe 0000000000000000 0000000000000000 
00007fffebb75e18
[ 2272.237076] GPR24: 0000000000000000 00007fffa602ce18 00007fffa602d9e8 
00007fffa602ce18
[ 2272.237076] GPR28: 00007fffa602d748 000000014998e9e0 0000000000000000 
0000000000002000
[ 2272.237118] NIP [00007fffa5f33d94] 0x7fffa5f33d94
[ 2272.237121] LR [00007fffa5f33d94] 0x7fffa5f33d94
[ 2272.237124] --- interrupt: 3000
[ 2272.237127] Code: 4182013c e91900c0 2c280000 41820044 7cfce82a 
e92803d8 7d293a14 e94900a0 7c395040 41820268 60000000 7c285040 
<e92a03d8> 7d274a14 41820154 e94900a8
[ 2272.237140] ---[ end trace 0000000000000000 ]--


If you happen to fix this, please add below tag.


Reproted-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>


Regards,

Venkat.

