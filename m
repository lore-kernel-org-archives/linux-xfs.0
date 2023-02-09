Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA186C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 21:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBIVu1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 16:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIVu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 16:50:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A857A25298
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 13:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9z3CetqWR7FnLKwCvxlHIWMBEwWt3NguIcUX9CsxuGY=; b=Tf0b+PD746qJ97SYvFqyLysWkl
        d3OVchju16Q9bCmGnutEf7sP+W9Sbh4pe+3EAP4Qq1lQFWmpfKmLSzM28fI2ZPKblwB/ST8Rvu1F/
        RXxak5q/dT/t8sCR3mT5a1cKLmzCI+A709HqDmaZnS4saWg/dyiIjWeh81J+YW+Vu44u9SNLe4ueU
        64VKpKfrmB+VtrYKMKMfSgk2V2+sXsPFBf/zWebyEuFUsTg8miUGQV3Gu97A3hDD60Ze0Qlp21vV/
        GQIzCYmdX6Vi7h8+TM052ZtET6zCCshFZAN2G1Mm3Mot6IJkNiWlbsnGvZubs33BtaaF04RkF8TSE
        QDKLAH8g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQEo8-002XlQ-6X; Thu, 09 Feb 2023 21:50:20 +0000
Date:   Thu, 9 Feb 2023 21:50:20 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000042
Message-ID: <Y+VqnCrGd56tUH5D@casper.infradead.org>
References: <412ef57499e8ad13c815516f11cd00479a35587a.camel@scylladb.com>
 <20230209213002.GF360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209213002.GF360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 10, 2023 at 08:30:02AM +1100, Dave Chinner wrote:
> [cc willy, linux-mm, as it crashed walking the page cache in the
> generic fault code]

