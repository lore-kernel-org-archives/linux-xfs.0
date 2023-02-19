Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6837C61DA4
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Feb 2023 19:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjBSTKN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Feb 2023 14:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjBSTKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Feb 2023 14:10:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F4F14E9A
        for <linux-xfs@vger.kernel.org>; Sun, 19 Feb 2023 11:10:06 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id b11so1551593wrw.5
        for <linux-xfs@vger.kernel.org>; Sun, 19 Feb 2023 11:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pkN0YdD8dEAF6e7Dz2wOIvKYfTpALyvEyYpNUUwVKj0=;
        b=yvGLSKIeRb8Q2AVcYjnAdsk1c3qwduKCqkDQVxt5V/OIxeqp4zjc3V5ytoF0hwu6yB
         rMpomzhaUqC6ELmpX70XSogsi443KzFmixJO7+7KATlH1h3gN6V6oJFFu/oQB3wjMCbW
         dCuWarQmOAyUVyiv45QfQlXSRoxbjkiJjgk3mbhg2iyPW9+qvwhyfmCBByLQxCDKCekT
         a9iZZ4XQWO3SJidihXIlztvHPziFuSfyCbxTFlBB7zpFXA1ospTXY78Fbpyg1MqJcIaq
         79YeuwZKCGo6p4J4aCiLvdJ77UsyTtdxnKYCMzicvqTHhLtzXtdY+TX4FErzGt2GeNvB
         dBqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pkN0YdD8dEAF6e7Dz2wOIvKYfTpALyvEyYpNUUwVKj0=;
        b=37XcvGyjuG27xLpETgTsAjJ/x6bLWVv++HiHtOgktriejjLG0Xt0aJ2z/AH15JcAes
         UrRGCisAnQ1G/L+tH+ExKSCFVdyhfd+JS0dcaUwHGRO5r5yZxi+sz4bY6GH2Kk58UbgE
         MMugNmKkcn4a1KN6jWyoSrXPg6U0pIUnJN2oihtXtZpgP+sjFcD+XEN9wLSlaR8E99Cx
         C5oG5phLzWG93vHSvOZoaSYYg+KQzBNNgnS92mR45GAEO0AoH30Fzhmfp3Is1RgwQuRY
         lAKewHBfcBWiXQMdhiDj9NffeOEZ7nmW+fFm1yqq6qsu1rDiuEMQ18bIOdFJ6qGDrAJh
         dNyQ==
X-Gm-Message-State: AO0yUKXtuIKx5HYmW2X4ouV999v67om41d73JCRBiwf/UEtQgXMv8yWk
        k7r6jpGF/zi/pQhie1YIkFH9HTm8yvW1LKMrbpoAjJr30kaLi3k+/1FuKQiSlz4mgRXYzrsaWxx
        pXU/nr0tWQOSI58xAuPmDKU1E2rXkknunbghP2PayF7eux6P8TF7M6UfFJ1Wg94C2OWWjV9jxmN
        ZtwZZB3D+oIXwYzyE4S+M84ZAZ4WfH9WvYv9FkjalImzTIny7O8vDIcn0=
X-Google-Smtp-Source: AK7set+qRH3lK4l8EQWdLMzKXsBWrIFxKpqsmQYRp5N+2UVyRfSvV/4VjcvGDe6aIVLCBWXOnZWYwA==
X-Received: by 2002:a5d:5710:0:b0:2c5:5dbf:1cc2 with SMTP id a16-20020a5d5710000000b002c55dbf1cc2mr1884469wrv.32.1676833805265;
        Sun, 19 Feb 2023 11:10:05 -0800 (PST)
