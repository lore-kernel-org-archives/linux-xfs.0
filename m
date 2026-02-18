Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3DA2ECEA3
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 21:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771451029; cv=none; b=CotLwYYvNCGoHMudMp0X8hfU/GeealmOuh+HAhNc1s6Ba9NzGYK2t/aQvMjYDL0hhgif68u11lTVnfGKXn2Qao/CHq/BFAaw2DN8s6fOMUpYFPyefZzFubC1lL4fLqbVVjbrAAZfN+CCdVxIl8twzunw3Abplcww1iMmx3Gybtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771451029; c=relaxed/simple;
	bh=L6/4HtShq/8MLw9GI3d12noTbzsj3cYwnJzyCbeU3nM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzmlOVpkhh/TtR0cnnsNMZQ3jdDiU0Neyv2KBHAry78wWvIKwQ1xdzywkrVnmpcUdQJg3cuqxLuLltUE8u8Cr4p4h/ETvxg7sjClTjHL74AUsiX/OcJAf+VuNKiK3bOEo1e1Yw/QM0TGvzcY8LB7B/Zhhq5znPJRVmZRj2KdkKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XrKR+93/; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XrKR+93/"
Date: Wed, 18 Feb 2026 13:43:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771451025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=msYWdO9LQsN9N/UWsBLAOEgtr0yGaAudQHpwfclAfDc=;
	b=XrKR+93/0pZkVvVb8I+PTBPs/FTrch9USxx7AVfGgU0WF5fXXLWeg8Cw3GdNJ3Y8sHdZmm
	PhDlbFjEAvl456iVhlM9ecvNtAnOUR+McwzdqqmRk/GX8AEKraoX8YxKCMoxBbTkUmDWvq
	z1U5gnlQpcOif9XK6xMXrNXSTyPeGZw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Ritesh Harjani <riteshh@linux.ibm.com>, ojaswin@linux.ibm.com, 
	Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [linux-next20260216]Warnings at mm/page_counter.c:60 at
 page_counter_cancel+0x110/0x134, CPU#24: kworker/24:3/1074770
Message-ID: <aZYyNtI-4yS4BFXX@linux.dev>
References: <ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com>
 <aZRdcsjvqK9s_Tej@nidhogg.toxiclabs.cc>
 <82cf51d8-eeaf-4616-ad54-23bb9938cbc3@suse.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82cf51d8-eeaf-4616-ad54-23bb9938cbc3@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 18, 2026 at 12:42:33PM +0100, Vlastimil Babka wrote:
