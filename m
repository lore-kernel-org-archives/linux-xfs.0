Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38869 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753156AbeEUPSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 11:18:39 -0400
Received: by mail-io0-f195.google.com with SMTP id z4-v6so14730668iof.5
        for <linux-xfs@vger.kernel.org>; Mon, 21 May 2018 08:18:38 -0700 (PDT)
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180521140348.GA19069@redhat.com>
 <686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
 <20180521151251.GX6649@twin.jikos.cz>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <87471185-1f64-2002-a7c8-f584ea6827a5@kernel.dk>
Date: Mon, 21 May 2018 09:18:36 -0600
MIME-Version: 1.0
In-Reply-To: <20180521151251.GX6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dsterba@suse.cz, Mike Snitzer <snitzer@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On 5/21/18 9:12 AM, David Sterba wrote:
> On Mon, May 21, 2018 at 08:19:58AM -0600, Jens Axboe wrote:
>> On 5/21/18 8:03 AM, Mike Snitzer wrote:
>>> On Sun, May 20 2018 at  6:25pm -0400,
>>> Kent Overstreet <kent.overstreet@gmail.com> wrote:
>>>
>>>> Jens - this series does the rest of the conversions that Christoph wanted, and
>>>> drops bioset_create().
>>>>
>>>> Only lightly tested, but the changes are pretty mechanical. Based on your
>>>> for-next tree.
>>>
>>> By switching 'mempool_t *' to 'mempool_t' and 'bio_set *' to 'bio_set'
>>> you've altered the alignment of members in data structures.  So I'll
>>> need to audit all the data structures you've modified in DM.
>>>
>>> Could we get the backstory on _why_ you're making this change?
>>> Would go a long way to helping me appreciate why this is a good use of
>>> anyone's time.
>>
>> Yeah, it's in the first series, it gets rid of a pointer indirection.
> 
> This should to be also mentioned the changelog of each patch. There are
> 12 subsystems changed, this could be about 10 maintainers and I guess
> everybody has the same question why the change is made.

Agree, the justification should be in this series as well, of course.
Kent, might not be a bad idea to resend with a more descriptive
cover letter.

-- 
Jens Axboe

