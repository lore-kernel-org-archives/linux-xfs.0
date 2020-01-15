Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F5CC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 18:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9C2A2187F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 18:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAOSKo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 13:10:44 -0500
Received: from mr014msb.fastweb.it ([85.18.95.103]:60427 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgAOSKo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 13:10:44 -0500
Received-SPF: pass (mr014msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr014msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgddutddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefvufggtgfgfffhohgjfhfkgigfsehtjehjtddtredvnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqedprhgtphhtthhopeeouggrrhhrihgtkhdrfihonhhgsehorhgrtghlvgdrtghomhequcfqtfevrffvpehrfhgtkedvvdenuggrrhhrihgtkhdrfihonhhgsehorhgrtghlvgdrtghomhdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr014msb.fastweb.it (5.8.208)
        id 5E19B471004F8843; Wed, 15 Jan 2020 18:45:09 +0100
Received: by ceres.assyoma.it (Postfix, from userid 48)
        id 1C48E2664CD; Wed, 15 Jan 2020 18:45:09 +0100 (CET)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS reflink vs ThinLVM
X-PHP-Originating-Script: 0:rcube.php
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 Jan 2020 18:45:09 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org, g.danti@assyoma.it
Organization: Assyoma s.r.l.
In-Reply-To: <20200115163948.GF8257@magnolia>
References: <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
 <20200113114356.midcgudwxpze3xfw@orion>
 <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
 <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
 <20200113180914.GI8247@magnolia>
 <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
 <9d8e8614-9ae1-30ee-f2b4-1e45b90b27f8@assyoma.it>
 <20200115163948.GF8257@magnolia>
Message-ID: <761fcf8f9d68ee221a35d15c1a7120c5@assyoma.it>
X-Sender: g.danti@assyoma.it
User-Agent: Roundcube Webmail/1.0.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 15-01-2020 17:39 Darrick J. Wong ha scritto:
> extszinherit > 0 disables delayed allocation, which means that (in your
> case above) if you wrote 1G to a file (using the pagecache) you'd get
> 8192x 128K calls to the allocator instead of making a single 1G
> allocation during writeback.

Thanks for the valuable information, I did not know that specific 
interaction between extsize and delalloc.

> If you have a lot of memory (or a high vmm
> dirty ratio) then you want delalloc over extsize.  Most of the time you
> want delalloc, frankly.

Let me briefly describe the expected workload: thinly provisioned 
virtual image storage. The problem with "plain" sparse file (ie: without 
extsize hint) is that, after some time, the underlying vdisk file will 
be very fragmented: consecutive physical blocks will be assigned to very 
different logical blocks, leading to sub-par performance when reading 
back the whole file (eg: for backup purpose).

I can easily simulate a worst-case scenario with fio, issuing random 
write to a pre-created sparse file. While the random writes complete 
very fast (because they are more-or-less sequentially written inside the 
sparse file), reading back that file will have very low performance: 10 
MB/s vs 600+ MB/s for a preallocated file.

Using a 128k extsize brings sequential read to ~100 MB/s (which is 
reasonable on that old hardware), and a 16M extsize is in the range of 
500+ MB/s.

Given that use case, do you suggest sticking with delalloc or setting an 
appropriate extsize?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
