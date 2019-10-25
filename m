Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,URIBL_SBL,URIBL_SBL_A,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F319CCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 07:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF1BD206DD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 07:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405856AbfJYHXX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 03:23:23 -0400
Received: from mr012msb.fastweb.it ([85.18.95.109]:34313 "EHLO
        mr012msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391415AbfJYHXX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 03:23:23 -0400
Received-SPF: pass (mr012msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr012msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrledvgdduudehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvfhfhohfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeouggrvhhiugesfhhrohhmohhrsghithdrtghomhequcfqtfevrffvpehrfhgtkedvvdenuggrvhhiugesfhhrohhmohhrsghithdrtghomhdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr012msb.fastweb.it (5.8.208)
        id 5DA963000099DB2A; Fri, 25 Oct 2019 09:10:34 +0200
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id BF3D0258087;
        Fri, 25 Oct 2019 09:10:33 +0200 (CEST)
Subject: Re: Question about logbsize default value
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, g.danti@assyoma.it
References: <00242d70-1d8e-231d-7ba0-1594412714ad@assyoma.it>
 <20191024215027.GC4614@dread.disaster.area>
From:   Gionatan Danti <g.danti@assyoma.it>
Organization: Assyoma s.r.l.
Message-ID: <eb0ef021-27be-c0bd-5950-103cd8b04594@assyoma.it>
Date:   Fri, 25 Oct 2019 09:10:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024215027.GC4614@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24/10/19 23:50, Dave Chinner wrote:
> On Wed, Oct 23, 2019 at 11:40:33AM +0200, Gionatan Danti wrote:
> Defaults are for best compatibility and general behaviour, not
> best performance. A log stripe unit of 32kB allows the user to
> configure a logbsize appropriate for their workload, as it supports
> logbsize of 32kB, 64kB, 128kB and 256kB. If we chose 256kB as the
> default log stripe unit, then you have no opportunity to set the
> logbsize appropriately for your workload.
> 
> remember, LSU determines how much padding is added to every non-full
> log write - 32kB pads out ot 32kB, 256kB pads out to 256kB. Hence if
> you have a workload that frequnetly writes non-full iclogs (e.g.
> regular fsyncs) then a small LSU results in much better performance
> as there is less padding that needs to be initialised and the IOs
> are much smaller.
> 
> Hence for the general case (i.e. what the defaults are aimed at), a
> small LSU is a much better choice. you can still use a large
> logbsize mount option and it will perform identically to a large LSU
> filesystem on full iclog workloads (like the above fsmark workload
> that doesn't use fsync). However, a small LSU is likely to perform
> better over a wider range of workloads and storage than a large LSU,
> and so small LSU is a better choice for the default....

Hi Dave, thank you for your explanation. The observed behavior of a 
large LSU surely matches what you described - less-than-optimal fsync perf.

That said, I was wondering why *logbsize* (rather than LSU) has a low 
default of 32k (or, better, its default is to match LSU size). If I 
understand it correctly, a large logbsize (eg: 256k) on top of a small 
LSU (32k) would give high performance on both full-log-writes and 
partial-log-writes (eg: frequent fsync).

Is my understanding correct? If you, do you suggest to always set 
logbsize to the maximum supported value?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
