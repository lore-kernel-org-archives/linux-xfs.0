Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:46300 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbeE3MfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 08:35:16 -0400
Received: by mail-lf0-f65.google.com with SMTP id h9-v6so4027814lfc.13
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 05:35:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180416170329.GA5203@magnolia>
References: <20180414215937.GH5572@dastard> <20180414222407.GA15294@bombadil.infradead.org>
 <20180415072121.GA13601@infradead.org> <20180415111104.GB25513@bombadil.infradead.org>
 <20180415120426.GA10479@infradead.org> <20180415123427.GA11379@bombadil.infradead.org>
 <20180416085707.GB30363@infradead.org> <20180416111423.GA26022@bombadil.infradead.org>
 <20180416112353.GA22921@infradead.org> <20180416113139.GB26022@bombadil.infradead.org>
 <20180416170329.GA5203@magnolia>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Wed, 30 May 2018 18:05:13 +0530
Message-ID: <CAFqt6za9AUAbt7g7tY7iQ2SQtgGOUZ266aym1zrm9Z5PhBvvaw@mail.gmail.com>
Subject: Re: [PATCH] fs: xfs: Change return type to vm_fault_t
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Apr 16, 2018 at 10:33 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Apr 16, 2018 at 04:31:39AM -0700, Matthew Wilcox wrote:
>> On Mon, Apr 16, 2018 at 04:23:53AM -0700, Christoph Hellwig wrote:
>> > On Mon, Apr 16, 2018 at 04:14:23AM -0700, Matthew Wilcox wrote:
>> > > That's an unreasonable request.  It would (usually) require writing more
>> > > code to convert errnos into VM_FAULT returns.  And that code would get
>> > > precisely zero testing upstream because the next commit would come along
>> > > and delete it, replacing it with calls to common code.
>> >
>> > Well, introduce the damn common code first.  It does not require
>> > using the typedef in any way.
>>
>> Already done.
>
> I wondered "Yeah, why isn't this one big series?  Where are the rest of
> the patches to convert everything else?" and then realized the patch
> author landed the function pointer prototype changes in mm.h prior to
> 4.17-rc1 and is now playing scattershot catch-up across the tree...
>
> ...hm, the original mm patch wasn't cc'd to fsdevel either, so that's
> probably why I never heard of any of this until now.
>
> So, uh, why wasn't this whole series (all the mm changes and all the
> required fs changes) sent out for review prior to the merge window?
>
> I don't like "Hey we bitrotted your filesystem without telling you, now
> here's a patch to fix it..."  The code change looks ok, but now I'm
> going to schedule some time to go digging to see if there's anything
> else lurking beneath the surface here.
>
>> > In this current form of single patches:  NAK to anything I maintain
>> > or review.
>>
>> Yeah, we already have a plan for dealing with arsehole or MIA maintainers.
>> Fortunately, you're not actually the maintainer for XFS, so it'll be up
>> to Darrick whether to take it or not.
>
> I also dislike being pitted against the other XFS developers.
>

Thanks Darrick. This patch is now available in linux-next-20180530.
