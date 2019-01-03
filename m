Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37241 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfACTMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 14:12:01 -0500
Received: by mail-oi1-f195.google.com with SMTP id y23so28533020oia.4
        for <linux-xfs@vger.kernel.org>; Thu, 03 Jan 2019 11:12:00 -0800 (PST)
MIME-Version: 1.0
References: <20190102211332.GL4205@dastard> <20190102212531.GK6310@bombadil.infradead.org>
 <20190102225005.GL6310@bombadil.infradead.org> <20190103000354.GM4205@dastard>
In-Reply-To: <20190103000354.GM4205@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Jan 2019 11:11:49 -0800
Message-ID: <CAPcyv4jTWyYLEn+NcmVObscB9hArdsfxNL0YSMrHi_QDCOEkfQ@mail.gmail.com>
Subject: Re: [BUG, TOT] xfs w/ dax failure in __follow_pte_pmd()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>

On Wed, Jan 2, 2019 at 4:04 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Jan 02, 2019 at 02:50:05PM -0800, Matthew Wilcox wrote:
> > On Wed, Jan 02, 2019 at 01:25:31PM -0800, Matthew Wilcox wrote:
> > > On Thu, Jan 03, 2019 at 08:13:32AM +1100, Dave Chinner wrote:
> > > > Hi folks,
> > > >
> > > > An overnight test run on a current TOT kernel failed generic/413
> > > > with the following dmesg output:
> > > >
> > > > [ 9487.276402] RIP: 0010:__follow_pte_pmd+0x22d/0x340
> > > > [ 9487.305065] Call Trace:
> > > > [ 9487.307310]  dax_entry_mkclean+0xbb/0x1f0
> > >
> > > We've only got one commit touching dax_entry_mkclean and it's Jerome's.
> > > Looking through ac46d4f3c43241ffa23d5bf36153a0830c0e02cc, I'd say
> > > it's missing a call to mmu_notifier_range_init().
> >
> > Could I persuade you to give this a try?
>
> Yup, that fixes it.
>
> And looking at the code, the dax mmu notifier code clearly wasn't
> tested. i.e. dax_entry_mkclean() is the *only* code that exercises
> the conditional range parameter code paths inside
> __follow_pte_pmd().  This means it wasn't tested before it was
> proposed for inclusion and since inclusion no-one using -akpm,
> linux-next or the current mainline TOT has done any filesystem DAX
> testing until I tripped over it.
>
> IOws, this is the second "this was never tested before it was merged
> into mainline" XFS regression that I've found in the last 3 weeks.
> Both commits have been merged through the -akpm tree, and that
> implies we currently have no significant filesystem QA coverage on
> changes being merged through this route. This seems like an area
> that needs significant improvement to me....

Yes, this is also part of a series I explicitly NAK'd [1] because
there are no upstream users for it. I didn't bother to test it because
I thought the NAK was sufficient.

Andrew, any reason to not revert the set? They provide no upstream
value and actively break DAX.

[1]: https://www.spinics.net/lists/linux-fsdevel/msg137309.html
