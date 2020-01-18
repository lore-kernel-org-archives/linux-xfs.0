Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084ABC33CB1
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 11:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2EE224694
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 11:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgARLI6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 06:08:58 -0500
Received: from mr013msb.fastweb.it ([85.18.95.104]:46030 "EHLO
        mr013msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgARLI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 06:08:58 -0500
Received-SPF: pass (mr013msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr013msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedugedruddtgddvfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhtefuvfghgfeupdcuqfgfvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepvffugggtgfffhfhojghfkfigfgesthejjhdttdervdenucfhrhhomhepifhiohhnrghtrghnucffrghnthhiuceoghdruggrnhhtihesrghsshihohhmrgdrihhtqeenucffohhmrghinheprghsshihohhmrgdrihhtnecukfhppeelfedrieefrdehhedrheejnecurfgrrhgrmhephhgvlhhopegtvghrvghsrdgrshhshihomhgrrdhithdpihhnvghtpeelfedrieefrdehhedrheejpdhmrghilhhfrhhomhepoehgrdgurghnthhisegrshhshihomhgrrdhitheqpdhrtghpthhtohepoegurghrrhhitghkrdifohhnghesohhrrggtlhgvrdgtohhmqecuqfftvefrvfeprhhftgekvddvnegurghrrhhitghkrdifohhnghesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepoehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgqecuqfftvefrvfeprhhftgekvddvnehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr013msb.fastweb.it (5.8.208)
        id 5E19B49F007E1D1E; Sat, 18 Jan 2020 12:08:48 +0100
Received: by ceres.assyoma.it (Postfix, from userid 48)
        id 61AC1267FA8; Sat, 18 Jan 2020 12:08:48 +0100 (CET)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS reflink vs ThinLVM
X-PHP-Originating-Script: 0:rcube.php
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 18 Jan 2020 12:08:48 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org, g.danti@assyoma.it
Organization: Assyoma s.r.l.
In-Reply-To: <20200117234219.GM8257@magnolia>
References: <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
 <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
 <20200113180914.GI8247@magnolia>
 <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
 <9d8e8614-9ae1-30ee-f2b4-1e45b90b27f8@assyoma.it>
 <20200115163948.GF8257@magnolia>
 <761fcf8f9d68ee221a35d15c1a7120c5@assyoma.it>
 <e3dd598260d9f92c3b2c91cb81540e37@assyoma.it>
 <20200117234219.GM8257@magnolia>
Message-ID: <cc3d0819966d2d3f5b8512ed0f6b1de1@assyoma.it>
X-Sender: g.danti@assyoma.it
User-Agent: Roundcube Webmail/1.0.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 18-01-2020 00:42 Darrick J. Wong ha scritto:
> How many fragments, and how big of a sparse file?

A just installed CentOS 8 guest using a 20 GB sparse file vdisk had 
about 2000 fragments.

After running "fio --name=test --filename=test.img --rw=randwrite 
--size=4G" for about 30 mins, it ended with over 1M fragments/extents. 
At that point, reflinking that file took over 2 mins, and unlinking it 
about 4 mins.

I understand fio randwrite pattern is a worst case scenario; still, I 
think the results are interesting and telling for "aged" virtual 
machines.

As a side note, a just installed Win2019 guest backed with an 80 GB 
sparse file had about 18000 fragments.
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
