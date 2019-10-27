Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_SBL,URIBL_SBL_A autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7F4CA9EBC
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 18:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B08121D81
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 18:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfJ0SWZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 14:22:25 -0400
Received: from mr012msb.fastweb.it ([85.18.95.109]:53859 "EHLO
        mr012msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbfJ0SWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 14:22:24 -0400
Received-SPF: pass (mr012msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr012msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdduudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepvffugggtgfffhfhojghfkfigfgesthejjhdttdervdenucfhrhhomhepifhiohhnrghtrghnucffrghnthhiuceoghdruggrnhhtihesrghsshihohhmrgdrihhtqeenucffohhmrghinheprghsshihohhmrgdrihhtnecukfhppeelfedrieefrdehhedrheejnecurfgrrhgrmhephhgvlhhopegtvghrvghsrdgrshhshihomhgrrdhithdpihhnvghtpeelfedrieefrdehhedrheejpdhmrghilhhfrhhomhepoehgrdgurghnthhisegrshhshihomhgrrdhitheqpdhrtghpthhtohepoegurghvihgusehfrhhomhhorhgsihhtrdgtohhmqecuqfftvefrvfeprhhftgekvddvnegurghvihgusehfrhhomhhorhgsihhtrdgtohhmpdhrtghpthhtohepoehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgqecuqfftvefrvfeprhhftgekvddvnehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr012msb.fastweb.it (5.8.208)
        id 5DA9630000D7E599; Sun, 27 Oct 2019 19:09:28 +0100
Received: by ceres.assyoma.it (Postfix, from userid 48)
        id 2CE0325CCF7; Sun, 27 Oct 2019 19:09:28 +0100 (CET)
To:     Dave Chinner <david@fromorbit.com>
Subject: Re: Question about logbsize default value
X-PHP-Originating-Script: 0:rcube.php
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 27 Oct 2019 19:09:28 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org, g.danti@assyoma.it
Organization: Assyoma s.r.l.
In-Reply-To: <20191026215909.GK4614@dread.disaster.area>
References: <00242d70-1d8e-231d-7ba0-1594412714ad@assyoma.it>
 <20191024215027.GC4614@dread.disaster.area>
 <eb0ef021-27be-c0bd-5950-103cd8b04594@assyoma.it>
 <20191025233934.GI4614@dread.disaster.area>
 <51fef5c8e58db12a72b693680c2feaa5@assyoma.it>
 <20191026215909.GK4614@dread.disaster.area>
Message-ID: <f3a9ec5d118d241b32f5dd8b9ca1bde7@assyoma.it>
X-Sender: g.danti@assyoma.it
User-Agent: Roundcube Webmail/1.0.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 26-10-2019 23:59 Dave Chinner ha scritto:
> On Sat, Oct 26, 2019 at 11:54:02AM +0200, Gionatan Danti wrote:
>> Il 26-10-2019 01:39 Dave Chinner ha scritto:
>> > Again, it's a trade-off.
>> >
>> > 256kB iclogs mean that a crash can leave an unrecoverable 2MB hole
>> > in the journal, while 32kB iclogs means it's only 256kB.
>> 
>> Sure, but a crash will always cause the loss of unsynced data, 
>> especially
>> when using deferred logging and/or deferred allocation, right?
> 
> Yes, but there's a big difference between 2MB and 256KB, especially
> if it's a small filesystem (very common) and the log is only ~10MB
> in size.
> 
>> > 256kB iclogs mean 2MB of memory usage per filesystem, 32kB is only
>> > 256kB. We have users with hundreds of individual XFS filesystems
>> > mounted on single machines, and so 256kB iclogs is a lot of wasted
>> > memory...
>> 
>> Just wondering: 1000 filesystems with 256k logbsize would result in 2 
>> GB of
>> memory consumed by journal buffers. Is this considered too much memory 
>> for a
>> system managing 1000 filesystems? The pagecache write back memory
>> consumption on these systems (probably equipped with 10s GB of RAM) 
>> would
>> dwarfs any journal buffers, no?
> 
> Log buffers are static memory footprint. Page cache memory is
> dynamic and can be trimmed to nothing when there is memory pressure
> However, memory allocated to log buffers is pinned for the life
> of the mount, whether that filesystem is busy or not - the memory is
> not reclaimable.
> 
> THe 8 log buffers of 32kB each is a good trade-off between
> minimising memory footprint and maintaining performance over a wide
> range of storage and use cases. If that's still too much memory per
> filesystem, then the user can compromise on performance by reducing
> the number of logbufs. If performance is too slow, then the user can
> increase the memory footprint to improve performance.
> 
> The default values sit in the middle ground on both axis - enough
> logbufs and iclog size for decent performance but with a small
> enough memory footprint that dense or resource constrained
> installations are possible to deploy without needing any tweaking.
> 
> Cheers,
> 
> Dave.

It surely is reasonable.
Thank you for the clear explanation.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
