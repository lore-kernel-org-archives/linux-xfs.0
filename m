Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE40EC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Nov 2021 23:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359767AbhK1Xn4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Nov 2021 18:43:56 -0500
Received: from sandeen.net ([63.231.237.45]:45916 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359595AbhK1Xlz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 28 Nov 2021 18:41:55 -0500
Received: from [10.132.48.7] (unknown [216.176.47.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B8F764820;
        Sun, 28 Nov 2021 17:38:02 -0600 (CST)
Message-ID: <6502995c-2586-2cea-3ae6-01babb63034b@sandeen.net>
Date:   Sun, 28 Nov 2021 15:38:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-xfs@vger.kernel.org
References: <473f18c6-dc0c-caa4-26d6-2b76ae0d3b35@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS: Assertion failed: !(flags & (RENAME_NOREPLACE |
 RENAME_EXCHANGE))
In-Reply-To: <473f18c6-dc0c-caa4-26d6-2b76ae0d3b35@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/26/21 9:56 AM, Paolo Bonzini wrote:
> Hi all,
> 
> I have reached the following ASSERT today running a kernel from
> git commit 5d9f4cf36721:
> 
>          /*
>           * If we are doing a whiteout operation, allocate the whiteout inode
>           * we will be placing at the target and ensure the type is set
>           * appropriately.
>           */
>          if (flags & RENAME_WHITEOUT) {
>                  ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
>                  error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
>                  if (error)
>                          return error;
> 
>                  /* setup target dirent info as whiteout */
>                  src_name->type = XFS_DIR3_FT_CHRDEV;
>          }


Hmm.  Is our ASSERT correct?  rename(2) says:

RENAME_NOREPLACE can't be employed together with RENAME_EXCHANGE.
RENAME_WHITEOUT  can't be employed together with RENAME_EXCHANGE.

do_renameat2() does enforce this:

         if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
             (flags & RENAME_EXCHANGE))
                 goto put_names;

but our assert seems to check for something different: that neither
NOREPLACE nor EXCHANGE is employed with WHITEOUT. Is that a thinko?

           if (flags & RENAME_WHITEOUT) {
                   ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));

(Neither of these checks has changed for a long time, AFAICT.)

-Eric

> I don't have a reproducer yet, as I was doing a few container-based
> builds today and I'm not sure which one resulted in the problematic
> call to xfs_vn_rename.  Here is the full text of the WARN:
> 
> [23045.125454] XFS: Assertion failed: !(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)), file: fs/xfs/xfs_inode.c, line: 3125
> [23045.136466] ------------[ cut here ]------------
> [23045.141167] WARNING: CPU: 20 PID: 125038 at fs/xfs/xfs_message.c:97 asswarn+0x1a/0x1d [xfs]
> [23045.149893] Modules linked in: tun overlay kvm_intel(OE) kvm(OE) tls rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc intel_rapl_msr intel_rapl_common isst_if_common skx_edac nfit ipmi_ssif libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt intel_pmc_bxt iTCO_vendor_support dell_smbios irqbypass dcdbas rapl intel_cstate i2c_i801 acpi_ipmi intel_uncore dell_wmi_descriptor wmi_bmof pcspkr lpc_ich i2c_smbus mei_me ipmi_si mei intel_pch_thermal ipmi_devintf ipmi_msghandler acpi_power_meter xfs crct10dif_pclmul crc32_pclmul crc32c_intel i40e ghash_clmulni_intel megaraid_sas tg3 mgag200 wmi fuse [last unloaded: kvm]
> [23045.209101] CPU: 20 PID: 125038 Comm: fuse-overlayfs Kdump: loaded Tainted: G        W IOE    --------- ---  5.16.0-0.rc2.20211124git5d9f4cf36721.19.fc36.x86_64 #1
> [23045.223732] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS 1.6.11 11/20/2018
> [23045.231319] RIP: 0010:asswarn+0x1a/0x1d [xfs]
> [23045.235821] Code: db 74 02 0f 0b 48 83 c4 58 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 68 59 6d c0 e8 ad fd ff ff <0f> 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 68 59
> [23045.254587] RSP: 0018:ffffa0c084d27bf0 EFLAGS: 00010282
> [23045.259829] RAX: 00000000ffffffea RBX: 0000000000000001 RCX: 0000000000000000
> [23045.266981] RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffffc06c7f42
> [23045.274133] RBP: ffffffff9c073b20 R08: 0000000000000000 R09: 000000000000000a
> [23045.281278] R10: 000000000000000a R11: f000000000000000 R12: ffff8af102784000
> [23045.288428] R13: ffff8af1d7ed6900 R14: ffffffff9c073b20 R15: ffff8af1d7ed6900
> [23045.295580] FS:  00007f1a0a1ac740(0000) GS:ffff8afc0f200000(0000) knlGS:0000000000000000
> [23045.303682] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [23045.309445] CR2: 0000561615cefbe8 CR3: 00000004c19a8004 CR4: 00000000007706e0
> [23045.316594] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [23045.323745] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [23045.330895] PKRU: 55555554
> [23045.333626] Call Trace:
> [23045.336099]  <TASK>
> [23045.338221]  xfs_rename+0x975/0xd60 [xfs]
> [23045.342359]  ? lock_acquire+0xd3/0x2f0
> [23045.346140]  xfs_vn_rename+0xcb/0x130 [xfs]
> [23045.350452]  ? vfs_rename+0x64d/0xd20
> [23045.354146]  vfs_rename+0x9cd/0xd20
> [23045.357670]  ? lookup_dcache+0x18/0x60
> [23045.361451]  ? do_renameat2+0x4c1/0x500
> [23045.365311]  do_renameat2+0x4c1/0x500
> [23045.369019]  __x64_sys_renameat2+0x4b/0x60
> [23045.373138]  do_syscall_64+0x3b/0x90
> [23045.376745]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [23045.381820] RIP: 0033:0x7f1a0a2ba0ed
> [23045.385415] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0b ed 0e 00 f7 d8 64 89 01 48
> [23045.404184] RSP: 002b:00007ffd5272a0c8 EFLAGS: 00000206 ORIG_RAX: 000000000000013c
> [23045.411782] RAX: ffffffffffffffda RBX: 00007ffd5272a440 RCX: 00007f1a0a2ba0ed
> [23045.418929] RDX: 000000000000003d RSI: 00007f1a0a0aa048 RDI: 0000000000000035
> [23045.426080] RBP: 00007ffd5272a1d0 R08: 0000000000000005 R09: 00007ffd5272a440
> [23045.433228] R10: 00007f1a0a0aa05b R11: 0000000000000206 R12: 0000000000000035
> [23045.440378] R13: 0000561615ce4050 R14: 000056161560a670 R15: 000056161560b170
> [23045.447565]  </TASK>
> 
> Hope this helps,
> 
> Paolo
> 