I've seen this one occasionally, and I'm not sure what's going on.
I've never been able to reproduce it myself, and it seems to disappear
for the people who have been able to reproduce it ;-(

It is 100% my fault and definitely caused by large folios.  In the
XArray, large folios are represented by a folio pointer in the lowest
index occupied by that folio and sibling entries in every other index,
which redirect lookups to the canonical (ie lowest) entry.  This 0x42
that you've managed to find in the XArray is a sibling entry.  It
says that the entry we're actually looking for is at offset 0x10 of
the node we're in.  

Something similar was fixed in commit 63b1898fffcd, but that was a
sibling entry that ended up pointing to a node.  You've *presumably*
hit some kind of temporary situation where the original sibling entry is no
longer pointing to the folio entry that it should be.  However, there's
another possibility, which is that this is not a temporary RCU-induced
state, but we have corruption in the tree.  If we do have corruption,
then you'll see an infinite loop instead of a crash.

If it's a temporary situation, this will fix it.

diff --git a/lib/xarray.c b/lib/xarray.c
index ea9ce1f0b386..4237a9647a6a 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -207,7 +207,8 @@ static void *xas_descend(struct xa_state *xas, struct xa_node *node)
 	if (xa_is_sibling(entry)) {
 		offset = xa_to_sibling(entry);
 		entry = xa_entry(xas->xa, node, offset);
-		if (node->shift && xa_is_node(entry))
+		if (xa_is_sibling(entry) ||
+		    (node->shift && xa_is_node(entry)))
 			entry = XA_RETRY_ENTRY;
 	}
 
Please do let me know ... you say it's happened twice, but how many
machine-hours did it take to hit twice?

> On Thu, Feb 09, 2023 at 10:43:10AM +0200, Avi Kivity wrote:
> > Workload: compilation and running unit tests. The task that crashed is
> > a unit test.
> > 
> > Kernel: 6.1.8-200.fc37.x86_64
> > 
> > Previously known stable on 5.8.9-200.fc32.x86_64. Two crashes seen so
> > far.
> > 
> > 
> > Feb  7 17:19:33 localhost kernel: BUG: kernel NULL pointer dereference,
> > address: 0000000000000042
> > Feb  7 17:19:33 localhost kernel: #PF: supervisor read access in kernel
> > mode
> > Feb  7 17:19:33 localhost kernel: #PF: error_code(0x0000) - not-present
> > page
> > Feb  7 17:19:33 localhost kernel: PGD 80000001cbb1f067 P4D
> > 80000001cbb1f067 PUD 9cbb75067 PMD 0 
> > Feb  7 17:19:33 localhost kernel: Oops: 0000 [#1] PREEMPT SMP PTI
> > Feb  7 17:19:33 localhost kernel: CPU: 24 PID: 3718328 Comm:
> > transport_test Tainted: G S                 6.1.8-200.fc37.x86_64 #1
> > Feb  7 17:19:33 localhost kernel: Hardware name: Dell Inc. PowerEdge
> > R730/0599V5, BIOS 2.9.1 12/04/2018
> > Feb  7 17:19:33 localhost kernel: RIP:
> > 0010:next_uptodate_page+0x46/0x200
> > Feb  7 17:19:33 localhost kernel: Code: 0f 84 3f 01 00 00 48 81 ff 06
> > 04 00 00 0f 84 b3 00 00 00 48 81 ff 02 04 00 00 0f 84 37 01 00 00 40 f6
> > c7 01 0f 85 9c 00 00 00 <48> 8b 07 a8 01 0f 85 91 00 00 00 8b 47 34 85
> > c0 0f 84 86 00 00 00
> > Feb  7 17:19:33 localhost kernel: RSP: 0000:ffffa83e4ed67cc8 EFLAGS:
> > 00010246
> > Feb  7 17:19:33 localhost kernel: RAX: 0000000000000042 RBX:
> > ffffa83e4ed67e00 RCX: 000000000000146e
> > Feb  7 17:19:33 localhost kernel: RDX: ffffa83e4ed67d20 RSI:
> > ffff94a9046316b0 RDI: 0000000000000042
> > Feb  7 17:19:33 localhost kernel: RBP: ffffa83e4ed67d20 R08:
> > 000000000000146e R09: 0000000000dfd000
> > Feb  7 17:19:33 localhost kernel: R10: 000000000000145f R11:
> > ffff94978b85960c R12: ffff94a9046316b0
> > Feb  7 17:19:33 localhost kernel: R13: 000000000000146e R14:
> > ffff94a9046316b0 R15: ffff948f8bb1f000
> > Feb  7 17:19:33 localhost kernel: FS:  00007fd68fcb9d40(0000)
> > GS:ffff949dffd00000(0000) knlGS:0000000000000000
> > Feb  7 17:19:33 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> > Feb  7 17:19:33 localhost kernel: CR2: 0000000000000042 CR3:
> > 00000001dc1be005 CR4: 00000000001706e0
> > Feb  7 17:19:33 localhost kernel: Call Trace:
> > Feb  7 17:19:33 localhost kernel: <TASK>
> > Feb  7 17:19:33 localhost kernel: filemap_map_pages+0x9f/0x7b0
> > Feb  7 17:19:33 localhost kernel: xfs_filemap_map_pages+0x41/0x60 [xfs]
> > Feb  7 17:19:33 localhost kernel: do_fault+0x1bf/0x430
> > Feb  7 17:19:33 localhost kernel: __handle_mm_fault+0x63d/0xe40
> > Feb  7 17:19:33 localhost kernel: ? do_sigaction+0x11a/0x240
> > Feb  7 17:19:33 localhost kernel: handle_mm_fault+0xdb/0x2d0
> > Feb  7 17:19:33 localhost kernel: do_user_addr_fault+0x1cd/0x690
> > Feb  7 17:19:33 localhost kernel: exc_page_fault+0x70/0x170
> > Feb  7 17:19:33 localhost kernel: asm_exc_page_fault+0x22/0x30
> > Feb  7 17:19:33 localhost kernel: RIP: 0033:0x1666350
> > Feb  7 17:19:33 localhost kernel: Code: Unable to access opcode bytes
> > at 0x1666326.
> > Feb  7 17:19:33 localhost kernel: RSP: 002b:00007ffde7fa86d8 EFLAGS:
> > 00010212
> > Feb  7 17:19:33 localhost kernel: RAX: 0000000000000000 RBX:
> > 00007ffde7fa8748 RCX: 0000000002ed4468
> > Feb  7 17:19:33 localhost kernel: RDX: 00006000000c4f50 RSI:
> > 00007ffde7fa8748 RDI: 0000000000000012
> > Feb  7 17:19:33 localhost kernel: RBP: 0000000000000012 R08:
> > 0000000000000001 R09: 0000000002f46860
> > Feb  7 17:19:33 localhost kernel: R10: 00007fd69219cac0 R11:
> > 00007fd69224e670 R12: 0000000000000000
> > Feb  7 17:19:33 localhost kernel: R13: 00006000000c4f50 R14:
> > 0000000002ed4470 R15: 00007fd693be0000
> > Feb  7 17:19:33 localhost kernel: </TASK>
> > Feb  7 17:19:33 localhost kernel: Modules linked in: xsk_diag veth tls
> > xt_conntrack xt_MASQUERADE nf_conntrack_netlink xt_addrtype nft_compat
> > br_netfilter bridge stp llc intel_rapl_msr dell_wmi iTCO_wdt
> > dell_smbios intel_pmc_bxt iTCO_vendor_support dell_wmi_descriptor
> > ledtrig_audio sparse_keymap video dcdbas intel_rapl_common sb_edac
> > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif
> > irqbypass rapl intel_cstate intel_uncore ipmi_si ipmi_devintf
> > ipmi_msghandler nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
> > nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> > nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill
> > overlay ip_set nf_tables nfnetlink qrtr acpi_power_meter mxm_wmi mei_me
> > mei lpc_ich auth_rpcgss ip6_tables ip_tables sunrpc zram xfs
> > crct10dif_pclmul crc32_pclmul nvme crc32c_intel polyval_clmulni
> > polyval_generic ixgbe ghash_clmulni_intel nvme_core sha512_ssse3
> > megaraid_sas tg3 mgag200 mdio nvme_common dca wmi scsi_dh_rdac
> > scsi_dh_emc scsi_dh_alua
> > Feb  7 17:19:33 localhost kernel: dm_multipath fuse
> > Feb  7 17:19:33 localhost kernel: CR2: 0000000000000042
> > Feb  7 17:19:33 localhost kernel: ---[ end trace 0000000000000000 ]---
> > Feb  7 17:19:33 localhost kernel: RIP:
> > 0010:next_uptodate_page+0x46/0x200
> > Feb  7 17:19:33 localhost kernel: Code: 0f 84 3f 01 00 00 48 81 ff 06
> > 04 00 00 0f 84 b3 00 00 00 48 81 ff 02 04 00 00 0f 84 37 01 00 00 40 f6
> > c7 01 0f 85 9c 00 00 00 <48> 8b 07 a8 01 0f 85 91 00 00 00 8b 47 34 85
> > c0 0f 84 86 00 00 00
> > Feb  7 17:19:33 localhost kernel: RSP: 0000:ffffa83e4ed67cc8 EFLAGS:
> > 00010246
> > Feb  7 17:19:33 localhost kernel: RAX: 0000000000000042 RBX:
> > ffffa83e4ed67e00 RCX: 000000000000146e
> > Feb  7 17:19:33 localhost kernel: RDX: ffffa83e4ed67d20 RSI:
> > ffff94a9046316b0 RDI: 0000000000000042
> > Feb  7 17:19:33 localhost kernel: RBP: ffffa83e4ed67d20 R08:
> > 000000000000146e R09: 0000000000dfd000
> > Feb  7 17:19:33 localhost kernel: R10: 000000000000145f R11:
> > ffff94978b85960c R12: ffff94a9046316b0
> > Feb  7 17:19:33 localhost kernel: R13: 000000000000146e R14:
> > ffff94a9046316b0 R15: ffff948f8bb1f000
> > Feb  7 17:19:33 localhost kernel: FS:  00007fd68fcb9d40(0000)
> > GS:ffff949dffd00000(0000) knlGS:0000000000000000
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
