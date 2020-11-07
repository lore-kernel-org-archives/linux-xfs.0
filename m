Return-Path: <SRS0=AdL6=EN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519A9C388F7
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Nov 2020 20:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0207420885
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Nov 2020 20:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgKGUBF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 7 Nov 2020 15:01:05 -0500
Received: from mr013msb.fastweb.it ([85.18.95.104]:44770 "EHLO
        mr013msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgKGUBF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Nov 2020 15:01:05 -0500
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Nov 2020 15:01:04 EST
Received-SPF: pass (mr013msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr013msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=plutone.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddgudeffecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhtefuvfghgfeupdcuqfgfvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeggfffhvffufgfkgigtgfesthejjhdttdervdenucfhrhhomhepifhiohhnrghtrghnucffrghnthhiuceoghdruggrnhhtihesrghsshihohhmrgdrihhtqeenucggtffrrghtthgvrhhnpeeludehfeejtdevgffhfeehfeeufeegkeetfeejveevffevvddvheevjeegtdevveenucffohhmrghinheprghsshihohhmrgdrihhtnecukfhppeelfedrieefrdehhedrheejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghlohepphhluhhtohhnvgdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqedprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from plutone.assyoma.it (93.63.55.57) by mr013msb.fastweb.it (5.8.208)
        id 5F4CF1900635F024 for linux-xfs@vger.kernel.org; Sat, 7 Nov 2020 20:55:50 +0100
Received: from webmail.assyoma.it (localhost [IPv6:::1])
        by plutone.assyoma.it (Postfix) with ESMTPA id 39BFCD4FAC0
        for <linux-xfs@vger.kernel.org>; Sat,  7 Nov 2020 20:55:50 +0100 (CET)
MIME-Version: 1.0
Date:   Sat, 07 Nov 2020 20:55:50 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
To:     linux-xfs@vger.kernel.org
Subject: Recover preallocated space after a crash?
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <274ec62926defe526850a4253d2b96a8@assyoma.it>
X-Sender: g.danti@assyoma.it
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi list,
it is my understanding that XFS can preallocate some "extra" space via 
speculative EOF preallocation and speculative COW preallocation.

During normal system operation, that extra space is recovered after some 
time. But what if system crashes? Can it be even recovered? If so, it is 
done at mount time or via a (more invasive) fsck?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
