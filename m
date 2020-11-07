Return-Path: <SRS0=AdL6=EN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A552FC388F7
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Nov 2020 22:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D05C206B2
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Nov 2020 22:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgKGW4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 7 Nov 2020 17:56:19 -0500
Received: from mr013msb.fastweb.it ([85.18.95.104]:40455 "EHLO
        mr013msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKGW4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Nov 2020 17:56:18 -0500
Received-SPF: pass (mr013msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr013msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=plutone.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedujedrudduvddgtddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepggffhffvufgjfhgfkfigtgfgsehtjehjtddtredvnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuggftrfgrthhtvghrnhepvdffvedtueevleehudekffeileeuhfdvtdeigfeukefgvddvhfelhefgkeffgfdtnecuffhomhgrihhnpegrshhshihomhgrrdhithenucfkphepleefrdeifedrheehrdehjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehplhhuthhonhgvrdgrshhshihomhgrrdhithdpihhnvghtpeelfedrieefrdehhedrheejpdhmrghilhhfrhhomhepoehgrdgurghnthhisegrshhshihomhgrrdhitheqpdhrtghpthhtohepoegurghvihgusehfrhhomhhorhgsihhtrdgtohhmqecuqfftvefrvfeprhhftgekvddvnegurghvihgusehfrhhomhhorhgsihhtrdgtohhmpdhrtghpthhtohepoehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgqecuqfftvefrvfeprhhftgekvddvnehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from plutone.assyoma.it (93.63.55.57) by mr013msb.fastweb.it (5.8.208)
        id 5F4CF1900638D6A3; Sat, 7 Nov 2020 23:56:13 +0100
Received: from webmail.assyoma.it (localhost [IPv6:::1])
        by plutone.assyoma.it (Postfix) with ESMTPA id 89C79C01BC40;
        Sat,  7 Nov 2020 23:56:13 +0100 (CET)
MIME-Version: 1.0
Date:   Sat, 07 Nov 2020 23:56:13 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Recover preallocated space after a crash?
In-Reply-To: <20201107204747.GH7391@dread.disaster.area>
References: <274ec62926defe526850a4253d2b96a8@assyoma.it>
 <20201107204747.GH7391@dread.disaster.area>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <1e8b6ec2fe950a3320236af8e8353ea2@assyoma.it>
X-Sender: g.danti@assyoma.it
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 2020-11-07 21:47 Dave Chinner ha scritto:
> On Sat, Nov 07, 2020 at 08:55:50PM +0100, Gionatan Danti wrote:
>> Hi list,
>> it is my understanding that XFS can preallocate some "extra" space via
>> speculative EOF preallocation and speculative COW preallocation.
>> 
>> During normal system operation, that extra space is recovered after 
>> some
>> time. But what if system crashes? Can it be even recovered? If so, it 
>> is
>> done at mount time or via a (more invasive) fsck?
> 
> It will be done silently the next time the inode is cycled through
> memory via an open()/close() pair as specualtive prealloc is removed
> on the final close() of a file.
> 
> Alternatively, you can trigger reclaim on the current set of
> in-memory inodes by running:
> 
> # xfs_spaceman -c "prealloc -m 64k -s" /mnt
> 
> to remove speculative preallocations of more than 64k from all
> inodes that are in-memory and wait for the operation to complete.
> 
> You still need to bring the inodes into memory, so you can do this
> via find command that reads some inode metadata (e.g. find /mnt
> -ctime 2>&1 /dev/null). This means you don't need to actually
> open/close each inode in userspace - the filesystem will traversal
> all the in-memory inodes and clear the prealloc space itself.
> 
> Cheers,
> 
> Dave.

Hi Dave,
thanks so much for the clear answer.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
