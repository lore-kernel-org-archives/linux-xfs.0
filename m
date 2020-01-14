Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FBBC33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B576B2075B
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgANI61 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 03:58:27 -0500
Received: from mr011msb.fastweb.it ([85.18.95.108]:40514 "EHLO
        mr011msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgANI61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:58:27 -0500
Received-SPF: pass (mr011msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr011msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrvdejuddguddvfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhtefuvfghgfeupdcuqfgfvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhohfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeouggrrhhrihgtkhdrfihonhhgsehorhgrtghlvgdrtghomhequcfqtfevrffvpehrfhgtkedvvdenuggrrhhrihgtkhdrfihonhhgsehorhgrtghlvgdrtghomhdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr011msb.fastweb.it (5.8.208)
        id 5E19B4DB00328269; Tue, 14 Jan 2020 09:45:20 +0100
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id 00DEC265489;
        Tue, 14 Jan 2020 09:45:19 +0100 (CET)
Subject: Re: XFS reflink vs ThinLVM
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
 <20200113114356.midcgudwxpze3xfw@orion>
 <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
 <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
 <20200113180914.GI8247@magnolia>
From:   Gionatan Danti <g.danti@assyoma.it>
Organization: Assyoma s.r.l.
Message-ID: <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
Date:   Tue, 14 Jan 2020 09:45:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200113180914.GI8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13/01/20 19:09, Darrick J. Wong wrote:
> xfs_io -c 'bmap -c -e -l -p -v <whatever>' test.img

Ok, good to know. Thanks.

> If you are interested in online scrub, then I'd say yes because it's the
> secret sauce that gives online metadata checking most of its power.  I
> confess, I haven't done a lot of performance analysis of rmap lately,
> the metadata ops overhead might still be in the ~10% range.
> 
> The two issues preventing rmap from being turned on by default (at least
> in my head) are (1) scrub itself is still EXPERIMENTAL and (2) it's not
> 100% clear that online fsck is such a killer app that everyone will want
> it, since you always pay the performance overhead of enabling rmap
> regardless of whether you use xfs_scrub.

Well, I really think online scrub, when ready, will be a killer feature. 
So, for a "mere" 10% performance penalty, I would enable rbmap unless a 
concrete chance to expose some bug exists.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
