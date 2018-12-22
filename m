Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731907AbeLVAFA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Dec 2018 19:05:00 -0500
Date: Fri, 21 Dec 2018 19:04:58 -0500
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in
 iomap_page_create/release()"
Message-ID: <20181222000458.GH86645@sasha-vm>
References: <20181220122324.17082-1-david@fromorbit.com>
 <20181220122825.GA17138@kroah.com>
 <20181220205721.GD4205@dastard>
 <20181221074042.GA8633@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20181221074042.GA8633@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pjaroszynski@nvidia.com, william.kucharski@oracle.com, stable@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Fri, Dec 21, 2018 at 08:40:42AM +0100, Greg KH wrote:
>On Fri, Dec 21, 2018 at 07:57:21AM +1100, Dave Chinner wrote:
>> On Thu, Dec 20, 2018 at 01:28:25PM +0100, Greg KH wrote:
>> > On Thu, Dec 20, 2018 at 11:23:24PM +1100, Dave Chinner wrote:
>> > > From: Dave Chinner <dchinner@redhat.com>
>> > >
>> > > This reverts commit 61c6de667263184125d5ca75e894fcad632b0dd3.
>>
>> <snip>
>>
>> > <formletter>
>> >
>> > This is not the correct way to submit patches for inclusion in the
>> > stable kernel tree.  Please read:
>> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> > for how to do this properly.
>> >
>> > </formletter>
>>
>> This wasn't a stable kernel patch submission. This was to let the
>> stable kernel maintainers know that a commit that was submitted for
>> stable kernel inclusion (via a cc stable in the commit message) is
>> buggy and should not be backported. i.e. if you've already queued/
>> backported 61c6de6672 then you need to drop it from your trees.
>
>As the commit 61c6de667263 ("fs/iomap.c: get/put the page in
>iomap_page_create/release()") was tagged for a stable release (and is in
>4.19.11) it would be nice to also add the cc: stable in the revert.
>When you just blindly send it to the stable mailing list, we have no
>idea what to do with it, hence the automated form letter that was sent.
>
>Now that this is in Linus's tree, I'll dig out the revert and remember
>to queue it up for the next round of stable updates, thanks for letting
>us know.

I've queued the revert for 4.19.

--
Thanks,
Sasha