Received: from avi.scylladb.com (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id u4-20020a5d4344000000b002c3f03d8851sm2434422wrr.16.2023.02.19.11.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 11:10:04 -0800 (PST)
Message-ID: <4d0982f52126f653feee5c2b3131dbab57e28785.camel@scylladb.com>
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000042
From:   Avi Kivity <avi@scylladb.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Date:   Sun, 19 Feb 2023 21:10:11 +0200
In-Reply-To: <Y+VqnCrGd56tUH5D@casper.infradead.org>
References: <412ef57499e8ad13c815516f11cd00479a35587a.camel@scylladb.com>
         <20230209213002.GF360264@dread.disaster.area>
         <Y+VqnCrGd56tUH5D@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

(resending as text so it doesn't get rejected as spam by the list;
since I responded on Feb 12 we've seen it happen one more time)

On Thu, 2023-02-09 at 21:50 +0000, Matthew Wilcox wrote:
> On Fri, Feb 10, 2023 at 08:30:02AM +1100, Dave Chinner wrote:
> > [cc willy, linux-mm, as it crashed walking the page cache in the
> > generic fault code]
>=20
> I've seen this one occasionally, and I'm not sure what's going on.
> I've never been able to reproduce it myself, and it seems to
> disappear
> for the people who have been able to reproduce it ;-(
>=20
> It is 100% my fault and definitely caused by large folios.=C2=A0 In the
> XArray, large folios are represented by a folio pointer in the lowest
> index occupied by that folio and sibling entries in every other
> index,
> which redirect lookups to the canonical (ie lowest) entry.=C2=A0 This 0x4=
2
> that you've managed to find in the XArray is a sibling entry.=C2=A0 It
> says that the entry we're actually looking for is at offset 0x10 of
> the node we're in.=C2=A0=20
>=20
> Something similar was fixed in commit 63b1898fffcd, but that was a
> sibling entry that ended up pointing to a node.=C2=A0 You've *presumably*
> hit some kind of temporary situation where the original sibling entry
> is no
> longer pointing to the folio entry that it should be.=C2=A0 However,
> there's
> another possibility, which is that this is not a temporary RCU-
> induced
> state, but we have corruption in the tree.=C2=A0 If we do have corruption=
,
> then you'll see an infinite loop instead of a crash.
>=20
> If it's a temporary situation, this will fix it.
>=20

I'm unfortunately not in a position to test a fix.=C2=A0

> diff --git a/lib/xarray.c b/lib/xarray.c
> index ea9ce1f0b386..4237a9647a6a 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -207,7 +207,8 @@ static void *xas_descend(struct xa_state *xas,
> struct xa_node *node)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (xa_is_sibling(entry))=
 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0offset =3D xa_to_sibling(entry);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0entry =3D xa_entry(xas->xa, node, offset);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if (node->shift && xa_is_node(entry))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if (xa_is_sibling(entry) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (node->shift && xa_is_node(entry)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ent=
ry =3D XA_RETRY_ENTRY;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> Please do let me know ... you say it's happened twice, but how many
> machine-hours did it take to hit twice?


That's hard to say. There are ~5 machines doing this work, the kernel
was installed in early February, so around 1000 machine-hours, but what
part of the time they were busy and how much of that they were running
the triggering workload, I can't say.

>=20
> > On Thu, Feb 09, 2023 at 10:43:10AM +0200, Avi Kivity wrote:
> > > Workload: compilation and running unit tests. The task that
> > > crashed is
> > > a unit test.
> > >=20
> > > Kernel: 6.1.8-200.fc37.x86_64
> > >=20
> > > Previously known stable on 5.8.9-200.fc32.x86_64. Two crashes
> > > seen so
> > > far.
> > >=20
> > >=20
> > > Feb=C2=A0 7 17:19:33 localhost kernel: BUG: kernel NULL pointer
> > > dereference,
> > > address: 0000000000000042
> > > Feb=C2=A0 7 17:19:33 localhost kernel: #PF: supervisor read access in
> > > kernel
> > > mode
> > > Feb=C2=A0 7 17:19:33 localhost kernel: #PF: error_code(0x0000) - not-
> > > present
> > > page
> > > Feb=C2=A0 7 17:19:33 localhost kernel: PGD 80000001cbb1f067 P4D
> > > 80000001cbb1f067 PUD 9cbb75067 PMD 0=20
> > > Feb=C2=A0 7 17:19:33 localhost kernel: Oops: 0000 [#1] PREEMPT SMP PT=
I
> > > Feb=C2=A0 7 17:19:33 localhost kernel: CPU: 24 PID: 3718328 Comm:
> > > transport_test Tainted: G S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.1.8-200.fc37.x86_6=
4
> > > #1
> > > Feb=C2=A0 7 17:19:33 localhost kernel: Hardware name: Dell Inc.
> > > PowerEdge
> > > R730/0599V5, BIOS 2.9.1 12/04/2018
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RIP:
> > > 0010:next_uptodate_page+0x46/0x200
> > > Feb=C2=A0 7 17:19:33 localhost kernel: Code: 0f 84 3f 01 00 00 48 81
> > > ff 06
> > > 04 00 00 0f 84 b3 00 00 00 48 81 ff 02 04 00 00 0f 84 37 01 00 00
> > > 40 f6
> > > c7 01 0f 85 9c 00 00 00 <48> 8b 07 a8 01 0f 85 91 00 00 00 8b 47
> > > 34 85
> > > c0 0f 84 86 00 00 00
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RSP: 0000:ffffa83e4ed67cc8
> > > EFLAGS:
> > > 00010246
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RAX: 0000000000000042 RBX:
> > > ffffa83e4ed67e00 RCX: 000000000000146e
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RDX: ffffa83e4ed67d20 RSI:
> > > ffff94a9046316b0 RDI: 0000000000000042
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RBP: ffffa83e4ed67d20 R08:
> > > 000000000000146e R09: 0000000000dfd000
> > > Feb=C2=A0 7 17:19:33 localhost kernel: R10: 000000000000145f R11:
> > > ffff94978b85960c R12: ffff94a9046316b0
> > > Feb=C2=A0 7 17:19:33 localhost kernel: R13: 000000000000146e R14:
> > > ffff94a9046316b0 R15: ffff948f8bb1f000
> > > Feb=C2=A0 7 17:19:33 localhost kernel: FS:=C2=A0 00007fd68fcb9d40(000=
0)
> > > GS:ffff949dffd00000(0000) knlGS:0000000000000000
> > > Feb=C2=A0 7 17:19:33 localhost kernel: CS:=C2=A0 0010 DS: 0000 ES: 00=
00
> > > CR0:
> > > 0000000080050033
> > > Feb=C2=A0 7 17:19:33 localhost kernel: CR2: 0000000000000042 CR3:
> > > 00000001dc1be005 CR4: 00000000001706e0
> > > Feb=C2=A0 7 17:19:33 localhost kernel: Call Trace:
> > > Feb=C2=A0 7 17:19:33 localhost kernel: <TASK>
> > > Feb=C2=A0 7 17:19:33 localhost kernel: filemap_map_pages+0x9f/0x7b0
> > > Feb=C2=A0 7 17:19:33 localhost kernel: xfs_filemap_map_pages+0x41/0x6=
0
> > > [xfs]
> > > Feb=C2=A0 7 17:19:33 localhost kernel: do_fault+0x1bf/0x430
> > > Feb=C2=A0 7 17:19:33 localhost kernel: __handle_mm_fault+0x63d/0xe40
> > > Feb=C2=A0 7 17:19:33 localhost kernel: ? do_sigaction+0x11a/0x240
> > > Feb=C2=A0 7 17:19:33 localhost kernel: handle_mm_fault+0xdb/0x2d0
> > > Feb=C2=A0 7 17:19:33 localhost kernel: do_user_addr_fault+0x1cd/0x690
> > > Feb=C2=A0 7 17:19:33 localhost kernel: exc_page_fault+0x70/0x170
> > > Feb=C2=A0 7 17:19:33 localhost kernel: asm_exc_page_fault+0x22/0x30
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RIP: 0033:0x1666350
> > > Feb=C2=A0 7 17:19:33 localhost kernel: Code: Unable to access opcode
> > > bytes
> > > at 0x1666326.
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RSP: 002b:00007ffde7fa86d8
> > > EFLAGS:
> > > 00010212
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RAX: 0000000000000000 RBX:
> > > 00007ffde7fa8748 RCX: 0000000002ed4468
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RDX: 00006000000c4f50 RSI:
> > > 00007ffde7fa8748 RDI: 0000000000000012
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RBP: 0000000000000012 R08:
> > > 0000000000000001 R09: 0000000002f46860
> > > Feb=C2=A0 7 17:19:33 localhost kernel: R10: 00007fd69219cac0 R11:
> > > 00007fd69224e670 R12: 0000000000000000
> > > Feb=C2=A0 7 17:19:33 localhost kernel: R13: 00006000000c4f50 R14:
> > > 0000000002ed4470 R15: 00007fd693be0000
> > > Feb=C2=A0 7 17:19:33 localhost kernel: </TASK>
> > > Feb=C2=A0 7 17:19:33 localhost kernel: Modules linked in: xsk_diag
> > > veth tls
> > > xt_conntrack xt_MASQUERADE nf_conntrack_netlink xt_addrtype
> > > nft_compat
> > > br_netfilter bridge stp llc intel_rapl_msr dell_wmi iTCO_wdt
> > > dell_smbios intel_pmc_bxt iTCO_vendor_support dell_wmi_descriptor
> > > ledtrig_audio sparse_keymap video dcdbas intel_rapl_common
> > > sb_edac
> > > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> > > ipmi_ssif
> > > irqbypass rapl intel_cstate intel_uncore ipmi_si ipmi_devintf
> > > ipmi_msghandler nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
> > > nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> > > nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> > > rfkill
> > > overlay ip_set nf_tables nfnetlink qrtr acpi_power_meter mxm_wmi
> > > mei_me
> > > mei lpc_ich auth_rpcgss ip6_tables ip_tables sunrpc zram xfs
> > > crct10dif_pclmul crc32_pclmul nvme crc32c_intel polyval_clmulni
> > > polyval_generic ixgbe ghash_clmulni_intel nvme_core sha512_ssse3
> > > megaraid_sas tg3 mgag200 mdio nvme_common dca wmi scsi_dh_rdac
> > > scsi_dh_emc scsi_dh_alua
> > > Feb=C2=A0 7 17:19:33 localhost kernel: dm_multipath fuse
> > > Feb=C2=A0 7 17:19:33 localhost kernel: CR2: 0000000000000042
> > > Feb=C2=A0 7 17:19:33 localhost kernel: ---[ end trace 000000000000000=
0
> > > ]---
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RIP:
> > > 0010:next_uptodate_page+0x46/0x200
> > > Feb=C2=A0 7 17:19:33 localhost kernel: Code: 0f 84 3f 01 00 00 48 81
> > > ff 06
> > > 04 00 00 0f 84 b3 00 00 00 48 81 ff 02 04 00 00 0f 84 37 01 00 00
> > > 40 f6
> > > c7 01 0f 85 9c 00 00 00 <48> 8b 07 a8 01 0f 85 91 00 00 00 8b 47
> > > 34 85
> > > c0 0f 84 86 00 00 00
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RSP: 0000:ffffa83e4ed67cc8
> > > EFLAGS:
> > > 00010246
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RAX: 0000000000000042 RBX:
> > > ffffa83e4ed67e00 RCX: 000000000000146e
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RDX: ffffa83e4ed67d20 RSI:
> > > ffff94a9046316b0 RDI: 0000000000000042
> > > Feb=C2=A0 7 17:19:33 localhost kernel: RBP: ffffa83e4ed67d20 R08:
> > > 000000000000146e R09: 0000000000dfd000
> > > Feb=C2=A0 7 17:19:33 localhost kernel: R10: 000000000000145f R11:
> > > ffff94978b85960c R12: ffff94a9046316b0
> > > Feb=C2=A0 7 17:19:33 localhost kernel: R13: 000000000000146e R14:
> > > ffff94a9046316b0 R15: ffff948f8bb1f000
> > > Feb=C2=A0 7 17:19:33 localhost kernel: FS:=C2=A0 00007fd68fcb9d40(000=
0)
> > > GS:ffff949dffd00000(0000) knlGS:0000000000000000
> > >=20
> >=20

