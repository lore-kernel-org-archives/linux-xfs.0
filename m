Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1481C33CAD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 10:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3FE207E0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 10:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgAMK2n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 05:28:43 -0500
Received: from mr014msb.fastweb.it ([85.18.95.103]:47150 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgAMK2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 05:28:43 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 05:28:41 EST
Received-SPF: pass (mr014msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr014msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrvdejtddgudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepvffhufhokffffgggtgfgsehtjeertddtfeejnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithdpihhmghdrhhhofienucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr014msb.fastweb.it (5.8.208)
        id 5E19B471002027D8 for linux-xfs@vger.kernel.org; Mon, 13 Jan 2020 11:22:52 +0100
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id 118BA263DF4;
        Mon, 13 Jan 2020 11:22:52 +0100 (CET)
To:     linux-xfs@vger.kernel.org
From:   Gionatan Danti <g.danti@assyoma.it>
Subject: XFS reflink vs ThinLVM
Organization: Assyoma s.r.l.
Cc:     "'g.danti@assyoma.it'" <g.danti@assyoma.it>
Message-ID: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
Date:   Mon, 13 Jan 2020 11:22:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,
as RHEL/CentOS 8 finally ships with XFS reflink enabled, I was thinking 
on how to put that very useful feature to good use. Doing that, I 
noticed how there is a significant overlap between XFS CoW (via reflink) 
and dm-thin CoW (via LVM thin volumes).

I am fully aware that they are far from identical, both in use and 
scope: ThinLVM is used to create multiple volumes from a single pool, 
with volume-level atomic snapshot; on the other hand, XFS CoW works 
inside a single volume and with file-level atomic snapshot.

Still, in at least one use case they are quite similar: single-volume 
storage of virtual machine files, with vdisk-level snapshot. So lets say 
I have a single big volume for storing virtual disk image file, and 
using XFS reflink to take atomic, per file snapshot via a simple "cp 
--reflink vdisk.img vdisk_snap.img".

How do you feel about using reflink for such a purpose? Is the right 
tool for the job? Or do you think a "classic" approach with dmthin and 
lvm snapshot should be preferred? On top of my head, I can thin about 
the following pros and cons when using reflink vs thin lvm:

PRO:
- xfs reflink works at 4k granularity;
- significantly simpler setup and fs expansion, especially when staked 
devices (ie: vdo) are employed.

CONS:
- xfs reflink works at 4k granularity, leading to added fragmentation 
(albeit mitigated by speculative preallocation?);
- no filesystem-wide atomic snapshot (ie: various vdisk files are 
reflinked one-by-one, at small but different times).

Side note: I am aware of the fact that a snapshot taken without guest 
quiescing is akin to a crashed guest, but lets ignore that for the moment.

Am I missing something?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
