Return-Path: <SRS0=5eVt=3I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4D5C33CB1
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 08:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 737B520730
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 08:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgASIpo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jan 2020 03:45:44 -0500
Received: from mr013msb.fastweb.it ([85.18.95.104]:60373 "EHLO
        mr013msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgASIpo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jan 2020 03:45:44 -0500
Received-SPF: pass (mr013msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr013msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedugedruddvgddvjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhtefuvfghgfeupdcuqfgfvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepvffugggtgfffhfhojghfkfigfgesthejjhdttdervdenucfhrhhomhepifhiohhnrghtrghnucffrghnthhiuceoghdruggrnhhtihesrghsshihohhmrgdrihhtqeenucffohhmrghinheprghsshihohhmrgdrihhtnecukfhppeelfedrieefrdehhedrheejnecurfgrrhgrmhephhgvlhhopegtvghrvghsrdgrshhshihomhgrrdhithdpihhnvghtpeelfedrieefrdehhedrheejpdhmrghilhhfrhhomhepoehgrdgurghnthhisegrshhshihomhgrrdhitheqpdhrtghpthhtohepoegurghrrhhitghkrdifohhnghesohhrrggtlhgvrdgtohhmqecuqfftvefrvfeprhhftgekvddvnegurghrrhhitghkrdifohhnghesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepoehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgqecuqfftvefrvfeprhhftgekvddvnehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr013msb.fastweb.it (5.8.208)
        id 5E19B49F009205B2; Sun, 19 Jan 2020 09:45:34 +0100
Received: by ceres.assyoma.it (Postfix, from userid 48)
        id 0E7C8268237; Sun, 19 Jan 2020 09:45:34 +0100 (CET)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS reflink vs ThinLVM
X-PHP-Originating-Script: 0:rcube.php
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Jan 2020 09:45:34 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org, g.danti@assyoma.it
Organization: Assyoma s.r.l.
In-Reply-To: <20200118230631.GX8247@magnolia>
References: <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
 <20200113180914.GI8247@magnolia>
 <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
 <9d8e8614-9ae1-30ee-f2b4-1e45b90b27f8@assyoma.it>
 <20200115163948.GF8257@magnolia>
 <761fcf8f9d68ee221a35d15c1a7120c5@assyoma.it>
 <e3dd598260d9f92c3b2c91cb81540e37@assyoma.it>
 <20200117234219.GM8257@magnolia>
 <cc3d0819966d2d3f5b8512ed0f6b1de1@assyoma.it>
 <20200118230631.GX8247@magnolia>
Message-ID: <9ca7a7f18ef7fe2e7c32ea6a6cd4ef35@assyoma.it>
X-Sender: g.danti@assyoma.it
User-Agent: Roundcube Webmail/1.0.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 19-01-2020 00:06 Darrick J. Wong ha scritto:
> 4GB / 1M extents == 4096, which is probably the fs blocksize :)

Yes, it did the same observation: due to random allocation, the 
underlying vdisk had block-sized extents.

> I wonder, do you get different results if you set an extent size hint
> on the dir before running fio?

Yes: setting extsize at 128K strongly reduces the amount of allocated 
extents (eg: 4M / 128K = 32K extents). A similar results can be obtained 
tapping in cowextsize, by cp --reflink the original file. Any subsequent 
4K write inside the guest will cause a 128K CoW allocation (with default 
setting) on the backing file.

However, while *much* better, it is my understanding that XFS reflink is 
a variable-length process: as any extents had to be scanned/reflinked, 
the reflink time is not constant. Meanwhile it is impossible to 
read/write from the reflinked file. Am I right?

On the other side thinlvm snapshots, operating on block level, are a 
(more-or-less) constant-time operation, causing much less disruption in 
the normal IO flow of the guest volumes.

I don't absolutely want to lessen reflink usefulnes; rather, it is an 
extremely useful feature which can be put to very good use.

> I forgot(?) to mention that if you're mostly dealing with sparse VM
> images then you might as well set a extent size hint and forego delayed
> allocation because it won't help you much.

This was my conclusion as well.
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