> On 2/17/26 13:25, Carlos Maiolino wrote:
> > On Tue, Feb 17, 2026 at 04:54:06PM +0530, Venkat Rao Bagalkote wrote:
> >> Greetings!!!
> >> 
> >> I am observing below warnings, while running xfstests generic/332 test case.
> >> But I am not able to reproduce this consistently.
> >> 
> >> 
> >> Platform: IBM Power11 (pSeries LPAR), Radix MMU, LE, 64K pages
> >> Kernel: 6.19.0-next-20260216
> >> Tests: generic/332
> >> 
> >> local.config >>>
> >> [xfs_4k]
> >> export RECREATE_TEST_DEV=true
> >> export TEST_DEV=/dev/loop0
> >> export TEST_DIR=/mnt/test
> >> export SCRATCH_DEV=/dev/loop1
> >> export SCRATCH_MNT=/mnt/scratch
> >> export MKFS_OPTIONS="-b size=4096"
> >> export FSTYP=xfs
> >> export MOUNT_OPTIONS=""-
> >> 
> >> 
> >> 
> >> Attached is .config file used.
> >> 
> >> 
> >> Traces:
> >> 
> >> 
> >> [ 5152.507299] run fstests generic/332 at 2026-02-16 22:10:54
> >> [ 5152.792552] XFS (loop0): Mounting V5 Filesystem
> >> 93d6dd00-ca31-47bb-8170-254f04bcaa7f
> >> [ 5152.795270] XFS (loop0): Ending clean mount
> >> [ 5152.797551] ------------[ cut here ]------------
> >> [ 5152.797562] page_counter underflow: -1 nr_pages=58
> >> [ 5152.797586] WARNING: mm/page_counter.c:60 at
> >> page_counter_cancel+0x110/0x134, CPU#24: kworker/24:3/1074770
> >> [ 5152.797602] Modules linked in: dm_snapshot dm_bufio dm_flakey xfs loop
> >> dm_mod nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet
> >> nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat
> >> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bonding ip_set tls nf_tables
> >> rfkill sunrpc nfnetlink pseries_rng vmx_crypto dax_pmem fuse ext4 crc16
> >> mbcache jbd2 nd_pmem papr_scm sd_mod libnvdimm sg ibmvscsi ibmveth
> >> scsi_transport_srp pseries_wdt [last unloaded: scsi_debug]
> >> [ 5152.797712] CPU: 24 UID: 0 PID: 1074770 Comm: kworker/24:3 Kdump: loaded
> >> Not tainted 6.19.0-next-20260216 #1 PREEMPTLAZY
> >> [ 5152.797723] Hardware name: IBM,9080-HEX Power11 (architected) 0x820200 0xf000007 of:IBM,FW1110.01 (NH1110_069) hv:phyp pSeries
> >> [ 5152.797731] Workqueue: memcg drain_local_memcg_stock
> >> [ 5152.797741] NIP:  c00000000089f460 LR: c00000000089f45c CTR: 0000000000000000
> >> [ 5152.797749] REGS: c000000267417960 TRAP: 0700   Not tainted (6.19.0-next-20260216)
> >> [ 5152.797756] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 48000200  XER: 00000007
> >> [ 5152.797786] CFAR: c0000000001bc144 IRQMASK: 0
> >> [ 5152.797786] GPR00: c00000000089f45c c000000267417c00 c00000000243a500 c0000002699d1280
> >> [ 5152.797786] GPR04: 0000000000000004 0000000000000001 c0000000001bc0f4 0000000000000001
> >> [ 5152.797786] GPR08: a80e000000000000 0000000000000001 0000000000000003 a80e000000000000
> >> [ 5152.797786] GPR12: c00e0001a1a3cfb2 c000000d0ddea700 c0000001d9f80240
> >> c000000d0d1fefd0
> >> [ 5152.797786] GPR16: c000000007a5ab08 c0000001d9f80278 0000000000000000
> >> 0000000000000001
> >> [ 5152.797786] GPR20: c0000002699d1300 0000000000000000 0000000000000000
> >> c0000000032cef80
> >> [ 5152.797786] GPR24: 0000000000000002 c0000002699d1280 c000000d0d1fef83
> >> c000000d0d1fef98
> >> [ 5152.797786] GPR28: c000000d0d1fef80 ffffffffffffffff 000000000000003a
> >> c00000007d696000
> >> [ 5152.797885] NIP [c00000000089f460] page_counter_cancel+0x110/0x134
> >> [ 5152.797894] LR [c00000000089f45c] page_counter_cancel+0x10c/0x134
> >> [ 5152.797902] Call Trace:
> >> [ 5152.797907] [c000000267417c00] [c00000000089f45c] page_counter_cancel+0x10c/0x134 (unreliable)
> >> [ 5152.797920] [c000000267417c80] [c00000000089f8cc] page_counter_uncharge+0x3c/0x6c
> >> [ 5152.797930] [c000000267417cb0] [c0000000008ab630] drain_local_memcg_stock+0x198/0x464
> >> [ 5152.797942] [c000000267417da0] [c000000000204ffc] process_one_work+0x3d4/0x968
> >> [ 5152.797954] [c000000267417eb0] [c00000000020664c] worker_thread+0x308/0x614
> >> [ 5152.797964] [c000000267417f80] [c0000000002183f8] kthread+0x244/0x28c
> >> [ 5152.797974] [c000000267417fe0] [c00000000000ded8] start_kernel_thread+0x14/0x18
> >> [ 5152.797985] Code: 3d220289 892982ea 2c090000 40820028 3c62ff7a 39200001
> >> 3d420289 7fc5f378 38631be0 992a82ea 4b91cbed 60000000 <0fe00000> 38800008
> >> 7fe3fb78 4bfc35e1
> >> [ 5152.798021] ---[ end trace 0000000000000000 ]---
> > 
> > This does not seem related to xfs at all, I'm not Cc'ing linux-mm
> > because Vlastimil is already Cc'ed so, he knows better than me if this
> > is worth sharing with linux-mm.
> 
> This one also also seems memcg related, but no slab in the picture here.
> 

I found the following two config options interesting. Not sure if it is related
to this warning (and the other crash).

>> CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC=y
>> CONFIG_MEMCG_V1=y

