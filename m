Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33231 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753686AbeE3ThC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 15:37:02 -0400
Received: by mail-io0-f196.google.com with SMTP id o185-v6so23029245iod.0
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 12:37:02 -0700 (PDT)
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
References: <20180521144703.GA19303@redhat.com>
 <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
 <20180521150439.GA19379@redhat.com>
 <61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
 <20180521151817.GA19454@redhat.com>
 <d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
 <20180521160907.GA19553@redhat.com>
 <f9e3714c-b7c9-d5f6-4018-2a87dd5babb2@kernel.dk>
 <20180530133629.GC5157@redhat.com>
 <f654ad69-aa90-9580-4731-a05d0604f353@kernel.dk>
 <20180530193435.GC3487@kmo-pixel>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bda57417-4aa1-b22c-9973-76d039fcaa9e@kernel.dk>
Date: Wed, 30 May 2018 13:36:58 -0600
MIME-Version: 1.0
In-Reply-To: <20180530193435.GC3487@kmo-pixel>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On 5/30/18 1:34 PM, Kent Overstreet wrote:
> On Wed, May 30, 2018 at 12:55:48PM -0600, Jens Axboe wrote:
>> On 5/30/18 7:36 AM, Mike Snitzer wrote:
>>> So revisiting this patchset: are you inclined to take these changes (I
>>> assume yes)?  If so, what would you need in order to get them staged for
>>> 4.18?  I'll start with offering my review in reply to the DM patch.  I'd
>>> much prefer to see this level of change go in sooner rather than later.
>>
>> Yeah I'd like to take the changes, but we might have to wait for
>> 4.19 at this point. It'd certainly help to have the dm bits reviewed,
>> as they are some of the larger ones. The grunt of the others are mostly
>> trivial and smaller in scope.
> 
> I don't have a strong opinion on 4.18 vs. 4.19, but I'm available to do whatever
> fixups are needed if it'll help get them in faster.

Let's do 4.18, I'm getting ready to queue it up. Pinged a few btrfs folks to
get that part reviewed.

Note that I'll add a one liner description in the commit message for the
patches, as suggested by Mike. They are pretty barren, a little meat in
the body won't hurt.

-- 
Jens Axboe

