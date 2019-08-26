Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB10C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 19:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2282A2342D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 19:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbfHZTck (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 15:32:40 -0400
Received: from sandeen.net ([63.231.237.45]:39062 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbfHZTck (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Aug 2019 15:32:40 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3FAFE4CDD33;
        Mon, 26 Aug 2019 14:32:39 -0500 (CDT)
Subject: Re: [PATCH v2 05/15] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652198391.2607.14772471190581142304.stgit@fedora-28>
 <4fcd7f09-88d9-35c7-d6f3-2c6407260fee@sandeen.net>
 <a6c39432-063e-a619-1691-83134f8fafef@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <393483c3-1fb4-f225-3372-f6e80cefba71@sandeen.net>
Date:   Mon, 26 Aug 2019 14:32:38 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a6c39432-063e-a619-1691-83134f8fafef@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/26/19 2:31 PM, Eric Sandeen wrote:
> On 8/26/19 2:19 PM, Eric Sandeen wrote:
>>>  	case Opt_biosize:
>>> -		if (match_kstrtoint(args, 10, &iosize))
>>> +		if (suffix_kstrtoint(param->string, 10, &iosize))
>>>  			return -EINVAL;
>>> -		*iosizelog = ffs(iosize) - 1;
>>> +		ctx->iosizelog = ffs(iosize) - 1;
>>>  		break;
>>>  	case Opt_grpid:
>>> +		if (result.negated)
>>> +			mp->m_flags &= ~XFS_MOUNT_GRPID;
>>> +		else
>>> +			mp->m_flags |= XFS_MOUNT_GRPID;
>>> +		break;
>> Is there any real advantage to this "fsparam_flag_no" / negated stuff?
>> I don't see any other filesystem using it (yet) and I'm not totally convinced
>> that this is any better, more readable, or more efficient than just keeping
>> the "Opt_nogrpid" stuff around.  Not a dealbreaker but just thinking out
>> loud... seems like this interface was a solution in search of a problem?
> 
> Also, at least as of this patch, it seems broken:
> 
> [xfstests-dev]# mount -o noikeep /dev/pmem0p1 /mnt/test
> mount: mount /dev/pmem0p1 on /mnt/test failed: Unknown error 519
> 
> <dmesg shows nothing>
> 
> [xfstests-dev]# mount -o ikeep /dev/pmem0p1 /mnt/test
> mount: wrong fs type, bad option, bad superblock on /dev/pmem0p1,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> [xfstests-dev]# dmesg | tail -n 1
> [  282.281557] XFS: Unexpected value for 'ikeep'

and it panics shortly after these failures.

[  378.761698] WARNING: CPU: 8 PID: 12477 at kernel/rcu/tree.c:2498 __call_rcu+0x1e9/0x290
[  378.770633] Modules linked in: macsec tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_rapl_msr intel_rapl_common sunrpc x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel nd_pmem nd_btt iTCO_wdt intel_cstate ipmi_si iTCO_vendor_support mei_me ipmi_devintf intel_uncore intel_rapl_perf mei ipmi_msghandler wmi nd_e820 libnvdimm pcspkr sg i2c_i801 ioatdma lpc_ich binfmt_misc ip_tables xfs(O) libcrc32c sd_mod mgag200 drm_vram_helper ttm drm_kms_helper syscopyarea igb crc32c_intel sysfillrect sysimgblt isci fb_sys_fops ptp libsas ahci pps_core drm scsi_transport_sas libahci dca i2c_algo_bit libata i2c_core dm_mirror dm_region_hash dm_log dm_mod
[  378.863955] CPU: 8 PID: 12477 Comm: bash Kdump: loaded Tainted: G           O      5.3.0-rc2+ #12
[  378.873860] Hardware name: Intel Corporation LH Pass/SVRBD-ROW_P, BIOS SE5C600.86B.02.01.SP06.050920141054 05/09/2014
[  378.885696] RIP: 0010:__call_rcu+0x1e9/0x290
[  378.890460] Code: 0f 84 8d 00 00 00 48 89 83 b0 00 00 00 48 8b 83 98 00 00 00 48 89 83 a8 00 00 00 e9 b4 fe ff ff e8 2c c8 ff ff e9 5f ff ff ff <0f> 0b 0f 1f 44 00 00 e9 31 fe ff ff 83 fa ff 0f 1f 84 00 00 00 00
[  378.911418] RSP: 0018:ffffc900070a3de0 EFLAGS: 00010206
[  378.917247] RAX: 0000000080000000 RBX: ffff888ffc6eade5 RCX: 0000000000000000
[  378.925210] RDX: 00000000ffffffff RSI: ffffffff81747450 RDI: ffff888ffc6eafbd
[  378.933174] RBP: ffff888ffc6eafbd R08: 0000000000000000 R09: ffff888ffc6eaec5
[  378.941135] R10: ffff88901567c880 R11: ffff889000844a10 R12: ffff888ffc6eafb5
[  378.949098] R13: ffff888103e20750 R14: ffffffff81747450 R15: 0000000000000000
[  378.957062] FS:  00007f08a102b740(0000) GS:ffff88901ea00000(0000) knlGS:0000000000000000
[  378.966092] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  378.972505] CR2: 00007f08a1037000 CR3: 0000000ffc77a004 CR4: 00000000001606e0
[  378.980469] Call Trace:
[  378.983208]  netlink_release+0x2b1/0x540
[  378.987586]  __sock_release+0x3d/0xc0
[  378.991673]  sock_close+0x11/0x20
[  378.995373]  __fput+0xbe/0x250
[  378.998784]  task_work_run+0x88/0xa0
[  379.002775]  exit_to_usermode_loop+0x77/0xc7
[  379.007537]  do_syscall_64+0x1a1/0x1d0
[  379.011721]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  379.017361] RIP: 0033:0x7f08a0714620
[  379.021348] Code: 00 64 c7 00 0d 00 00 00 b8 ff ff ff ff eb 90 b8 ff ff ff ff eb 89 0f 1f 40 00 83 3d 7d c9 2d 00 00 75 10 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 9e c5 01 00 48 89 04 24
[  379.042303] RSP: 002b:00007ffdef07c748 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
[  379.050752] RAX: 0000000000000000 RBX: 0000000001e0cc70 RCX: 00007f08a0714620
[  379.058715] RDX: 0000000000000000 RSI: 00007ffdef07c790 RDI: 0000000000000003
[  379.066679] RBP: 0000000000000003 R08: 00007ffdef07c6a0 R09: 00007ffdef07c5f0
[  379.074640] R10: 0000000000000008 R11: 0000000000000246 R12: 000000000000001c
[  379.082602] R13: 0000000000000001 R14: 0000000000000002 R15: 00007ffdef07c930
[  379.090565] ---[ end trace 0146f578893eb498 ]---
