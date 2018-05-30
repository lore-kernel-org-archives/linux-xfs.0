Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35786 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbeE3LDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 07:03:02 -0400
Received: by mail-it0-f65.google.com with SMTP id q72-v6so22869108itc.0
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 04:03:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8a9e048b-f60c-90bc-6884-e2fa6eca2c28@redhat.com>
References: <20180523144357.18985-1-hch@lst.de> <20180523144357.18985-12-hch@lst.de>
 <20180530055033.GZ30110@magnolia> <bc621d7c-f1a6-14c2-663f-57ded16811fa@redhat.com>
 <20180530095911.GB31068@lst.de> <e14b3cfb-73ca-e712-e1e9-4ceabc8c7b6d@redhat.com>
 <20180530101003.GA31419@lst.de> <8a9e048b-f60c-90bc-6884-e2fa6eca2c28@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 30 May 2018 13:03:00 +0200
Message-ID: <CAHc6FU7We19b5m2eXq2HKN=4szM+mgfyv6COMZzjAdxRyj0SKg@mail.gmail.com>
Subject: Re: [Cluster-devel] [PATCH 11/34] iomap: move IOMAP_F_BOUNDARY to gfs2
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-mm@kvack.org

On 30 May 2018 at 12:12, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
> On 30/05/18 11:10, Christoph Hellwig wrote:
>>
>> On Wed, May 30, 2018 at 11:02:08AM +0100, Steven Whitehouse wrote:
>>>
>>> In that case,  maybe it would be simpler to drop it for GFS2. Unless we
>>> are getting a lot of benefit from it, then we should probably just follow
>>> the generic pattern here. Eventually we'll move everything to iomap, so
>>> that the bh mapping interface will be gone. That implies that we might be
>>> able to drop it now, to avoid this complication during the conversion.
>>>
>>> Andreas, do you see any issues with that?

We're not handling reads through iomap yet, so I'd be happier with
keeping that flag in one form or the other until we get there. This
will go away eventually anyway.

>> I suspect it actually is doing the wrong thing today.  It certainly
>> does for SSDs, and it probably doesn't do a useful thing for modern
>> disks with intelligent caches either.
>
>
> Yes, agreed that it makes no sense for SSDs,

Thanks,
Andreas
