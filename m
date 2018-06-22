Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:37038 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934153AbeFVDT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 23:19:56 -0400
Received: by mail-ot0-f172.google.com with SMTP id 101-v6so5974796oth.4
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 20:19:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180621221911.GT19934@dastard>
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
 <20180619161819.GD21698@magnolia> <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
 <20180621191535.GI7508@wotan.suse.de> <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
 <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com> <20180621221911.GT19934@dastard>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 21 Jun 2018 21:19:54 -0600
Message-ID: <CAJCQCtSzsYSyCD2eEvdgpKJ8ZFShsJrV2FxKZ4bv=-S6gpx2fw@mail.gmail.com>
Subject: Re: Mounting xfs filesystem takes long time
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>, xfs list <linux-xfs@vger.kernel.org>

On Thu, Jun 21, 2018 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:

> The mkfs ratios are about as optimal as we can get for the
> information we have about the storage - growing by
> 10x (i.e.  increaseing the number of AGs by 10x) puts us at the
> outside edge of the acceptible filesystem performance and longevity
> charcteristics. Growing by 100x puts us way outside the window,
> and examples like this where we are taking about growing by 10000x
> is just way beyond anything the static AG layout architecture was
> ever intended to support....

OK that's useful information, thanks.

What about from the other direction; is it possible to make an XFS
file system too big, on an LVM thin volume?

For example a 1TB drive, and I'm scratching my head at mkfs.xfs time
and think maaaybe one day it could end up 25TB at the top end? So I
figure do mkfs.xfs on a virtual LV of 5TB now and that gives me a 5x
growfs if I really do hit 25TB one day. But for now, it's a 5TB XFS
file system on a 1TB drive. Is there any negative performance effect
if it turns out I never end up growing this file system (it lives
forever on a 1TB drive as a 5TB virtual volume and file system)?



-- 
Chris Murphy
