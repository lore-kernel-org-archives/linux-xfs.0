Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B7FC33CA9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 16:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C664821569
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 16:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgAMQZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 11:25:58 -0500
Received: from mr012msb.fastweb.it ([85.18.95.109]:56786 "EHLO
        mr012msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbgAMQZ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 11:25:58 -0500
Received-SPF: pass (mr012msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr012msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrvdejtddgkeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvfhfhohfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithdpshhpihhnihgtshdrnhgvthenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeeolhhishhtshestgholhhorhhrvghmvgguihgvshdrtghomhequcfqtfevrffvpehrfhgtkedvvdenlhhishhtshestgholhhorhhrvghmvgguihgvshdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr012msb.fastweb.it (5.8.208)
        id 5E19B4C200263D6C; Mon, 13 Jan 2020 17:25:49 +0100
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id BD97E26499A;
        Mon, 13 Jan 2020 17:25:48 +0100 (CET)
Subject: Re: XFS reflink vs ThinLVM
To:     Chris Murphy <lists@colorremedies.com>,
        xfs list <linux-xfs@vger.kernel.org>
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <CAJCQCtShw=TTqfnxWpEROXfUgs2TtAOnLzPdi4LpOo9aYsN-gg@mail.gmail.com>
Cc:     "'g.danti@assyoma.it'" <g.danti@assyoma.it>
From:   Gionatan Danti <g.danti@assyoma.it>
Organization: Assyoma s.r.l.
Message-ID: <6882c726-2ac0-2d1e-155f-6e9a65009a45@assyoma.it>
Date:   Mon, 13 Jan 2020 17:25:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtShw=TTqfnxWpEROXfUgs2TtAOnLzPdi4LpOo9aYsN-gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13/01/20 17:14, Chris Murphy wrote:
> Is --reflink on XFS atomic? In particular for a VM file that's being
> used, that's possibly quite a lot of metadata on disk and in-flight in
> the host and in the guest.
> 
> I ask because I'm not certain --reflink copies on Btrfs are atomic,
> I'll have to ask over there too. Whereas btrfs subvolume snapshots are
> considered atomic.

Hi, I did that question some time ago and, based on what I read here 
[1], it *should* be atomic.

Feel free to correct me, anyway.

[1] https://www.spinics.net/lists/linux-xfs/msg15969.html

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
